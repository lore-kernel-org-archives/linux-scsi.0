From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: add batches discard support
Date: Thu, 17 Sep 2009 12:25:40 -0400
Message-ID: <20090917163105.866689916@bombadil.infradead.org>
References: <20090917162536.815743395@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbZIQQbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 12:31:03 -0400
Content-Disposition: inline; filename=xfs-add-trim-support-2
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, matthew@wil.cx, dwmw2@infradead.org
Cc: linux-scsi@vger.kernel.org

Add support for discarding all currently unused space by an ioctl.  Only
intended as demonstration and not for merging.

Use the following small tool to exercise it:


#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/ioctl.h>

#define XFS_IOC_TRIM                 _IOR ('X', 126, uint32_t)


int main(int argc, char **argv)
{
	int minsize = 4096;
	int fd;

	if (argc != 2) {
		fprintf(stderr, "usage: %s mountpoint\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (ioctl(fd, XFS_IOC_TRIM, &minsize)) {
		if (errno == EOPNOTSUPP)
			fprintf(stderr, "TRIM not supported\n");
		else
			perror("XFS_IOC_TRIM");
		return 1;
	}

	return 0;
}


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-08-29 15:53:27.319844716 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2009-08-29 16:51:56.271867967 -0300
@@ -1274,6 +1274,31 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_trim(
+	struct xfs_mount	*mp,
+	__uint32_t		*argp)
+{
+	xfs_agnumber_t		agno;
+	int			error = 0;
+	__uint32_t		minlen;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (get_user(minlen, argp))
+		return -EFAULT;
+
+	down_read(&mp->m_peraglock);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = -xfs_trim_extents(mp, agno, minlen);
+		if (error)
+			break;
+	}
+	up_read(&mp->m_peraglock);
+
+	return error;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1523,6 +1548,9 @@ xfs_file_ioctl(
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_TRIM:
+		return xfs_ioc_trim(mp, arg);
+
 	default:
 		return -ENOTTY;
 	}
Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c	2009-08-29 15:53:27.355845733 -0300
+++ linux-2.6/fs/xfs/xfs_alloc.c	2009-08-29 16:59:20.451343922 -0300
@@ -2609,6 +2609,96 @@ error0:
 	return error;
 }
 
+STATIC int
+xfs_trim_extent(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen)
+{
+	xfs_daddr_t		blkno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+	sector_t		nblks = XFS_FSB_TO_BB(mp, flen);
+	int			error;
+
+	xfs_fs_cmn_err(CE_NOTE, mp, "discarding sectors [0x%llx-0x%llx]",
+			blkno, nblks);
+
+	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, blkno, nblks,
+				      GFP_NOFS, DISCARD_FL_WAIT);
+	if (error && error != EOPNOTSUPP)
+		xfs_fs_cmn_err(CE_NOTE, mp, "discard failed, error %d", error);
+	return error;
+}
+
+/*
+ * Notify the underlying block device about our free extent map.
+ *
+ * This walks all free extents above a minimum threshold and notifies the
+ * underlying device that these blocks are unused.  That information is
+ * useful for SSDs or thinly provisioned storage in high end arrays or
+ * virtualization scenarios.
+ */
+int
+xfs_trim_extents(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		minlen)	/* minimum extent size to bother */
+{
+	struct xfs_btree_cur	*cur;	/* cursor for the by-block btree */
+	struct xfs_buf		*agbp;	/* AGF buffer pointer */
+	xfs_agblock_t		bno;	/* block the for next search */
+	xfs_agblock_t		fbno;	/* start block of found extent */
+	xfs_extlen_t		flen;	/* length of found extent */
+	int			error;
+	int			i;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	bno = 0;
+	for (;;) {
+		cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
+					      XFS_BTNUM_BNO);
+
+		error = xfs_alloc_lookup_ge(cur, bno, minlen, &i);
+		if (error)
+			goto error0;
+		if (!i) {
+			/*
+			 * No more free extents found: done.
+			 */
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			break;
+		}
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/*
+		 * Pass if the freespace extent isn't long enough to bother.
+		 */
+		if (flen >= minlen) {
+			error = xfs_trim_extent(mp, agno, fbno, flen);
+			if (error) {
+				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+				break;
+			}
+		}
+
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		bno = fbno + flen;
+	}
+
+out:
+	xfs_buf_relse(agbp);
+	return error;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	goto out;
+}
 
 /*
  * AG Busy list management
Index: linux-2.6/fs/xfs/xfs_alloc.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.h	2009-08-29 15:53:27.371844485 -0300
+++ linux-2.6/fs/xfs/xfs_alloc.h	2009-08-29 16:51:56.271867967 -0300
@@ -215,4 +215,7 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len);	/* length of extent */
 
+int xfs_trim_extents(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_extlen_t minlen);
+
 #endif	/* __XFS_ALLOC_H__ */
Index: linux-2.6/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fs.h	2009-08-29 15:53:27.391844445 -0300
+++ linux-2.6/fs/xfs/xfs_fs.h	2009-08-29 16:51:56.279865211 -0300
@@ -475,6 +475,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_TRIM		     _IOR ('X', 126, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-29 15:53:27.339845024 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-29 16:51:56.283864672 -0300
@@ -563,6 +563,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
+	case XFS_IOC_TRIM:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */


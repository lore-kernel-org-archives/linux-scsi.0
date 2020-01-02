Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EE9C3276C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 14:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34652072C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 14:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgABO6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 09:58:03 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:57085 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgABO6C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 09:58:02 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MLzSD-1j4yPT0dAv-00Hze6; Thu, 02 Jan 2020 15:57:46 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/22] compat: scsi: sg: fix v3 compat read/write interface
Date:   Thu,  2 Jan 2020 15:55:21 +0100
Message-Id: <20200102145552.1853992-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20200102145552.1853992-1-arnd@arndb.de>
References: <20200102145552.1853992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:nRc504jMOm3JteF2RHJQED6rMExyEXomIbEfWluQRtfGedaueYQ
 HSnicqYeOwDMEjGgqcf4j08q/sMz5sHGGLthM74HFeHngEPEkorJ45QatkmReK5HEnYGg0Q
 oLtQoQ+Cf1LpV37J0Pz07NhxUCOLR9IJXxJ2yqt8zUvjH6ItrQ9pvGsmV0x6jLpTq1PxO9/
 ufsyhI+t4Svq5bNIPe5gg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BnXOhNwbfkU=:G4tQDXF/WQu5mAC+Qjokpr
 UzEnwTBWXbsWHaLla/qdLs2mW5qNgZFwTiUDd5DGbBe2SricT8IdiLgWGayPiowyVZtcGJO/P
 B6taIxfgDh2HALD87S/IQmx4wUXwYB1G2D74gIpPEfxtmCHHZ729sfiWkGsJ0hF+VTpRZwLz3
 brfDXU+c7fPpl5WV8D/9dt1WEGMraFDU1geUYc+AtvT4hrluVjuHlrkKNgZzbOc+0+p0WNL+z
 K0l2aGuYpsEjy13CBPGhTjb3csc88TfTvTBoUANZ4/fXBArGyxir/jD59hg2kjLX6t7hLuaw8
 qZi5DT3kG1FVW4VsbQa1noXXXr4pgEd/iVqU4lFSOeqfLhbZOnjkj4+7q/toElEx5/QoG6woP
 AZ9Fe8xbsqoeew7RyIMyhyHVXujjooBHbqe+MzgR6kKtVt0GIyk7V8LSliYgOhlWBhzEsNI9Y
 FdMd/eMbUjQCyCISrCrtTZqD2lX1Bh5LDLrosiISU0xar6BJe1iQgjUnhKidcO2sqw3KOxd0b
 h3dXVxLFB3qm4UZ0nZRaVCQAA6rrJw76q9BMg5EeccPRRWz9zB0B/6y8V7izQJdVqmRdTnE13
 aLa4tQxm3nxcjMcHlJ90A8hQBoW5YQnbBN/z23+CSluU7B9fm0RusOc4zrQvUeUmAhIhgq6Ea
 fLiKLXSx9zXlxZfL8xm4lkePrfln4NDwecxDAka5J9x5vgPcH7qnFZ0hSnJTz9dwmOzz3zjRa
 nQ42O1hnRr37jL6KnlRFoiyyYbFOQxVShu7NJ7XGnDqCaoBek9uOp3bXYRMFsjmp0216Q4A2R
 vHWzGQAk4Oh06U6wzVfXf+fcOV4Yy7UZkWEIUUHWrSozyHsatqTsxDaIsvOkDKre1ioI3FqbN
 ZTQ6UcJF3QsKHHwZgbRQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the v5.4 merge window, a cleanup patch from Al Viro conflicted
with my rework of the compat handling for sg.c read(). Linus Torvalds
did a correct merge but pointed out that the resulting code is still
unsatisfactory.

I later noticed that the sg_new_read() function still gets the compat
mode wrong, when the 'count' argument is large enough to pass a
compat_sg_io_hdr object, but not a nativ sg_io_hdr.

To address both of these, move the definition of compat_sg_io_hdr
into a scsi/sg.h to make it visible to sg.c and rewrite the logic
for reading req_pack_id as well as the size check to a simpler
version that gets the expected results.

Fixes: c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t")
Fixes: 98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/scsi_ioctl.c |  29 +----------
 drivers/scsi/sg.c  | 126 +++++++++++++++++++++------------------------
 include/scsi/sg.h  |  30 +++++++++++
 3 files changed, 90 insertions(+), 95 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 650bade5ea5a..b61dbf4d8443 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -20,6 +20,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/sg.h>
 
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
@@ -550,34 +551,6 @@ static inline int blk_send_start_stop(struct request_queue *q,
 	return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);
 }
 
-#ifdef CONFIG_COMPAT
-struct compat_sg_io_hdr {
-	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
-	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
-	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
-	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
-	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
-	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
-	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
-						or scatter gather list */
-	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
-	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
-	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
-	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
-	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
-	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
-	unsigned char status;		/* [o] scsi status */
-	unsigned char masked_status;	/* [o] shifted, masked scsi status */
-	unsigned char msg_status;	/* [o] messaging level data (optional) */
-	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
-	unsigned short host_status;	/* [o] errors from host adapter */
-	unsigned short driver_status;	/* [o] errors from software driver */
-	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
-	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
-	compat_uint_t info;		/* [o] auxiliary information */
-};
-#endif
-
 int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
 {
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 160748ad9c0f..eace8886d95a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -405,6 +405,38 @@ sg_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
+{
+	struct sg_header __user *old_hdr = buf;
+	int reply_len;
+
+	if (count >= SZ_SG_HEADER) {
+		/* negative reply_len means v3 format, otherwise v1/v2 */
+		if (get_user(reply_len, &old_hdr->reply_len))
+			return -EFAULT;
+
+		if (reply_len >= 0)
+			return get_user(*pack_id, &old_hdr->pack_id);
+
+		if (in_compat_syscall() &&
+		    count >= sizeof(struct compat_sg_io_hdr)) {
+			struct compat_sg_io_hdr __user *hp = buf;
+
+			return get_user(*pack_id, &hp->pack_id);
+		}
+
+		if (count >= sizeof(struct sg_io_hdr)) {
+			struct sg_io_hdr __user *hp = buf;
+
+			return get_user(*pack_id, &hp->pack_id);
+		}
+	}
+
+	/* no valid header was passed, so ignore the pack_id */
+	*pack_id = -1;
+	return 0;
+}
+
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 {
@@ -413,8 +445,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	Sg_request *srp;
 	int req_pack_id = -1;
 	sg_io_hdr_t *hp;
-	struct sg_header *old_hdr = NULL;
-	int retval = 0;
+	struct sg_header *old_hdr;
+	int retval;
 
 	/*
 	 * This could cause a response to be stranded. Close the associated
@@ -429,79 +461,34 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_read: count=%d\n", (int) count));
 
-	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		old_hdr = memdup_user(buf, SZ_SG_HEADER);
-		if (IS_ERR(old_hdr))
-			return PTR_ERR(old_hdr);
-		if (old_hdr->reply_len < 0) {
-			if (count >= SZ_SG_IO_HDR) {
-				/*
-				 * This is stupid.
-				 *
-				 * We're copying the whole sg_io_hdr_t from user
-				 * space just to get the 'pack_id' field. But the
-				 * field is at different offsets for the compat
-				 * case, so we'll use "get_sg_io_hdr()" to copy
-				 * the whole thing and convert it.
-				 *
-				 * We could do something like just calculating the
-				 * offset based of 'in_compat_syscall()', but the
-				 * 'compat_sg_io_hdr' definition is in the wrong
-				 * place for that.
-				 */
-				sg_io_hdr_t *new_hdr;
-				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
-				if (!new_hdr) {
-					retval = -ENOMEM;
-					goto free_old_hdr;
-				}
-				retval = get_sg_io_hdr(new_hdr, buf);
-				req_pack_id = new_hdr->pack_id;
-				kfree(new_hdr);
-				if (retval) {
-					retval = -EFAULT;
-					goto free_old_hdr;
-				}
-			}
-		} else
-			req_pack_id = old_hdr->pack_id;
-	}
+	if (sfp->force_packid)
+		retval = get_sg_io_pack_id(&req_pack_id, buf, count);
+	if (retval)
+		return retval;
+
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (filp->f_flags & O_NONBLOCK) {
-			retval = -EAGAIN;
-			goto free_old_hdr;
-		}
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
 		retval = wait_event_interruptible(sfp->read_wait,
 			(atomic_read(&sdp->detaching) ||
 			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (retval) {
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		if (retval)
 			/* -ERESTARTSYS as signal hit process */
-			goto free_old_hdr;
-		}
-	}
-	if (srp->header.interface_id != '\0') {
-		retval = sg_new_read(sfp, buf, count, srp);
-		goto free_old_hdr;
+			return retval;
 	}
+	if (srp->header.interface_id != '\0')
+		return sg_new_read(sfp, buf, count, srp);
 
 	hp = &srp->header;
-	if (old_hdr == NULL) {
-		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
-		if (! old_hdr) {
-			retval = -ENOMEM;
-			goto free_old_hdr;
-		}
-	}
-	memset(old_hdr, 0, SZ_SG_HEADER);
+	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
+	if (!old_hdr)
+		return -ENOMEM;
+
 	old_hdr->reply_len = (int) hp->timeout;
 	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
 	old_hdr->pack_id = hp->pack_id;
@@ -575,7 +562,12 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 	int err = 0, err2;
 	int len;
 
-	if (count < SZ_SG_IO_HDR) {
+	if (in_compat_syscall()) {
+		if (count < sizeof(struct compat_sg_io_hdr)) {
+			err = -EINVAL;
+			goto err_out;
+		}
+	} else if (count < SZ_SG_IO_HDR) {
 		err = -EINVAL;
 		goto err_out;
 	}
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index f91bcca604e4..29c7ad04d2e2 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -68,6 +68,36 @@ typedef struct sg_io_hdr
     unsigned int info;          /* [o] auxiliary information */
 } sg_io_hdr_t;  /* 64 bytes long (on i386) */
 
+#if defined(__KERNEL__)
+#include <linux/compat.h>
+
+struct compat_sg_io_hdr {
+	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
+	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
+	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
+	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
+	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
+	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
+	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
+						or scatter gather list */
+	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
+	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
+	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
+	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
+	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
+	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
+	unsigned char status;		/* [o] scsi status */
+	unsigned char masked_status;	/* [o] shifted, masked scsi status */
+	unsigned char msg_status;	/* [o] messaging level data (optional) */
+	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
+	unsigned short host_status;	/* [o] errors from host adapter */
+	unsigned short driver_status;	/* [o] errors from software driver */
+	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
+	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
+	compat_uint_t info;		/* [o] auxiliary information */
+};
+#endif
+
 #define SG_INTERFACE_ID_ORIG 'S'
 
 /* Use negative values to flag difference from original sg_header structure */
-- 
2.20.0


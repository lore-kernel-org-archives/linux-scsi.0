From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 1/6] sg: disable SET_FORCE_LOW_DMA
Date: Fri,  3 Feb 2017 14:12:06 +0100
Message-ID: <1486127531-13716-2-git-send-email-hare@suse.de>
References: <1486127531-13716-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752705AbdBCNMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 08:12:24 -0500
In-Reply-To: <1486127531-13716-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ioctl SET_FORCE_LOW_DMA has never worked since the initial
git check-in, and the respective setting is nowadays handled
correctly.
So disable it entirely.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sg.c | 30 +++++++++---------------------
 include/scsi/sg.h |  1 -
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dbe5b4b..55cd641 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -149,7 +149,6 @@
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
-	char low_dma;		/* as in parent but possibly overridden to 1 */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
 	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
@@ -887,24 +886,14 @@ static int max_sectors_bytes(struct request_queue *q)
 				/* strange ..., for backward compatibility */
 		return sfp->timeout_user;
 	case SG_SET_FORCE_LOW_DMA:
-		result = get_user(val, ip);
-		if (result)
-			return result;
-		if (val) {
-			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
-				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(sfp, &sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
-			if (atomic_read(&sdp->detaching))
-				return -ENODEV;
-			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
-		}
+		/*
+		 * N.B. This ioctl never worked properly, but failed to
+		 * return an error value. So returning '0' to keep compability
+		 * with legacy applications.
+		 */
 		return 0;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
+		return put_user((int) sdp->device->host->unchecked_isa_dma, ip);
 	case SG_GET_SCSI_ID:
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
@@ -1821,6 +1810,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size, order;
 	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
+	struct sg_device *sdp = sfp->parentdp;
 
 	if (blk_size < 0)
 		return -EFAULT;
@@ -1846,7 +1836,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 			scatter_elem_sz_prev = num;
 	}
 
-	if (sfp->low_dma)
+	if (sdp->device->host->unchecked_isa_dma)
 		gfp_mask |= GFP_DMA;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -2132,8 +2122,6 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
-	sfp->low_dma = (SG_DEF_FORCE_LOW_DMA == 0) ?
-	    sdp->device->host->unchecked_isa_dma : 1;
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
@@ -2603,7 +2591,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			   jiffies_to_msecs(fp->timeout),
 			   fp->reserve.bufflen,
 			   (int) fp->reserve.k_use_sg,
-			   (int) fp->low_dma);
+			   (int) sdp->device->host->unchecked_isa_dma);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 3afec70..20bc71c 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -197,7 +197,6 @@
 #define SG_DEFAULT_RETRIES 0
 
 /* Defaults, commented if they differ from original sg driver */
-#define SG_DEF_FORCE_LOW_DMA 0  /* was 1 -> memory below 16MB on i386 */
 #define SG_DEF_FORCE_PACK_ID 0
 #define SG_DEF_KEEP_ORPHAN 0
 #define SG_DEF_RESERVED_SIZE SG_SCATTER_SZ /* load time option */
-- 
1.8.5.6

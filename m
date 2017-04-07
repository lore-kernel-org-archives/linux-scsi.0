From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 6/6] sg: close race condition in sg_remove_sfp_usercontext()
Date: Fri,  7 Apr 2017 09:34:17 +0200
Message-ID: <1491550457-78302-7-git-send-email-hare@suse.de>
References: <1491550457-78302-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54235 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753917AbdDGHeZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 03:34:25 -0400
In-Reply-To: <1491550457-78302-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <"james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, DougGilberdgilbert"@interlog.com>, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

sg_remove_sfp_usercontext() is clearing any sg requests,
but needs to take 'rq_list_lock' when modifying the list.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sg.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5c9f1b9..8147147 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -524,6 +524,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	} else
 		count = (old_hdr->result == 0) ? 0 : -EIO;
 	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	retval = count;
 free_old_hdr:
 	kfree(old_hdr);
@@ -564,6 +565,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	}
 err_out:
 	err2 = sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	return err ? : err2 ? : count;
 }
 
@@ -800,6 +802,7 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
 			"sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
+		sg_remove_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if (atomic_read(&sdp->detaching)) {
@@ -810,6 +813,7 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 		}
 
 		sg_finish_rem_req(srp);
+		sg_remove_request(sfp, srp);
 		return -ENODEV;
 	}
 
@@ -1285,6 +1289,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
@@ -1831,8 +1836,6 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	else
 		sg_remove_scat(sfp, req_schp);
 
-	sg_remove_request(sfp, srp);
-
 	return ret;
 }
 
@@ -2177,12 +2180,17 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
 	Sg_request *srp;
+	unsigned long iflags;
 
 	/* Cleanup any responses which were never read(). */
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
 		srp = list_first_entry(&sfp->rq_list, Sg_request, entry);
 		sg_finish_rem_req(srp);
+		list_del(&srp->entry);
+		srp->parentfp = NULL;
 	}
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
-- 
1.8.5.6

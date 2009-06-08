From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Initializing the residual length to proper value for BSG requests
Date: Mon, 8 Jun 2009 13:14:54 -0700
Message-ID: <CC60250D-396C-4D7C-B24B-8356EA12CDFC@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11850 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZFHUOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 16:14:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

	While testing the CT pass thru with BSG, I am seeing that residual  
length for bi-directional request are not getting set properly (rq- 
 >next_rq->resid_len is not getting set with proper value). I am using  
scsi-post-merge tree( http://www.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git) 
. I do see that req->resid_len getting set whenever a request is  
fetched from the block layer. I don't see a similar code for bi- 
directional request. This code below sets the residual length for bi- 
directional command. Hope this is a proper place to initialize the  
residual length. Do any body see any side effects because of this  
change.


diff --git a/block/bsg.c b/block/bsg.c
index 2d746e3..2cffacb 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -281,12 +281,16 @@ bsg_map_hdr(struct bsg_device *bd, struct  
sg_io_v4 *hdr, fmode_t has_write_perm,
                 }
                 rq->next_rq = next_rq;
                 next_rq->cmd_type = rq->cmd_type;

                 dxferp = (void*)(unsigned long)hdr->din_xferp;
                 ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
                                        hdr->din_xfer_len, GFP_KERNEL);
                 if (ret)
                         goto out;
+               rq->next_rq->resid_len = blk_rq_bytes(rq->next_rq);

         }

Thanks,
Giridhar.M.B


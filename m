From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/11] mpt2sas: Added sanity check for cb_idx and smid access.
Date: Sat, 13 Nov 2010 04:31:14 +0530
Message-ID: <20101112230107.GD853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45543 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab0KLXnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:43:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Sometime it is seen that controller
firmware returns an invalid system message id (smid).

the oops is occurring becuase mpt_callbacks pointer is referenced to
either null or invalid virtual address.  this is due to cb_idx set
incorrectly from routine _base_get_cb_idx.  the cb_idx was set incorrectly
becuase there is no check to make sure smid is less than maxiumum
anticapted smid.   to fix this issue, we add a check in
_base_get_cb_idx to make sure smid is not greater than
ioc->hba_queue_depth.   in addition, a similar check was added to make
sure the reply address was less than the largest anticapated address.

Newer firmware has sovled this issue, however it good to have this sanity
check.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 12faf64..d1c5345 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -758,7 +758,7 @@ _base_get_cb_idx(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 		if (smid < ioc->internal_smid) {
 			i = smid - ioc->hi_priority_smid;
 			cb_idx = ioc->hpr_lookup[i].cb_idx;
-		} else {
+		} else if (smid <= ioc->hba_queue_depth)  {
 			i = smid - ioc->internal_smid;
 			cb_idx = ioc->internal_lookup[i].cb_idx;
 		}
@@ -848,6 +848,7 @@ _base_interrupt(int irq, void *bus_id)
 		return IRQ_NONE;
 
 	completed_cmds = 0;
+	cb_idx = 0xFF;
 	do {
 		rd.word = rpf->Words;
 		if (rd.u.low == UINT_MAX || rd.u.high == UINT_MAX)
@@ -860,6 +861,9 @@ _base_interrupt(int irq, void *bus_id)
 		    MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
 			reply = le32_to_cpu
 				(rpf->AddressReply.ReplyFrameAddress);
+			if (reply > ioc->reply_dma_max_address ||
+			    reply < ioc->reply_dma_min_address)
+				reply = 0;
 		} else if (request_desript_type ==
 		    MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER)
 			goto next;
@@ -2221,6 +2225,8 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		    ioc->name);
 		goto out;
 	}
+	ioc->reply_dma_min_address = (u32)(ioc->reply_dma);
+	ioc->reply_dma_max_address = (u32)(ioc->reply_dma) + sz;
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "reply pool(0x%p): depth"
 	    "(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name, ioc->reply,
 	    ioc->reply_free_queue_depth, ioc->reply_sz, sz/1024));
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 0b15a8b..63f7a19 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -737,6 +737,8 @@ struct MPT2SAS_ADAPTER {
 	u16		reply_sz;
 	u8		*reply;
 	dma_addr_t	reply_dma;
+	u32		reply_dma_max_address;
+	u32		reply_dma_min_address;
 	struct dma_pool *reply_dma_pool;
 
 	/* reply free queue */

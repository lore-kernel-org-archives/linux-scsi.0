From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_loop: Drop host_lock around struct scsi_cmnd->scsi_done()
Date: Wed,  1 Sep 2010 14:23:25 -0700
Message-ID: <1283376205-8071-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:44641 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753041Ab0IAVX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2010 17:23:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Vasu Dev <vasu.dev@linux.intel.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch updates tcm_loop_queue_data_in() and tcm_loop_queue_status()
to no longer hold struct Scsi_Host->host_lock while calling the
struct scsi_cmnd->scsi_done() callback, in order queue the *sc off into
the block softirq.  This optimization is safely allowed for SCSI LLDs on
modern v2.6 kernels, and is done by the majority of mainline SCSI LLDs.

Thanks to Vasu Dev to the clarification on this item!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index 588730a..ef23f07 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -379,7 +379,6 @@ int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 	struct tcm_loop_cmd *tl_cmd =
 			(struct tcm_loop_cmd *)se_cmd->se_fabric_cmd_ptr;
 	struct scsi_cmnd *sc = tl_cmd->sc;
-	unsigned long flags;
 
 	TL_CDB_DEBUG( "tcm_loop_queue_data_in() called for scsi_cmnd: %p"
 			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
@@ -393,10 +392,7 @@ int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 	}
 
 	sc->result = host_byte(DID_OK) | SAM_STAT_GOOD;
-
-	spin_lock_irqsave(sc->device->host->host_lock, flags);
 	(*sc->scsi_done)(sc);
-	spin_unlock_irqrestore(sc->device->host->host_lock, flags);
 	return 0;
 }
 
@@ -405,7 +401,6 @@ int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	struct tcm_loop_cmd *tl_cmd =
 			(struct tcm_loop_cmd *)se_cmd->se_fabric_cmd_ptr;
 	struct scsi_cmnd *sc = tl_cmd->sc;
-	unsigned long flags;
 
 	TL_CDB_DEBUG("tcm_loop_queue_status() called for scsi_cmnd: %p"
 			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
@@ -421,9 +416,7 @@ int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	} else
 		sc->result = host_byte(DID_OK) | se_cmd->scsi_status;
 
-	spin_lock_irqsave(sc->device->host->host_lock, flags);
 	(*sc->scsi_done)(sc);
-	spin_unlock_irqrestore(sc->device->host->host_lock, flags);
 	return 0;
 }
 
-- 
1.5.6.5


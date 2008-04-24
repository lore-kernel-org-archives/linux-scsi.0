From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/10] qla2xxx: Correct SRB usage-after-completion/free issues.
Date: Thu, 24 Apr 2008 15:21:25 -0700
Message-ID: <1209075691-6539-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbYDXWVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:33 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The driver is incorrectly assuming that the 'sp' reference held
in qla2[x00|4xx]_abort_command() is valid after the mailbox
command is issued to abort the exchange.  It is *not*, as the
command may be completed during interrupt context before control
is returned to the mailbox caller.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a9cb829..d10cb06 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -784,7 +784,6 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 		DEBUG2_3_11(printk("qla2x00_abort_command(%ld): failed=%x.\n",
 		    ha->host_no, rval));
 	} else {
-		sp->flags |= SRB_ABORT_PENDING;
 		DEBUG11(printk("qla2x00_abort_command(%ld): done.\n",
 		    ha->host_no));
 	}
@@ -2210,7 +2209,6 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
-		sp->flags |= SRB_ABORT_PENDING;
 	}
 
 	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
-- 
1.5.5.1.67.gbdb8


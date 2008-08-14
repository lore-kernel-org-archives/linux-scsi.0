From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/8] qla2xxx: Don't leak SG-DMA mappings while aborting commands.
Date: Wed, 13 Aug 2008 21:36:58 -0700
Message-ID: <1218688622-71361-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57991 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYHNEhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:06 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code inadvertently cleared an SRB's 'flags' while
aborting; causing a follow-on scsi_dma_unmap() to be potentially
missed.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c8af7e..c2092ad 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1080,9 +1080,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *ha, int res)
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
 			ha->outstanding_cmds[cnt] = NULL;
-			sp->flags = 0;
 			sp->cmd->result = res;
-			sp->cmd->host_scribble = (unsigned char *)NULL;
 			qla2x00_sp_compl(ha, sp);
 		}
 	}
-- 
1.6.0.rc2.22.g71b9


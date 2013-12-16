From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 19/24] qla4xxx: Update print statements in qla4xxx_mailbox_command()
Date: Mon, 16 Dec 2013 06:49:49 -0500
Message-ID: <1387194594-29817-20-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:53040 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 782a94586..1345c0e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -212,9 +212,8 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 			    ha->host_no, __func__));
 			goto mbox_exit;
 		}
-		DEBUG2(printk("scsi%ld: Mailbox Cmd 0x%08X timed out ...,"
-			      " Scheduling Adapter Reset\n", ha->host_no,
-			      mbx_cmd[0]));
+		ql4_printk(KERN_WARNING, ha, "scsi%ld: Mailbox Cmd 0x%08X timed out, Scheduling Adapter Reset\n",
+			   ha->host_no, mbx_cmd[0]);
 		ha->mailbox_timeout_count++;
 		mbx_sts[0] = (-1);
 		set_bit(DPC_RESET_HA, &ha->dpc_flags);
@@ -251,15 +250,16 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		break;
 
 	case MBOX_STS_BUSY:
-		DEBUG2( printk("scsi%ld: %s: Cmd = %08X, ISP BUSY\n",
-			       ha->host_no, __func__, mbx_cmd[0]));
+		ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: Cmd = %08X, ISP BUSY\n",
+			   ha->host_no, __func__, mbx_cmd[0]);
 		ha->mailbox_timeout_count++;
 		break;
 
 	default:
-		DEBUG2(printk("scsi%ld: %s: **** FAILED, cmd = %08X, "
-			      "sts = %08X ****\n", ha->host_no, __func__,
-			      mbx_cmd[0], mbx_sts[0]));
+		ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: FAILED, MBOX CMD = %08X, MBOX STS = %08X %08X %08X %08X %08X %08X %08X %08X\n",
+			   ha->host_no, __func__, mbx_cmd[0], mbx_sts[0],
+			   mbx_sts[1], mbx_sts[2], mbx_sts[3], mbx_sts[4],
+			   mbx_sts[5], mbx_sts[6], mbx_sts[7]);
 		break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-- 
1.8.2.GIT


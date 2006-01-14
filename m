From: andrew.vasquez@qlogic.com
Subject: [PATCH 03/15] qla2xxx: Drop noisy 'UNDERRUN' status message.
Date: Fri, 13 Jan 2006 17:04:59 -0800
Message-ID: <11372006942093-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:19491 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945920AbWANBFA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:00 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

There's no point in displaying the message during a valid
underrun case.  Limit the message to potentially problematic
cases.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_isr.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

296a4916c8f4b2c725dfdccdb8c42c9cbd5815aa
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5181d96..8a539dd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -963,15 +963,16 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		break;
 
 	case CS_DATA_UNDERRUN:
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld:%d:%d) UNDERRUN status detected 0x%x-0x%x.\n",
-		    ha->host_no, cp->device->id, cp->device->lun, comp_status,
-		    scsi_status));
-
 		resid = resid_len;
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			cp->resid = resid;
 			CMD_RESID_LEN(cp) = resid;
+		} else {
+			DEBUG2(printk(KERN_INFO
+			    "scsi(%ld:%d:%d) UNDERRUN status detected "
+			    "0x%x-0x%x.\n", ha->host_no, cp->device->id,
+			    cp->device->lun, comp_status, scsi_status));
+
 		}
 
 		/*
-- 
1.1.1-g4c34



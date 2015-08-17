From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] pm80xx: Don't override ts->stat on IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY
Date: Mon, 17 Aug 2015 15:04:42 +0200
Message-ID: <1439816682-9781-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: xjtuwjp@gmail.com, lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@odin.com>, pmchba@pmcs.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

In case XXX returns with a status of IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY
ts->stat gets set to SAS_OPEN_REJECT but a missing 'break' statement causes a
fallthrough to the default handler of the switch statement overriding ts->stat
to SAS_DEV_NO_RESPONSE.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 1 +
 drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 96dcc09..d0feec5 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2642,6 +2642,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		break;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("Unknown status 0x%x\n", status));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 05cce46..18d4ac4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2314,6 +2314,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		break;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("Unknown status 0x%x\n", status));
-- 
2.5.0

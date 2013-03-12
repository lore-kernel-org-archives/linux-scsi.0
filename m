From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH 12/18] driver: scsi: remove cast for kmalloc/kzalloc return
 value
Date: Tue, 12 Mar 2013 13:25:03 +0800
Message-ID: <513EBC2F.6030601@cn.fujitsu.com>
References: <513EB23D.7020303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

remove cast for kmalloc/kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c           |    3 +--
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..7a5a002 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3071,8 +3071,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = (BIG_IOCTL_Command_struct *)
-	    kmalloc(sizeof(*ioc), GFP_KERNEL);
+	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc) {
 		status = -ENOMEM;
 		goto cleanup1;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 314b4f6..f9a3b30 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4674,7 +4674,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
+		phba->sli.ring =
 			kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
-- 
1.7.1

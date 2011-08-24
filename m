From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] [SCSI] megaraid_sas: Fix mismatch in megasas_reset_fusion mutex lock-unlock
Date: Thu, 25 Aug 2011 00:39:25 +0400
Message-ID: <1314218365-12295-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@ispras.ru
List-Id: linux-scsi@vger.kernel.org

In case of MEGASAS_HW_CRITICAL_ERROR goto out is invalid since
we have not locked mutex and have not set MEGASAS_FUSION_IN_RESET bit yet.
The patch replaces goto by immediate return.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f13e7ab..8b59fb9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2057,8 +2057,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
 		       "returning FAILED.\n");
-		retval = FAILED;
-		goto out;
+		return FAILED;
 	}
 
 	mutex_lock(&instance->reset_mutex);
-- 
1.7.4.1

From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when request_irq() failed
Date: Wed, 16 Jul 2014 20:05:21 +0200
Message-ID: <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When a call to request_irq() failed pm8001_setup_msix()
still returns the success. This udate fixes the described
misbehaviour.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: xjtuwjp@gmail.com
Cc: lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Jack Wang <xjtuwjp@gmail.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e90c89f..e837ece 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -744,9 +744,10 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 			pm8001_ha->irq_vector[i].irq_id = i;
 			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
 
-			if (request_irq(pm8001_ha->msix_entries[i].vector,
+			rc = request_irq(pm8001_ha->msix_entries[i].vector,
 				pm8001_interrupt_handler_msix, flag,
-				intr_drvname[i], &(pm8001_ha->irq_vector[i]))) {
+				intr_drvname[i], &(pm8001_ha->irq_vector[i]));
+			if (rc) {
 				for (j = 0; j < i; j++)
 					free_irq(
 					pm8001_ha->msix_entries[j].vector,
-- 
1.7.7.6

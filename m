From: Colin King <colin.king@canonical.com>
Subject: [PATCH 2/2] scsi: pm8001: fix spelling mistake, interupt -> interrupt
Date: Fri, 29 Mar 2019 23:44:23 +0000
Message-ID: <20190329234423.5611-3-colin.king@canonical.com>
References: <20190329234423.5611-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190329234423.5611-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Rename the functions pm8001_chip_is_our_interupt,
pm80xx_chip_is_our_interupt and function pointer is_our_interrupt
to fix spelling mistakes.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 4 ++--
 drivers/scsi/pm8001/pm8001_init.c | 4 ++--
 drivers/scsi/pm8001/pm8001_sas.h  | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 434498a78946..627075d00918 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4623,7 +4623,7 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
-static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
+static u32 pm8001_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 {
 #ifdef PM8001_USE_MSIX
 	return 1;
@@ -5120,7 +5120,7 @@ const struct pm8001_dispatch pm8001_8001_dispatch = {
 	.chip_rst		= pm8001_hw_chip_rst,
 	.chip_iounmap		= pm8001_chip_iounmap,
 	.isr			= pm8001_chip_isr,
-	.is_our_interupt	= pm8001_chip_is_our_interupt,
+	.is_our_interrupt	= pm8001_chip_is_our_interrupt,
 	.isr_process_oq		= process_oq,
 	.interrupt_enable 	= pm8001_chip_interrupt_enable,
 	.interrupt_disable	= pm8001_chip_interrupt_disable,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a36060c23b37..3374f553c617 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -201,7 +201,7 @@ static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 
 	if (unlikely(!pm8001_ha))
 		return IRQ_NONE;
-	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
+	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
 		return IRQ_NONE;
 #ifdef PM8001_USE_TASKLET
 	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
@@ -224,7 +224,7 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 	pm8001_ha = sha->lldd_ha;
 	if (unlikely(!pm8001_ha))
 		return IRQ_NONE;
-	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
+	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
 		return IRQ_NONE;
 
 #ifdef PM8001_USE_TASKLET
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index f88b0d33c385..ac6d8e3f22de 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -197,7 +197,7 @@ struct pm8001_dispatch {
 	int (*chip_ioremap)(struct pm8001_hba_info *pm8001_ha);
 	void (*chip_iounmap)(struct pm8001_hba_info *pm8001_ha);
 	irqreturn_t (*isr)(struct pm8001_hba_info *pm8001_ha, u8 vec);
-	u32 (*is_our_interupt)(struct pm8001_hba_info *pm8001_ha);
+	u32 (*is_our_interrupt)(struct pm8001_hba_info *pm8001_ha);
 	int (*isr_process_oq)(struct pm8001_hba_info *pm8001_ha, u8 vec);
 	void (*interrupt_enable)(struct pm8001_hba_info *pm8001_ha, u8 vec);
 	void (*interrupt_disable)(struct pm8001_hba_info *pm8001_ha, u8 vec);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4a176e60307f..301de40eb708 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4617,7 +4617,7 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 }
 
-static u32 pm80xx_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
+static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 {
 #ifdef PM8001_USE_MSIX
 	return 1;
@@ -4725,7 +4725,7 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.chip_rst		= pm80xx_hw_chip_rst,
 	.chip_iounmap		= pm8001_chip_iounmap,
 	.isr			= pm80xx_chip_isr,
-	.is_our_interupt	= pm80xx_chip_is_our_interupt,
+	.is_our_interrupt	= pm80xx_chip_is_our_interrupt,
 	.isr_process_oq		= process_oq,
 	.interrupt_enable	= pm80xx_chip_interrupt_enable,
 	.interrupt_disable	= pm80xx_chip_interrupt_disable,
-- 
2.20.1

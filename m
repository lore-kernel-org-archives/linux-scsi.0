From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: be2iscsi: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:21 -0700
Message-ID: <20171016235421.GA102535@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/be2iscsi/be_main.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7561e1332257..1013987db49b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5249,12 +5249,11 @@ static void beiscsi_eqd_update_work(struct work_struct *work)
 			      msecs_to_jiffies(BEISCSI_EQD_UPDATE_INTERVAL));
 }
 
-static void beiscsi_hw_tpe_check(unsigned long ptr)
+static void beiscsi_hw_tpe_check(struct timer_list *t)
 {
-	struct beiscsi_hba *phba;
+	struct beiscsi_hba *phba = from_timer(phba, t, hw_check);
 	u32 wait;
 
-	phba = (struct beiscsi_hba *)ptr;
 	/* if not TPE, do nothing */
 	if (!beiscsi_detect_tpe(phba))
 		return;
@@ -5267,11 +5266,10 @@ static void beiscsi_hw_tpe_check(unsigned long ptr)
 			   msecs_to_jiffies(wait));
 }
 
-static void beiscsi_hw_health_check(unsigned long ptr)
+static void beiscsi_hw_health_check(struct timer_list *t)
 {
-	struct beiscsi_hba *phba;
+	struct beiscsi_hba *phba = from_timer(phba, t, hw_check);
 
-	phba = (struct beiscsi_hba *)ptr;
 	beiscsi_detect_ue(phba);
 	if (beiscsi_detect_ue(phba)) {
 		__beiscsi_log(phba, KERN_ERR,
@@ -5283,7 +5281,7 @@ static void beiscsi_hw_health_check(unsigned long ptr)
 		if (!test_bit(BEISCSI_HBA_UER_SUPP, &phba->state))
 			return;
 		/* modify this timer to check TPE */
-		phba->hw_check.function = beiscsi_hw_tpe_check;
+		phba->hw_check.function = (TIMER_FUNC_TYPE)beiscsi_hw_tpe_check;
 	}
 
 	mod_timer(&phba->hw_check,
@@ -5371,7 +5369,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	 * Timer function gets modified for TPE detection.
 	 * Always reinit to do health check first.
 	 */
-	phba->hw_check.function = beiscsi_hw_health_check;
+	phba->hw_check.function = (TIMER_FUNC_TYPE)beiscsi_hw_health_check;
 	mod_timer(&phba->hw_check,
 		  jiffies + msecs_to_jiffies(BEISCSI_UE_DETECT_INTERVAL));
 	return 0;
@@ -5721,9 +5719,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	 * Start UE detection here. UE before this will cause stall in probe
 	 * and eventually fail the probe.
 	 */
-	init_timer(&phba->hw_check);
-	phba->hw_check.function = beiscsi_hw_health_check;
-	phba->hw_check.data = (unsigned long)phba;
+	timer_setup(&phba->hw_check, beiscsi_hw_health_check, 0);
 	mod_timer(&phba->hw_check,
 		  jiffies + msecs_to_jiffies(BEISCSI_UE_DETECT_INTERVAL));
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-- 
2.7.4


-- 
Kees Cook
Pixel Security

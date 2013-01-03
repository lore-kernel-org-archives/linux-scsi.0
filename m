From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v2 16/26] scsi: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:12 +0900
Message-ID: <1357215562-6288-17-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org
Cc: James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org
---

No change from v1

 drivers/scsi/fcoe/fcoe_ctlr.c    | 4 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 +++---
 drivers/scsi/qla2xxx/qla_attr.c  | 7 +++++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 4a909d7..d870ccc 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2153,7 +2153,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 
 	if (fip->probe_tries < FIP_VN_RLIM_COUNT) {
 		fip->probe_tries++;
-		wait = random32() % FIP_VN_PROBE_WAIT;
+		wait = prandom_u32() % FIP_VN_PROBE_WAIT;
 	} else
 		wait = FIP_VN_RLIM_INT;
 	mod_timer(&fip->timer, jiffies + msecs_to_jiffies(wait));
@@ -2786,7 +2786,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 					  fcoe_all_vn2vn, 0);
 			fip->port_ka_time = jiffies +
 				 msecs_to_jiffies(FIP_VN_BEACON_INT +
-					(random32() % FIP_VN_BEACON_FUZZ));
+					(prandom_u32() % FIP_VN_BEACON_FUZZ));
 		}
 		if (time_before(fip->port_ka_time, next_time))
 			next_time = fip->port_ka_time;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d7096ad..bfda184 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1732,7 +1732,7 @@ lpfc_check_pending_fcoe_event(struct lpfc_hba *phba, uint8_t unreg_fcf)
  * use through a sequence of @fcf_cnt eligible FCF records with equal
  * probability. To perform integer manunipulation of random numbers with
  * size unit32_t, the lower 16 bits of the 32-bit random number returned
- * from random32() are taken as the random random number generated.
+ * from prandom_u32() are taken as the random random number generated.
  *
  * Returns true when outcome is for the newly read FCF record should be
  * chosen; otherwise, return false when outcome is for keeping the previously
@@ -1744,7 +1744,7 @@ lpfc_sli4_new_fcf_random_select(struct lpfc_hba *phba, uint32_t fcf_cnt)
 	uint32_t rand_num;
 
 	/* Get 16-bit uniform random number */
-	rand_num = (0xFFFF & random32());
+	rand_num = 0xFFFF & prandom_u32();
 
 	/* Decision with probability 1/fcf_cnt */
 	if ((fcf_cnt * rand_num) < 0xFFFF)
@@ -2380,7 +2380,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->fcf.eligible_fcf_cnt = 1;
 		/* Seeding the random number generator for random selection */
 		seed = (uint32_t)(0xFFFFFFFF & jiffies);
-		srandom32(seed);
+		prandom_seed(seed);
 	}
 	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 83d7984..3658e9f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1933,8 +1933,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	/* No pending activities shall be there on the vha now */
 	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(random32()%10);  /* Just to see if something falls on
-					* the net we have placed below */
+		msleep(prandom_u32() % 10);
+		/*
+		 * Just to see if something falls on the net we have placed
+		 * below
+		 */
 
 	BUG_ON(atomic_read(&vha->vref_count));
 
-- 
1.7.11.7

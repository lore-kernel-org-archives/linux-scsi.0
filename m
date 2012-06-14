From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.5-rc2
Date: Thu, 14 Jun 2012 15:56:56 +0100
Message-ID: <1339685816.3107.29.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a couple of minor fixes, one for a preempt warning in the
mpt2sas driver and one is a config failure with the new sd async domain.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Bottomley (1):
      Fix sd_probe_domain config problem

nagalakshmi.nandigama@lsi.com (1):
      mpt2sas: Fix unsafe using smp_processor_id() in preemptible


And the diffstat:

 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 drivers/scsi/scsi.c                 |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

Full diff is below.

James

---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6102ef2..9d46fcb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1792,7 +1792,7 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
 
 /**
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 61c82a3..bbbc9c9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -90,11 +90,9 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
-#if IS_ENABLED(CONFIG_PM) || IS_ENABLED(CONFIG_BLK_DEV_SD)
-/* sd and scsi_pm need to coordinate flushing async actions */
+/* sd, scsi core and power management need to coordinate flushing async actions */
 LIST_HEAD(scsi_sd_probe_domain);
 EXPORT_SYMBOL(scsi_sd_probe_domain);
-#endif
 
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is

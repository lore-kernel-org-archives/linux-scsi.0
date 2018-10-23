From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v6 3/4] mpt3sas:Fix driver modifying persistent data.
Date: Tue, 23 Oct 2018 15:51:20 +0530
Message-ID: <1540290081-15827-4-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: helgaas@kernel.org, lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

* If EEDPTagMode field in manufacturing page11 is set,
unset it. This is needed to fix a hardware bug
in SAS3/SAS2 cards, So, skipping EEDPTagMode changes
in Manufacturing page11 for SAS35 controllers.

* Fix driver modifying NVRAM/persistent data in
Manufacturing page11 along with current copy. Driver should
change only current copy of Manufacturing page11.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 243bf32..2237681 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4062,7 +4062,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	 * flag unset in NVDATA.
 	 */
 	mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
-	if (ioc->manu_pg11.EEDPTagMode == 0) {
+	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
 		    ioc->name);
 		ioc->manu_pg11.EEDPTagMode &= ~0x3;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 88062d1..fe3da1c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -659,10 +659,6 @@ mpt3sas_config_set_manufacturing_pg11(struct MPT3SAS_ADAPTER *ioc,
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-	    sizeof(*config_page));
  out:
 	return r;
 }
-- 
1.8.3.1

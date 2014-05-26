From: Benoit Taine <benoit.taine@lip6.fr>
Subject: [PATCH 8/18] Drivers: scsi: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:17 +0200
Message-ID: <1401117687-28911-9-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: benoit.taine@lip6.fr, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 +---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6fd7d40..080d5f5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7603,7 +7603,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		return;
 	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	fw_event->event_data = kmemdup(mpi_reply->EventData, sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7611,8 +7611,6 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		return;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData,
-	    sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..40c15cf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7205,7 +7205,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	fw_event->event_data = kmemdup(mpi_reply->EventData, sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7213,7 +7213,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData, sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: mpt3sas: Fix value returned by 'mpt3sas_base_attach' in case of error
Date: Sun, 11 Jun 2017 06:43:05 +0200
Message-ID: <20170611044305.28152-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

'r' is known to be zero here, so it must be set to -ENOMEM is one of these
'kzalloc' fails.

Fixes: c696f7b83edea ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 18039bba26c4..22bee63ce239 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5453,14 +5453,18 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->pend_os_device_add_sz++;
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
-	if (!ioc->pend_os_device_add)
+	if (!ioc->pend_os_device_add) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->device_remove_in_progress_sz = ioc->pend_os_device_add_sz;
 	ioc->device_remove_in_progress =
 		kzalloc(ioc->device_remove_in_progress_sz, GFP_KERNEL);
-	if (!ioc->device_remove_in_progress)
+	if (!ioc->device_remove_in_progress) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->fwfault_debug = mpt3sas_fwfault_debug;
 
-- 
2.11.0

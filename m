Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CAC23A4
	for <linux-scsi@vger.kernel.org>; Fri, 29 Dec 2023 04:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VzQGD9z_1703822612;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VzQGD9z_1703822612)
          by smtp.aliyun-inc.com;
          Fri, 29 Dec 2023 12:03:36 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2] scsi: mpi3mr: use ida to manage mrioc's id
Date: Fri, 29 Dec 2023 12:03:31 +0800
Message-ID: <20231229040331.52518-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To ensure that the same id is not obtained during concurrent
execution of the probe, an ida is used to manage the mrioc's
id.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
Changes from v1 to v2:
- change id from int to u8, and use ida_alloc_range instead of ida_alloc.

 drivers/scsi/mpi3mr/mpi3mr_os.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 040031eb0c12..36c4ab679094 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -8,11 +8,12 @@
  */
 
 #include "mpi3mr.h"
+#include <linux/idr.h>
 
 /* global driver scop variables */
 LIST_HEAD(mrioc_list);
 DEFINE_SPINLOCK(mrioc_list_lock);
-static int mrioc_ids;
+static DEFINE_IDA(mrioc_ida);
 static int warn_non_secure_ctlr;
 atomic64_t event_counter;
 
@@ -5060,7 +5061,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	mrioc->id = mrioc_ids++;
+	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	if (retval < 0)
+		goto id_alloc_failed;
+	mrioc->id = (u8)retval;
 	sprintf(mrioc->driver_name, "%s", MPI3MR_DRIVER_NAME);
 	sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
 	INIT_LIST_HEAD(&mrioc->list);
@@ -5207,9 +5211,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 resource_alloc_failed:
 	destroy_workqueue(mrioc->fwevt_worker_thread);
 fwevtthread_failed:
+	ida_free(&mrioc_ida, mrioc->id);
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
+id_alloc_failed:
 	scsi_host_put(shost);
 shost_failed:
 	return retval;
@@ -5295,6 +5301,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		mrioc->sas_hba.num_phys = 0;
 	}
 
+	ida_free(&mrioc_ida, mrioc->id);
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
@@ -5502,6 +5509,7 @@ static void __exit mpi3mr_exit(void)
 			   &driver_attr_event_counter);
 	pci_unregister_driver(&mpi3mr_pci_driver);
 	sas_release_transport(mpi3mr_transport_template);
+	ida_destroy(&mrioc_ida);
 }
 
 module_init(mpi3mr_init);
-- 
2.43.0


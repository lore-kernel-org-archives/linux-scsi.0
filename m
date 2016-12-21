From: Burak Ok <burak-kernel@bur0k.de>
Subject: [PATCH] snic: Return error code on memory allocation failure
Date: Wed, 21 Dec 2016 14:45:53 +0100
Message-ID: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Martin K Petersen <martin.petersen@oracle.com>, James E J Bottomley <jejb@linux.vnet.ibm.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>, linux-kernel@i4.cs.fau.de, Burak Ok <burak-kernel@bur0k.de>, Andreas Schaertl <andreas.schaertl@fau.de>
List-Id: linux-scsi@vger.kernel.org

If a call to mempool_create_slab_pool() in snic_probe() returns NULL,
return -ENOMEM to indicate failure. mempool_creat_slab_pool() only fails if
it cannot allocate memory.

https://bugzilla.kernel.org/show_bug.cgi?id=189061

Reported-by: bianpan2010@ruc.edu.cn
Signed-off-by: Burak Ok <burak-kernel@bur0k.de>
Signed-off-by: Andreas Schaertl <andreas.schaertl@fau.de>
---
 drivers/scsi/snic/snic_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 396b32d..7cf70aa 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -591,6 +591,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!pool) {
 		SNIC_HOST_ERR(shost, "dflt sgl pool creation failed\n");
 
+		ret = -ENOMEM;
 		goto err_free_res;
 	}
 
@@ -601,6 +602,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!pool) {
 		SNIC_HOST_ERR(shost, "max sgl pool creation failed\n");
 
+		ret = -ENOMEM;
 		goto err_free_dflt_sgl_pool;
 	}
 
@@ -611,6 +613,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!pool) {
 		SNIC_HOST_ERR(shost, "snic tmreq info pool creation failed.\n");
 
+		ret = -ENOMEM;
 		goto err_free_max_sgl_pool;
 	}
 
-- 
2.7.4

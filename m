From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 1/25]  fix error return code
Date: Sun, 29 Dec 2013 23:47:16 +0100
Message-ID: <1388357260-4843-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

Additionally, in each case there is no need to initialize ret to 0, since
its value is immediately overwritten.

A simplified version of the semantic match that finds the first problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/scsi/be2iscsi/be_main.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..82f4587 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4326,7 +4326,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	struct be_dma_mem nonemb_cmd;
 	unsigned int tag;
 	unsigned int s_handle;
-	int ret = -ENOMEM;
+	int ret;
 
 	/* Get the session handle of the boot target */
 	ret = be_mgmt_get_boot_shandle(phba, &s_handle);
@@ -4356,6 +4356,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
 			    "BM_%d : beiscsi_get_session_info"
 			    " Failed\n");
+		ret = -ENOMEM;
 
 		goto boot_freemem;
 	}
@@ -4455,7 +4456,8 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 		goto do_cleanup_ctrlr;
 	}
 
-	if (hba_setup_cid_tbls(phba)) {
+	ret = hba_setup_cid_tbls(phba);
+	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : Failed in hba_setup_cid_tbls\n");
 		kfree(phba->io_sgl_hndl_base);
@@ -5479,7 +5481,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
-	int ret = 0, i;
+	int ret, i;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -5492,6 +5494,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	if (!phba) {
 		dev_err(&pcidev->dev,
 			"beiscsi_dev_probe - Failed in beiscsi_hba_alloc\n");
+		ret = -ENOMEM;
 		goto disable_pci;
 	}
 
@@ -5586,6 +5589,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
 			    "Failed in beiscsi_init_port\n");
+		ret = -ENOMEM;
 		goto free_port;
 	}
 

From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] BNX2I: Removed the individual PCI DEVICE ID checking
Date: Mon, 15 Oct 2012 17:31:37 -0700
Message-ID: <1350347497-20965-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCUIJQ5MUMJBBB6W6KBQKGQEAWGRLRY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Removed the individual PCI DEVICE ID checking inside bnx2i.  The device
type can easily be read from the corresponding cnic->flags.  This will
free bnx2i from having to get updated for every new device ID that gets
added.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i_init.c  |   43 +++++++++++++++-----------------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 3 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 3f9e706..b44d04e 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -800,7 +800,7 @@ extern struct device_attribute *bnx2i_dev_attributes[];
 /*
  * Function Prototypes
  */
-extern void bnx2i_identify_device(struct bnx2i_hba *hba);
+extern void bnx2i_identify_device(struct bnx2i_hba *hba, struct cnic_dev *dev);
 
 extern void bnx2i_ulp_init(struct cnic_dev *dev);
 extern void bnx2i_ulp_exit(struct cnic_dev *dev);
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index b17637a..ee009e4ad 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -79,42 +79,33 @@ static struct notifier_block bnx2i_cpu_notifier = {
 /**
  * bnx2i_identify_device - identifies NetXtreme II device type
  * @hba: 		Adapter structure pointer
+ * @cnic:		Corresponding cnic device
  *
  * This function identifies the NX2 device type and sets appropriate
  *	queue mailbox register access method, 5709 requires driver to
  *	access MBOX regs using *bin* mode
  */
-void bnx2i_identify_device(struct bnx2i_hba *hba)
+void bnx2i_identify_device(struct bnx2i_hba *hba, struct cnic_dev *dev)
 {
 	hba->cnic_dev_type = 0;
-	if ((hba->pci_did == PCI_DEVICE_ID_NX2_5706) ||
-	    (hba->pci_did == PCI_DEVICE_ID_NX2_5706S))
-		set_bit(BNX2I_NX2_DEV_5706, &hba->cnic_dev_type);
-	else if ((hba->pci_did == PCI_DEVICE_ID_NX2_5708) ||
-	    (hba->pci_did == PCI_DEVICE_ID_NX2_5708S))
-		set_bit(BNX2I_NX2_DEV_5708, &hba->cnic_dev_type);
-	else if ((hba->pci_did == PCI_DEVICE_ID_NX2_5709) ||
-	    (hba->pci_did == PCI_DEVICE_ID_NX2_5709S)) {
-		set_bit(BNX2I_NX2_DEV_5709, &hba->cnic_dev_type);
-		hba->mail_queue_access = BNX2I_MQ_BIN_MODE;
-	} else if (hba->pci_did == PCI_DEVICE_ID_NX2_57710    ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57711    ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57711E   ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57712    ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57712E   ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57800    ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57800_MF ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57800_VF ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57810    ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57810_MF ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57810_VF ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57840    ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57840_MF ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57840_VF)
+	if (test_bit(CNIC_F_BNX2_CLASS, &dev->flags)) {
+		if (hba->pci_did == PCI_DEVICE_ID_NX2_5706 ||
+		    hba->pci_did == PCI_DEVICE_ID_NX2_5706S) {
+			set_bit(BNX2I_NX2_DEV_5706, &hba->cnic_dev_type);
+		} else if (hba->pci_did == PCI_DEVICE_ID_NX2_5708 ||
+		    hba->pci_did == PCI_DEVICE_ID_NX2_5708S) {
+			set_bit(BNX2I_NX2_DEV_5708, &hba->cnic_dev_type);
+		} else if (hba->pci_did == PCI_DEVICE_ID_NX2_5709 ||
+		    hba->pci_did == PCI_DEVICE_ID_NX2_5709S) {
+			set_bit(BNX2I_NX2_DEV_5709, &hba->cnic_dev_type);
+			hba->mail_queue_access = BNX2I_MQ_BIN_MODE;
+		}
+	} else if (test_bit(CNIC_F_BNX2X_CLASS, &dev->flags)) {
 		set_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type);
-	else
+	} else {
 		printk(KERN_ALERT "bnx2i: unknown device, 0x%x\n",
 				  hba->pci_did);
+	}
 }
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 3b34c13..0056e47 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -808,7 +808,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	hba->pci_func = PCI_FUNC(hba->pcidev->devfn);
 	hba->pci_devno = PCI_SLOT(hba->pcidev->devfn);
 
-	bnx2i_identify_device(hba);
+	bnx2i_identify_device(hba, cnic);
 	bnx2i_setup_host_queue_size(hba, shost);
 
 	hba->reg_base = pci_resource_start(hba->pcidev, 0);
-- 
1.7.7.4


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.

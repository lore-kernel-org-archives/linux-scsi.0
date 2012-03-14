From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 3/3 v4] qla4xxx: use pci_dev->revision
Date: Wed, 14 Mar 2012 22:10:03 +0300
Message-ID: <201203142210.03891.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, iscsi-driver@qlogic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit f4f5df23bf72208d0c2f1d8be629839924c2f4c2 ([SCSI] qla4xxx: Added support
for ISP82XX) added code to read the PCI revision ID from the PCI configuration
register while it's already stored by PCI subsystem in the 'revision' field of
'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

---
The patch is refreshed against the recent Linus' tree.

 drivers/scsi/qla4xxx/ql4_os.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
@@ -2962,7 +2962,6 @@ static void qla4xxx_free_adapter(struct 
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 {
 	int status = 0;
-	uint8_t revision_id;
 	unsigned long mem_base, mem_len, db_base, db_len;
 	struct pci_dev *pdev = ha->pdev;
 
@@ -2974,10 +2973,9 @@ int qla4_8xxx_iospace_config(struct scsi
 		goto iospace_error_exit;
 	}
 
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &revision_id);
 	DEBUG2(printk(KERN_INFO "%s: revision-id=%d\n",
-	    __func__, revision_id));
-	ha->revision_id = revision_id;
+	    __func__, pdev->revision));
+	ha->revision_id = pdev->revision;
 
 	/* remap phys address */
 	mem_base = pci_resource_start(pdev, 0); /* 0 is for BAR 0 */

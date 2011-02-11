From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH] qla4xxx: use pci_dev->revision
Date: Fri, 11 Feb 2011 22:40:58 +0300
Message-ID: <201102112240.59257.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46622 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753805Ab1BKTmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2011 14:42:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, iscsi-driver@qlogic.com

The 'qla4xxx' driver was merged somewhat later than commit
44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all drivers to use
pci_device->revision) and so wasn't subject to the conversion...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

 drivers/scsi/qla4xxx/ql4_os.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
@@ -1441,7 +1441,6 @@ static void qla4xxx_free_adapter(struct 
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 {
 	int status = 0;
-	uint8_t revision_id;
 	unsigned long mem_base, mem_len, db_base, db_len;
 	struct pci_dev *pdev = ha->pdev;
 
@@ -1453,10 +1452,9 @@ int qla4_8xxx_iospace_config(struct scsi
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

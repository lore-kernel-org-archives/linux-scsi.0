From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH v2 resend] qla4xxx: use pci_dev->revision
Date: Thu, 21 Jul 2011 19:37:37 +0400
Message-ID: <201107211937.37741.sshtylyov@ru.mvista.com>
References: <201105131904.35018.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:56305 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752182Ab1GUPj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 11:39:27 -0400
In-Reply-To: <201105131904.35018.sshtylyov@ru.mvista.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, iscsi-driver@qlogic.com

Commit f4f5df23bf72208d0c2f1d8be629839924c2f4c2 ([SCSI] qla4xxx: Added support
for ISP82XX) added code to read the PCI revision ID from the PCI configuration
register while it's already stored by PCI subsystem in the 'revision' field of
'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.
It wasn't merged in either 2.6.39 or 3.0 time, hopefully it can be merged to
3.1...

 drivers/scsi/qla4xxx/ql4_os.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
@@ -1428,7 +1428,6 @@ static void qla4xxx_free_adapter(struct 
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 {
 	int status = 0;
-	uint8_t revision_id;
 	unsigned long mem_base, mem_len, db_base, db_len;
 	struct pci_dev *pdev = ha->pdev;
 
@@ -1440,10 +1439,9 @@ int qla4_8xxx_iospace_config(struct scsi
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

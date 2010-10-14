From: Dan Carpenter <error27@gmail.com>
Subject: [patch -next] lpfc: unlock etc on error path
Date: Thu, 14 Oct 2010 18:38:49 +0200
Message-ID: <20101014163849.GA6614@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Alex Iannicelli <alex.iannicelli@emulex.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

All the other error paths call sysfs_mbox_idle() and unlock before
returning. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f681eea..5f7d9e6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3789,8 +3789,11 @@ sysfs_mbox_read(struct file *filp, struct kobject *kobj,
 			break;
 		case MBX_SECURITY_MGMT:
 		case MBX_AUTH_PORT:
-			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
+				sysfs_mbox_idle(phba);
+				spin_unlock_irq(&phba->hbalock);
 				return -EPERM;
+			}
 			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:

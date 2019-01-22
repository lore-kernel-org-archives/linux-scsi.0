From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/7] scsi: bfa: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:09:00 +0100
Message-ID: <20190122150906.12470-2-gregkh@linuxfoundation.org>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/bfa/bfad_debugfs.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 349cfe7d055e..ece165851cf6 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -460,11 +460,6 @@ bfad_debugfs_init(struct bfad_port_s *port)
 	if (!bfa_debugfs_root) {
 		bfa_debugfs_root = debugfs_create_dir("bfa", NULL);
 		atomic_set(&bfa_debugfs_port_count, 0);
-		if (!bfa_debugfs_root) {
-			printk(KERN_WARNING
-				"BFA debugfs root dir creation failed\n");
-			goto err;
-		}
 	}
 
 	/* Setup the pci_dev debugfs directory for the port */
@@ -472,12 +467,6 @@ bfad_debugfs_init(struct bfad_port_s *port)
 	if (!port->port_debugfs_root) {
 		port->port_debugfs_root =
 			debugfs_create_dir(name, bfa_debugfs_root);
-		if (!port->port_debugfs_root) {
-			printk(KERN_WARNING
-				"bfa %s: debugfs root creation failed\n",
-				bfad->pci_name);
-			goto err;
-		}
 
 		atomic_inc(&bfa_debugfs_port_count);
 
@@ -489,12 +478,6 @@ bfad_debugfs_init(struct bfad_port_s *port)
 							port->port_debugfs_root,
 							port,
 							file->fops);
-			if (!bfad->bfad_dentry_files[i]) {
-				printk(KERN_WARNING
-					"bfa %s: debugfs %s creation failed\n",
-					bfad->pci_name, file->name);
-				goto err;
-			}
 		}
 	}
 
-- 
2.20.1

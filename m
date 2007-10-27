From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [PATCH] MegaRAID SAS: Convert aen_mutex to the mutex API
Date: Sat, 27 Oct 2007 09:48:46 +0200
Message-ID: <20071027074846.GQ9824@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753802AbXJ0Hsp@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

MegaRAID SAS: Convert aen_mutex to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

index e3c5c52..3ad379f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -31,6 +31,7 @@
 #include <linux/moduleparam.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/uio.h>
@@ -2358,7 +2359,7 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	spin_lock_init(&instance->cmd_pool_lock);
 
-	sema_init(&instance->aen_mutex, 1);
+	mutex_init(&instance->aen_mutex);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
 	/*
@@ -2874,10 +2875,10 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	if (!instance)
 		return -ENODEV;
 
-	down(&instance->aen_mutex);
+	mutex_lock(&instance->aen_mutex);
 	error = megasas_register_aen(instance, aen.seq_num,
 				     aen.class_locale_word);
-	up(&instance->aen_mutex);
+	mutex_unlock(&instance->aen_mutex);
 	return error;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 4dffc91..08c74c9 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1089,7 +1089,7 @@ struct megasas_instance {
 	struct megasas_evt_detail *evt_detail;
 	dma_addr_t evt_detail_h;
 	struct megasas_cmd *aen_cmd;
-	struct semaphore aen_mutex;
+	struct mutex aen_mutex;
 	struct semaphore ioctl_sem;
 
 	struct Scsi_Host *host;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Tant qu'il y aura sur terre des hommes pour qui existe un concept
    d' 'honneur national', la menace d'une nouvelle guerre subsistera.
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

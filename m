From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/12] scsi: megaraid_sas - Add poll mechanism to megaraid
 sas driver (part I)
Date: Tue, 6 Oct 2009 14:18:02 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C6861AE@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C511953@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C5123FB@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933166AbZJFUSy@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5123FB@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT:

Add Poll_wait mechanism to SAS-2 MegaRAID SAS Linux driver. Driver will wakeup poll after the driver get event from MegaRAID SAS FW.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   45 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    1
 2 files changed, 45 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c	2009-06-10 14:31:17.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c	2009-09-13 09:45:56.000000000 -0400
@@ -40,6 +40,7 @@
 #include <linux/compat.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -89,8 +90,14 @@ static struct megasas_mgmt_info megasas_
 static struct fasync_struct *megasas_async_queue;
 static DEFINE_MUTEX(megasas_async_queue_mutex);
 
+static int megasas_poll_wait_aen;
+static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
+
 static u32 megasas_dbg_lvl;
 
+/* define lock for aen poll */
+spinlock_t poll_aen_lock;
+
 static void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		     u8 alt_status);
@@ -1292,11 +1299,17 @@ megasas_bios_param(struct scsi_device *s
 static void
 megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
+	unsigned long flags;
 	/*
 	 * Don't signal app if it is just an aborted previously registered aen
 	 */
-	if (!cmd->abort_aen)
+	if ((!cmd->abort_aen) && (instance->unload == 0)) {
+		spin_lock_irqsave(&poll_aen_lock, flags);
+		megasas_poll_wait_aen = 1;
+		spin_unlock_irqrestore(&poll_aen_lock, flags);
+		wake_up(&megasas_poll_wait);
 		kill_fasync(&megasas_async_queue, SIGIO, POLL_IN);
+	}
 	else
 		cmd->abort_aen = 0;
 
@@ -1381,6 +1394,7 @@ megasas_complete_cmd(struct megasas_inst
 {
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
+	unsigned long flags;
 
 	if (cmd->scmd)
 		cmd->scmd->SCp.ptr = NULL;
@@ -1470,6 +1484,12 @@ megasas_complete_cmd(struct megasas_inst
 	case MFI_CMD_SMP:
 	case MFI_CMD_STP:
 	case MFI_CMD_DCMD:
+		if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
+			cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET) {
+			spin_lock_irqsave(&poll_aen_lock, flags);
+			megasas_poll_wait_aen = 0;
+			spin_unlock_irqrestore(&poll_aen_lock, flags);
+		}
 
 		/*
 		 * See if got an event notification
@@ -2583,6 +2603,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 
 	*instance->producer = 0;
 	*instance->consumer = 0;
+	megasas_poll_wait_aen = 0;
 
 	instance->evt_detail = pci_alloc_consistent(pdev,
 						    sizeof(struct
@@ -2607,6 +2628,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->completion_lock);
+	spin_lock_init(&poll_aen_lock);
 
 	mutex_init(&instance->aen_mutex);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
@@ -2621,6 +2643,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 
 	megasas_dbg_lvl = 0;
 	instance->flag = 0;
+	instance->unload = 0;
 	instance->last_time = 0;
 
 	/*
@@ -2924,6 +2947,7 @@ static void __devexit megasas_detach_one
 	struct megasas_instance *instance;
 
 	instance = pci_get_drvdata(pdev);
+	instance->unload = 1;
 	host = instance->host;
 
 	if (poll_mode_io)
@@ -3027,6 +3051,23 @@ static int megasas_mgmt_fasync(int fd, s
 }
 
 /**
+ * megasas_mgmt_poll -  char node "poll" entry point
+ * */
+static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
+{
+	unsigned int mask;
+	unsigned long flags;
+	poll_wait(file, &megasas_poll_wait, wait);
+	spin_lock_irqsave(&poll_aen_lock, flags);
+	if (megasas_poll_wait_aen)
+		mask =   (POLLIN | POLLRDNORM);
+	else
+		mask = 0;
+	spin_unlock_irqrestore(&poll_aen_lock, flags);
+	return mask;
+}
+
+/**
  * megasas_mgmt_fw_ioctl -	Issues management ioctls to FW
  * @instance:			Adapter soft state
  * @argp:			User's ioctl packet
@@ -3067,6 +3108,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 */
 	memcpy(cmd->frame, ioc->frame.raw, 2 * MEGAMFI_FRAME_SIZE);
 	cmd->frame->hdr.context = cmd->index;
+	cmd->frame->hdr.pad_0 = 0;
 
 	/*
 	 * The management interface between applications and the fw uses
@@ -3348,6 +3390,7 @@ static const struct file_operations mega
 	.open = megasas_mgmt_open,
 	.fasync = megasas_mgmt_fasync,
 	.unlocked_ioctl = megasas_mgmt_ioctl,
+	.poll = megasas_mgmt_poll,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = megasas_mgmt_compat_ioctl,
 #endif
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h	2009-06-10 14:31:17.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h	2009-09-13 09:27:23.000000000 -0400
@@ -1120,6 +1120,7 @@ struct megasas_instance {
 	struct tasklet_struct isr_tasklet;
 
 	u8 flag;
+	u8 unload;
 	unsigned long last_time;
 
 	struct timer_list io_completion_timer;

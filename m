From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/10] scsi: megaraid_sas - Add Poll Wait mechanism to
 MegaRAID SAS driver (PART-I)
Date: Tue, 5 May 2009 18:25:55 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C3E@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C22@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:44877 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZEFA0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 20:26:38 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C22@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Add Poll_wait mechanism to SAS-2 MegaRAID SAS Linux driver. Driver will wakeup poll after the driver get event from MegaRAID SAS FW.  Driver also reregisters for Event with the FW when it receives AEN.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  136 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   18 ++++
 2 files changed, 153 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 20:10:20.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 20:11:52.000000000 -0400
@@ -40,6 +40,7 @@
 #include <linux/compat.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>

 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -89,6 +90,9 @@ static struct megasas_mgmt_info megasas_
 static struct fasync_struct *megasas_async_queue;
 static DEFINE_MUTEX(megasas_async_queue_mutex);

+static int megasas_poll_wait_aen;
+static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
+
 static u32 megasas_dbg_lvl;

 static void
@@ -1277,6 +1281,8 @@ megasas_bios_param(struct scsi_device *s
        return 0;
 }

+static void megasas_aen_polling(struct megasas_instance *instance);
+
 /**
  * megasas_service_aen -       Processes an event notification
  * @instance:                  Adapter soft state
@@ -1295,13 +1301,20 @@ megasas_service_aen(struct megasas_insta
        /*
         * Don't signal app if it is just an aborted previously registered aen
         */
-       if (!cmd->abort_aen)
+       if ((!cmd->abort_aen) && (instance->unload == 0)) {
+               megasas_poll_wait_aen = 1;
+               wake_up(&megasas_poll_wait);
                kill_fasync(&megasas_async_queue, SIGIO, POLL_IN);
+       }
        else
                cmd->abort_aen = 0;

        instance->aen_cmd = NULL;
        megasas_return_cmd(instance, cmd);
+
+       if ((!cmd->abort_aen) && (instance->unload == 0)) {
+               megasas_aen_polling(instance);
+       }
 }

 /*
@@ -2583,6 +2596,8 @@ megasas_probe_one(struct pci_dev *pdev,

        *instance->producer = 0;
        *instance->consumer = 0;
+       megasas_poll_wait_aen = 0;
+       instance->hotplug_wk = NULL;

        instance->evt_detail = pci_alloc_consistent(pdev,
                                                    sizeof(struct
@@ -2621,6 +2636,7 @@ megasas_probe_one(struct pci_dev *pdev,

        megasas_dbg_lvl = 0;
        instance->flag = 0;
+       instance->unload = 0;
        instance->last_time = 0;

        /*
@@ -2924,6 +2940,7 @@ static void __devexit megasas_detach_one
        struct megasas_instance *instance;

        instance = pci_get_drvdata(pdev);
+       instance->unload = 1;
        host = instance->host;

        if (poll_mode_io)
@@ -2932,6 +2949,15 @@ static void __devexit megasas_detach_one
        scsi_remove_host(instance->host);
        megasas_flush_cache(instance);
        megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
+
+       /*
+       * cancel the delayed work if this work still in queue
+       */
+       if (instance->hotplug_wk != NULL) {
+               cancel_delayed_work(
+                       (struct delayed_work *)instance->hotplug_wk);
+               flush_scheduled_work();
+       }
        tasklet_kill(&instance->isr_tasklet);

        /*
@@ -3027,6 +3053,19 @@ static int megasas_mgmt_fasync(int fd, s
 }

 /**
+ * megasas_mgmt_poll -  char node "poll" entry point
+ * */
+static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
+{
+       unsigned int mask = 0;
+       poll_wait(file, &megasas_poll_wait, wait);
+       if (megasas_poll_wait_aen) {
+               mask |=   (POLLIN | POLLRDNORM);
+       }
+       return mask;
+}
+
+/**
  * megasas_mgmt_fw_ioctl -     Issues management ioctls to FW
  * @instance:                  Adapter soft state
  * @argp:                      User's ioctl packet
@@ -3348,6 +3387,7 @@ static const struct file_operations mega
        .open = megasas_mgmt_open,
        .fasync = megasas_mgmt_fasync,
        .unlocked_ioctl = megasas_mgmt_ioctl,
+       .poll = megasas_mgmt_poll,
 #ifdef CONFIG_COMPAT
        .compat_ioctl = megasas_mgmt_compat_ioctl,
 #endif
@@ -3462,6 +3502,100 @@ out:
        return retval;
 }

+static void
+megasas_scsi_scan_host(struct work_struct *work)
+{
+       struct megasas_aen_event *ev = container_of(work,
+               struct megasas_aen_event, hotplug_work);
+       struct megasas_instance *instance = ev->instance;
+
+       instance->hotplug_wk = NULL;
+       if (!instance) {
+               printk(KERN_ERR "%s: invalid instance!\n", __FUNCTION__);
+               kfree(ev);
+               return;
+       }
+
+       printk(KERN_INFO "%s[%d]: scanning ...\n",
+               __FUNCTION__, instance->host->host_no);
+       scsi_scan_host(instance->host);
+       kfree(ev);
+}
+
+static void
+megasas_aen_polling(struct megasas_instance *instance)
+{
+       union megasas_evt_class_locale class_locale;
+       int doscan = 0;
+       u32 seq_num;
+       int error;
+
+       if (instance->evt_detail) {
+               printk(KERN_INFO "%s[%d]: event code 0x%04x\n", __FUNCTION__,
+                       instance->host->host_no, instance->evt_detail->code);
+
+               switch (instance->evt_detail->code) {
+
+               case MR_EVT_LD_CREATED:
+               case MR_EVT_PD_INSERTED:
+               case MR_EVT_LD_DELETED:
+               case MR_EVT_LD_OFFLINE:
+               case MR_EVT_CFG_CLEARED:
+               case MR_EVT_PD_REMOVED:
+               case MR_EVT_FOREIGN_CFG_IMPORTED:
+               case MR_EVT_LD_STATE_CHANGE:
+               case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
+                       doscan = 1;
+                       break;
+               default:
+                       doscan = 0;
+                       break;
+               }
+       } else {
+               printk(KERN_ERR "%s[%d]: invalid evt_detail!\n",
+                       __FUNCTION__, instance->host->host_no);
+               return;
+       }
+
+       if (doscan) {
+               struct megasas_aen_event *ev;
+               ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+               if (!ev) {
+                       printk(KERN_ERR "%s: out of memory\n", __FUNCTION__);
+               } else {
+                       ev->instance = instance;
+                       instance->hotplug_wk = &ev->hotplug_work;
+                       INIT_WORK(&ev->hotplug_work, megasas_scsi_scan_host);
+                       schedule_delayed_work(
+                               (struct delayed_work *)&ev->hotplug_work, 0);
+               }
+       }
+
+       seq_num = instance->evt_detail->seq_num + 1;
+
+       /**
+       * Register AEN with FW for latest sequence number plus 1
+       **/
+
+       class_locale.members.reserved = 0;
+       class_locale.members.locale = MR_EVT_LOCALE_ALL;
+       class_locale.members.class = MR_EVT_CLASS_DEBUG;
+
+       if ( instance->aen_cmd != NULL ) {
+               return ;
+       }
+
+       mutex_lock(&instance->aen_mutex);
+       error = megasas_register_aen(instance, seq_num,
+                               class_locale.word);
+       mutex_unlock(&instance->aen_mutex);
+
+       if (error)
+               printk(KERN_ERR "%s[%d]: register aen failed error %x\n",
+                        __FUNCTION__, instance->host->host_no, error);
+}
+
+
 static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
                megasas_sysfs_show_poll_mode_io,
                megasas_sysfs_set_poll_mode_io);
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-05-04 20:10:21.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-05-04 20:00:31.000000000 -0400
@@ -132,6 +132,17 @@
 #define MR_DCMD_CLUSTER_RESET_ALL              0x08010100
 #define MR_DCMD_CLUSTER_RESET_LD               0x08010200

+#define MR_EVT_CFG_CLEARED                     0x0004
+
+#define MR_EVT_LD_STATE_CHANGE                 0x0051
+#define MR_EVT_PD_INSERTED                     0x005b
+#define MR_EVT_PD_REMOVED                      0x0070
+#define MR_EVT_LD_CREATED                      0x008a
+#define MR_EVT_LD_DELETED                      0x008b
+#define MR_EVT_FOREIGN_CFG_IMPORTED            0x00db
+#define MR_EVT_LD_OFFLINE                      0x00fc
+#define MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED     0x0152
+
 /*
  * MFI command completion codes
  */
@@ -1072,6 +1083,11 @@ struct megasas_evt_detail {
        u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
  };

+struct megasas_aen_event {
+       struct work_struct hotplug_work;
+       struct megasas_instance *instance;
+};
+
 struct megasas_instance {

        u32 *producer;
@@ -1118,8 +1134,10 @@ struct megasas_instance {

        struct megasas_instance_template *instancet;
        struct tasklet_struct isr_tasklet;
+       struct work_struct *hotplug_wk;

        u8 flag;
+       u8 unload;
        unsigned long last_time;

        struct timer_list io_completion_timer;

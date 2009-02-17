From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/9] scsi: megaraid_sas - Add poll wait support to megaraid
 sas driver - I
Date: Tue, 17 Feb 2009 08:25:07 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FB3B@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FB03@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:44117 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZBQPZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 10:25:26 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FB03@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>li
Cc: "Austria, Winston" <Winston.Austria@lsi.com>

Add Poll_wait mechanism to Gen-2 MegaRAID SAS Linux driver.  In the aen handler, driver needs to wakeup poll handler similar to the way it raises SIGIO.  Driver needs to reregister for AEN with the FW when it receives AEN.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  133 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   15 +++
 2 files changed, 147 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 15:36:36.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 15:39:26.000000000 -0500
@@ -40,6 +40,7 @@
 #include <linux/compat.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>

 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -89,6 +90,11 @@ static struct megasas_mgmt_info megasas_
 static struct fasync_struct *megasas_async_queue;
 static DEFINE_MUTEX(megasas_async_queue_mutex);

+static int megasas_poll_wait_aen;
+static DECLARE_WAIT_QUEUE_HEAD (megasas_poll_wait);
+extern void
+poll_wait(struct file *filp, wait_queue_head_t *q, poll_table *token);
+
 static u32 megasas_dbg_lvl;

 static void
@@ -1277,6 +1283,8 @@ megasas_bios_param(struct scsi_device *s
        return 0;
 }

+static void megasas_aen_polling(void *arg);
+
 /**
  * megasas_service_aen -       Processes an event notification
  * @instance:                  Adapter soft state
@@ -1295,8 +1303,20 @@ megasas_service_aen(struct megasas_insta
        /*
         * Don't signal app if it is just an aborted previously registered aen
         */
-       if (!cmd->abort_aen)
+       if ((!cmd->abort_aen) && (instance->unload == 0)) {
+               struct megasas_aen_event *ev;
+               ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+               if (!ev) {
+                       printk(KERN_ERR "%s: out of memory\n", __FUNCTION__);
+               } else {
+                       ev->instance = instance;
+                       INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
+                       schedule_delayed_work(&ev->hotplug_work, 0);
+               }
+               megasas_poll_wait_aen = 1;
+               wake_up(&megasas_poll_wait);
                kill_fasync(&megasas_async_queue, SIGIO, POLL_IN);
+       }
        else
                cmd->abort_aen = 0;

@@ -2621,6 +2641,7 @@ megasas_probe_one(struct pci_dev *pdev,

        megasas_dbg_lvl = 0;
        instance->flag = 0;
+       instance->unload = 0;
        instance->last_time = 0;

        /*
@@ -2924,6 +2945,7 @@ static void __devexit megasas_detach_one
        struct megasas_instance *instance;

        instance = pci_get_drvdata(pdev);
+       instance->unload = 1;
        host = instance->host;

        if (poll_mode_io)
@@ -3027,6 +3049,21 @@ static int megasas_mgmt_fasync(int fd, s
 }

 /**
+ * megasas_mgmt_poll -  char node "poll" entry point
+ * */
+static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
+{
+       unsigned int mask = 0;
+       poll_wait(file, &megasas_poll_wait, wait);
+
+       if (megasas_poll_wait_aen) {
+               mask |=   (POLLIN | POLLRDNORM);
+               megasas_poll_wait_aen = 0;
+       }
+       return mask;
+}
+
+/**
  * megasas_mgmt_fw_ioctl -     Issues management ioctls to FW
  * @instance:                  Adapter soft state
  * @argp:                      User's ioctl packet
@@ -3348,6 +3385,7 @@ static const struct file_operations mega
        .open = megasas_mgmt_open,
        .fasync = megasas_mgmt_fasync,
        .unlocked_ioctl = megasas_mgmt_ioctl,
+       .poll = megasas_mgmt_poll,
 #ifdef CONFIG_COMPAT
        .compat_ioctl = megasas_mgmt_compat_ioctl,
 #endif
@@ -3462,6 +3500,99 @@ out:
        return retval;
 }

+
+static void
+megasas_aen_polling(struct work_struct *work)
+{
+       struct megasas_aen_event *ev =
+               container_of(work, struct megasas_aen_event, hotplug_work);
+       struct megasas_instance *instance = ev->instance;
+       struct megasas_evt_log_info eli;
+       union megasas_evt_class_locale class_locale;
+       int doscan = 0;
+       u32 seq_num;
+       int error;
+
+       if (!instance) {
+               printk(KERN_ERR "%s: invalid instance!\n", __FUNCTION__);
+               kfree(ev);
+               return;
+       }
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
+                       doscan = 1;
+                       break;
+               default:
+                       doscan = 0;
+                       break;
+               }
+       } else {
+               printk(KERN_ERR "%s[%d]: invalid evt_detail!\n",
+                       __FUNCTION__, instance->host->host_no);
+               kfree(ev);
+               return;
+       }
+
+       if (doscan) {
+               printk(KERN_INFO "%s[%d]: scanning ...\n",
+                       __FUNCTION__, instance->host->host_no);
+               scsi_scan_host(instance->host);
+               msleep(1000);
+       }
+
+       kfree(ev);
+       /**
+       * Get the latest sequence number from FW
+       **/
+
+       memset(&eli, 0, sizeof(eli));
+
+       if (megasas_get_seq_num(instance, &eli)) {
+               printk(KERN_ERR "%s[%d]: failed to get seq_num\n",
+                       __FUNCTION__, instance->host->host_no);
+               return;
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
+       down(&instance->aen_mutex);
+
+       error = megasas_register_aen(instance, seq_num,
+                               class_locale.word);
+
+       up(&instance->aen_mutex);
+
+       if (error)
+               printk(KERN_ERR "%s[%d]: register aen failed error %x\n",
+                        __FUNCTION__, instance->host->host_no, error);
+       else
+               printk(KERN_INFO "%s[%d]: aen registered\n",
+                       __FUNCTION__, instance->host->host_no);
+
+}
+
+
 static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
                megasas_sysfs_show_poll_mode_io,
                megasas_sysfs_set_poll_mode_io);
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 15:36:37.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 15:24:58.000000000 -0500
@@ -132,6 +132,16 @@
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
+
 /*
  * MFI command completion codes
  */
@@ -1072,6 +1082,11 @@ struct megasas_evt_detail {
        u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
  };

+struct megasas_aen_event {
+       struct work_struct hotplug_work;
+       struct megasas_instance *instance;
+};
+
 struct megasas_instance {

        u32 *producer;

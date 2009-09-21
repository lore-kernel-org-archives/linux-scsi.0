From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 10/12] scsi: megaraid_sas - Add the support for updating the
 OS after adding/removing the devices form FW.
Date: Sun, 20 Sep 2009 20:45:27 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C512406@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119CF@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50536 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbZIUCpi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2009 22:45:38 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5119CF@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Driver will update the OS devices after adding and deleting the device from FW.  When driver receive add or delete AEN from FW, driver will send the DCMD cmd to get the System PD list from FW.  Then driver will check if this device already in the OS: If add event and OS don't have the device (but it is in the list), driver add the device to OS, otherwise driver will not add.  If remove event, driver will check the list, if is not in the list, but OS have the device, driver will remove the device.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---

drivers/scsi/megaraid/megaraid_sas.c |  125 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   17 ++++
 2 files changed, 141 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-09-15 03:45:14.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-09-15 04:18:58.000000000 -0400
@@ -1520,6 +1520,8 @@ megasas_bios_param(struct scsi_device *s
        return 0;
 }

+static void megasas_aen_polling(struct work_struct *work);
+
 /**
  * megasas_service_aen -       Processes an event notification
  * @instance:                  Adapter soft state
@@ -1551,6 +1553,20 @@ megasas_service_aen(struct megasas_insta

        instance->aen_cmd = NULL;
        megasas_return_cmd(instance, cmd);
+
+       if (instance->unload == 0) {
+               struct megasas_aen_event *ev;
+               ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+               if (!ev) {
+                       printk(KERN_ERR "megasas_service_aen: out of memory\n");
+               } else {
+                       ev->instance = instance;
+                       instance->ev = ev;
+                       INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
+                       schedule_delayed_work(
+                               (struct delayed_work *)&ev->hotplug_work, 0);
+               }
+       }
 }

 /*
@@ -2075,6 +2091,7 @@ static int megasas_create_frame_pool(str
                }

                cmd->frame->io.context = cmd->index;
+               cmd->frame->io.pad_0 = 0;
        }

        return 0;
@@ -2271,7 +2288,6 @@ megasas_get_pd_list(struct megasas_insta
        return ret;
 }

-
 /**
  * megasas_get_controller_info -       Returns FW's controller structure
  * @instance:                          Adapter soft state
@@ -2986,6 +3002,7 @@ megasas_probe_one(struct pci_dev *pdev,
        *instance->consumer = 0;
        megasas_poll_wait_aen = 0;
        instance->flag_ieee = 0;
+       instance->ev = NULL;

        instance->evt_detail = pci_alloc_consistent(pdev,
                                                    sizeof(struct
@@ -3209,6 +3226,16 @@ megasas_suspend(struct pci_dev *pdev, pm

        megasas_flush_cache(instance);
        megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
+
+       /* cancel the delayed work if this work still in queue */
+       if (instance->ev != NULL) {
+               struct megasas_aen_event *ev = instance->ev;
+               cancel_delayed_work(
+                       (struct delayed_work *)&ev->hotplug_work);
+               flush_scheduled_work();
+               instance->ev = NULL;
+       }
+
        tasklet_kill(&instance->isr_tasklet);

        pci_set_drvdata(instance->pdev, instance);
@@ -3349,6 +3376,16 @@ static void __devexit megasas_detach_one
        scsi_remove_host(instance->host);
        megasas_flush_cache(instance);
        megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
+
+       /* cancel the delayed work if this work still in queue*/
+       if (instance->ev != NULL) {
+               struct megasas_aen_event *ev = instance->ev;
+               cancel_delayed_work(
+                       (struct delayed_work *)&ev->hotplug_work);
+               flush_scheduled_work();
+               instance->ev = NULL;
+       }
+
        tasklet_kill(&instance->isr_tasklet);

        /*
@@ -3913,6 +3950,92 @@ out:
        return retval;
 }

+static void
+megasas_aen_polling(struct work_struct *work)
+{
+       struct megasas_aen_event *ev =
+               container_of(work, struct megasas_aen_event, hotplug_work);
+       struct megasas_instance *instance = ev->instance;
+       union megasas_evt_class_locale class_locale;
+       struct  Scsi_Host *host;
+       struct  scsi_device *sdev1;
+       u16     pd_index = 0;
+       int     i, j, doscan = 0;
+       u32 seq_num;
+       int error;
+
+       if (!instance) {
+               printk(KERN_ERR "invalid instance!\n");
+               kfree(ev);
+               return;
+       }
+       instance->ev = NULL;
+       host = instance->host;
+       if (instance->evt_detail) {
+
+               switch (instance->evt_detail->code) {
+               case MR_EVT_PD_INSERTED:
+               case MR_EVT_PD_REMOVED:
+               case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
+                       doscan = 1;
+                       break;
+               default:
+                       doscan = 0;
+                       break;
+               }
+       } else {
+               printk(KERN_ERR "invalid evt_detail!\n");
+               kfree(ev);
+               return;
+       }
+
+       if (doscan) {
+               printk(KERN_INFO "scanning ...\n");
+               megasas_get_pd_list(instance);
+               for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
+                       for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+                               pd_index = i*MEGASAS_MAX_DEV_PER_CHANNEL + j;
+                               sdev1 = scsi_device_lookup(host, i, j, 0);
+                               if (instance->pd_list[pd_index].driveState ==
+                                                       MR_PD_STATE_SYSTEM) {
+                                       if (!sdev1) {
+                                               scsi_add_device(host, i, j, 0);
+                                       }
+                                       if (sdev1)
+                                               scsi_device_put(sdev1);
+                               } else {
+                                       if (sdev1) {
+                                               scsi_remove_device(sdev1);
+                                               scsi_device_put(sdev1);
+                                       }
+                               }
+                       }
+               }
+       }
+
+       if ( instance->aen_cmd != NULL ) {
+               kfree(ev);
+               return ;
+       }
+
+       seq_num = instance->evt_detail->seq_num + 1;
+
+       /* Register AEN with FW for latest sequence number plus 1 */
+       class_locale.members.reserved = 0;
+       class_locale.members.locale = MR_EVT_LOCALE_ALL;
+       class_locale.members.class = MR_EVT_CLASS_DEBUG;
+       mutex_lock(&instance->aen_mutex);
+       error = megasas_register_aen(instance, seq_num,
+                                       class_locale.word);
+       mutex_unlock(&instance->aen_mutex);
+
+       if (error)
+               printk(KERN_ERR "register aen failed error %x\n", error);
+
+       kfree(ev);
+}
+
+
 static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
                megasas_sysfs_show_poll_mode_io,
                megasas_sysfs_set_poll_mode_io);
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-09-15 03:45:14.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-09-15 04:23:57.000000000 -0400
@@ -285,6 +285,17 @@ enum MR_PD_QUERY_TYPE {
        MR_PD_QUERY_TYPE_EXPOSED_TO_HOST    = 5,
 };

+#define MR_EVT_CFG_CLEARED                              0x0004
+#define MR_EVT_LD_STATE_CHANGE                          0x0051
+#define MR_EVT_PD_INSERTED                              0x005b
+#define MR_EVT_PD_REMOVED                               0x0070
+#define MR_EVT_LD_CREATED                               0x008a
+#define MR_EVT_LD_DELETED                               0x008b
+#define MR_EVT_FOREIGN_CFG_IMPORTED                     0x00db
+#define MR_EVT_LD_OFFLINE                               0x00fc
+#define MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED             0x0152
+#define MAX_LOGICAL_DRIVES                             64
+
 enum MR_PD_STATE {
        MR_PD_STATE_UNCONFIGURED_GOOD   = 0x00,
        MR_PD_STATE_UNCONFIGURED_BAD    = 0x01,
@@ -1157,6 +1168,11 @@ struct megasas_evt_detail {

 } __attribute__ ((packed));

+struct megasas_aen_event {
+       struct work_struct hotplug_work;
+       struct megasas_instance *instance;
+};
+
struct megasas_instance {

        u32 *producer;
@@ -1176,6 +1192,7 @@ struct megasas_instance {
        u16 max_num_sge;
        u16 max_fw_cmds;
        u32 max_sectors_per_req;
+       struct megasas_aen_event *ev;

        struct megasas_cmd **cmd_list;
        struct list_head cmd_pool;

From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 8/9] scsi: megaraid_sas - Add the IEEE SGL support to the
 driver
Date: Tue, 17 Feb 2009 10:31:10 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FC5B@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FC48@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:43562 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZBQRb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 12:31:29 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FC48@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>li
Cc: "Austria, Winston" <Winston.Austria@lsi.com>

Add the IEEE SGL support to MegaRAID SAS driver

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  125 ++++++++++++++++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas.h |   13 +++
 2 files changed, 107 insertions(+), 31 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 16:36:41.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 17:24:26.000000000 -0500
@@ -698,6 +698,35 @@ megasas_make_sgl64(struct megasas_instan
        return sge_count;
 }

+/**
+ * megasas_make_sgl64 -        Prepares 64-bit SGL
+ * @instance:          Adapter soft state
+ * @scp:               SCSI command from the mid-layer
+ * @mfi_sgl:           SGL to be filled in
+ *
+ * If successful, this function returns the number of SG elements. Otherwise,
+ * it returnes -1.
+ */
+static int
+megasas_make_sgl_skinny(struct megasas_instance *instance,
+               struct scsi_cmnd *scp, union megasas_sgl *mfi_sgl)
+{
+       int i;
+       int sge_count;
+       struct scatterlist *os_sgl;
+
+       sge_count = scsi_dma_map(scp);
+       BUG_ON(sge_count < 0);
+
+       if (sge_count) {
+               scsi_for_each_sg(scp, os_sgl, sge_count, i) {
+                 mfi_sgl->sge_skinny[i].length = sg_dma_len(os_sgl);
+                 mfi_sgl->sge_skinny[i].phys_addr = sg_dma_address(os_sgl);
+               }
+       }
+       return sge_count;
+}
+
  /**
  * megasas_get_frame_count - Computes the number of frames
  * @frame_type         : type of frame- io or pthru frame
@@ -706,7 +735,8 @@ megasas_make_sgl64(struct megasas_instan
  * Returns the number of frames required for numnber of sge's (sge_count)
  */

-static u32 megasas_get_frame_count(u8 sge_count, u8 frame_type)
+static u32 megasas_get_frame_count(struct megasas_instance *instance,
+                       u8 sge_count, u8 frame_type)
 {
        int num_cnt;
        int sge_bytes;
@@ -716,6 +746,10 @@ static u32 megasas_get_frame_count(u8 sg
        sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
            sizeof(struct megasas_sge32);

+       if (instance->flag_ieee) {
+               sge_sz = sizeof(struct megasas_sge_skinny);
+       }
+
        /*
         * Main frame can contain 2 SGEs for 64-bit SGLs and
         * 3 SGEs for 32-bit SGLs for ldio &
@@ -723,12 +757,16 @@ static u32 megasas_get_frame_count(u8 sg
         * 2 SGEs for 32-bit SGLs for pthru frame
         */
        if (unlikely(frame_type == PTHRU_FRAME)) {
-               if (IS_DMA64)
+               if (instance->flag_ieee == 1) {
+                       num_cnt = sge_count - 1;
+               } else if (IS_DMA64)
                        num_cnt = sge_count - 1;
                else
                        num_cnt = sge_count - 2;
        } else {
-               if (IS_DMA64)
+               if (instance->flag_ieee == 1) {
+                       num_cnt = sge_count - 1;
+               } else if (IS_DMA64)
                        num_cnt = sge_count - 2;
                else
                        num_cnt = sge_count - 3;
@@ -777,6 +815,10 @@ megasas_build_dcdb(struct megasas_instan
        else if (scp->sc_data_direction == PCI_DMA_NONE)
                flags = MFI_FRAME_DIR_NONE;

+       if (instance->flag_ieee == 1) {
+               flags = MFI_FRAME_IEEE;
+       }
+
        /*
         * Prepare the DCDB frame
         */
@@ -806,7 +848,12 @@ megasas_build_dcdb(struct megasas_instan
        /*
         * Construct SGL
         */
-       if (IS_DMA64) {
+       if (instance->flag_ieee == 1) {
+               pthru->flags |= MFI_FRAME_SGL64;
+               pthru->sge_count = megasas_make_sgl_skinny(instance, scp,
+                                                     &pthru->sgl);
+
+       } else if (IS_DMA64) {
                pthru->flags |= MFI_FRAME_SGL64;
                pthru->sge_count = megasas_make_sgl64(instance, scp,
                                                      &pthru->sgl);
@@ -825,7 +872,7 @@ megasas_build_dcdb(struct megasas_instan
         * Compute the total number of frames this command consumes. FW uses
         * this number to pull sufficient number of frames from host memory.
         */
-       cmd->frame_count = megasas_get_frame_count(pthru->sge_count,
+       cmd->frame_count = megasas_get_frame_count(instance, pthru->sge_count,
                                                        PTHRU_FRAME);

        return cmd->frame_count;
@@ -856,6 +903,10 @@ megasas_build_ldio(struct megasas_instan
        else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
                flags = MFI_FRAME_DIR_READ;

+       if (instance->flag_ieee == 1) {
+               flags = MFI_FRAME_IEEE;
+       }
+
        /*
         * Prepare the Logical IO frame: 2nd bit is zero for all read cmds
         */
@@ -926,7 +977,11 @@ megasas_build_ldio(struct megasas_instan
        /*
         * Construct SGL
         */
-       if (IS_DMA64) {
+       if (instance->flag_ieee) {
+               ldio->flags |= MFI_FRAME_SGL64;
+               ldio->sge_count = megasas_make_sgl_skinny(instance, scp,
+                                             &ldio->sgl);
+       } else if (IS_DMA64) {
                ldio->flags |= MFI_FRAME_SGL64;
                ldio->sge_count = megasas_make_sgl64(instance, scp, &ldio->sgl);
        } else
@@ -943,7 +998,8 @@ megasas_build_ldio(struct megasas_instan
         * Compute the total number of frames this command consumes. FW uses
         * this number to pull sufficient number of frames from host memory.
         */
-       cmd->frame_count = megasas_get_frame_count(ldio->sge_count, IO_FRAME);
+       cmd->frame_count = megasas_get_frame_count(instance,
+                       ldio->sge_count, IO_FRAME);

        return cmd->frame_count;
 }
@@ -1117,6 +1173,20 @@ megasas_queue_command(struct scsi_cmnd *
        return 0;
 }

+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+       int i;
+
+       for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+
+               if ((megasas_mgmt_info.instance[i]) &&
+                   (megasas_mgmt_info.instance[i]->host->host_no == host_no))
+                       return megasas_mgmt_info.instance[i];
+       }
+
+       return NULL;
+}
+
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
        u16             pd_index = 0;
@@ -1143,6 +1213,7 @@ static int megasas_slave_configure(struc
                }

                return -ENXIO;
+       }

        /*
         * The RAID firmware may require extended timeouts.
@@ -1405,7 +1476,7 @@ megasas_bios_param(struct scsi_device *s
        return 0;
 }

-static void megasas_aen_polling(void *arg);
+static void megasas_aen_polling(struct work_struct *work);

 /**
  * megasas_service_aen -       Processes an event notification
@@ -1433,7 +1504,8 @@ megasas_service_aen(struct megasas_insta
                } else {
                        ev->instance = instance;
                        INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
-                       schedule_delayed_work(&ev->hotplug_work, 0);
+                       schedule_delayed_work(
+                               (struct delayed_work *)&ev->hotplug_work, 0);
                }
                megasas_poll_wait_aen = 1;
                wake_up(&megasas_poll_wait);
@@ -1917,6 +1989,10 @@ static int megasas_create_frame_pool(str
        sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
            sizeof(struct megasas_sge32);

+       if (instance->flag_ieee) {
+               sge_sz = sizeof(struct megasas_sge_skinny);
+       }
+
        /*
         * Calculated the number of 64byte frames required for SGL
         */
@@ -3053,6 +3129,7 @@ megasas_probe_one(struct pci_dev *pdev,

        *instance->producer = 0;
        *instance->consumer = 0;
+       instance->flag_ieee = 0;

        instance->evt_detail = pci_alloc_consistent(pdev,
                                                    sizeof(struct
@@ -3079,11 +3156,6 @@ megasas_probe_one(struct pci_dev *pdev,
        spin_lock_init(&instance->completion_lock);

        mutex_init(&instance->aen_mutex);
-       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-               sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
-       } else
-               sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);

        /*
         * Initialize PCI related and misc parameters
@@ -3093,6 +3165,13 @@ megasas_probe_one(struct pci_dev *pdev,
        instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
        instance->init_id = MEGASAS_DEFAULT_INIT_ID;

+       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+               instance->flag_ieee = 1;
+               sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
+       } else
+               sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
+
        megasas_dbg_lvl = 0;
        instance->flag = 0;
        instance->unload = 0;
@@ -3683,20 +3762,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
        return error;
 }

-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-       int i;
-
-       for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-               if ((megasas_mgmt_info.instance[i]) &&
-                   (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-                       return megasas_mgmt_info.instance[i];
-       }
-
-       return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
        struct megasas_iocpacket __user *user_ioc =
@@ -4043,12 +4108,12 @@ megasas_aen_polling(struct work_struct *
        class_locale.members.locale = MR_EVT_LOCALE_ALL;
        class_locale.members.class = MR_EVT_CLASS_DEBUG;

-       down(&instance->aen_mutex);
+       mutex_lock(&instance->aen_mutex);

        error = megasas_register_aen(instance, seq_num,
                                class_locale.word);

-       up(&instance->aen_mutex);
+       mutex_unlock(&instance->aen_mutex);

        if (error)
                printk(KERN_ERR "%s[%d]: register aen failed error %x\n",
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 16:36:42.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 16:53:50.000000000 -0500
@@ -96,6 +96,7 @@
 #define MFI_FRAME_DIR_WRITE                    0x0008
 #define MFI_FRAME_DIR_READ                     0x0010
 #define MFI_FRAME_DIR_BOTH                     0x0018
+#define MFI_FRAME_IEEE                         0x0020

 /*
  * Definition for cmd_status
@@ -752,10 +753,19 @@ struct megasas_sge64 {

 } __attribute__ ((packed));

+struct megasas_sge_skinny {
+
+       u64 phys_addr;
+       u32 length;
+       u32 flag;
+
+} __attribute__ ((packed));
+
 union megasas_sgl {

        struct megasas_sge32 sge32[1];
        struct megasas_sge64 sge64[1];
+       struct megasas_sge64 sge_skinny[1];

 } __attribute__ ((packed));

@@ -1190,7 +1200,7 @@ struct megasas_aen_event {
 #define MEGASAS_SKINNY_MAX_NUM_MEM_BK          512

 struct megasas_skinny_mm_bk {
-       u32                     vir;
+       u32                     *vir;
        u32                     sz;
        dma_addr_t              paddr;
 };
@@ -1253,6 +1263,7 @@ struct megasas_instance {

        u8 flag;
        u8 unload;
+       u8 flag_ieee;
        unsigned long last_time;

        struct timer_list io_completion_timer;

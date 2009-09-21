From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 8/12] scsi: megaraid_sas - add the IEEE SGE support to SAS2
 controller
Date: Sun, 20 Sep 2009 20:43:25 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C512404@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119A4@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36851 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbZIUCnf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2009 22:43:35 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5119A4@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

To increase the performance, megaraid sas driver added the IEEE SGE support to support SAS2 controller.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   80 +++++++++++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas.h |    9 +++
 2 files changed, 82 insertions(+), 7 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-09-14 06:14:35.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-09-14 06:42:53.000000000 -0400
@@ -696,6 +696,35 @@ megasas_make_sgl64(struct megasas_instan
        return sge_count;
 }

+/**
+ * megasas_make_sgl_skinny - Prepares IEEE SGL
+ * @instance:           Adapter soft state
+ * @scp:                SCSI command from the mid-layer
+ * @mfi_sgl:            SGL to be filled in
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
+
+       if (sge_count) {
+               scsi_for_each_sg(scp, os_sgl, sge_count, i) {
+                       mfi_sgl->sge_skinny[i].length = sg_dma_len(os_sgl);
+                       mfi_sgl->sge_skinny[i].phys_addr =
+                                               sg_dma_address(os_sgl);
+               }
+       }
+       return sge_count;
+}
+
  /**
  * megasas_get_frame_count - Computes the number of frames
  * @frame_type         : type of frame- io or pthru frame
@@ -704,7 +733,8 @@ megasas_make_sgl64(struct megasas_instan
  * Returns the number of frames required for numnber of sge's (sge_count)
  */

-static u32 megasas_get_frame_count(u8 sge_count, u8 frame_type)
+static u32 megasas_get_frame_count(struct megasas_instance *instance,
+                       u8 sge_count, u8 frame_type)
 {
        int num_cnt;
        int sge_bytes;
@@ -714,6 +744,10 @@ static u32 megasas_get_frame_count(u8 sg
        sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
            sizeof(struct megasas_sge32);

+       if (instance->flag_ieee) {
+               sge_sz = sizeof(struct megasas_sge_skinny);
+       }
+
        /*
         * Main frame can contain 2 SGEs for 64-bit SGLs and
         * 3 SGEs for 32-bit SGLs for ldio &
@@ -721,12 +755,16 @@ static u32 megasas_get_frame_count(u8 sg
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
@@ -775,6 +813,10 @@ megasas_build_dcdb(struct megasas_instan
        else if (scp->sc_data_direction == PCI_DMA_NONE)
                flags = MFI_FRAME_DIR_NONE;

+       if (instance->flag_ieee == 1) {
+               flags |= MFI_FRAME_IEEE;
+       }
+
        /*
         * Prepare the DCDB frame
         */
@@ -804,7 +846,11 @@ megasas_build_dcdb(struct megasas_instan
        /*
         * Construct SGL
         */
-       if (IS_DMA64) {
+       if (instance->flag_ieee == 1) {
+               pthru->flags |= MFI_FRAME_SGL64;
+               pthru->sge_count = megasas_make_sgl_skinny(instance, scp,
+                                                     &pthru->sgl);
+       } else if (IS_DMA64) {
                pthru->flags |= MFI_FRAME_SGL64;
                pthru->sge_count = megasas_make_sgl64(instance, scp,
                                                      &pthru->sgl);
@@ -823,7 +869,7 @@ megasas_build_dcdb(struct megasas_instan
         * Compute the total number of frames this command consumes. FW uses
         * this number to pull sufficient number of frames from host memory.
         */
-       cmd->frame_count = megasas_get_frame_count(pthru->sge_count,
+       cmd->frame_count = megasas_get_frame_count(instance, pthru->sge_count,
                                                        PTHRU_FRAME);

        return cmd->frame_count;
@@ -854,6 +900,10 @@ megasas_build_ldio(struct megasas_instan
        else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
                flags = MFI_FRAME_DIR_READ;

+       if (instance->flag_ieee == 1) {
+               flags |= MFI_FRAME_IEEE;
+       }
+
        /*
         * Prepare the Logical IO frame: 2nd bit is zero for all read cmds
         */
@@ -924,7 +974,11 @@ megasas_build_ldio(struct megasas_instan
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
@@ -941,7 +995,8 @@ megasas_build_ldio(struct megasas_instan
         * Compute the total number of frames this command consumes. FW uses
         * this number to pull sufficient number of frames from host memory.
         */
-       cmd->frame_count = megasas_get_frame_count(ldio->sge_count, IO_FRAME);
+       cmd->frame_count = megasas_get_frame_count(instance,
+                       ldio->sge_count, IO_FRAME);

        return cmd->frame_count;
 }
@@ -1929,6 +1984,10 @@ static int megasas_create_frame_pool(str
        sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
            sizeof(struct megasas_sge32);

+       if (instance->flag_ieee) {
+               sge_sz = sizeof(struct megasas_sge_skinny);
+       }
+
        /*
         * Calculated the number of 64byte frames required for SGL
         */
@@ -2725,6 +2784,11 @@ megasas_register_aen(struct megasas_inst
        dcmd->sgl.sge32[0].phys_addr = (u32) instance->evt_detail_h;
        dcmd->sgl.sge32[0].length = sizeof(struct megasas_evt_detail);

+       if (instance->aen_cmd != NULL) {
+               megasas_return_cmd(instance, cmd);
+               return 0;
+       }
+
        /*
         * Store reference to the cmd used to register for AEN. When an
         * application wants us to register for AEN, we have to abort this
@@ -2895,6 +2959,7 @@ megasas_probe_one(struct pci_dev *pdev,
        *instance->producer = 0;
        *instance->consumer = 0;
        megasas_poll_wait_aen = 0;
+       instance->flag_ieee = 0;

        instance->evt_detail = pci_alloc_consistent(pdev,
                                                    sizeof(struct
@@ -2933,6 +2998,7 @@ megasas_probe_one(struct pci_dev *pdev,

        if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
                (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+               instance->flag_ieee = 1;
                sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
        } else
                sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-09-14 06:14:35.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-09-14 07:53:02.000000000 -0400
@@ -96,6 +96,7 @@
 #define MFI_FRAME_DIR_WRITE                    0x0008
 #define MFI_FRAME_DIR_READ                     0x0010
 #define MFI_FRAME_DIR_BOTH                     0x0018
+#define MFI_FRAME_IEEE                          0x0020

 /*
  * Definition for cmd_status
@@ -732,10 +733,17 @@ struct megasas_sge64 {

 } __attribute__ ((packed));

+struct megasas_sge_skinny {
+       u64 phys_addr;
+       u32 length;
+       u32 flag;
+} __packed;
+
 union megasas_sgl {

        struct megasas_sge32 sge32[1];
        struct megasas_sge64 sge64[1];
+       struct megasas_sge_skinny sge_skinny[1];

 } __attribute__ ((packed));

@@ -1210,6 +1218,7 @@ struct megasas_instance {

        u8 flag;
        u8 unload;
+       u8 flag_ieee;
        unsigned long last_time;

        struct timer_list io_completion_timer;

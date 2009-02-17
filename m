From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 5/9] scsi: megaraid_sas - Add memory support required by
 0x73 controller
Date: Tue, 17 Feb 2009 08:37:00 -0800
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FBD2@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FB75@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:46874 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZBQQhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 11:37:24 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FB75@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>li
Cc: "Austria, Winston" <Winston.Austria@lsi.com>

Add memory support required by 0x73 controller

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  164 +++++++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |   19 ++++
 2 files changed, 183 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 16:05:07.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 16:12:54.000000000 -0500
@@ -2039,6 +2039,144 @@ static int megasas_alloc_cmds(struct meg
 }

 /**
+ * megasas_skinny_mem_alloc:   allocation memory for 0x73 and 0x71 controller
+ * @instance:                  Adapter soft state
+ *
+ * this function will allocate the memory for 0.73 comtroller.
+ */
+static int
+megasas_skinny_mem_alloc(struct megasas_instance *instance)
+{
+       u8              i = 0, mem_alloc_done = 0;
+       u32             *virt, ind, num_bk = 0;
+       dma_addr_t      paddr;
+       u32              mem_alloc_size = MEGASAS_SKINNY_SZ_MEM_BK * 256;
+       u32             *mem_tb = instance->skinny_mm_tb;
+
+       instance->skinny_mm_tb = pci_alloc_consistent(instance->pdev,
+                                MEGASAS_SKINNY_MAX_NUM_MEM_BK*sizeof(u32),
+                                &instance->skinny_mm_tb_h);
+
+       memset(instance->skinny_mm_tb, 0,
+               MEGASAS_SKINNY_MAX_NUM_MEM_BK * sizeof(u32));
+
+       instance->skinny_mm_alloc_ind = 0;
+
+       while (!mem_alloc_done) {
+
+                       virt = pci_alloc_consistent(instance->pdev,
+                                                        mem_alloc_size,
+                                                        &paddr);
+                       if (virt) {
+                               num_bk = (mem_alloc_size/
+                                               MEGASAS_SKINNY_SZ_MEM_BK);
+
+                               for (ind = 0; ind < num_bk; ind++) {
+                                       if (instance->skinny_mm_alloc_ind <
+                                               MEGASAS_SKINNY_MAX_NUM_MEM_BK) {
+                                               *mem_tb = (u32)(paddr+
+                                               (MEGASAS_SKINNY_SZ_MEM_BK*ind));
+                                               mem_tb++;
+                                               instance->skinny_mm_alloc_ind++;
+                                       } else {
+                                               mem_alloc_done = 1;
+                                       }
+                               }
+
+                               instance->skinny_mm_bk[i].vir   = virt;
+                               instance->skinny_mm_bk[i].paddr = paddr;
+                               instance->skinny_mm_bk[i].sz = mem_alloc_size;
+                       } else {
+                               if (mem_alloc_size > MEGASAS_SKINNY_SZ_MEM_BK)
+                                       mem_alloc_size = mem_alloc_size / 2;
+                       }
+       }
+
+       if (instance->skinny_mm_alloc_ind == 0)
+               return -1;
+
+       return 0;
+}
+
+/**
+ * megasas_skinny_mem_alloc:   de-allocate memory for 0x73 and 0x71 controller
+ * @instance:                  Adapter soft state
+ *
+ * this function will de-allocate the memory for 0.73 comtroller.
+ */
+static void
+megasas_skinny_mem_dealloc(struct megasas_instance *instance)
+{
+       int i = 0;
+
+       for (i = 0; i < MEGASAS_SKINNY_MAX_NUM_MEM_BK; i++) {
+               if (instance->skinny_mm_bk[i].vir) {
+                       pci_free_consistent(instance->pdev,
+                               instance->skinny_mm_bk[i].sz,
+                               instance->skinny_mm_bk[i].vir,
+                               instance->skinny_mm_bk[i].paddr);
+               }
+       }
+
+       if (instance->skinny_mm_tb)
+               pci_free_consistent(instance->pdev,
+                       MEGASAS_SKINNY_MAX_NUM_MEM_BK * sizeof(u32),
+                       instance->skinny_mm_tb,
+                       instance->skinny_mm_tb_h);
+
+}
+
+/**
+ * megasas_mem_to_fw - Send requested memory to FW
+ * @instance:          Adapter soft state
+ *
+ * Issues an internal command (DCMD) to get the FW's controller structure.
+ * This information is mainly used to send out the memory table  to FW
+ */
+static int
+megasas_mem_to_fw(struct megasas_instance *instance)
+{
+       int ret = 0;
+       struct megasas_cmd *cmd;
+       struct megasas_dcmd_frame *dcmd;
+
+       cmd = megasas_get_cmd(instance);
+
+       if (!cmd) {
+               printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
+               return -ENOMEM;
+       }
+
+       dcmd = &cmd->frame->dcmd;
+
+       memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+       dcmd->mbox.s[0] = instance->skinny_mm_alloc_ind;
+       dcmd->mbox.s[2] = MEGASAS_SKINNY_SZ_MEM_BK / 1024;
+
+       dcmd->cmd = MFI_CMD_DCMD;
+       dcmd->cmd_status = 0xFF;
+       dcmd->sge_count = 1;
+       dcmd->flags = MFI_FRAME_DIR_READ;
+       dcmd->timeout = 0;
+       dcmd->data_xfer_len = sizeof(u32) * MEGASAS_SKINNY_MAX_NUM_MEM_BK;
+       dcmd->opcode = MR_DCMD_CTRL_MFI_HOST_MEM_ALLOC;
+       dcmd->sgl.sge32[0].phys_addr = instance->skinny_mm_tb_h;
+       dcmd->sgl.sge32[0].length = sizeof(u32) * MEGASAS_SKINNY_MAX_NUM_MEM_BK;
+
+       if (!megasas_issue_polled(instance, cmd)) {
+               ret = 0;
+
+       } else {
+               ret = -1;
+       }
+
+       megasas_return_cmd(instance, cmd);
+
+       return ret;
+}
+
+/**
  * megasas_get_controller_info -       Returns FW's controller structure
  * @instance:                          Adapter soft state
  * @ctrl_info:                         Controller information structure
@@ -2290,6 +2428,9 @@ static int megasas_init_mfi(struct megas
         * Get various operational parameters from status register
         */
        instance->max_fw_cmds = instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
+       instance->memory_need =
+               instance->instancet->read_fw_status_reg(reg_set) & 0x08000000;
+
        /*
         * Reduce the max supported cmds by 1. This is to ensure that the
         * reply_q_sz (1 more than the max cmd that driver may send)
@@ -2325,6 +2466,25 @@ static int megasas_init_mfi(struct megas
                goto fail_reply_queue;
        }

+       if (instance->memory_need) {
+               if ((instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+                       (instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+
+                       if (megasas_skinny_mem_alloc(instance)) {
+                               printk(KERN_DEBUG "megasas: failed "
+                                               "allocate mem\n");
+                               megasas_skinny_mem_dealloc(instance);
+                       }
+
+                       if (megasas_mem_to_fw(instance)) {
+                               printk(KERN_DEBUG "megasas: fail to "
+                                       "dcmd cmd to pass mem to fw\n");
+                       }
+               }
+       }
+
        if (megasas_issue_init_mfi(instance))
                goto fail_fw_init;

@@ -3110,6 +3270,10 @@ static void __devexit megasas_detach_one

        free_irq(instance->pdev->irq, instance);

+       if (instance->memory_need) {
+               megasas_skinny_mem_dealloc(instance);
+       }
+
        megasas_release_mfi(instance);

        pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 16:05:08.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 15:24:58.000000000 -0500
@@ -1092,6 +1092,16 @@ struct megasas_aen_event {
        struct megasas_instance *instance;
 };

+#define MR_DCMD_CTRL_MFI_HOST_MEM_ALLOC                0x0100e100
+#define MEGASAS_SKINNY_SZ_MEM_BK               (64*1024)
+#define MEGASAS_SKINNY_MAX_NUM_MEM_BK          512
+
+struct megasas_skinny_mm_bk {
+       u32                     vir;
+       u32                     sz;
+       dma_addr_t              paddr;
+};
+
 struct megasas_instance {

        u32 *producer;
@@ -1105,6 +1115,15 @@ struct megasas_instance {
        unsigned long base_addr;
        struct megasas_register_set __iomem *reg_set;

+       u32 *skinny_mm_tb;
+       dma_addr_t skinny_mm_tb_h;
+
+       struct megasas_skinny_mm_bk skinny_mm_bk[MEGASAS_SKINNY_MAX_NUM_MEM_BK];
+
+       u32 skinny_mm_alloc_ind;
+       struct megasas_pd_list pd_list[MEGASAS_MAX_PD];
+
+       u8 memory_need;
        s8 init_id;

        u16 max_num_sge;

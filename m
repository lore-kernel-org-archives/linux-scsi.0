Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8B6C4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6274121531
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="aAXpfpge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgI1KfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 06:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgI1KfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 06:35:08 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C740C0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:35:08 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s31so480063pga.7
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=Z706JSUt/VLLPSYZ68NZedSYjfikVbkiJGD4sGPT1NU=;
        b=aAXpfpgeAqkQaLP+RYiR8QqfKp8Xo9jtGLwNXjNK5ujJBMnLJWrnLVGah2VxWwdL85
         jbcgdFZrIAN+LgfkdLEw6nrXXEkUknMG9PVRC4dIFrv0c+zOx8wxA+wmuKLZ+V4ePQwj
         Sqp649wsxEIx4+Bi9oTlL9NBg0LWH6PB/fnagXEJJVQ5EEWbAFr+BzlTYnYlTdCpEqk0
         xrsWf+SbbGXzTfdGxKvsDxKXH857piVtE23i7/ijpzCMqtpfE7rq2shmZFYAIiWGQPnp
         sfveddovMiN328IxtpdEMZJcxWNmtS7T/At7twg4Yzz81NdxrjVWLtpCVSjXAaBApDXe
         /+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=Z706JSUt/VLLPSYZ68NZedSYjfikVbkiJGD4sGPT1NU=;
        b=WBeErFPF6sv6ntEqbOhHzjb9NS0mEkevSp822Csf90BDu6NebHfJIwHYYuGoxdj6lI
         hNDf8rnru6zuOWkuO+PLDllMHf20dHE5puA6Egy+xwi08fbrk/Fj7DMJZCsmSqn3lQX0
         S/PXz/h7AeosCeY61doe4x2ArwcPnA45JB3mEDx0g3eX7Ibf+4aBSYD/SDzAEDsJtRE6
         7xUGtidfDr1PNT84EwsrGqqCuOjDgL2AchwuwJR4Xv48nCFRCIZK9/HeKQ0HMYiOFZZm
         LB86FUqvOVS+AkTSmtxw0LDyliAr7kITkk7A4v87gAEnPO0uDOD+UP84Q0B2SvbX0Xib
         M3jg==
X-Gm-Message-State: AOAM5321iFFzY9wfKhjXszfJGQrKZIiKPPOuoDVsMi1/7q8NrYfP/0nM
        tVJH52h4Sv+gj5IACexe27FQRw==
X-Google-Smtp-Source: ABdhPJycESH6EloX6g1VITmTbo2Pb+nwsKzH6h+1f7LFAn9TFi3fCWrTDQemANozpUl9rKyZunmTKg==
X-Received: by 2002:a17:902:bd88:b029:d2:8ce6:f5c9 with SMTP id q8-20020a170902bd88b02900d28ce6f5c9mr998143pls.39.1601289307472;
        Mon, 28 Sep 2020 03:35:07 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id s24sm869032pjp.53.2020.09.28.03.35.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 03:35:06 -0700 (PDT)
Message-ID: <78ae03d0ac05054c721cc3a94f41f9e656a5e176.camel@areca.com.tw>
Subject: [PATCH 3/4] scsi: arcmsr: Add supporting ARC-1886 series Raid
 controllers
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     dan.carpenter@oracle.com, hch@infradead.org,
        Colin King <colin.king@canonical.com>
Date:   Mon, 28 Sep 2020 18:35:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Add supporting ARC-1886 series Raid controllers.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 0ae401d..5e32f17 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -80,6 +80,7 @@ struct device_attribute;
 #ifndef PCI_DEVICE_ID_ARECA_1884
 #define PCI_DEVICE_ID_ARECA_1884	0x1884
 #endif
+#define PCI_DEVICE_ID_ARECA_1886	0x188A
 #define	ARCMSR_HOURS			(1000 * 60 * 60 * 4)
 #define	ARCMSR_MINUTES			(1000 * 60 * 60)
 /*
@@ -436,6 +437,21 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBEMU_DOORBELL_SYNC		0x100
 #define ARCMSR_ARC188X_RESET_ADAPTER		0x00000004
 #define ARCMSR_ARC1884_DiagWrite_ENABLE		0x00000080
+
+/*
+*******************************************************************************
+**                SPEC. for Areca Type F adapter
+*******************************************************************************
+*/
+#define ARCMSR_SIGNATURE_1886			0x188617D3
+// Doorbell and interrupt definition are same as Type E adapter
+/* ARC-1886 doorbell sync */
+#define ARCMSR_HBFMU_DOORBELL_SYNC		0x100
+//set host rw buffer physical address at inbound message 0, 1 (low,high)
+#define ARCMSR_HBFMU_DOORBELL_SYNC1		0x300
+#define ARCMSR_HBFMU_MESSAGE_FIRMWARE_OK	0x80000000
+#define ARCMSR_HBFMU_MESSAGE_NO_VOLUME_CHANGE	0x20000000
+
 /*
 *******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -720,6 +736,80 @@ struct MessageUnit_E{
 	uint32_t	msgcode_rwbuffer[256];			/*2200 23FF*/
 };
 
+/*
+*********************************************************************
+**     Messaging Unit (MU) of Type F processor(LSI)
+*********************************************************************
+*/
+struct MessageUnit_F {
+	uint32_t	iobound_doorbell;			/*0000 0003*/
+	uint32_t	write_sequence_3xxx;			/*0004 0007*/
+	uint32_t	host_diagnostic_3xxx;			/*0008 000B*/
+	uint32_t	posted_outbound_doorbell;		/*000C 000F*/
+	uint32_t	master_error_attribute;			/*0010 0013*/
+	uint32_t	master_error_address_low;		/*0014 0017*/
+	uint32_t	master_error_address_high;		/*0018 001B*/
+	uint32_t	hcb_size;				/*001C 001F*/
+	uint32_t	inbound_doorbell;			/*0020 0023*/
+	uint32_t	diagnostic_rw_data;			/*0024 0027*/
+	uint32_t	diagnostic_rw_address_low;		/*0028 002B*/
+	uint32_t	diagnostic_rw_address_high;		/*002C 002F*/
+	uint32_t	host_int_status;			/*0030 0033*/
+	uint32_t	host_int_mask;				/*0034 0037*/
+	uint32_t	dcr_data;				/*0038 003B*/
+	uint32_t	dcr_address;				/*003C 003F*/
+	uint32_t	inbound_queueport;			/*0040 0043*/
+	uint32_t	outbound_queueport;			/*0044 0047*/
+	uint32_t	hcb_pci_address_low;			/*0048 004B*/
+	uint32_t	hcb_pci_address_high;			/*004C 004F*/
+	uint32_t	iop_int_status;				/*0050 0053*/
+	uint32_t	iop_int_mask;				/*0054 0057*/
+	uint32_t	iop_inbound_queue_port;			/*0058 005B*/
+	uint32_t	iop_outbound_queue_port;		/*005C 005F*/
+	uint32_t	inbound_free_list_index;		/*0060 0063*/
+	uint32_t	inbound_post_list_index;		/*0064 0067*/
+	uint32_t	reply_post_producer_index;		/*0068 006B*/
+	uint32_t	reply_post_consumer_index;		/*006C 006F*/
+	uint32_t	inbound_doorbell_clear;			/*0070 0073*/
+	uint32_t	i2o_message_unit_control;		/*0074 0077*/
+	uint32_t	last_used_message_source_address_low;	/*0078 007B*/
+	uint32_t	last_used_message_source_address_high;	/*007C 007F*/
+	uint32_t	pull_mode_data_byte_count[4];		/*0080 008F*/
+	uint32_t	message_dest_address_index;		/*0090 0093*/
+	uint32_t	done_queue_not_empty_int_counter_timer;	/*0094 0097*/
+	uint32_t	utility_A_int_counter_timer;		/*0098 009B*/
+	uint32_t	outbound_doorbell;			/*009C 009F*/
+	uint32_t	outbound_doorbell_clear;		/*00A0 00A3*/
+	uint32_t	message_source_address_index;		/*00A4 00A7*/
+	uint32_t	message_done_queue_index;		/*00A8 00AB*/
+	uint32_t	reserved0;				/*00AC 00AF*/
+	uint32_t	inbound_msgaddr0;			/*00B0 00B3*/
+	uint32_t	inbound_msgaddr1;			/*00B4 00B7*/
+	uint32_t	outbound_msgaddr0;			/*00B8 00BB*/
+	uint32_t	outbound_msgaddr1;			/*00BC 00BF*/
+	uint32_t	inbound_queueport_low;			/*00C0 00C3*/
+	uint32_t	inbound_queueport_high;			/*00C4 00C7*/
+	uint32_t	outbound_queueport_low;			/*00C8 00CB*/
+	uint32_t	outbound_queueport_high;		/*00CC 00CF*/
+	uint32_t	iop_inbound_queue_port_low;		/*00D0 00D3*/
+	uint32_t	iop_inbound_queue_port_high;		/*00D4 00D7*/
+	uint32_t	iop_outbound_queue_port_low;		/*00D8 00DB*/
+	uint32_t	iop_outbound_queue_port_high;		/*00DC 00DF*/
+	uint32_t	message_dest_queue_port_low;		/*00E0 00E3*/
+	uint32_t	message_dest_queue_port_high;		/*00E4 00E7*/
+	uint32_t	last_used_message_dest_address_low;	/*00E8 00EB*/
+	uint32_t	last_used_message_dest_address_high;	/*00EC 00EF*/
+	uint32_t	message_done_queue_base_address_low;	/*00F0 00F3*/
+	uint32_t	message_done_queue_base_address_high;	/*00F4 00F7*/
+	uint32_t	host_diagnostic;			/*00F8 00FB*/
+	uint32_t	write_sequence;				/*00FC 00FF*/
+	uint32_t	reserved1[46];				/*0100 01B7*/
+	uint32_t	reply_post_producer_index1;		/*01B8 01BB*/
+	uint32_t	reply_post_consumer_index1;		/*01BC 01BF*/
+};
+
+#define	MESG_RW_BUFFER_SIZE	(256 * 3)
+
 typedef struct deliver_completeQ {
 	uint16_t	cmdFlag;
 	uint16_t	cmdSMID;
@@ -739,6 +829,7 @@ struct AdapterControlBlock
 #define ACB_ADAPTER_TYPE_C		0x00000002	/* hbc L IOP */
 #define ACB_ADAPTER_TYPE_D		0x00000003	/* hbd M IOP */
 #define ACB_ADAPTER_TYPE_E		0x00000004	/* hba L IOP */
+#define ACB_ADAPTER_TYPE_F		0x00000005	/* hba L IOP */
 	u32			ioqueue_size;
 	struct pci_dev *	pdev;
 	struct Scsi_Host *	host;
@@ -760,10 +851,16 @@ struct AdapterControlBlock
 		struct MessageUnit_C __iomem *pmuC;
 		struct MessageUnit_D 	*pmuD;
 		struct MessageUnit_E __iomem *pmuE;
+		struct MessageUnit_F __iomem *pmuF;
 	};
 	/* message unit ATU inbound base address0 */
 	void __iomem		*mem_base0;
 	void __iomem		*mem_base1;
+	//0x000 - COMPORT_IN  (Host sent to ROC)
+	uint32_t		*message_wbuffer;
+	//0x100 - COMPORT_OUT (ROC sent to Host)
+	uint32_t		*message_rbuffer;
+	uint32_t		*msgcode_rwbuffer;	//0x200 - BIOS_AREA
 	uint32_t		acb_flags;
 	u16			dev_id;
 	uint8_t			adapter_index;
@@ -846,6 +943,7 @@ struct AdapterControlBlock
 	uint32_t		out_doorbell;
 	uint32_t		completionQ_entry;
 	pCompletion_Q		pCompletionQ;
+	uint32_t		completeQ_size;
 };/* HW_DEVICE_EXTENSION */
 /*
 *******************************************************************************
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 86f84d7..96e58d3 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -133,6 +133,7 @@ static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
 static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);
 static void arcmsr_hbaE_message_isr(struct AdapterControlBlock *acb);
 static void arcmsr_hbaE_postqueue_isr(struct AdapterControlBlock *acb);
+static void arcmsr_hbaF_postqueue_isr(struct AdapterControlBlock *acb);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -209,6 +210,8 @@ static struct pci_device_id arcmsr_device_id_table[] = {
 		.driver_data = ACB_ADAPTER_TYPE_C},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1884),
 		.driver_data = ACB_ADAPTER_TYPE_E},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1886),
+		.driver_data = ACB_ADAPTER_TYPE_F},
 	{0, 0}, /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
@@ -232,12 +235,12 @@ static void arcmsr_free_io_queue(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B:
 	case ACB_ADAPTER_TYPE_D:
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		dma_free_coherent(&acb->pdev->dev, acb->ioqueue_size,
 			acb->dma_coherent2, acb->dma_coherent_handle2);
 		break;
 	}
-	}
 }
 
 static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
@@ -310,6 +313,19 @@ static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
 		acb->out_doorbell = 0;
 		break;
 		}
+	case ACB_ADAPTER_TYPE_F: {
+		acb->pmuF = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+		if (!acb->pmuF) {
+			pr_notice("arcmsr%d: memory mapping region fail \n",
+				acb->host->host_no);
+			return false;
+		}
+		writel(0, &acb->pmuF->host_int_status); /* clear interrupt */
+		writel(ARCMSR_HBFMU_DOORBELL_SYNC, &acb->pmuF->iobound_doorbell);
+		acb->in_doorbell = 0;
+		acb->out_doorbell = 0;
+		break;
+		}
 	}
 	return true;
 }
@@ -333,6 +349,9 @@ static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_E:
 		iounmap(acb->pmuE);
 		break;
+	case ACB_ADAPTER_TYPE_F:
+		iounmap(acb->pmuF);
+		break;
 	}
 }
 
@@ -561,6 +580,7 @@ static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 		arcmsr_hbaD_flush_cache(acb);
 		break;
 	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		arcmsr_hbaE_flush_cache(acb);
 		break;
 	}
@@ -618,6 +638,28 @@ static void arcmsr_hbaD_assign_regAddr(struct AdapterControlBlock *acb)
 	reg->msgcode_rwbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
 }
 
+static void arcmsr_hbaF_assign_regAddr(struct AdapterControlBlock *acb)
+{
+	dma_addr_t host_buffer_dma;
+	struct MessageUnit_F __iomem	*pmuF;
+
+	memset(acb->dma_coherent2, 0xff, acb->completeQ_size);
+	acb->message_wbuffer = (uint32_t *)((((unsigned long)acb->dma_coherent2 +
+		acb->completeQ_size + 3) >> 2) << 2);
+	acb->message_rbuffer = ((void *)acb->message_wbuffer) + 0x100;
+	acb->msgcode_rwbuffer = ((void *)acb->message_wbuffer) + 0x200;
+	memset((void *)acb->message_wbuffer, 0, MESG_RW_BUFFER_SIZE);
+	host_buffer_dma = ((acb->dma_coherent_handle2 + acb->completeQ_size +
+		3) >> 2) << 2;
+	pmuF = acb->pmuF;
+	/* host buffer low address, bit0:1 all buffer active */
+	writel((uint32_t)(host_buffer_dma | 1), &pmuF->inbound_msgaddr0);
+	/* host buffer high address */
+	writel((uint32_t)(host_buffer_dma >> 32), &pmuF->inbound_msgaddr1);
+	/* set host buffer physical address */
+	writel(ARCMSR_HBFMU_DOORBELL_SYNC1, &pmuF->iobound_doorbell);
+}
+
 static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 {
 	bool rtn = true;
@@ -671,6 +713,28 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 		acb->doneq_index = 0;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_F: {
+		uint32_t QueueDepth;
+		uint32_t depthTbl[] = {256, 512, 1024, 128, 64, 32};
+
+		arcmsr_wait_firmware_ready(acb);
+		QueueDepth = depthTbl[readl(&acb->pmuF->outbound_msgaddr1) & 7];
+		acb->completeQ_size = sizeof(struct deliver_completeQ) * QueueDepth + 128 ;
+		acb->ioqueue_size = roundup(acb->completeQ_size + MESG_RW_BUFFER_SIZE, 32);
+		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
+			&dma_coherent_handle, GFP_KERNEL);
+		if (!dma_coherent){
+			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+			return false;
+		}
+		acb->dma_coherent_handle2 = dma_coherent_handle;
+		acb->dma_coherent2 = dma_coherent;
+		acb->pCompletionQ = dma_coherent;
+		acb->completionQ_entry = acb->completeQ_size / sizeof(struct deliver_completeQ);
+		acb->doneq_index = 0;
+		arcmsr_hbaF_assign_regAddr(acb);
+		}
+		break;
 	default:
 		break;
 	}
@@ -705,7 +769,8 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	acb->host->sg_tablesize = max_sg_entrys;
 	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) + (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
 	acb->uncache_size = roundup_ccbsize * acb->maxFreeCCB;
-	acb->uncache_size += acb->ioqueue_size;
+	if (acb->adapter_type != ACB_ADAPTER_TYPE_F)
+		acb->uncache_size += acb->ioqueue_size;
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
 	if(!dma_coherent){
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n", acb->host->host_no);
@@ -728,6 +793,7 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		case ACB_ADAPTER_TYPE_C:
 		case ACB_ADAPTER_TYPE_D:
 		case ACB_ADAPTER_TYPE_E:
+		case ACB_ADAPTER_TYPE_F:
 			ccb_tmp->cdb_phyaddr = cdb_phyaddr;
 			break;
 		}
@@ -746,8 +812,10 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		ccb_tmp = (struct CommandControlBlock *)((unsigned long)ccb_tmp + roundup_ccbsize);
 		dma_coherent_handle = next_ccb_phy;
 	}
-	acb->dma_coherent_handle2 = dma_coherent_handle;
-	acb->dma_coherent2 = ccb_tmp;
+	if (acb->adapter_type != ACB_ADAPTER_TYPE_F) {
+		acb->dma_coherent_handle2 = dma_coherent_handle;
+		acb->dma_coherent2 = ccb_tmp;
+	}
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B:
 		acb->pmuB = (struct MessageUnit_B *)acb->dma_coherent2;
@@ -813,6 +881,11 @@ static void arcmsr_message_isr_bh_fn(struct work_struct *work)
 		devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
 		break;
 		}
+	case ACB_ADAPTER_TYPE_F: {
+		signature = (uint32_t __iomem *)(&acb->msgcode_rwbuffer[0]);
+		devicemap = (char __iomem *)(&acb->msgcode_rwbuffer[21]);
+		break;
+		}
 	}
 	if (readl(signature) != ARCMSR_SIGNATURE_GET_CONFIG)
 		return;
@@ -998,7 +1071,8 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if(!error){
 		goto free_hbb_mu;
 	}
-	arcmsr_free_io_queue(acb);
+	if (acb->adapter_type != ACB_ADAPTER_TYPE_F)
+		arcmsr_free_io_queue(acb);
 	error = arcmsr_alloc_ccb_pool(acb);
 	if(error){
 		goto unmap_pci_region;
@@ -1111,6 +1185,14 @@ static int arcmsr_resume(struct pci_dev *pdev)
 		acb->out_doorbell = 0;
 		acb->doneq_index = 0;
 		break;
+	case ACB_ADAPTER_TYPE_F:
+		writel(0, &acb->pmuF->host_int_status);
+		writel(ARCMSR_HBFMU_DOORBELL_SYNC, &acb->pmuF->iobound_doorbell);
+		acb->in_doorbell = 0;
+		acb->out_doorbell = 0;
+		acb->doneq_index = 0;
+		arcmsr_hbaF_assign_regAddr(acb);
+		break;
 	}
 	arcmsr_iop_init(acb);
 	arcmsr_init_get_devmap_timer(acb);
@@ -1123,6 +1205,8 @@ controller_stop:
 controller_unregister:
 	scsi_remove_host(host);
 	arcmsr_free_ccb_pool(acb);
+	if (acb->adapter_type == ACB_ADAPTER_TYPE_F)
+		arcmsr_free_io_queue(acb);
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
@@ -1215,6 +1299,7 @@ static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 		rtnval = arcmsr_hbaD_abort_allcmd(acb);
 		break;
 	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		rtnval = arcmsr_hbaE_abort_allcmd(acb);
 		break;
 	}
@@ -1290,7 +1375,8 @@ static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
 		writel(ARCMSR_ARC1214_ALL_INT_DISABLE, reg->pcief0_int_enable);
 		}
 		break;
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		orig_mask = readl(&reg->host_int_mask);
 		writel(orig_mask | ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR | ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR, &reg->host_int_mask);
@@ -1497,6 +1583,9 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_E:
 		arcmsr_hbaE_postqueue_isr(acb);
 		break;
+	case ACB_ADAPTER_TYPE_F:
+		arcmsr_hbaF_postqueue_isr(acb);
+		break;
 	}
 }
 
@@ -1551,6 +1640,8 @@ static void arcmsr_free_pcidev(struct AdapterControlBlock *acb)
 	pdev = acb->pdev;
 	arcmsr_free_irq(pdev, acb);
 	arcmsr_free_ccb_pool(acb);
+	if (acb->adapter_type == ACB_ADAPTER_TYPE_F)
+		arcmsr_free_io_queue(acb);
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
@@ -1608,6 +1699,8 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	}
 	arcmsr_free_irq(pdev, acb);
 	arcmsr_free_ccb_pool(acb);
+	if (acb->adapter_type == ACB_ADAPTER_TYPE_F)
+		arcmsr_free_io_queue(acb);
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
@@ -1685,7 +1778,8 @@ static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
 		writel(intmask_org | mask, reg->pcief0_int_enable);
 		break;
 		}
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 
 		mask = ~(ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR | ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR);
@@ -1829,6 +1923,19 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 		writel(ccb_post_stamp, &pmu->inbound_queueport_low);
 		break;
 		}
+	case ACB_ADAPTER_TYPE_F: {
+		struct MessageUnit_F __iomem *pmu = acb->pmuF;
+		u32 ccb_post_stamp, arc_cdb_size;
+
+		if (ccb->arc_cdb_size <= 0x300)
+			arc_cdb_size = (ccb->arc_cdb_size - 1) >> 6 | 1;
+		else
+			arc_cdb_size = (((ccb->arc_cdb_size + 0xff) >> 8) + 2) << 1 | 1;
+		ccb_post_stamp = (ccb->smid | arc_cdb_size);
+		writel(0, &pmu->inbound_queueport_high);
+		writel(ccb_post_stamp, &pmu->inbound_queueport_low);
+		break;
+		}
 	}
 }
 
@@ -1912,6 +2019,7 @@ static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 		arcmsr_hbaD_stop_bgrb(acb);
 		break;
 	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		arcmsr_hbaE_stop_bgrb(acb);
 		break;
 	}
@@ -1947,7 +2055,8 @@ static void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 			reg->inbound_doorbell);
 		}
 		break;
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_DATA_READ_OK;
 		writel(acb->out_doorbell, &reg->iobound_doorbell);
@@ -1993,7 +2102,8 @@ static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 			reg->inbound_doorbell);
 		}
 		break;
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_DATA_WRITE_OK;
 		writel(acb->out_doorbell, &reg->iobound_doorbell);
@@ -2032,6 +2142,10 @@ struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 		qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_F: {
+		qbuffer = (struct QBUFFER __iomem *)acb->message_rbuffer;
+		}
+		break;
 	}
 	return qbuffer;
 }
@@ -2066,6 +2180,9 @@ static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct AdapterControlBloc
 		pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_F:
+		pqbuffer = (struct QBUFFER __iomem *)acb->message_wbuffer;
+		break;
 	}
 	return pqbuffer;
 }
@@ -2480,6 +2597,36 @@ static void arcmsr_hbaE_postqueue_isr(struct AdapterControlBlock *acb)
 	spin_unlock_irqrestore(&acb->doneq_lock, flags);
 }
 
+static void arcmsr_hbaF_postqueue_isr(struct AdapterControlBlock *acb)
+{
+	uint32_t doneq_index;
+	uint16_t cmdSMID;
+	int error;
+	struct MessageUnit_F __iomem *phbcmu;
+	struct CommandControlBlock *ccb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&acb->doneq_lock, flags);
+	doneq_index = acb->doneq_index;
+	phbcmu = acb->pmuF;
+	while (1) {
+		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
+		if (cmdSMID == 0xffff)
+			break;
+		ccb = acb->pccb_pool[cmdSMID];
+		error = (acb->pCompletionQ[doneq_index].cmdFlag &
+			ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+		arcmsr_drain_donequeue(acb, ccb, error);
+		acb->pCompletionQ[doneq_index].cmdSMID = 0xffff;
+		doneq_index++;
+		if (doneq_index >= acb->completionQ_entry)
+			doneq_index = 0;
+	}
+	acb->doneq_index = doneq_index;
+	writel(doneq_index, &phbcmu->reply_post_consumer_index);
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);
+}
+
 /*
 **********************************************************************************
 ** Handle a message interrupt
@@ -2670,6 +2817,31 @@ static irqreturn_t arcmsr_hbaE_handle_isr(struct AdapterControlBlock *pACB)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t arcmsr_hbaF_handle_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t host_interrupt_status;
+	struct MessageUnit_F __iomem *phbcmu = pACB->pmuF;
+
+	host_interrupt_status = readl(&phbcmu->host_int_status) &
+		(ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR |
+		ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR);
+	if (!host_interrupt_status)
+		return IRQ_NONE;
+	do {
+		/* MU post queue interrupts*/
+		if (host_interrupt_status & ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR) {
+			arcmsr_hbaF_postqueue_isr(pACB);
+		}
+		/* MU ioctl transfer doorbell interrupts*/
+		if (host_interrupt_status & ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR) {
+			arcmsr_hbaE_doorbell_isr(pACB);
+		}
+		host_interrupt_status = readl(&phbcmu->host_int_status);
+	} while (host_interrupt_status & (ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR |
+		ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR));
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -2683,6 +2855,8 @@ static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 		return arcmsr_hbaD_handle_isr(acb);
 	case ACB_ADAPTER_TYPE_E:
 		return arcmsr_hbaE_handle_isr(acb);
+	case ACB_ADAPTER_TYPE_F:
+		return arcmsr_hbaF_handle_isr(acb);
 	default:
 		return IRQ_NONE;
 	}
@@ -3231,6 +3405,31 @@ static bool arcmsr_hbaE_get_config(struct AdapterControlBlock *pACB)
 	return true;
 }
 
+static bool arcmsr_hbaF_get_config(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_F __iomem *reg = pACB->pmuF;
+	uint32_t intmask_org;
+
+	/* disable all outbound interrupt */
+	intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
+	writel(intmask_org | ARCMSR_HBEMU_ALL_INTMASKENABLE, &reg->host_int_mask);
+	/* wait firmware ready */
+	arcmsr_wait_firmware_ready(pACB);
+	/* post "get config" instruction */
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+
+	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+	writel(pACB->out_doorbell, &reg->iobound_doorbell);
+	/* wait message ready */
+	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
+		pr_notice("arcmsr%d: wait get adapter firmware "
+			"miscellaneous data timeout\n", pACB->host->host_no);
+		return false;
+	}
+	arcmsr_get_adapter_config(pACB, pACB->msgcode_rwbuffer);
+	return true;
+}
+
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
 	bool rtn = false;
@@ -3251,6 +3450,9 @@ static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_E:
 		rtn = arcmsr_hbaE_get_config(acb);
 		break;
+	case ACB_ADAPTER_TYPE_F:
+		rtn = arcmsr_hbaF_get_config(acb);
+		break;
 	default:
 		break;
 	}
@@ -3621,6 +3823,7 @@ static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 		rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
 		break;
 	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		rtn = arcmsr_hbaE_polling_ccbdone(acb, poll_ccb);
 		break;
 	}
@@ -3701,6 +3904,15 @@ static void arcmsr_set_iop_datetime(struct timer_list *t)
 			writel(pacb->out_doorbell, &reg->iobound_doorbell);
 			break;
 		}
+		case ACB_ADAPTER_TYPE_F: {
+			struct MessageUnit_F __iomem *reg = pacb->pmuF;
+			pacb->msgcode_rwbuffer[0] = datetime.b.msg_time[0];
+			pacb->msgcode_rwbuffer[1] = datetime.b.msg_time[1];
+			writel(ARCMSR_INBOUND_MESG0_SYNC_TIMER, &reg->inbound_msgaddr0);
+			pacb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+			writel(pacb->out_doorbell, &reg->iobound_doorbell);
+			break;
+		}
 	}
 	if (sys_tz.tz_minuteswest)
 		next_time = ARCMSR_HOURS;
@@ -3726,6 +3938,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		dma_coherent_handle = acb->dma_coherent_handle2;
 		break;
 	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		dma_coherent_handle = acb->dma_coherent_handle +
 			offsetof(struct CommandControlBlock, arcmsr_cdb);
 		break;
@@ -3859,6 +4072,29 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		}
 		}
 		break;
+	case ACB_ADAPTER_TYPE_F: {
+		struct MessageUnit_F __iomem *reg = acb->pmuF;
+		acb->msgcode_rwbuffer[0] = ARCMSR_SIGNATURE_SET_CONFIG;
+		acb->msgcode_rwbuffer[1] = ARCMSR_SIGNATURE_1886;
+		acb->msgcode_rwbuffer[2] = cdb_phyaddr;
+		acb->msgcode_rwbuffer[3] = cdb_phyaddr_hi32;
+		acb->msgcode_rwbuffer[4] = acb->ccbsize;
+		dma_coherent_handle = acb->dma_coherent_handle2;
+		cdb_phyaddr = (uint32_t)dma_coherent_handle;
+		cdb_phyaddr_hi32 = (uint32_t)(dma_coherent_handle >> 32);
+		acb->msgcode_rwbuffer[5] = cdb_phyaddr;
+		acb->msgcode_rwbuffer[6] = cdb_phyaddr_hi32;
+		acb->msgcode_rwbuffer[7] = acb->completeQ_size;
+		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
+		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		if (!arcmsr_hbaE_wait_msgint_ready(acb)) {
+			pr_notice("arcmsr%d: 'set command Q window' timeout \n",
+				acb->host->host_no);
+			return 1;
+		}
+		}
+		break;
 	}
 	return 0;
 }
@@ -3907,7 +4143,8 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 			ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
 		}
 		break;
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		do {
 			if (!(acb->acb_flags & ACB_F_IOP_INITED))
@@ -3955,10 +4192,22 @@ static void arcmsr_request_device_map(struct timer_list *t)
 			writel(acb->out_doorbell, &reg->iobound_doorbell);
 			break;
 			}
+		case ACB_ADAPTER_TYPE_F: {
+			struct MessageUnit_F __iomem *reg = acb->pmuF;
+			uint32_t outMsg1 = readl(&reg->outbound_msgaddr1);
+			if (!(outMsg1 & ARCMSR_HBFMU_MESSAGE_FIRMWARE_OK) ||
+				(outMsg1 & ARCMSR_HBFMU_MESSAGE_NO_VOLUME_CHANGE))
+				goto nxt6s;
+			writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+			acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+			writel(acb->out_doorbell, &reg->iobound_doorbell);
+			break;
+			}
 		default:
 			return;
 		}
 		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
+nxt6s:
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
 }
@@ -4040,6 +4289,7 @@ static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 		arcmsr_hbaD_start_bgrb(acb);
 		break;
 	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:
 		arcmsr_hbaE_start_bgrb(acb);
 		break;
 	}
@@ -4119,7 +4369,8 @@ static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
 		}
 		}
 		break;
-	case ACB_ADAPTER_TYPE_E: {
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		uint32_t i, tmp;
 
@@ -4246,7 +4497,8 @@ static bool arcmsr_reset_in_progress(struct AdapterControlBlock *acb)
 			true : false;
 		}
 		break;
-	case ACB_ADAPTER_TYPE_E:{
+	case ACB_ADAPTER_TYPE_E:
+	case ACB_ADAPTER_TYPE_F:{
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		rtn = (readl(&reg->host_diagnostic_3xxx) &
 			ARCMSR_ARC188X_RESET_ADAPTER) ? true : false;
@@ -4445,6 +4697,9 @@ static const char *arcmsr_info(struct Scsi_Host *host)
 	case PCI_DEVICE_ID_ARECA_1884:
 		type = "SAS/SATA";
 		break;
+	case PCI_DEVICE_ID_ARECA_1886:
+		type = "NVMe/SAS/SATA";
+		break;
 	default:
 		type = "unknown";
 		raid6 =	0;


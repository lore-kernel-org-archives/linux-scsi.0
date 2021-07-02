Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAF2C11F6A
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70BB61405
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhGBPKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 11:10:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231549AbhGBPKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 11:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625238490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=otEKCj1unPyVe9Lp2ZcDpKHjifbexAdrpVGRXhWizTI=;
        b=I8p2/qWv/Vnf1yk+LdvirqVMjTSP+Eq03PhmxnS1OrZgdt7TDMr05zxaxhoX1iMEFV5wr6
        NBNCUbAKBCj2q8MWV2tLlL6qvSZImHMylRLVX6WtuBnpS4nsE7i5xvXICzPdEhW18gvU+N
        GZLmjxddeRDoKYa4bNbH2Gz860yLqHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-tTsD9dx-O5aQXD7g3xdq4w-1; Fri, 02 Jul 2021 11:08:07 -0400
X-MC-Unique: tTsD9dx-O5aQXD7g3xdq4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33F7FEC1A1;
        Fri,  2 Jul 2021 15:08:05 +0000 (UTC)
Received: from localhost (ovpn-12-40.pek2.redhat.com [10.72.12.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E954B5D9D5;
        Fri,  2 Jul 2021 15:08:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Don Brace <don.brace@microchip.com>,
        James Smart <james.smart@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH V2 4/6] scsi: set shost->use_managed_irq if driver uses managed irq
Date:   Fri,  2 Jul 2021 23:05:53 +0800
Message-Id: <20210702150555.2401722-5-ming.lei@redhat.com>
In-Reply-To: <20210702150555.2401722-1-ming.lei@redhat.com>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set shost->use_managed_irq if irq vectors are allocated via
pci_alloc_irq_vectors_affinity(PCI_IRQ_AFFINITY) or
pci_alloc_irq_vectors(PCI_IRQ_AFFINITY).

The rule is that driver has to tell scsi core if managed irq is used.

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/aacraid/linit.c              | 3 +++
 drivers/scsi/be2iscsi/be_main.c           | 3 +++
 drivers/scsi/csiostor/csio_init.c         | 3 +++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 1 +
 drivers/scsi/hpsa.c                       | 3 +++
 drivers/scsi/lpfc/lpfc.h                  | 1 +
 drivers/scsi/lpfc/lpfc_init.c             | 4 ++++
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 3 +++
 drivers/scsi/qla2xxx/qla_isr.c            | 5 ++++-
 drivers/scsi/smartpqi/smartpqi_init.c     | 3 +++
 11 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3168915adaa7..6d0abad77ef8 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1761,6 +1761,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		shost->this_id = shost->max_id;
 
+	if (aac->msi_enabled)
+		shost->use_managed_irq = 1;
+
 	if (!aac->sa_firmware && aac_drivers[index].quirks & AAC_QUIRK_SRC)
 		aac_intr_normal(aac, 0, 2, 0, NULL);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 22cf7f4b8d8c..2de2a3f78170 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5684,6 +5684,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	hwi_enable_intr(phba);
 
+	if (phba->num_cpus > 1)
+		phba->shost->use_managed_irq = 1;
+
 	ret = iscsi_host_add(phba->shost, &phba->pcidev->dev);
 	if (ret)
 		goto free_irqs;
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 390b07bf92b9..3bc713f3237d 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -633,6 +633,9 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
 	else
 		shost->transportt = csio_fcoe_transport_vport;
 
+	if (hw->num_pports <= IRQ_AFFINITY_MAX_SETS)
+		shost->use_managed_irq = 1;
+
 	/* root lnode */
 	if (!hw->rln)
 		hw->rln = ln;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e95408314078..a8bf567b8cfe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4760,6 +4760,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err_out_debugfs;
 	dev_err(dev, "%d hw queues\n", shost->nr_hw_queues);
+	shost->use_managed_irq = 1;
 	rc = scsi_add_host(shost, dev);
 	if (rc)
 		goto err_out_free_irq_vectors;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f135a10f582b..a84c80746001 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5877,6 +5877,9 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
 {
 	int rv;
 
+	if (h->msix_vectors > 0)
+		h->scsi_host->use_managed_irq = 1;
+
 	rv = scsi_add_host(h->scsi_host, &h->pdev->dev);
 	if (rv) {
 		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f8de0d10620b..f0595c670fe8 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -783,6 +783,7 @@ struct lpfc_hba {
 #define HBA_HBEAT_INP		0x4000000 /* mbox HBEAT is in progress */
 #define HBA_HBEAT_TMO		0x8000000 /* HBEAT initiated after timeout */
 #define HBA_FLOGI_OUTSTANDING	0x10000000 /* FLOGI is outstanding */
+#define HBA_USE_MANAGED_IRQ	0x20000000 /* Use managed irq */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5f018d02bf56..df5ec095d813 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4460,6 +4460,9 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 		vport->port_type = LPFC_PHYSICAL_PORT;
 	}
 
+	if (phba->hba_flag & HBA_USE_MANAGED_IRQ)
+		shost->use_managed_irq = 1;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_FCP,
 			"9081 CreatePort TMPLATE type %x TBLsize %d "
 			"SEGcnt %d/%d\n",
@@ -11563,6 +11566,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		goto vec_fail_out;
 	}
 	vectors = rc;
+	phba->hba_flag |= HBA_USE_MANAGED_IRQ;
 
 	/* Assign MSI-X vectors to interrupt handlers */
 	for (index = 0; index < vectors; index++) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4d4e9dbe5193..20747f8e7bc8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6909,6 +6909,9 @@ static int megasas_io_attach(struct megasas_instance *instance)
 		instance->iopoll_q_count = 0;
 	}
 
+	if (instance->smp_affinity_enable)
+		host->use_managed_irq = 1;
+
 	dev_info(&instance->pdev->dev,
 		"Max firmware commands: %d shared with default "
 		"hw_queues = %d poll_queues %d\n", instance->max_fw_cmds,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d00aca3c77ce..de9de343e819 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12089,6 +12089,9 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		    shost->can_queue, shost->nr_hw_queues);
 	}
 
+	if (ioc->smp_affinity_enable)
+		shost->use_managed_irq = 1;
+
 	rv = scsi_add_host(shost, &pdev->dev);
 	if (rv) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6e8f737a4af3..036b5f178a7f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4000,11 +4000,14 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
 		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
 		    PCI_IRQ_MSIX);
-	} else
+	} else {
 		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
 		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
 		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
 		    &desc);
+		if (ret > 0)
+			vha->host->use_managed_irq = 1;
+	}
 
 	if (ret < 0) {
 		ql_log(ql_log_fatal, vha, 0x00c7,
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5db16509b6e1..b2f28ed7e568 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6972,6 +6972,9 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->host_tagset = 1;
 	shost->hostdata[0] = (unsigned long)ctrl_info;
 
+	if (ctrl_info->num_msix_vectors_enabled)
+		shost->use_managed_irq = 1;
+
 	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev, "scsi_add_host failed\n");
-- 
2.31.1


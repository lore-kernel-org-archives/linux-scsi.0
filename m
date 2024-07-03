Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0308317A5B0;
	Wed,  3 Jul 2024 18:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032312; cv=none; b=kpcdlHXDYL7ed7bOSOzjd0w8njxeHkvelJLEXccfDM5vjlPJ6ly5LGqjOfbvK0KxdRgmAo4V4f9pXUsL5H6luss/+W4pZRq5ZMdGsvBWUxK1PcXmVuT01SZanGTRhFZz9bxVNmME2gDGrcS7eetripsMT6PDLYTNGM8WEg/22gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032312; c=relaxed/simple;
	bh=/MLKSt9L9K9TbHwrbZnMJA+gn6m1M/anrGf/UAzP/OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/LHlmGxPT3bB8zGNehkwCxxtyK+IlLeXgCoi9X4UfrcNpAmrU8l6LNMch35ii8JQ0a65kj/rjvMKqIf2rnsUW1T95DbXRPW3Ru0p6ajt8W8sI8+8WD7L7C0kslGOwQmjulvkZNc+e2oPyDCEvQxlGWOD6f7NowgEBABiL7pJ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCvROagr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCvROagr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77515C2BD10;
	Wed,  3 Jul 2024 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032311;
	bh=/MLKSt9L9K9TbHwrbZnMJA+gn6m1M/anrGf/UAzP/OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCvROagrDbtC711sGGijz7Qcti6AsgKTf2cMEkmebCU49J77JLmfkmi4TXUUcLT+A
	 3c8ZtZS63JSbVWiXv1/xDzlnpZ4rtkQepxkY8t6SrF/UFewCKyJtht/Q3eVwMvqtLF
	 z81lYAshkb9/IZsh37/yjTkXbuIiM/u45lqVNOBHft6lt3NzJr0LJ0Ahs6BqOCFP+0
	 Js4wmEIKzz2qIyFZB7y+WYWo/IXdi8VfqtKnG4A2Rew5qhHaXNHIImudr8jYfxdoyt
	 veV9RFkH2xHQ0xiPr3CAGoPXkxwC9NcAXWpBUhpGhrCyiJ4K5Oq/oVvB7M7IgmqiLI
	 tYJ3xrb9gPkXQ==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v4 8/9] ata,scsi: Remove wrapper ata_sas_port_alloc()
Date: Wed,  3 Jul 2024 20:44:25 +0200
Message-ID: <20240703184418.723066-19-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5664; i=cassel@kernel.org; h=from:subject; bh=/MLKSt9L9K9TbHwrbZnMJA+gn6m1M/anrGf/UAzP/OQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa5/DqNp5h5ns3Z2cZt4nTfZPpz2+56pa8uVF93L6NT ++rF+P9jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEwks4OR4aqtaVeIjrBld5nT qn9Xq3Y03DMve9bIu1+D75t23KUOMUaG5XtZgq0rRBaql6UGRQs3pPEePejxX+c/f4Vr3nu7mQs 5AA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

The ata_sas_port_alloc() wrapper mainly exists in order to export the
internal libata function which it wraps. The secondary reason is that
it initializes some ata_port struct members.

However, ata_sas_port_alloc() is only used in a single location,
sas_ata_init(), which already performs some ata_port struct member
initialization, so it does not make sense to spread this initialization
out over two separate locations.

Thus, remove the wrapper and instead export the libata function directly,
and move the libsas specific ata_port initialization to sas_ata_init(),
which already does some ata_port initialization.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c     |  1 +
 drivers/ata/libata-sata.c     | 35 -----------------------------------
 drivers/ata/libata.h          |  1 -
 drivers/scsi/libsas/sas_ata.c | 20 +++++++++-----------
 include/linux/libata.h        |  3 +--
 5 files changed, 11 insertions(+), 49 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5031064834be..22e7b09c93b1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5493,6 +5493,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	return ap;
 }
+EXPORT_SYMBOL_GPL(ata_port_alloc);
 
 void ata_port_free(struct ata_port *ap)
 {
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b602247604dc..48660d445602 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1204,41 +1204,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 }
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
 
-/**
- *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
- *	@host: ATA host container for all SAS ports
- *	@port_info: Information from low-level host driver
- *	@shost: SCSI host that the scsi device is attached to
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- *	RETURNS:
- *	ata_port pointer on success / NULL on failure.
- */
-
-struct ata_port *ata_sas_port_alloc(struct ata_host *host,
-				    struct ata_port_info *port_info,
-				    struct Scsi_Host *shost)
-{
-	struct ata_port *ap;
-
-	ap = ata_port_alloc(host);
-	if (!ap)
-		return NULL;
-
-	ap->port_no = 0;
-	ap->pio_mask = port_info->pio_mask;
-	ap->mwdma_mask = port_info->mwdma_mask;
-	ap->udma_mask = port_info->udma_mask;
-	ap->flags |= port_info->flags;
-	ap->ops = port_info->port_ops;
-	ap->cbl = ATA_CBL_SATA;
-
-	return ap;
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
-
 /**
  *	ata_sas_device_configure - Default device_configure routine for libata
  *				   devices
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5ea194ae8a8b..6abf265f626e 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -81,7 +81,6 @@ extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
-extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
 extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 				      u8 page, void *buf, unsigned int sectors);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index ab4ddeea4909..88714b7b0dba 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -572,15 +572,6 @@ static struct ata_port_operations sas_sata_ops = {
 	.end_eh			= sas_ata_end_eh,
 };
 
-static struct ata_port_info sata_port_info = {
-	.flags = ATA_FLAG_SATA | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ |
-		 ATA_FLAG_SAS_HOST | ATA_FLAG_FPDMA_AUX,
-	.pio_mask = ATA_PIO4,
-	.mwdma_mask = ATA_MWDMA2,
-	.udma_mask = ATA_UDMA6,
-	.port_ops = &sas_sata_ops
-};
-
 int sas_ata_init(struct domain_device *found_dev)
 {
 	struct sas_ha_struct *ha = found_dev->port->ha;
@@ -597,13 +588,20 @@ int sas_ata_init(struct domain_device *found_dev)
 
 	ata_host_init(ata_host, ha->dev, &sas_sata_ops);
 
-	ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
+	ap = ata_port_alloc(ata_host);
 	if (!ap) {
-		pr_err("ata_sas_port_alloc failed.\n");
+		pr_err("ata_port_alloc failed.\n");
 		rc = -ENODEV;
 		goto free_host;
 	}
 
+	ap->port_no = 0;
+	ap->pio_mask = ATA_PIO4;
+	ap->mwdma_mask = ATA_MWDMA2;
+	ap->udma_mask = ATA_UDMA6;
+	ap->flags |= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ |
+		     ATA_FLAG_SAS_HOST | ATA_FLAG_FPDMA_AUX;
+	ap->ops = &sas_sata_ops;
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 84a7bfbac9fa..17394098bee9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1244,9 +1244,8 @@ extern int sata_link_debounce(struct ata_link *link,
 extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			     bool spm_wakeup);
 extern int ata_slave_link_init(struct ata_port *ap);
-extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
-					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
+extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_port_free(struct ata_port *ap);
 extern int ata_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_tport_delete(struct ata_port *ap);
-- 
2.45.2


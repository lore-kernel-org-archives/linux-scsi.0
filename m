Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510A61C8FA2
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729620706; cv=none; b=PxioomxZLWwC83tTLvgMB/jW6GgMOsKM0Wjc/2r9p14fQUVm5b71xj7ljbCidKQF6MeKz6CXhOu/oCZxY4jKc1cXSvSE+ETXYbe0EJBTHW/a6heqJsevSDkGw5r+fuzh1ahm4hNE2aD82q6p9ZvBQkD+fUHuzPGnT+SnbwGBWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729620706; c=relaxed/simple;
	bh=kfReEtsG9y1D1XFzyUjx1M1HLY0UQAHrrxTYuXUm1jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtDvrynjvax4pumzZSI10wTYr8zfwg7jwKMs6KYQpuRNfzkMX4b4C5qnwClGkJsi2OUkmYPfUDw2L7iAfR3shfzxDR+GEVwU6BD5JzMqAcYIfhMLa290vNaJpDpbD1JMKSiozJ6o9ahmu4Aaxma7WMfRG/66d31RVuxhk2EEZNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kUiUIAZg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kUiUIAZg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY0cb63MSzlgMVj;
	Tue, 22 Oct 2024 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729620607; x=1732212608; bh=SoirT
	aatIuLi6qBP7bgvclibZuFLulWEmkIDeYi5cK4=; b=kUiUIAZg4iXO27F+lV3Nv
	0pbB2zbEwsrzyJeNbUvPGGthXAkkL4AZ/DH+HZ24WkIdEXrx4QwuKLyTGpXDqshE
	HF1sAr4QHXi3T9CKFu3XcpMQ8pGgfbdUlv+MULLhkpLraX/Cg3eA08tV50DH3Lzn
	QUW6Sear6ZYXjMVZi9Y/1AfSurSoy1fn1ImQ/l8icfL+PnHZUTUYjGozST5gO4j7
	n0ygGyv2eMOSpwhBboQbcMUbkgp2A5SzFeKdxKsXCZzs9HE088dbq/Pcdhka2SO5
	1GksVtPUjrEG/bVYcc0Ktj6IAmYWfYN4AHm/XTxX0QNy5E1q1RNPV3MzGIex8aRD
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tYVE0nCOqv7H; Tue, 22 Oct 2024 18:10:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY0Yw0H2HzlgMVS;
	Tue, 22 Oct 2024 18:09:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Yihang Li <liyihang9@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.com>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v4 2/5] scsi: Rename .device_configure() into .sdev_configure()
Date: Tue, 22 Oct 2024 11:07:54 -0700
Message-ID: <20241022180839.2712439-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022180839.2712439-1-bvanassche@acm.org>
References: <20241022180839.2712439-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Improve naming consistency with the .sdev_prep() and .sdev_destroy()
methods by renaming .device_configure() into .sdev_configure().

Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/ahci.h                        |  2 +-
 drivers/ata/libata-sata.c                 |  8 ++++----
 drivers/ata/libata-scsi.c                 |  7 +++----
 drivers/ata/pata_macio.c                  |  8 ++++----
 drivers/ata/sata_mv.c                     |  2 +-
 drivers/ata/sata_nv.c                     | 24 +++++++++++------------
 drivers/ata/sata_sil24.c                  |  2 +-
 drivers/firewire/sbp2.c                   |  6 +++---
 drivers/scsi/hisi_sas/hisi_sas.h          |  3 +--
 drivers/scsi/hisi_sas/hisi_sas_main.c     |  7 +++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  8 ++++----
 drivers/scsi/hptiop.c                     |  6 +++---
 drivers/scsi/ipr.c                        |  8 ++++----
 drivers/scsi/iscsi_tcp.c                  |  6 +++---
 drivers/scsi/libsas/sas_scsi_host.c       |  7 +++----
 drivers/scsi/megaraid/megaraid_sas_base.c |  6 +++---
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  8 ++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  8 ++++----
 drivers/scsi/pmcraid.c                    |  8 ++++----
 drivers/scsi/scsi_scan.c                  | 10 +++++-----
 drivers/ufs/core/ufshcd.c                 |  8 ++++----
 drivers/usb/storage/scsiglue.c            |  4 ++--
 drivers/usb/storage/uas.c                 |  6 +++---
 include/linux/libata.h                    | 11 +++++------
 include/scsi/libsas.h                     |  5 ++---
 include/scsi/scsi_host.h                  |  4 ++--
 28 files changed, 90 insertions(+), 96 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 8f40f75ba08c..75cdf51a7f74 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -397,7 +397,7 @@ extern const struct attribute_group *ahci_sdev_groups=
[];
 	.sdev_groups		=3D ahci_sdev_groups,			\
 	.change_queue_depth     =3D ata_scsi_change_queue_depth,		\
 	.tag_alloc_policy       =3D BLK_TAG_ALLOC_RR,             	\
-	.device_configure	=3D ata_scsi_device_configure
+	.sdev_configure		=3D ata_scsi_sdev_configure
=20
 extern struct ata_port_operations ahci_ops;
 extern struct ata_port_operations ahci_platform_ops;
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index c8b119a06bb2..36fd0499cdfb 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1313,7 +1313,7 @@ int ata_scsi_change_queue_depth(struct scsi_device =
*sdev, int queue_depth)
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
=20
 /**
- *	ata_sas_device_configure - Default device_configure routine for libat=
a
+ *	ata_sas_sdev_configure - Default sdev_configure routine for libata
  *				   devices
  *	@sdev: SCSI device to configure
  *	@lim: queue limits
@@ -1323,14 +1323,14 @@ EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
  *	Zero.
  */
=20
-int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limi=
ts *lim,
-		struct ata_port *ap)
+int ata_sas_sdev_configure(struct scsi_device *sdev, struct queue_limits=
 *lim,
+			   struct ata_port *ap)
 {
 	ata_scsi_sdev_config(sdev);
=20
 	return ata_scsi_dev_config(sdev, lim, ap->link.device);
 }
-EXPORT_SYMBOL_GPL(ata_sas_device_configure);
+EXPORT_SYMBOL_GPL(ata_sas_sdev_configure);
=20
 /**
  *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 27cde1759011..80b6ec577233 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1169,7 +1169,7 @@ int ata_scsi_sdev_init(struct scsi_device *sdev)
 EXPORT_SYMBOL_GPL(ata_scsi_sdev_init);
=20
 /**
- *	ata_scsi_device_configure - Set SCSI device attributes
+ *	ata_scsi_sdev_configure - Set SCSI device attributes
  *	@sdev: SCSI device to examine
  *	@lim: queue limits
  *
@@ -1181,8 +1181,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_sdev_init);
  *	Defined by SCSI layer.  We don't really care.
  */
=20
-int ata_scsi_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+int ata_scsi_sdev_configure(struct scsi_device *sdev, struct queue_limit=
s *lim)
 {
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	struct ata_device *dev =3D __ata_scsi_find_dev(ap, sdev);
@@ -1192,7 +1191,7 @@ int ata_scsi_device_configure(struct scsi_device *s=
dev,
=20
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ata_scsi_device_configure);
+EXPORT_SYMBOL_GPL(ata_scsi_sdev_configure);
=20
 /**
  *	ata_scsi_sdev_destroy - SCSI device is about to be destroyed
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index f2f36e55a1f4..a8e2989d0469 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -812,8 +812,8 @@ static void pata_macio_reset_hw(struct pata_macio_pri=
v *priv, int resume)
 /* Hook the standard slave config to fixup some HW related alignment
  * restrictions
  */
-static int pata_macio_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int pata_macio_sdev_configure(struct scsi_device *sdev,
+				     struct queue_limits *lim)
 {
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	struct pata_macio_priv *priv =3D ap->private_data;
@@ -822,7 +822,7 @@ static int pata_macio_device_configure(struct scsi_de=
vice *sdev,
 	int rc;
=20
 	/* First call original */
-	rc =3D ata_scsi_device_configure(sdev, lim);
+	rc =3D ata_scsi_sdev_configure(sdev, lim);
 	if (rc)
 		return rc;
=20
@@ -932,7 +932,7 @@ static const struct scsi_host_template pata_macio_sht=
 =3D {
 	/* We may not need that strict one */
 	.dma_boundary		=3D ATA_DMA_BOUNDARY,
 	.max_segment_size	=3D PATA_MACIO_MAX_SEGMENT_SIZE,
-	.device_configure	=3D pata_macio_device_configure,
+	.sdev_configure		=3D pata_macio_sdev_configure,
 	.sdev_groups		=3D ata_common_sdev_groups,
 	.can_queue		=3D ATA_DEF_QUEUE,
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 05c905827dc5..705f9bae2175 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -673,7 +673,7 @@ static const struct scsi_host_template mv6_sht =3D {
 	.sdev_groups		=3D ata_ncq_sdev_groups,
 	.change_queue_depth	=3D ata_scsi_change_queue_depth,
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,
-	.device_configure	=3D ata_scsi_device_configure
+	.sdev_configure		=3D ata_scsi_sdev_configure
 };
=20
 static struct ata_port_operations mv5_ops =3D {
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 36d99043ef50..b62b8ebdd89f 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -296,8 +296,8 @@ static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_adma_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim);
+static int nv_adma_sdev_configure(struct scsi_device *sdev,
+				  struct queue_limits *lim);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static enum ata_completion_errors nv_adma_qc_prep(struct ata_queued_cmd =
*qc);
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc);
@@ -319,8 +319,8 @@ static void nv_adma_tf_read(struct ata_port *ap, stru=
ct ata_taskfile *tf);
 static void nv_mcp55_thaw(struct ata_port *ap);
 static void nv_mcp55_freeze(struct ata_port *ap);
 static void nv_swncq_error_handler(struct ata_port *ap);
-static int nv_swncq_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim);
+static int nv_swncq_sdev_configure(struct scsi_device *sdev,
+				   struct queue_limits *lim);
 static int nv_swncq_port_start(struct ata_port *ap);
 static enum ata_completion_errors nv_swncq_qc_prep(struct ata_queued_cmd=
 *qc);
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
@@ -382,7 +382,7 @@ static const struct scsi_host_template nv_adma_sht =3D=
 {
 	.can_queue		=3D NV_ADMA_MAX_CPBS,
 	.sg_tablesize		=3D NV_ADMA_SGTBL_TOTAL_LEN,
 	.dma_boundary		=3D NV_ADMA_DMA_BOUNDARY,
-	.device_configure	=3D nv_adma_device_configure,
+	.sdev_configure		=3D nv_adma_sdev_configure,
 	.sdev_groups		=3D ata_ncq_sdev_groups,
 	.change_queue_depth     =3D ata_scsi_change_queue_depth,
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,
@@ -393,7 +393,7 @@ static const struct scsi_host_template nv_swncq_sht =3D=
 {
 	.can_queue		=3D ATA_MAX_QUEUE - 1,
 	.sg_tablesize		=3D LIBATA_MAX_PRD,
 	.dma_boundary		=3D ATA_DMA_BOUNDARY,
-	.device_configure	=3D nv_swncq_device_configure,
+	.sdev_configure		=3D nv_swncq_sdev_configure,
 	.sdev_groups		=3D ata_ncq_sdev_groups,
 	.change_queue_depth     =3D ata_scsi_change_queue_depth,
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,
@@ -663,8 +663,8 @@ static void nv_adma_mode(struct ata_port *ap)
 	pp->flags &=3D ~NV_ADMA_PORT_REGISTER_MODE;
 }
=20
-static int nv_adma_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int nv_adma_sdev_configure(struct scsi_device *sdev,
+				  struct queue_limits *lim)
 {
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	struct nv_adma_port_priv *pp =3D ap->private_data;
@@ -676,7 +676,7 @@ static int nv_adma_device_configure(struct scsi_devic=
e *sdev,
 	int adma_enable;
 	u32 current_reg, new_reg, config_mask;
=20
-	rc =3D ata_scsi_device_configure(sdev, lim);
+	rc =3D ata_scsi_sdev_configure(sdev, lim);
=20
 	if (sdev->id >=3D ATA_MAX_DEVICES || sdev->channel || sdev->lun)
 		/* Not a proper libata device, ignore */
@@ -1871,8 +1871,8 @@ static void nv_swncq_host_init(struct ata_host *hos=
t)
 	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
 }
=20
-static int nv_swncq_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int nv_swncq_sdev_configure(struct scsi_device *sdev,
+				   struct queue_limits *lim)
 {
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	struct pci_dev *pdev =3D to_pci_dev(ap->host->dev);
@@ -1882,7 +1882,7 @@ static int nv_swncq_device_configure(struct scsi_de=
vice *sdev,
 	u8 check_maxtor =3D 0;
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
=20
-	rc =3D ata_scsi_device_configure(sdev, lim);
+	rc =3D ata_scsi_sdev_configure(sdev, lim);
 	if (sdev->id >=3D ATA_MAX_DEVICES || sdev->channel || sdev->lun)
 		/* Not a proper libata device, ignore */
 		return rc;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 72c03cbdaff4..3e0be0399619 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -381,7 +381,7 @@ static const struct scsi_host_template sil24_sht =3D =
{
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_FIFO,
 	.sdev_groups		=3D ata_ncq_sdev_groups,
 	.change_queue_depth	=3D ata_scsi_change_queue_depth,
-	.device_configure	=3D ata_scsi_device_configure
+	.sdev_configure		=3D ata_scsi_sdev_configure
 };
=20
 static struct ata_port_operations sil24_ops =3D {
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4937df12c3fb..1a19828114cf 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1506,8 +1506,8 @@ static int sbp2_scsi_sdev_init(struct scsi_device *=
sdev)
 	return 0;
 }
=20
-static int sbp2_scsi_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int sbp2_scsi_sdev_configure(struct scsi_device *sdev,
+				    struct queue_limits *lim)
 {
 	struct sbp2_logical_unit *lu =3D sdev->hostdata;
=20
@@ -1591,7 +1591,7 @@ static const struct scsi_host_template scsi_driver_=
template =3D {
 	.proc_name		=3D "sbp2",
 	.queuecommand		=3D sbp2_scsi_queuecommand,
 	.sdev_init		=3D sbp2_scsi_sdev_init,
-	.device_configure	=3D sbp2_scsi_device_configure,
+	.sdev_configure		=3D sbp2_scsi_sdev_configure,
 	.eh_abort_handler	=3D sbp2_scsi_abort,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D SG_ALL,
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/his=
i_sas.h
index fee3cadfde1e..45ea313b342b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -644,8 +644,7 @@ extern int hisi_sas_probe(struct platform_device *pde=
v,
 			  const struct hisi_sas_hw *ops);
 extern void hisi_sas_remove(struct platform_device *pdev);
=20
-int hisi_sas_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim);
+int hisi_sas_sdev_configure(struct scsi_device *sdev, struct queue_limit=
s *lim);
 extern int hisi_sas_sdev_init(struct scsi_device *sdev);
 extern int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long=
 time);
 extern void hisi_sas_scan_start(struct Scsi_Host *shost);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
index a80d8b2a9941..da4a2ed8ee86 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -868,11 +868,10 @@ static int hisi_sas_dev_found(struct domain_device =
*device)
 	return rc;
 }
=20
-int hisi_sas_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+int hisi_sas_sdev_configure(struct scsi_device *sdev, struct queue_limit=
s *lim)
 {
 	struct domain_device *dev =3D sdev_to_domain_dev(sdev);
-	int ret =3D sas_device_configure(sdev, lim);
+	int ret =3D sas_sdev_configure(sdev, lim);
=20
 	if (ret)
 		return ret;
@@ -881,7 +880,7 @@ int hisi_sas_device_configure(struct scsi_device *sde=
v,
=20
 	return 0;
 }
-EXPORT_SYMBOL_GPL(hisi_sas_device_configure);
+EXPORT_SYMBOL_GPL(hisi_sas_sdev_configure);
=20
 void hisi_sas_scan_start(struct Scsi_Host *shost)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v1_hw.c
index 71e1353e9eaa..3efc9cb26378 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1753,7 +1753,7 @@ static int check_fw_info_v1_hw(struct hisi_hba *his=
i_hba)
=20
 static const struct scsi_host_template sht_v1_hw =3D {
 	LIBSAS_SHT_BASE_NO_SLAVE_INIT
-	.device_configure	=3D hisi_sas_device_configure,
+	.sdev_configure		=3D hisi_sas_sdev_configure,
 	.scan_finished		=3D hisi_sas_scan_finished,
 	.scan_start		=3D hisi_sas_scan_start,
 	.sg_tablesize		=3D HISI_SAS_SGE_PAGE_CNT,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v2_hw.c
index d28d673ecad0..fe25403dd53a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3585,7 +3585,7 @@ static int check_fw_info_v2_hw(struct hisi_hba *his=
i_hba)
=20
 static const struct scsi_host_template sht_v2_hw =3D {
 	LIBSAS_SHT_BASE_NO_SLAVE_INIT
-	.device_configure	=3D hisi_sas_device_configure,
+	.sdev_configure		=3D hisi_sas_sdev_configure,
 	.scan_finished		=3D hisi_sas_scan_finished,
 	.scan_start		=3D hisi_sas_scan_start,
 	.sg_tablesize		=3D HISI_SAS_SGE_PAGE_CNT,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
index 5758388508ec..6766995e227b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2908,12 +2908,12 @@ static ssize_t iopoll_q_cnt_v3_hw_show(struct dev=
ice *dev,
 }
 static DEVICE_ATTR_RO(iopoll_q_cnt_v3_hw);
=20
-static int device_configure_v3_hw(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int sdev_configure_v3_hw(struct scsi_device *sdev,
+				struct queue_limits *lim)
 {
 	struct Scsi_Host *shost =3D dev_to_shost(&sdev->sdev_gendev);
 	struct hisi_hba *hisi_hba =3D shost_priv(shost);
-	int ret =3D hisi_sas_device_configure(sdev, lim);
+	int ret =3D hisi_sas_sdev_configure(sdev, lim);
 	struct device *dev =3D hisi_hba->dev;
=20
 	if (ret)
@@ -3336,7 +3336,7 @@ static void hisi_sas_map_queues(struct Scsi_Host *s=
host)
=20
 static const struct scsi_host_template sht_v3_hw =3D {
 	LIBSAS_SHT_BASE_NO_SLAVE_INIT
-	.device_configure	=3D device_configure_v3_hw,
+	.sdev_configure		=3D sdev_configure_v3_hw,
 	.scan_finished		=3D hisi_sas_scan_finished,
 	.scan_start		=3D hisi_sas_scan_start,
 	.map_queues		=3D hisi_sas_map_queues,
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index e889f268601b..55eee5b0f0d7 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1151,8 +1151,8 @@ static struct attribute *hptiop_host_attrs[] =3D {
=20
 ATTRIBUTE_GROUPS(hptiop_host);
=20
-static int hptiop_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int hptiop_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	if (sdev->type =3D=3D TYPE_TAPE)
 		lim->max_hw_sectors =3D 8192;
@@ -1168,7 +1168,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.emulated                   =3D 0,
 	.proc_name                  =3D driver_name,
 	.shost_groups		    =3D hptiop_host_groups,
-	.device_configure	    =3D hptiop_device_configure,
+	.sdev_configure		    =3D hptiop_sdev_configure,
 	.this_id                    =3D -1,
 	.change_queue_depth         =3D hptiop_adjust_disk_queue_depth,
 	.cmd_size		    =3D sizeof(struct hpt_cmd_priv),
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 41bc54e27896..f0444faf776a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4769,7 +4769,7 @@ static void ipr_sdev_destroy(struct scsi_device *sd=
ev)
 }
=20
 /**
- * ipr_device_configure - Configure a SCSI device
+ * ipr_sdev_configure - Configure a SCSI device
  * @sdev:	scsi device struct
  * @lim:	queue limits
  *
@@ -4778,8 +4778,8 @@ static void ipr_sdev_destroy(struct scsi_device *sd=
ev)
  * Return value:
  * 	0 on success
  **/
-static int ipr_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int ipr_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	struct ipr_ioa_cfg *ioa_cfg =3D (struct ipr_ioa_cfg *) sdev->host->host=
data;
 	struct ipr_resource_entry *res;
@@ -6399,7 +6399,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.eh_device_reset_handler =3D ipr_eh_dev_reset,
 	.eh_host_reset_handler =3D ipr_eh_host_reset,
 	.sdev_init =3D ipr_sdev_init,
-	.device_configure =3D ipr_device_configure,
+	.sdev_configure =3D ipr_sdev_configure,
 	.sdev_destroy =3D ipr_sdev_destroy,
 	.scan_finished =3D ipr_scan_finished,
 	.target_destroy =3D ipr_target_destroy,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c708e1059638..e81f60985193 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1057,8 +1057,8 @@ static umode_t iscsi_sw_tcp_attr_is_visible(int par=
am_type, int param)
 	return 0;
 }
=20
-static int iscsi_sw_tcp_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int iscsi_sw_tcp_sdev_configure(struct scsi_device *sdev,
+				       struct queue_limits *lim)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host =3D iscsi_host_priv(sdev->host);
 	struct iscsi_session *session =3D tcp_sw_host->session;
@@ -1083,7 +1083,7 @@ static const struct scsi_host_template iscsi_sw_tcp=
_sht =3D {
 	.eh_device_reset_handler=3D iscsi_eh_device_reset,
 	.eh_target_reset_handler =3D iscsi_eh_recover_target,
 	.dma_boundary		=3D PAGE_SIZE - 1,
-	.device_configure	=3D iscsi_sw_tcp_device_configure,
+	.sdev_configure		=3D iscsi_sw_tcp_sdev_configure,
 	.proc_name		=3D "iscsi_tcp",
 	.this_id		=3D -1,
 	.track_queue_depth	=3D 1,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sa=
s_scsi_host.c
index e7d5093f7c5d..55ce7892f217 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -804,15 +804,14 @@ EXPORT_SYMBOL_GPL(sas_target_alloc);
=20
 #define SAS_DEF_QD 256
=20
-int sas_device_configure(struct scsi_device *scsi_dev,
-		struct queue_limits *lim)
+int sas_sdev_configure(struct scsi_device *scsi_dev, struct queue_limits=
 *lim)
 {
 	struct domain_device *dev =3D sdev_to_domain_dev(scsi_dev);
=20
 	BUG_ON(dev->rphy->identify.device_type !=3D SAS_END_DEVICE);
=20
 	if (dev_is_sata(dev)) {
-		ata_sas_device_configure(scsi_dev, lim, dev->sata_dev.ap);
+		ata_sas_sdev_configure(scsi_dev, lim, dev->sata_dev.ap);
 		return 0;
 	}
=20
@@ -830,7 +829,7 @@ int sas_device_configure(struct scsi_device *scsi_dev=
,
=20
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sas_device_configure);
+EXPORT_SYMBOL_GPL(sas_sdev_configure);
=20
 int sas_change_queue_depth(struct scsi_device *sdev, int depth)
 {
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index 56cb240d9631..d7b0fbce88fa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2068,8 +2068,8 @@ static void megasas_set_static_target_properties(st=
ruct scsi_device *sdev,
 }
=20
=20
-static int megasas_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int megasas_sdev_configure(struct scsi_device *sdev,
+				  struct queue_limits *lim)
 {
 	u16 pd_index =3D 0;
 	struct megasas_instance *instance;
@@ -3510,7 +3510,7 @@ static const struct scsi_host_template megasas_temp=
late =3D {
 	.module =3D THIS_MODULE,
 	.name =3D "Avago SAS based MegaRAID driver",
 	.proc_name =3D "megaraid_sas",
-	.device_configure =3D megasas_device_configure,
+	.sdev_configure =3D megasas_sdev_configure,
 	.sdev_init =3D megasas_sdev_init,
 	.sdev_destroy =3D megasas_sdev_destroy,
 	.queuecommand =3D megasas_queue_command,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index 6b9f453565f2..f84bdce8c65c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4552,7 +4552,7 @@ static void mpi3mr_target_destroy(struct scsi_targe=
t *starget)
 }
=20
 /**
- * mpi3mr_device_configure - Slave configure callback handler
+ * mpi3mr_sdev_configure - Slave configure callback handler
  * @sdev: SCSI device reference
  * @lim: queue limits
  *
@@ -4561,8 +4561,8 @@ static void mpi3mr_target_destroy(struct scsi_targe=
t *starget)
  *
  * Return: 0 always.
  */
-static int mpi3mr_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int mpi3mr_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
@@ -5063,7 +5063,7 @@ static const struct scsi_host_template mpi3mr_drive=
r_template =3D {
 	.queuecommand			=3D mpi3mr_qcmd,
 	.target_alloc			=3D mpi3mr_target_alloc,
 	.sdev_init			=3D mpi3mr_sdev_init,
-	.device_configure		=3D mpi3mr_device_configure,
+	.sdev_configure			=3D mpi3mr_sdev_configure,
 	.target_destroy			=3D mpi3mr_target_destroy,
 	.sdev_destroy			=3D mpi3mr_sdev_destroy,
 	.scan_finished			=3D mpi3mr_scan_finished,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index f113fba81f02..38cb83793f9d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2497,7 +2497,7 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, stru=
ct scsi_device *sdev)
 }
=20
 /**
- * scsih_device_configure - device configure routine.
+ * scsih_sdev_configure - device configure routine.
  * @sdev: scsi device struct
  * @lim: queue limits
  *
@@ -2505,7 +2505,7 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, stru=
ct scsi_device *sdev)
  * the device is ignored.
  */
 static int
-scsih_device_configure(struct scsi_device *sdev, struct queue_limits *li=
m)
+scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	struct Scsi_Host *shost =3D sdev->host;
 	struct MPT3SAS_ADAPTER *ioc =3D shost_priv(shost);
@@ -11906,7 +11906,7 @@ static const struct scsi_host_template mpt2sas_dr=
iver_template =3D {
 	.queuecommand			=3D scsih_qcmd,
 	.target_alloc			=3D scsih_target_alloc,
 	.sdev_init			=3D scsih_sdev_init,
-	.device_configure		=3D scsih_device_configure,
+	.sdev_configure			=3D scsih_sdev_configure,
 	.target_destroy			=3D scsih_target_destroy,
 	.sdev_destroy			=3D scsih_sdev_destroy,
 	.scan_finished			=3D scsih_scan_finished,
@@ -11944,7 +11944,7 @@ static const struct scsi_host_template mpt3sas_dr=
iver_template =3D {
 	.queuecommand			=3D scsih_qcmd,
 	.target_alloc			=3D scsih_target_alloc,
 	.sdev_init			=3D scsih_sdev_init,
-	.device_configure		=3D scsih_device_configure,
+	.sdev_configure			=3D scsih_sdev_configure,
 	.target_destroy			=3D scsih_target_destroy,
 	.sdev_destroy			=3D scsih_sdev_destroy,
 	.scan_finished			=3D scsih_scan_finished,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d9e6e75e801c..2342ded7ee78 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -197,7 +197,7 @@ static int pmcraid_sdev_init(struct scsi_device *scsi=
_dev)
 }
=20
 /**
- * pmcraid_device_configure - Configures a SCSI device
+ * pmcraid_sdev_configure - Configures a SCSI device
  * @scsi_dev: scsi device struct
  * @lim: queue limits
  *
@@ -210,8 +210,8 @@ static int pmcraid_sdev_init(struct scsi_device *scsi=
_dev)
  * Return value:
  *	  0 on success
  */
-static int pmcraid_device_configure(struct scsi_device *scsi_dev,
-		struct queue_limits *lim)
+static int pmcraid_sdev_configure(struct scsi_device *scsi_dev,
+				  struct queue_limits *lim)
 {
 	struct pmcraid_resource_entry *res =3D scsi_dev->hostdata;
=20
@@ -3669,7 +3669,7 @@ static const struct scsi_host_template pmcraid_host=
_template =3D {
 	.eh_host_reset_handler =3D pmcraid_eh_host_reset_handler,
=20
 	.sdev_init =3D pmcraid_sdev_init,
-	.device_configure =3D pmcraid_device_configure,
+	.sdev_configure =3D pmcraid_sdev_configure,
 	.sdev_destroy =3D pmcraid_sdev_destroy,
 	.change_queue_depth =3D pmcraid_change_queue_depth,
 	.can_queue =3D PMCRAID_MAX_IO_CMD,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index da8aecc9d304..b60c218dc0d0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -227,7 +227,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_d=
evice *sdev,
=20
 	/*
 	 * realloc if new shift is calculated, which is caused by setting
-	 * up one new default queue depth after calling ->device_configure
+	 * up one new default queue depth after calling ->sdev_configure
 	 */
 	if (!need_alloc && new_shift !=3D sdev->budget_map.shift)
 		need_alloc =3D need_free =3D true;
@@ -1074,8 +1074,8 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 	else if (*bflags & BLIST_MAX_1024)
 		lim.max_hw_sectors =3D 1024;
=20
-	if (hostt->device_configure)
-		ret =3D hostt->device_configure(sdev, &lim);
+	if (hostt->sdev_configure)
+		ret =3D hostt->sdev_configure(sdev, &lim);
 	else if (hostt->slave_configure)
 		ret =3D hostt->slave_configure(sdev);
 	if (ret) {
@@ -1097,12 +1097,12 @@ static int scsi_add_lun(struct scsi_device *sdev,=
 unsigned char *inq_result,
 	}
=20
 	/*
-	 * The queue_depth is often changed in ->device_configure.
+	 * The queue_depth is often changed in ->sdev_configure.
 	 *
 	 * Set up budget map again since memory consumption of the map depends
 	 * on actual queue depth.
 	 */
-	if (hostt->device_configure || hostt->slave_configure)
+	if (hostt->sdev_configure || hostt->slave_configure)
 		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
=20
 	if (sdev->scsi_level >=3D SCSI_3)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 36410c2e1ee4..d6b4e9404087 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5225,14 +5225,14 @@ static int ufshcd_change_queue_depth(struct scsi_=
device *sdev, int depth)
 }
=20
 /**
- * ufshcd_device_configure - adjust SCSI device configurations
+ * ufshcd_sdev_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
  * @lim: queue limits
  *
  * Return: 0 (success).
  */
-static int ufshcd_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int ufshcd_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	struct ufs_hba *hba =3D shost_priv(sdev->host);
 	struct request_queue *q =3D sdev->request_queue;
@@ -8974,7 +8974,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
-	.device_configure	=3D ufshcd_device_configure,
+	.sdev_configure		=3D ufshcd_sdev_configure,
 	.sdev_destroy		=3D ufshcd_sdev_destroy,
 	.change_queue_depth	=3D ufshcd_change_queue_depth,
 	.eh_abort_handler	=3D ufshcd_abort,
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglu=
e.c
index a64ce2aca9ec..7e2ee926200d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -88,7 +88,7 @@ static int sdev_init (struct scsi_device *sdev)
 	return 0;
 }
=20
-static int device_configure(struct scsi_device *sdev, struct queue_limit=
s *lim)
+static int sdev_configure(struct scsi_device *sdev, struct queue_limits =
*lim)
 {
 	struct us_data *us =3D host_to_us(sdev->host);
 	struct device *dev =3D us->pusb_dev->bus->sysdev;
@@ -638,7 +638,7 @@ static const struct scsi_host_template usb_stor_host_=
template =3D {
 	.this_id =3D			-1,
=20
 	.sdev_init =3D			sdev_init,
-	.device_configure =3D		device_configure,
+	.sdev_configure =3D		sdev_configure,
 	.target_alloc =3D			target_alloc,
=20
 	/* lots of sg segments can be handled */
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 7bd2a314b329..0bb9ea875843 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -832,8 +832,8 @@ static int uas_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
=20
-static int uas_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim)
+static int uas_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	struct uas_dev_info *devinfo =3D sdev->hostdata;
=20
@@ -906,7 +906,7 @@ static const struct scsi_host_template uas_host_templ=
ate =3D {
 	.queuecommand =3D uas_queuecommand,
 	.target_alloc =3D uas_target_alloc,
 	.sdev_init =3D uas_sdev_init,
-	.device_configure =3D uas_device_configure,
+	.sdev_configure =3D uas_sdev_configure,
 	.eh_abort_handler =3D uas_eh_abort_handler,
 	.eh_device_reset_handler =3D uas_eh_device_reset_handler,
 	.this_id =3D -1,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3318004a1b18..59d6d17955fb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1202,8 +1202,7 @@ extern int ata_std_bios_param(struct scsi_device *s=
dev,
 			      sector_t capacity, int geom[]);
 extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
 extern int ata_scsi_sdev_init(struct scsi_device *sdev);
-int ata_scsi_device_configure(struct scsi_device *sdev,
-		struct queue_limits *lim);
+int ata_scsi_sdev_configure(struct scsi_device *sdev, struct queue_limit=
s *lim);
 extern void ata_scsi_sdev_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
@@ -1303,8 +1302,8 @@ extern struct ata_port *ata_port_alloc(struct ata_h=
ost *host);
 extern void ata_port_free(struct ata_port *ap);
 extern int ata_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_tport_delete(struct ata_port *ap);
-int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limi=
ts *lim,
-		struct ata_port *ap);
+int ata_sas_sdev_configure(struct scsi_device *sdev, struct queue_limits=
 *lim,
+			   struct ata_port *ap);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
@@ -1470,13 +1469,13 @@ extern const struct attribute_group *ata_common_s=
dev_groups[];
 	__ATA_BASE_SHT(drv_name),				\
 	.can_queue		=3D ATA_DEF_QUEUE,		\
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,		\
-	.device_configure	=3D ata_scsi_device_configure
+	.sdev_configure		=3D ata_scsi_sdev_configure
=20
 #define ATA_SUBBASE_SHT_QD(drv_name, drv_qd)			\
 	__ATA_BASE_SHT(drv_name),				\
 	.can_queue		=3D drv_qd,			\
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,		\
-	.device_configure	=3D ata_scsi_device_configure
+	.sdev_configure		=3D ata_scsi_sdev_configure
=20
 #define ATA_BASE_SHT(drv_name)					\
 	ATA_SUBBASE_SHT(drv_name),				\
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index f30f716ba045..ba460b6c0374 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -683,8 +683,7 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset=
);
 int sas_phy_enable(struct sas_phy *phy, int enable);
 extern int sas_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
-int sas_device_configure(struct scsi_device *dev,
-		struct queue_limits *lim);
+int sas_sdev_configure(struct scsi_device *dev, struct queue_limits *lim=
);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
 extern int sas_bios_param(struct scsi_device *, struct block_device *,
 			  sector_t capacity, int *hsc);
@@ -750,7 +749,7 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, en=
um phy_event event,
 #endif
=20
 #define LIBSAS_SHT_BASE			_LIBSAS_SHT_BASE		\
-	.device_configure		=3D sas_device_configure,		\
+	.sdev_configure			=3D sas_sdev_configure,		\
 	.sdev_init			=3D sas_sdev_init,		\
=20
 #define LIBSAS_SHT_BASE_NO_SLAVE_INIT	_LIBSAS_SHT_BASE
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 58b29cc6de09..7e1b1a54e46a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -212,10 +212,10 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 *
-	 * Note: slave_configure is the legacy version, use device_configure fo=
r
+	 * Note: slave_configure is the legacy version, use sdev_configure for
 	 * all new code.  A driver must never define both.
 	 */
-	int (* device_configure)(struct scsi_device *, struct queue_limits *lim=
);
+	int (* sdev_configure)(struct scsi_device *, struct queue_limits *lim);
 	int (* slave_configure)(struct scsi_device *);
=20
 	/*

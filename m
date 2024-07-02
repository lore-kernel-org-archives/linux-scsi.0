Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF47F1BD509;
	Tue,  2 Jul 2024 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936542; cv=none; b=fxDq51/N8cYk/+cXb3fa0SqMQmptonlgDKhAHSs+q6mvBE38VG4SrZwNt9GFxwEGAWIfpLQh39epjnj03CD2vnzhlKF4AM929Evh0TjIC4WVvyXNPukoQps+o39XyqSR51wTxxXANWmNsmYHclAihtqt3OsTPw49bVIsWis7j8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936542; c=relaxed/simple;
	bh=2nXhznD2n9mOsTraJeYedHQ0dd5sSbCQv+ynUdP05NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSellL4292/qb5qU6QOWyR6mugk+oeWtSpU4cyZcU3xAS639+Hfw/FB3DZtXD24JLhdr15EFKbxIVorKILe7UpdMTKX76bPLimcXQM/q/Tif07MP3gxKiR+/m4oAFY5frkp31VkwGUiZ2ZjZgWWeFOxhvi7vUVIj6cpr9Hkn1UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLaZpjrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLaZpjrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61267C116B1;
	Tue,  2 Jul 2024 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936542;
	bh=2nXhznD2n9mOsTraJeYedHQ0dd5sSbCQv+ynUdP05NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLaZpjrpfv35c2JtAlDfcFZqCEo1b7ncq4PrKR22/s0dr2PhgHbZqs+UEGozNJ57h
	 jeTSZ1TRLTn9WnCZyDVn6w+zBgamuhd9ntfcjPQO6pNBvc3MTqAdXEEFG8jSMu2DWf
	 aosUUo3X+c6JWgj4EQVeD9MGH++Zw2f4rrw9qFjwsUm0JwaHUTDRHcItXKrkjo8xYp
	 ZB3GxBOOi+VXKY2lNu+tEVhrCsNqo71/OCLcu5r1OYSFCUpJzS91x1f1QUbfGsc0ie
	 FkA/tpbOm2kdYOglzOKOO85CuWfbxtkxg5LMVCLQojBCmPDLnxsvNvc6VtLxBQpgmD
	 IfnPKiWo1XrYQ==
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
Subject: [PATCH v3 8/9] ata,scsi: Remove useless ata_sas_port_alloc() wrapper
Date: Tue,  2 Jul 2024 18:08:04 +0200
Message-ID: <20240702160756.596955-19-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4634; i=cassel@kernel.org; h=from:subject; bh=2nXhznD2n9mOsTraJeYedHQ0dd5sSbCQv+ynUdP05NI=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ/Z+Z9fuYNrDzvvnGMLP8rmLvxn337v+d+JgonLG bp4pwQEdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiGgsYGdZdP1rWOksxkn3x 1s1HNps5Z97cUcH7+ZRwLHvY09tyTy4yMvzoeeXFoGtVMJn9T57vp5tnUm6FmRkqyc8LvcH4sKL qKCcA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Now when the ap->print_id assignment has moved to ata_port_alloc(),
we can remove the useless ata_sas_port_alloc() wrapper.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c     |  1 +
 drivers/ata/libata-sata.c     | 35 -----------------------------------
 drivers/ata/libata.h          |  1 -
 drivers/scsi/libsas/sas_ata.c | 10 ++++++++--
 include/linux/libata.h        |  3 +--
 5 files changed, 10 insertions(+), 40 deletions(-)

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
index ab4ddeea4909..80299f517081 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -597,13 +597,19 @@ int sas_ata_init(struct domain_device *found_dev)
 
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
+	ap->pio_mask = sata_port_info.pio_mask;
+	ap->mwdma_mask = sata_port_info.mwdma_mask;
+	ap->udma_mask = sata_port_info.udma_mask;
+	ap->flags |= sata_port_info.flags;
+	ap->ops = sata_port_info.port_ops;
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


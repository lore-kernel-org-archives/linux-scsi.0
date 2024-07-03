Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C42188CD1;
	Wed,  3 Jul 2024 18:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032291; cv=none; b=h6NZhT5O9qCQfcY/OjQDFec2u79rKsBcVEDekXLFs2dE0mOoHfRfXFTrZ6+5iouFDlFqoGRIFuGIIoOHaBRZKffaRAM+hOSV84Ggf7pz4tZgz1fdV3sQkUvBu4V7/EBWYwZTnrsWP9WwyjUm8sAZbISCzOU4w15SmhfmNWGaZig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032291; c=relaxed/simple;
	bh=S858SQVX9YmHmjvKLTMN0yzpfs0SRvbPJQP2a+vy2SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa3EqAdRpSv1ZCAaKynBE0bekGbkS7O2nbZTfyYOlT2EuyuXJL1m32ii33DQjcc/1rhOBl84MkZlnaukGUY4MR4RooI6mC9ohf+7vuTYSCeL9L/970e80IaboFwRoIWx32LpvZjgc3avzoYQF0Wb6rkJVlLYDs+8p/8qKFr9caU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKHgpQrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKHgpQrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2317DC2BD10;
	Wed,  3 Jul 2024 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032291;
	bh=S858SQVX9YmHmjvKLTMN0yzpfs0SRvbPJQP2a+vy2SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKHgpQrr1foav0yInaPMFdcQuXS8t2vpYUl/SEgz0+fNRcJT9eIhD3XY7xgRU8Zql
	 lrvVw36pb1hZ4EKC0jeG9jLmpZqLUMDabOBizC3SF7xF96qH/oPs/TxjjF1NbieIcQ
	 a7fQ3g3Un4hyG0GCk5aQQ894MluzcphdZlRPd79Y7rOXI7aKcPvXWHkhUGd34KoaEZ
	 fDWFCbo3lIJkSZSx++NmUtDMTQAHIl3F0t3xBw86VLLuLvdD11FOCGhkQ08rSeB454
	 uRasiFj5tMRVT5DUPq6oUdfptOiZENs7JcqEHfNPN+GAneOwvNgNjfXdDtBzieCn2+
	 tVwc9FJIgV2HA==
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
Subject: [PATCH v4 1/9] ata,scsi: Remove wrappers ata_sas_tport_{add,delete}()
Date: Wed,  3 Jul 2024 20:44:18 +0200
Message-ID: <20240703184418.723066-12-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4533; i=cassel@kernel.org; h=from:subject; bh=S858SQVX9YmHmjvKLTMN0yzpfs0SRvbPJQP2a+vy2SE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa53B5XFP7tvOmk8vLqd+W33cyPlXv8OVsYmDbBcGN3 EzvTuiad5SyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAibvGMDG2srx7++P728JSq 0J2ZF8VrfV52bJt67/Bsk812S5u2LVZiZFjO8ftv/d63Sx72JOxaJrlzgqI+/9m2edqyH6TvCj+ WdOIHAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

The ata_sas_tport_add() and ata_sas_tport_delete() wrappers only exist in
order to export the internal libata functions which they wrap.
Remove the wrappers and instead export the libata functions directly.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-sata.c          | 12 ------------
 drivers/ata/libata-transport.c     |  2 ++
 drivers/ata/libata-transport.h     |  3 ---
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  4 ++--
 6 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 9e047bf912b1..e7991595bfe5 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1241,18 +1241,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
 
-int ata_sas_tport_add(struct device *parent, struct ata_port *ap)
-{
-	return ata_tport_add(parent, ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_tport_add);
-
-void ata_sas_tport_delete(struct ata_port *ap)
-{
-	ata_tport_delete(ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
-
 /**
  *	ata_sas_device_configure - Default device_configure routine for libata
  *				   devices
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 3e49a877500e..d24f201c0ab2 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -265,6 +265,7 @@ void ata_tport_delete(struct ata_port *ap)
 	transport_destroy_device(dev);
 	put_device(dev);
 }
+EXPORT_SYMBOL_GPL(ata_tport_delete);
 
 static const struct device_type ata_port_sas_type = {
 	.name = ATA_PORT_TYPE_NAME,
@@ -329,6 +330,7 @@ int ata_tport_add(struct device *parent,
 	put_device(dev);
 	return error;
 }
+EXPORT_SYMBOL_GPL(ata_tport_add);
 
 /**
  *     ata_port_classify - determine device type based on ATA-spec signature
diff --git a/drivers/ata/libata-transport.h b/drivers/ata/libata-transport.h
index 08a57fb9dc61..50cd2cbe8eea 100644
--- a/drivers/ata/libata-transport.h
+++ b/drivers/ata/libata-transport.h
@@ -8,9 +8,6 @@ extern struct scsi_transport_template *ata_scsi_transport_template;
 int ata_tlink_add(struct ata_link *link);
 void ata_tlink_delete(struct ata_link *link);
 
-int ata_tport_add(struct device *parent, struct ata_port *ap);
-void ata_tport_delete(struct ata_port *ap);
-
 struct scsi_transport_template *ata_attach_transport(void);
 void ata_release_transport(struct scsi_transport_template *t);
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index cbbe43d8ef87..ab4ddeea4909 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -608,7 +608,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
 
-	rc = ata_sas_tport_add(ata_host->dev, ap);
+	rc = ata_tport_add(ata_host->dev, ap);
 	if (rc)
 		goto free_port;
 
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 48d975c6dbf2..951bdc554a10 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -300,7 +300,7 @@ void sas_free_device(struct kref *kref)
 		kfree(dev->ex_dev.ex_phy);
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
-		ata_sas_tport_delete(dev->sata_dev.ap);
+		ata_tport_delete(dev->sata_dev.ap);
 		ata_port_free(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7d3bd7c9664a..586f0116d1d7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1250,8 +1250,8 @@ extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
 extern void ata_port_free(struct ata_port *ap);
-extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
-extern void ata_sas_tport_delete(struct ata_port *ap);
+extern int ata_tport_add(struct device *parent, struct ata_port *ap);
+extern void ata_tport_delete(struct ata_port *ap);
 int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
 		struct ata_port *ap);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
-- 
2.45.2


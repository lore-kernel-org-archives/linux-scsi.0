Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C550415B55D;
	Wed, 26 Jun 2024 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424879; cv=none; b=iMFOA1uYpXStRytxFZtNLKdqJq1LF8awBrPNN4K16skXqHiu+v7qwu2denVNG3/FmlNc1fzPGmIs9xXcVSF36FTnEu3OJEfDHLHAFe3qD0RVMarymKFsP/OAbgZP6xf3jrsll3f9MXWlYOcUmRsBIIEh7pk4CMjee6k2C3E0VlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424879; c=relaxed/simple;
	bh=ZL1nwDzfI+ryUk6FQso2XK2cFPn6McHKtJqVFsUzmco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omz6tpohI5pJT7lUtaix0E53WxaxpfLzCoIkCMloAqLys5cshTJ+w4l1n8hVnNzaEW/oGmIApWM/wxcVJ0azenZQmHxsrk22etIP3J3sA+QNR8fZ4JcTQowkwp2l2r/aNfrXfgt4tfYmcP1fWMVFhl3bweliEoDe2Vs0bcSrKkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxT6rzRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxT6rzRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A2AC32782;
	Wed, 26 Jun 2024 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424879;
	bh=ZL1nwDzfI+ryUk6FQso2XK2cFPn6McHKtJqVFsUzmco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxT6rzRfjrk7P0pDEY07vpY/qNdPEKIAW8isEcJnrkQnrNiDlpyWsvy97PedEFeo6
	 T7IxHVEag1552dUY5/+aXqVHvyWevnepBIbTdILyvb42ur2V96RRdgtcpYJUW9LvNb
	 nN8MxXkW4DPjNWgL1kNA48jTb3oht6LeWsisoJW5Wh2lDNI3c6lr1ZROJ6pFsPmnQx
	 5u6D+IZ6oLfn8YPtRzcVxS7uRWYNFWWzwcJ5EsgQ7JpkNp40pTlwCgoxiNaKwyothl
	 +Re/X9uBOu5hIc73kO7JhksIY4FR9EoUXTcERJ3In7LiDCkFMNI+8A1VXBGeUWQAaS
	 rzFbB/91b3tfg==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 04/13] ata,scsi: Remove useless wrappers ata_sas_tport_{add,delete}()
Date: Wed, 26 Jun 2024 20:00:34 +0200
Message-ID: <20240626180031.4050226-19-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4300; i=cassel@kernel.org; h=from:subject; bh=ZL1nwDzfI+ryUk6FQso2XK2cFPn6McHKtJqVFsUzmco=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwh2iMiIVJ0Zx8qln53HP6ZA5uPRGytoLTMsVPk459 b9pXY94RykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACaiUcbwT/2FQ7mQ8KNzPvoJ fznnae7o33uWefaZI/s+PQkQ8A36sZPhv/ea1SphJnyKl5W7Jr08aL1P4opGiPS20CWOG+oOHly lxwAA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Remove useless wrappers ata_sas_tport_add() and ata_sas_tport_delete().

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
index 4c69fc63c119..1c2400c96ebd 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -608,7 +608,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
 
-	rc = ata_sas_tport_add(ata_host->dev, ap);
+	rc = ata_tport_add(ata_host->dev, ap);
 	if (rc)
 		goto destroy_port;
 
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 8fb7c41c0962..6e01ddec10c9 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -300,7 +300,7 @@ void sas_free_device(struct kref *kref)
 		kfree(dev->ex_dev.ex_phy);
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
-		ata_sas_tport_delete(dev->sata_dev.ap);
+		ata_tport_delete(dev->sata_dev.ap);
 		kfree(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 13fb41d25da6..581e166615fa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1249,8 +1249,8 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
-extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
-extern void ata_sas_tport_delete(struct ata_port *ap);
+extern int ata_tport_add(struct device *parent, struct ata_port *ap);
+extern void ata_tport_delete(struct ata_port *ap);
 int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
 		struct ata_port *ap);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
-- 
2.45.2


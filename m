Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96244148825;
	Tue,  2 Jul 2024 16:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936522; cv=none; b=awumPQFBCWf51aMX71WJFkAlXFKfVF3If2hVqbx4U98rbHzfliFtHKCqSgmwqA5E9BVtbvBRauhrNXSaGjguHwjeswlOaGF3iG57qx2MRTXrW26EKPvxvhWZNaP12dokJrqlxwI37Qdqgq3b0nPoDihjCUDR24oZclZQc7N68VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936522; c=relaxed/simple;
	bh=u92l4xGXPhjRxlEy8appg1I3CAXjTva0uB8D7Zqnsh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzWeVtaJU/VcA+D+ljw9kPfLDY0a684BzFrCyLeQxlTbtjb5/7LxefkdzQpNdHn79/DAVGjVnrDxYFAMhigAhkAl9i/P93TJPDUer8aGqY5okFTuY25z6FQxg4Xol6MNQnbGXSccPntf+l0p92boQ0Lm28IWSnNl4xWdh44NrvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLwKVgmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLwKVgmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B3BC116B1;
	Tue,  2 Jul 2024 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936522;
	bh=u92l4xGXPhjRxlEy8appg1I3CAXjTva0uB8D7Zqnsh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLwKVgmyoIooYet13CuwvDlEHKZorsQuimJHQhRCxqXxgUv5ONaMz3ZkHGwtCH3+5
	 F+6YpijD2wLfbY/47LD5xDjIOMnwW/6obwBMFWWg49k5Xa/mh1inIzr7w68u3QNIBs
	 CdDuZ1oHQIaQ0q3VREcgXSwEzKZXZGjavXKHijoLnOgMpJpwXEkFggxoV9r/ufSTGn
	 3C62ZS144RezETNjOSdgz9gKw9jmCz3G9s868zCXd2Y4GrfVFcgC3DQbcmNIcIcAal
	 YGLybXO6OSgMNWxnIuN8K6EzMoAR2veyKQecljCNIflQs1twqW4j7Ylo1I3xAmHeMn
	 G+HFlDDwy8cXw==
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
Subject: [PATCH v3 1/9] ata,scsi: Remove useless wrappers ata_sas_tport_{add,delete}()
Date: Tue,  2 Jul 2024 18:07:57 +0200
Message-ID: <20240702160756.596955-12-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4345; i=cassel@kernel.org; h=from:subject; bh=u92l4xGXPhjRxlEy8appg1I3CAXjTva0uB8D7Zqnsh8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVB/X/9Eq3PnTg+WWq+Fcjo0/X4v6/zTuiBPcoR/UE iAWbbalo5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABMRMGNkOCrXcl/eYLLLFv5z P3ez7Zz5+rFW3Mp7HNvmno/dENx+bB7DP/WsW61bkmx31zB5Wb+Pecco/fVN/uc6IU/Ol6vFlvt asgEA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Remove useless wrappers ata_sas_tport_add() and ata_sas_tport_delete().

Reviewed-by: Hannes Reinecke <hare@suse.de>
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


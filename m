Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6443E2574B;
	Sat, 29 Jun 2024 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719664956; cv=none; b=WZ77I7AN+v6vTaF/LTrqiYirl7nOKQ/Dg5fcfC7N0H4EsdzMHGGVbEO1yjs4jBcVyMWg4p/AS7ooy8NkCPSGxG5d9+tIXD42W0xUME+g4D+RdmmAOOrXAEY+P29JOJMqCfPpzCXTrtTIIMX3LQ0zS0+r8UfQuzyP6ZneCkbnb/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719664956; c=relaxed/simple;
	bh=8/B0SvslXTxTjDhfLJIfaceE22N2ftGQShVYBG/PkYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8toYTkgVAbjJ7WbqH/MoT9EniFPzwt3+YpvNSN78haC5FtFjcW2EpSCJXsiuiuOuqrXcD+EINvFs54MQOuzbrpXxxqv4CwClOvbWRzd767RnfcOsZJcexmWXs9cCHF4M2KrLE4F/lPHbirv/+lYLFmv1ywGyag1pVOmJg5Bgz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlMrCYGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlMrCYGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF925C2BBFC;
	Sat, 29 Jun 2024 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719664955;
	bh=8/B0SvslXTxTjDhfLJIfaceE22N2ftGQShVYBG/PkYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlMrCYGywLO/9jMbUNfLr83dbMZ2eCAJNPoiAL2MULX3cihaWaxOc2ONCW1vjoKZA
	 NLDTMsCC+0AC+8gXR6tPQ6gzfv5xMd3TqB+uujh4XRIyyTgdkbM1qUF7VNIZ7vTGQe
	 3mOPax4TyugOtRQ/WacG1vDZ6zdhqfhGsyiSUnKyr4Xb8V6F0UqMikeu87WST5WKNO
	 xyYp9TLz2jyRW5vHB4032/VzOV9lwd9CPaVzhQZyQPcCMGBaPhgPITfR+COccpbdF/
	 9X85pEd+aEh4sQ7B+UI5KjZuF30qr8Z4SOSY1X7zyihKdChwq56SARl8/Ybs6JjIyn
	 0ECq2XH810bUA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org,
	Niklas Cassel <niklas.cassel@wdc.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ata,scsi: libata-core: Do not leak memory for ata_port struct members
Date: Sat, 29 Jun 2024 14:42:12 +0200
Message-ID: <20240629124210.181537-8-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240629124210.181537-6-cassel@kernel.org>
References: <20240629124210.181537-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3737; i=cassel@kernel.org; h=from:subject; bh=8/B0SvslXTxTjDhfLJIfaceE22N2ftGQShVYBG/PkYg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNIaGNWvfKvhOvXBaHqo0jmXm8dCb81JS4hddOSiII/O4 QVLah6HdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAi134xMhxY9LAsq/O55Rxb hS7fcxbnlic+ezVtx70JFisT+xm3euxj+O96+G78O35d/Rnr3S0dn96eGVCS7J8U+WKrrGO13a7 gEh4A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

libsas is currently not freeing all the struct ata_port struct members,
e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).

Add a function, ata_port_free(), that is used to free a ata_port,
including its struct members. It makes sense to keep the code related to
freeing a ata_port in its own function, which will also free all the
struct members of struct ata_port.

Fixes: 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL commands using policy 0xD")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c          | 24 ++++++++++++++----------
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 +
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f47838da75d7..481baa55ebfc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5490,6 +5490,18 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	return ap;
 }
 
+void ata_port_free(struct ata_port *ap)
+{
+	if (!ap)
+		return;
+
+	kfree(ap->pmp_link);
+	kfree(ap->slave_link);
+	kfree(ap->ncq_sense_buf);
+	kfree(ap);
+}
+EXPORT_SYMBOL_GPL(ata_port_free);
+
 static void ata_devres_release(struct device *gendev, void *res)
 {
 	struct ata_host *host = dev_get_drvdata(gendev);
@@ -5516,15 +5528,7 @@ static void ata_host_release(struct kref *kref)
 	int i;
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (!ap)
-			continue;
-
-		kfree(ap->pmp_link);
-		kfree(ap->slave_link);
-		kfree(ap->ncq_sense_buf);
-		kfree(ap);
+		ata_port_free(host->ports[i]);
 		host->ports[i] = NULL;
 	}
 	kfree(host);
@@ -5907,7 +5911,7 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 	 * allocation time.
 	 */
 	for (i = host->n_ports; host->ports[i]; i++)
-		kfree(host->ports[i]);
+		ata_port_free(host->ports[i]);
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++) {
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 4c69fc63c119..1f247a8cd185 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -618,7 +618,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	return 0;
 
 destroy_port:
-	kfree(ap);
+	ata_port_free(ap);
 free_host:
 	ata_host_put(ata_host);
 	return rc;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 8fb7c41c0962..48d975c6dbf2 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
 		ata_sas_tport_delete(dev->sata_dev.ap);
-		kfree(dev->sata_dev.ap);
+		ata_port_free(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
 		dev->sata_dev.ap = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 13fb41d25da6..7d3bd7c9664a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1249,6 +1249,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
+extern void ata_port_free(struct ata_port *ap);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
 int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
-- 
2.45.2


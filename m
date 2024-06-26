Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5731D6E613;
	Wed, 26 Jun 2024 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424885; cv=none; b=kTfR1Iu66fV8RhyaH13rgn0Gx5aoR0tKlU7VzI9ndOf0ZWw2ZVPxMg0FAyEu4/4ScMV3q31/lmNBhjAB3xSn9x/y9Qgdvw+RxOBaApO7QlglpPzOM9/roEdrVkV4WE57I8FFG8Q7zobX2Q/Nzpf0VFZfsfVJEUsyjDPwPe3rA1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424885; c=relaxed/simple;
	bh=eW+RWOtkOzS/Mw/Oj7hVhpP1gSVa4ky/5MrpmPV8NF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRVT7xKG/mpfInI+G3fIZDludU84d5PMBxH8wsVizLss+EIWzcIUz0bOXyev46k5syPTZdknGlIwT9sZtIl7wuRyoed9C7/ip3euXrokHzDAEKQIRZRpmFCvyOdEH0l+jyKhLANyISys/GUhLi1nTT3UY0Ph+SUzYnsddczLet0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgZ5UOqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgZ5UOqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F13C4AF09;
	Wed, 26 Jun 2024 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424884;
	bh=eW+RWOtkOzS/Mw/Oj7hVhpP1gSVa4ky/5MrpmPV8NF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgZ5UOqX9C2sl/Tz8JwZxIpt/e2b2PC1gWqR34x/8UBdmEQ/GFJZ7RAdYggrvnS71
	 LNfv12YooqZ3SOskZwG/tISyTJkijk6aiXjI+J5OulFgCWyNLcdjbNLSP3sIZcjl9e
	 WCUaLnrfhx+6csEhXTEAE9oUxaaFMqPATjZxvHdrK3+Up8M1DqrbrqGdcMWbgRWC7L
	 jZBgXsmnDOLF9keB/v/81UZBfrPORNbZu40dLrUXJIqoM+TrKz1Yv2dDv8YQo8K7Qn
	 rxxcHvOuiSqQRzb5yZD+b+ioSmXKUoD9yAXeLqPx9g5E8Gvx+rLPvykomJfqRrOnPL
	 jIpbriVrb39hA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 05/13] ata,scsi: libata-core: Add ata_port_free()
Date: Wed, 26 Jun 2024 20:00:35 +0200
Message-ID: <20240626180031.4050226-20-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3228; i=cassel@kernel.org; h=from:subject; bh=eW+RWOtkOzS/Mw/Oj7hVhpP1gSVa4ky/5MrpmPV8NF0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwh0bFvwMuxgWmfkjfkrP4Q2ruqLONKgsWLWp0Mvp9 I7n7iv6O0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARowqG/9HJsxyU/EU51vFv FZHUU/jReGuWY2BzPf/pDvu+sLlPXzEy7GvdfP7Zuwf1va3/jrKLu1RPOOv13mZJ4buEF+5WzY5 djAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Add a function, ata_port_free(), that is used to free a ata_port.
It makes sense to keep the code related to freeing a ata_port in its own
function, which will also free all the struct members of struct ata_port.

libsas is currently not freeing all the struct ata_port struct members,
e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c          | 19 +++++++++++++------
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 +
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c916cbe3e099..591020ea8989 100644
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
@@ -5518,12 +5530,7 @@ static void ata_host_release(struct kref *kref)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		if (ap) {
-			kfree(ap->pmp_link);
-			kfree(ap->slave_link);
-			kfree(ap->ncq_sense_buf);
-			kfree(ap);
-		}
+		ata_port_free(ap);
 		host->ports[i] = NULL;
 	}
 	kfree(host);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 1c2400c96ebd..e8987dce585f 100644
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
index 6e01ddec10c9..951bdc554a10 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
 		ata_tport_delete(dev->sata_dev.ap);
-		kfree(dev->sata_dev.ap);
+		ata_port_free(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
 		dev->sata_dev.ap = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 581e166615fa..586f0116d1d7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1249,6 +1249,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
+extern void ata_port_free(struct ata_port *ap);
 extern int ata_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_tport_delete(struct ata_port *ap);
 int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
-- 
2.45.2


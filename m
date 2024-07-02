Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F8E148825;
	Tue,  2 Jul 2024 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936536; cv=none; b=ohoWFjgPGqrqLfsGbiPqKcUUfDNVJCObVU4IO25yDBIMudlnMJFsi3BrRAZhK2Vt6BmZo1KFEQa5S45UuAb3yGoWQ09IERUrHeQLPtkFUcqksV7qK+fqhHgQ5iZqMKHiVbSdLM8A+CcsIPhzjUDvG5N43dWJQukINKwRdj4K5Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936536; c=relaxed/simple;
	bh=tbDAh0q0cfWpxkoy8wWkLTXEdVgFDHunVlxbO8TdVRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH6wTeugOxXcZnEC3bh0awhBOS1HSdCfhgLNLQSJ+Qwohb6kgwKhwC0XvtQ95OSOdmvltCCgHslLye3SXlhWjCj3pNX8KA8IoUxTc140lFPas7qwcdN6fkl+89gDX1RdtCd93mJOMR/tdQ8IF2Pkhu20bKpwQLvQdiXA3aZudh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7QcYq6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7QcYq6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DF5C4AF0A;
	Tue,  2 Jul 2024 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936536;
	bh=tbDAh0q0cfWpxkoy8wWkLTXEdVgFDHunVlxbO8TdVRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7QcYq6xp0ybX1VqpqrZ33gfFT3q/9QmziJhjTJPRX1VjotL4hg7d8XZk9IDMkcF3
	 VfRQDAzoJKjB4zOiS2CfHh9UKzcGZyNZ0y86JT3AtsDedV4YFQ0SRSajK8MW2XJ44y
	 5GXbcVXqUtEUChGaNxg8AaucQrvI3aFhPQvW1lZj0yHrV7HW7zML0hJPbQD9OZGB28
	 MyBD3N8C89cb5nvVdPAK8VVQ0PvdRxmpV0958f6kfy/V8ytRMCpl22uG9DSnN7jP7x
	 ggzitLOszkG0GYDnmjJId5Zvg6fxLBUyeKM9nZq/vgOjkflYU2QbkHYhvbkCyiFD/P
	 x5gwMBTp9Y1YA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v3 6/9] ata: libata: Assign print_id at port allocation time
Date: Tue,  2 Jul 2024 18:08:02 +0200
Message-ID: <20240702160756.596955-17-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2459; i=cassel@kernel.org; h=from:subject; bh=tbDAh0q0cfWpxkoy8wWkLTXEdVgFDHunVlxbO8TdVRc=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ9qVff5f5S4a+zoXMXqvy/G2JX1s2h3f8yb0nn8p me7Tot3lLIwiHExyIopsvj+cNlf3O0+5bjiHRuYOaxMIEMYuDgFYCL9UxgZ+qWX3J7waMNnz9AH B39bT17xL5T7hs6eiIMdSocL+BpllzH84TG/89lDhedtgF7NhxOW06esmv+x58HbphNLXzz5uOK +BisA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

While the assignment of ap->print_id could have been moved to
ata_host_alloc(), let's simply move it to ata_port_alloc().

If you allocate a port, you want to give it a unique name that can be used
for printing.

By moving the ap->print_id assignment to ata_port_alloc(), means that we
can also remove the ap->print_id assignment from ata_sas_port_alloc().

This will allow a LLD to use the ata_port_*() print functions before
ata_host_register() has been called.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 6 +-----
 drivers/ata/libata-sata.c | 1 -
 drivers/ata/libata.h      | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index aff54651da65..f02c023ba89e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5462,7 +5462,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
-	ap->print_id = -1;
+	ap->print_id = atomic_inc_return(&ata_print_id);
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5899,10 +5899,6 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 		return -EINVAL;
 	}
 
-	/* give ports names and add SCSI hosts */
-	for (i = 0; i < host->n_ports; i++)
-		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
-
 	/* Create associated sysfs transport objects  */
 	for (i = 0; i < host->n_ports; i++) {
 		rc = ata_tport_add(host->dev,host->ports[i]);
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 1a36a5d1d7bc..b602247604dc 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1234,7 +1234,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 	ap->flags |= port_info->flags;
 	ap->ops = port_info->port_ops;
 	ap->cbl = ATA_CBL_SATA;
-	ap->print_id = atomic_inc_return(&ata_print_id);
 
 	return ap;
 }
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 38ce13b55474..5ea194ae8a8b 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -32,7 +32,6 @@ enum {
 
 #define ATA_PORT_TYPE_NAME	"ata_port"
 
-extern atomic_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
-- 
2.45.2


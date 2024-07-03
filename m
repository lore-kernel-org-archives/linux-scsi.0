Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B4187353;
	Wed,  3 Jul 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032305; cv=none; b=Xyfh6r5qs/SwR4O53AvP8z90Wxrm4Rc0ofDRI03ZuFU+nv/xi0vyhWx7Ef7HchyQu10tzxld4r5OxSwPj5WhGiApUZ2fsF6G6vMy60VoNBbeOPcNSO670Btazas6M7s2cF920CxD65X8PACKWZBpzjEARZErRUw2Kf2vZAN2VfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032305; c=relaxed/simple;
	bh=tbDAh0q0cfWpxkoy8wWkLTXEdVgFDHunVlxbO8TdVRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIxstcm5zUJj4PJb5Ac7PqX79/jQAIvAoFxHPObXwQKQ0W92E0vH4KW+4RvC94xXGu/GwnfalArPI7kQdSTuR6B8kjZTeZwzDcjinFnAiVDxvEvgRZMXt8KRxNzAfoafJPC1SUtkqYHQ7giGceAFNFHTcUcIo+tac4JBRBjA+T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnwCGZ4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnwCGZ4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71909C4AF0C;
	Wed,  3 Jul 2024 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032305;
	bh=tbDAh0q0cfWpxkoy8wWkLTXEdVgFDHunVlxbO8TdVRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnwCGZ4lWpo2B7gIjv9hVSDm4u5Y3OS+1iUUGg3NEhIHTwooTIZciyBaR8i/QPw1o
	 ybYL84akOdNEJ87Ril7YZ+4N11VPcLG4wDowOmLlpRLRMK1KmZ7D7+Ll0neU5ytQMB
	 D/5r2GOk+OXRWjFOwBjHAtoI0mYocV+bjKyLPfP4Q+wMBIKwiCTge5ftNhcqRry8Et
	 IbsSmKDroY+JlQKdZvxKsY+iswj9Fa54foS43RPvJ77MXHjjQlL+VvFHZggQpA88xq
	 hnSIK6O4SNJhQOAhVW94Qql70sV58dvYZGsmiAK0cWIcTTswZiCnnYGXn04YS2Wi/v
	 v9KvqazhCQcCw==
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
Subject: [PATCH v4 6/9] ata: libata: Assign print_id at port allocation time
Date: Wed,  3 Jul 2024 20:44:23 +0200
Message-ID: <20240703184418.723066-17-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2459; i=cassel@kernel.org; h=from:subject; bh=tbDAh0q0cfWpxkoy8wWkLTXEdVgFDHunVlxbO8TdVRc=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa5/BoVff5f5S4a+zoXMXqvy/G2JX1s2h3f8yb0nn8p me7Tot3lLIwiHExyIopsvj+cNlf3O0+5bjiHRuYOaxMIEMYuDgFYCLp2gy/WTxN9ijduuUpt2Dy wo99djk/tx+fsmFLSeJNp1sXrmh/Fmdk2BnWoaJgMTWK+fDKwy5yMW27O02jYtoO8HAGKmRV14Z xAQA=
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


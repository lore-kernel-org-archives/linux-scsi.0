Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408BC6E613;
	Wed, 26 Jun 2024 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424912; cv=none; b=SXsHja1/fxJJW/RTxN4qiF9f/1lcdsJTrZ1Gc1euyEr6Jo3gHV50UZiRrZgfimmTbTXfTvL4eHujFmn5xWGLnx42XFj5O0FRb97VC2dijdSinhhiA7aq56fhd3Hv2G7ELaQO9l1HHuNcb5SCRiewjm9O50Nko9FR/K5v9laLvaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424912; c=relaxed/simple;
	bh=+ANSy8S7jRPCn1qaYrZz2sKexsqF72tMosrAwiODGrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwziUAm3QpxTtfsEJ/utpatIiZzX3SzaP/iNTIPDHZpwxK42HaweyzgdSK2ny4KUkaTgi8SjXiusRgrOCoLBmVa5QjOrd+P2os96C3RxkExBs5Qnl6gmUbcphNZwE2JowBRLm0QVycSD7GPSQjRSsNj/XsIJ8VIiu6LFSbabL4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHu4c4Uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHu4c4Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9582C116B1;
	Wed, 26 Jun 2024 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424912;
	bh=+ANSy8S7jRPCn1qaYrZz2sKexsqF72tMosrAwiODGrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHu4c4Uzew2pI0CdAkVvdU/soYcoT0pRd4dTr0GCaQsRI5O+bA6DsV+QtZNwV/U3c
	 xsXyz3C4+SLfWa4s3dR59effKQGShPYA3PT9HgSW1oXJPaoux1mWdH6fR+n2q0HQNh
	 bvNKOa0o45Pszlwlx8VgzzAL0ntFnbo4aXmaBvrNjjvhPOjPVH7EXqC2CWsDQwV/xl
	 WrT6oz2gfCeNibnkKziY9a+bmml/ypp1VY9GCI9GQ1PWhzSKOMZ6nd9NBu3ITzKKtU
	 BiZhcvyy4wIib7F+q03GsGSq5el4O0/AaMQOwT+LrJ55V4efNwuVExpi1PEjxJSxcm
	 7LybXTOIhF7Yg==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 10/13] ata: libata: Assign print_id at port allocation time
Date: Wed, 26 Jun 2024 20:00:40 +0200
Message-ID: <20240626180031.4050226-25-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2089; i=cassel@kernel.org; h=from:subject; bh=+ANSy8S7jRPCn1qaYrZz2sKexsqF72tMosrAwiODGrs=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwp2N96Wp/UrK3vQo/8WjjotxIcfMJGZUTPtuF/vy0 ZRTS3jmdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAixc8ZGVZ/4zhe/c1W6E8f 35IpPWWNJ45pp8mf3OTpyiMo0/E7kYnhf+Fk3erUCaXKP0q3X0/5YrEp6sr6P6Glu7UFQp/EhHl O5gEA
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
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 6 +-----
 drivers/ata/libata-sata.c | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ceee4b6ba3dd..52c1f0915aef 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5463,7 +5463,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
-	ap->print_id = -1;
+	ap->print_id = atomic_inc_return(&ata_print_id);
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5910,10 +5910,6 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 	for (i = host->n_ports; host->ports[i]; i++)
 		WARN_ON(host->ports[i]);
 
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
-- 
2.45.2


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC7A148825;
	Tue,  2 Jul 2024 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936533; cv=none; b=Ff1e0xywq27GeQMgeDgBZbUYJ6c/0DwK1hRTr6Ak4oCMbbPQB/isVgIh/r4hnceYAJpL6fwE6q0wDQkRfU+3ZDlTkZlqUefXcK6L83OtT92TjMyTkv6ek+5e2u8dU9K1UgxB3D76x7GeY+rfn/ifEFOhNzNCQkXADGBNRJTJVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936533; c=relaxed/simple;
	bh=rGLhGA4U0nWfnf9gDicbn5UReSpLOrwyOSqv92NlJnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M63pJlLmtSj3yhumWTN4Sz2y2+hxZwEjt5xRsucjwF/jXSPaD3Ju2/asBrupetUBXuHv+dT+1aP6hU5dbqXctxZUpTfzlHactMvMGT3bE2LbEexU8tOBe+l9CTu2vLfq3TMfhUcj9r6nAQJyBg36wTErW4sLerTMaRuPGlv4rhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLqvpNmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLqvpNmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94354C116B1;
	Tue,  2 Jul 2024 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936533;
	bh=rGLhGA4U0nWfnf9gDicbn5UReSpLOrwyOSqv92NlJnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLqvpNmEwgGzV/QpyKiwD0J/ZXtzd+E9sknDZ6hzl7BpcRGmLVLAGRx1Eut4rd3e6
	 gLvaet5Bg7trCOi/uxxDnma2xJsP8vu+KeHgYdAHpHPUvTgbaqpP8owXPUsCAWeBeZ
	 6k4m9wcs0cGPqQVKxf9tXleX5+fTS5VRKz7Tg64ObAMI/XIVG+Tf2/JZUvkoOxHoFN
	 8a9sK4spBqz6bNkkrB1Us12ecEI2U5DHTQffFZ9kHxSccrY9LNAARCovez+qovpd/V
	 q2O9PcsH+uUL6PXrhFwOccwzuP+VnM52tkqSOpZYPRNfPtyWpWWdeWOka2vmbpqsFI
	 Y3ZCFPL2954DA==
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
Subject: [PATCH v3 5/9] ata: libata-core: Remove local_port_no struct member
Date: Tue,  2 Jul 2024 18:08:01 +0200
Message-ID: <20240702160756.596955-16-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2682; i=cassel@kernel.org; h=from:subject; bh=rGLhGA4U0nWfnf9gDicbn5UReSpLOrwyOSqv92NlJnE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ94K4YIMp75ps23qeykqlxF8cR1zyJD+IxFWJXbJ qTWnM7oKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwERWnmL4K3l45STGtBkOot4y Z0VfVccyc7w13M35/c2UdpvGTbFbtBgZTnO80fO3K9G1i1/50Tv9QbOS4QrvVxWtXNf1qr+vPLC PEwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ap->local_port_no is simply ap->port_no + 1.
Since ap->local_port_no can be derived from ap->port_no, there is no need
for the ap->local_port_no struct member, so remove ap->local_port_no.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c      | 5 +----
 drivers/ata/libata-transport.c | 3 ++-
 include/linux/libata.h         | 1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f0cce3fec902..aff54651da65 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5463,7 +5463,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
-	ap->local_port_no = -1;
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5901,10 +5900,8 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 	}
 
 	/* give ports names and add SCSI hosts */
-	for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
-		host->ports[i]->local_port_no = i + 1;
-	}
 
 	/* Create associated sysfs transport objects  */
 	for (i = 0; i < host->n_ports; i++) {
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index d24f201c0ab2..9e24c33388f9 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -217,7 +217,8 @@ static DEVICE_ATTR(name, S_IRUGO, show_ata_port_##name, NULL)
 
 ata_port_simple_attr(nr_pmp_links, nr_pmp_links, "%d\n", int);
 ata_port_simple_attr(stats.idle_irq, idle_irq, "%ld\n", unsigned long);
-ata_port_simple_attr(local_port_no, port_no, "%u\n", unsigned int);
+/* We want the port_no sysfs attibute to start at 1 (ap->port_no starts at 0) */
+ata_port_simple_attr(port_no + 1, port_no, "%u\n", unsigned int);
 
 static DECLARE_TRANSPORT_CLASS(ata_port_class,
 			       "ata_port", NULL, NULL, NULL);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b7c5d3f33368..84a7bfbac9fa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -814,7 +814,6 @@ struct ata_port {
 	/* Flags that change dynamically, protected by ap->lock */
 	unsigned int		pflags; /* ATA_PFLAG_xxx */
 	unsigned int		print_id; /* user visible unique port ID */
-	unsigned int            local_port_no; /* host local port num */
 	unsigned int		port_no; /* 0 based port no. inside the host */
 
 #ifdef CONFIG_ATA_SFF
-- 
2.45.2


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90DC158A22;
	Wed, 26 Jun 2024 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424906; cv=none; b=b6Et19L3YEcPOZRicKMAkIBMTcvghp6IADgTjfztX2V+DrDrua0q9LOi45ymCcETYUIqiGtNWsSojQxoETwxGuYMRn7d9Mfqdk1k+bDsLF/N0LL8iKKJEysojEQAgW/9tUHzHcQ7YtkWwZJL45ZrQwzYfRA21yir1nOwopx42qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424906; c=relaxed/simple;
	bh=ppUpG4EnJX1Q6mJjRxr3G8icwrV8ouUl0tzKUC36+yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqQOfRysS6YKmxV6e4L+jKbzKraTPoXIp36R8l8do5G7bV0O/mW/6rW740Ry7NFgYIXl9po6hojHse03W1sakGl1hDbny78a0GpXiQAnAea3dd0IeXX7IpkwdOEEzzu0ZfLiDOom2WnjdBa4DqjpHE2eMs7KLsvEAVMOem+NDg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGjGTn80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGjGTn80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD1BC4AF07;
	Wed, 26 Jun 2024 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424906;
	bh=ppUpG4EnJX1Q6mJjRxr3G8icwrV8ouUl0tzKUC36+yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGjGTn80bPJiXsAe/PE7eU/L0eaFH4AlizVGS1VacQmNmCD+UNX2pXbzk/Ud4pl8w
	 nroUyXnutoAadXdcQVaQuoeShU66Bl3YsdZNKJiAFE9vt1orVaKfqtqBm4efJFdJAc
	 OtmYlS4cKMbYo00fK2CKO9tJolhs59hwx5aAQ1UKEUiJE2LMP6O7OuVBdompgxr6Ob
	 2YKOsTgnxA5bS7q4+mjgEVm58EoiiPoQ6Z1pzK/bJok9ATZnGxCmZ5g1nTALH41oCB
	 2ZvQ1jPvgnqRRGTE88i9SDptX7UmOQNNh5FRE+ObCdR4do5GUZ1tElG/Hphxm+lbgA
	 Wepmw0cfFhyDA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 09/13] ata: libata-core: Remove local_port_no struct member
Date: Wed, 26 Jun 2024 20:00:39 +0200
Message-ID: <20240626180031.4050226-24-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2611; i=cassel@kernel.org; h=from:subject; bh=ppUpG4EnJX1Q6mJjRxr3G8icwrV8ouUl0tzKUC36+yU=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwp15ikXf+VpsLee0EY6yv/1wo86qCwf8Nz27JegS6 K42MYW/o5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABPZ4cfIMMnNcYIa/6oUW/ae 76LpS7l7bu2s8s4+9WzvK+U5AqLFfxkZJn+Z1XQl66/ulCkV20+uU5qr93FxteEMUY/9/ZYPfyy +wwEA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ap->local_port_no is simply ap->port_no + 1.
Since ap->local_port_no can be derived from ap->port_no, there is no need
for the ap->local_port_no struct member, so remove ap->local_port_no.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c      | 5 +----
 drivers/ata/libata-transport.c | 3 ++-
 include/linux/libata.h         | 1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a213a9c0d0a5..ceee4b6ba3dd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5464,7 +5464,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
-	ap->local_port_no = -1;
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5912,10 +5911,8 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 		WARN_ON(host->ports[i]);
 
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


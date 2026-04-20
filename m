Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E063393DF9;
	Mon, 20 Apr 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776689127; cv=none; b=cz5/JIEE4nH5KjcnOnOBkEE4OhGny8HJjiuKR3NJjOF3oarpnGqp/hUqVnzrWKLjFh2p6EHREAzqAoqCpe4/pLxFdQEw7JkSeXLoZRVraZ1nxwGx0Cv/grJBconxF8ZUCU04Bl1SEJm9bCZJ1EROpKzLR1a/8hX9uWlI32zP/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776689127; c=relaxed/simple;
	bh=IsQYB9LYP2StV7D93d0U0QPltWvtmbEQheG5KxO1iFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6BqElmxZQVEfpgqYT22xZBRyNX6PKIjXFsoEa4aX7Hn28Nt2IObPru7sCt4FIV+cKSkDDbQ5ho7zuka6H6PGa5XOWZsimvguWLtU1iSVE4ZUgppLkxAvpc+yj0AGVqoGByluqQReAbG1j9LdCZxbe38DlAZkXJ2P0NA/9fVJXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=FZUbyZKg; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="FZUbyZKg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1776687809;
	bh=IsQYB9LYP2StV7D93d0U0QPltWvtmbEQheG5KxO1iFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZUbyZKgJLFAzEaox7bK5/6kz2r6+nyNEbV0smo3ZzaReae7EP8JE46KyE8KJYoCw
	 8BSTnDj8hMal1SJ/Y/bbkhueQ/Z0MquGVF12+Qb6hOUsVaCNh9fC/NEuIDnUlIH6wM
	 4C7usrl57otnvKj8X4YWrUS+I6qEsIpGGIP9kd4c=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 29798BEFDF;
	Mon, 20 Apr 2026 12:23:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 92E385FC55;
	Mon, 20 Apr 2026 13:23:28 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v2 1/5] ata: libata-scsi: add atapi_max_lun module parameter
Date: Mon, 20 Apr 2026 13:23:17 +0100
Message-ID: <20260420122321.4161027-2-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260420122321.4161027-1-philpem@philpem.me.uk>
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Until now libata has hard-coded shost->max_lun = 1 for every ATA host,
so the SCSI layer never scans past LUN 0.  This blocks support for
the small handful of multi-LUN ATAPI devices (Panasonic LF-1195C and
COMPAQ PD-1 PD/CD combos export CD on LUN 0 and PD on LUN 1; old
Nakamichi MJ-x.y CD changers expose one LUN per disc slot, up to 7).

Introduce a libata module parameter, atapi_max_lun, that controls the
upper bound of the per-host SCSI LUN scan.  Default is 1, preserving
current behaviour exactly: out-of-the-box only LUN 0 is scanned.
Range is clamped to 1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).

Subsequent patches gate actual LUN>0 probing on BLIST_FORCELUN, so a
device must both be on the SCSI device list (or carry the appropriate
quirk) and run on a host whose atapi_max_lun has been raised before
any extra LUNs are scanned.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-core.c | 5 +++++
 drivers/ata/libata-scsi.c | 2 +-
 drivers/ata/libata.h      | 1 +
 include/linux/libata.h    | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 374993031895..8c279b6eb1fb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -122,6 +122,11 @@ int atapi_passthru16 = 1;
 module_param(atapi_passthru16, int, 0444);
 MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
 
+int atapi_max_lun = 1;
+module_param(atapi_max_lun, int, 0444);
+MODULE_PARM_DESC(atapi_max_lun,
+	"Maximum LUN to scan on ATAPI devices flagged BLIST_FORCELUN (1 [default] .. 7)");
+
 int libata_fua = 0;
 module_param_named(fua, libata_fua, int, 0444);
 MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3b65df914ebb..d1665305b552 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4620,7 +4620,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
 		shost->transportt = ata_scsi_transport_template;
 		shost->unique_id = ap->print_id;
 		shost->max_id = 16;
-		shost->max_lun = 1;
+		shost->max_lun = clamp(atapi_max_lun, 1, ATAPI_MAX_LUN);
 		shost->max_channel = 1;
 		shost->max_cmd_len = 32;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index b5423b6e97de..96d804d02b99 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -33,6 +33,7 @@ enum {
 #define ATA_PORT_TYPE_NAME	"ata_port"
 
 extern int atapi_passthru16;
+extern int atapi_max_lun;
 extern int libata_fua;
 extern int libata_noacpi;
 extern int libata_allow_tpm;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 00346ce3af5e..27b11577826e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -131,6 +131,7 @@ enum {
 	ATA_SHORT_PAUSE		= 16,
 
 	ATAPI_MAX_DRAIN		= 16 << 10,
+	ATAPI_MAX_LUN		= 8,	/* SCSI-2 cap (LUN values 0..7) */
 
 	ATA_ALL_DEVICES		= (1 << ATA_MAX_DEVICES) - 1,
 
-- 
2.43.0


Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B14EFFD9;
	Fri,  9 Oct 2026 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563232; cv=none; b=N62g9Toms00UKVK7zO+cnsjDOcnRhzpEza4RH1DDu4txLYGfXhFirLY2y2kQcLFeXLas0gVP4tk2Pd4NCwuJTzQkM3RyeCjGslInL7A1T0JdzZhQ3wUfHJmfJYrjax6PUSoqulefqYLZm3bUI4n8NKJ9q8N0KtguYzmxFEzuD+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563232; c=relaxed/simple;
	bh=eYWM3DLUFowiToaoR3AAwQoTg6A3M8dkeEHVfTWe7Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADpiXY8QJO/perVRTDoMDYw0OjzsaY6KRawoNsV5cbTFH4Ql03DsvIEi1f5hfytjtVIgQy4qUgJuao7mtmIgXFZ8+jPsigkhkzpb273NV4j6YlIH21pcYDq5f2WwVQUVX8FvGXPJmkTygNau3WkGe8SJtWy3j5sujHIfceW+C3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=ufqpG9JX; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="ufqpG9JX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=eYWM3DLUFowiToaoR3AAwQoTg6A3M8dkeEHVfTWe7Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufqpG9JX9uaNgR+5ksy7EL+9X8rd3DOgfePPY84z25q+FM9Xziv/bE9pQym+f3u13
	 LyaFpKWO6B09EdVTzqnL1do4wC91i0eddK725oJqKgtaqTexmCIWrKBPc23hWb+JA8
	 iokjgt8iqNymUHxC3wgImjTPG4jv2M82C67ydlZs=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 8D9C8BE778;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 563F55FC4F;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v10 10/15] ata: libata-scsi: add atapi_max_lun module parameter
Date: Fri,  9 Oct 2026 16:55:17 +0100
Message-ID: <20261009155522.593045-11-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libata sets shost->max_lun to 1, so SCSI scans stop at LUN 0. Panasonic
LF-1195C and COMPAQ PD-1 drives expose their PD media on LUN 1, and
Nakamichi MJ-x.y CD changers expose a LUN for each disc slot.

Add the atapi_max_lun module parameter to set the host's scan limit.
Keep the default of 1 and clamp the value to 1..8, covering SCSI-2 LUNs
0..7. Later patches enable automatic scanning of additional LUNs for
ATAPI devices marked BLIST_FORCELUN.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-core.c | 5 +++++
 drivers/ata/libata-scsi.c | 2 +-
 drivers/ata/libata.h      | 1 +
 include/linux/libata.h    | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5518525357ce..f2f5ad727d20 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -123,6 +123,11 @@ int atapi_passthru16 = 1;
 module_param(atapi_passthru16, int, 0444);
 MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
 
+int atapi_max_lun = 1;
+module_param(atapi_max_lun, int, 0444);
+MODULE_PARM_DESC(atapi_max_lun,
+		 "Number of LUNs to scan on ATAPI devices flagged BLIST_FORCELUN (1 [default] = LUN 0 only, 8 = all SCSI-2 LUNs 0..7)");
+
 int libata_fua = 0;
 module_param_named(fua, libata_fua, int, 0444);
 MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8f9aa97a519d..3131d84204ed 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -5230,7 +5230,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
 		shost->transportt = &ata_scsi_transportt;
 		shost->unique_id = ap->print_id;
 		shost->max_id = 16;
-		shost->max_lun = 1;
+		shost->max_lun = clamp(atapi_max_lun, 1, ATAPI_MAX_LUN);
 		shost->max_channel = 1;
 		shost->max_cmd_len = 32;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 48274691cd0e..aedc6b61196b 100644
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
index 48bde275968d..03511280800f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -180,6 +180,7 @@ enum {
 	ATA_SHORT_PAUSE		= 16,
 
 	ATAPI_MAX_DRAIN		= 16 << 10,
+	ATAPI_MAX_LUN		= 8,	/* SCSI-2 cap (LUN values 0..7) */
 
 	ATA_ALL_DEVICES		= (1 << ATA_MAX_DEVICES) - 1,
 
-- 
2.43.0


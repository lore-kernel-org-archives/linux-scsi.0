Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52624F7979;
	Tue,  6 Oct 2026 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330132; cv=none; b=VBMq1JzrtyOUcWkGxgZL6r34VkA7JMSm/pGnD02qNiqLCxLjFHltpqz7iCz3XTZF4AjZf2Z012xQ3vII2xLkw66I1FyB6L5t0A/2DdpFu7YlA8V2lVcAq0d6YswMcoMne7H+s3e30NahmsXwZy8CA4mNPWDX2H+CS7eMtmBLQE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330132; c=relaxed/simple;
	bh=Jf7EnuQNU0pR4JT8vVO+lTeyOD9C8IzaWAoWRW1Rdg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRO9jp2m2c0wHgFz5KQk0BPYGwyRrGj5IeaAsD7JwHYtOerqQTwaWyH8Iq8LMWKFwD/kOYGQMFZDmivoZLDfFISBMRwEgAfUtXv3Vsscm0zUon3gC82RAkUd5JlWrjITDtjcSIjtmxH2ABrv8aV462DO6bo4DoAz6/JGWIYmUnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=nqKg0uXp; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="nqKg0uXp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330125;
	bh=Jf7EnuQNU0pR4JT8vVO+lTeyOD9C8IzaWAoWRW1Rdg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqKg0uXpFlhymfvtpldPeGZWqD/BZ7u/a0r1AmRrkHBeaooHue9ti56O7R3FwHCY3
	 cTju8jykAss/zwDVumnVlKn7GqCY3o7XhiGFxJykm81Kzo0tGiEoe8f6dxIZfS8zCc
	 WaXyqGDhV/PehyjLJYvO4kWK8xMb/4Qed2UhLED4=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id D6A54BE5FF;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 826FF5FC59;
	Wed,  7 Oct 2026 00:42:05 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v9 08/11] ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
Date: Wed,  7 Oct 2026 00:41:58 +0100
Message-ID: <20261006234202.1139018-9-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006234202.1139018-1-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow nonzero LUNs in __ata_scsi_find_dev(). Keep this lookup independent
of device class so removal can clear the per-LUN pointer after error
handling disables the device. Restrict nonzero LUN commands to ATAPI
in ata_scsi_find_dev().

Encode nonzero LUNs in CDB byte 1, bits 7:5, as required by older SCSI-2
ATAPI devices. Reject values above 7 with DID_ERROR. Check this encoding
limit directly, since SAS hosts can have much larger shost->max_lun
values. Preserve byte 1 for LUN 0, where modern MMC commands use the upper
bits for command-specific fields.

Pass the failed command's LUN to atapi_eh_request_sense() so error handling
reads sense from the correct unit. Internal reset and ZPODD commands
continue to use LUN 0.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-eh.c    | 10 +++++++---
 drivers/ata/libata-scsi.c  | 25 ++++++++++++++++++++++---
 drivers/ata/libata-zpodd.c |  2 +-
 drivers/ata/libata.h       |  4 ++--
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c93c24b22d9c..7177e4bddc2a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1535,6 +1535,7 @@ static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
 /**
  *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
  *	@dev: device to perform REQUEST_SENSE to
+ *	@lun: logical unit to request sense from
  *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
  *	@dfl_sense_key: default sense key to use
  *
@@ -1547,14 +1548,16 @@ static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure
  */
-unsigned int atapi_eh_request_sense(struct ata_device *dev,
-					   u8 *sense_buf, u8 dfl_sense_key)
+unsigned int atapi_eh_request_sense(struct ata_device *dev, u8 lun,
+				    u8 *sense_buf, u8 dfl_sense_key)
 {
 	u8 cdb[ATAPI_CDB_LEN] =
 		{ REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0 };
 	struct ata_port *ap = dev->link->ap;
 	struct ata_taskfile tf;
 
+	cdb[1] = lun << 5;
+
 	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
 
 	/* initialize sense_buf with the error register,
@@ -1700,6 +1703,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc)
 	case ATA_DEV_ATAPI:
 		if (!ata_port_is_frozen(qc->ap)) {
 			tmp = atapi_eh_request_sense(qc->dev,
+						qc->scsicmd->device->lun,
 						qc->scsicmd->sense_buffer,
 						qc->result_tf.error >> 4);
 			if (!tmp)
@@ -3531,7 +3535,7 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 		if (!err_mask || sense_key != UNIT_ATTENTION)
 			return 0;
 
-		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
+		err_mask = atapi_eh_request_sense(dev, 0, sense_buffer, sense_key);
 		if (err_mask) {
 			ata_dev_warn(dev, "failed to clear "
 				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 68d6ca1f791d..471daf63382a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3112,6 +3112,21 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
+	/*
+	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
+	 * Byte 1 is left untouched for LUN 0, since commands which use
+	 * the full byte (e.g. MMC SECURITY PROTOCOL IN/OUT, where it is
+	 * the 8-bit security protocol) must pass through unmodified.
+	 */
+	if (unlikely(scmd->device->lun)) {
+		if (scmd->device->lun >= ATAPI_MAX_LUN) {
+			scmd->result = DID_ERROR << 16;
+			return 1;
+		}
+		qc->cdb[1] = (qc->cdb[1] & 0x1f) |
+			     ((u8)scmd->device->lun << 5);
+	}
+
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
@@ -3222,13 +3237,13 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 {
 	int devno;
 
-	/* skip commands not addressed to targets we simulate */
+	/* Teardown must still find devices whose class was changed by EH. */
 	if (!sata_pmp_attached(ap)) {
-		if (unlikely(scsidev->channel || scsidev->lun))
+		if (unlikely(scsidev->channel))
 			return NULL;
 		devno = scsidev->id;
 	} else {
-		if (unlikely(scsidev->id || scsidev->lun))
+		if (unlikely(scsidev->id))
 			return NULL;
 		devno = scsidev->channel;
 	}
@@ -3263,6 +3278,10 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
 
+	/* Only ATAPI devices can route commands to nonzero LUNs. */
+	if (scsidev->lun && dev->class != ATA_DEV_ATAPI)
+		return NULL;
+
 	return dev;
 }
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index bbdcaaa35798..ef39142ec5f7 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -113,7 +113,7 @@ static bool zpready(struct ata_device *dev)
 		return false;
 
 	sense_buf = dev->sector_buf;
-	ret = atapi_eh_request_sense(dev, sense_buf, sense_key);
+	ret = atapi_eh_request_sense(dev, 0, sense_buf, sense_key);
 	if (ret)
 		return false;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index aedc6b61196b..ca60d0e1d31c 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -216,8 +216,8 @@ extern int ata_ering_map(struct ata_ering *ering,
 			 void *arg);
 enum scsi_disposition ata_eh_decide_disposition(struct ata_queued_cmd *qc);
 extern unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key);
-extern unsigned int atapi_eh_request_sense(struct ata_device *dev,
-					   u8 *sense_buf, u8 dfl_sense_key);
+unsigned int atapi_eh_request_sense(struct ata_device *dev, u8 lun,
+				    u8 *sense_buf, u8 dfl_sense_key);
 
 /* libata-pmp.c */
 #ifdef CONFIG_SATA_PMP
-- 
2.43.0


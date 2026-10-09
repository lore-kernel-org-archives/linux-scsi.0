Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7C4F3906;
	Fri,  9 Oct 2026 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563236; cv=none; b=pn3vRDwfnpNZc9NrUFi7Vh0k+Utn7SpfEpXolm6dlBJvf03Xv8vBv+FIGAtfAA/qf5X90l8zZTq3YIYRi3VD5Z6/RQReVCY7iK9QeLJ5vTDxk816E5AI9kEPhg1MVkFlIMGOQLpS2VhhdUFmsXuvaajivN146Uwr+pIpU/7YW6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563236; c=relaxed/simple;
	bh=fole+92UJtSz7Vx0fDJMb6R9XFlYBieqgLkcJ8qd7Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJ2k4vOSUZd4RHj9Pp9zhYKAr7YE6yv3pXxZRXgBlvPDN8eNyNHapi6PJoSiEUshVXbx7CymrvcSM7nWxzLP0Q9MsWu5u6mKoz3PlyS8Tu1CvLNGGy9CmjrldTntj36vq7hTfvphPBf854EwSmEQSq4xogFrd1x5JkjKlR6m7nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=ftHvDRtL; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="ftHvDRtL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=fole+92UJtSz7Vx0fDJMb6R9XFlYBieqgLkcJ8qd7Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftHvDRtLOruBmJ6Ex5wiCxMs+7MbksmcboLdvOC9y/XwU8Mif93nB2pc5OfOwWrYe
	 iWYZNdf7xq4x0OfHmJ1Iy5kp7oDGhAar1UvsMWnlwzREaySHJ43T8AP/ZcGDujCWZD
	 mNjehp60a2eMGN6+T4IazE/ogtYHbCNp8Ziv3aUw=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id AFE78BE77A;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 7F0115FADC;
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
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 12/15] ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
Date: Fri,  9 Oct 2026 16:55:19 +0100
Message-ID: <20261009155522.593045-13-philpem@philpem.me.uk>
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
 drivers/ata/libata-eh.c   | 10 +++++++---
 drivers/ata/libata-scsi.c | 25 ++++++++++++++++++++++---
 drivers/ata/libata.h      |  4 ++--
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 25d335c33d0a..2345fe5eb606 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1544,6 +1544,7 @@ static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
 /**
  *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
  *	@dev: device to perform REQUEST_SENSE to
+ *	@lun: logical unit to request sense from
  *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
  *	@dfl_sense_key: default sense key to use
  *
@@ -1556,14 +1557,16 @@ static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
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
@@ -1709,6 +1712,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc)
 	case ATA_DEV_ATAPI:
 		if (!ata_port_is_frozen(qc->ap)) {
 			tmp = atapi_eh_request_sense(qc->dev,
+						qc->scsicmd->device->lun,
 						qc->scsicmd->sense_buffer,
 						qc->result_tf.error >> 4);
 			if (!tmp)
@@ -3540,7 +3544,7 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 		if (!err_mask || sense_key != UNIT_ATTENTION)
 			return 0;
 
-		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
+		err_mask = atapi_eh_request_sense(dev, 0, sense_buffer, sense_key);
 		if (err_mask) {
 			ata_dev_warn(dev, "failed to clear "
 				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index efd0916f8180..faf408acf65e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3113,6 +3113,21 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
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
@@ -3223,13 +3238,13 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
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
@@ -3264,6 +3279,10 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
 
+	/* Only ATAPI devices can route commands to nonzero LUNs. */
+	if (scsidev->lun && dev->class != ATA_DEV_ATAPI)
+		return NULL;
+
 	return dev;
 }
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index e86052d4b067..457b1bd766c2 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -219,8 +219,8 @@ extern int ata_ering_map(struct ata_ering *ering,
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


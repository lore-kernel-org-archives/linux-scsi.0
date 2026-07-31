Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A4330307;
	Fri, 31 Jul 2026 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534760; cv=none; b=VR+UH+0S0ABHhi9cz5kxBq5s030POomHRjY5JWDTS4EVxd29+T4KPs3RlG8pxGHEiJFFjS2iA+1yyl/S381C92UEqSF70Se8L4UYQc0qgSIu5Mcoulvq5klHvonX3yWf0Vj6QKc/bekqghJ9L1vDJFO00Qh+/oGWaaAZDkwFdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534760; c=relaxed/simple;
	bh=MnZ1hre2Kf21Dyn7ZNb8A7WsTa84hKx8Xk3evhQYboQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox70q+Vim8nKFnBrtQkVS9U4P3BUh4HVZYIGJXZ4c/3qMEE/x4NQV1lCO/MSzTnOydUCWhV1OmQ0/OfIOaM9jHefzM017ODIZDih6FdmU0b9lRIvF6c8O+qem4db72dFS5HztNe9s9iNrA/PAuoAJwEiM72GeTLDuDWfh1QRzVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=XoeDqw39; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="XoeDqw39"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1785533714;
	bh=MnZ1hre2Kf21Dyn7ZNb8A7WsTa84hKx8Xk3evhQYboQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoeDqw399ztBF14+LuigMKXg9ZYz0IdslGqEU4DCHZeAmDGv0z9uKu6WTwjkVeJOz
	 lY8S1pAI3QPqa7zv5ygPX8Mh8I6WfYs4gpHMAwttnUqkIEjl2VlbIrniTk5Ianjm5F
	 nNF9pHs/AVLcAUeiVNFoZds4LUkAAHvmqncRzB7M=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id BA77CBE539;
	Fri, 31 Jul 2026 21:35:14 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 840585FC3D;
	Fri, 31 Jul 2026 22:35:14 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v8 3/6] ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
Date: Fri, 31 Jul 2026 22:35:00 +0100
Message-ID: <20260731213503.2379771-4-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731213503.2379771-1-philpem@philpem.me.uk>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two changes are required to route commands to ATAPI LUNs other than 0:

1. __ata_scsi_find_dev():  The existing code rejects any scsi_device
   with a non-zero LUN, returning NULL and dropping the command on
   the floor.  Hoist a non-zero LUN early-exit ahead of the original
   channel/id checks: when scsidev->lun is non-zero, allow it through
   only if the underlying ata_device is ATAPI class.  The original
   LUN-0 path is left structurally unchanged.

2. atapi_xlat():  Older ATAPI devices (SCSI-2 era) expect the LUN in
   CDB byte 1 bits 7:5 rather than relying on transport-level LUN
   addressing.  Always clear those bits first, then encode
   scmd->device->lun into them for non-zero LUNs.  This is required by
   both the Panasonic PD/CD combos and Nakamichi CD changers.

   Guard with WARN_ON_ONCE() and fail the command (setting scmd->result
   to DID_ERROR) if the LUN is out of range, since the 3-bit CDB field
   cannot represent it.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 808368b952b5..0b1e4842860c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3012,6 +3012,20 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
+	/*
+	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
+	 * Always clear those bits; only set them for non-zero LUNs.
+	 */
+	qc->cdb[1] = qc->cdb[1] & 0x1f;
+	if (unlikely(scmd->device->lun)) {
+		if (WARN_ON_ONCE(scmd->device->host->max_lun > ATAPI_MAX_LUN ||
+				 scmd->device->lun >= scmd->device->host->max_lun)) {
+			scmd->result = DID_ERROR << 16;
+			return 1;
+		}
+		qc->cdb[1] |= (u8)scmd->device->lun << 5;
+	}
+
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
@@ -3122,6 +3136,29 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 {
 	int devno;
 
+	/*
+	 * Non-zero LUN is only legal for ATAPI devices, since they can
+	 * legitimately expose more than one LUN (PD/CD combos, CD changers).
+	 * Handle that case up front so the LUN-0 path below stays unchanged.
+	 */
+	if (unlikely(scsidev->lun)) {
+		struct ata_device *dev;
+
+		if (!sata_pmp_attached(ap)) {
+			if (unlikely(scsidev->channel))
+				return NULL;
+			devno = scsidev->id;
+		} else {
+			if (unlikely(scsidev->id))
+				return NULL;
+			devno = scsidev->channel;
+		}
+		dev = ata_find_dev(ap, devno);
+		if (!dev || dev->class != ATA_DEV_ATAPI)
+			return NULL;
+		return dev;
+	}
+
 	/* skip commands not addressed to targets we simulate */
 	if (!sata_pmp_attached(ap)) {
 		if (unlikely(scsidev->channel || scsidev->lun))
-- 
2.43.0


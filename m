Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFB92D7DDD;
	Mon, 20 Apr 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776689126; cv=none; b=kKwTi/riA3syWjfhX7Ac/qyuggdAcsXdBl3CO+6WlkqOCnC7xs3Wlrsxt2Jcb3TpRZBdGz0bgwC/OTw5t7S8AJETfZIQhEq/9ZpFtoMN74bI+YIBN685yVXzr9sCKKh/Ykx7YpNBDbfJdTe+oRIa3emVQn6arv9B7o9WMX3BuxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776689126; c=relaxed/simple;
	bh=mOszOGgiRniI+v2UWq22eRi5tmlU02g5ePSKlT10boU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYtLgKX9dgwNkCg7OkfWOqJbVQoKmPP1KAcmtAKGa6XUx1XiJCe7AW1GxijqWZXBTLZVOM7R8oEglwrQLIwrTk3GXzhp1IZmpb8siQ6kww2427WE0VgtOD6A7wOjK9PAcHQphSH//R2shSycD2PSvj6S+7RkFg/pc1GZE6AcmX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Dz/93QVn; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Dz/93QVn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1776687809;
	bh=mOszOGgiRniI+v2UWq22eRi5tmlU02g5ePSKlT10boU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz/93QVnxhsZ5AVlWbrYuCF6+9GAlDgaeyk0NVRHgYcEce8yM4EBkV1619R9ybLbN
	 u7zMIy3UtqNnCaR5mBZ442Sy6dgdh/mXZ81ZH25A8F69BHtXcW9NiF8ln1MUx0I6K0
	 2PsLvnG+CgVefxXvCwhtE1hWsPc10RS0BP/QxsJE=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 36724BEFE2;
	Mon, 20 Apr 2026 12:23:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id AF6965FC59;
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
Subject: [PATCH v2 3/5] ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
Date: Mon, 20 Apr 2026 13:23:19 +0100
Message-ID: <20260420122321.4161027-4-philpem@philpem.me.uk>
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

Two changes are required to route commands to ATAPI LUNs other than 0:

1. __ata_scsi_find_dev():  The existing code rejects any scsi_device
   with a non-zero LUN, returning NULL and dropping the command on
   the floor.  Relax both the PMP and non-PMP branches to allow
   non-zero LUNs through when the underlying ata_device is ATAPI
   class, since ATAPI devices can legitimately expose multiple LUNs.

2. atapi_xlat():  Older ATAPI devices (SCSI-2 era) expect the LUN in
   CDB byte 1 bits 7:5 rather than relying on transport-level LUN
   addressing.  Encode scmd->device->lun into those bits, preserving
   the existing command-specific bits in 4:0.  This is required by
   both the Panasonic PD/CD combos and Nakamichi CD changers.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 317883bac25f..4e88ae7d94c3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2951,6 +2951,11 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
+	/* SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 */
+	if (scmd->device->lun < 8)
+		qc->cdb[1] = (qc->cdb[1] & 0x1f) |
+			      ((u8)scmd->device->lun << 5);
+
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
@@ -3059,19 +3064,27 @@ static struct ata_device *ata_find_dev(struct ata_port *ap, unsigned int devno)
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					      const struct scsi_device *scsidev)
 {
+	struct ata_device *dev;
 	int devno;
 
 	/* skip commands not addressed to targets we simulate */
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
 
+	if (unlikely(scsidev->lun)) {
+		dev = ata_find_dev(ap, devno);
+		if (!dev || dev->class != ATA_DEV_ATAPI)
+			return NULL;
+		return dev;
+	}
+
 	return ata_find_dev(ap, devno);
 }
 
-- 
2.43.0


Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CAE36212D;
	Sun, 26 Apr 2026 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777230581; cv=none; b=G/UIt1Exo626Tq3WjVkmPiNns6rp8JLkTCpQCnnxaOF44OTwqkKJLjzTz5rHbKWHBa1z4KuBABpdzYfBl5DI0HH64kLRgAi/DyhONyK7f3L+NtSq2iwTyOgZCvwmJUJ9GLAzXbo2/PD2/cnmv3FczPoz9S5bfkdsL+MPOqpcwMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777230581; c=relaxed/simple;
	bh=5INEidaxPS3KpBzcwlk1svLm8n+Qi1qL50o+7Kyduc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyuPc3SwKl1dyuwNe25LS2oQ3Lar9pCZutQzgMbbklQ7gmkekyohATHnjWy8OZVblySmDtI5np4DTa7qoOzyjj8dGtTrJSfM/myS5cRkT0L4RuIwWB1J8tL4d0nIipjxo+pU40U8vf7lhA6CEdHcqRazBdQzJom6ZUlyiiOdiuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=lDUmb9c1; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="lDUmb9c1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1777230569;
	bh=5INEidaxPS3KpBzcwlk1svLm8n+Qi1qL50o+7Kyduc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDUmb9c1VyrP+q6BiWQBnhA4Z0VMiPbUX6jQvKipIBHM7yFXToWxx2d6jm72RNv1g
	 Mr+EHq8Mra4RXrdAt32vqshE8VLyrWRo65qSu4gd803c59f8V3Dd5gbiUUbfEnuCvX
	 kACixhxt3L5amLObMblQ7r0RlZYyAkuRhArtcq+M=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 7A8CCBE5D6;
	Sun, 26 Apr 2026 19:09:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 1E72A5FC55;
	Sun, 26 Apr 2026 20:09:29 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v3 3/7] ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
Date: Sun, 26 Apr 2026 20:09:16 +0100
Message-ID: <20260426190920.2051289-4-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260426190920.2051289-1-philpem@philpem.me.uk>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
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
   both the Panasonic PD/CD combos and Nakamichi CD changers.  LUNs
   beyond 7 cannot be encoded in the 3-bit CDB field; reject them
   with AC_ERR_INVALID.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 317883bac25f..48c7d323d6f9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2951,6 +2951,11 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
+	/* SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field) */
+	if (scmd->device->lun >= 8)
+		return AC_ERR_INVALID;
+	qc->cdb[1] = (qc->cdb[1] & 0x1f) | ((u8)scmd->device->lun << 5);
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


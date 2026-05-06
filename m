Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D2D23183C;
	Wed,  6 May 2026 23:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778111158; cv=none; b=sd50EhB3oEK8wj1HlWscROYGvkOu87UUTci9d4XARYBJ7QDo3xZC4do5JHoR9j1eNvJ+Wxfh1Nj0aDiOKaeZzPrLrvd44PvpcQnSgL0+c1XkSvYWfbkAeCaOu2djvknR+f0yLYzKl5PqlbD6BouM/5PwXIGwta3wLEWSl/bJhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778111158; c=relaxed/simple;
	bh=iSH+EsUYTi5kjwu7PQRwKavxPbeUI9BWXZgW1s3W2BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaNLPezLOzCDzjh9P/SlAZJLviSvZY/F7+M6tnD+GAazp+ZC7IMS4COhcttqYRQ1/+8JUeuDv4/h8QO05DS6TddeptFmxmvTGjmDm2v1bv/TpghlLW+dWJpY8Ck8MKeOJB3Pw1SgYMSrZgtDQ4osONKvIUKNVpJyEnWaO7H45lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=F62v5wKV; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="F62v5wKV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1778111155;
	bh=iSH+EsUYTi5kjwu7PQRwKavxPbeUI9BWXZgW1s3W2BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F62v5wKVl1qC2w8q7i15aHpdA/vZcwB+fYwH1k3puRfawkeM+hg3/nljzTyCct0lE
	 t7D5/c3oGWADvRcG9oXllwdjK+aUczijIySgdGIBKeuojCQ4G0TK7fV/f+/AmYpgrV
	 jYhbdXoLlsBHDi3v3b8CCUNcVBgGk88N8WskcS28=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 6D2B5BE554;
	Wed,  6 May 2026 23:45:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 2C2195FC4D;
	Thu,  7 May 2026 00:45:55 +0100 (BST)
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
Subject: [PATCH v4 3/7] ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
Date: Thu,  7 May 2026 00:45:44 +0100
Message-ID: <20260506234548.1974603-4-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260506234548.1974603-1-philpem@philpem.me.uk>
References: <20260506234548.1974603-1-philpem@philpem.me.uk>
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
   addressing.  Encode scmd->device->lun into those bits, preserving
   the existing command-specific bits in 4:0.  This is required by
   both the Panasonic PD/CD combos and Nakamichi CD changers.

   The SCSI layer caps the LUN at shost->max_lun, so a value beyond
   the device's nr_luns should never reach this point; guard with
   WARN_ON_ONCE() and return AC_ERR_INVALID if it does, since the
   3-bit CDB field cannot represent it.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 59eb97433087..7eb735fed4f0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2956,6 +2956,15 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
+	/*
+	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
+	 * The SCSI layer caps the LUN at shost->max_lun (<= ATAPI_MAX_LUN),
+	 * so this should never trip; warn and reject if it does.
+	 */
+	if (WARN_ON_ONCE(scmd->device->lun >= dev->nr_luns))
+		return AC_ERR_INVALID;
+	qc->cdb[1] = (qc->cdb[1] & 0x1f) | ((u8)scmd->device->lun << 5);
+
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
@@ -3066,6 +3075,29 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
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


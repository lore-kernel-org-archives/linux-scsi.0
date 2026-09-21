Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE7B4C2261
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005280; cv=none; b=JKmr3vIU22q868LyrJMJn4scPjx8IrIbK+QpIveRZW30YAqOW0kor/a1lj89ZeNvtc/TQhYz7JdYscGTmt1rSfP2005PHBCFN0lgEWwXNMQBk0rk6FHdUNpXlZ/8+laLbTyk0+4ykjlNN8WeqnnJK+ymwb2OnTXGyECJs9zigmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005280; c=relaxed/simple;
	bh=QdzZ+y/RPdn67/aJqwHkdeiHqGBV+/kCk1e3lmHkDCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjA3lHan/V+2b5MLMnWHp1HM2lEuDJodNUSNn5Bk9RGPogx9g6o1FEwyEyKncWmeakYOWKgYUKMPt5DsfxMHZuMYDp6jHRhHJkLQXpx8IWha/ggOPVcIdSaWAGY315cRkvCYY+TSQgAz5Hmp8jZMFi0cYkLnj4sYhnRz4fjgSt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQRxDJyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQRxDJyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3831F000FF;
	Mon, 21 Sep 2026 15:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005279;
	bh=k0azR0fDidBRdhqEt2NqC5XIiJfAkYbwE4x0TFyaJ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQRxDJytaAcYkkcTXRtIQM6k7F0QSFTvkVzMspqocDWnWNtQq3yK28ui8BYTI3HIN
	 6aussdvS4fweN5b3kaqKddcjjit44H5ed2OdDwoYjiSpLnC5od2xiBD/b0xI41waUW
	 Ug2q9nnsL6mfeaZerO3lBOCzBxE5T5NH78pcUoQ5eZjvXXxWu3EBns9eD91xTrK9KX
	 b8L7uXnYo3THQCWIqZB0UAf7bBYWyP6hxudq3WXil2siGOFyVxTvVQsPztCe3sMGSL
	 HkctTHo6lYhxKzyGi9vzpe1v1q8NT5wQr5Zx+LVHs2si+cI50YGxBg/AWZ4cS6pJGD
	 v7mFG23V2xsTg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 07/10] scsi: scsi_debug: Do not write a partial physical block to a zoned device
Date: Mon, 21 Sep 2026 17:40:23 +0200
Message-ID: <20260921154015.2971990-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3603; i=cassel@kernel.org; h=from:subject; bh=QdzZ+y/RPdn67/aJqwHkdeiHqGBV+/kCk1e3lmHkDCk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j//bmkWWuiZ83f22i0T1C+FFGpN+fQq5fwpzw1z/ JIVrqS87ChlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBE9toy/E9Y0RLnbP3JsW6P Ztdfw6AjV7d/Fjjw1N65TvGE9CLjyZcZ/hfHbGgo+reEV59bZ+60dY+U2a9Ynvy7pa1WaH3vSVM bA24A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

do_device_access() copies one logical block at a time and stops at the
first short copy, so when the data-out buffer is smaller than the
transfer length of the command it can write part of a physical block.
An initiator can arrange that with SG_IO.

A write that does not end on a physical block boundary is perfectly
acceptable to a device that is not zoned, and to a conventional zone,
where the device reads, modifies and writes the physical block that the
write falls in. ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, does require
a write to a sequential write required zone to end on a physical block
boundary, though, so a partly written physical block is not a state that
such a zone can be left in.

Stop at the last whole physical block that the buffer holds, for a
sequential write required zone only. The bytes that are left over are
not written, and are reported to the initiator as part of the residual.

With the default physblk_exp=0 the physical block size equals the
logical block size and this changes nothing. Nothing changes either when
the buffer holds all of the data that the command asks for, so a command
that transfers fewer logical blocks than a physical block is unaffected
wherever it is legal.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

issuing a sixteen logical block WRITE(16) through SG_IO with a buffer of
twelve blocks. To a sequential write required zone it now transfers
eight blocks, one whole physical block, and reports the remaining 2048
bytes as the residual; before this patch it transferred twelve. To a
conventional zone it still transfers all twelve and reports no residual.

With physblk_exp=0 an eight block write with a buffer of one block still
transfers one block, wherever it is addressed.
---

Changes since v4: the division is a bit shift now, as suggested.
 drivers/scsi/scsi_debug.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a4db282ac971..cf5037e81952 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4273,6 +4273,8 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	u64 block;
 	enum dma_data_direction dir;
 	struct scsi_data_buffer *sdb = &scp->sdb;
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
 	u8 *fsp;
 	int i, total = 0;
 
@@ -4300,6 +4302,25 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 
 	fsp = sip->storep;
 
+	/*
+	 * A write to a sequential write required zone has to end on a physical
+	 * block boundary, so if the data-out buffer does not hold all of the
+	 * data that the command asks for, write up to the last whole physical
+	 * block that it does hold. What is left over is reported as part of
+	 * the residual.
+	 */
+	if (do_write && sdebug_dev_is_zoned(devip)) {
+		struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
+
+		if (zsp->z_type == ZBC_ZTYPE_SWR) {
+			u32 avail = (sdb->length - sg_skip)
+				>> ilog2(sdebug_sector_size);
+
+			if (avail < num)
+				num = round_down(avail, 1U << sdebug_physblk_exp);
+		}
+	}
+
 	block = do_div(lba, sdebug_store_sectors);
 
 	/* Only allow 1x atomic write or multiple non-atomic writes at any given time */
-- 
2.55.0


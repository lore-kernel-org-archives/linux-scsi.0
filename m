Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABC948C41A
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712986; cv=none; b=Qw/XwbnUAgOjRJdvUsGxAJhVPS5s8BgY88+Bb2ToQa8tBzQnJvX1FVemBJpYb82zn5RBGhH9cDMO5LUciUFcowftsMLfyu3ORfBaADjRA/d/mzsjT8QjmLsFRHC56b+3tCl+CFHoa5yWZEJrE1FjO44pGEy1kg2hlBOFMUCZdhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712986; c=relaxed/simple;
	bh=qegM35efXzPK1TBtZrJOh/KVCeCxobUaxm+boxy02IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLKnHbExDn9BeEfedXViw9IHt91rUEu8CJd78EclsZffeh5jQnruDPgKXudAvI5mRfisrg1FGLDmVZzXruvqqQTaDY9rTJuSsxrXT6Mmk5JMzbl6LR0B/aNPqRMJiJnbY++mUbJeNwqQdcHgXS2nLZ5sMxXpPd1jUoOMwbdLtf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHOVci37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHOVci37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAF41F000FF;
	Fri, 18 Sep 2026 06:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712984;
	bh=S8JWjUvzamv6TAnVeZ3H2kQoqedZNqIbqgyIu3MKDVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHOVci37LbHaHFkBVglh/vfB0e8wXllJNV1AOl1FQ3N0klyEg1qk2Xas5wreHepCw
	 wQYTWE6wQ8iY0zK04NpqTPWXEmldKkKoKfWRcKfeX5kzieD7bzWj6f8+AAqAgcf+SR
	 ygSCaXd3z4/FK5fEurwFZq3YLnqOtnDFlJOn9DQT668yK9bhd1IlzlCgNHphFWQgfJ
	 yPTX7msB/iD4Nvr1ijeeh96cnT18cga4IhgNGa3119liKwTsDRWxhRw+txat6A6q9h
	 Qfe0XLtrP5pdKveeHL/TWJP6Q4GixiNnUWF8kkDrAXVM5jTVfsR+I/KBGArlZ0JTc+
	 Eem0xbklS95rQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 07/10] scsi: scsi_debug: Do not write a partial physical block to a zoned device
Date: Fri, 18 Sep 2026 08:29:18 +0200
Message-ID: <20260918062910.1709791-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3470; i=cassel@kernel.org; h=from:subject; bh=qegM35efXzPK1TBtZrJOh/KVCeCxobUaxm+boxy02IE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LKf21g+7bhg5Z/X4i0Ldrj7Z7z/0elVbVPycs61t 3y9oX5tHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjI9jMM/9S2ZIqJPIvq/FL/ 9HN96kOLZ8b3LBQlt5TNfPd//48dLbMZ/tcVTv2tfKQmxmvtyV6tmQr/lzT6nlqe5sG1OPein7q yFQMA
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
 drivers/scsi/scsi_debug.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a4db282ac971..837077a4e740 100644
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
 
@@ -4300,6 +4302,24 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 
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
+			u32 avail = (sdb->length - sg_skip) / sdebug_sector_size;
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196793BD653
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248916; cv=none; b=lIkPo/liuelqu6cHFyx5W8cSbRfRvG/sKmz4GFOZgicejdvfFW8sK+Yx+34HzonyYS4y1TfTuKrcMQJ/FLOXrIZNQaGGkd3whHCeYebfDUmV3K6kqCtYV/jXpzIpqvg+RlYjrp3GrYbxJoBvrb8ffCxpt/lcRQ60/isRiRrKIFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248916; c=relaxed/simple;
	bh=jod1Tz5qivSRPaAWVZIF4Evtzip48DZGM5KSmB2l/h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2lfBym3/h+l32msH0ngGSM07dDUGwoSI9cpVpMMQ6M2R1kWKaeXQ+Jmut+yq7GtZe8uwgQ9dhU1H6Bmpf3Nrs75Q1p8kJb1rTkqUewbzlK/UqQ29UiVSk4L6LIVmqr9CAWeCONF4HSg7Cku98DGzzYaCh3jEbWwPXKR5LnJFFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wz4cnkz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wz4cnkz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D41F00899;
	Thu, 24 Sep 2026 11:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248912;
	bh=fUQBz1dpaLLt8YH3QQXoVwX4MDI+C1icmYtH08a6N54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wz4cnkz1NjwRV0m9aDsDrkjCRb6PBnqClNsTYnXKBOtQs0AN3YLkLXDHW8k+zAB9H
	 9wc3k2dqh3TvLQ53N688gLIrlIKryV9x5cOoSV7VsePKRZPmJ+TQAQTH6H5a3cA2JX
	 b3YzHkCm4c+FYQweGmqYZbYQ/DVWQIfa4wcuP8RYIOURD0uB7d90Oha4plnInFyZ2Z
	 zL4+pl9ycpc4zFV4qgA3NDYp9xjg/tPohjMzz3fTDd6bCOZ0+G+KJt82I6+rzfEMKN
	 sWCQATvVddYBfUdFLTPiYWOnMBV2fToK8RTRnqWVOixlFOK9WdZY6253U9r097AaJc
	 c2FZ93H24Nl4A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 07/11] scsi: scsi_debug: Do not write a partial physical block to a zoned device
Date: Thu, 24 Sep 2026 13:21:35 +0200
Message-ID: <20260924112127.3815255-20-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2895; i=cassel@kernel.org; h=from:subject; bh=jod1Tz5qivSRPaAWVZIF4Evtzip48DZGM5KSmB2l/h0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su8RNJvP0qwgrCPN38R3y/Tmp96TBnMUxVtqQ/8qz 78l+oipo5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABMxOs/IsH3Vvz4OXh+987vy lsif1U78Z/9iyv3z7zw/+f949uvSY3uGf1rrPKZZzt/DukJrxuemsle/zDZ2Hs+abDbV10Ra2dJ lBwcA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

do_device_access() copies one logical block at a time and stops at the
first short copy, so a data-out buffer smaller than the transfer length
of the command can leave part of a physical block written. An initiator
can arrange that with SG_IO.

That is acceptable everywhere but a sequential write required zone,
where ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, requires a write to end
on a physical block boundary.

For such a zone, stop at the last whole physical block that the buffer
holds. The bytes left over are not written, and are reported to the
initiator as part of the residual.

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
 drivers/scsi/scsi_debug.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f434fa033745..0171dab59865 100644
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C53354707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486827; cv=none; b=WtYMX0+KXv/dRNUQeiLx37xp7e5AGAkUm8Bl0bAzLUtRyJ4JAd0mOzMSU5CPVZnqw0C1waq153jIX1HVkhksR1drEcUccNOZU1l8w7vRRcxh5TxE/uUD7iueB5ilGpfpu8WJjCDcYNFhi+kRCtUI7Tl8FHik+EwHji04Nv/3imE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486827; c=relaxed/simple;
	bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0WexrKCg/JRgByJjkkbFp+5+RyqgnHB8TEuEL3VVYftrSut+stIz4JF3fjPyGMaOhpoHOmHDEpTknQiba5sAYpbv62X6sv6kfzlziWDQaFaQME+9fZl7H3I71gzBNwO8/9lxPgJ9YA29dXQ5Cc0N5qd3BFzydpnw5nKyiejPLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMAKWn3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMAKWn3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE531F00893;
	Sun, 27 Sep 2026 05:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486825;
	bh=ey0gyz67TSo2myMlN7dPMXp4he7umj2+wNfXxNtkXX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMAKWn3PoLkUEgqxKfp1YxzxV3I0P7J+bo53O3bgFRmyA01uUdHDft/LEY9Zkygin
	 Lu6homqpn6ziR6hfTbKptTLmXcAkOLdRa4ZOTdvnP4NSYZoFM+NT6kmVQXJDF/NtDv
	 SxKmTjmvV+UdvJ84biwsDWgfol738Cwh+bwOqaczhDkWZKi8L2wGv5THJ8YRYtV+2P
	 JJLGkhVtVcdY+RGsvJSnZeIvfxnRtbad0fbYc3BZRXQz+x5opCzg+x4YYgut3Lyg9Z
	 rH8f3lzglp3PFoBid/plbnOEP4eHetSTwZcg+gGCeBOCq4q2bPxx1AKchR0ESrolHs
	 sncPMWD/xtirQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 01/11] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Sun, 27 Sep 2026 07:26:52 +0200
Message-ID: <20260927052650.567035-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1627; i=cassel@kernel.org; h=from:subject; bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rJS3O33a0GBvZS2D9Pk7/PknxY7KurIr3Zl5xVCnZ sM9IZm2jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExk7yyG/7H3NKfqL2V6WJzI tmjptZs/jZQr4v8F790aNK3iXOz/k72MDOc3J934U8v5gO3WtjUs555bGu/VCTN0OPb05fvuJuZ d0xgB
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_debug reports the lowest_aligned module parameter in the LOWEST
ALIGNED LOGICAL BLOCK ADDRESS field, see SBC-6 r02 (T10/BSR INCITS 587),
5.20.2, but nothing else in the driver acts on it.

On a zoned device a non-zero value puts the start of every zone in the
middle of a physical block. ZBC requires a write to a sequential write
required zone to end on a physical block boundary, so a host writing in
units of the reported zone write granularity could never write such a
zone at all.

Refuse the combination rather than emulate a device that cannot be used.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed lowest_aligned=8    refused, -EINVAL
  zbc=aware   lowest_aligned=8    refused, -EINVAL
  zbc=managed lowest_aligned=0    loads
  lowest_aligned=8                loads, as the device is not zoned
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..c664966e95cb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8734,6 +8734,11 @@ static int __init scsi_debug_init(void)
 			sdebug_dev_size_mb = DEF_ZBC_DEV_SIZE_MB;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_lowest_aligned) {
+		pr_err("lowest_aligned is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
-- 
2.55.0


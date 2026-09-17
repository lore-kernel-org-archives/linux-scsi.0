Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10D64D0CE0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643033; cv=none; b=a9yCuAqESsWHYyoJV3C9nXT668Hf9D71SbL2J5+EAn0a7hm9PL9C/FMImx/Xs78E3SzLr/vJzvJ7VL/CeQXNUkAJbJhBKPAyZnAukUyfXPFOu2Kk9tnaV8VltXlnIuqwC4dIFKIfYPgtsgvAUKX6d9+him/KGYUftAsdPt80fsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643033; c=relaxed/simple;
	bh=vgHGvd7q59jNipSbeOqAkQsbboWjoqTgLXoB00WpA8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfmc1G0+n+roy8rZoeTXXuDRWa92Yn50WXZsuPn9ksEgpMoUchu7eQCzfz3qq/5M5ml18VnjohXbUSGaKT9uxwiaAy2ggyrqvSglEtN2sQc8Jg7ZZ8nKp8HXOoEPGuXu8/omcApOS/mbRZbcobGUR6K71cZphVWZ1MZA5SqZQRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bY6Q/n9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bY6Q/n9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41D91F00898;
	Thu, 17 Sep 2026 11:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643022;
	bh=OYY9S7muMocGulM/xGSXdAWRGYv3opg8MUPZrcLpEKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bY6Q/n9yv6yE47aWnBACLBJvG311GOxzLJ25dVxf7djb9VtU0Imds7dU9zGCnZLy8
	 5+nBCw9FvED1o1NIV8Q5F9WYAhA4Ktg3pRjbykgwTNEpLumUw2VtOIypbxakxdxqkJ
	 fWs92i1FrEAM2EwLRXtwP1PCsJWEcSh/2pWMZKdG1pMWmgk+k1BoDPAUR+LcN6/ZjA
	 aKwzVXvZK13pjr6TlxG1ORyVSNMVILOvSStSXvLnjast7LRRhZu0JXFACVJzQghm7Y
	 2sgkA+7rj/92TvDoWUvft+fG5J21fNEy8Tyh5NEiT3I0jeNKC5j7qc69duo3XeEGse
	 KPYVoTI5mh1qg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v2 1/4] scsi: scsi_debug: Do not advance the write pointer of a failed write
Date: Thu, 17 Sep 2026 13:03:18 +0200
Message-ID: <20260917110316.1104863-7-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917110316.1104863-6-cassel@kernel.org>
References: <20260917110316.1104863-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3604; i=cassel@kernel.org; h=from:subject; bh=vgHGvd7q59jNipSbeOqAkQsbboWjoqTgLXoB00WpA8I=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWn/hxt0D/u4WbcvjWT5yCb03OHeNzlt/YucHgzpdd2 humJXOrdJSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAit34x/FPfHbkxnWGv8rGL Yq+MVhTH698v2nNwncjq38J8D5Xmnb7J8D/qfKV8f2RWhJjMoZiV2j07FKbMleGJeeUy53jmO1H hHmYA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_dt0() and resp_write_scat() advance the write pointer of a
sequential write required zone by the transfer length of the command
before looking at what do_device_access() returned. It returns -1 when
the data direction of the command does not match the operation, and a
short byte count when the data-out buffer is smaller than the transfer
length, both of which an initiator can produce with SG_IO.

The zone state then describes more data than is on the medium, and a
write at the position where the data really ends is terminated with
UNALIGNED WRITE COMMAND, because the write pointer has moved beyond it.
The zone has to be reset before it can be written to again.

Leave the write pointer alone unless all of the data was written. A host
that retries the command writes at the write pointer, where whatever the
failed command did write begins, so the retry overwrites it.

Advancing over the data that was written instead would be no better,
because do_device_access() copies one logical block at a time and stops
at the first short copy, so it can report a byte count that is not a
multiple of the physical block size. That would leave the write pointer
in the middle of a physical block, and ZBC requires a write to a
sequential write required zone to end on a physical block boundary, so
no write can leave a real device with such a write pointer.

resp_write_same() does not need the same treatment, as it writes with
memmove() and cannot fail part way through.

Assisted-by: LLM
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

issuing WRITE(16) with sg_raw so that the data-out buffer is shorter
than the transfer length and do_device_access() returns a short count.
Sixteen logical blocks with a buffer of twelve, and eight blocks with a
buffer of one, both leave the write pointer where it was, and the full
sixteen block write then succeeds from there. Before this patch both
advanced the write pointer by the full transfer length, and a write at
the end of the data that had actually been written was then terminated
with UNALIGNED WRITE COMMAND.
---
 drivers/scsi/scsi_debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..3ce2dbdff177 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5150,8 +5150,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
+	/* If ZBC zone then bump its write pointer, if all data was written */
+	if (sdebug_dev_is_zoned(devip) && ret == num * sdebug_sector_size)
 		zbc_inc_wp(devip, lba, num);
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
@@ -5314,8 +5314,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * writes behaviour as possible.
 		 */
 		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
-		/* If ZBC zone then bump its write pointer */
-		if (sdebug_dev_is_zoned(devip))
+		/* If ZBC zone then bump its write pointer, if all data was written */
+		if (sdebug_dev_is_zoned(devip) && ret == num_by)
 			zbc_inc_wp(devip, lba, num);
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
-- 
2.55.0


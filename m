Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C9E298CC4
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580098; cv=none; b=HLbgiGlJMks9rgOv5T28XJDx4lJHz9c1CO9P7nK/2Yj6tg63w2DBnEZbsklabaGChJmUUetSOgue7GaIqZAAi4iB3RHqAt9RINzprn2wJSZTMolFs7pP+3EMEDEQJZrH39KnfWATpF+wWkuwNYatzMFaLebIIOFfZI6JlCyqlF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580098; c=relaxed/simple;
	bh=lg209iIuS1BQbWnOPf/JZSvd7Fe9M6qgNmaxtBGlc7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a02px5v59lc33e1HZRzdKtviqT2LO/X6pSF8BoGj81IRGsGUDH1qnL9XCkpI7z4QEMbj25qEhbuhmD7D8M2pz6tGhOy2dbmeeaW90arXqKZadLtiej5CWsSaQwBxC9LZ3DFvWRGY9UvqVZ3LxkuH7y3EP69p0iPeA/Omn6Wi9XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfPq5JtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfPq5JtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216791F00893;
	Mon, 28 Sep 2026 07:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580097;
	bh=sgbwpp4bpmeP5JKfa36quTsR3FDHrRPWKUi1B0uBxN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfPq5JtBHJwEvzc0dJEHQx2oefzWj+1mArtCMbKNPWC+S2DK5iNSxtdeu71OdUCS5
	 lO/XlILJTPa6vNw7sO+P/jMI0vgKL+TlkyvrtQcPMfKwmDtApnfbmf4nFyxgjzTDE3
	 tA4PvUiShJak5Nge7vp4v2VkfttD02Q3GsTFTFkp/gdBlUwdrVvNcGnL7I9Yqv09Bt
	 7IakDenjX4u0dsv7aOgX8UEnMerHWfc4SxisLp54TSCb6NzgIGf3S0A1iJkZNrmne+
	 sDDVvgKIayVxmgO7t34w7nVbusp0qju2MtN/5sfKPlQlH0FUikh5nPG6ckrPj1cUTj
	 7lDlekc+JJFzw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 11/12] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Mon, 28 Sep 2026 09:21:14 +0200
Message-ID: <20260928072102.725566-25-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2501; i=cassel@kernel.org; h=from:subject; bh=lg209iIuS1BQbWnOPf/JZSvd7Fe9M6qgNmaxtBGlc7U=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iabr3JtYn3aV55pluMy/5IjnNnPdtfT+L8ucGpl4I nGT+j6bjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEykZxnD/yiJZWyfhdZ/WfHq fiPPP+nZrFyLJ7uXTjbaZdcpM9+/XZbhv+Ou/xfvLo+J+rBEpyvyhGz5wyt7JnxKXBXFqPs2L3q aETMA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

When logical block provisioning is enabled, every command that writes
user data calls map_region() so that GET LBA STATUS reports the region
as mapped. resp_atomic_write() does not, so GET LBA STATUS keeps
reporting a region as deallocated after a WRITE ATOMIC (16) has written
it.

Call map_region() the way resp_write_dt0() does, holding the zone
metadata write lock across the access. That lock is what serialises the
map against resp_unmap(), which does nothing unless logical block
provisioning is enabled.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1 lbpu=1

GET LBA STATUS reports a region that has never been written as
deallocated, and reports it as mapped after a WRITE ATOMIC (16) of eight
blocks. Only an ordinary WRITE did so before this patch.
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8c8b409f921a..8fc515a7a7e1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4876,6 +4876,11 @@ static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
 	return mapped;
 }
 
+/*
+ * Callers may map the whole range of a write without checking how much of
+ * it was written. SBC-6 4.7.4.6.2 allows a deallocated LBA to become mapped
+ * at any time, and only requires an LBA that was written to be mapped.
+ */
 static void map_region(struct sdeb_store_info *sip, sector_t lba,
 		       unsigned int len)
 {
@@ -6204,6 +6209,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6252,7 +6258,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
 
+	if (lbp)
+		sdeb_meta_write_lock(sip);
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (lbp) {
+		map_region(sip, lba, len);
+		sdeb_meta_write_unlock(sip);
+	}
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0


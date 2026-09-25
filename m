Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502B21DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320686; cv=none; b=kl/aM49wAFkRstl7zO0N5SRzfNyN4gRLnpwIT2MLLOP1OtWDQve6ON7DDbh55dqgQgiC/2ZkTlNCTWvJrRzoaRfefrw4Sw5UYGZUwURrbPO08qIl3s+/AaDaM1/EkVRMQonFVQxiTSVcvexVnJS2MlLj1Phsi0temwUrGrfXSzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320686; c=relaxed/simple;
	bh=l7bp4cnEnPbwWcWekfiuvVZ6jD2WZAewNLMCnkz/DGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSCyBGmbDQYjkqoUjzcFTZs2oEOadVClogs/srkxR1Lx1qdooXyZpZwfbGqgvgrX0USiKW7WDmvcGq0FWFBYi50hsQIm5c3XlQLNiKIQLaYSup9mRSljdpSDUHXqvIj+BN3ejNPYSC4zvSf53G8CDtrjV9FzXRqigrIyQbxX0+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDLMsr4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDLMsr4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691BB1F000FF;
	Fri, 25 Sep 2026 07:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320684;
	bh=WObWXRYr4SfdCxe70WfyNIQxiLEj5gLT71Jk4sK83So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDLMsr4mj5uZ1rDZqLgrm5lFRvYdpFjebL8srYuLPpKzwU17Q+Gmd/mKYo6q581EJ
	 pjfed2/HxLmJwB4v4dX3xPKsi2+jQejNPd9QdQQfZUTSN3Oala1h2D6AQwbz7yN2uH
	 E5XLzUYPLeKPvJtdESff4gTVznLF2TUTqztENYUTgp+KjGPtXb1QNgwmywNiI+ecHG
	 Ph7u8eZrRXTK7bK1med77G3c1tZ7gmbfEoBToqChff0AwyKf6NRFzzwxNUzYXzftax
	 d92LL7FEl/eZVaUSzxqrZB1CiSQALkoGpzpeFZBhmr0BcW2YsfykegL01gMtg3a08H
	 pbrdM0bG4fv2Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 10/11] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Fri, 25 Sep 2026 09:17:37 +0200
Message-ID: <20260925071726.140915-23-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1982; i=cassel@kernel.org; h=from:subject; bh=l7bp4cnEnPbwWcWekfiuvVZ6jD2WZAewNLMCnkz/DGQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQh3P7opmrrtXSTP/Ld5dxf0Ht65N+erufSOTcfFZ 1Q9+em4oqOUhUGMi0FWTJHF94fL/uJu9ynHFe/YwMxhZQIZwsDFKQAT2bmWkaHlkl3bilvTygu5 Nq1eNH89u2KiYmUUv/ed5mWhe7a392kx/E+T2iS48+gUQZf1gS/zd/EFT7BV+f9owUrVafHLrj+ 4E88EAA==
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
 drivers/scsi/scsi_debug.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c0bcf8155fc8..c407f4c5ac47 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6203,6 +6203,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6251,7 +6252,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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


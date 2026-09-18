Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19938330E
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712990; cv=none; b=c6Anb/6UGt0lIZseOKXFSmpqvue43WgSfhWtR9brUaX4IWs8J5cIO8Vz1Lfk/aDrr2IhhW3adm+zQ/woNhdLutXQ0LzsaOjsolgHe8KyuuyxcTbrpVeR+pTi2aHZRqOQrzmmmmvtFR2O7w8VhD2JI6mz4gMsSKNgrXQhO2V8ABg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712990; c=relaxed/simple;
	bh=ldjqDYJie5dPFK/BLSHz0dqE8UOAGcMywLObc/1atBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9PUJjjEgvH9e2n4qsF1y9ETywsDCsxdX2Q7eWvXKcreHtsPR/I0zso4gQdQKdded24NsyUuLWo7VxVSQSGAYuEvZOte1mlDw08I+XGqEwecIj675MDMGwMG+Q1wzDRPs6NPUqDZk7dyIsAh+hvE1qJxK1ohlM2RUAvXnbdOyqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCHLXEQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCHLXEQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC71E1F000FF;
	Fri, 18 Sep 2026 06:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712988;
	bh=5vANFAyZHCQU+Q0zdYJUbDlYY8YOmsX6rIwCpasYGFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCHLXEQsvkb7wVPmG+hqVOx6E9QwPNbo+TGhOLJ1SRaTAs5MzhFLjaCz2bVat9BCm
	 wbB/vXROuZWhPdioeXdyzGgSfBD7mzo2cH7jJtGKLqK/laVwxhqr5Xur0yHGteAMla
	 NnMkOyLAhKvuTKx3I8BZP+lCOg/6QH2lf2GV4SRhhrhte8alpU2hD/Ns6SUAeq+Y3A
	 PSPk8tjs25jVrI+Iy8S7wO5HIJuKQIGbphq1NqdEaRBA6/65fuyLXKNIYoqojo2lC4
	 9LykHRaydlc+EGmpgu8MENZXVt9CYsBp7AqlMCLYPoVYMF88L5kgPd8v5D+nM8Pn5q
	 x75bksHpUdq9w==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 09/10] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Fri, 18 Sep 2026 08:29:20 +0200
Message-ID: <20260918062910.1709791-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2513; i=cassel@kernel.org; h=from:subject; bh=ldjqDYJie5dPFK/BLSHz0dqE8UOAGcMywLObc/1atBI=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LI/0LSnMtrFpDLbr8l+81fv9R8lJhfnR9UFLt4Sc NsjvUi7o5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABM5MJPhn3J2UpZ81eN9t+fe ON7wvVjmw3zGcx67JB06JXg99uRFbGL4K6Aut/NY3JtPn678OPs95ZParf2xX7bpdTh+YX3+boK YETsA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

When logical block provisioning is enabled, a command that writes user
data marks the region that it wrote in the provisioning map, so that
GET LBA STATUS reports the region as mapped. resp_write_dt0(),
resp_write_scat() and resp_write_same() all call map_region() for that.

resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
provisioning map untouched, and GET LBA STATUS keeps reporting the
region as deallocated after it has been written. map_state(), which
GET LBA STATUS uses, is the only reader of the map, so that is the whole
of the effect.

Call map_region() the way resp_write_dt0() does, and take the zone
metadata write lock across the access as it does when logical block
provisioning is enabled. That lock is what serialises the provisioning
map against resp_unmap(), which holds it while unmap_region() clears map
bits and zeroes the data that they cover. resp_unmap() does nothing
unless logical block provisioning is enabled, so the lock is only needed
in that case.

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
 drivers/scsi/scsi_debug.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cdea21b570c4..5243401701f9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6200,6 +6200,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6244,7 +6246,18 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	if (lbp) {
+		sdeb_meta_write_lock(sip);
+		meta_data_locked = true;
+	}
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (unlikely(lbp))
+		map_region(sip, lba, len);
+
+	if (meta_data_locked)
+		sdeb_meta_write_unlock(sip);
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0


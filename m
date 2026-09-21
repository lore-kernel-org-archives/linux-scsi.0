Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D594C33DA
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005285; cv=none; b=Xf81MIV0RBj+zVaLIFD1AMLV5GRSe7dgSXT/OZxidFkj+GvDfPtnQNlSVcegYBA5yXASBus6Lvi3Re3H+mbm+/jJxpjViVpgK6IHU9SVYYUraqOZdeB6c7a7yLzUBHqbZejICl9i+krEPUVtwm7VRPpOat+Od31pOWDcNI4R4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005285; c=relaxed/simple;
	bh=ug/Jvqj2EiezvFZAVqH1YXkyn6JV/6OpjcbqR+85CL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYsnp/jDs2ToOr35PeqXGc0USG22/u8prG9O4SPXju+swCAy9pEZA5tQR/qYnU99cSmM0Vz2i8IowSQZAShN8xg3+Qk2YNqZmaXy7zw8FEF2GBF6jRC2h45akOm3rZtSoONQHSL20K5jskGUScEzY6wyNzrRJ5OEC0OuJLQNuhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pl9lIpV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pl9lIpV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF591F000FF;
	Mon, 21 Sep 2026 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005283;
	bh=hv20pRO/zbRuFJ0mdj+KlKV1kYRqTls1qB8PJpyU9/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pl9lIpV9WmhVBxIZuCcTmoxZCS74u/b0tE+tvNYYNnHl5n+RgWvkJNrDXgBHyxh8X
	 EJs9Q2Pt43woZT6WwUBi2cHkuIMtI+4geOjGAG3ZQu08VB2a4hBN30+lcM8OapqP3u
	 jKQK1VVbVb5BRzi9hkQ+6lu+eFLWnuMORsGSNCBe+O7Upicf+XosPAA3bEFgMeqATO
	 ok4I8O5fdNdejzwr88N+oFcXvNuI48CY6vNq0P6pVTqPyPdf549ytFC1tuqHYV8Stc
	 fXshemPsSJrmRKj0MjFLKWPpS199loZBYBeEKRfXKWYzjQCYIXFRz0bQxIx9HY/7xN
	 CY3C0GXzGUofQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 09/10] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Mon, 21 Sep 2026 17:40:25 +0200
Message-ID: <20260921154015.2971990-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2501; i=cassel@kernel.org; h=from:subject; bh=ug/Jvqj2EiezvFZAVqH1YXkyn6JV/6OpjcbqR+85CL8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j93y2Pu+Xm4+pxlYrCZpLr6tvfaMaenPEw20tv5q dVZ4oRdRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACYSHsXI8O7yo4oPG7QMLhlf WxjAq7xU1mpWUclpk45vG6e90jVzyGD4Z1GcGMw0W92bWcZ5auWqh0fbGfN8fNaVfrUVMo8P3+H EBwA=
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

Changes since v4: the meta_data_locked variable is gone, as suggested.
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d07f6f891951..2e1a02c383a3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6202,6 +6202,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6246,7 +6247,16 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	if (lbp)
+		sdeb_meta_write_lock(sip);
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (unlikely(lbp))
+		map_region(sip, lba, len);
+
+	if (lbp)
+		sdeb_meta_write_unlock(sip);
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BBA44238A
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248919; cv=none; b=rDMZoIPHMyjhgy8cvkFYC+RPo5as5aqV5bro9HEkm+fypWGUHquHOCW5jPoiwin0w+ON5xYYOqUf3RwxLOv0c76iqV2S1VA8unfdrIUhG2/7P7HkqaKa5+R53S9RIl2oAD5ctLNoZStELnuWYecJ2QH9gujHcYePNHFYzLIBlSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248919; c=relaxed/simple;
	bh=TXx/CdYhUyJG4RJnwTRp7TVMAiy+e6h+AXLWWulrNc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tySNgudNkUG5HZedotOp9PdM1+6QhlDmKR0oyfBD8lsP8YGDaFvdVbjv1CPwVf2tr3/tJC5goc2UbfTQo4e3DYuxouBnQRwyINwI5o1URKxTAGvwdzz3R6nC8ftDTxnaR6+BcnLn7ltXBuzwHFXFXfZLVdZCrvssknIoBCycTpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVJYKchw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVJYKchw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB291F00898;
	Thu, 24 Sep 2026 11:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248918;
	bh=MC8tqB2AssH9p/y9HIzL0FAl7kAsmYxDcS+LVEYJlJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVJYKchwvi6J2R3MTVll1yKsKrU7q42bo/qWqvTe7NmwVI6YuSjg63J7SeDLmuLM3
	 QXlaPwUHD96FuKsU+FoUsAMNLcQK8UMlL3Ck+uKxlzK17TDLgAvf2E4x1Yssspye6/
	 nSykQTcURBrfjJyj3HN8CLqeDuDazm8l0iHzburo3O6lGtBiEGJKkUBbCjuZyx/xqt
	 QH9u3lUoE3ucJWhTsjI+Zfc+o0ddpxsxJNn7mExf53A1SmOzK5ekQnS9iwb7JGhLOd
	 uE58E+adnNotzVKxGyA6GA7Gsz9js8qEMpMLETRmn5u45TzvW+jBlrxlLbas86wFU6
	 Mq7Tiai7gc3Wg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 10/11] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Thu, 24 Sep 2026 13:21:38 +0200
Message-ID: <20260924112127.3815255-23-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2044; i=cassel@kernel.org; h=from:subject; bh=TXx/CdYhUyJG4RJnwTRp7TVMAiy+e6h+AXLWWulrNc0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su85rn9U/+wRD5dfL4KFqz6W6r+rue498d/K+9GpC 8095NwvdJSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiTcUM/1MKr6cvmFYwU3R2 9zGPVcy1ql87ypotnu/Z8/a4p8n5q4cZ/hcddVzFoOuWprmB9dtxnT/Ruz7u8a6ov/bmvI3KhV+ uD/kB
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

Changes since v5: the dubplicated if (lbp) blocks are one.
---
 drivers/scsi/scsi_debug.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3b112ad58489..cbe21ac06044 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6198,6 +6198,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6246,7 +6247,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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


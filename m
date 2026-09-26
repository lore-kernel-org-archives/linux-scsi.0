Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C172369D61
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446650; cv=none; b=mMtBaTCD656XHBv6dy6IXyVK9kDxykIF4JZP3habSz0J1PbZgWzR4s6L6dCpumpiXelLkae2OnZ5ybSyVpdVp53WmBRPFxPdrN4CIfOmnaLK34VFLjtLxSASPNPc2X5duRr8QIQsaELJdTNwg3KsGR7IUAPjpSLO9uxUfRXuqdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446650; c=relaxed/simple;
	bh=zcyXAOf4VbSIay+KxEIY1LR3GZ37zAUz0g6FWignRu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EviYi9C/r9K8THIZzayWgCdlEKbBx3GQ8bxoFbxN9vuQ5pJ+NrF/KW+wr7qUr5jqgdAS8bx+ZOlwkChOfX3hRLlknw31uJ4r0/vDT2VOtFj7EaX4CmIglgUmWHL30YlW5bTPlE2zTLVzb32QPQ8UyR27eebvpo3AX/zqqLIUBZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJKmlq19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJKmlq19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A721F000FF;
	Sat, 26 Sep 2026 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446649;
	bh=NRMgc6mRmbsyjlNgdEiuaeW1Vq1ww9JjEWhZyyRn2mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJKmlq19EUHmt1rJSXekNl7ZdTWg48gUHeHhCVuFB6xwy6hyXQ2PovQfYSbTanIet
	 IZ4ERisXqzxqUi/Tuog58c9zBo3lttGs+Q+i7AGv0Zv9ou5XX4xCqPPGSE9MLA+Grd
	 q6fd5mdJY5SN+4dauUd5YPsuvGDLQFWARzq7kcfaP3fl0aBwSCqzPyhodPjhpVtcGw
	 JmKZeqnJ78PYgmVlO99xBzWounzpoCQG3eb50fGtqSPxDMRZj164lvL24stTaseveY
	 WFTHjJ7eIklu2V13dGzChjDy+mx1Mq3EZqZD8KgNgeSobKHmemKQRblCK54vCeY6ah
	 XCCk1U+IluGFg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v8 10/11] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Sat, 26 Sep 2026 20:17:13 +0200
Message-ID: <20260926181702.508975-23-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926181702.508975-13-cassel@kernel.org>
References: <20260926181702.508975-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2627; i=cassel@kernel.org; h=from:subject; bh=zcyXAOf4VbSIay+KxEIY1LR3GZ37zAUz0g6FWignRu0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ28MibydUrTemqPVj1MLB1qYh0r9Uii4UyInW9Tvv75 rMWsFt2lLIwiHExyIopsvj+cNlf3O0+5bjiHRuYOaxMIEMYuDgFYCKh4YwM/6+s+NR2c7eI+F1f e4H2Rw/uSS2T4NHbL6OzQmgFq7Z+PyPDi/yfGas/LGt1WzerqbH7tOKa1N13TH4kX49LmLB6NeM ibgA=
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

Changes since v7: a comment above map_region() explains why its callers
may map more than was written, as John suggested.
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c0bcf8155fc8..0ae0a6ac3baa 100644
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
@@ -6203,6 +6208,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6251,7 +6257,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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


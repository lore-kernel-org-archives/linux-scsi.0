Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C521CC58;
	Thu,  9 Jul 2026 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626525; cv=pass; b=cou0GoF8M8i4S4clEr4fye4+pP3zQ2hzRw+DVvQD4VNur/NVIAAojXnsGvz8lKQfWFmdhCp8nYrIXniW7ee7TdQD1hOA+Xt3meavG4YZTkziT/MKnYMv9UIkavali6gI2ykgzv91uZ5VCnvCMEKYKU9EkDkcqzMR7P2WWf0P4CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626525; c=relaxed/simple;
	bh=dDjjvt+WNwBkHfdPdkwDuLBSLtinU9dJAE6dohogZ20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfZ0VzFkcIURpzoh8gfkt5jkZ9ecAKmnk15sN1IRnKQpNpVx9ZCCfE3wRy4Cq7o8HKpwepP5MyM0HJW7ep2N/JJ2A3LZoyVaXtLzQB3+MJIrAfYAU243jMeUEUjO/oFFoyYs2j+T7qO3Nm4idyKBHn4Jetpz7NYB+bZ9PB+95zs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=U6e+0uOh; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="U6e+0uOh"
ARC-Seal: i=1; a=rsa-sha256; t=1783626509; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=TS2jbqFZ+lb4+VfgDaGIDiefHqMjc9smCWdoOvDipM7ak55Z1lzaNl6SPKgERH51O1HF9TdNhji7GcKD30304Fa91ZhgLvvgONEz4bHoUDM1i6C81CEfQVka0RQYxq0JG2nly0HkOCSvdXyuNtvD3I72KJTxwkjOSEdd6zII4sw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783626509; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Gk3XmXycZs1HvmQ6VNzfMD4HnSIDWANgBlFIkYgCNJY=; 
	b=KUXh8/Bq9xYOholbyqF9kqxmEv4mxwTOAenlSrKL6qZSLOqe9aLzSEWWMWM/yBUO5IxZ4CkZCvfMuILBnsyt0/8E96fP/z7N+SrRLr4P0GdWQz/RTNZ5dr6en0DV/GMQyR8OKbPHa5VxlG7Ec93Sn6Pg+5zrNJoC1xK1KUBv5Ds=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783626509;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Gk3XmXycZs1HvmQ6VNzfMD4HnSIDWANgBlFIkYgCNJY=;
	b=U6e+0uOh3R7fYTBAHIWnwYMnjaZVrzZBIVnv+t7HoVU29k7GJDhaySyIWQ0w0g+t
	NQPWHPCdIAIPY/EQ0oNXe8sPokgpgxB8b0355wbA+vmPf+N0myRtG2eQPXDGZUXGl1v
	OUD8Peny/1k3ZmAxyosHHzBJSqzsGHD7dAYwoDeM=
Received: by mx.zoho.eu with SMTPS id 1783626507485699.487861191679;
	Thu, 9 Jul 2026 21:48:27 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: shinichiro.kawasaki@wdc.com,
	damien.lemoal@opensource.wdc.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write
Date: Thu,  9 Jul 2026 21:48:24 +0200
Message-ID: <20260709194824.50777-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709150631.45018-1-security@auditcode.ai>
References: <20260709150631.45018-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

resp_report_zones() reads the REPORT ZONES(16) ALLOCATION LENGTH field
(cmd[10..13]) into the unsigned alloc_len and, apart from the
alloc_len == 0 fast path, uses it without flooring it against the
64-byte report header:

	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
	...
	desc = arr + 64;

For any alloc_len in the range 1..63, alloc_len - 64 wraps around
(alloc_len and rep_max_zones are unsigned), so rep_max_zones becomes a
huge value instead of zero. At the same time arr is allocated with the
raw alloc_len, which is smaller than the 64-byte header the function
always builds, and desc is set to arr + 64, already past the end of the
allocation. The report header stores (put_unaligned_be32 at arr+0,
put_unaligned_be64 at arr+8 and arr+16) can then run past a sub-24-byte
buffer, and the per-zone descriptor loop, no longer bounded by the
inflated rep_max_zones, writes 64-byte descriptors from desc onward,
producing a slab out-of-bounds write.

Fix it the way ZBC and SPC require: allocation length truncation is not
an error, and a small alloc_len is a legitimate probe a host uses to
read the zone list length before allocating a full buffer. Clamp
rep_max_zones to zero when alloc_len is below the header size so no
descriptor is emitted, and size the allocation to at least the header
so the unconditional 64-byte header build cannot overflow. The existing
copy-out already truncates the result with
fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len)), so the
host still receives exactly the alloc_len bytes it asked for. There is
no functional change for alloc_len >= 64.

This supersedes the previous approach of rejecting a sub-header
allocation length with a check condition, which would have broken those
legitimate small-alloc_len probes.

Verified on a v6.19 KASAN build: with scsi_debug loaded as
zbc=host-managed, issuing REPORT ZONES(16) via SG_IO with alloc_len=32
triggers a KASAN slab-out-of-bounds write in resp_report_zones()
before this change, and the same command produces no report once the
clamp and allocation floor are applied. Reproduction requires
CAP_SYS_RAWIO to submit the raw CDB.

Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
v2: address sashiko-bot review of v1
(https://lore.kernel.org/linux-scsi/20260709150631.45018-1-security@auditcode.ai/):
rejecting a sub-header allocation length with a check condition violates the
ZBC/SPC rule that allocation-length truncation is not an error and breaks
legitimate small-alloc_len zone-list-length probes. Instead clamp rep_max_zones
to zero and floor the allocation at the 64-byte header, letting the existing
min(alloc_len, rep_len) copy-out return the truncated header. No functional
change for alloc_len >= 64.
 drivers/scsi/scsi_debug.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..a21d76fe35f6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5911,9 +5911,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
+	rep_max_zones = (alloc_len < RZONES_DESC_HD) ? 0 :
+			(alloc_len - RZONES_DESC_HD) >> ilog2(RZONES_DESC_HD);
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
+	arr = kzalloc(max_t(u32, alloc_len, RZONES_DESC_HD),
+		      GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.50.1 (Apple Git-155)


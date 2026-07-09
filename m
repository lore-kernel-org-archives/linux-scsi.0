Received: from sender-op-o14.zoho.eu (sender-op-o14.zoho.eu [136.143.169.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36366333440;
	Thu,  9 Jul 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609606; cv=pass; b=XffC3g6H9V9sGbn+EUH/hpclPaLwkY0wkXwBOFuGMycGmrM5+yfjfhmQZHPTPK8hR6GbzKaYb/Q8rw3VrLQB/vOHpgqeB773AP8vv/lhd/KW3vedmGYZPB9cMt/GPrQNSDK3usNfc62dmKTsYEFlw4XdAFb/kH9OUv7sHROoxLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609606; c=relaxed/simple;
	bh=84bIJyohN0btGTNkT/Q1umTDxT5SbFgG3xgDpsL0kbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t9sTSsjJAX2c17fvQPOS9CgZ26BW1MFCqX0Rdke4N9HbpNEdubOPhn7lGBTWq4Cb+F2ULYlfm2oxC8TfPY4Q8yV/zlHqgppKUj0svGm6qBSuzL2UIiFkZDxe/Pof0EGmHz8/mkg8N9VmRx4qrIOvTFpTLHJnPRofiqTDIetDujg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=NPxE7Vh0; arc=pass smtp.client-ip=136.143.169.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="NPxE7Vh0"
ARC-Seal: i=1; a=rsa-sha256; t=1783609596; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Eeu/Y4sA+biKDUZ6nW1Ng3w7r2HI7yF8z9tREDCoSfKxT0czi87i+MJwFdSebAQZvdXpGrdqcFOAbspWUjiScXHzQhN4BsMBlYB/0/TPll8tDpOEZIewF6V5tkgu35DquoFABIAh3plK83eCdO4xpa39VqcxPKzLAUfiTiXzs/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783609596; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=DRFaL7M/HgkqlbgQPgTDq1S4xPq6b53kdKlRyfM4wCA=; 
	b=KjolBSq5CHzs/r0MeNr1yx4otDOVYEtQKBAHxCAg3N7YVIsok1YcCoJtWisodf+h3e5bW2mcwezScv8G9HlpgSyg54LhLgYrC7wDuAzdZQXHwWYychrPRVipJkxHef99cfm2OHGtmRz60bp8Lx6kzf/yjGuaPIpFfosNK8C3T/Y=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783609596;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=DRFaL7M/HgkqlbgQPgTDq1S4xPq6b53kdKlRyfM4wCA=;
	b=NPxE7Vh0SVwpMDvC/98kgLeK+29FPfiuIwW/olFC2cziQif0EexcIAelkTnANi+S
	uz17MTJfj98raEesnu3908L/A9WZKGwghg39wvUnf/Thp1CiKn8aqGK419SUrSf+UG4
	fAQycaJGX4dTZiYLUHjWQk3ntzXK0w/HIeM4fsTE=
Received: by mx.zoho.eu with SMTPS id 1783609594491534.3593889803047;
	Thu, 9 Jul 2026 17:06:34 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write
Date: Thu,  9 Jul 2026 17:06:31 +0200
Message-ID: <20260709150631.45018-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

resp_report_zones() only rejects a REPORT ZONES(16) CDB when the
requested allocation length (cmd[10..13], SBC/ZBC "ALLOCATION LENGTH")
is exactly zero:

	alloc_len = get_unaligned_be32(cmd + 10);
	if (alloc_len == 0)
		return 0;	/* not an error */
	...
	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);

	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
	...
	desc = arr + 64;

For any nonzero alloc_len in the range 1..63, `alloc_len - 64`
underflows (alloc_len and rep_max_zones are unsigned), turning
rep_max_zones into a huge value (~2^25 for typical small alloc_len).
Meanwhile arr is allocated with the raw, unvalidated alloc_len, so it
can be smaller than the 64-byte report header. desc is then set to
arr + 64, which already points past the end of the (too small)
allocation, and the per-zone descriptor loop:

	if (nrz < rep_max_zones) {
		desc[0] = zsp->z_type;
		...
		put_unaligned_be64((u64)zsp->z_wp, desc + 24);
		desc += 64;
	}

keeps writing 64-byte zone descriptors starting at that out-of-bounds
pointer and marching forward, because the inflated rep_max_zones no
longer bounds anything. A local CAP_SYS_RAWIO attacker who loads
scsi_debug in zoned mode (zbc=host-managed) and sends a REPORT ZONES
CDB with e.g. alloc_len=32 via SG_IO triggers a heap
slab-out-of-bounds write, confirmed under KASAN
("slab-out-of-bounds in resp_report_zones", writes landing at
arr+64, arr+128, ... i.e. exactly the desc[0]/desc[1]/
put_unaligned_be64(desc+8/16/24) sequence, stepping by 64 bytes per
iteration).

Every other REPORT-style/allocation-length-consuming handler in this
file floors alloc_len against its own header/descriptor size before
using it, e.g.:

  resp_report_tgtpgs():        if (alloc_len < 4 || alloc_len > 0xffff) ...
  resp_readcap16():            if (alloc_len < 24) return 0;
  resp_get_stream_status():    if (alloc_len < 8) { ... }
  resp_report_luns():          if (alloc_len < 4) { ... }

resp_report_zones() is missing the equivalent floor. Since the report
header itself is RZONES_DESC_HD (64) bytes, alloc_len must be at
least that before rep_max_zones is computed and before desc is walked
past the header. Add that check, rejecting an under-sized allocation
length the same way resp_get_stream_status() rejects an under-sized
one for the identical cmd[10..13] field (SDEB_IN_CDB, field offset
10) via mk_sense_invalid_fld() + check_condition_result. alloc_len==0
keeps its existing "not an error, nothing to report" fast path.

This bounds both the underflowing subtraction and the kzalloc() size
against the 64-byte header the function unconditionally writes,
without touching the per-zone descriptor loop itself.

Verified on a v6.19 KASAN build: issuing REPORT ZONES(16) via SG_IO
with alloc_len=32 against a scsi_debug zbc=host-managed device hits
the slab-out-of-bounds write in resp_report_zones() before this
patch, and the same command no longer triggers a KASAN report once
the floor check above is applied.

Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..2fa887c65b61 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5911,6 +5911,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
+	if (alloc_len < RZONES_DESC_HD) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
+		return check_condition_result;
+	}
+
 	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
 
 	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
-- 
2.50.1 (Apple Git-155)


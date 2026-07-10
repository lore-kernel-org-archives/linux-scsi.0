Received: from sender-op-o19.zoho.eu (sender-op-o19.zoho.eu [136.143.169.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2738A3988E2;
	Fri, 10 Jul 2026 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783663120; cv=pass; b=FfKgr0AVO/+pqUdcLvNKYivWHbZBwU1/baz/7K8nG81Lh/Xh8QmUipkRavTfs6gBVjQ1D/Gx6y128HeTKdJglhPKw26BcJgQzXhNXm1OolH3CxKtnmgKwsWoySZbNvgZFqnh98bMLM+KgwIDY4K6E4IcjDF3Sw+f5ktlS9/dnyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783663120; c=relaxed/simple;
	bh=KzuWyfg4UPR2voA0XeurZPkyLTxq8gx74y+5OrxnD2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do6QI+hWx9STgBDXPA4z0adNrn47r7QP8YeewAac+KYtDdqPMBB5iH/edLB5S1IT9t7CGVPRvDHyKImCk/YeIHGRODEzDTA0dDXRZ8fFe/wjazwC9WV12SFtLoVE51B5uT9vjv4XAVDDJlfeBWi57ubI4NqpiKBxFf6rRXk9sl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=tMlak7R2; arc=pass smtp.client-ip=136.143.169.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="tMlak7R2"
ARC-Seal: i=1; a=rsa-sha256; t=1783663098; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=XRp3AB6pSsucizXYrcpP4A7QrUu5pZGBYGPiqQtBD3PK0hdReyVZlX1s78if8ioItSpuFW7N0A03eEZcqNPSnIkC3cBV0eLoQFz2Zp5JuWKJmnxX+jMON9KxwfSJ16bBLWKojXNJJI/7W7a+jT8vXh1IGXtmnvb5oXk4p/EKWPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783663098; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Jw7NNGzmu6cNvHW2t60/yQ1V2O6qaEt5DX69vlQC+DU=; 
	b=Y6PTp/v2rlD+HBv0Uf7PIuFzNDR0C5q1Ezdou56H6y6ZS4eFQDw0W+KDICjZed6EFJAlK/s0ujx7lEyDS4EibP7BKcCDjcYQqr3CWVLAyZbx4xF02I3rOg/SNmwRYW7UWgMKsCighzuZjJIgz5o/GSvGSmsCxDnNv8AZgp24Ld0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783663098;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Jw7NNGzmu6cNvHW2t60/yQ1V2O6qaEt5DX69vlQC+DU=;
	b=tMlak7R2ODQiRmvHKRYc2UHql8xVSan3PmDnrQbzIObbYYTDvnVPpEabm5IpYtVA
	9fHE6AvXL7U/3X7SkwKsJCXh5qcJ36sz3MWB9ZlcJHCTktx5RkWR4QLMLEhm+0uNhPk
	uKYutT3Y/48kOYFeOy3TrKgw4VmFRj+trexv305A=
Received: by mx.zoho.eu with SMTPS id 1783663094984324.05441366467164;
	Fri, 10 Jul 2026 07:58:14 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	dlemoal@kernel.org
Cc: shinichiro.kawasaki@wdc.com,
	damien.lemoal@opensource.wdc.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow OOB write
Date: Fri, 10 Jul 2026 07:57:55 +0200
Message-ID: <20260710055755.53830-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <1357dbf9-e135-4ba3-896d-1472a208f82f@kernel.org>
References: <1357dbf9-e135-4ba3-896d-1472a208f82f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

resp_report_zones() derives the number of zone descriptors that fit in
the reply buffer from the command allocation length:

	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);

	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);

alloc_len is taken directly from the CDB and is fully controlled by the
initiator. When alloc_len is smaller than the 64-byte report header
(RZONES_DESC_HD), the subtraction underflows and rep_max_zones becomes a
huge value. The buffer is then allocated with only alloc_len bytes, which
is smaller than the 64-byte header the code unconditionally writes, and
the descriptor loop is bounded by the bogus rep_max_zones. Both the header
store and the following zone descriptors are then written past the end of
the undersized allocation, corrupting adjacent slab memory.

Fix it by sizing the buffer to a whole number of 64-byte blocks that
cover the requested allocation length:

	rep_max_zones =
		(ALIGN((u64)alloc_len, RZONES_DESC_HD) - RZONES_DESC_HD)
		>> ilog2(RZONES_DESC_HD);
	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);

	arr = kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);

RZONES_DESC_HD is a power of two, so ALIGN() rounds alloc_len up to the
next multiple of 64 and rep_max_zones can no longer underflow: for any
alloc_len of 1 to 64 it is 0, so only the header is built. arr_len is
always RZONES_DESC_HD * (rep_max_zones + 1), which is exactly large enough
for the header plus every descriptor the loop may write, so the report is
always assembled within bounds, including a possibly partial trailing
zone descriptor. The existing copy-out still transfers only what the host
asked for:

	fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));

so an allocation length that ends in the middle of a zone descriptor
returns the correctly truncated partial descriptor, as permitted by the
SCSI/ZBC specifications, while never reading past arr_len.

The aligned length and the buffer size are computed in 64-bit (alloc_len
is cast to u64 before ALIGN and the size product uses a u64 block size) so
a crafted allocation length near U32_MAX cannot wrap them to a small value;
such a request simply fails the large allocation and returns a check
condition instead of overflowing the buffer.

This was found by static analysis. A KASAN slab-out-of-bounds runtime
reproduction of the original underflow is being re-run against the ALIGN
based fix and will be reported separately.

Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
v3: adopt Damien Le Moal's ALIGN-based buffer sizing (Suggested-by) so a
partial trailing zone descriptor is filled and returned per the SCSI/ZBC
specs; v2 emitted only the report header for allocation lengths of 65..127
bytes. The buffer is sized to a whole number of 64-byte blocks covering
alloc_len; the existing min(alloc_len, rep_len) copy-out still truncates the
transfer to the requested length.
Computed in 64-bit to avoid a u32 wrap of the aligned length/size for
allocation lengths near U32_MAX (which would otherwise reintroduce the
overflow).
v2: https://lore.kernel.org/linux-scsi/20260709194824.50777-1-security@auditcode.ai/
 drivers/scsi/scsi_debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..12e5a8624511 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5890,6 +5890,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	u32 alloc_len, rep_opts, rep_len;
 	bool partial;
 	u64 lba, zs_lba;
+	u64 arr_len;
 	u8 *arr = NULL, *desc;
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp = NULL;
@@ -5911,9 +5912,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
+	rep_max_zones = (ALIGN((u64)alloc_len, RZONES_DESC_HD) - RZONES_DESC_HD) >>
+			ilog2(RZONES_DESC_HD);
+	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
+	arr = kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.50.1 (Apple Git-155)


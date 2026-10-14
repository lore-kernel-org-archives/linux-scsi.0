Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4487127FD43
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 02:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791944376; cv=none; b=F+ffpX04GudunuHU1ZTUJn9IL5Djx3iZWBQIf1plAios+FcAu1Y7jL3SNqaEC8ZGWXD/Ee0OUIenF3WJtmsI1a6bBzQSfeX3RCQ0G8CfO4K3OvF5paasNcEMI5qw+oU5BbZ3m7nITzO2/xksQnqJHi3u6l8d3kfU+qg+NobjWis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791944376; c=relaxed/simple;
	bh=pE0hNVeCheMf6mjewOOf2r8fDlXDp/jOCwfj5MLCP6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z5gqHVK2SUD9nXLBW4hsRwLztCXUatM5QYLS6TRvuTaK5aXdDKbIusKERV68Q3ZCqkiQFjq/yjl/N+PK0yaxuhp8uafXYF8mjj11Jo7oEa73Ti5eCzbrLSKC5QvcUHM7t43CJXz96dThZa46ZRDgLy257xFmZyyA+XlCPlhtS14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=I3mHTTf8; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="I3mHTTf8"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd61a2dfd7aso127951a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 19:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791944372; x=1792549172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q12rhay6Z+E6s3DqDKvyK3mBEkuoBId4jjHQRHFqAps=;
        b=I3mHTTf8TUjoQinK6MVJyfQh6iqGKBsbtw6Si/t6qypMv4Y8gYlOJVGUbQ7b6mAv0M
         Zuyb3kyLIovzmwBm61xDSniWmJO89925aT6lJ3LpFmsEfuXRVvHrNOz+p9jY+RUR7FSi
         dDGMtpIHG76F6jmll9gVJz/hAJ4cNNQDNP1QrTNTdbTZ5irCgrm3vy6DWSNkXSHdQ8dY
         DXEmJgFpIt+sMHuxOwvHLkFMSDoSMc34LC5TdttboeYbEmLGt7HBfHS1Mo08kq34gqV0
         kt5QELcHwHYrmOq++IAO9rSFGEhdl2YF7lTn4EFV6iPKbOpdwSslYIWBf8w1PqjVoUPM
         b9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791944372; x=1792549172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q12rhay6Z+E6s3DqDKvyK3mBEkuoBId4jjHQRHFqAps=;
        b=bHIiC/8dtdiosT064vmq6Ds22xwNhCQButhsgv832CpeAcNfdd2Pj9HXX6LJo8QZGv
         BvPT+NEEhaCRdQtObYXDx1jykc+mr4mgGZfvQABhxkSTMS6z3uWSd4Ubh+NoRaAnX2ga
         nqvcSIms9JO35wQx1qD46PnZN9Dav4gutd8PJ6J9dZGkWnRFeLqgN6zy1l1sRHC+Nwmj
         +0+h3FxfwcdiqhumKEx+h3KpXEqz6FRiTQ5gpD+WsE3lLYqo0WGP0vQnUzkgeEeh4oZp
         0xSGtivnJ27pkMd3cVxoKLzILF+3kr0uHMmW3VvLmrOGB/eNb1gGgQ7raUHe2EwqgnDn
         YSbQ==
X-Gm-Message-State: AFq9FYJuAjxMOonWXia9pAsm3k1ZE3MbsIvdKbAxGg5UKE2QIsHsqE+g
	yPFducoTmLMpqNtqAMdyRr7tF3LbcEWw5gBUcmsD763/C6HkhhstltBnmM3EZcqlFZw=
X-Gm-Gg: AYBFou3x/cnHjH1qhPxp92c/fq1oqhR06v6ZalKlGCAmy2TI2qMlrcZJQa4sTlm7vW0
	geseu21syzQQ0MaUxaIcbbi1f5358B5BZCY3XC7EXPZ6bpM6lTbnuTgoW8FSOlxwQbqArToHWn6
	MIopXJz1ndbhnF+S5lTftP/bfoQMwBqBfvB8NQm0vIrWpPeXzG7o4xQ8HFaIAVcbXQTazZ1fdGV
	8YxhJbJfpq9rw2CRdhmeHyyFeMNKaXeKuosxY0mLv1K58yV4ad12IfBFq+WTFu/iJqJTiNqOqcq
	CHHMz6nmgIobDzVGDGJLNdg5PHE95ASo6RjKhQxj816Eqwlk64Dx4ARzazgfdGqr6LFuV4jH9gV
	0X96N35W4sY+W+2mISBI3yBfoQhrcfea02otYW7W6LiQtdc/bTWLvVIH+rFYE77cbP35TUKd0ta
	2v700SPnMd/kUWJkcbsYDN86KRV1bKJ42fuKe18mr6d1ZXOHeuMpGZHe7oPIlK9wyhNVMlVl6Ke
	qt5w9YEkuXzmMaSqnYX
X-Received: by 2002:a17:90b:384b:b0:3a0:c276:1ec0 with SMTP id 98e67ed59e1d1-3ab3a9536cfmr11211653a91.28.1791944372055;
        Tue, 13 Oct 2026 19:19:32 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac61171feesm1975565a91.17.2026.10.13.19.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 19:19:31 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Wed, 14 Oct 2026 11:19:19 +0900
Message-ID: <20261014021919.3486362-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_hs_process_page() takes max_io, the two command entry sizes and the
list depth from the firmware handshake page.  The entry sizes are u8 fields
used as shift counts, and 1 is an int, so a count of 29 or more makes the
<< 2 applied to the shift overflow an int; a count of 32 or more is
undefined outright.  max_io is a u16, and the sizes derived from the shifts
are multiplied by it in mvumi_init_data() to size three unsigned int
allocations, so a large entry size wraps the product and the loops that
follow then walk and write past the short allocation.  The list depth is
used as a shift count too, but only when the firmware sets
HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF; a count of 32 or more is undefined
there as well.  The depth also sets how many entries the inbound and
outbound rings hold, and the per-command slot index wraps on that count
while the rings are allocated for max_io entries, so a depth yielding more
entries than max_io -- or none -- walks the index past them.  A host reset
runs the handshake again, but mvumi_init_data() returns early once
MVUMI_FW_ALLOC is set, so the buffers keep the sizes they were allocated
with while the newly reported values drive the indexing.

Reject an entry size above 29, which keeps 1U << n and the shift that
follows it inside an unsigned int.  Then compute the worst-case allocation
size in u64 at the top of mvumi_init_data() and reject it if it does not
fit an unsigned int.  That total bounds all three allocations: the inbound
list total, the outbound data pool and the tag arrays, whose sizes are the
same products plus smaller terms.  Reject a list depth of 32 or more on the
shifted path so the shift stays defined, and reject a resulting entry count
that is zero or above max_io so the slot index cannot walk past the rings.
The shifts also use 1U now so that a legal count cannot overflow an int.
Once MVUMI_FW_ALLOC is set, reject a handshake that reports a size larger
than the one its buffer was allocated for.

No realistic controller is rejected: a controller reporting 4096 commands
with 64 KiB entries and a depth of 12 needs 513 MiB and passes unchanged.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v3:
- reject a reset handshake whose sizes exceed the existing allocation,
  which is not reallocated on reset (Sashiko).
v2:
- compute the allocation total in u64 so the check also holds on 32-bit
  (Sashiko).
- reject a handshake list depth whose entry count exceeds max_io, which
  would walk the per-command ring past its allocation (Sashiko).
 drivers/scsi/mvumi.c | 62 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab39..72a1516a804bb 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -912,10 +912,23 @@ static int mvumi_init_data(struct mvumi_hba *mhba)
 	unsigned int tmp_size, offset, i;
 	void *virmem, *v;
 	dma_addr_t p;
+	u64 total;
 
 	if (mhba->fw_flag & MVUMI_FW_ALLOC)
 		return 0;
 
+	/* These are firmware-supplied and size the allocations below. */
+	total = (u64)mhba->ib_max_size * mhba->max_io +
+		(u64)mhba->ob_max_size * mhba->max_io +
+		sizeof(struct mvumi_dyn_list_entry) * (u64)mhba->max_io +
+		160;
+	if (total > UINT_MAX) {
+		dev_err(&mhba->pdev->dev,
+			"handshake sizes too large: io %u, in %u, out %u\n",
+			mhba->max_io, mhba->ib_max_size, mhba->ob_max_size);
+		return -1;
+	}
+
 	tmp_size = mhba->ib_max_size * mhba->max_io;
 	if (mhba->hba_capability & HS_CAPABILITY_SUPPORT_DYN_SRC)
 		tmp_size += sizeof(struct mvumi_dyn_list_entry) * mhba->max_io;
@@ -1048,19 +1061,32 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 	}
 
 	switch (hs_header->page_code) {
-	case HS_PAGE_FIRM_CAP:
+	case HS_PAGE_FIRM_CAP: {
+		unsigned int old_max_io = mhba->max_io;
+		unsigned int old_ib = mhba->ib_max_size;
+		unsigned int old_ob = mhba->ob_max_size;
+		unsigned int old_list = mhba->list_num_io;
+
 		hs_page1 = (struct mvumi_hs_page1 *) hs_header;
 
+		/* Firmware-supplied shift counts: (1U << n) << 2 must fit. */
+		if (hs_page1->cl_in_max_entry_size > 29 ||
+		    hs_page1->cl_out_max_entry_size > 29) {
+			dev_err(&mhba->pdev->dev,
+				"invalid handshake entry size\n");
+			return -1;
+		}
+
 		mhba->max_io = hs_page1->max_io_support;
 		mhba->list_num_io = hs_page1->cl_inout_list_depth;
 		mhba->max_transfer_size = hs_page1->max_transfer_size;
 		mhba->max_target_id = hs_page1->max_devices_support;
 		mhba->hba_capability = hs_page1->capability;
 		mhba->ib_max_size_setting = hs_page1->cl_in_max_entry_size;
-		mhba->ib_max_size = (1 << hs_page1->cl_in_max_entry_size) << 2;
+		mhba->ib_max_size = (1U << hs_page1->cl_in_max_entry_size) << 2;
 
 		mhba->ob_max_size_setting = hs_page1->cl_out_max_entry_size;
-		mhba->ob_max_size = (1 << hs_page1->cl_out_max_entry_size) << 2;
+		mhba->ob_max_size = (1U << hs_page1->cl_out_max_entry_size) << 2;
 
 		dev_dbg(&mhba->pdev->dev, "FW version:%d\n",
 						hs_page1->fw_ver.ver_build);
@@ -1069,9 +1095,35 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 			mhba->eot_flag = 22;
 		else
 			mhba->eot_flag = 27;
-		if (mhba->hba_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF)
-			mhba->list_num_io = 1 << hs_page1->cl_inout_list_depth;
+		if (mhba->hba_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF) {
+			if (hs_page1->cl_inout_list_depth >= 32) {
+				dev_err(&mhba->pdev->dev,
+					"invalid handshake list depth\n");
+				return -1;
+			}
+			mhba->list_num_io = 1U << hs_page1->cl_inout_list_depth;
+		}
+		/* The rings hold max_io entries but the index wraps on list_num_io. */
+		if (mhba->list_num_io == 0 ||
+		    mhba->list_num_io > mhba->max_io) {
+			dev_err(&mhba->pdev->dev,
+				"invalid handshake list depth: %u entries for %u commands\n",
+				mhba->list_num_io, mhba->max_io);
+			return -1;
+		}
+		/* On reset the buffers are not reallocated; reject sizes that
+		 * outgrow them.
+		 */
+		if ((mhba->fw_flag & MVUMI_FW_ALLOC) &&
+		    (mhba->max_io > old_max_io || mhba->ib_max_size > old_ib ||
+		     mhba->ob_max_size > old_ob ||
+		     mhba->list_num_io > old_list)) {
+			dev_err(&mhba->pdev->dev,
+				"handshake sizes grew across reset\n");
+			return -1;
+		}
 		break;
+	}
 	default:
 		dev_err(&mhba->pdev->dev, "handshake: page code error\n");
 		return -1;

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0


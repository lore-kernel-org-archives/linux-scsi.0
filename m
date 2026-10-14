Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6700F2931C4
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985284; cv=none; b=B66RgkSY6C/NIIqikV2XQMhJIVD5QG8hw+0Xp8jzLSiLHSa6KQwa/OEr/Q/9qQ791JELIk1TNrjWXtLsA7VXDkPODRZPujAx/JGEw3PzGGJsxhXn1DqMvGRS7EzBI5sG3xSRNpwsd30gJpOE0FD5PXlpONncvMuDC2utzIXAVo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985284; c=relaxed/simple;
	bh=I3g5eh8yikhMU1X7LWPg0jgB07gV60z9xSPYrA25Hn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Axlihcbd8tMI3mQYhblFw3v6S5DLXQOVfIPC0GFrbXyOkvRVs00KW0jHyjtcCxcOhPgIrCkGr6JqqQL46EmTi6GkaH8Lk36nG7LtBPri718i737bK6h95I5djDxpclFnwGd15npIdRj3hbtwXRMeMfqtrnKMnM7TQeHXHjuzapw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=rJDTm/m1; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="rJDTm/m1"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so1912993a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 06:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791985281; x=1792590081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LYBOQP1TdKSQDWr6VBNXaizNTJy6YFMyo0MXiGEf2A0=;
        b=rJDTm/m1AzjGVuWl992L3FBzSH2qEUtgI0EZC1XoEM+6ZfZWFy//5adWFUS56ELT2s
         j13mLRqkaYLRKCV/7yrmBF0Z0D3iqw3kD3fpXMbx4ix5Z8+XyUeceTU450yB+h/vsKk/
         jUezAEZtzVEYdXa/TsACUrpxB2yw0yb/+S3wLM6RmOolxTjy8eNAse4Ikemtxjf9TTJo
         RSINJd66CK86EtGh9hQ0kjH8i4sRVtZKt6+Ai5VD39Ymo7Lp6KiCi9pl5LuxOMQowxke
         9eVNFujd+CVEUYLUkbOc6k6tUfdRMBlirq6+aeJlLLz/WIbIUxMleOuJWuAYl6PodlWC
         PzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791985281; x=1792590081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LYBOQP1TdKSQDWr6VBNXaizNTJy6YFMyo0MXiGEf2A0=;
        b=1I0Z2SKCrla1ZznR3NznLmLE9f68tOJfrP6ZEjE4gzuv8sfQ3AOoKidLVJLM5i7jlj
         Vlq8MCAgrMI6n9g920BZs3dT9p/A2MKPjsA/lfKgQI0uDULcs11Zcs14j4B86PMt2Swg
         gR5Vc+hoVsjQk6F2ALh5mD+hoeijfpM6oKeD55RjEztemNBKrto7m50tz+vS0GXL1vgj
         zRX7iMe+KUxQpKVSa+6xOpHR3SEcaimTKt5i+ZXPp/vgLH0cJDkpkvKEzDrGS2WknbWm
         W9vtMuvQM7jnpgqKk7XLQhpa8EsyPWA1Ailb9FUy8gaiEUya8oXzxzYJ/bIF1igXltMv
         va0Q==
X-Gm-Message-State: AFq9FYLJrItOrlyzZanl7mcmITDn0/4sdTztbSJ1YCkwpOCsDTEiiQhW
	TOFN8KFhFt7LU8UdoCURcOvgNe5LtWVpaBI2P+5MsMEpQymWq03DiFh1fn3d8QdAchLZ2uapvvi
	TsPUb
X-Gm-Gg: AYBFou11ve3jDf5+OKdpNDjk6loKLoerP6eAbBdkJL4fj9GlvRMVoRRq6nEBN2ohBS8
	T7txmMgSfZ4yumJGLWBGEtYCmFOVr1333jSexjeGrs0fGMcPPly2ouYdhfqHpwMvIrD25ZW7q23
	0SRHih53h6Pte6v4ZO+774yEeJGTc7bQ/6q4G4CpbfrmT4ukYbpwiPa9RgSdsAUBrEzb3zlCx6Q
	F4fRBOKAvt59jqT5QxKg+R6wyHBqLS8W7DRKTKWgS23aEMT0CYQ/XYZ1hWtQnTKklKxIbNX+yEi
	tjN2s1Iwete56gbKr0otIvxP3JJMNkTOLROx6O9udeJxCkP2GfdApc6LKaltSGSocoWGclm4EDA
	Z7KanrdKLKwqp6sR0J7DyPglPQXFLwNZ+XTpxt+ljaA8y9LHfSQT0HZmz8zh2QfF46iOV885OZD
	9av6B9koEd4H20KQK+QrohEDDBmePFCoDX2RZumzR3FpNNsU8C6Tdas3JqIWxlTvutNNGjzpr7R
	EWHO4xygGURTgEwl1sZ
X-Received: by 2002:a17:90b:5444:b0:3a4:b74a:795c with SMTP id 98e67ed59e1d1-3ab3a60cec9mr12995839a91.16.1791985281374;
        Wed, 14 Oct 2026 06:41:21 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f27d573sm4952571a91.11.2026.10.14.06.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:41:21 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Wed, 14 Oct 2026 22:41:04 +0900
Message-ID: <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr>
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
entries than max_io -- or none -- walks the index past them.
max_devices_support sizes the target_map bitmap in the same allocation.  A
host reset runs the handshake again, but mvumi_init_data() returns early
once MVUMI_FW_ALLOC is set, so the buffers keep the sizes they were
allocated with while the newly reported values drive the indexing:
mvumi_flush_cache() then reads target_map past its end and
mvumi_sdev_configure() sets a bit past it.  The handshake is retried as
well, because mvumi_handshake_event() discards the error, so a page that
was already rejected can be presented again.

Reject an entry size above 29, which keeps 1U << n and the shift that
follows it inside an unsigned int.  Then compute the worst-case allocation
size in u64 at the top of mvumi_init_data() and reject it if it does not
fit an unsigned int.  That total bounds all three allocations: the inbound
list total, the outbound data pool and the tag arrays, whose sizes are the
same products plus smaller terms.  Reject a list depth of 32 or more on the
shifted path so the shift stays defined, and reject a resulting entry count
that is zero or above max_io so the slot index cannot walk past the rings.
The shifts also use 1U now so that a legal count cannot overflow an int.
Take the page's values into locals and run every check on those.  Once
MVUMI_FW_ALLOC is set the buffers already exist, so only check that no
reported size, max_devices_support included, is larger than the one its
buffer was allocated for, and leave the size fields alone: they already
hold the sizes those buffers have.  Only the first handshake, whose values
size the allocations, assigns them.

No realistic controller is rejected: a controller reporting 4096 commands
with 64 KiB entries and a depth of 12 needs 513 MiB and passes unchanged.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v4:
- a reset does not reallocate, so validate the reported sizes against the
  current ones and leave the size fields unchanged; only the first handshake
  assigns them.  This also means a page the driver has already rejected
  cannot be presented again to get past the check, which the retry in
  mvumi_handshake_event() allows (Sashiko).
- include max_devices_support in that check; it sizes target_map, which
  mvumi_flush_cache() reads and mvumi_sdev_configure() writes (Sashiko).

v3:
- reject a reset handshake whose sizes exceed the existing allocation,
  which is not reallocated on reset (Sashiko).

v2:
- compute the allocation total in u64 so the check also holds on 32-bit
  (Sashiko).
- reject a handshake list depth whose entry count exceeds max_io, which
  would walk the per-command ring past its allocation (Sashiko).

 drivers/scsi/mvumi.c | 87 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 75 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab39..4fc0cf819c271 100644
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
@@ -1048,30 +1061,80 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 	}
 
 	switch (hs_header->page_code) {
-	case HS_PAGE_FIRM_CAP:
+	case HS_PAGE_FIRM_CAP: {
+		unsigned int new_max_io, new_ib_max_size, new_ob_max_size;
+		unsigned int new_list_num_io;
+		unsigned short new_max_target_id, new_capability;
+
 		hs_page1 = (struct mvumi_hs_page1 *) hs_header;
 
-		mhba->max_io = hs_page1->max_io_support;
-		mhba->list_num_io = hs_page1->cl_inout_list_depth;
-		mhba->max_transfer_size = hs_page1->max_transfer_size;
-		mhba->max_target_id = hs_page1->max_devices_support;
-		mhba->hba_capability = hs_page1->capability;
-		mhba->ib_max_size_setting = hs_page1->cl_in_max_entry_size;
-		mhba->ib_max_size = (1 << hs_page1->cl_in_max_entry_size) << 2;
+		/* Firmware-supplied shift counts: (1U << n) << 2 must fit. */
+		if (hs_page1->cl_in_max_entry_size > 29 ||
+		    hs_page1->cl_out_max_entry_size > 29) {
+			dev_err(&mhba->pdev->dev,
+				"invalid handshake entry size\n");
+			return -1;
+		}
 
-		mhba->ob_max_size_setting = hs_page1->cl_out_max_entry_size;
-		mhba->ob_max_size = (1 << hs_page1->cl_out_max_entry_size) << 2;
+		new_max_io = hs_page1->max_io_support;
+		new_ib_max_size = (1U << hs_page1->cl_in_max_entry_size) << 2;
+		new_ob_max_size = (1U << hs_page1->cl_out_max_entry_size) << 2;
+		new_max_target_id = hs_page1->max_devices_support;
+		new_capability = hs_page1->capability;
+
+		new_list_num_io = hs_page1->cl_inout_list_depth;
+		if (new_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF) {
+			if (hs_page1->cl_inout_list_depth >= 32) {
+				dev_err(&mhba->pdev->dev,
+					"invalid handshake list depth\n");
+				return -1;
+			}
+			new_list_num_io = 1U << hs_page1->cl_inout_list_depth;
+		}
+		/* The rings hold max_io entries but the index wraps on list_num_io. */
+		if (new_list_num_io == 0 || new_list_num_io > new_max_io) {
+			dev_err(&mhba->pdev->dev,
+				"invalid handshake list depth: %u entries for %u commands\n",
+				new_list_num_io, new_max_io);
+			return -1;
+		}
 
 		dev_dbg(&mhba->pdev->dev, "FW version:%d\n",
 						hs_page1->fw_ver.ver_build);
 
+		/* A host reset does not reallocate, so the sizes have to stay
+		 * the ones the buffers were allocated with.  Only check that
+		 * the firmware is not asking for more than they hold.
+		 */
+		if (mhba->fw_flag & MVUMI_FW_ALLOC) {
+			if (new_max_io > mhba->max_io ||
+			    new_ib_max_size > mhba->ib_max_size ||
+			    new_ob_max_size > mhba->ob_max_size ||
+			    new_list_num_io > mhba->list_num_io ||
+			    new_max_target_id > mhba->max_target_id) {
+				dev_err(&mhba->pdev->dev,
+					"handshake sizes grew across reset\n");
+				return -1;
+			}
+			break;
+		}
+
+		mhba->max_io = new_max_io;
+		mhba->list_num_io = new_list_num_io;
+		mhba->max_transfer_size = hs_page1->max_transfer_size;
+		mhba->max_target_id = new_max_target_id;
+		mhba->hba_capability = new_capability;
+		mhba->ib_max_size_setting = hs_page1->cl_in_max_entry_size;
+		mhba->ib_max_size = new_ib_max_size;
+		mhba->ob_max_size_setting = hs_page1->cl_out_max_entry_size;
+		mhba->ob_max_size = new_ob_max_size;
+
 		if (mhba->hba_capability & HS_CAPABILITY_SUPPORT_COMPACT_SG)
 			mhba->eot_flag = 22;
 		else
 			mhba->eot_flag = 27;
-		if (mhba->hba_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF)
-			mhba->list_num_io = 1 << hs_page1->cl_inout_list_depth;
 		break;
+	}
 	default:
 		dev_err(&mhba->pdev->dev, "handshake: page code error\n");
 		return -1;

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0


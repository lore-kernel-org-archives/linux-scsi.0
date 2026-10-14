Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F2E5540AD
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991183; cv=none; b=Hj5shAXPbzU8AO4b51Bx5WqfR5jNSjziwzmXoEUabMJkix6LgqbkLn10FWdibvvAprTT472YWA5QcXT0hsrX63PhHPi3JkkCLhDlv6f8ETlLugq5UKU2NnFnUjHIUZxUrFnNkiTNwMuTIvk6wiDM0JoUEuG2W77K+NFjL38Iuqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991183; c=relaxed/simple;
	bh=jwGvzoFfqXWUagf738d8nUl29JjQa39oqVMZfC1i2x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu2Ip5sQlv0xjAXf7GqPscwdOpMMKkBaQSO2Jv9cX1mSzU8VdKOZLyk4DbgEl0yLVopG7r/g6XL9oIelwR5Cipn6LGALw39oQU2mMR+fJc2g3AW10RElbo+r8hAr1IZjh4AUF4L8AdiS681MfCiSHBj92wxYkmXKY87UaC6xZhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=BSQAbYUA; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="BSQAbYUA"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so2000173a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991181; x=1792595981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LY2anHxBHwpLr2j92jtUWuN9so9bossKkrbDgSAVTLY=;
        b=BSQAbYUAHdFFCt2xJx7zXLpawgcyuCx+7+YkqnTKJDz4R4w66IikB8PSuixy9iePKW
         NL1Q1BU5fFtUhealx0VISwgw6GPBxQP4HU5Fni4cqwZ2OVo/oZUzFpRjprRIVlc0xLrt
         Ois8LrbIe5C3ItBw6laD1JIxAFcKULGTJzFlGzAKIT/X+iltgF6w4MagPm3gVbvbLM83
         LIlNNcFbhwMholAXLnpTKVzPSLz4WqNyjRfsRHZZzAWTe3gcMVSSqgPe9/MRPb67P8Y+
         qwtzl24+Q6mv4UYLIDwwuaF9qfnxYjqjYtUv6Vg2CDAoxMoukmoJYGTsjqAA60cO5hKA
         pQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991181; x=1792595981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LY2anHxBHwpLr2j92jtUWuN9so9bossKkrbDgSAVTLY=;
        b=m8TFVEcZOaeYPMmYo4ndkU8C+vkQInNaAJO/HEUmrtqRYGTLlkRQ726SsQ/XnlfX1T
         ++0ynB26sfzQBb0GKj7io690HPSDIYZB8OXEjQYcHVYV6/WokfDhpk1e9L7G9Gc0MQdV
         Zcj/ZORvW5G9UA0O9NxSzpiq07XSX3DgbCKJ58G8AQeYcVb455ZCDimw86+Cf82f1MOQ
         6ifzLjoizK0L/Qgf89CfAtGHLfDZSrvJo4uSeA0rYi2SnIpmsKx5DqL49ZuIlFwl+7uw
         sSwpEA19+5HiN9CMWgA43JUef7z8o7YSgwag8LKIMW94ow15jIPxtUOZIRUzmzbywlfi
         BtTA==
X-Gm-Message-State: AFq9FYLc5CBJCocQQEmqUe16rCx2QRdgOC1d2UmJXpYnKz/me07Mx6oD
	yT+1f3ftTk+ZthHMEFv9Y+tG+vfZkOBedqTphzZF2D7CwMoD5Pz6+RAoc4QI3XE93ZwFRx7W71A
	Csyrg
X-Gm-Gg: AYBFou3Lmn8NiLx32bjFhCnjeHUDGe93pkoqyJvMSHC0EJAaXXbjyzyjGCGNw3A4UV3
	5+6SySD+JIvSVHRUTPO8gdLhkIgZUxNp2cbwFKTbIgqydIRShoN6CkgToducqM55OQVEkfUy0GM
	huyvEe25U7jLw4AVzHZwal/d74ZUwRdrRRPtg3tYQriomL2RaWGOblDru7Og8BsL/icFqMx1j07
	dTqjFIckVZSMPQ0eTRa8DcVmTQUbCy0Dwg2x5L7bYr2gyzyRpTCQXbllwoY4uKAzfHG4xqoumWA
	3ObBQ434JQ0DIGjTp6Vfky68Tl43VS0cY97MDowp4nv7F3wPbfHhPFC7xEOIagtd7zJ8Xgfb/Iq
	TuvZ0VknHCgNCiyNR6Tlsy7A9ZC/RpJ94KxrAPVHkWgSFdYTdL861S7ziRA8lgZeKDtw/JJXAr9
	7ixLYozT0iEfATvWLv9Kan8m7Ni+f+6A9lKa7y1EGxwjUyr5yWbyDvcU+KcCOnzfiP8CgRJqJil
	kPlGwBcd1GLLyd7tqASDg==
X-Received: by 2002:a17:90b:1e4a:b0:3a7:933a:3195 with SMTP id 98e67ed59e1d1-3ab3a236a1bmr14325526a91.7.1791991181016;
        Wed, 14 Oct 2026 08:19:41 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac8d40e7f3sm622450a91.5.2026.10.14.08.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:19:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 4/6] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Thu, 15 Oct 2026 00:19:12 +0900
Message-ID: <20261014151914.3632701-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
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
there as well.  Nothing bounds the entry sizes from below either, and an
entry has to hold what the driver puts in it: a command frame and at least
one scatter-gather element going in, a response frame and sense data coming
back.  An entry size of 32 bytes or less makes mvumi_internal_cmd_sgl()
write its element past an inbound entry, since it writes one whatever
host->sg_tablesize says, and makes mvumi_complete_cmd() read sense data
past an outbound one; it also makes the max_sg subtraction in
mvumi_io_attach() wrap, which hands mvumi_build_frame() and
mvumi_send_command() a table size no entry can hold.  The depth also sets
how many entries the inbound and outbound rings hold, and the per-command
slot index wraps on that count while the rings are allocated for max_io
entries, so a depth yielding more entries than max_io -- or none -- walks
the index past them.  max_devices_support sizes the target_map bitmap in
the same allocation.  A host reset runs the handshake again, but
mvumi_init_data() returns early once MVUMI_FW_ALLOC is set, so the buffers
keep the sizes they were allocated with while the newly reported values
drive the indexing: mvumi_flush_cache() then reads target_map past its end
and mvumi_sdev_configure() sets a bit past it.  The handshake is retried as
well, because mvumi_handshake_event() discards the error, so a page that
was already rejected can be presented again.

Reject an entry size above 29, which keeps 1U << n and the shift that
follows it inside an unsigned int, and reject one too small to hold those
frames.  Then compute the worst-case allocation size in u64 at the top of
mvumi_init_data() and reject it if it does not fit an unsigned int.  That
total bounds all three allocations: the inbound list total, the outbound
data pool and the tag arrays, whose sizes are the same products plus
smaller terms.  Reject a list depth of 32 or more on the shifted path so
the shift stays defined, and reject a resulting entry count that is zero or
above max_io so the slot index cannot walk past the rings.  The shifts also
use 1U now so that a legal count cannot overflow an int.  Take the page's
values into locals and run every check on those.  Once MVUMI_FW_ALLOC is
set the buffers already exist, so only check that no reported size,
max_devices_support included, is larger than the one its buffer was
allocated for, and leave the size fields alone: they already hold the sizes
those buffers have.  Only the first handshake, whose values size the
allocations, assigns them.

No realistic controller is rejected: a controller reporting 4096 commands
with 64 KiB entries and a depth of 12 needs 513 MiB and passes unchanged.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 87 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 75 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9e342db4b8383..e63b3ba7eaabd 100644
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
@@ -1054,30 +1067,80 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
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
-- 
2.43.0


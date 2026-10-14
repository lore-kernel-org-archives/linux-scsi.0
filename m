Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F34FDE50
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995080; cv=none; b=M6s++PqPnTF7w11+iXF8cJxVm4YgT7bWsCkXB9gdBpXwQx4U46SJd2dHueiJpbP+/fEWH5OLQZIdfkNpwknkSggsKRup3uIVs+VGj2JHEz8mQHqzYbtNI14GMU1U3yfLNxIgeyaS5OxtQoTpK43fHA2T9QIwiPf+OcFv2ljAGeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995080; c=relaxed/simple;
	bh=L4atwK/4B5HMdPz8fu3+qz/K35MFOyA22YXdVhdQYgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyYsuH7qVo+/Li6qA2NsYwMx41ZinIRiUhmGsmd9UE22aU/FeJ+px/YTmtYe7dynmzwGzR4zqHqyjmTVFkA+FfAMRq7bhclcSOL16H8X4Ktw9yZj9IsUoVNjbfIFVzfmK6XbUPri5kuCyYSgH4sOGZjPcQz8H8OJOj9VWgaS4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=dmLayGv4; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="dmLayGv4"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-16079d54c17so5606334c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 09:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791995077; x=1792599877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RD42K58SbW+8VGmiJudw2bFsQ/pU+IEnoR92c2KHeVs=;
        b=dmLayGv4M/XY21hBlTQ0iAYHTRfd04AsElM9hyHYS5TfuPFPdCv5H9Tj0c8S1cS6ve
         +mU/2jHR9/mbQ9t48SFAWSZ3lckd6jlZX69tWKCzu9xOaQuP9vKow5erlsDlUqFLLh21
         56DhWKyRGtgAEhbwBFEzynp76wnzbAwhUqsKOfaAwHEeuSwwNIA4ZtJBXW5bM6ZB++Tq
         gseuzARo5ONl5Fkgf6QIPqZJKQzGJa3LoaAit0UGIx46t/UexqMVn1KVm/bnxgzwpmta
         yPa75HSlwuk0WIcrOFrGi2NK062meZZoTctcpBDJeLP3Y8p9xwR7YuQjVUrpprsF4WXK
         SLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995077; x=1792599877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RD42K58SbW+8VGmiJudw2bFsQ/pU+IEnoR92c2KHeVs=;
        b=aeQFdv1cMtEGMWORqC5LcJsuX3k/SVM3oo2WnP4aEu4lmJ+Gdm14KCT1pqICYUegLq
         pdARrAGPW317zCR73O9zopPwMkUiK7T7y7xDEKw8oX4y5q4wfiuG8gptOwHqRG86CZaP
         N4mAifNXhPyKX3i732rtFoHgkhyuATHRfK587PPkbN14QpSEsItapm1sAnEG0TXbZEMZ
         AxIXYbAQr7K8GsXBD/ZfvB4ECxFb32HzVe4lW6lZyz8euDvomDp+CwDsFlNgTcl65sSp
         nMhI2jYao9UnQ2JBogbBmyyJgVsDt8ecD/GDW6KF0hM+F18PrL5D1i/dyf7ll6JomklI
         +yRg==
X-Gm-Message-State: AFq9FYKQqLryeHyMnhZwySyCH6u8MSHp3cIsKsFuT1lfQIOFsWyxiLJK
	zeK3DgQp7N0gaAOkAEDugawOaH+pakKOk3L5gCNDCJ+5FKVpz33I8Y1FNDfLiwZVPbU=
X-Gm-Gg: AYBFou2e4lFWTPcGMWd74vnJnrssb7PxoO1wRZzNTZXwEnwlL7ICcobhVILLQJUk2a6
	2JRwESXtAMNsjWorLQi1FsvsNzxTmYl/wPK9IoF30GRhHAMvyYGLn8BbBX4XcYbI6EflrZmLDlg
	4seR+FwDN76jHE0in3UT9enfIrInDIfvNoux6d8nW2d5uJax9dsN+G4mLGDVrZSRLnJAg5nlgo2
	1mEM8HJDdwn4O4Lhe1OHZ1vN5bvPQrPFOmy6KEOv2t5m2hiB33qMKupUpsl2h8iG/pkQMQ5VGQF
	ZqbMZcndNUW0qRQXcMX7FDUnWe1I2njDvRQul36l6oIoAUv5W9+sN7YvMQzfGXHEnwr/NT1HAgo
	pwe0Pj9QqiVTyI67CH325oTUv8fYvjaPhGKgRlH2gxf3y+f84TDIroh1FvkpyJwMbIJF9lS7UIG
	GzFRKRknjT5iTFPgKjTVkQV4uULdImk2cZrXSzw84v7oKN7CqASank6h5iY797lcpJ8aZV3aVGk
	2W32WyFbqqWKo1iNdb6
X-Received: by 2002:a05:701b:4544:10b0:144:c12b:4e35 with SMTP id a92af1059eb24-16a6090d49bmr21200263c88.42.1791995076902;
        Wed, 14 Oct 2026 09:24:36 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a1dd57d0sm48816685c88.8.2026.10.14.09.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:24:36 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v6 4/5] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Thu, 15 Oct 2026 01:24:12 +0900
Message-ID: <20261014162413.3649841-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
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
the same allocation, and it is a u16 while mvumi_build_frame() packs the
target id into the low byte of device_id and the LUN into the high byte, so
a target of 256 or more aliases another device's LUN; it is also what makes
the unsigned char loop counter in mvumi_flush_cache() wrap before it
reaches the bound, which never ends that loop.  A host reset runs the
handshake again, but mvumi_init_data() returns early once MVUMI_FW_ALLOC is
set, so the buffers keep the sizes they were allocated with while the newly
reported values drive the indexing: mvumi_flush_cache() then reads
target_map past its end and mvumi_sdev_configure() sets a bit past it.  The
handshake is retried as well, because mvumi_handshake_event() discards the
error, so a page that was already rejected can be presented again.

Reject an entry size above 29, which keeps 1U << n and the shift that
follows it inside an unsigned int, and reject one too small to hold those
frames.  Reject a device count the frame layout cannot address, which also
keeps mvumi_flush_cache() terminating.  Then compute the worst-case
allocation size in u64 at the top of mvumi_init_data() and reject it if it
does not fit an unsigned int.  That total bounds all three allocations: the
inbound list total, the outbound data pool and the tag arrays, whose sizes
are the same products plus smaller terms.  Reject a list depth of 32 or
more on the shifted path so the shift stays defined, and reject a resulting
entry count that is zero or above max_io so the slot index cannot walk past
the rings.  The shifts also use 1U now so that a legal count cannot
overflow an int.  Take the page's values into locals and run every check on
those, with READ_ONCE() for the three shift counts so the value that is
checked is the value that is shifted; a second fetch of the entry size
could turn a count of 29 into one of 31, and a second fetch of the list
depth could turn 31 into 32, which is the undefined shift the check exists
to stop.  Once MVUMI_FW_ALLOC is set the buffers already exist, so only
check that no reported size, max_devices_support included, is larger than
the one its buffer was allocated for, and leave the size fields alone: they
already hold the sizes those buffers have.  Only the first handshake, whose
values size the allocations, assigns them.

No realistic controller is rejected: one reporting 4096 commands with 64
KiB entries and a depth of 12 needs 512 MiB and passes unchanged.  The
device count is the one new bound that could turn a controller away, and a
controller reporting more than 255 devices is already one this driver
cannot address.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 115 ++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/mvumi.h |   6 +++
 2 files changed, 109 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9a3dde53dea97..2871b4c96f1c8 100644
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
@@ -1054,30 +1067,108 @@ static int mvumi_hs_process_page(struct mvumi_hba *mhba,
 	}
 
 	switch (hs_header->page_code) {
-	case HS_PAGE_FIRM_CAP:
+	case HS_PAGE_FIRM_CAP: {
+		unsigned int new_max_io, new_ib_max_size, new_ob_max_size;
+		unsigned int new_list_num_io;
+		unsigned short new_max_target_id, new_capability;
+		u8 in_sz, out_sz, list_depth;
+
 		hs_page1 = (struct mvumi_hs_page1 *) hs_header;
 
-		mhba->max_io = hs_page1->max_io_support;
-		mhba->list_num_io = hs_page1->cl_inout_list_depth;
-		mhba->max_transfer_size = hs_page1->max_transfer_size;
-		mhba->max_target_id = hs_page1->max_devices_support;
-		mhba->hba_capability = hs_page1->capability;
-		mhba->ib_max_size_setting = hs_page1->cl_in_max_entry_size;
-		mhba->ib_max_size = (1 << hs_page1->cl_in_max_entry_size) << 2;
+		in_sz = READ_ONCE(hs_page1->cl_in_max_entry_size);
+		out_sz = READ_ONCE(hs_page1->cl_out_max_entry_size);
+		list_depth = READ_ONCE(hs_page1->cl_inout_list_depth);
+
+		/* Firmware-supplied shift counts: (1U << n) << 2 must fit. */
+		if (in_sz > 29 || out_sz > 29) {
+			dev_err(&mhba->pdev->dev,
+				"invalid handshake entry size\n");
+			return -1;
+		}
+
+		new_max_io = hs_page1->max_io_support;
+		new_ib_max_size = (1U << in_sz) << 2;
+		new_ob_max_size = (1U << out_sz) << 2;
+		new_max_target_id = hs_page1->max_devices_support;
+		new_capability = hs_page1->capability;
+
+		/*
+		 * A target above MVUMI_MAX_TARGET_ID cannot be addressed: its
+		 * id would land in the LUN byte of device_id and alias another
+		 * device.  It is also what makes the loop counter in
+		 * mvumi_flush_cache() wrap before it reaches the bound.
+		 */
+		if (new_max_target_id > MVUMI_MAX_TARGET_ID) {
+			dev_err(&mhba->pdev->dev,
+				"too many devices reported: %u\n",
+				new_max_target_id);
+			return -1;
+		}
+
+		/* An entry has to hold the frame the driver puts in it. */
+		if (new_ib_max_size < sizeof(struct mvumi_msg_frame) +
+					sizeof(struct mvumi_sgl) ||
+		    new_ob_max_size < sizeof(struct mvumi_rsp_frame) +
+					sizeof(struct mvumi_sense_data)) {
+			dev_err(&mhba->pdev->dev,
+				"handshake entry size too small: in %u, out %u\n",
+				new_ib_max_size, new_ob_max_size);
+			return -1;
+		}
 
-		mhba->ob_max_size_setting = hs_page1->cl_out_max_entry_size;
-		mhba->ob_max_size = (1 << hs_page1->cl_out_max_entry_size) << 2;
+		new_list_num_io = list_depth;
+		if (new_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF) {
+			if (list_depth >= 32) {
+				dev_err(&mhba->pdev->dev,
+					"invalid handshake list depth\n");
+				return -1;
+			}
+			new_list_num_io = 1U << list_depth;
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
+		mhba->ib_max_size_setting = in_sz;
+		mhba->ib_max_size = new_ib_max_size;
+		mhba->ob_max_size_setting = out_sz;
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
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index 5d45f0d99e639..d20eea2b61a31 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -127,6 +127,12 @@ enum {
 /* size of the buffer the driver hands the firmware for event replies */
 #define MVUMI_EVENT_BUF_SIZE		512
 
+/*
+ * mvumi_build_frame() packs the target id into the low byte of device_id
+ * and the LUN into the high byte, so only these ids can be addressed.
+ */
+#define MVUMI_MAX_TARGET_ID		255
+
 #define DEVICE_OFFLINE	0
 #define DEVICE_ONLINE	1
 
-- 
2.43.0


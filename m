Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2923D88E0
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279280; cv=none; b=BwDf1htAsqY7DHlCJMgp47uUqjzuxoQ9/AreGUGS/ifWjPOk4PzIOoFhouc57Rsi7NmXLODQJL72bj4EG8MJonJYTileJOG1fmPrsJOP2AEooVJH2V3nK6EQ0y57zIQ+o+1oLryi+mTUzCIjYtIrpQAUCrNEshwjMAnuGOMeBVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279280; c=relaxed/simple;
	bh=okY7cIImX8qIYsFc9Y9Q3Pwsl1ijY3N0uQi/iyGQ8K4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bkz0ZQK+V2d3rZsvCf+8IdVk29suYuUjNAHcqMBLSr/GmtBi1gZC/5SGyNMLRGTX3zP01Z9VQb8TdYpuZDzC67f5NUPzbFQBoLXaQf/zyWLeZpG9bmAwjmevB/D2UxvOg4LR7eYl94nJbL5kMs1r1HaO/Lu6W7MgAJ+XPAXAsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cMY9vATI; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMY9vATI"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso679536a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279268; x=1791884068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4occJ8bcfYl1ztAcem1o8SmF8sKoGNbjtjkE+6WTes=;
        b=cMY9vATIbKCsCvSpcEGZFdVW+CtDVE8Qqij3hcHiT2iY+FxItunXPr9yKFPGMI7yGG
         8jMbtlfoFk1nVdnZ7NLzwdotw8cFG7IdCPrQcNSvHJpDU4zWCklhw6oGvzwr9OOBD2QL
         O0RH/89LXxiV3ZNXXSpQGIR6gToihQbyi1JRxHOOPlOUXylG/gBJjtG99jbIbGIYUliz
         hJdWU6LxsQObQ7FQvbSK9nZyPlacXn6NPNxMG+wbVgL8sTt1mhQsa2USFMRSPHFP9tk/
         gelTAwI06Sr7jNYWKZn1kpaR97P7YoGa4/lW3se+bNOs7YcRNH5aAaK04wIaPKl2S1d2
         BTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279268; x=1791884068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y4occJ8bcfYl1ztAcem1o8SmF8sKoGNbjtjkE+6WTes=;
        b=tF7Oaz3Sm9F0ActcJTSP0tL/2WccWGvVcZLGzoaJHDtQbj+1TX6zjxMBiOTOjAlXjF
         BL77BSAShNjlX12Ilh/kAurmnoIINJat3QF0HmaeiSKSVjmL4o7ZpBbd0S0wKb81h4Tf
         MH5fGj1LZTfzXwGwrQCtpQctyZs7EocGgnEDO84qi5ee/7yZmNWmcmKOZzaeiCp5l0lm
         Z49RZAIBbq7jA/Ozq0f3Usynjm+CBN92PWZP9NT+DzW+iBARs7nE9j5LOpPvK9UuWtzd
         zmEamJiozJkDJStBKEH2UZQWyVoO66WOM1xJRSOybJZpEWSGw4IsS1rI1CJrg2LZ0Ygh
         ZOcg==
X-Forwarded-Encrypted: i=1; AKwUvByN5F/SdmdHM8wHzVM7UeIuimUXGI5UcE5kvZPWAtEgoRJu6+1cmVWJl/sxr7Din5GfTzan3YC8TP+E@vger.kernel.org
X-Gm-Message-State: AFq9FYKkDyEhwGtxS7cfIxzZl96p66SVPuQiEYbVAZQdMh/XA0WHj6al
	zt8oCnXvzZdqv+boTlP6iM8i156Bz4NxkMWtL9MyzumUvm30BsyyB2vz
X-Gm-Gg: AYBFou3jml7ZOqVxibMS2LxCLPrYIva9pou8soTivH+j9zjuFGMx4nbaguW3Xo7oNvq
	PUWJ+iR7RqO1gNXR+3Etno8KUPKtcUGPLwKElcJxH/i6xkiFkB+j+xscj9Ryjp9zjVRGm5+3r+O
	KJ2K5FBRGmyBM8KVW2HAzzUNFAj7Od9ubRYxhjBSL3efAwR12boBTDEIoI8Rxr0Nm6KZCSNw+tg
	+srbn0X8s9ciWnu9A53SqGYoPZnFOw0GhE4Bj0Pi1y+n6Lxi5oKNwdJZb2AhmqXUZlfKg6pNDCy
	JGYsIBmrVSU/oppL6uNrFhaM9eftKAHmJXCrOeUtkrVMb1n3vTHwmneQbYrL4YYdzZI+axDWuHy
	WBnWJcvfGLA77253MNCnAOpkGC5bxBnnFRpq/YqL5mw/U/HGciqM2/2YBxZx3xqT3KxWl//EAX5
	LXK1mrRRk6SI/wJVLlNsyVS7HYVR8ArZTbLcP1/wOE2x+m3ey8ZQNKvbtfGnbfERdew6BzfQ==
X-Received: by 2002:a17:90b:380d:b0:39d:84af:a0b3 with SMTP id 98e67ed59e1d1-3a87353c171mr667697a91.18.1791279267975;
        Tue, 06 Oct 2026 02:34:27 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:27 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 2/8] scsi: target: keep REPORT REFERRALS stores inside the buffer
Date: Tue,  6 Oct 2026 17:33:32 +0800
Message-Id: <20261006093338.27342-3-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261006093338.27342-1-physicalmtea@gmail.com>
References: <20261006093338.27342-1-physicalmtea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

target_emulate_report_referrals() stores an 8-byte LBA when
data_length > off. That test only shows that one byte is left. An
allocation length of 9 therefore writes buf[8] through buf[15].

vhost-scsi keeps one sg inside a page. Nine bytes placed at page
offset 4087 end on the page boundary, so the extra seven bytes are the
next physical page. That page is not part of the data-in sgl.

The check from commit 38edd7245771 ("target_core_alua: check for buffer
overflow") still walks every map entry, so the returned data length stays
the full descriptor size. Keep the walk.
Encode each LBA locally, then copy only the bytes that fit in the
remaining allocation. This also preserves the valid prefix when the
allocation ends in the middle of an LBA field.

The one-byte descriptor fields already test data_length > off.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_report_referrals+0x100/0x380 [target_core_mod]
  Write of size 8

  target_emulate_report_referrals
  __target_execute_cmd
  target_execute_cmd
  transport_generic_new_cmd
  __target_submit
  target_queued_submit_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork

Fixes: 38edd7245771 ("target_core_alua: check for buffer overflow")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -44,9 +44,22 @@ static u32 alua_lu_gps_count;
 static u16 alua_lu_gps_counter;
 static u32 alua_lu_gps_count;
 
 static DEFINE_SPINLOCK(lu_gps_lock);
 static LIST_HEAD(lu_gps_list);
 
 struct t10_alua_lu_gp *default_lu_gp;
 
+static void
+target_emulate_report_referrals_copy_lba(unsigned char *buf, u32 off,
+					 u32 data_length, u64 lba)
+{
+	unsigned char lba_buf[sizeof(lba)];
+
+	if (off >= data_length)
+		return;
+	put_unaligned_be64(lba, lba_buf);
+	memcpy(&buf[off], lba_buf,
+	       min_t(u32, sizeof(lba_buf), data_length - off));
+}
+
 /*
@@ -85,13 +98,15 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	list_for_each_entry(map, &dev->t10_alua.lba_map_list,
 			    lba_map_list) {
 		int desc_num = off + 3;
 		int pg_num;
 
 		off += 4;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_first_lba);
 		off += 8;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_last_lba);
 		off += 8;
 		rd_len += 20;

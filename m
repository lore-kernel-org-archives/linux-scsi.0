Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3D489FDF
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791813141; cv=none; b=aWY1fTORssreJ7JwNEbpZUvUxa4qCqBzjXFHls5oyabkZWE6eY4XuXGAn1iOFtVJZmd1EXj3GDvle+h0IsVIdiinmsatJW3LU2gsmn1jqufGUyDrn/89bDKJk5lmiIAPT6rT8DrR8YwrVFKo9+EOZdDJg+smKtO/coxqV44rIE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791813141; c=relaxed/simple;
	bh=TmrDgwIsBwwzPv80GnSL6PFlsZHILn4PMmXvaiqLLF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kddc+2WZJ7c53m7c2StqwwcfY+z8Ct9suudJV4v4pyCxykiQyj6W96MTqrrBU69s4qmAiZ1PnF6csi7danfVC9m0PnZW8CzVdYDvWIEJzZU0iM8SHU1LyOujyTxyZoh+96y69Q38b3ZSoEc06tLx2T2w5WTAD2vjNN8wmumHcD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=a58vcaqc; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="a58vcaqc"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-88cfa501c5cso558929b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 06:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791813137; x=1792417937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VUNiGziCUNl+CT1ZqXgl34E50ZrFvZEoRDfOve+S9JE=;
        b=a58vcaqcqb31nvvheENTQc3TJZJ3c8qP6d9NiFVlddOPyg5hTQjOM0ID1aNoW/YFg/
         1mLesTY29GGjN9B3iwgZqthZdxADBJJtL5aQGtFudXTIdG1DT0w/NmCybyMxiZWgw0zZ
         oNHteQdf0o3PQG8W9OLgcRbvDgWpYiM+tCUyt1mxrMryxU9MHdgi9b8lyxoO+bzwXv2K
         2o7sg+s5h2wDQpbloc+RDqafUg9f5oafvJRDIMm7F22GHVU4DsLdr/S5H1AIJ+EXEmQE
         pmD3lkDhFLAed0O+YRA0LOru1czE6dxKdMIBO0XajXdhZOehjtmzYpQu7+q6quYiTuKA
         wCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813137; x=1792417937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VUNiGziCUNl+CT1ZqXgl34E50ZrFvZEoRDfOve+S9JE=;
        b=nHysI5Aan19+QYQcXNBX5UxoRZ1gb6S0T6/7eZ1ZYpRx5muqvx1JHC32Kvg+nrB8zn
         JSlqOlJWpypFdBsXyzqvX1h2TJRaTBwNUq+OEVQJqfMxXOjOCak92idkNjFo8E6JwW9L
         gUAzdORYgMcOlq1ITvYIuGWYjagQxlHAyFDzLqwaUOzonMCcVurcT6ibMuz6CjF/Ppl7
         G7teTkeNkWQCr/0xeZEFa67rnsBs/uhVa6rXfoN2WUdQA14qycnGUtIpRKrTyuvtPSdR
         szDgVtvIxiBBP9YGJ0fnZ4aNO5MpcOy9ObTuAC5HON0jMV8hFGEaOqkILkAAdj+NhubU
         hrHA==
X-Forwarded-Encrypted: i=1; AKwUvBz23YB5ARCNo0fjAXpcLW7uQQ4HdQq0xISoTsJKvIG+V//wUV+x6dq0H9Mo6bgy3wJlT9Fyip4QZcCH@vger.kernel.org
X-Gm-Message-State: AFq9FYKTtCSGt9bD7nsgFv+VpnHwGtEmLiL88GnZ+1PfMrsVm4/64umg
	5xLNovxOKKN/L+dmZSRJ3b+ExWjrjLvqgtQyvdvzv0hesDzGipGPKhoQtj0KiLCRswwleBFpuqI
	I5plZa3o=
X-Gm-Gg: AYBFou2/pKpPiHfxVXwcuGJc2j1Z2uX4V1hsAftRGJ7vGUGq3bvybc6gXzhnDSL1WHL
	9Hv3ndEttsyvEnIkUCqTtpS4MXAw6sZ3k8TEkyZ//AXHItepztkvbCq6tgVtwOie+qbIC69xout
	NKnHeNn5X54wzJbVruJDGqdELyaY7fvggFxFtpzutarFJpfrLeianbtIFf/KxS4X866wOKYaTF4
	RFqMcCacT3x3WrzprN5DQsZD6mrSg4BHS9d6aF73JLZEBc91p47ZZ+2izfNozb5A67vkbTpuDAY
	DoNIlkuZw8JxJivaBucPTnScLBQAaZgcDrSOxLejxUiWBftYNxTj2nBqPIClkMnbGiS6f4ga/GH
	QN1OsSposFvKeAvdQweCiEcaRYJAtNZlMOLK35B1/hPd9Q/ly5JywkQV1qUmEd0I4/VOrkHZWoX
	R8ppwEfI/+tHe5j0fTtJiZYy6lxs1eE1Ce5fAXqDYBE8n5OzICy85sPsnHID1aRo55S7y6ZDP+o
	eqPTJuLjAQXKPuRLI0sAw==
X-Received: by 2002:a05:6a20:5493:b0:3dd:a00a:c5be with SMTP id adf61e73a8af0-3e16c03cd8emr10688105637.49.1791813136750;
        Mon, 12 Oct 2026 06:52:16 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e08c89sm4298333a12.8.2026.10.12.06.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 06:52:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Mon, 12 Oct 2026 22:51:59 +0900
Message-ID: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ft_recv_write_data() executes a WRITE once the received byte count reaches
se_cmd->data_length.  Frames are placed by their FCP relative offset but
nothing tracks which offsets were filled, so an initiator that sends two
frames at the same offset reaches data_length with part of the buffer never
written: two 4096-byte frames at offset 0 of an 8192-byte write get the
count to 8192 and leave the second half untouched.

The buffer is not zeroed (transport_generic_new_cmd() clears zero_flag for
a data CDB), so that gap keeps the previous page contents, which the
backend then writes to the device for the initiator to read back.  There is
no oops; poisoning the buffer and sending such a pair leaves 4096 bytes of
it committed unchanged, and the patched driver refuses the overlapping
frame.

Track the range received and drop a frame that falls inside it.  With no
overlapping frame accepted, the byte count reaches data_length only when
the whole buffer has been written, so it stays a valid completion test;
in-order and out-of-order complete writes are unaffected.

Fixes: 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target (TCM - target core) support")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/tcm_fc/tcm_fc.h |  8 +++++
 drivers/target/tcm_fc/tfc_io.c | 57 ++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 00e5573c62966..b75b1373a49c9 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -103,12 +103,20 @@ struct ft_lport_wwn {
 /*
  * Commands
  */
+#define FT_WRITE_SEGS	4	/* out-of-order write ranges tracked per cmd */
+
 struct ft_cmd {
 	struct ft_sess *sess;		/* session held for cmd */
 	struct fc_seq *seq;		/* sequence in exchange mgr */
 	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
 	struct fc_frame *req_frame;
 	u32 write_data_len;		/* data received on writes */
+	u32 write_contig_end;		/* end of the contiguous data received */
+	u8 write_nseg;			/* out-of-order ranges held below */
+	struct ft_write_seg {
+		u32 off;
+		u32 end;
+	} write_seg[FT_WRITE_SEGS];
 	struct work_struct work;
 	/* Local sense buffer */
 	unsigned char ft_sense_buffer[TRANSPORT_SENSE_BUFFER];
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 45329284f52f5..53d7c7268865d 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -189,6 +189,56 @@ static void ft_execute_work(struct work_struct *work)
 	target_execute_cmd(&cmd->se_cmd);
 }
 
+/* Record a frame's range; refuse one that repeats data already received. */
+static bool ft_add_write_range(struct ft_cmd *cmd, u32 off, u32 len)
+{
+	u32 end = off + len;
+	unsigned int i, j;
+	bool absorbed;
+
+	if (off < cmd->write_contig_end)
+		return false;
+	for (i = 0; i < cmd->write_nseg; i++)
+		if (off < cmd->write_seg[i].end && cmd->write_seg[i].off < end)
+			return false;
+
+	if (off != cmd->write_contig_end) {
+		for (i = 0; i < cmd->write_nseg; i++) {
+			if (cmd->write_seg[i].end == off) {
+				cmd->write_seg[i].end = end;
+				return true;
+			}
+			if (cmd->write_seg[i].off == end) {
+				cmd->write_seg[i].off = off;
+				return true;
+			}
+		}
+		if (cmd->write_nseg >= FT_WRITE_SEGS)
+			return false;
+		cmd->write_seg[cmd->write_nseg].off = off;
+		cmd->write_seg[cmd->write_nseg].end = end;
+		cmd->write_nseg++;
+		return true;
+	}
+
+	cmd->write_contig_end = end;
+	do {
+		absorbed = false;
+		for (i = 0; i < cmd->write_nseg; i++) {
+			if (cmd->write_seg[i].off != cmd->write_contig_end)
+				continue;
+			cmd->write_contig_end = cmd->write_seg[i].end;
+			for (j = i; j + 1 < cmd->write_nseg; j++)
+				cmd->write_seg[j] = cmd->write_seg[j + 1];
+			cmd->write_nseg--;
+			absorbed = true;
+			break;
+		}
+	} while (absorbed);
+
+	return true;
+}
+
 /*
  * Receive write data frame.
  */
@@ -267,6 +317,11 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		goto drop;
 	if (frame_len + rel_off > se_cmd->data_length)
 		frame_len = se_cmd->data_length - rel_off;
+	if (!ft_add_write_range(cmd, rel_off, frame_len)) {
+		pr_err_ratelimited("%s: xid 0x%x: offset %u len %zu repeats data\n",
+				   __func__, ep->xid, rel_off, frame_len);
+		goto drop;
+	}
 
 	/*
 	 * Setup to use first mem list entry, unless no data.
@@ -345,6 +400,8 @@ void ft_invl_hw_context(struct ft_cmd *cmd)
 				 */
 				cmd->write_data_len = lport->tt.ddp_done(lport,
 								      ep->xid);
+				cmd->write_contig_end = cmd->write_data_len;
+				cmd->write_nseg = 0;
 
 				/*
 				 * Resetting same variable to indicate HW's
-- 
2.43.0


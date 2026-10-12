Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C215B48EC91
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 15:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819334; cv=none; b=bGx+9kdftE9NI4v1tC7tty9yL0BJ49p9pd4tGNERtDl5OhSuLSpThVuKsjLHLeuikgrWmhyZ+3V+EKIy9db6s7tHKZChm1l43EG8Jh/9n12Y1CUjdC/VwpU4cxwr1S1bI5oIrE/YpihPkngaZ/fumxNQvXdzr0Scdq6yc/3+9Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819334; c=relaxed/simple;
	bh=gnxM0yOOK/JwI1s4juAVEfjVQ1r1eqV660lsNqxSPEw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tAnlGmLT85w3O3SoJcr4AER2fB9q5DCCl89z1QkRQKqcAd9qbqz0tzKzZiyZDazKhtXBJ1AVz6eBEJoAYMmK5P3BEhsSC2ZEI0RQWUXaIELDERtDjrbiuOKING4vv3rn/WqgVLWqf0bHDYZCOvHY6RQJ2B+fa+uM+k4l+tiiOjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=LB9He1gC; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="LB9He1gC"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a706146559so1156952a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 08:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791819330; x=1792424130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yok6zVFuauItk86XZja8sSODs2GHBMfYs1w0NhMN22c=;
        b=LB9He1gC1IUekYjF8vFwvdVXa4LoDMBGvgLH50+Z7YkBFwdAxmfHZGHtUmGDN6b1fK
         e7820GwtU8/DQ0oWrqmoakeFPpUQJxYklpPIfjPD+CliCMjbMHWrfCeuwU4hfbGaPTx0
         BKR1AXoPQchdmy+ahS8CocpFDI4uW8b9qxaJJoyw34q3ymg1sz5EF196yQHp0l5CaYVJ
         DBe4ftjkSOd2/z5GGJ4MlHGvAhYdXuQV7WyT1foFd0aYhuknp2Ho98wNnRTJJagn83O9
         W+JVkigatv8uzw7yGSUxQZ9nWuNC6eOd+jA57aEywJUeQI2q+1W+UvnWiJaUd4QdVc5+
         Nrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791819330; x=1792424130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yok6zVFuauItk86XZja8sSODs2GHBMfYs1w0NhMN22c=;
        b=hpCGzfQLQzpXpSFKF3kRoS0PR/4i5XvXtEy4riwlBq7Dmf3rfHWDETc+96jPHr1g2h
         VCFRva5k02RDx4QySuUAdeDa307t6beSYwDhb4WYNUMTlhYDn1boM+NL+fOdzJ0w8Pt5
         G5YxrgasETw7OYe/44bvzsbL3dc/wak0D02tMq1TvnHTmZABDu8fP67yKJb/fc3DNp3I
         aE8UpPeVh5alyw5zrNdl+tMGfzG94ySrEIRpZOPNoEPEXydbBAPU2UByDNxaOocoe/7w
         DObJLXFNThTJwn+BHqXO+CrSdA7HBczzQYYs8XjM1J+DWhTgEviCEalq/4HjRohMCu30
         UpUw==
X-Forwarded-Encrypted: i=1; AKwUvBwvs86Nerm86kEkTiN0/ljOLh3F3zAfaJKqPH4M9b+RV9AmVIH8ctPwQCJgYFYbXGZrG+OiyodRio0k@vger.kernel.org
X-Gm-Message-State: AFq9FYIEEu/4LkP1u+mLrJNzyezRSs0JFsu48qeoOhMmrByMG+1os7tQ
	fZjntNf3AjbxiYHVFEoBOm5QbKm7kKeUStLRIHf+rB9BiPfY4xBgvL9biuMNzcp8seI=
X-Gm-Gg: AYBFou2UbPPrsk2wW4DDnnhnQeRQOuy7nEccE2WImld6MCwarjIo9nlULHP5djYvMZ2
	eVAnexn7iV/UgPj4o1TettXjU34eT15zMaML8Yv+P5hMZIfotAxdoYqr8dhyF3wN6HAgDQqpjgI
	AkbdFVTHZhjpenjHJ8UPEpq692haXu49CqHlEY+n6nghV1Dg2VT5sc5P9wNW9IIZ/adTs1ZMrSA
	n35A1wuVSqTeAHez1KxB1m5t7Z8wYk2exz81HZWnV8Zo0yGIYKMopVIi7r+BAqJTyzJZ37XUhUt
	OQ4fY9ygK53HVyI83jdJKrQK0sDSpthlptyZzpvl05kFIuUM92UgKMlLvWL4xJ+FpbpD/U3Aezr
	q4kyOv4xMdofw8V78+SUX+eh/Sh2Vkd2fCm6ULqRwl4Gm0n2/qNTi6dk8+uwKzdfmNbV3iZfSmf
	H+aTbUuxOHJTrYQSRni9vMpfoqssJnLWnxb56pKHv76/NdLmx6sTNpTT1JEURi8IkApkb/L9WD9
	Jnjd/DMyriazttgi/QrIM8=
X-Received: by 2002:a17:90b:2889:b0:3ac:eeb:e0ed with SMTP id 98e67ed59e1d1-3ac0eebecf5mr1790611a91.36.1791819329799;
        Mon, 12 Oct 2026 08:35:29 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38b9639bsm16371590a91.4.2026.10.12.08.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:35:29 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Tue, 13 Oct 2026 00:35:02 +0900
Message-ID: <20261012153502.2435483-1-yhlee@isslab.korea.ac.kr>
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
v2: coalesce adjacent tracked ranges, so a reordered write whose segments
    have become contiguous no longer exhausts the array and is wrongly
    refused (Sashiko).

 drivers/target/tcm_fc/tcm_fc.h |  8 ++++
 drivers/target/tcm_fc/tfc_io.c | 74 ++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

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
index 45329284f52f5..27eb9da0bc01f 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -189,6 +189,73 @@ static void ft_execute_work(struct work_struct *work)
 	target_execute_cmd(&cmd->se_cmd);
 }
 
+/* Fold a range that now adjoins the contiguous front, or another range. */
+static void ft_merge_write_ranges(struct ft_cmd *cmd)
+{
+	unsigned int i, j;
+	bool merged;
+
+	do {
+		merged = false;
+		for (i = 0; i < cmd->write_nseg; i++) {
+			if (cmd->write_seg[i].off == cmd->write_contig_end) {
+				cmd->write_contig_end = cmd->write_seg[i].end;
+			} else {
+				for (j = 0; j < cmd->write_nseg; j++)
+					if (j != i && cmd->write_seg[j].end ==
+					    cmd->write_seg[i].off)
+						break;
+				if (j == cmd->write_nseg)
+					continue;
+				cmd->write_seg[j].end = cmd->write_seg[i].end;
+			}
+			for (j = i; j + 1 < cmd->write_nseg; j++)
+				cmd->write_seg[j] = cmd->write_seg[j + 1];
+			cmd->write_nseg--;
+			merged = true;
+			break;
+		}
+	} while (merged);
+}
+
+/* Record a frame's range; refuse one that repeats data already received. */
+static bool ft_add_write_range(struct ft_cmd *cmd, u32 off, u32 len)
+{
+	u32 end = off + len;
+	unsigned int i;
+
+	if (off < cmd->write_contig_end)
+		return false;
+	for (i = 0; i < cmd->write_nseg; i++)
+		if (off < cmd->write_seg[i].end && cmd->write_seg[i].off < end)
+			return false;
+
+	if (off == cmd->write_contig_end) {
+		cmd->write_contig_end = end;
+	} else {
+		for (i = 0; i < cmd->write_nseg; i++) {
+			if (cmd->write_seg[i].end == off) {
+				cmd->write_seg[i].end = end;
+				break;
+			}
+			if (cmd->write_seg[i].off == end) {
+				cmd->write_seg[i].off = off;
+				break;
+			}
+		}
+		if (i == cmd->write_nseg) {
+			if (cmd->write_nseg >= FT_WRITE_SEGS)
+				return false;
+			cmd->write_seg[i].off = off;
+			cmd->write_seg[i].end = end;
+			cmd->write_nseg++;
+		}
+	}
+
+	ft_merge_write_ranges(cmd);
+	return true;
+}
+
 /*
  * Receive write data frame.
  */
@@ -267,6 +334,11 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
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
@@ -345,6 +417,8 @@ void ft_invl_hw_context(struct ft_cmd *cmd)
 				 */
 				cmd->write_data_len = lport->tt.ddp_done(lport,
 								      ep->xid);
+				cmd->write_contig_end = cmd->write_data_len;
+				cmd->write_nseg = 0;
 
 				/*
 				 * Resetting same variable to indicate HW's
-- 
2.43.0


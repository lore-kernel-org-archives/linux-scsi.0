Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B2345EBF
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 03:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791343521; cv=none; b=rk/0P/OreudP8MV4scvdShAHyDh+rWzIZTNh/YeKzqHSKtiP9V/9HbJPmD6oRkDNxdaIN5ZLhnWUaLRYysT1QOzLpmEwNxqE8IA3wYFEAsjtWMUTQZnsdN7qIJQw6ZcTDcOTFJta41tXSM36RhmYzfkZ9kY1MCJd3OJqVXNd4lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791343521; c=relaxed/simple;
	bh=TPohYjm1V8x75cgKx5ONjFui0qm3rfLa18jSDO9R78U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nv8c0oZ3aPiE+JoZ68IihxHXfV5u1RQWuPNwNW4MGv6Dfzt+mRRT+pRqR/ecxp8ClXSwwbbfqJSx+h0gZnUxJ2kC7wB2YFG9DZRjjJWIRxz6AR4d5guzxsppC0mzDIp9rPazjAGbDJg3zh637tR0EuJT9vwd6n2+tXL1j60uR7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=wi91ixbL; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="wi91ixbL"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a4d455ace3so1560521a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 20:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791343519; x=1791948319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y1QV4x32p4s0q/rMsfynBUDdaugSDJj3zH60UDSCAiE=;
        b=wi91ixbL/UUKh0RFcBCsl+UXqzyq107Y3WlWTlJNtP8iUfHBu5fPOyra1hC77ubkBk
         bG9EZb5aCfPnOrqQJRxKgTsoFlLIHMHr6pkGaSGHlzqPldZfgpPb8YmEWHgcC2BcBLN/
         vqP/k1FttSfq60g3cxr5+i0JT+VlnePsXV4fcwUZ1zsQskrVYK/wf+fU3ShZhsGVyP+M
         hGwvvbT/aS5nxpDVVdw2w5XEjpNgp2vbdIyCMwwiQnOtDCCPZfUQL24SeMaQq350d5vm
         k1Rc4IhSFrjRZVrYak6uNjyrmDhORxFYYZF22Qt65XJ76RkPei2oTTT3lH3kG327VVJK
         +jOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791343519; x=1791948319;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y1QV4x32p4s0q/rMsfynBUDdaugSDJj3zH60UDSCAiE=;
        b=KYyzVzk/ZV5dFWvouLbKQ0l8ewVKDPnT0ABh8tG4hvtaNud+p3/xjGKIx0uzmiemDO
         3yi4KWj2M5oJDKmDc5wvuMjNZ/7L01xZDVfxw3dKGXQcaCNH3Eul7VW67H3eS/+kEBlW
         L28rUeoh7PeVwIA1f6UnbSpjFSJEUuimz3STWtXsGL7fwoGZRSp8TzqDUEAB6tAl91l4
         ca9j3+k5kean6fg1bnSInv9uoylgqFrTWfapW15Oo6KNV7Wdf382o4KqPzo2W/B3CBFo
         4aLS5qDUwQMtKZ5JXa56nUa/8n2JU2FHTqRYupP5tEwUMAMx18vh2PcejSan3UIJNkqV
         o5Iw==
X-Gm-Message-State: AFq9FYJsyRVHKozKm02xcnN+bm8Tls5GYauZs30zRF8ggLOD2H1MaH8Z
	A6a/M+O9jfXxSowDXAYhoR4zPiCNcBkcgyRtvcWX6lJcL8Si1HQdv9OWE9fuI9vbAtw=
X-Gm-Gg: AYBFou2Q3KCP0ETyFVT4WlXPl+lofTXygGLiwhfZDyccCIhrRhkVZ6cII99LYTwUbQA
	NXO72pHKP3b5m7ytzeuAfDrhybt9QBeXpIXPF7QmgC09dFqtbCSQXQJ4LBC6sHHIi9/63iBSS5p
	SyaswKdhwz7NvDEeDwkeISnDf/aN5NVZ1H8VqKvWmI2/3c+Qk4ZJrWncj1ZCixLCe+YR549Fzet
	R5xWetHHTPuJkj/KTXdpoBfHnBggmE9mGM8IN/yxgnEzRttdPwKTPZZoKfnmkvrQyFdSn7M3vce
	1UTpBDnHOoAc+qwD26AhBnv91ExdyD1fiJkiqYqaXwPMOKBA+YU4ud+lz+Kmqu6DJ/f77bMa4oM
	o2i1sxpjpPu5KAeNh65cXHS+TWHZW206uyPCgu+C4RCNrNOMo+RlqIwLQL1yytbwRjdosmEt3Q4
	AC/joAonluqAbN+NezosJgkfXcrHh+KKiLPu34oGyyRR47YXaZwxuWwMe264V8f1FaDN7a2Uf+l
	v2ImGw=
X-Received: by 2002:a17:90a:6096:b0:3a8:a1b0:3e0c with SMTP id 98e67ed59e1d1-3a8a1b03f77mr525594a91.13.1791343519374;
        Tue, 06 Oct 2026 20:25:19 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543deb6dsm7951257a91.16.2026.10.06.20.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 20:25:19 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Wed,  7 Oct 2026 12:25:01 +0900
Message-ID: <20261007032501.640372-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A target can finish a read without sending the data.  iscsi_tcp_data_in()
bounds each Data-In PDU against the command buffer but never adds them up,
so a completion that declares no underflow is believed and the command
ends with DID_OK.  The pages keep whatever they held.

Over a 1 MiB pread of a file that had never been read, 999424 bytes came
back as the contents of an unrelated file the same process had written
earlier.  pread() returned 1048576 and errno was 0.

Count the payload per task.  Require each Data-In to continue where the
last one ended, and at completion compare the total with the buffer
length, less the residual when an underflow is declared.  A read can end
on a Data-In or on a SCSI Response, so check both.  Writes are untouched.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: take back_lock once on the SCSI Response path and make the counter
    uint32_t, both per Mike Christie's review.

On "was it built over another patch?" - no, v1 was generated against
v7.2-rc5 directly.  It stopped applying because c1dea15f819cd ("scsi:
libiscsi_tcp: Bound SCSI Response data segment to the connection
buffer") folded ISCSI_OP_SCSI_CMD_RSP into the shared response case,
which is the block v1's last hunk patched.  This version leaves that
fold alone and applies the check inside the shared case, so the data
segment bound stays in one place.

v1: https://lore.kernel.org/all/20260814121428.359541-1-yhlee@isslab.korea.ac.kr/
 drivers/scsi/libiscsi_tcp.c | 69 ++++++++++++++++++++++++++++++++++++-
 include/scsi/libiscsi_tcp.h |  1 +
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index d35f93451ee9b..6d8ace85c51ca 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -467,6 +467,37 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_cleanup_task);
 
+/**
+ * iscsi_tcp_check_data_in - verify a read received the data the target claimed
+ * @task: scsi command task
+ * @flags: flags of the PDU carrying the status
+ * @residual: residual count of that PDU
+ *
+ * ISCSI_FLAG_CMD_UNDERFLOW and ISCSI_FLAG_DATA_UNDERFLOW share a value, so the
+ * Data-In and SCSI Response paths both use this.
+ */
+static int iscsi_tcp_check_data_in(struct iscsi_task *task, u32 flags,
+				   u32 residual)
+{
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct scsi_cmnd *sc = task->sc;
+	unsigned int expected;
+
+	if (!sc || sc->sc_data_direction == DMA_TO_DEVICE)
+		return 0;
+
+	expected = sc->sdb.length;
+	if (flags & ISCSI_FLAG_DATA_UNDERFLOW) {
+		if (residual > expected)
+			return 0;
+		expected -= residual;
+	}
+	if (tcp_task->data_in_bytes == expected)
+		return 0;
+
+	return ISCSI_ERR_DATALEN;
+}
+
 /**
  * iscsi_tcp_data_in - SCSI Data-In Response processing
  * @conn: iscsi connection
@@ -491,7 +522,7 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 		iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
 
 	if (tcp_conn->in.datalen == 0)
-		return 0;
+		goto status;
 
 	if (tcp_task->exp_datasn != datasn) {
 		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->datasn(%d)"
@@ -509,7 +540,17 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
+	if (tcp_task->data_offset != tcp_task->data_in_bytes)
+		return ISCSI_ERR_DATA_OFFSET;
+
+	tcp_task->data_in_bytes += tcp_conn->in.datalen;
+
 	conn->datain_pdus_cnt++;
+
+status:
+	if (rhdr->flags & ISCSI_FLAG_DATA_STATUS)
+		return iscsi_tcp_check_data_in(task, rhdr->flags,
+					       be32_to_cpu(rhdr->residual_count));
 	return 0;
 }
 
@@ -783,6 +824,31 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			break;
 		}
 
+		if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
+			struct iscsi_scsi_rsp *rsp = (struct iscsi_scsi_rsp *)hdr;
+
+			spin_lock(&conn->session->back_lock);
+			task = iscsi_itt_to_ctask(conn, hdr->itt);
+			if (!task) {
+				spin_unlock(&conn->session->back_lock);
+				return ISCSI_ERR_BAD_ITT;
+			}
+			rc = iscsi_tcp_check_data_in(task, rsp->flags,
+						     be32_to_cpu(rsp->residual_count));
+			if (rc) {
+				spin_unlock(&conn->session->back_lock);
+				return rc;
+			}
+			if (tcp_conn->in.datalen) {
+				spin_unlock(&conn->session->back_lock);
+				iscsi_tcp_data_recv_prep(tcp_conn);
+				return 0;
+			}
+			rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
+			spin_unlock(&conn->session->back_lock);
+			break;
+		}
+
 		/* If there's data coming in with the response,
 		 * receive it to the connection's buffer.
 		 */
@@ -995,6 +1061,7 @@ int iscsi_tcp_task_init(struct iscsi_task *task)
 
 	BUG_ON(kfifo_len(&tcp_task->r2tqueue));
 	tcp_task->exp_datasn = 0;
+	tcp_task->data_in_bytes = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
 	ISCSI_DBG_TCP(conn, "task deq [itt 0x%x imm %d unsol %d]\n",
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index ef53d4bea28a0..a6e63db75d674 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -66,6 +66,7 @@ struct iscsi_tcp_conn {
 
 struct iscsi_tcp_task {
 	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
+	uint32_t		data_in_bytes;	/* Data-In payload received */
 	int			data_offset;
 	struct iscsi_r2t_info	*r2t;		/* in progress solict R2T */
 	struct iscsi_pool	r2tpool;

base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
-- 
2.43.0


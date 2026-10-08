Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C63783C6
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 04:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791432122; cv=none; b=GU4fsuLfTHEWNljVP3waNSUVvghWNPEvL17anuuHqQLq8VHg7XVW5qMmNTFPsudXpBCaUTdn9PqAG2ZADcOu7qm1Znb9EUo8bWOFq08SF9EooQCJfkQe9xrReSq74STQbecwSKn1vYAYEcJGY+7xlasHHVsHFBDiLUY9GGk2mdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791432122; c=relaxed/simple;
	bh=S2HX0NxKa03U27J+jIphYK1NDRJiLWnKVLa3qhkVVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VUSuBBNgQ8vgMxefeh5Q5FgMFtCvZQ3dDISuibYvu3C5aTnY2tWJcG6RMkKTH5d1evkFvBQe4zvVMtT6c/dO9JWsuIR/pguGt7gTuyqSwQlbcQzqrprTInMRAAAJ17n0XstG+CvJ2I+nZRIsxt/0shQfl2V630lawGBZdWVyBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=LNRe18Kk; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="LNRe18Kk"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2dfa54c8ccfso1786485ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 21:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791432118; x=1792036918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eo0Mxm2U7pH93nJD67q7zSOE038zz8DvuAtE9yTrVy8=;
        b=LNRe18KkAxka7eVkrty7ZugRh7Sk8Gl8khPeQHboYbDsx/p44rUYGlslW1IO2HFCer
         x9HgwIm0X/9X5scMMamVYh8iQ52m1sGmJA93dJVUzXs/Kw30PvTi6h0yDz7+ZaKH7sM0
         6Ql4KOUrJ2AdI5EjZ8uOs568ePhz43tKtIqqSGgGY3vl9woUYLPZWwX3QcTzR2m6Aqj/
         H1MdZOdpn4513pg8nwnDl4ri51SjsKOrtSuTX474wLLkEvZVkyLzsL6iyP/OOTXkYPYD
         T0PGH3a3MVEGnJNDbAS/q4tZPhAKLN82aYzTazejzDegDpR91Jvx44+/o/8UTQHpnOxR
         llNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791432118; x=1792036918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eo0Mxm2U7pH93nJD67q7zSOE038zz8DvuAtE9yTrVy8=;
        b=lhnvP1EBwRhxg5Xyls2YmxTf6qjUA/BhWRiA0cHtKadE2+0X4be4SkUibmrjcH5hgx
         XVRJMJ15AQ7tX4rDlKjpKp/kSnxz0k045nQh9KtHDFjG3pqdtj3VrEjDTd3bZdmrTYPj
         xBjiBbHAqkfocki6fP2cKkBWhYXsZ1dBhBaPTSnXSjYPjfnct6jXF9I6ZTIUh/DxxX82
         JYOXQG8dm39+is4VBHekx87LQrDJD728ip5MoA0wLlr3A4iM4ONl3AB/TeyDTMJPK1Ga
         2oQuIrB4T8L/LFyu+xBlBo5Dvt9m/3+J5tOjAVYKhAP9H5WNtVwBABgXEzRptFuGaPYk
         pRUA==
X-Gm-Message-State: AFq9FYKXPAKlm3dW3WcOW2/ZgxqXA6ucP2h7eo+wfWIimTlh1Y7Oph5j
	EmQKRxV012+pkMmTPueL9j3QrCcBh3+t1JKJm3jgqEtzLXX6TcuynV9lXKxMp+pKZRA=
X-Gm-Gg: AYBFou0XDYCvP626otfLnEhrxEdVrepgHAdgXjDz+1MHW9YLNHACG73AqOfejTpyr6w
	8T+ZHIhqBXFavGm2oUNwBXBrjyHnd8jf4Jf1dIj4q87NpKuwzy8xhKKhAH9PkT/Xn2BUgKbw5GL
	+hZxrToZ+cuLWaC7YRpMTKQTlt357BFAHeyMThcd5iz2cndC5yvcny9lDCSM9e51tjoCi3qvL6y
	EtRAbUzJnSbaqxh8LqX1pg85sEcjdv9ymCrjiXuR0JYg8JXWWbV0DdqWYP2uPqtS/FE5awrEzra
	/b9BnDO3HjWx3TJ55T5kj8DwURGa0LAFaEZ9IC5q+m5CJUaAFaQMRHEI/o3EqdHHDMUaLpo1S0O
	+uePO2IPWwJki7FrTsFLhXl8lyc9SF3vjTvUlAS/XGStVIiMnqgxfqJ3pSBmgVwPsqH6Vg0hrbO
	qf7EcwIDR9p1UoFX/6XLqENVsNmonP+4VXJHNqZKC1upJHqnezMDWtHBnGC+WsUSW+R1apZxR2M
	9v6Sw==
X-Received: by 2002:a17:90b:2d4c:b0:3a0:c31d:80c with SMTP id 98e67ed59e1d1-3aadff4891amr663631a91.9.1791432117993;
        Wed, 07 Oct 2026 21:01:57 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff5cd5c3sm2505994a91.17.2026.10.07.21.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 21:01:57 -0700 (PDT)
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
Subject: [PATCH v6] scsi: libiscsi_tcp: zero the unsent part of a short read
Date: Thu,  8 Oct 2026 13:01:29 +0900
Message-ID: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
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

Count the Data-In payload per task and, when the command completes, zero
the tail of the read buffer that was never received.  Whatever the
midlayer reports as transferred the caller then sees zeroes instead of
stale page contents, so no completion status has to be special-cased.
Writes are untouched.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v6: change approach.  Instead of deciding from the status, the sense, the
    service response and the residual whether the target promised the whole
    buffer, zero the bytes that did not arrive.  The previous versions kept
    growing because every completion shape that reports a full transfer has
    to be enumerated - SAM_STAT_GOOD, CHECK_CONDITION with RECOVERED_ERROR,
    and whatever a future upper-level driver decides - and missing one hands
    the caller the previous contents of those pages.  Zeroing the tail is
    independent of all of it: whatever the midlayer reports as transferred,
    the caller sees zeroes.  That also removes the need to fail the command,
    so a legitimate error reply no longer costs the connection.  The
    predictor and its three call sites go away; the per-task counter, its
    reset and the continuity check stay.
v5: do not check a response that did not complete at the target
    (ISCSI_STATUS_CMD_COMPLETED), since iscsi_scsi_cmd_rsp() already fails
    it with DID_ERROR, and treat a residual larger than the command buffer
    as a protocol error rather than a reason to skip the check (noted by
    Sashiko AI review).  The remaining case it raised, CHECK_CONDITION with
    a data segment shorter than two bytes, needs no change: libiscsi fails
    that with DID_BAD_TARGET, so the data is never handed to the caller.
v4: also validate coverage when the status is CHECK_CONDITION with a sense
    key of RECOVERED_ERROR.  sd_done() counts RECOVERED_ERROR as the whole
    buffer transferred, so v3's "skip every non-GOOD status" left a target
    able to short a read and still have it reported as a full success
    (noted by Sashiko AI review).
    The Data-In continuity check requires in-order Data-In and so does not
    interoperate with a target that negotiates DataPDUInOrder=No; that is
    deliberate, as making a safety check conditional on a peer-negotiated
    value would let the peer turn it off.
v3: only validate coverage for SAM_STAT_GOOD completions; a non-GOOD reply
    such as CHECK_CONDITION that omits the underflow flag must not be
    treated as a short read (noted by Sashiko AI review).
v2: take back_lock once on the SCSI Response path and make the counter
    uint32_t, both per Mike Christie's review.

On "was it built over another patch?" - no, v1 was generated against
v7.2-rc5 directly.  It stopped applying because c1dea15f819cd ("scsi:
libiscsi_tcp: Bound SCSI Response data segment to the connection
buffer") folded ISCSI_OP_SCSI_CMD_RSP into the shared response case,
which is the block v1's last hunk patched.

v1: https://lore.kernel.org/all/20260814121428.359541-1-yhlee@isslab.korea.ac.kr/

 drivers/scsi/libiscsi_tcp.c | 85 +++++++++++++++++++++++++++++++++++--
 include/scsi/libiscsi_tcp.h |  1 +
 2 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index d35f93451ee9b..00bdbcc6e27e3 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -397,6 +397,61 @@ void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_hdr_recv_prep);
 
+/**
+ * iscsi_tcp_zero_unread - zero the part of a read buffer the target never sent
+ * @task: scsi command task
+ *
+ * A target can end a read without sending all of the data, in any of the ways
+ * a completion can be reported.  Rather than predict from the status, the
+ * sense and the residual whether the buffer was promised in full, zero the
+ * bytes that did not arrive.  Whatever the midlayer then reports as
+ * transferred, the caller sees zeroes and not the previous contents of those
+ * pages.
+ *
+ * The continuity check in iscsi_tcp_data_in() means the bytes that did not
+ * arrive are exactly the tail, so one range covers them.
+ */
+static void iscsi_tcp_zero_unread(struct iscsi_task *task)
+{
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct scsi_cmnd *sc = task->sc;
+
+	if (!sc || sc->sc_data_direction != DMA_FROM_DEVICE ||
+	    tcp_task->data_in_bytes >= sc->sdb.length)
+		return;
+
+	sg_zero_buffer(sc->sdb.table.sgl, sc->sdb.table.nents,
+		       sc->sdb.length - tcp_task->data_in_bytes,
+		       tcp_task->data_in_bytes);
+}
+
+/**
+ * iscsi_tcp_complete_cmd - zero any unread tail, then complete the command
+ * @conn: iscsi connection
+ * @hdr: the PDU carrying the status
+ * @data: data segment of that PDU, if it has one
+ * @datalen: length of @data
+ *
+ * back_lock is taken once for the lookup, the fill and the completion.
+ */
+static int iscsi_tcp_complete_cmd(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				  char *data, int datalen)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	spin_lock(&conn->session->back_lock);
+	task = iscsi_itt_to_ctask(conn, hdr->itt);
+	if (!task) {
+		spin_unlock(&conn->session->back_lock);
+		return ISCSI_ERR_BAD_ITT;
+	}
+	iscsi_tcp_zero_unread(task);
+	rc = __iscsi_complete_pdu(conn, hdr, data, datalen);
+	spin_unlock(&conn->session->back_lock);
+	return rc;
+}
+
 /*
  * Handle incoming reply to any other type of command
  */
@@ -410,8 +465,13 @@ iscsi_tcp_data_recv_done(struct iscsi_tcp_conn *tcp_conn,
 	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
 		return ISCSI_ERR_DATA_DGST;
 
-	rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr,
-			conn->data, tcp_conn->in.datalen);
+	if ((tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK) ==
+	    ISCSI_OP_SCSI_CMD_RSP)
+		rc = iscsi_tcp_complete_cmd(conn, tcp_conn->in.hdr, conn->data,
+					    tcp_conn->in.datalen);
+	else
+		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, conn->data,
+					tcp_conn->in.datalen);
 	if (rc)
 		return rc;
 
@@ -509,6 +569,11 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
+	if (tcp_task->data_offset != tcp_task->data_in_bytes)
+		return ISCSI_ERR_DATA_OFFSET;
+
+	tcp_task->data_in_bytes += tcp_conn->in.datalen;
+
 	conn->datain_pdus_cnt++;
 	return 0;
 }
@@ -658,7 +723,7 @@ iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_conn,
 
 	/* check for non-exceptional status */
 	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
+		rc = iscsi_tcp_complete_cmd(conn, tcp_conn->in.hdr, NULL, 0);
 		if (rc)
 			return rc;
 	}
@@ -752,6 +817,14 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			spin_unlock(&conn->session->back_lock);
 			return rc;
 		}
+		/*
+		 * A Data-In with no data segment can still carry the status,
+		 * and it completes the command here rather than from
+		 * iscsi_tcp_process_data_in(), so fill the tail on this path
+		 * too.
+		 */
+		if (hdr->flags & ISCSI_FLAG_DATA_STATUS)
+			iscsi_tcp_zero_unread(task);
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&conn->session->back_lock);
 		break;
@@ -783,6 +856,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			break;
 		}
 
+		if (opcode == ISCSI_OP_SCSI_CMD_RSP && !tcp_conn->in.datalen) {
+			rc = iscsi_tcp_complete_cmd(conn, hdr, NULL, 0);
+			break;
+		}
+
 		/* If there's data coming in with the response,
 		 * receive it to the connection's buffer.
 		 */
@@ -995,6 +1073,7 @@ int iscsi_tcp_task_init(struct iscsi_task *task)
 
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


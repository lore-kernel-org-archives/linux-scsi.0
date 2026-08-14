Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F13546C4CF
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 12:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786709685; cv=none; b=ZFEhasacPjmUZWaasorIf8MsaA5SssRLif/W02CDu9VNw8l+0RFwHLQ/O/oW9alYCHp2CU0GQgzN1GQTmp1t+w3dPCbunbwAVqTAeJ6BwLANG+PwXNiG2COAd+6mukcnzoqPynObFVIJxHDCis/myx5s7WJ1a5Zex5zMD3boLek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786709685; c=relaxed/simple;
	bh=vS1DaGeA34Vt/UL7hTlZ7x9a+4a9vxNMD5B4EeDQiSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u+BEwi8CULeHCrBNWkY44Yt/bqLzK6f3ArrYol6dbxKbj/0ZnCJTsVU1AIphdjeCa6lHtmha7S3W7QXmsWj8ehRdt7wiQZDYa7w+mEtqTMekhgQwsqUhNb3OmUbDSn3yVwnwfmArAIPHJVCiGcEK26sZZtD47VsmXfNUrINORPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=XTi8PQsh; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="XTi8PQsh"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbb7926836eso614968a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 05:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786709680; x=1787314480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mB3Pg/1SEPTtiURwc1+Fo1eQBiAzNFUq+2h1OebH7HE=;
        b=XTi8PQsh6fGaESnR6L/VGvrUQElm93drqKeJpVA4qqm3ceqbSpXuNwPjOnvF0kcRWe
         x3LsSy7QKCm5hRjpEKltckoriI+rzVk48arJ78xlKhDXs4oLHUi9zunevntlYRABGGZu
         54Mn4ILgUjwmwlC9ewB5pm3bh6KKVxHRYZjCuxKrqKQ5TAQQU8jRqANNyOKxopkg5Cj7
         qBtEYRVDFItWtxhigikOGtV3AC6/dW8aeLSnRi4OHRz7ThcR6Riy8kBd/9aFCAONlidJ
         QqIaAmkCRKeB1yjxa9EXiPYwnwUoxaJ7JKO/PjcpnTnk5AGFO5NcsoAYdXYbBP2kV0ae
         i71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786709680; x=1787314480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mB3Pg/1SEPTtiURwc1+Fo1eQBiAzNFUq+2h1OebH7HE=;
        b=SgWBhYAV/TKFKOXV+zfbl1oL5KCxR2kcrAgHkRKnWZDpARazIurAXmhr1csiwknaMy
         aHIi3fVwOPxp3kdVCn/n6Zn6tpidhLotipUo1OsjNbpucUlKKcn76QKD6ifH8MgX61H4
         GY/5af6SLA1gDMgs/mlKfMZu/X+Uy3Gzu0D2uvmqiF1+JKvpH8VTYL6NL0fHl45KmiWO
         vqpy9iRE11qyBG4gpOMMnVEq+Tzz2wCOioeZqVk/0XK6LAv2VH+5uQhxTjrsY+e7r/8X
         2ZcV1sil1mmlzNDVf7oQfp3DcZ4u3qXs6azjk1KgiKIl0nfMIToKRqLQ0XY7dLOuLmyR
         VOQg==
X-Forwarded-Encrypted: i=1; AHgh+RqB+InOgc6XSyQ90m1oHq3/lkUedtltArOkOq6HbCw7wmKjV+b4F7slAZuPp34n8yPQ0ENvc72pVPH2@vger.kernel.org
X-Gm-Message-State: AOJu0YwN/MadSC33nXp0mWwtGbSUs5ewet1iwb7ndP6d60y94EiSELJo
	cerGO/2pruSXsEd8iB1w/jO/cHEb12W3gjBsZ/16+D19fG3oFKssN2DfCD07k7PAvug=
X-Gm-Gg: AR+sD102E6zoB51KDYa7U9oKNLa6kzFE1ClZ+SzTEtwAYxJEPpPB9S3zUj1mFxUAug7
	bj7z4LguHS8ct5VW0fnmqopHL66dWEQ3RpGtNF4RzGJilHOmY9Q//lgUV9gAdUs2ozPDyN6NKK6
	un00QEs8j0pNzs8ARgj9TJKhfx0USyU6E8M+lgExBY+1K4GvnJRIwhcEkA09d42D4/1U2Xby/x7
	T/bE627ahQ7JabUjmHBEEOyWmoup5hv29Kh1Z4K247erRlVp39M/Iq19QdQNeUB59I+V8SlpGKr
	6mhSAvnuEE9bpR7LVzSFIRuuesQV4mzJTGWhzbKvAnW9C3+YHzpSJkWc5BCkR1BgwNcRIvhb9Uq
	4V1YS+2dOqbZw6PwtHyiLNBvsBHpJ/YZw9LY0NJF562Z/I12e/83/Awh27+xRTcQH0MBD6EgzzJ
	CCtVM1+k+o1sx7+Pv7k0BpfMVQOHei2mGKvzinlyP/m1pFgCZ2kvrEeq1vFVHYSyLk4qyE
X-Received: by 2002:a05:6a00:2383:b0:84e:89a:b8ec with SMTP id d2e1a72fcca58-84fde3d4d3emr5107874b3a.11.1786709680448;
        Fri, 14 Aug 2026 05:14:40 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d267305sm373099b3a.52.2026.08.14.05.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:14:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	cleech@redhat.com,
	lduncan@suse.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 14 Aug 2026 21:14:28 +0900
Message-ID: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
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

Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
No Fixes: tag.  iscsi_tcp.c had the same shape before a081c13e39b5 ("[SCSI]
iscsi_tcp: split module into lib and lld"), so the check has never been
there.

Measured with a proxy in front of tgt.  Four ways of ending a read early
made it return success with the contents of an unrelated file the same
process had written: a zero-length Data-In, the status in a SCSI Response,
and no Data-In at all each gave 999424 of 1048576 bytes, and rewinding
BufferOffset gave 737280.  Each is refused now, two runs each, as is a
short last PDU with no underflow declared.  An honest underflow and
ordinary traffic are unchanged.

The check does not honour DataPDUInOrder: the target answers that key, so
honouring it lets a target switch the check off - measured.  A target that
legitimately sends Data-In out of buffer order will now fail.

Not exercised: the cxgbi offload path, and a digest session - tgt would
not negotiate CRC32C.
 drivers/scsi/libiscsi_tcp.c | 60 +++++++++++++++++++++++++++++++++++--
 include/scsi/libiscsi_tcp.h |  1 +
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e90805ba868fb..ce9c96f968c2a 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -467,6 +467,39 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_cleanup_task);
 
+/**
+ * iscsi_tcp_check_data_in - verify the Data-In payload that was received
+ * @task: scsi command task
+ * @flags: flags of the PDU carrying the status
+ * @residual: residual count of that PDU
+ *
+ * A target that reports success must have sent the whole buffer, or have
+ * declared the shortfall as an underflow.  ISCSI_FLAG_CMD_UNDERFLOW and
+ * ISCSI_FLAG_DATA_UNDERFLOW have the same value, so both paths can use
+ * this.
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
@@ -488,7 +521,7 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 		iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
 
 	if (tcp_conn->in.datalen == 0)
-		return 0;
+		goto status;
 
 	if (tcp_task->exp_datasn != datasn) {
 		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->datasn(%d)"
@@ -506,7 +539,17 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
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
 
@@ -752,13 +795,25 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&conn->session->back_lock);
 		break;
-	case ISCSI_OP_SCSI_CMD_RSP:
+	case ISCSI_OP_SCSI_CMD_RSP: {
+		struct iscsi_scsi_rsp *rsp = (struct iscsi_scsi_rsp *)hdr;
+
+		spin_lock(&conn->session->back_lock);
+		task = iscsi_itt_to_ctask(conn, hdr->itt);
+		if (task)
+			rc = iscsi_tcp_check_data_in(task, rsp->flags,
+						     be32_to_cpu(rsp->residual_count));
+		spin_unlock(&conn->session->back_lock);
+		if (rc)
+			break;
+
 		if (tcp_conn->in.datalen) {
 			iscsi_tcp_data_recv_prep(tcp_conn);
 			return 0;
 		}
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
+	}
 	case ISCSI_OP_R2T:
 		if (ahslen) {
 			rc = ISCSI_ERR_AHSLEN;
@@ -998,6 +1053,7 @@ int iscsi_tcp_task_init(struct iscsi_task *task)
 
 	BUG_ON(kfifo_len(&tcp_task->r2tqueue));
 	tcp_task->exp_datasn = 0;
+	tcp_task->data_in_bytes = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
 	ISCSI_DBG_TCP(conn, "task deq [itt 0x%x imm %d unsol %d]\n",
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index ef53d4bea28a0..b38be23b9e10b 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -66,6 +66,7 @@ struct iscsi_tcp_conn {
 
 struct iscsi_tcp_task {
 	uint32_t		exp_datasn;	/* expected target's R2TSN/DataSN */
+	u32			data_in_bytes;	/* Data-In payload received */
 	int			data_offset;
 	struct iscsi_r2t_info	*r2t;		/* in progress solict R2T */
 	struct iscsi_pool	r2tpool;
-- 
2.43.0


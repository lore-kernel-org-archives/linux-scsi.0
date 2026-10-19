Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C6484257
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392639; cv=none; b=Ro98w3/eUX2BeKBh8ZHv+ajON9fFB0mmh7b+gMFmp7IWB3NcHxGX5gRHqoeJ43LWHL2mREz6xlKLiXaohEyFpLSum6A+uXQaFyvuYojNTQghX4RXayeT79RlCN+aUdgPliEkhI2ESVsxnrD2Dog/ZrV0CJrg+cbJ3WVrDWK/i1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392639; c=relaxed/simple;
	bh=xSwl1h8Mp7wGf7H3F4SROm9i1vxc19txpJ5T1qdCORA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feXFNsx3NuE0dBDkDw9yqFnSp290h3Nsei1CwnYOnNwcRCF0V8pYRdDvzJb+6LA8SqUGx/+smffjahuyuLGZTgKeNhfuL9RrL75NVuVxcF07RQddIt5u1qSPA0FCGVdgg0bsAM8gJ+eXMObKAWMuVSV/hgQYVAlSnkYrGcI/W2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=tUYlrR0r; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="tUYlrR0r"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd632f7a4a1so547307a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 23:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792392636; x=1792997436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rb0QTBYByMcASXRlRy3m0adfxviH4p2FnEIUqbImivk=;
        b=tUYlrR0rEwVg33y/Nu430WHslgG2sAClQ4G5NHT9YXOIMm6xg7PiAK5Vi93YgvZ+mQ
         QUyIdCC7djM0JaLgqCF8hi/jYvV7+u87nAPNBreh9r07LoEmu++mKkIbPja+WF0YfmLs
         dMkR/GEqxWKvWAu3HcqYO5awvP7nu3QZQUcIxbigpO56Eoap+NnTDZ/MaEQPsRInexLF
         tzjaLsIIZdT+WQG1bP2Mo7gqES3XU5vf9TFBllDkzN18Bv+c1KMsk2L5UKL2CX5p46NB
         RPrT4HRC7RYtmEIZnoPf/4EUK8PCM2Js0NsWMRL2O1Fh94LDKvR1zlMpwZG7tJdWm9Hr
         O0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392636; x=1792997436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rb0QTBYByMcASXRlRy3m0adfxviH4p2FnEIUqbImivk=;
        b=lrzdpCKB3hDV18WnZrnOa8WmUG5XNoxI+mhnZbdtyx7hKRoBrDbIVje1FWJ0RtORud
         AlGyF3x05vCML/ywhCseDPncIMR/0HwjnMvlP7bOE8QeO19g8E8LVyGBK67hnDOThK5C
         rkunM6OSHc8rL0CamcISagGFNiRKvTLCQGKfe58NoaM7l1jqxx+KuWNfQa4BTW56eKu+
         fmnD/DfwDk4v+nEkTMQ/WmWhWtYQqvOus3GADbd9rqDWFWA0JVeXwi9SMFLcyTcLfnON
         4ONZkMg8WQtvDf6IFz1SbCpasPZwoLyGK6dika26ybRYm+IJdq54C0umB9WM0gCOWt+K
         wQvg==
X-Forwarded-Encrypted: i=1; AKwUvByg3H1u6SE6MG8Y7ylX8by5P4nYG+O4oCCb1rLwZMhal3VoM1sTHKAxKU5BRCQh3n7Ljyo3t4rb/Z20@vger.kernel.org
X-Gm-Message-State: AFq9FYKwGv9UdtRmvw6nBtIwQYOk9TDTIqWZ2xX5uZuL2jJ33vQqvYiN
	uPXzZzXrhLXisAylEAuUherhPGJ+B9iQMpQJOlfha3woD6qoz2RJW5IDomVehsS/6M8=
X-Gm-Gg: AYBFou2Iay/Dee1kvU2C0pynBueROfUfzeL/M5eoB7948cHIq9k7wwtWs6ZGj6P/oj3
	RtSWhgo640aq8bt+ooPWn8SSlq26QQUM0QxhRFyK6DaHUeB5lwRO+Y3dfWCYMQHJaaC0xNxBV5G
	2u+9WTYJtvshJ/fue1lcZmwfpkV3vq/yEYHTI6v5UdoXJoL8jbK/RHXEuk85KLqJ1Vak/xg39+g
	XTdFJC+J5cUxJsSgxJvfNCetIbx1Qu2fc2WGrPxmkmZG2mKl8SbdqIWCHy6Cyxgm0bSkw9m9Vbm
	CFgVWFkM+qTTvK/dRFyLjsOSx0FK947WCv5ZUL2Suy20tuNhYBpxoApM7s1UXG5KG2WkpRPF/UR
	gen8jl4z6xkR5lUYmu9aCz4BLKbeD3S+gqFk7PbjDQkGzmW8zicoNDeSLGarZfBNVJPaYP4PVdE
	zK7CWvMbUovP+xT5Xi7PgOnpiCHrZiOtU1+evm3uGjPsZVpJD9iaejvQTl8VOjWKXtlFcyYbLQS
	LOm+w==
X-Received: by 2002:a17:90b:44:b0:39e:3713:c2e4 with SMTP id 98e67ed59e1d1-3aceefc61f5mr5910732a91.14.1792392635675;
        Sun, 18 Oct 2026 23:50:35 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3f3ce5asm5870887a91.3.2026.10.18.23.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 23:50:35 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com,
	mrangankar@marvell.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: qedi: bound the data segment length of an unsolicited PDU
Date: Mon, 19 Oct 2026 15:50:18 +0900
Message-ID: <20261019065019.537183-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019065019.537183-1-yhlee@isslab.korea.ac.kr>
References: <20261019065019.537183-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qedi_process_nopin_mesg(), qedi_process_async_mesg() and
qedi_process_reject_mesg() read the data segment length out of the CQE the
firmware wrote and hand it to qedi_unsol_pdu_adjust_bdq(), which passes it
on to qedi_get_rq_bdq_buf() as a memcpy() length:

	pdu_len = cqe_nop_in->hdr_second_dword &
		  ISCSI_NOP_IN_HDR_DATA_SEG_LEN_MASK;
	...
	memcpy(ptr, (void *)qedi->bdq[idx].buf_addr, len);

That mask is 0xFFFFFF.  The buffer the copy reads from is a single
QEDI_BDQ_BUF_SIZE coherent DMA allocation, and in the nop-in and async
handlers the destination is an on-stack bdq_data[QEDI_BDQ_BUF_SIZE], so a
data segment larger than 256 bytes runs off the end of both.  The same
length then reaches __iscsi_complete_pdu(), which reads it back out of that
buffer.  Only the BDQ index is checked, not the length.

A segment that does not fit in one buffer is not a firmware malfunction.
The handlers divide the reported length by QEDI_BDQ_BUF_SIZE to work out
how many buffers were consumed so that qedi_put_rq_bdq_buf() can hand them
all back, and ISCSI_CQE_UNSOLICITED_FIRST, _MIDDLE and _LAST exist for that
same case, so the reported length is the total across several buffers while
only the first of them is ever copied here.  qedi_iscsi.c also gives the
firmware conn->max_recv_dlength as max_recv_pdu_length, which libiscsi
defaults to ISCSI_DEF_MAX_RECV_SEG_LEN, so this is a length a target picks
by sending a nop-in or an async message with a payload larger than one
buffer.

Cap the copy at one buffer in qedi_get_rq_bdq_buf(), return how much it
made available and report that rather than the announced length.  The cases
where nothing is copied at all are then covered too, because a rejected BDQ
index, the middle and last parts of a segment and a solicited PDU all used
to hand __iscsi_complete_pdu() a firmware-chosen length over a buffer that
had never been written.  num_bdqs stays derived from the announced length,
since it counts the buffers that were consumed and all of them still have
to go back to the ring.

Driving qedi_get_rq_bdq_buf() with a length one byte past QEDI_BDQ_BUF_SIZE
shows the copy running off the destination.  The harness is a KUnit test
that is not part of this patch; it calls the real helper and only swaps the
two coherent DMA buffers for kmalloc() of the same size, because coherent
allocations are page granular and KASAN does not track them.  In production
the destination is on the stack rather than in the slab.  The report names
the test function because the unpatched helper tail-jumps into
__asan_memcpy(), so the instrumentation records its caller's return
address:

  BUG: KASAN: slab-out-of-bounds in qedi_bdq_oob_dst_write_257+0x16a/0x2d0
  Write of size 257 at addr 0000000062866e00 by task kunit_try_catch/24
  
  CPU: 0 UID: 0 PID: 24 Comm: kunit_try_catch Tainted: G                 N  7.3.0-rc7-g58161ead29e5-dirty #4 VOLUNTARY
  Tainted: [N]=TEST
  Stack:
   612daf8d 00000000 00000000 00000000
   ffffff00 612daf8d 612e27f1 62866e00
   61371680 600ad4cf 62863ca0 6004301e
  Call Trace:
   [<600ad4cf>] ? dump_stack_lvl+0x5e/0x7a
   [<6004301e>] ? _printk+0x0/0xd7
   [<6004fc1a>] ? print_report+0x14b/0x517
   [<603c9c85>] ? __kasan_kmalloc+0xb5/0xc0
   [<6004301e>] ? _printk+0x0/0xd7
   [<608d2bfa>] ? qedi_bdq_oob_dst_write_257+0x16a/0x2d0
   [<603cad0b>] ? kasan_report+0x11b/0x160
   [<608d2bfa>] ? qedi_bdq_oob_dst_write_257+0x16a/0x2d0
   [<603cbcc0>] ? kasan_check_range+0x0/0x1c0
   [<603cbe0e>] ? kasan_check_range+0x14e/0x1c0
   [<603cc8a8>] ? __asan_memcpy+0x48/0x80
   [<608d2bfa>] ? qedi_bdq_oob_dst_write_257+0x16a/0x2d0
   [<608d2a90>] ? qedi_bdq_oob_dst_write_257+0x0/0x2d0
   [<601652be>] ? _task_rq_lock+0x5e/0x210
   [<6016cf70>] ? migrate_disable_switch.constprop.0+0x0/0x280
   [<600b46a4>] ? timer_read+0x14/0x30
   [<6022f42e>] ? ktime_get_ts64+0x8e/0x2c0
   [<6022f3a0>] ? ktime_get_ts64+0x0/0x2c0
   [<607082ac>] ? kunit_try_run_case+0x1bc/0x310
   [<607080f0>] ? kunit_try_run_case+0x0/0x310
   [<601c3b30>] ? sched_setscheduler_nocheck+0x180/0x220
   [<600cae70>] ? um_set_signals+0x0/0x60
   [<600cae70>] ? um_set_signals+0x0/0x60
   [<6014a21d>] ? __kthread_parkme+0xdd/0x1c0
   [<607080f0>] ? kunit_try_run_case+0x0/0x310
   [<6070e370>] ? kunit_generic_run_threadfn_adapter+0x0/0x100
   [<6070e3ec>] ? kunit_generic_run_threadfn_adapter+0x7c/0x100
   [<6015049e>] ? kthread+0x36e/0x560
   [<60150130>] ? kthread+0x0/0x560
   [<600b20de>] ? new_thread_handler+0xce/0x130
  
  The buggy address belongs to the object at 0000000062866e00
   which belongs to the cache kmalloc-256 of size 256
  The buggy address is located 0 bytes inside of
   allocated 256-byte region [0000000062866e00, 0000000062866f00)
  
  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2866
  flags: 0x0(zone=0)
  page_type: f5(slab)
  raw: 0000000000000000 0000000061801b40 0000000000000122 0000000000000000
  raw: 0000000000000000 0000000000080008 00000000f5000000
  page dumped because: kasan: bad access detected
  
  Memory state around the buggy address:
   0000000062866e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   0000000062866e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >0000000062866f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                     ^
   0000000062866f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   0000000062867000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ==================================================================

The over-read off the source reports the same way once the source is the
one left at its production size.  With the length capped both reports go
away, a 4096-byte request copies 256 bytes, and a data segment that fits in
one buffer is still copied in full.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 854efa4f61d87..f21d16c034990 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -316,9 +316,10 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 	cmd->state = RESPONSE_RECEIVED;
 }
 
-static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
-				struct iscsi_cqe_unsolicited *cqe,
-				char *ptr, int len)
+/* Cap the announced length at one BDQ buffer and return what was copied. */
+static u32 qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
+			       struct iscsi_cqe_unsolicited *cqe,
+			       char *ptr, u32 len)
 {
 	u16 idx = 0;
 
@@ -333,7 +334,7 @@ static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
 			  "wrong idx %d returned by FW, dropping the unsolicited pkt\n",
 			  idx);
-		return;
+		return 0;
 	}
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
@@ -344,15 +345,18 @@ static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
 	switch (cqe->unsol_cqe_type) {
 	case ISCSI_CQE_UNSOLICITED_SINGLE:
 	case ISCSI_CQE_UNSOLICITED_FIRST:
+		len = min_t(u32, len, QEDI_BDQ_BUF_SIZE);
 		if (len)
 			memcpy(ptr, (void *)qedi->bdq[idx].buf_addr, len);
-		break;
+		return len;
 	case ISCSI_CQE_UNSOLICITED_MIDDLE:
 	case ISCSI_CQE_UNSOLICITED_LAST:
 		break;
 	default:
 		break;
 	}
+
+	return 0;
 }
 
 static void qedi_put_rq_bdq_buf(struct qedi_ctx *qedi,
@@ -393,16 +397,20 @@ static void qedi_put_rq_bdq_buf(struct qedi_ctx *qedi,
 	readw(qedi->bdq_secondary_prod);
 }
 
-static void qedi_unsol_pdu_adjust_bdq(struct qedi_ctx *qedi,
-				      struct iscsi_cqe_unsolicited *cqe,
-				      u32 pdu_len, u32 num_bdqs,
-				      char *bdq_data)
+static u32 qedi_unsol_pdu_adjust_bdq(struct qedi_ctx *qedi,
+				     struct iscsi_cqe_unsolicited *cqe,
+				     u32 pdu_len, u32 num_bdqs,
+				     char *bdq_data)
 {
+	u32 data_len;
+
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
 		  "num_bdqs [%d]\n", num_bdqs);
 
-	qedi_get_rq_bdq_buf(qedi, cqe, bdq_data, pdu_len);
+	data_len = qedi_get_rq_bdq_buf(qedi, cqe, bdq_data, pdu_len);
 	qedi_put_rq_bdq_buf(qedi, cqe, (num_bdqs + 1));
+
+	return data_len;
 }
 
 static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
@@ -417,7 +425,7 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 	struct qedi_cmd *cmd;
 	int tgt_async_nop = 0;
 	u32 lun[2];
-	u32 pdu_len, num_bdqs;
+	u32 pdu_len, data_len = 0, num_bdqs;
 	char bdq_data[QEDI_BDQ_BUF_SIZE];
 	unsigned long flags;
 
@@ -438,8 +446,9 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 
 	if (cqe->cqe_common.cqe_type == ISCSI_CQE_TYPE_UNSOLICITED) {
 		spin_lock_irqsave(&qedi->hba_lock, flags);
-		qedi_unsol_pdu_adjust_bdq(qedi, &cqe->cqe_unsolicited,
-					  pdu_len, num_bdqs, bdq_data);
+		data_len = qedi_unsol_pdu_adjust_bdq(qedi, &cqe->cqe_unsolicited,
+						     pdu_len, num_bdqs,
+						     bdq_data);
 		hdr->itt = RESERVED_ITT;
 		tgt_async_nop = 1;
 		spin_unlock_irqrestore(&qedi->hba_lock, flags);
@@ -470,7 +479,7 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 	}
 
 done:
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, bdq_data, pdu_len);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, bdq_data, data_len);
 
 	spin_unlock_bh(&session->back_lock);
 	return tgt_async_nop;
@@ -487,7 +496,7 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 	struct iscsi_async_msg_hdr *cqe_async_msg;
 	struct iscsi_async *resp_hdr;
 	u32 lun[2];
-	u32 pdu_len, num_bdqs;
+	u32 pdu_len, data_len = 0, num_bdqs;
 	char bdq_data[QEDI_BDQ_BUF_SIZE];
 	unsigned long flags;
 
@@ -500,8 +509,9 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 
 	if (cqe->cqe_common.cqe_type == ISCSI_CQE_TYPE_UNSOLICITED) {
 		spin_lock_irqsave(&qedi->hba_lock, flags);
-		qedi_unsol_pdu_adjust_bdq(qedi, &cqe->cqe_unsolicited,
-					  pdu_len, num_bdqs, bdq_data);
+		data_len = qedi_unsol_pdu_adjust_bdq(qedi, &cqe->cqe_unsolicited,
+						     pdu_len, num_bdqs,
+						     bdq_data);
 		spin_unlock_irqrestore(&qedi->hba_lock, flags);
 	}
 
@@ -525,7 +535,7 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 	resp_hdr->param3 = cpu_to_be16(cqe_async_msg->param3_rsrv);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, bdq_data,
-			     pdu_len);
+			     data_len);
 
 	spin_unlock_bh(&session->back_lock);
 }
@@ -540,7 +550,7 @@ static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 	struct iscsi_session *session = conn->session;
 	struct iscsi_reject_hdr *cqe_reject;
 	struct iscsi_reject *hdr;
-	u32 pld_len, num_bdqs;
+	u32 pld_len, data_len = 0, num_bdqs;
 	unsigned long flags;
 
 	spin_lock_bh(&session->back_lock);
@@ -551,8 +561,9 @@ static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 
 	if (cqe->cqe_common.cqe_type == ISCSI_CQE_TYPE_UNSOLICITED) {
 		spin_lock_irqsave(&qedi->hba_lock, flags);
-		qedi_unsol_pdu_adjust_bdq(qedi, &cqe->cqe_unsolicited,
-					  pld_len, num_bdqs, conn->data);
+		data_len = qedi_unsol_pdu_adjust_bdq(qedi, &cqe->cqe_unsolicited,
+						     pld_len, num_bdqs,
+						     conn->data);
 		spin_unlock_irqrestore(&qedi->hba_lock, flags);
 	}
 	hdr = (struct iscsi_reject *)&qedi_conn->gen_pdu.resp_hdr;
@@ -568,7 +579,7 @@ static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 	hdr->ffffffff = cpu_to_be32(0xffffffff);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
-			     conn->data, pld_len);
+			     conn->data, data_len);
 	spin_unlock_bh(&session->back_lock);
 }
 

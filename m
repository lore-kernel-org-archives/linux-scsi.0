Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56D148AE38
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 07:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395937; cv=none; b=shlR88zXUZcWfESR/YaTyApDCjwUuOVuG0wH56qZ0WoyF9QQ/VnL0AF0mer/ViHhrb4fkqydDx6gUiQeLR6FMcwlDA2yXTAe9sTsUghrpd2gyuTFql6xcyS2q5fLxbbbt1TXz8oV7VhTuj8Q8XlziXHQJaAxQd5Zm36UG49Ruo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395937; c=relaxed/simple;
	bh=dfUUksOL3X+kzZA+D/DY/EOYy5QBDZZIDdWU4ZDh9GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgqG/DHGTKdJ9V0J1YKRFI67aB2oCxc3Sxo9q2Uz9h66oXVBNRb0nwM5b4cjDJ/V4IENjWP0kCE/5uPZBbGqtNNvi9RQZe0Hap+LpiCWt53Jp882NCwDZEI1Z7OSv+gPUt1ITezNBMa/SV8EWxisistVCjzxk3dKunVDMMfl5ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=yoxg5fQ9; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="yoxg5fQ9"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso441229a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792395935; x=1793000735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x6yjhXyk6uyPmPL6Z4Y+CrcUQo2i9q5QwSDRpKoQBdg=;
        b=yoxg5fQ9FVELvxNi51Pnd4GXWQkLqGhqLU+y+MRKyG823w2FGyRrojZWu9vca5xi9J
         SSxfmjJnu3Cg0q5zD/oq0W+HO0cxTDuftxHBnRgKEjPrZlFbO1gYppv8T5ITlkknKsh5
         NCd/H60a1GEGDRGww0QVHU782+YONUpgQggsvMogSJA55dZCcHj6JAg4AkgmkddAt4WD
         azz7TbBeT+MscH/I2Iqfo43wbVMfMtnAu+nl4GpwKpYLs1fDcKU/BlI6EWCoh0nDEmsZ
         JWJwcPx2ohqfKmfav9tUmRiFzYhEXqvIwZC8pGcSLcGJl6AosfAwURVxX5H6jRFERHnz
         v6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792395935; x=1793000735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x6yjhXyk6uyPmPL6Z4Y+CrcUQo2i9q5QwSDRpKoQBdg=;
        b=DlvCd59jq+gIQlmkazaURrV2D56ri5N4kOq1fqvIQDUx0xfj1uGdagj183oORx5aea
         KXpx6SZefUBXBZenxWg7rMO35erdvVemoYjLDF238dnEIRDR8lWmbwlv9/FaVkqDX7gM
         zD0nh90CkWUBhJNhmouS8I7eDvtXZTEKusbrcUAqTxFa9xA8du3Z2nBCLdiPF1K8C8N1
         sBi4FZ+fZXrH9C5UZnYELO3PjwJp6JqZDzsVmd0AaxPtOliORRuuyuJDlUAQSNKuojs5
         2zjdWI/r2SazZLjpV8kET5TrkvH3xXWhQuFesPNP+jPYfBPYnNxJd+hzuaTd+oiR67g0
         0iAA==
X-Forwarded-Encrypted: i=1; AKwUvBzbZJDaIMwvBLgzeHJUtF68j25YtH74P6DSd8AnD5UFBiOuW4yzUy/SAlc9Bu7eSDFGty9UCRS9iOm6@vger.kernel.org
X-Gm-Message-State: AFq9FYKFAuvKAMpL/Z0RqVait4LWrXzH2VBvD8ZoXKIww1EzT7MSDeP/
	fg1miuNNRpOintxngLsEzu3phWND9DLxwRAMqkRAYRK+km4KB7PmvvO2xC8EUgTZBpk=
X-Gm-Gg: AYBFou2y20E4S9WBWvKFoSTK0HseLMG23ipQNPNmqviMuT//Wgu2Po+isvdUJzOSib+
	amGQG2Q438Jve5rr+3iYaFu92i1jPg/LKspoABwTXcLddWs6IqVKSXN8zIsDm2T9Y3v41AOYtWa
	AVEcw0FShFdok2sepbpFa1UgkiCwMxJviGXCJoHq2nYagqpAJWovMG11WGuTjZImrPtyqHJgam5
	XkmYn6FBRilh8V1lbSccrlQvRbvA8lmUe7L6Rth9U0fR/TE/WQsfr1Zsyj75wEtt/2P/gAtQkBD
	VFU8qFtv2KCBMKo9VleAY26xZdvjDa730KxfRWBYDpG0YtomPRGiYKaBqBo8DHm4UG0WUhZCd7d
	XQGIb1zqGGiCZLJphCzY99/+ajciaOryXGKz2f/qAWY7hdgEwSkcYjy1SF2PbAKwAr/PxF6hkt4
	WZO5ElwX3GDOAXzwuLNpZuT5Q7eKea1YRhp9gSVqg6nXBv+03V2VEPwYir1ayBeMOIOxLM3ppa/
	bJYhkQ=
X-Received: by 2002:a05:6a20:4310:b0:3d1:c99f:efbf with SMTP id adf61e73a8af0-3e225fe8764mr5459805637.14.1792395935069;
        Mon, 19 Oct 2026 00:45:35 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f58017244sm3494351b3a.47.2026.10.19.00.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 00:45:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com,
	mrangankar@marvell.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: yhlee@isslab.korea.ac.kr,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: bnx2i: bound the RQ payload length reported by the chip
Date: Mon, 19 Oct 2026 16:45:20 +0900
Message-ID: <20261019074521.658170-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019074521.658170-1-yhlee@isslab.korea.ac.kr>
References: <20261019074521.658170-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bnx2i_get_rq_buf() copies a chip-chosen number of bytes out of one receive
queue entry:

	void bnx2i_get_rq_buf(struct bnx2i_conn *bnx2i_conn, char *ptr, int len)
	{
		if (!bnx2i_conn->ep->qp.rqe_left)
			return;
		...
		memcpy(ptr, (u8 *) bnx2i_conn->ep->qp.rq_cons_qe, len);

The only thing it checks is that the ring is not empty.  An RQ entry is
BNX2I_RQ_WQE_SIZE, which is also the size the driver hands the chip in
iscsi_init.rq_buffer_size, so any length above that runs off the end of the
entry the copy reads from.

bnx2i_process_reject_mesg() passes it reject->data_length straight out of
the CQE, having checked only that it is not zero:

	if (reject->data_length) {
		bnx2i_get_rq_buf(bnx2i_conn, conn->data, reject->data_length);

data_length is a u32 and is masked nowhere, and conn->data is the
ISCSI_DEF_MAX_RECV_SEG_LEN buffer libiscsi allocates for the connection, so
a Reject PDU whose length the chip reports above 256 reads past the RQ
entry and one above 8192 writes past conn->data as well.  That same value
then reaches __iscsi_complete_pdu(), which reads it back out of the buffer.

Trusting the chip here is not a position the driver already takes.
bnx2i_process_scsi_cmd_resp() reads the same field out of its own CQE and
caps it against both of the sizes involved, and says which one it hit:

	if (datalen > BNX2I_RQ_WQE_SIZE) {
		iscsi_conn_printk(KERN_ERR, conn,
				  "sense data len %d > RQ sz\n", datalen);
		datalen = BNX2I_RQ_WQE_SIZE;
	} else if (datalen > ISCSI_DEF_MAX_RECV_SEG_LEN) {

That guard and the unguarded caller were both there in the commit that
added the driver.

Cap the copy at one RQ entry in bnx2i_get_rq_buf(), return how much it made
available and report that instead of the announced length.  The two have to
come down together: iscsi_handle_reject() fails the connection when
ntoh24(reject->dlength) is larger than the datalen it was handed, so a
clamped copy with an unclamped header would trade the overrun for a dropped
connection.  Nothing else changes behaviour, because the sense path already
caps to the same value and bnx2i_unsol_pdu_adjust_rq() asks for one byte
and ignores the result.

Driving bnx2i_get_rq_buf() with a length one byte past an RQ entry shows
the copy running off the source.  The harness is a KUnit test that is not
part of this patch; it calls the real function and only swaps the RQ ring
and conn->data for kmalloc() of the same sizes, because coherent DMA
allocations are page granular and KASAN does not track them:

  BUG: KASAN: slab-out-of-bounds in bnx2i_get_rq_buf+0xc5/0x2d0
  Read of size 257 at addr 0000000062886c00 by task kunit_try_catch/25
  
  CPU: 0 UID: 0 PID: 25 Comm: kunit_try_catch Tainted: G                 N  7.3.0-rc7-g58161ead29e5-dirty #1 VOLUNTARY
  Tainted: [N]=TEST
  Stack:
   61189b44 00000000 00000000 00000000
   ffffff00 61189b44 611913a8 62886c00
   61219680 6009a4fc 6286fcd0 6004301e
  Call Trace:
   [<6009a4fc>] ? dump_stack_lvl+0x5e/0x7a
   [<6004301e>] ? _printk+0x0/0xd7
   [<6004fc1a>] ? print_report+0x14b/0x517
   [<6004301e>] ? _printk+0x0/0xd7
   [<60895b75>] ? bnx2i_get_rq_buf+0xc5/0x2d0
   [<603b7d0b>] ? kasan_report+0x11b/0x160
   [<606f6462>] ? kunit_add_action+0x122/0x4a0
   [<60895b75>] ? bnx2i_get_rq_buf+0xc5/0x2d0
   [<606f6340>] ? kunit_add_action+0x0/0x4a0
   [<603b8cc0>] ? kasan_check_range+0x0/0x1c0
   [<603b8e0e>] ? kasan_check_range+0x14e/0x1c0
   [<603b9891>] ? __asan_memcpy+0x31/0x80
   [<606f4550>] ? kfree_action_wrapper+0x0/0x10
   [<60895b75>] ? bnx2i_get_rq_buf+0xc5/0x2d0
   [<60896e7f>] ? bnx2i_rq_oob_src_read_257+0x11f/0x270
   [<60896d60>] ? bnx2i_rq_oob_src_read_257+0x0/0x270
   [<600b847d>] ? os_nsecs+0x2d/0x40
   [<600a16a4>] ? timer_read+0x14/0x30
   [<6021c42e>] ? ktime_get_ts64+0x8e/0x2c0
   [<6021c3a0>] ? ktime_get_ts64+0x0/0x2c0
   [<606f52ac>] ? kunit_try_run_case+0x1bc/0x310
   [<606f50f0>] ? kunit_try_run_case+0x0/0x310
   [<603b9740>] ? __kasan_check_read+0x0/0x20
   [<600b7e70>] ? um_set_signals+0x0/0x60
   [<600b7e70>] ? um_set_signals+0x0/0x60
   [<6013721d>] ? __kthread_parkme+0xdd/0x1c0
   [<606f50f0>] ? kunit_try_run_case+0x0/0x310
   [<606fb370>] ? kunit_generic_run_threadfn_adapter+0x0/0x100
   [<606fb3ec>] ? kunit_generic_run_threadfn_adapter+0x7c/0x100
   [<6013d49e>] ? kthread+0x36e/0x560
   [<6013d130>] ? kthread+0x0/0x560
   [<6009f0de>] ? new_thread_handler+0xce/0x130
  
  The buggy address belongs to the object at 0000000062886c00
   which belongs to the cache kmalloc-256 of size 256
  The buggy address is located 0 bytes inside of
   allocated 256-byte region [0000000062886c00, 0000000062886d00)
  
  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2886
  flags: 0x0(zone=0)
  page_type: f5(slab)
  raw: 0000000000000000 0000000061801b40 0000000000000122 0000000000000000
  raw: 0000000000000000 0000000000080008 00000000f5000000
  page dumped because: kasan: bad access detected
  
  Memory state around the buggy address:
   0000000062886c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   0000000062886c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >0000000062886d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                     ^
   0000000062886d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   0000000062886e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ==================================================================

The over-write past conn->data reports the same way once the source is the
one left oversized, and a length taken from the full width of the field
runs far enough out to be reported against whatever it lands on.  With the
copy capped all of those go away, a 4096-byte request copies 256 bytes, and
a payload that fills exactly one RQ entry is still copied in full.

Fixes: cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 7030efee5c46c..9ea0c704eb08f 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -820,7 +820,7 @@ struct bnx2i_hba *bnx2i_find_hba_for_cnic(struct cnic_dev *cnic);
 struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic);
 void bnx2i_free_hba(struct bnx2i_hba *hba);
 
-void bnx2i_get_rq_buf(struct bnx2i_conn *conn, char *ptr, int len);
+u32 bnx2i_get_rq_buf(struct bnx2i_conn *conn, char *ptr, u32 len);
 void bnx2i_put_rq_buf(struct bnx2i_conn *conn, int count);
 
 void bnx2i_iscsi_unmap_sg_list(struct bnx2i_cmd *cmd);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index d24cc2c795d61..776bf211eaeed 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -189,13 +189,16 @@ int bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action)
  * Copies RQ buffer contents from shared (DMA'able) memory region to
  *	driver buffer. RQ is used to DMA unsolicitated iscsi pdu's and
  *	scsi sense info
+ *
+ * Return: number of bytes copied, which is @len capped at one RQ entry.
  */
-void bnx2i_get_rq_buf(struct bnx2i_conn *bnx2i_conn, char *ptr, int len)
+u32 bnx2i_get_rq_buf(struct bnx2i_conn *bnx2i_conn, char *ptr, u32 len)
 {
 	if (!bnx2i_conn->ep->qp.rqe_left)
-		return;
+		return 0;
 
 	bnx2i_conn->ep->qp.rqe_left--;
+	len = min_t(u32, len, BNX2I_RQ_WQE_SIZE);
 	memcpy(ptr, (u8 *) bnx2i_conn->ep->qp.rq_cons_qe, len);
 	if (bnx2i_conn->ep->qp.rq_cons_qe == bnx2i_conn->ep->qp.rq_last_qe) {
 		bnx2i_conn->ep->qp.rq_cons_qe = bnx2i_conn->ep->qp.rq_first_qe;
@@ -204,6 +207,8 @@ void bnx2i_get_rq_buf(struct bnx2i_conn *bnx2i_conn, char *ptr, int len)
 		bnx2i_conn->ep->qp.rq_cons_qe++;
 		bnx2i_conn->ep->qp.rq_cons_idx++;
 	}
+
+	return len;
 }
 
 
@@ -1794,10 +1799,12 @@ static void bnx2i_process_reject_mesg(struct iscsi_session *session,
 	struct iscsi_conn *conn = bnx2i_conn->cls_conn->dd_data;
 	struct bnx2i_reject_msg *reject;
 	struct iscsi_reject *hdr;
+	u32 data_len = 0;
 
 	reject = (struct bnx2i_reject_msg *) cqe;
 	if (reject->data_length) {
-		bnx2i_get_rq_buf(bnx2i_conn, conn->data, reject->data_length);
+		data_len = bnx2i_get_rq_buf(bnx2i_conn, conn->data,
+					    reject->data_length);
 		bnx2i_put_rq_buf(bnx2i_conn, 1);
 	} else
 		bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
@@ -1807,12 +1814,12 @@ static void bnx2i_process_reject_mesg(struct iscsi_session *session,
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode = reject->op_code;
 	hdr->reason = reject->reason;
-	hton24(hdr->dlength, reject->data_length);
+	hton24(hdr->dlength, data_len);
 	hdr->max_cmdsn = cpu_to_be32(reject->max_cmd_sn);
 	hdr->exp_cmdsn = cpu_to_be32(reject->exp_cmd_sn);
 	hdr->ffffffff = cpu_to_be32(RESERVED_ITT);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, conn->data,
-			     reject->data_length);
+			     data_len);
 	spin_unlock(&session->back_lock);
 }
 

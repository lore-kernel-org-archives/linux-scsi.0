Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058359;
	b=k11yMZ7MJgsiY0GNTK9+Vo9fGaT2ebhHEGY2uE7uSfusjEslzV9ehRuDNcGf+tOajw3l
	 3rbJ7E4H9MCjux+PdOjUDU+cpZq5rI1gULolHCMeBeO03IDHFsJHBQG8QJr/wZOttoN04
	 p/yBBZXWloZXhmUU7wN6NqXs6iKVuqeVSweaYGlYP1WIHS8KQvymWx4Foimd1rRVSVoaq
	 57Rb3/MPEq3x2XoCgRu3hjJq9v5Aa/aEIHpH5Mm7GPGYeKQAeOJEG9hYLAGHDgbv8AwsF
	 /aWNsCVHZH99xjcMwAtvzKMBfWAsuUNnadqGc4pABPaZ9ly5b2abrEia4IiPC/lM4zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058359;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=m1YDbvR0NdM/Ep3+a9LrNovs2dBnSUqDo0ZUIBxkOFc=;
	b=TnKlwiD9do9mkzSEklacFCTnSroGspqqRaw6iEmAhnFq5w5cKSHUY01oKBjeeXIo4VQi
	 C3fNj7EneTBWPRy/QTQXjhDk5OnyqNvNvW4Reb3WoW2XSrJVpZr2XNLipXT2isNB9GujQ
	 r3WeohOpLVXYz4Mkbpq5mI8DIive87jGTV4YQ6QnDv15vz5GcCTGaJDcMABkHfuqjLlxG
	 ePJOZa/61h5HWx9QzjmyXEyk2PDa0jL/kr3osXTvHOfigKDBTLNdkNW3b7ZnPjGUjcxte
	 1XGWNCVNhbUMoQefG0kshbIUKsxDzSRCSpfrnW7nyuvW9GaRjFQ5cgugXT3eyKIwtAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=jA2vHwNn;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876C4606A320;
	Thu, 19 Nov 2026 03:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 876C4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=jA2vHwNn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=m1
	YDbvR0NdM/Ep3+a9LrNovs2dBnSUqDo0ZUIBxkOFc=; b=jA2vHwNn6d39q7FgOj
	NnV9rdqmOLIWW1Yn4iguGF3uw/pS203pxC7a8287CAgVmReaeiHy/c9yzTHCFIQ+
	ImQxX3Nig79JutbWbYXCn+RDk/mxC2HmGrmLqcvu/ChVGtArs3MwI2THMYQx/3iu
	gW/3xvVJtWfbatUxJso4KTOtY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDH7+Jfav5qLqoeJQ--.1940S4;
	Thu, 19 Nov 2026 11:17:53 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	jthoughton@google.com,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 2/2] scsi: bsg: release io_uring requests from end-I/O
Date: Thu, 19 Nov 2026 11:17:51 +0800
Message-Id: <20261119031751.3471968-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
References: <cover.1795016239.git.x-professor@outlook.com>
 <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH7+Jfav5qLqoeJQ--.1940S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3GF47JrWxur4DAF18uF1rWFg_yoW3WF13pF
	W5Kw43XrZ8Ww4IkrZxtrs8ZryYvan5Ca47KFWUWay7Ar1UAr9I93W0kw10qF13urWkt343
	Xr4kKa1DCF1jqwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j47KxUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gENnWr+amHhsAAA31

Holding the completed request until task work keeps its tag busy
and can deadlock deferred taskrun when the submitter faults on the
same queue. Snapshot result and sense in end-I/O, return
RQ_END_IO_FREE, and let task work unmap and copy without touching
the request. Sense snapshots use the per-device completion pool;
check out before mapping user data, return -EAGAIN when empty, and
put immediately in end-I/O when no sense needs delivering.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 128 +++++++++++++++++++++++++++++++---------
 1 file changed, 101 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e4a65d7a2374..739778244f42 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -16,9 +16,13 @@
  */
 struct scsi_bsg_uring_cmd_pdu {
 	struct bio *bio;		/* mapped user buffer, unmap in task work */
-	struct request *req;		/* block request, freed in task work */
+	u8 *sense_buffer;		/* sense snapshot from the per-device pool */
 	u64 response_addr;		/* user space response buffer address */
-	u32 max_response_len;		/* user response buffer size */
+	/* max_response_len is replaced by res2 after the end-I/O snapshot. */
+	union {
+		u32 max_response_len;	/* maximum sense snapshot size */
+		u64 res2;		/* saved completion result */
+	};
 };
 static_assert(sizeof(struct scsi_bsg_uring_cmd_pdu) <= sizeof_field(struct io_uring_cmd, pdu));
 
@@ -28,39 +32,48 @@ static inline struct scsi_bsg_uring_cmd_pdu *scsi_bsg_uring_cmd_pdu(
 	return io_uring_cmd_to_pdu(ioucmd, struct scsi_bsg_uring_cmd_pdu);
 }
 
-/* Task work: build res2 (layout in uapi/linux/bsg.h) and copy sense to user. */
+static u64 scsi_bsg_res2_clear_sense_len(u64 res2)
+{
+	return bsg_scsi_res2_build(bsg_scsi_res2_device_status(res2),
+				   bsg_scsi_res2_driver_status(res2),
+				   bsg_scsi_res2_host_status(res2), 0,
+				   bsg_scsi_res2_resid_len(res2));
+}
+
+/* Task work: unmap the saved BIO and copy sense to user space. */
 static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
 	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
 	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
-	struct request *rq = pdu->req;
-	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	u64 res2;
+	u64 res2 = pdu->res2;
+	u8 sense_len = bsg_scsi_res2_sense_len(res2);
 	int ret = 0;
-	u8 driver_status = 0;
-	u8 sense_len_wr = 0;
 
 	if (pdu->bio)
 		ret = blk_rq_unmap_user(pdu->bio);
 
-	if (scsi_status_is_check_condition(scmd->result)) {
-		driver_status = DRIVER_SENSE;
-		if (pdu->response_addr)
-			sense_len_wr = min_t(unsigned int, pdu->max_response_len,
-					     scmd->sense_len);
-	}
-
-	if (sense_len_wr) {
-		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,
-				 sense_len_wr))
+	/*
+	 * If the ring is being torn down or the submitting task
+	 * has exited, this may run from a kworker or in a different task, so
+	 * don't copy the sense data to the submitter's address.
+	 */
+	if (unlikely(tw.cancel)) {
+		ret = -ECANCELED;
+		sense_len = 0;
+	} else if (sense_len) {
+		if (copy_to_user(uptr64(pdu->response_addr), pdu->sense_buffer,
+				 sense_len)) {
 			ret = -EFAULT;
+			sense_len = 0;
+		}
 	}
 
-	res2 = bsg_scsi_res2_build(status_byte(scmd->result), driver_status,
-				  host_byte(scmd->result), sense_len_wr,
-				  scmd->resid_len);
+	if (!sense_len)
+		res2 = scsi_bsg_res2_clear_sense_len(res2);
+
+	if (pdu->sense_buffer)
+		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);
 
-	blk_mq_free_request(rq);
 	io_uring_cmd_done32(ioucmd, ret, res2,
 			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 }
@@ -70,9 +83,38 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 						  const struct io_comp_batch *iocb)
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	u8 driver_status = 0;
+	u8 sense_len = 0;
+
+	if (scsi_status_is_check_condition(scmd->result)) {
+		driver_status = DRIVER_SENSE;
+		if (pdu->response_addr) {
+			sense_len = min_t(unsigned int, pdu->max_response_len,
+					  scmd->sense_len);
+			if (sense_len)
+				memcpy(pdu->sense_buffer, scmd->sense_buffer,
+				       sense_len);
+		}
+	}
+
+	pdu->res2 = bsg_scsi_res2_build(status_byte(scmd->result),
+					driver_status, host_byte(scmd->result),
+					sense_len, scmd->resid_len);
+
+	/*
+	 * No sense to deliver: return the pool buffer now so other commands
+	 * can use it while this one waits for task work.  Task work only puts
+	 * when sense_buffer is still set.
+	 */
+	if (!sense_len && pdu->sense_buffer) {
+		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);
+		pdu->sense_buffer = NULL;
+	}
 
 	io_uring_cmd_do_in_task_lazy(ioucmd, scsi_bsg_uring_task_cb);
-	return RQ_END_IO_NONE;
+	return RQ_END_IO_FREE;
 }
 
 static int scsi_bsg_map_user_buffer(struct request *req,
@@ -115,8 +157,14 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	u32 dout_xfer_len = READ_ONCE(cmd->dout_xfer_len);
 	u64 din_xferp = READ_ONCE(cmd->din_xferp);
 	u32 din_xfer_len = READ_ONCE(cmd->din_xfer_len);
+	u64 response_addr = READ_ONCE(cmd->response);
+	u32 max_response_len = min_t(u32, READ_ONCE(cmd->max_response_len),
+				     SCSI_SENSE_BUFFERSIZE);
 	int ret;
 
+	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
+		return -EOPNOTSUPP;
+
 	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
 	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
 		return -EINVAL;
@@ -160,8 +208,32 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		goto out_free_req;
 	}
 
-	pdu->response_addr = cmd->response;
-	pdu->max_response_len = cmd->max_response_len;
+	pdu->response_addr = response_addr;
+	pdu->max_response_len = max_response_len;
+
+	/*
+	 * Sense bytes can only be delivered when the caller passed a
+	 * response buffer and a nonzero response length; a command without
+	 * both never snapshots sense, so it needs no pool buffer and cannot
+	 * be rejected for pool exhaustion.
+	 *
+	 * Take the buffer before mapping the user data buffer.
+	 * blk_rq_unmap_user() is not pure cleanup: for a bounce-mapped READ
+	 * it copies the zero-filled bounce pages back into the caller's
+	 * buffer, so a command rejected for pool exhaustion after mapping
+	 * would zero the caller's data before returning -EAGAIN.
+	 */
+	if (response_addr && max_response_len) {
+		pdu->sense_buffer =
+			bsg_uring_cmd_get_completion_buf(ioucmd,
+							 SCSI_SENSE_BUFFERSIZE);
+		if (!pdu->sense_buffer) {
+			ret = -EAGAIN;
+			goto out_free_req;
+		}
+	} else {
+		pdu->sense_buffer = NULL;
+	}
 
 	if (dout_xfer_len || din_xfer_len) {
 		bool is_write = dout_xfer_len > 0;
@@ -172,7 +244,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 					       gfp_mask, is_write, buf_addr,
 					       buf_len);
 		if (ret)
-			goto out_free_req;
+			goto out_put_buf;
 		pdu->bio = req->bio;
 	} else {
 		pdu->bio = NULL;
@@ -183,11 +255,13 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 
 	req->end_io = scsi_bsg_uring_cmd_done;
 	req->end_io_data = ioucmd;
-	pdu->req = req;
 
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
 
+out_put_buf:
+	if (pdu->sense_buffer)
+		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);
 out_free_req:
 	blk_mq_free_request(req);
 	return ret;
-- 
2.25.1


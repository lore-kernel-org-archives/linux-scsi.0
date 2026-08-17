Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A603B1B3;
	Mon, 17 Aug 2026 08:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954120; cv=none; b=gmh2lZR+BFpj32S1eUBcBbntfVm7RNhlNOABRpHF8QpCrLTo5ycCXUykoHhzgXo53pn7GdotmlNSkc0kNMsezzY74rMkkNl0mow2PWIlT5I+RcaMxhkPXiilPBlcx98gh5VvxuZ01PNnefXtg2bbH6Uj9A48m3Kpcs/wykFYF0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954120; c=relaxed/simple;
	bh=N1asHTRKCpcEnDNQlROeyRpfmEjSM+yGQ4uvlpZRL7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EV8VmqoPo3noLSRKyrxLuA9brEhwnMApuWKHnsOKP/6nohPwJUHrjezXrK7xHe4WzdyhczNDFzyhykvK1cFKD/hNWZFR47iqUNwui3jd4zurMrMkus02nbR/37TKCq2q6xavHGQ1vTR0R96rywlZVYQyPuD6TF++ZBMORJjCoeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bp3gSJwV; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bp3gSJwV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jB
	0Ii9VVJ36PDJ+rCQ20pEyAgsPYY4wT++RC7X4XDwo=; b=bp3gSJwVKWCo5/nq5O
	CnGaNdRhS+R6iu92eDby2z7DoNxHFz4Ff0guGfrwIGzG5wtwJCZKZEuTHQtUxQc0
	R68VRtlf5qxmEJ0DPDWikvgR+fHnw74rflGt3hY6lLl8MeeV8th0mJD6oToXSAW8
	RdmMDOvU7vmHnVd4RPSfuk610=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBnnvpFwYJqCVRqOA--.71S3;
	Mon, 17 Aug 2026 16:07:39 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	rc@rexion.ai,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/3] scsi: bsg: cap io_uring sense copy to max_response_len
Date: Mon, 17 Aug 2026 16:07:28 +0800
Message-Id: <20260817080730.967879-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
References: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnnvpFwYJqCVRqOA--.71S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxJry7tr1fJw17AF1UuFyxAFb_yoW8Zry5pF
	4rKw45ZrZ8Wr4IkrZrArWjvFyYy3Z5ua47KFWj9a43CryUAr9a93W0k3WIqFyrXrWIy3s8
	Xw4kKF4Yk3WjqwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7Z23UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Qu9TmqCwUteLgAA3D

Completion copied scmd->sense_len to the user response buffer without
honoring max_response_len. After a valid sense, the midlayer sets
sense_len to the real length (up to SCSI_SENSE_BUFFERSIZE), so a
smaller user buffer was overrun.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..b3c4b1063d6f 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -18,6 +18,7 @@ struct scsi_bsg_uring_cmd_pdu {
 	struct bio *bio;		/* mapped user buffer, unmap in task work */
 	struct request *req;		/* block request, freed in task work */
 	u64 response_addr;		/* user space response buffer address */
+	u32 max_response_len;		/* user response buffer size */
 };
 static_assert(sizeof(struct scsi_bsg_uring_cmd_pdu) <= sizeof_field(struct io_uring_cmd, pdu));
 
@@ -45,8 +46,8 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status = DRIVER_SENSE;
 		if (pdu->response_addr)
-			sense_len_wr = min_t(u8, scmd->sense_len,
-					     SCSI_SENSE_BUFFERSIZE);
+			sense_len_wr = min_t(unsigned int, pdu->max_response_len,
+					     scmd->sense_len);
 	}
 
 	if (sense_len_wr) {
@@ -155,8 +156,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	}
 
 	pdu->response_addr = cmd->response;
-	scmd->sense_len = cmd->max_response_len ?
-		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
+	pdu->max_response_len = cmd->max_response_len;
 
 	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
 		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
-- 
2.25.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257745;
	b=tFFkAPdg0VR8Gu0CAXK+mqrOpgsQf8s139ZBXnh7ngLsXpMq/O2dzN3dIO0iMszsTmbB
	 EQPMxnkRmxIu2/KkzDWDAz+aG/g4D95vTcsuqe1pCihqXHI0pqBGK8NdfBNBXjWDNb7/J
	 mfvaP08aiuaME0go4P1wTxYwDA8FwBbLew80ONVUEXOlw3m+MD3kC69Vkc6vPSPyQd2Lt
	 QtsY9kUJ9N4aaehMLrapVgM62f8tgWyInXVTDFYjXHKPkevdfiTTIig1jLlyQ4a+KqCFi
	 JP6P7yaPYb7ADPBAwxq1dRQpa5cjnFxiu1v+PI97+fxjfs1CV91bNm2sUjsBbDVelrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257745;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=/ChzfnrguZ/H1j3NAqG6KHPxUvTJUSYvVzUQIOYG/3o=;
	b=n2qDreWe/6EiUp+NHi/qaKWpsyqD8CnusEMAH8y8Em3VT1aZ+pKXzhY9Z5p36aAz3qru
	 oKn/weC2bFWbYzDKJpcS8D4gegyQ7Ipi0+fnrTrDvMKgpQdTTxewkMn9rEGm3b8yDZ9EY
	 OwFiaZM7ksW7PgXv37bvqT51Yuju5VcjUuGRhxRQczoR1t7WR04KByWmjIVcommk6aI2Y
	 3eiB5Qi9krv+uah926dPEIBsCvqeS2U7Bm7X1/j9SOxD/ErA20SgLNiksPZJVDhYRru8R
	 KR2ixurcebXOJxkBHDJfdZR1ncuon7Ujqrn8XHJM5cRz/KIFy/hj2vltV2qyL61BYWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fUtHDdYT;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377D9606A321
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:09:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 377D9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fUtHDdYT
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a086f5d91aso2468277b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793257744; x=1793862544; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/ChzfnrguZ/H1j3NAqG6KHPxUvTJUSYvVzUQIOYG/3o=;
        b=fUtHDdYTbr4K7eLAdZ3R7KNAhqOkxXUIkvORkUSs9hjc9OkEWcH62XXHqxEFozA2hB
         H4mDDdPA3ewNS+S3Fvhkr+83biOy2LwTNQM+jRf6DNL95FD2iFRwdw9N9z6q5Sk5XYUK
         vafLmAzlUqQq/DIheti4b40xpLbnsDbeHepfgSaTQqddEC1rrCC+cMtdnVSJPDw5x/AU
         J4johsDHur9BY3M51h8Oz3JJV2NEkgWApKBHHSrnGumhtA76a4NDo3WQ8S49LjpjOP6O
         6Hx5oHz0DYmsSvDs/cU0ICSVN1gq08QzqAbKaRs8qIIb2W1ZB1BJugi5gQU1EcN8E4Io
         W73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257744; x=1793862544;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ChzfnrguZ/H1j3NAqG6KHPxUvTJUSYvVzUQIOYG/3o=;
        b=t6y6XNRgeoibsMI1trFF36oZuAhwHed+isZpRf7BMyPtgv9T2Gv80S37JC+4AWmpHX
         1y0R5n5sU3FkWaW/xEGiXL3NUHFTyGoCudvLJn4YoNxUOk+QkKUskiv9jAIbKrQPwn1u
         yU+aykVSwpqVmbMHy3NSaNQ6GzxNTveeuNI2oBmUTYAY1yA+mi5o5dL2SoEJkiaIvCCC
         naALNZiV39byv96ULnTCq87Kxl8EqRFmFcwNHRQqHlNdqUYZr/suZQGFsqDNhI3vzw+2
         tCgfJh3PdpPIGT9AbohQuKcPexZOHOGAUUCPt4n2uYxSn7V7lRai9p6RQ6thaN6oNpBU
         wlmg==
X-Forwarded-Encrypted: i=1; AKwUvBx9TAIBqLyOkYE74M+6cg6wtq5n5O4egTFGv9wfykm8DkbaX2V/XtEJVVz7ycx8Jc3a/jcWC6T21ICI@vger.kernel.org
X-Gm-Message-State: AFq9FYIA6qqFaR7INb8p2lZSHuhGTeQd1Esh3YR4JssZ9Kcumr2qTjIS
	Qrb4gWk8hc+bx2B+VYijZos+XlMhkXuBn72qPQOs6bx17h0phe/NmQtiTqunnQh+tHjPKepexiN
	a8btlAMU7ViSjaBy+mSxB8w==
X-Received: from pffl11-n1.prod.google.com ([2002:a05:6a00:c34b:10b0:89e:78fd:6ab9])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:230a:b0:883:71f6:5fb with SMTP id d2e1a72fcca58-8a6e6348be0mr4187982b3a.13.1793257744383;
 Thu, 29 Oct 2026 00:09:04 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:09:02 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029040004.2100004-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: core: Skip completion of SCSI commands owned by
 the SCSI EH
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>
Cc: Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	John Garry <john.garry@linux.dev>, "Bao D . Nguyen" <quic_nguyenb@quicinc.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

1. A SCSI command times out. scsi_timeout() sets SCMD_STATE_COMPLETE
   and hands the command to the SCSI error handler.
2. The abort fails, so the error handler resets the LU and
   ufshcd_clear_lu_cmds() completes the cleared command.
3. ufshcd_compl_one_cqe() overwrites cmd->result with DID_REQUEUE.
4. scsi_eh_flush_done_q() only sets DID_TIME_OUT when cmd->result is
   zero. A command that may not be retried, such as an SG_IO
   command, is finished with DID_REQUEUE instead of DID_TIME_OUT.
5. If a retried command times out again, the DID_TIME_OUT set by
   scsi_timeout() is overwritten as well. sd_eh_action() then does not
   count the medium access timeout, so the disk is not taken
   offline, and a REQ_FAILFAST_DEV command is retried instead of
   failed fast.

Only release the LLD resources of such a command, since the SCSI error
handler owns it. Commands sent by scsi_send_eh_cmnd() reuse the
timed-out scsi_cmnd with SCMD_STATE_COMPLETE set and still complete
normally. Completions that arrive after the command was resubmitted
are not handled here.

Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..710d57bb4dbc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5987,6 +5987,22 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	ufshcd_clk_scaling_update_busy(hba);
 }
 
+/**
+ * ufshcd_cmd_owned_by_scsi_eh - Check if the SCSI EH owns @cmd
+ * @cmd: SCSI command pointer
+ *
+ * scsi_timeout() sets SCMD_STATE_COMPLETE before it hands a block-layer
+ * command to the SCSI EH. Commands from scsi_send_eh_cmnd() reuse such a
+ * scsi_cmnd with the bit still set and must still reach scsi_done().
+ *
+ * Return: true if the SCSI EH owns @cmd.
+ */
+static inline bool ufshcd_cmd_owned_by_scsi_eh(struct scsi_cmnd *cmd)
+{
+	return cmd->submitter == SUBMITTED_BY_BLOCK_LAYER &&
+	       test_bit(SCMD_STATE_COMPLETE, &cmd->state);
+}
+
 /**
  * ufshcd_compl_one_cqe - handle a completion queue entry
  * @hba: per adapter instance
@@ -6009,6 +6025,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		lrbp->compl_time_stamp_local_clock = local_clock();
 	}
 	if (ufshcd_is_scsi_cmd(cmd)) {
+		if (unlikely(ufshcd_cmd_owned_by_scsi_eh(cmd))) {
+			ufshcd_release_scsi_cmd(hba, cmd);
+			return;
+		}
 		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
 			ufshcd_update_monitor(hba, cmd);
 		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);

base-commit: 503e6172fa74da6b4944ece458f5534681e51d21
-- 
2.56.0.313.g2479322e68-goog


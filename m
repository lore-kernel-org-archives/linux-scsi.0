Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B9E305691
	for <linux-scsi@vger.kernel.org>; Sun,  2 Aug 2026 23:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785711649; cv=none; b=EOAqO7ifcDiUXCVsIErpBB4oVRsBOogDUNeLThBrkwJgt6sKmiRl1btWJ1b1qABKHLDoUJ9BegJoHjew12jWJy6tY3guY31Kv18SJTwSmTFxE8Ixmx9cDDifG+qQJsd+HFabCkSRojodqDhVGzyFc4AhzMyeuZmU7Vdqj4NTmAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785711649; c=relaxed/simple;
	bh=m/m7KTgKi/LcyP+eWbddXArCStEzIKmA1HvhZGlEyD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bygHjDExlPxwr9ZjDu3t+oc364Q42Bw40dcS2hBlSBsS1n3FZdRTxZU8Mr0oADsOx8idbiyyJQmUa9BenAfTYQJaXQUYdNTdsJjaelyHDzGtDPFYA36Mdhrb65TvCai6Wu4UcStXKWBLql835AfYlLqAd1VKdwbeE0EhAgXWroI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EUx4n9zh; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUx4n9zh"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-517dc520840so19179301cf.3
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2026 16:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785711645; x=1786316445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vxrln7BIlezN0ZqkL6mqHcDhzTt4gD/8fw46+cxfpnI=;
        b=EUx4n9zhF1rAOYlWMumejEpoOOoIEIz9GlPSOUOWN5LziajEXRM6bDk3gKBRe+fSyC
         ME/D0xWQF5XbzIxZk8/NewHza/+jwHAZClawEKw2P9/n9Q7cGsESXRFcgbO81l4TS01/
         rVlitW7Zu5Tno+2v+e4MFmbIDaXMZOhFgux1UDX5UBlFIFmiULkiZsIrmFb06KLknwRN
         RItluXKwr8a4MUXTnOPZ2pOB17ZujHtK4gSDOozXiB8cDbxkH2B8O89XmyaMD+lyNeR4
         5gGH+b4NmgrkFktJ7XKPNO/h0xCe4IfeeyWBXU40SPnGlgonCvx8B4FjN8gftPmtML7G
         vm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785711645; x=1786316445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vxrln7BIlezN0ZqkL6mqHcDhzTt4gD/8fw46+cxfpnI=;
        b=TWjV6auPrYv4H3z/Ebt92bY0Dg7mwz8lNM9EFkvxKxQSCAw4z9DZL1o31bTcJtOPAX
         7rMmcd6pkws17Qjo2MBrc6/T6Awm19lvAO26ncHq3eGT87tAiD/Z0+dTIGuPIZBVR6uR
         mX5HH08zZ5hqbS88xxvbNfRZTb+D4i6EwKbmzripphSkLjLDKX1mxF9EpQ3dZPORZdir
         uCJZ5OhyX04c5m3oNfULBUF6BA2Nm46GrucVnFNMgcHvWfHExru8WAWMsLcg2LH/FchV
         BDVVNgmEllADuRmTFyG43ef1BWxWJNyoP9i1RzO2tiQbkKb9qTdjFosxQL23owDnu/ap
         h9yg==
X-Gm-Message-State: AOJu0YypVyL6PCu9pWxCvzmuRsfgRo18umO8AFwO+/2PbNZ12icwKRtK
	OgSNLSmYlFV8EdSeu6QW/vXv4cYKi/Y3ID7pg1QG+jOfEsjIbbX44Cc80eGGX/qar0c=
X-Gm-Gg: AR+sD11LbO424XUW7aMRK+R0s3R/n+fDqpN7zItUB5DlHBkFPQVKz2M2HflaygKEA5O
	JD32tBb+zv9IQmDEQirdDgX10l8C9/cXfknKRW9Bo+GUR/DkyTqWSsc/OCjOUSIKabe9E201W7h
	YejT094tKq3sHmk8B1NzijvLgN0oUQJkRGTKr6PKYX8S21va/UGn2TnsupghVy5NLNbLbuc1tWV
	SPVmfVQBp2UuHA0r/CW+j+tpGvLCAEFYwGuFTBtM754hb3Qmf8XHBqKach13mDIRA0wGzxZhvkF
	A0M7Q+tH4uSvVeMLsfXOHMsgLYz0zjI68YSpeDUg7xc6X+ygNOQEO+xjhL7kIY9zatogSyndva1
	FzjoonnwDeyqiw1mbwiaXzuBfc4JwXZ2E2S5yZeQwtlDUysd9KRJ6UfRxNKmT32JfznUqjf21C5
	MrK2SHHTYoKXARK12RyS8FwUYLOJScVSvUXixQlyEDW/8kINOz7BmELwSctUw7dSumkfXLQCmxB
	r2JHNnxfIoChQLhnuf2wZHlnQUikjR6TvN/RjBhDDqkYFoofDRLaG2GnA35jDA=
X-Received: by 2002:a05:622a:40c6:b0:517:5bc1:e1f0 with SMTP id d75a77b69052e-52b56521469mr168643111cf.0.1785711645310;
        Sun, 02 Aug 2026 16:00:45 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm61606316d6.38.2026.08.02.16.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 16:00:43 -0700 (PDT)
From: Yuho Choi <dbgh9129@gmail.com>
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <dbgh9129@gmail.com>
Subject: [PATCH v1] scsi: qla2xxx: Cancel qpair work before freeing queues
Date: Sun,  2 Aug 2026 19:00:39 -0400
Message-ID: <20260802230039.586918-1-dbgh9129@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The qpair response interrupt handler queues q_work with qpair as its
context. qla2xxx_create_qpair() frees qpair on setup failure after deleting
the response queue, but does not cancel work queued before the failure.
qla2xxx_delete_qpair() has the same ordering issue.

Mark the qpair as being deleted and cancel its work before deleting the
request and response queues and freeing qpair.

Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e746c9274cde..d5cd33e84720 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -10001,10 +10001,16 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 	return qpair;
 
 fail_bufpool:
-	mempool_destroy(qpair->srb_mempool);
 fail_mempool:
-	qla25xx_delete_req_que(vha, qpair->req);
 fail_req:
+	qpair->delete_in_progress = 1;
+	if (qpair->srb_mempool) {
+		mempool_destroy(qpair->srb_mempool);
+		qpair->srb_mempool = NULL;
+	}
+	if (qpair->hw->wq)
+		cancel_work_sync(&qpair->q_work);
+	qla25xx_delete_req_que(vha, qpair->req);
 	qla25xx_delete_rsp_que(vha, qpair->rsp);
 fail_rsp:
 	mutex_lock(&ha->mq_lock);
@@ -10028,6 +10034,8 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	struct qla_hw_data *ha = qpair->hw;
 
 	qpair->delete_in_progress = 1;
+	if (qpair->hw->wq)
+		cancel_work_sync(&qpair->q_work);
 
 	qla_free_buf_pool(qpair);
 
-- 
2.43.0


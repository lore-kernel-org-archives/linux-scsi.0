Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EE933439A;
	Tue, 21 Apr 2026 13:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776777593; cv=none; b=vFo6vbKnQe5uxauqtU7TXyEzIcHnYSgBN4lDfHc2jevNRzsGLA563kkUJW3ZemEU78Yy2rD14fupFf0aeAXlCQ2H2+e1jNEFNUr1dMNCVKHqzBlOtL22ZJ1R225nnMO9AfLtM0ZJZ1Y0PMl4seX1XqC9V3yJkbFW4nCEA05C55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776777593; c=relaxed/simple;
	bh=K/3Rtss0cj0W3VV1itd+ogpDFeURPUIgkeGJIgPQQes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M/71JShhH97STYvgYToUXzO52bGkyzBp7tTscsgftC+zqP3an6NQMpTvondDrjavoY8GFGDAVxTVlHPRLHqFnRgZ3IiH+jwwORZI1uiFHQHrwce3cLzOynfC8r50vza0LFJjfrXmb9cY13Rg8t2A0uM6bm5c99Zw+sMOPqDSDbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id CD8662338E;
	Tue, 21 Apr 2026 16:19:41 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: stable@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH 5.10.y] scsi: ufs: core: Improve SCSI abort handling
Date: Tue, 21 Apr 2026 16:19:41 +0300
Message-Id: <20260421131941.38176-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

commit 3ff1f6b6ba6f97f50862aa50e79959cc8ddc2566 upstream.

The following has been observed on a test setup:

WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737 ufshcd_queuecommand+0x468/0x65c
Call trace:
 ufshcd_queuecommand+0x468/0x65c
 scsi_send_eh_cmnd+0x224/0x6a0
 scsi_eh_test_devices+0x248/0x418
 scsi_eh_ready_devs+0xc34/0xe58
 scsi_error_handler+0x204/0x80c
 kthread+0x150/0x1b4
 ret_from_fork+0x10/0x30

That warning is triggered by the following statement:

	WARN_ON(lrbp->cmd);

Fix this warning by clearing lrbp->cmd from the abort handler.

Link: https://lore.kernel.org/r/20211104181059.4129537-1-bvanassche@acm.org
Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ kovalev: bp to fix CVE-2021-47188; adapted placement of
  lrbp->cmd = NULL for 5.10 function structure ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c7bf0e6bc303..1b8072f47e7e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6788,6 +6788,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		__ufshcd_transfer_req_compl(hba, (1UL << tag));
 		spin_unlock_irqrestore(host->host_lock, flags);
 out:
+		lrbp->cmd = NULL;
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
-- 
2.50.1


Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D9A1A315A
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2025 20:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748031278; cv=none; b=WUiae5Pi8bwtfbmLN3fIKHcGa/DjbRnbLRPPYZ+G/fEhpGCkdMFNb0aecXagZ/9DNaNbT7qErLev/kao6wzpsmj1aUkGAVfwj0GS5Uj+HapuItTHoqS7m2j6vr0y1sGrGXMncdWQUKEly+iPglkopXMOMgCS1AIVMWasi6j9Ruc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748031278; c=relaxed/simple;
	bh=muiiH3BzynTaFQm3RJp0l/XCUUGb+/JN9CI/r9tsYa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bXXFbdwPKA4WI3Fw614fB5UXPG90x4ClKmw5sdt9X3vYFOujByaw6EaqpVFVSLsiJJ/p6/DSiEudFMXFgFYPUhkUwNtztQl60YjZxdCWc7kRPheOrt2f4km/9avXTAQLQPAnQ4frrnFUM/Zdd1dvnHtvQJJ+JflPlX2K7afS+eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=I0jmy5np; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="I0jmy5np"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b3xG212fFzm10gT;
	Fri, 23 May 2025 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1748031271; x=1750623272; bh=QstXYPBlIKP0j6Mzyp1T5D/zMV9d9wBtZSD
	HG3ZRI84=; b=I0jmy5npSTguLn2dWSIh47X9xDuQQmt5DvTeX5JmFUBYkM1DTTz
	Mx2JYfzMQ07jciOsKfYrlkZvxpLru6QYZEAgXwl3V6FNvi2iaV8gAjun3046OcKP
	ynr2lsjVAknk0xCTkkY0cUuHlXQmft7Bcmm16Ufc5ost12qFM+vdRmASHJ5O5v3M
	zAF/ROIHwAb/kAR0JvZflUU10Unx9vU6qf7zwCAIYjh0pcIcJU4UO4YoS3RJEXl6
	cXuBBfLy0WHYQwUSu/PXjMcsgENHs3IWt/Twve7HvNUrLskNJGbomFQ8l5fyX9nA
	7w+ldYKpToElw3v0WnwDZyqyJH4KR+CZP/w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TpzZZ4QrtTqc; Fri, 23 May 2025 20:14:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b3xFq0ndBzm0gbn;
	Fri, 23 May 2025 20:14:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Sanjeev Yadav <sanjeev.y@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Santosh Y <santoshsy@gmail.com>
Subject: [PATCH] scsi: core: ufs: Fix a hang in the error handler
Date: Fri, 23 May 2025 13:14:01 -0700
Message-ID: <20250523201409.1676055-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Sanjeev Yadav <sanjeev.y@mediatek.com>

ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync(). The latter
function can only succeed if UFSHCD_EH_IN_PROGRESS is not set because
resuming involves submitting a SCSI command and ufshcd_queuecommand()
returns SCSI_MLQUEUE_HOST_BUSY if UFSHCD_EH_IN_PROGRESS is set. Fix
this hang by setting UFSHCD_EH_IN_PROGRESS after
ufshcd_rpm_get_sync() has been called instead of before.

Backtrace:
__switch_to+0x174/0x338
__schedule+0x600/0x9e4
schedule+0x7c/0xe8
schedule_timeout+0xa4/0x1c8
io_schedule_timeout+0x48/0x70
wait_for_common_io+0xa8/0x160 //waiting on START_STOP
wait_for_completion_io_timeout+0x10/0x20
blk_execute_rq+0xe4/0x1e4
scsi_execute_cmd+0x108/0x244
ufshcd_set_dev_pwr_mode+0xe8/0x250
__ufshcd_wl_resume+0x94/0x354
ufshcd_wl_runtime_resume+0x3c/0x174
scsi_runtime_resume+0x64/0xa4
rpm_resume+0x15c/0xa1c
__pm_runtime_resume+0x4c/0x90 // Runtime resume ongoing
ufshcd_err_handler+0x1a0/0xd08
process_one_work+0x174/0x808
worker_thread+0x15c/0x490
kthread+0xf4/0x1ec
ret_from_fork+0x10/0x20

Signed-off-by: Sanjeev Yadav <sanjeev.y@mediatek.com>
[ bvanassche: rewrote patch description ]
Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host con=
troller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 34a499b19480..b43dd1f88fbc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6530,9 +6530,14 @@ static void ufshcd_err_handler(struct ufs_hba *hba=
)
 		up(&hba->host_sem);
 		return;
 	}
-	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	ufshcd_err_handling_prepare(hba);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_set_eh_in_progress(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba, false);
 	spin_lock_irqsave(hba->host->host_lock, flags);

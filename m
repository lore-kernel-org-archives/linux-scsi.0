Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E249623BD1B
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796003; cv=none; b=SVvh2+pWmqi3MMYFGM7hSTFcXdvEtwoxy2yBG7OKLaRxnH8j0eWQuS/GyAsK7HCPbimF907Q8wppWKYhuEMUy2gRzjq1R45JYsZOwaNT43rGAV7icP/gJA8kogW/c096ZQZxi7meARastHNoYJ9nJnYD0gEDtzK07hz9Cm1qjG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796003; c=relaxed/simple;
	bh=fh2CqEI6TDbfKsLN8wHepvnZv5jdUHrDJM27EN/ehiA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QH9Cap8e/S5F4gydVU72R4p5DVaaqQI/3F47qOenTNR2fu7vpAwC1bC6q2bwQXdK2FdqgAg32I4wLB1/yLDvVjODYcLS9xLVrYH4srJXP1Gt/eURQpSS8GAqZ359JnC7QWWaVduP11+oOt+j9zo8Q7jxjQCJB8a5JBHEc7dlPbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DDDEJsWP; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DDDEJsWP"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bRbjr5Tv3zlgqVb;
	Tue, 24 Jun 2025 20:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1750795998; x=1753387999; bh=w1fxkDy76vqFyH4r65jsnRoQvvBqdfcN6bp
	vlFbfkMw=; b=DDDEJsWPQ4RdJUEBv/Fh3ZctDapLlh0Sox4xJ98gVgNG7oTL0Fe
	YSlvNPNcLxZurbTLhuTfJYoWSVMDPneSG0DF8YrQ5DbcnruVwdrV3HNS2U/fqSNX
	7A/WeV/paWYPnE6B2gd/wZrvQ9gM8C0jmRFmnp7MVyowaSulB57ODZBMIdVe+/2E
	h6NHdX3+Jwi8bQpxjYff3pD0UVFN+NS0gLtiJxlXmqKwxRnAUUroeEMhH9NhkTPP
	zyHQwtv8K6kfeUA43r3dPQ7uoea/NAJyvNCARoHZdQDljI0EpEEii2jip713hbUb
	d0opppwqfCUxBBCStlrWS/3ZIRj5d9qUb4A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8p236RIKAJAD; Tue, 24 Jun 2025 20:13:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bRbjg18DWzlgqVM;
	Tue, 24 Jun 2025 20:13:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH] scsi: ufs: Make ufshcd_clock_scaling_prepare() compatible with MCQ
Date: Tue, 24 Jun 2025 13:12:44 -0700
Message-ID: <20250624201252.396941-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufshcd_clock_scaling_prepare() only supports the lecagy doorbell mode and
may wait up to 20 ms longer than necessary. Hence this patch that reworks
ufshcd_clock_scaling_prepare(). Compile-tested only.

Cc: Can Guo <quic_cang@quicinc.com>
Fixes: 305a357d3595 ("scsi: ufs: core: Introduce multi-circular queue cap=
ability")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 162 +++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 98 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b3fe4335d56c..c8eb5bf65e22 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1248,87 +1248,6 @@ static bool ufshcd_is_devfreq_scaling_required(str=
uct ufs_hba *hba,
 	return false;
 }
=20
-/*
- * Determine the number of pending commands by counting the bits in the =
SCSI
- * device budget maps. This approach has been selected because a bit is =
set in
- * the budget map before scsi_host_queue_ready() checks the host_self_bl=
ocked
- * flag. The host_self_blocked flag can be modified by calling
- * scsi_block_requests() or scsi_unblock_requests().
- */
-static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
-{
-	const struct scsi_device *sdev;
-	unsigned long flags;
-	u32 pending =3D 0;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	__shost_for_each_device(sdev, hba->host)
-		pending +=3D sbitmap_weight(&sdev->budget_map);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	return pending;
-}
-
-/*
- * Wait until all pending SCSI commands and TMFs have finished or the ti=
meout
- * has expired.
- *
- * Return: 0 upon success; -EBUSY upon timeout.
- */
-static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
-					u64 wait_timeout_us)
-{
-	int ret =3D 0;
-	u32 tm_doorbell;
-	u32 tr_pending;
-	bool timeout =3D false, do_last_check =3D false;
-	ktime_t start;
-
-	ufshcd_hold(hba);
-	/*
-	 * Wait for all the outstanding tasks/transfer requests.
-	 * Verify by checking the doorbell registers are clear.
-	 */
-	start =3D ktime_get();
-	do {
-		if (hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL) {
-			ret =3D -EBUSY;
-			goto out;
-		}
-
-		tm_doorbell =3D ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-		tr_pending =3D ufshcd_pending_cmds(hba);
-		if (!tm_doorbell && !tr_pending) {
-			timeout =3D false;
-			break;
-		} else if (do_last_check) {
-			break;
-		}
-
-		io_schedule_timeout(msecs_to_jiffies(20));
-		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
-		    wait_timeout_us) {
-			timeout =3D true;
-			/*
-			 * We might have scheduled out for long time so make
-			 * sure to check if doorbells are cleared by this time
-			 * or not.
-			 */
-			do_last_check =3D true;
-		}
-	} while (tm_doorbell || tr_pending);
-
-	if (timeout) {
-		dev_err(hba->dev,
-			"%s: timedout waiting for doorbell to clear (tm=3D0x%x, tr=3D0x%x)\n"=
,
-			__func__, tm_doorbell, tr_pending);
-		ret =3D -EBUSY;
-	}
-out:
-	ufshcd_release(hba);
-	return ret;
-}
-
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
@@ -1391,36 +1310,86 @@ static int ufshcd_scale_gear(struct ufs_hba *hba,=
 u32 target_gear, bool scale_up
  * Return: 0 upon success; -EBUSY upon timeout.
  */
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout=
_us)
+	__cond_acquires(hba->host->scan_mutex)
+	__cond_acquires(hba->wb_mutex)
+	__cond_acquires(hba->clk_scaling_lock)
 {
-	int ret =3D 0;
+	const unsigned long deadline =3D jiffies + usecs_to_jiffies(timeout_us)=
;
+	struct Scsi_Host *host =3D hba->host;
+	struct scsi_device *sdev;
+	long timeout;
+
 	/*
-	 * make sure that there are no outstanding requests when
-	 * clock scaling is in progress
+	 * Hold scan_mutex to prevent that SCSI devices are added or removed
+	 * while this function is in progress.
 	 */
-	mutex_lock(&hba->host->scan_mutex);
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	mutex_lock(&host->scan_mutex);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
+	/* Call ufshcd_hold() to serialize clock gating and clock scaling. */
+	ufshcd_hold(hba);
=20
 	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
-		ret =3D -EBUSY;
-		up_write(&hba->clk_scaling_lock);
-		mutex_unlock(&hba->wb_mutex);
-		blk_mq_unquiesce_tagset(&hba->host->tag_set);
-		mutex_unlock(&hba->host->scan_mutex);
+	    hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL)
 		goto out;
+
+	blk_freeze_queue_start(hba->tmf_queue);
+	shost_for_each_device(sdev, host)
+		blk_freeze_queue_start(sdev->request_queue);
+
+	/*
+	 * Calling synchronize_*rcu_expedited() reduces the wait time from
+	 * milliseconds to less than a microsecond. See also
+	 * https://paulmck.livejournal.com/67547.html.
+	 */
+	if (host->tag_set.flags & BLK_MQ_F_BLOCKING)
+		synchronize_srcu_expedited(host->tag_set.srcu);
+	else
+		synchronize_rcu_expedited();
+
+	timeout =3D deadline - jiffies;
+	if (timeout <=3D 0 ||
+	    blk_mq_freeze_queue_wait_timeout(hba->tmf_queue, timeout) <=3D 0)
+		goto unfreeze;
+	shost_for_each_device(sdev, host) {
+		timeout =3D deadline - jiffies;
+		if (timeout <=3D 0 ||
+		    blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
+						     timeout) <=3D 0) {
+			goto unfreeze;
+		}
 	}
=20
-	/* let's not get into low power until clock scaling is completed */
-	ufshcd_hold(hba);
+	return 0;
+
+unfreeze:
+	blk_mq_unfreeze_queue_nomemrestore(hba->tmf_queue);
+	shost_for_each_device(sdev, host)
+		blk_mq_unfreeze_queue_nomemrestore(sdev->request_queue);
+
+	dev_err(hba->dev, "%s timed out\n", __func__);
=20
 out:
-	return ret;
+	ufshcd_release(hba);
+	up_write(&hba->clk_scaling_lock);
+	mutex_unlock(&hba->wb_mutex);
+	mutex_unlock(&host->scan_mutex);
+
+	return -EBUSY;
 }
=20
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
+	__releases(hba->host->scan_mutex)
+	__releases(hba->wb_mutex)
+	__releases(hba->clk_scaling_lock)
 {
+	struct scsi_device *sdev;
+
+	blk_mq_unfreeze_queue_nomemrestore(hba->tmf_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue_nomemrestore(sdev->request_queue);
+
+	ufshcd_release(hba);
 	up_write(&hba->clk_scaling_lock);
=20
 	/* Enable Write Booster if current gear requires it else disable it */
@@ -1428,10 +1397,7 @@ static void ufshcd_clock_scaling_unprepare(struct =
ufs_hba *hba, int err)
 		ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >=3D hba->clk_scaling.wb_g=
ear);
=20
 	mutex_unlock(&hba->wb_mutex);
-
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	mutex_unlock(&hba->host->scan_mutex);
-	ufshcd_release(hba);
 }
=20
 /**

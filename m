Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794460559;
	b=ghMFck09FBKmmfPdJ0FyjPEX3qDXVCwyD5M1FRe7gcnC8cQnPKgdlTrlgYQ8Gt9PZOK0
	 LVTFdA30qZoog2Q8JJcBz4QpbvxWJYqsMrDdqPMsKcBelT4lZe6iaVSw2vUbMjEpZyJk7
	 y8X7CB8G5jOay0zEeaoJ5RlLqPu/eHGAohC5rtrl0opzK5rIJvgovCG6igjf2mb84Xr7k
	 ka3Y4hD/AORXntC+9L32MNayGb4zmR7ZwT0sJ0gzvaSGILanEL7o2noI6IG6qG8d3Ef8U
	 BYuqmYeAy4h+wd2eyxtK37XvyI7dEXsBshDd1d/L2XWfByQ3JOGJU6y6kT4vqmHdGmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794460559;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=N+HgnkkymV/qrktUNyVm3RT+UUMj6FmudRG62GmKRrY=;
	b=mWiajVpyLGvWfFpUK0ZT/uj270kkXfP8c2QjaFUsAzPazdwZWp9bZvf1tz7R8Z4cHIXf
	 3Fzw9K/Cd1W4lddk7pCHm+S32BoxRM6LUfp8OaGjJLlldhSERWXabJDZ9jvDcjRXPXi2i
	 X8s+Pzv5LKZeBNPtrmqU+iXRqlKL4KLyb+thntFhHH8guvllKYq5l4O8R6xkG1lpAVHSB
	 b6ecF7dvZE3XuyKDS998wbE5xCqRlHiWofZt2qWHGQaPXFolQtJFo6KpCnA0KASYSoWiD
	 dU1eIEFfad5DzSc6+0hu/g5z1l0/pAKUXxOxauT5sYTA3kJ61cKXVB8WiAyVlkOda7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d4BkTQ4R;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325F60A2612
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C325F60A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d4BkTQ4R
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8b691cf0eeaso5183828b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 21:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794460558; x=1795065358; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N+HgnkkymV/qrktUNyVm3RT+UUMj6FmudRG62GmKRrY=;
        b=d4BkTQ4RObiVbBdQXjh7UURMch9jnhUrXWq6ZWWvVjbiKCXzumVMhfg8thdReRkhlR
         naHFtBrwjte4sGfml9TbgNWZ5Zh355GptcK+7qXzj8PY5hb4C0v6pwtgSuPjfgJwW1SC
         5y7fKAfmyvKXd63uysJl3QcqRwlX//FpZxOqnBXcFET4kZymQJ4pG81zUb9bzxZVqWd/
         xN7pSponFzaYsPHUUSDNQ8s0MZzDRRn8YjgVfzeb0viJFLN3/eGYjUe0mDV70bW3Y9Vh
         GbBzJ/am3ea526oN5QnLlALl7tc7pDI5mw9owhlFcexTpP3IFf74BJjY5E42Ycx3Iycc
         XH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794460558; x=1795065358;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N+HgnkkymV/qrktUNyVm3RT+UUMj6FmudRG62GmKRrY=;
        b=YLdww15AsqrawALq7ZRdKkRG4HorV27SHYgfIt95S0q9qQdecltW+Qbrh74wIQRW9l
         F3yBIcIaBPaAqvzwkrGElvJ9+EZXG2mcGT8rwwJ83buG9/rQsyYM9rngXDmGo2I8fbSb
         m8Nx5XWftOgsdP4j9OlECkxQ5YfdllIfzAUBjuHi3WIZj+GnUG+/LBK+5Pp183xtkBhB
         aSwIN2YcBPeMLr4P7yaN+aGiTTUqAoahwVLbJM54t2qrkzXnqGLd8A+6Y2bbQfkCLByR
         0clt1vENuCqupLMdDprXAYyy7sBJ1vyBdxoQeyijrhCvgluZvlirAotvYX4s0Qb5RcR4
         vPAg==
X-Gm-Message-State: APuU4Z86FHk2ZAtlR0aPjRemCk9p4UGdjguN8LBu6q9FqU1uCXZWz93a
	2Ni3hnF8bnwdusWc8/R0C0bdb51DTkP81zx7XjGUDpGyqDlalwXK9L5yL/9PoXK+GJakEshYxMV
	rCs4VUGumKpBpKDFikgDIb00afithzJmhhzP4l4HW6MRbBz1ADduEmuuX38DZqYeLg4FGUw9jVL
	jyZTKcNuduYlyAIoifo1gR7T8WMgAAqom8Cr+WW/C7fcpPBH6KXny6a3VfndjNNp8=
X-Received: from pfbk10.prod.google.com ([2002:a05:6a00:b00a:b0:8b6:3f11:2ac5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4148:b0:89d:7d72:3433 with SMTP id d2e1a72fcca58-8bc1bae9a10mr4699352b3a.21.1794460557863;
 Wed, 11 Nov 2026 21:15:57 -0800 (PST)
Date: Thu, 12 Nov 2026 13:15:38 +0800
In-Reply-To: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112051542.1539779-6-stanleyjhu@google.com>
Subject: [PATCH 5/9] scsi: ufs: core: Disable W-LUN runtime PM in ufshcd_err_handling_prepare()
From: Stanley Jhu <stanleyjhu@google.com>
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>, 
	Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Brian Kao <powenkao@google.com>, Jens Axboe <axboe@kernel.dk>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync() to power up
the host. Since commit eef1d74bf88f ("PM: runtime: Only set
runtime_error on suspend callback failures"), a failed W-LUN resume no
longer sets runtime_error, so this call runs the W-LUN resume again:

1. A request to a runtime-suspended logical unit resumes its W-LUN
   supplier, and __ufshcd_wl_resume() sends START STOP UNIT.
2. A fatal error sets UFSHCD_STATE_EH_SCHEDULED_FATAL, and
   ufshcd_queuecommand() fails START STOP UNIT with DID_BAD_TARGET.
3. sdev_runtime_resume() fails and clears pm_only on the W-LUN queue
   while rpm_resume() leaves the W-LUN RPM_SUSPENDED.
4. ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync() while the
   state is still UFSHCD_STATE_EH_SCHEDULED_FATAL. START STOP UNIT
   fails the same way, and blk_clear_pm_only() underflows pm_only
   to -1.

Instead, have the error handler power up the host itself by taking
ufshcd_rpm_get_noresume() and disabling W-LUN runtime PM in
ufshcd_err_handling_prepare(), then re-enabling it in
ufshcd_err_handling_unprepare(). Not resuming the W-LUN in
ufshcd_err_handling_prepare() needs two more changes.

First, force a host reset when the W-LUN is runtime suspended. On a
non-fatal UIC error with the link active in runtime suspend, a logical
unit resuming during error handling ignores the disabled W-LUN.
Skipping reset then leaves the device asleep, and I/O after unquiesce
fails with NOT READY.

Second, block non-W-LUN commands before blk_mq_quiesce_tagset() freezes
the queues. Once W-LUN runtime PM is disabled, another logical unit
resuming in that gap ignores the disabled W-LUN and sends commands that
hit a sleeping device or fail with DID_BAD_TARGET. Add
UFSHCD_EH_WLUN_FENCE to return SCSI_MLQUEUE_HOST_BUSY for non-W-LUN
commands while letting in-flight W-LUN PM commands finish.

Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend callback failures")
Cc: stable@vger.kernel.org # 7.3.x
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5563d28ef92e..7e3f9abc7e7c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -215,6 +215,7 @@ static const char *const ufshcd_state_name[] = {
 /* UFSHCD error handling flags */
 enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
+	UFSHCD_EH_WLUN_FENCE = (1 << 1),
 };
 
 /* UFSHCD UIC layer error flags */
@@ -235,6 +236,13 @@ enum {
 #define ufshcd_clear_eh_in_progress(h) \
 	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
 
+#define ufshcd_set_eh_wlun_fence(h) \
+	((h)->eh_flags |= UFSHCD_EH_WLUN_FENCE)
+#define ufshcd_eh_wlun_fence(h) \
+	((h)->eh_flags & UFSHCD_EH_WLUN_FENCE)
+#define ufshcd_clear_eh_wlun_fence(h) \
+	((h)->eh_flags &= ~UFSHCD_EH_WLUN_FENCE)
+
 const struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
 	[UFS_PM_LVL_0] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
 	[UFS_PM_LVL_1] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
@@ -3134,12 +3142,19 @@ static enum scsi_qc_status ufshcd_queuecommand(struct Scsi_Host *host,
 		 * UFSHCD_STATE_EH_SCHEDULED_NON_FATAL. Prevent requests
 		 * being issued in that case.
 		 */
-		if (ufshcd_eh_in_progress(hba)) {
+		if (ufshcd_eh_in_progress(hba) ||
+		    (ufshcd_eh_wlun_fence(hba) &&
+		     cmd->device != hba->ufs_device_wlun)) {
 			err = SCSI_MLQUEUE_HOST_BUSY;
 			goto out;
 		}
 		break;
 	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
+		if (ufshcd_eh_wlun_fence(hba) &&
+		    cmd->device != hba->ufs_device_wlun) {
+			err = SCSI_MLQUEUE_HOST_BUSY;
+			goto out;
+		}
 		/*
 		 * pm_runtime_get_sync() is used at error handling preparation
 		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
@@ -6899,7 +6914,8 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	 * runtime suspended, so take an extra reference on hba->dev.
 	 */
 	pm_runtime_get_sync(hba->dev);
-	ufshcd_rpm_get_sync(hba);
+	ufshcd_rpm_get_noresume(hba);
+	__pm_runtime_disable(&hba->ufs_device_wlun->sdev_gendev, false);
 	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
 	    hba->is_sys_suspended) {
 		enum ufs_pm_op pm_op;
@@ -6943,6 +6959,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
+	pm_runtime_enable(&hba->ufs_device_wlun->sdev_gendev);
 	ufshcd_rpm_put(hba);
 	pm_runtime_put(hba->dev);
 }
@@ -7146,6 +7163,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 		up(&hba->host_sem);
 		return;
 	}
+	ufshcd_set_eh_wlun_fence(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	ufshcd_err_handling_prepare(hba);
@@ -7166,6 +7184,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 		hba->ufshcd_state = UFSHCD_STATE_RESET;
+	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev))
+		hba->force_reset = true;
 	/*
 	 * A full reset and restore might have happened after preparation
 	 * is finished, double check whether we should stop.
@@ -7295,6 +7315,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 			goto again;
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
 	}
+	ufshcd_clear_eh_wlun_fence(hba);
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
-- 
2.56.0.567.gdb80ae8cd5-goog


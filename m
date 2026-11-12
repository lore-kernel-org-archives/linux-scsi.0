Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794460551;
	b=zOMk9zwiKBe2WhXEzC/ZIe2DMwPpKBAnw44se1qDslj4UwbPCclXMzT740bYv0XxL3gH
	 WMEV7O7WUaCVS5uk76QSHOQSb7S4pRxV1oWqcI/6CZivAGXUVVXCqbLU27Vb2JNh+kYU0
	 wJCQhGC9sTaFpQlavhaEwJIYypydUlAaPIPBR1dKjCMZT/hjHNfC7UnjmcPUD0kVRWEUi
	 u8v/4pHxoJZfUPL4pvxDRdUlRA5a4zN8VNaelwLng3wpU4tl8ranE/K+kouzZDIX6x0me
	 0f2Px4DQ/3vOnth6NExMRy0oWbvWfgu7IYtTdtvcf9t+gUD3rWYMydOF0NnRh4uQgrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794460551;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=oOfImB3qy0T90q2O/tjXznngWxo1sLRzTsMD5yze5WY=;
	b=FfW8k5I0g4tQ8VDE2UWpeLxDd0GDJDYD30E0fO4FLteRtqbIPTuFQ+FnF4oi1kZR80O+
	 6sUv4UvEJtsKWPM4UFn3XPDUeS6+iwj753xyB1qOonW2B0bXcvcgtDST+5HndpoqCRXe7
	 k9QgbDIl7qTnS/xi63yansZCj4CKQlIfxMsR/LcNG6OHsaOmD6nvIp3gw4eRSSjgEdrqU
	 VIpJh59s5TWouepaGJnGbU3orsK5/ODGfFVXk3AX8LvWdsGDf1Uawgh0kjWc15LkT3oHz
	 rQ8F7bKcfIEh4ZTsQDWnz2XGD6j9AGR//K2HgZQ/hOuJNY123BO3qbijQHvl57INLLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gFRMwEKA;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AA7606A89B
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:15:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25AA7606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gFRMwEKA
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8b32efd7ec4so3454563b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 21:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794460550; x=1795065350; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oOfImB3qy0T90q2O/tjXznngWxo1sLRzTsMD5yze5WY=;
        b=gFRMwEKAJw5ZuY8NYu46R1Od99zHrRk1T0WQ0ByyqQxFWo/FO8b9BYmwtbPrDKiZ4I
         8iJCPyF+DH0SbIdKg5EZqRNnZ77zN0vEGA1kJhIaWIoWSEvmP3Zav+xWvkrahTbDNTP0
         DC3CuAjEV4udKvZxQwIiIOJIM/OGdzJW+nyM1i/D+lbRkFuBfzvF0ILfOL+XDEnivDJt
         I8JW59AuBx2T2ND73bowbCI162DDMy4rcDDza7wh2NWGxem38TL8iR8ofuG9jli+UW1n
         GKl2bJ8LUOuIR+FMxw5RFrZ5jkFhw7LMLhKjPHydwZ0aGZrDTZL49OEalhPI2/d69xw8
         36bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794460550; x=1795065350;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oOfImB3qy0T90q2O/tjXznngWxo1sLRzTsMD5yze5WY=;
        b=DM3/TbMNPkVU6sv43lyM75xheE14tuGVkdyW3MiStv2LTRn286EA9/iGxBRiHqDQml
         4K/IVcK8pjX6x+gXxyT/R03LW8x/H+x8+1rAbIaH/G2FRS/ztcnhUN2fcopF0zLtYh4N
         R3Usp1hp63s3isyytrJUpnSqjqnS+F+AG3/WE/i2Qt3sU6GrKyJrTWV23g409E1tW5sI
         GZi3hB1UdOZS/8KFRveou4dpZVObfcnO6u8MyTyxXwyclRo8vbpc4sDo1E10w2pjWbNN
         0/tDCyHQKS3GN1x/FU4XVYRqDELXWMexPxAc4rkDUhGeR5U2Akv5yLef2Sfep0aAQUWr
         aVmg==
X-Gm-Message-State: APuU4Z8hmCj2lDu/haU5T0sza6zwa1G/Ak/qgEzBq7pSZmPLYTC+dWUD
	t1brrfEuW+Dq2Ku4aEM5j467NF5aPQ43rc9Jt2FztEyebeMj4hUFfEOltqfrlnyMv0bO+zVTpbi
	lDR1u2ckX0/UsnhdIp4u8o0Chx09k2nr9DJZLV9s8wSxy7/Q4ILBIbUtk56kn2JuJY27cpuA5j2
	2lvIqNzudETOSRGSiTSDnHrDtxcVq/g/JHItHJWnd/1ZQhFGbZNgJNXaXNUqaZcKI=
X-Received: from pgbo22.prod.google.com ([2002:a63:5a16:0:b0:cdb:5e5a:97a0])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3988:b0:3dd:d729:c62c with SMTP id adf61e73a8af0-3f2ff4d7c53mr4552825637.54.1794460549897;
 Wed, 11 Nov 2026 21:15:49 -0800 (PST)
Date: Thu, 12 Nov 2026 13:15:35 +0800
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
Message-ID: <20261112051542.1539779-3-stanleyjhu@google.com>
Subject: [PATCH 2/9] scsi: ufs: core: Defer link recovery on reserved PM
 command timeout
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

When a device management command sent by a PM callback times out,
ufshcd_eh_timed_out() runs ufshcd_link_recovery() inline:

1. The PM callback holds hba->dev_cmd.lock, a read lock on
   hba->clk_scaling_lock, and the only reserved tag while it waits
   for the command.
2. The command times out and ufshcd_eh_timed_out() resets the host.
3. The reset runs ufshcd_verify_dev_init(), which needs the same tag
   and lock, so host init fails with -ENOMEM in SDB mode and
   deadlocks on hba->dev_cmd.lock in MCQ mode.

Instead, stop the host controller, schedule the error handler and
complete the command with DID_TIME_OUT, so the PM callback releases
the tag and locks before recovery runs.

The remaining tail of ufshcd_eh_timed_out() then only handles SCSI
commands, so drop the reserved command branch there.

Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before SCSI EH")
Cc: stable@vger.kernel.org # 7.3.x: cd37a69c367b: scsi: ufs: core: Remove an always-false WARN_ONCE()
Cc: stable@vger.kernel.org # 7.3.x: 22d14117ec18: scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
Cc: stable@vger.kernel.org # 7.3.x: 3a7e551ae4bc: scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
Cc: stable@vger.kernel.org # 7.3.x
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 60 +++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e9dcab35a4cd..6a5f5fa732d9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7147,7 +7147,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	/* Complete requests that have door-bell cleared by h/w */
-	if (!stop)
+	if (!stop && ufshcd_is_hba_active(hba))
 		ufshcd_complete_requests(hba, false);
 	spin_lock_irqsave(&hba->host->host_lock, flags);
 again:
@@ -9689,6 +9689,50 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
 }
 
+/*
+ * Claim @scmd before stopping the HBA in case normal completion raced with
+ * scsi_timeout(), then complete @scmd so the PM caller releases
+ * hba->dev_cmd.lock and the reserved tag before error recovery runs.
+ */
+static void ufshcd_eh_pm_cmd_timed_out(struct ufs_hba *hba,
+				       struct scsi_cmnd *scmd)
+{
+	struct request *rq = scsi_cmd_to_rq(scmd);
+	struct ufs_hw_queue *hwq;
+
+	if (!hba->mcq_enabled) {
+		if (!ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag)))
+			return;
+		ufshcd_hba_stop(hba);
+		ufshcd_force_error_recovery(hba);
+		set_host_byte(scmd, DID_TIME_OUT);
+		scsi_done(scmd);
+		return;
+	}
+
+	hwq = ufshcd_mcq_req_to_hwq(hba, rq);
+	if (ufshcd_is_hba_active(hba))
+		ufshcd_mcq_poll_cqe_lock(hba, hwq);
+	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
+		if (test_bit(SCMD_STATE_COMPLETE, &scmd->state))
+			return;
+	}
+	spin_lock_irq(&hba->host->host_lock);
+	hba->force_reset = true;
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
+		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+	spin_unlock_irq(&hba->host->host_lock);
+	ufshcd_hba_stop(hba);
+	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
+	ufshcd_force_error_recovery(hba);
+	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
+		if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
+			set_host_byte(scmd, DID_TIME_OUT);
+			scsi_done(scmd);
+		}
+	}
+}
+
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct ufs_hba *hba = shost_priv(scmd->device->host);
@@ -9698,6 +9742,11 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 		return SCSI_EH_NOT_HANDLED;
 	}
 
+	if (!ufshcd_is_scsi_cmd(scmd)) {
+		ufshcd_eh_pm_cmd_timed_out(hba, scmd);
+		return SCSI_EH_DONE;
+	}
+
 	/*
 	 * Handle the timeout directly to prevent a deadlock between
 	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
@@ -9718,13 +9767,8 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 				return SCSI_EH_DONE;
 		}
 
-		if (ufshcd_is_scsi_cmd(scmd)) {
-			set_host_byte(scmd, DID_REQUEUE);
-			ufshcd_release_scsi_cmd(hba, scmd);
-		} else {
-			set_host_byte(scmd, DID_TIME_OUT);
-		}
-
+		set_host_byte(scmd, DID_REQUEUE);
+		ufshcd_release_scsi_cmd(hba, scmd);
 		scsi_done(scmd);
 	}
 
-- 
2.56.0.567.gdb80ae8cd5-goog


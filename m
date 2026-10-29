Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=154.81.10.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238545;
	b=x9tU5bXgnXpa0HhdDJRWrHMSmndMMWjduEQNw5U1brAYgFDhJcOjWVWrRWTlWbYltra2
	 3lkBZkFWoHoEAcQo/JM+WMCmYeYY7BJyZ5oA9eCXgwoTm2f7LrQsQMYBtTYKRpB8G3cUs
	 mJGGim4qzUfaB7fLvIxcpDC2vWIf8KyXTstNKOVKa+T/L9wT7QMqhpTKPvcooYcAPvsX8
	 MbUynHVPYOz7ZSrnDU0KaVOIkoPjf2PJS8GgsNiDGbnxit4Cpi+AlbXBJPtMb8sY0N/P+
	 Qvk9lZBmpwHRQgW3EodtshlHLMJ7b3LsTZzhkqU4nBjf6iGst3okZeLjOXl6fPnSIpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238545;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=GnVcAOH2LmSWAQPFKCBX7AMqmJ+8lxkyCENmB7HkRJ0=;
	b=X0eX1FAKKJjIm9kfNqxm6ptnxH/9ZcuoqCnmm5D3P/YJoVpP/rNkm+yC4aAIn9tZ81rk
	 k0ezy0hdqUTHuh3OUCZeOOFCYURKLmbhwcLSqlPSBDGCFAN/1VqqcupOcIfwqZaOUIGFc
	 u/73McrW4Cd0Q8AYlKIjvv3HjuotDFmXDk2sqGbI2bCJ46ECS+GQKIwq0FHJPvZ96rS0v
	 hO2nfXCkAx8Na7xBakfeyAn75zZYEn3NvDQyl2tCVrl6NVgnxCmdRRnQAtK4Owl3iZu8V
	 Kye7asA5YzEUCLzHESmC0bGoHOGHJ1JLU+l1hbr8+ne1qwEqbVSNR/bBxDMnczp6KUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=kWhPzudl;
	arc=none smtp.remote-ip=154.81.10.68
Received: from mail-m1068.netease.com (mail-m1068.netease.com [154.81.10.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61C606A323
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 01:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C61C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=kWhPzudl
Received: from localhost.localdomain (unknown [61.154.14.87])
	by smtp.qiye.163.com (Hmail) with ESMTP id 52b924268;
	Thu, 29 Oct 2026 09:48:53 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stanley Jhu <stanleyjhu@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-rockchip@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v2 2/2] scsi: ufs: core: Retry the full device init on fatal link loss
Date: Thu, 29 Oct 2026 09:48:39 +0800
Message-Id: <20261029014839.3390579-3-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261029014839.3390579-1-shawn.lin@rock-chips.com>
References: <20261029014839.3390579-1-shawn.lin@rock-chips.com>
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
X-HM-Tid: 0aa18558876403a4kunmb608b1c4109653
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCThpNVhgaGExCSRpMTUNKHVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ0xZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=kWhPzudlFpdUGE7DD6SN0cYrXRn3l0pPlW+c+RmQRQbBK1/qX5DEJqs3g9vSWlimbFsxImi3pht5v/EHRbsrwcyttxM4qx1CWPyrAM3S2VLacJfBqCAFYhaVnhac83ltliqymhFIA1bPj/Az5sZpd10quGj/PoDpQK0JGLp/8cY=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=GnVcAOH2LmSWAQPFKCBX7AMqmJ+8lxkyCENmB7HkRJ0=;
	h=date:mime-version:subject:message-id:from;

On an RK3572 board the UFS device is sometimes reported dead during the
initialization at boot: DEVICE_FATAL_ERROR | UIC_LINK_LOST is latched and
the following UIC query fails with -EIO, leaving the device unusable.

Recover by resetting the device and the controller and redoing the whole
initialization sequence, up to three times with a 100 ms settle delay in
between. Doing this in ufshcd_init() rather than in the platform driver's
probe keeps the interrupt, clock and regulator resources acquired only
once, and the UFS device is already reachable through hba->priv at that
point.

Each retry stops a pending error handler and clears the error state
latched by the failed attempt, reconfigures and re-enables MCQ if the
controller reset cleared it, and restores the reset ufshcd_state, so
that no stale error context survives into the retried initialization.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

---

Changes in v2:
- Move the initialization sequence into a new function and retry by
  looping over its call site instead of adding more gotos to
  ufshcd_init()(Bart)
- Stop a pending error handler and clear the error state latched by the
  failed attempt, so that the retry starts from a clean state(sashiko)
- Reconfigure and re-enable MCQ after the controller re-enable, since
  the HCE toggle clears the MCQ mode setting(sashiko)

 drivers/ufs/core/ufshcd.c | 46 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f1e54d719537..bd82d6755739 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11468,8 +11468,52 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Initialize hba, detect and initialize UFS device */
 	ktime_t probe_start = ktime_get();
+	int retries = 3;
 
-	err = ufshcd_full_device_init(hba);
+	while (retries--) {
+		unsigned long flags;
+
+		err = ufshcd_full_device_init(hba);
+		if (!err)
+			break;
+
+		if (!retries)
+			break;
+
+		dev_warn(hba->dev, "UFS init failed %d, full retry (%d left)\n",
+			 err, retries);
+
+		/*
+		 * The failed attempt may have latched fatal errors and
+		 * scheduled the error handler. Stop it and start the retry
+		 * from a clean state, mirroring ufshcd_reset_and_restore().
+		 */
+		cancel_work_sync(&hba->eh_work);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->saved_err = 0;
+		hba->saved_uic_err = 0;
+		hba->force_reset = false;
+		hba->ufshcd_state = UFSHCD_STATE_RESET;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+		ufshcd_device_reset(hba);
+		ufs_put_device_desc(hba);
+		ufshcd_hba_stop(hba);
+		if (ufshcd_hba_enable(hba)) {
+			dev_err(hba->dev, "Host controller enable failed\n");
+			ufshcd_print_evt_hist(hba);
+			ufshcd_print_host_state(hba);
+			goto out_release;
+		}
+
+		/* Reconfigure MCQ upon controller re-enable */
+		if (hba->mcq_enabled) {
+			ufshcd_config_mcq(hba);
+			ufshcd_mcq_enable(hba);
+		}
+
+		msleep(100);
+	}
 
 	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
-- 
2.25.1


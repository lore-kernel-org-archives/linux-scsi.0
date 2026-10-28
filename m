Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=154.81.10.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793172712;
	b=qIUFyQafyhYclAbhzFkG5v2MDIKXKEIWCF7BLtwCL6T8GbWUNoKn1dJl9Wb4Dnag2ZHk
	 biAWutlqBgROnRwiQa/dfwps2xRraKgIVTNYCz2ngzh77kfRziPhAMAUPV5TeYpJ6tLth
	 mUnqZP6Cdvz4Zp3qOesITE7HW2LyxYqzbJfkU4GGidLrZgRIwYxI5eiDy4mo4dfvfPHQ+
	 froQDOJUsM48KttPIMwhfEuDU+YvtMOf0EqIZmWQyx138/ELF7bIXjzCY0qORLlnn6SkB
	 Gv1NMi7wuzm9JUL8eIn6METReuUTgun0VpMKtG9dCXGu6tb3HDaM5+DJJh4hywP0uFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793172712;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=d20iozcM94y1ynJJGzlYfaLHRuOSfOKuZNnqcN4LWBQ=;
	b=aiJNaeUGlUB4HQGOJT4aVfceo3YkUYYe+1YYIkISa4dDVwsNU2Ez5/IFHwG0fW09fLcN
	 SRA1XnPYdw7T1CR1MFxEyh/MoPYEvKBo4015Iqsjj5vbK4yImg1XTqWHfPYlYoKlNqbCa
	 mTSQ06lBCcAwTiEW4/oKdXD83iYBl79c7SE8iTa9/ukufgmy5CbUa72B2EcVn8fVzb2jp
	 XWhkM/8+szqVEV5QUHPWcJEVIivyvy8ym8idWWOD1IJ4Sxuh+K+kVJSJbn3NYR/7mNDII
	 mcBemxoSl+jUqjlnLcGV++rpvXfkNg2KbxkFPcYSfgR6trZF8o8ZVPALtZ435BqM1JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=TB+GQMii;
	arc=none smtp.remote-ip=154.81.10.10
Received: from mail-m1010.netease.com (mail-m1010.netease.com [154.81.10.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91297606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 07:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91297606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=TB+GQMii
Received: from localhost.localdomain (unknown [61.154.14.87])
	by smtp.qiye.163.com (Hmail) with ESMTP id 52a1342f6;
	Wed, 28 Oct 2026 15:31:39 +0800 (GMT+08:00)
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
Subject: [PATCH] scsi: ufs: core: Retry the full device init on fatal link loss
Date: Wed, 28 Oct 2026 15:31:29 +0800
Message-Id: <20261028073129.1661829-1-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.25.1
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
X-HM-Tid: 0aa1816bf8ef03a4kunm8a59feb98d47f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGk8ZVk5LTklJTkwfQ0oZTVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ0xZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=TB+GQMiiZFz6iEXGHZpLEHkhiImt1AHwh5JT9q9S7vFCqPvkeXGWlvbQ4EzrWzsPfAlklF7HWq39Veuzngx5G5mWDoTEwGa7A0V4UKZxWesattozxQs0Suzt1Lmx8FTZK2IpvpwICsusizal8qyEsPUT3iF89ck8wmMZmK9+Qd0=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=d20iozcM94y1ynJJGzlYfaLHRuOSfOKuZNnqcN4LWBQ=;
	h=date:mime-version:subject:message-id:from;

On an RK3576 board the UFS device is rarely reported dead during the
initialization at boot: DEVICE_FATAL_ERROR | UIC_LINK_LOST is latched and
the following UIC query fails with -EIO, leaving the device unusable.

Recover by resetting the device and the controller and redoing the whole
initialization sequence, up to three times with a 100 ms settle delay in
between. The retry covers the link startup, the device verification, the
completion of the device initialization and the device parameters setup,
since any of them can fail once the link has been lost.

This is done in ufshcd_init() rather than in the platform driver's probe.
A host driver only reaches its private data through ufshcd_get_variant(),
which is set from the ->init callback that ufshcd_pltfrm_init() invokes
on the caller's behalf, so the resources needed to reset the device are
not available before or after that call. More importantly, retrying
ufshcd_pltfrm_init() would request the interrupt, clocks and regulators a
second time without any of the earlier registrations being rolled back:
ufshcd_pltfrm_init() returns the error as-is, it does not undo what the
previous attempt already set up. That leaves the controller with leaked
resources and makes the retry fail on the interrupt registration.

Doing the retry inside ufshcd_init() avoids both problems: the host data
is already reachable through hba->priv, and the interrupt, clocks and
regulators are acquired only once.

The failure looks like this on RK3576:

  ufshcd-rockchip 29e00000.ufs: ufshcd_check_errors: saved_err 0x880 saved_uic_err 0x0
  host_regs: 00000000: 0187011f 00000000 00000200 00000000
  host_regs: 00000010: 00000000 000005e6 00000000 00000000
  host_regs: 00000020: 00000000 00031ef5 00000000 00000000
  host_regs: 00000030: 00000008 00000001 00000000 00000000
  host_regs: 00000040: 00000000 00000000 00000000 00000000
  host_regs: 00000050: 02dd3000 00000001 00000000 00000000
  host_regs: 00000060: 00000000 00000000 00000000 00000000
  host_regs: 00000070: 02dd4000 00000001 00000000 00000000
  host_regs: 00000080: 00000000 00000000 00000000 00000000
  host_regs: 00000090: 00000016 00000000 00000000 00000000
  ufshcd-rockchip 29e00000.ufs: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0; saved_err = 2176; saved_uic_err = 0; force_reset = 0
  ufshcd-rockchip 29e00000.ufs: ufshcd_query_flag: Sending flag query for idn 1 failed, err = 5

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..e75370d1b950 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11419,12 +11419,14 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Initialize hba, detect and initialize UFS device */
 	ktime_t probe_start = ktime_get();
+	int retries = 3;
 
+retry_init:
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 
 	err = ufshcd_link_startup(hba);
 	if (err)
-		goto out_release;
+		goto retry_device_init;
 
 	if (hba->mcq_enabled)
 		ufshcd_config_mcq(hba);
@@ -11441,16 +11443,16 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Verify device initialization by sending NOP OUT UPIU */
 	err = ufshcd_verify_dev_init(hba);
 	if (err)
-		goto out_release;
+		goto retry_device_init;
 
 	/* Initiate UFS initialization, and waiting until completion */
 	err = ufshcd_complete_dev_init(hba);
 	if (err)
-		goto out_release;
+		goto retry_device_init;
 
 	err = ufshcd_device_params_init(hba);
 	if (err)
-		goto out_release;
+		goto retry_device_init;
 
 	err = ufshcd_post_device_init(hba);
 
@@ -11468,6 +11470,25 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
 
+retry_device_init:
+	if (retries--) {
+		dev_warn(hba->dev, "UFS init failed %d, full retry (%d left)\n",
+			 err, retries);
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
+		msleep(100);
+		goto retry_init;
+	}
+
 out_release:
 	ufshcd_release(hba);
 out_disable:
-- 
2.25.1


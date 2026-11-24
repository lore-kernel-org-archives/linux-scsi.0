Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483808;
	b=0vGBxdqFiGZcV5ArIpB0JwRU6AUj1RlyQABXsw13F8JIu3tT4quPqk3dFWaPzQrZ3p5C
	 SVg8LnG1WLuph12MPCwOc9cLa/aJqm2JTjLJv2TiSiefmRzrpC0aLTsk+wkVePqc5ni8E
	 a5UIw0ZWKvY7aPMWoPw2qZ5xDRdRxNyScOHCZBfoML7ISbAsYr5I9vRlBzKFM0NeMppcD
	 kl5uGwbTQRXQG563QpMyLPuoMisHHEZf4tb2kz+9+1RyjFwxOssYZVgftyJSo56RriX0f
	 M/KN1IlBab9airopPv6l+Xk8VZcPOsAgRmryK4LDUbTUuv+hitkIW1SePR8Up5Y4f/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=aZ+kdjMwzLW6D1d8Noa04UT5HiQC8LgMJZGM4R3Q9WU=;
	b=2OROFZYg2hsQp9jJEXBEOLwgB7ZieLgebkFyvh44SxkYHfP9bDJvLpiGtXHhkQgFbdC3
	 JDWJw0kL/PHLq8EASWPy9H1G0g/bf1pHpeTweQwrN9PTkwRQ418+piTf9mB4Z6cKys/jg
	 SuZjiR/TpRN/XGJFyDo7gtdJz9kXIrRseVF4C5+ReEkhF7ER/A1fDk5FIWLZ6I9aovCd+
	 lOHcDWnM8g4oSLdeT20RQJhy28gCuY41sF55e+WzMv8+O9c5ggzoYEuRrNZi8Z24DfP9B
	 +7hiDCYdd3V39yR0R/0zMqYmIyqaJLUeuyZupiIHo/unaT7UMZS0jaCFrPuXotNMkZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UBmAvtsh;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F9606A326
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 01:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 199F9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UBmAvtsh
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b3f3e256e8so3967082a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 17:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795483807; x=1796088607; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aZ+kdjMwzLW6D1d8Noa04UT5HiQC8LgMJZGM4R3Q9WU=;
        b=UBmAvtshi1MR+jB7Et3WRppr+mRq801u72XXTzXTUR2woLynEgQLZkpA/XuR2+2KhJ
         lDJZEl0GfJgXuvl3USjrgcRiW8n46q2YNOz8D0HcUJY3FzHyHezef0jYdIJttM84zLUS
         gByv7Xt7HCbTgsSF0+YFm3metxFqAgIO10DPSOdZJ6zrsU0T87zZlpX7XR1VUpO0f/oC
         Y6NvOz60DPnHP40QJk724++/H8XK0uJTeOa2Jly4M7QSXFgy5gL0PGZXCy6iaKV/EZkP
         IoxBy8Gl/r5ekwD9cajmVnGudHMStVAEH0wjeeM9MUjmsMJmNLEviaf+H9wT7+VYYplL
         vm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795483807; x=1796088607;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aZ+kdjMwzLW6D1d8Noa04UT5HiQC8LgMJZGM4R3Q9WU=;
        b=uXIPcE7X4kO94htQeA87pDqE8UYx83iL8+YFwF+mZ2tTsRe5cVRiIbTi3jFAIehm3W
         50Y2Lue0R1Ug2TDTUNtlmSHd7Lor4Q1zUvCXbgJap/pnwVjtIbsOhxiiqSAmKOXd5/m6
         4zCoiG4jZqjj9r/i8nvXqrGmriLR67mj3W7g7hCjuuWWHv2DRuS5VKbXF0Xq07wpe/6W
         JDvMkybuOsd9R7x680A2P7m5/7DHq4AkEKJpOqAMKJfcei2HHcGswBqgiZxPyjnSQvep
         XHTN4EFs07/dkW0xRTmog9F76lJibx9ZJ81hBWOsCnxUB2lMrrpa/NIuXWFmgLFlmRrp
         qKxw==
X-Gm-Message-State: APuU4Z+2xtF0xBpynXCJJIMcj9pxym0400jllVLjeWNgNmKju9yFXZ69
	MnykiNXyH3qsz/ABZikrYm1tcUoLPfrAsV/lKOCG+rA6kMDiBhhx11Uk0/ss9PB5bRU95yiWTIq
	x4QB252NY7kVni7HXEy9QeCHpsB3HwPQnjy5ARqEdyt9FOsJoTV2kC8jY+L5NXRMW9Z5j0y79ok
	q6GtPh8Vfn8V3b8lPQ31U2Zg93Y7Jup71InJrQ2kfjniufSECHaVAR
X-Received: from pjyp3.prod.google.com ([2002:a17:90a:e703:b0:3b3:ec38:c78e])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d03:b0:3ab:31e6:12fc with SMTP id 98e67ed59e1d1-3b41c5574f0mr12394867a91.0.1795483807147;
 Mon, 23 Nov 2026 17:30:07 -0800 (PST)
Date: Tue, 24 Nov 2026 09:29:32 +0800
In-Reply-To: <20261124012951.3143833-1-powenkao@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261124012951.3143833-1-powenkao@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261124012951.3143833-2-powenkao@google.com>
Subject: [PATCH v2 1/2] scsi: ufs: core: Defer debugfs init until after device init
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>, Li Qiang <liqiang01@kylinos.cn>, 
	John Garry <john.garry@linux.dev>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

ufshcd_hba_init() currently creates the debugfs hierarchy and fault
injection attributes before the controller version (hba->ufs_version),
controller locks, and device descriptor (hba->dev_info.wspecversion) are
initialized.

Move ufs_debugfs_hba_init() and ufs_fault_inject_hba_init() into
ufshcd_init() alongside ufs_sysfs_add_nodes(), and move the matching
ufs_debugfs_hba_exit() from ufshcd_hba_exit() into ufshcd_remove()
alongside ufs_sysfs_remove_nodes(). Use disable_delayed_work_sync() in
ufs_debugfs_hba_exit() so an in-flight exception event cannot re-queue
debugfs_ee_work while scsi_remove_host() is still tearing down devices.

Moving the exit call symmetrically keeps probe error paths from tearing
down uncreated debugfs state, drains debugfs readers before
scsi_remove_host() removes the WLUN during unbind, and lets debugfs
initialization inspect both hba->ufs_version and
hba->dev_info.wspecversion directly.

Suggested-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufs-debugfs.c | 2 +-
 drivers/ufs/core/ufshcd.c      | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 9f83628f3e2c..e62b942b37dc 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -529,5 +529,5 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 void ufs_debugfs_hba_exit(struct ufs_hba *hba)
 {
 	debugfs_remove_recursive(hba->debugfs_root);
-	cancel_delayed_work_sync(&hba->debugfs_ee_work);
+	disable_delayed_work_sync(&hba->debugfs_ee_work);
 }
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 56a77f4a2a6e..f1df1d6734d9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10115,9 +10115,6 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_vreg;
 
-	ufs_debugfs_hba_init(hba);
-	ufs_fault_inject_hba_init(hba);
-
 	hba->is_powered = true;
 	goto out;
 
@@ -10139,7 +10136,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_exit_clk_gating(hba);
 		if (hba->eh_wq)
 			destroy_workqueue(hba->eh_wq);
-		ufs_debugfs_hba_exit(hba);
 		ufshcd_vops_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_setup_clocks(hba, false);
@@ -11027,6 +11023,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_bsg_remove(hba);
 	ufs_rpmb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	ufs_debugfs_hba_exit(hba);
 	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
@@ -11505,6 +11502,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufs_sysfs_add_nodes(hba->dev);
 	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
 						     "dme_qos_notification");
+	ufs_debugfs_hba_init(hba);
+	ufs_fault_inject_hba_init(hba);
 	async_schedule(ufshcd_async_scan, hba);
 
 	device_enable_async_suspend(dev);
-- 
2.56.1.809.ga0b61035b5-goog


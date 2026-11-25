Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606493;
	b=TcfYpWSavOv1aZSGR8Tn6mICxyETM/1/FvGspnl6HaM1h/y2JaxHvyi+pbPFR40ipgo7
	 l+WdGYMvxY0LnlcI/7gT/+EU7JJMlXNHMF+qg1mo5MeQMgEieD1D96J9eLSeO/rXtLkX5
	 IdwZRNTqwOhiK6JBweCSbofuoY5RiQVEICunOEHjUvVMkTxPndpo1C9VmnCAsU2OdCifd
	 k4LhkRZCobK/8h+FDv5Ks/TNjUo2+e7poOwoI2CKNwIU2MHDZ1dCTu5XurRMh033Umgh6
	 GoDlJTFJk3UH87Uvb4RzwRJTKYHKsj7IFC92J0zPDVKCIs30eo6DV8E8nvR7x9+IiOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606493;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=tRhNWivZSw3mIS21gLSttP0TksdvFQvMGJw8Ec1v+p8=;
	b=Sv7AIfEH4iXqfIjvoj8ummdAZpQf8iAOHKdOAVrCxvkbg2pp2XXwNQIrrAvcFD3CojFH
	 eBsm235AeZzTScS0C1fAc7iDulaQboRyjlPb/xPFVfWZk5gazy2KZJCQkHUqYSxh35hNJ
	 qO48UYknAZIPJwlGv2+5SS/+RkoVxJsu4NIU6UnayDO6lQgD02b9BLx+nQ9BispyP/uBm
	 XiWiR2ob3nM0oEayB+LdIonjgaUuGRTYiwjedU2B/FyyALjOsTCBWzoZG8hheRA7JiDCu
	 vGGB0E7Em214FXbs5rAW5VpQ6uaC7LMGS/flPQ/Jbn1Wg8IouX6CCXZo/s+Ke+wNaYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X5wCkg3H;
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECEB606A68B
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ECEB606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X5wCkg3H
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so5633375a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795606493; x=1796211293; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tRhNWivZSw3mIS21gLSttP0TksdvFQvMGJw8Ec1v+p8=;
        b=X5wCkg3HRNPaXveDbaQR4cSBcifd7AJvx3JudOQJfpHNWScGHPXAnZ2Hh16t8ZOMcp
         E8iobLlRB7wAZfWS+wl79LXSyvbDgvXVMp8xorOyKYK2FyRmATKpu7LVA86l5QSTDonG
         +dorx5oQsDpf/dKkVHHBy7lbM80Os/JXkKwjZ2x9YqrdXAL45UKoeiYmkHehFjBuhDda
         wuBuJ6Wi6WnruweqHT/N6Bxps5Nrw+J8ZQvDQm3UMcD4olmeu4Ei+cCckKvb2QSJcnrv
         YHVL2CZaF0I2XAQhahwQJpmCqdjepiLJfixzKS2n2ay4KapLaykOSruUX4wskuA/jK2O
         QOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795606493; x=1796211293;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tRhNWivZSw3mIS21gLSttP0TksdvFQvMGJw8Ec1v+p8=;
        b=iV2dTgOtzjJo2s5iIuQc8I5j3R31ADYMeC5+ij0YM+7WxRhA5ic/36u7e45txvkOur
         5iVgf56ruF+ZPUerQ0x7eazoFRbTxbx8RXpKclGTnIb8oobaYuZFZbkPpMTdNh5Q+hzW
         7RRtMZiYHKvJXRyRyl5kcT9i3KQhU/Dc8PnKodYgbODRB+lYEnwRd7XMlZkrorypZ0cv
         SGgg7Kr95W9hvEGqWvvNJbf0uHFG/Y1n9pHh1ItRVd53UBlUB92PizQx1W2FlgbMwbGk
         gM0xEysN4SFmpjrXOX3lgGgGnO9ckpY4fYKnBi5YzXDdNJycOSpFJ09RpQ34PDgdR4qV
         UZnQ==
X-Gm-Message-State: APuU4Z/KwBw6y8iQ+dfReIpVcNgSgoAnstUcygk/0TW1OyiHzEo3ayuE
	LNBPjiEWhauGTacTJzy9XAKhS4/2M8BFkW/fmmDWFhSUvK2Z/Sldo2Vi11l59NYx7duICwklMOx
	exyBCyLjurj3dr44BoGYezac7jnxqsY8wZcUTDMMsW6EJ84kU90b9gTtazPorsBd3t7vo6kEYVr
	bCveVvVUXhMvy8SdFr7D5tHolFeQprzDlqXhs2iNiOoNsyiwyvAIAG
X-Received: from pffh16-n2.prod.google.com ([2002:a05:6a00:c250:20b0:8c4:bb6e:711])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:748e:b0:3d3:aec2:4dcd with SMTP id adf61e73a8af0-4014c251613mr19030501637.25.1795606492379;
 Wed, 25 Nov 2026 03:34:52 -0800 (PST)
Date: Wed, 25 Nov 2026 19:33:59 +0800
In-Reply-To: <20261125113435.1426680-1-powenkao@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125113435.1426680-1-powenkao@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125113435.1426680-2-powenkao@google.com>
Subject: [PATCH v3 1/3] scsi: ufs: core: Remove debugfs before removing SCSI host
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Randall Huang <huangrandall@google.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>, stable@vger.kernel.org, 
	John Garry <john.garry@linux.dev>, Li Qiang <liqiang01@kylinos.cn>, 
	HOYOUNG SEO <hy50.seo@samsung.com>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Asutosh Das <quic_asutoshd@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

ufs_debugfs_hba_exit() is currently called only from ufshcd_hba_exit(),
after scsi_remove_host() has removed hba->ufs_device_wlun. Active
debugfs write handlers (e.g. exception_event_mask) and
hba->debugfs_ee_work call ufs_debugfs_get_user_access() ->
ufshcd_rpm_get_sync(), which can dereference a NULL or freed
hba->ufs_device_wlun during unbind.

Call ufs_debugfs_hba_exit() from ufshcd_remove() alongside
ufs_sysfs_remove_nodes(), before scsi_remove_host(), so in-flight
debugfs file operations are drained while the WLUN is still present.
Switch cancel_delayed_work_sync() to disable_delayed_work_sync()
(introduced in v6.10) so an in-flight exception event cannot re-queue
debugfs_ee_work during teardown, and clear hba->debugfs_root so the
existing ufs_debugfs_hba_exit() call in ufshcd_hba_exit() remains safe
on both normal remove and probe failure paths.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufs-debugfs.c | 3 ++-
 drivers/ufs/core/ufshcd.c      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 9f83628f3e2c..89753c40b27b 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -529,5 +529,6 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 void ufs_debugfs_hba_exit(struct ufs_hba *hba)
 {
 	debugfs_remove_recursive(hba->debugfs_root);
-	cancel_delayed_work_sync(&hba->debugfs_ee_work);
+	hba->debugfs_root = NULL;
+	disable_delayed_work_sync(&hba->debugfs_ee_work);
 }
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 56a77f4a2a6e..646359d446c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11027,6 +11027,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_bsg_remove(hba);
 	ufs_rpmb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	ufs_debugfs_hba_exit(hba);
 	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
-- 
2.56.1.839.g22a8290db9-goog


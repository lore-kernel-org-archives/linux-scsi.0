Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B414A3054DE
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472130; cv=none; b=NQ3GaVVjjlV7wHybuDvDT4GpOg49rczmiHbnmMstSWGZuyyoKFMs7rV4PEmROr/Bjvr76ZAuoDZP8L/DJY200zXmUtZTErEzfO/rrnAec2UXDLBftnPde+CejSr0LR5FKIMoFc3Eep3bN21akh4evwmFH3n/jVSeTBpWzm4RNz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472130; c=relaxed/simple;
	bh=czRRGc8Q2X+g00v989R1xG63GbFGRx3NT6bCwGIKA0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFVL23UpurL7j31dPl4ryJ0sc5G5SgvR+3vTsk/e5of9ehdKtyLgEHdP1yQ5pdfJ+Er/h6dyOq45K3BhjvY+Ha88v1dtCb6JtKyw5opoUkaip7w/BZPc1ZgShboPKTF7Xb3A1/+erBMgfHNaYDBBzSlTaTSZOXeHJi94BBvUnyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RPVWAZvW; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RPVWAZvW"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQ9C3ZlHzlgqyY;
	Tue, 14 Oct 2025 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472125; x=1763064126; bh=UA/lR
	Dj7arpLOB2SippvYC4nMPa2M6ZIUi+xkeKCqZg=; b=RPVWAZvWn5RHW65hWPDna
	MyA3+MJQ4B8oNHgH5Scj5GiwQXuCZuqLB0TqYOr0RHSyYxT12MM7RdNaCu8dWHcY
	yrxRMYCDjxzRxFs0nMBsLT0JjB0vZMnOQ2BzNCxCDjb/bEIWZT5eQ2OnHXIXG/Zi
	/lYbih7ZGwxkdNBGha756SPiSLgo8de93gA7ZUtIe6u9iSwvYyQAEOQdeisGa5+v
	KqvR0Jb4CEnYjpjaUIBlDT2JsnwTtSbdQtwjErVzOly3BC846l5vbAwBvdpB+GUm
	Cn7iCBZuxi9ece9CeDIbpmvr7tPD9Drh99HNouLTQ3GfI662GEzWT1bx/zHgRJHL
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WIchaZIIvAfW; Tue, 14 Oct 2025 20:02:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ8y1QW8zlgqVm;
	Tue, 14 Oct 2025 20:01:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/8] ufs: core: Reduce link startup failure logging
Date: Tue, 14 Oct 2025 13:00:54 -0700
Message-ID: <20251014200118.3390839-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some systems, e.g. Rock 4D, have a pluggable UFS module. Link startup
fails systematically on these systems. If no UFS module has been plugged
in, more than fourty lines are logged after the "link startup failed"
message. Avoid this by reducing link startup failure logging.

An intended side effect of this patch is that scsi_host_busy() is not
called before scsi_add_host() is called.

Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
iterators") introduced a regression - the warning shown below is
triggered during every boot. This patch fixes that regression.

Call trace:
 __srcu_read_lock+0x30/0x80 (P)
 blk_mq_tagset_busy_iter+0x44/0x300
 scsi_host_busy+0x38/0x70
 ufshcd_print_host_state+0x34/0x1bc
 ufshcd_link_startup.constprop.0+0xe4/0x2e0
 ufshcd_init+0x944/0xf80
 ufshcd_pltfrm_init+0x504/0x820
 ufs_rockchip_probe+0x2c/0x88
 platform_probe+0x5c/0xa4
 really_probe+0xc0/0x38c
 __driver_probe_device+0x7c/0x150
 driver_probe_device+0x40/0x120
 __driver_attach+0xc8/0x1e0
 bus_for_each_dev+0x7c/0xdc
 driver_attach+0x24/0x30
 bus_add_driver+0x110/0x230
 driver_register+0x68/0x130
 __platform_driver_register+0x20/0x2c
 ufs_rockchip_pltform_init+0x1c/0x28
 do_one_initcall+0x60/0x1e0
 kernel_init_freeable+0x248/0x2c4
 kernel_init+0x20/0x140
 ret_from_fork+0x10/0x20

Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Closes: https://lore.kernel.org/linux-block/pnezafputodmqlpumwfbn644ohjyb=
ouveehcjhz2hmhtcf2rka@sdhoiivync4y/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 26c2aafd7338..fa20082ac4d4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5131,12 +5131,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba=
)
 	ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
 	ret =3D ufshcd_make_hba_operational(hba);
 out:
-	if (ret) {
+	if (ret)
 		dev_err(hba->dev, "link startup failed %d\n", ret);
-		ufshcd_print_host_state(hba);
-		ufshcd_print_pwr_info(hba);
-		ufshcd_print_evt_hist(hba);
-	}
 	return ret;
 }
=20

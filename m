Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793258717;
	b=eUgvyPWwluAfiXf2IkR6oBStHneoYQVwxoNn+iWZZNDWZIlkF2ABKREX00KshHCUKgj5
	 AuSO8y2OBm4fXI6fB8ijceqR6dC5AaSn9H4YVdhsG39iUpkcaF6LkOxH5ck5r4qdiO/+y
	 WMFsGxhy53mR4TaHcc1UZrRRpeN/NqG/BP42TA5PheOcB3DY0YO3dN8u3xOxyDEqv4BrA
	 qUrJl+gmwYIIXvkEBHpVcX7v0Auy90wd8EWam+ndWU3k+cwLyAB69Wjlyw74/LOtxI6t/
	 gxwIgyBs0EKbIBWiGuyrwlh84uDNOeMnvhusZu1YmJef7IINWZSdbj79aTvgPMMTvlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793258717;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=laRlzAtsKIRBcFs8iM4s6pQnI/rS0v1hGyELb/if4n8=;
	b=n09aS41/KSzAoKtusHW2WfqRSwseayRMBYT6B5KoJdM5B9HVS0M5AZ8kjl2xsDUvvZ2q
	 ScrTaiwemipofEA3RxyjOMPlqx8idrFlyRcCamxH9oXEZBlOBr+Kz66IeWxVrsiAQQPMQ
	 yaxcduhNyEllJQdgnn2wgB0oD8U6EAV9hLbm0KhEzrz1Y7DfTwM70rdjDB7pMYz8grUWW
	 f4Ew/P4XVHE+RwnEe4NwHatSak5vGbh4MnyIUwVZRuGj/uU/8c5rPtphxVOEvlCqfQbCK
	 ibvFDLq9ftRfx2Tk8QzgMT8rkTTxiMbJ3xYAejHNxZYxCOB6l1JvkqPdxzeSoJmVyMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=WZ3cO+wW;
	arc=none smtp.remote-ip=220.197.31.74
Received: from mail-m1973174.qiye.163.com (mail-m1973174.qiye.163.com [220.197.31.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE4606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:25:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61CE4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=WZ3cO+wW
Received: from localhost.localdomain (unknown [61.154.14.87])
	by smtp.qiye.163.com (Hmail) with ESMTP id 52c491321;
	Thu, 29 Oct 2026 15:25:04 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Heiko Stuebner <heiko@sntech.de>,
	linux-rockchip@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: ufs: rockchip: Improve RX noise immunity
Date: Thu, 29 Oct 2026 15:24:55 +0800
Message-Id: <20261029151030.1.I61cd43e660b146e49d4380a754e936270e5fb6a1@changeid>
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
X-HM-Tid: 0aa1868c4fe003a4kunm83c5329213e600
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCH0oYVk8aGhpLSx0eTkJJQ1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ0xZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=WZ3cO+wWijVGbctlALLZvC47QgebXvXj9s93VX/EXQMVvX3GIOl7vDjxOxE9MyiqYpy80UvtAzJcYdRQ4XOwbYovhQHWrdKYa2Hz9Lgpc3qLiPratjKQ6Hz2AoSJHPj2Hl5OiLqEaQTsYOuaYdwusVbbuFpF8SWog0mgMIz0gYw=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=laRlzAtsKIRBcFs8iM4s6pQnI/rS0v1hGyELb/if4n8=;
	h=date:mime-version:subject:message-id:from;

Program VND_RX_SAVE_DET_CTRL for each RX lane to raise the receiver's
tolerance against short transients on the incoming signal, as recommended
by the Rockchip PHY team.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

---

 drivers/ufs/host/ufs-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index bac68f238e1c..87308c9b1070 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -82,6 +82,7 @@ static int ufs_rockchip_rk3576_phy_init(struct ufs_hba *hba)
 		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_PVALUE2, SEL_RX_LANE0 + i), 0x02);
 		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_OPTION, SEL_RX_LANE0 + i), 0xf6);
 		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_POWER_SAVING_CTRL, SEL_RX_LANE0 + i), 0x69);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_SAVE_DET_CTRL, SEL_RX_LANE0 + i), 0x18);
 	}
 
 	/* disable the mphy DME_SET cfg */
-- 
2.25.1


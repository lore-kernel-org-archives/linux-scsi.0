Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21E647ACCA;
	Mon, 14 Sep 2026 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789394416; cv=none; b=Db5dpdnzNS4pf278qwMu2pKcvaer3+pV3Nnuq/XUk9gbVsXpJ5rvux1K/5EDtiHjD22FGKrlTbAnjln8cyqx5X+3jPZImo+TT3L7ycoXb8AHlcQgMwI+dbPvrECGIegc4gdUS7EWqxj51XS3H3RNskuiMsld2qRa7XaAoMfEpjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789394416; c=relaxed/simple;
	bh=3bZVcXvW5ldCAMC/kmfJvW1WdhG+3OknH1GD9+lD4S4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KRoJdjlQcsc5/CSfdzHhTfzgM8SqwZm8EU25Az5sobtfHQlX/Yz8UrMfvMpTL68ctApwId5+VYgsO0ZTOUqxW7RUAmxKcmYtvkoBEM00fOY3uwGPfek1o4A+vSHpN3WHurNLExufuZfJ0GHx9cUf03N0nzMMXisybmuvbTB5YgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0101F000FF;
	Mon, 14 Sep 2026 14:00:06 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Palash Kambar <palash.kambar@oss.qualcomm.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Koichiro Den <den@valinux.co.jp>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: linux-scsi@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: pltfrm: Add quirk for R-Car S4 lacking lanes-per-direction
Date: Mon, 14 Sep 2026 16:00:01 +0200
Message-ID: <ae0cc2bd764e6dfffce99db3d8b44a55887c508c.1789394185.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
during link"), the following error is observed on R-Car S4:

    ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
    ufshcd-renesas e6860000.ufs: link startup failed -67
    ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
    ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67

R-Car S4 has one UFS lane per direction, as described in section 152.1
of its hardware manual.  Without lanes-per-direction, the UFS platform
driver defaults to two lanes.

Previously, the core used PA_CONNECTEDRXDATALANES and
PA_CONNECTEDTXDATALANES to configure the link without checking them
against lanes-per-direction, so the missing property did not prevent
initialization.

While fixing the R-Car S4 DTS is the proper solution, doing only that
would still break backwards compatibility with existing DTBs.  Hence add
a quirk to let lanes-per-direction default to one on R-Car S4.

Fixes: e72323f3b09f9c89 ("scsi: ufs: core: Configure only active lanes during link")
Reported-by: Koichiro Den <den@valinux.co.jp>
Closes: https://lore.kernel.org/20260911073058.253000-1-den@valinux.co.jp
Cc: stable@vger.kernel.org # 7.2+
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Tested on S4SK.

 drivers/ufs/host/ufshcd-pltfrm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 5ac7afe759346deb..169dbc1a75fe5734 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -206,7 +206,11 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 		dev_dbg(hba->dev,
 			"%s: failed to read lanes-per-direction, ret=%d\n",
 			__func__, ret);
-		hba->lanes_per_direction = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
+		/* Old R-Car S4 DTBs lack "lanes-per-direction = <1>" */
+		if (of_device_is_compatible(dev->of_node, "renesas,r8a779f0-ufs"))
+			hba->lanes_per_direction = 1;
+		else
+			hba->lanes_per_direction = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
 	}
 }
 
-- 
2.43.0


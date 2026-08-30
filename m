Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC1825B0AC;
	Sun, 30 Aug 2026 13:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788096455; cv=none; b=Slbrd3RCwwjcexmkj2xJQ7fu7uX8RBzSPTN4T1uRo3VAEEdSAdZIoN1QoGPaeSli9atpAR6lKk+3G1SSXVLw0H+mYyN/z+RpRGa6PukUUxCJfOIAM949ZaxNPUgtpOGm9uEFItiu0kmZ8pqQu/GO1F55Pvo2x4BFcpIXVycnmq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788096455; c=relaxed/simple;
	bh=gTknnmJVsv1KKwoadU2pO+gLkmP3l7mc+0gm7q9pZNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fyvxqdzWWTlD4F1vpc9HRWmnEv3Ei9oVhuBkdnrrjl85gtIz88+fPBUNUkC3Viezd/qzgFSWVPF/V3n8pVHDpI8sKfktoCx7X1VwPLel5YkDt8jHVIvMDy48KdoNZHcjcrZsFN7fYBAEVClx9zbaZdAh3dbm/1e6U7DdriVB8V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowABHUD6+L5RqwBebBg--.40350S2;
	Sun, 30 Aug 2026 21:27:26 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ufs: rockchip: propagate controller reset errors
Date: Sun, 30 Aug 2026 21:27:23 +0800
Message-ID: <20260830132723.5855-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHUD6+L5RqwBebBg--.40350S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1xAF4fZrWkuF18AFWrXwb_yoW8KF45pF
	s8C3y3tr1DKF43XFZ7trn3A3WFqan3Kw47J397Ga4fAw1xtw1UWa4vkF1FqF4Dtry5ZFy5
	uF43Ja48uanFqrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbo5l5
	UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The Rockchip UFS reset helper discards reset-controller errors before
probe, HCE enable, and runtime resume continue as if the controller were
reset.

Return reset errors from the helper and unwind the resume clock on failure.

Fixes: d3cbe455d6eb ("scsi: ufs: rockchip: Initial support for UFS")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/ufs/host/ufs-rockchip.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index bac68f238e1c4..3b9661befe6ae 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -20,11 +20,16 @@
 #include "ufshcd-pltfrm.h"
 #include "ufs-rockchip.h"
 
-static void ufs_rockchip_controller_reset(struct ufs_rockchip_host *host)
+static int ufs_rockchip_controller_reset(struct ufs_rockchip_host *host)
 {
-	reset_control_assert(host->rst);
+	int ret;
+
+	ret = reset_control_assert(host->rst);
+	if (ret)
+		return ret;
 	udelay(1);
-	reset_control_deassert(host->rst);
+
+	return reset_control_deassert(host->rst);
 }
 
 static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
@@ -46,9 +51,7 @@ static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
 	}
 
 	/* PRE_CHANGE */
-	ufs_rockchip_controller_reset(host);
-
-	return 0;
+	return ufs_rockchip_controller_reset(host);
 }
 
 static void ufs_rockchip_set_pm_lvl(struct ufs_hba *hba)
@@ -167,7 +170,9 @@ static int ufs_rockchip_common_init(struct ufs_hba *hba)
 		return dev_err_probe(dev, PTR_ERR(host->rst),
 				"failed to get reset control\n");
 
-	ufs_rockchip_controller_reset(host);
+	err = ufs_rockchip_controller_reset(host);
+	if (err)
+		return dev_err_probe(dev, err, "failed to reset controller\n");
 
 	host->ref_out_clk = devm_clk_get_enabled(dev, "ref_out");
 	if (IS_ERR(host->ref_out_clk))
@@ -291,7 +296,11 @@ static int ufs_rockchip_runtime_resume(struct device *dev)
 		return err;
 	}
 
-	ufs_rockchip_controller_reset(host);
+	err = ufs_rockchip_controller_reset(host);
+	if (err) {
+		clk_disable_unprepare(host->ref_out_clk);
+		return err;
+	}
 
 	return ufshcd_runtime_resume(dev);
 }

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1


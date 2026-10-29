Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.126.93.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238542;
	b=RkqbwZzmXqWB9E/ILIA7teLUH8mx4AHC1h/zbCz8SYPJPJb4HLBQjMEbCQxDcbFqum9w
	 iIltfPBK30EE/eqJO6md5QrkXJL4HFWeu+NXAxmukw45IXed30Ud1MHt558TrYNTKyONj
	 OxozZVi1OWgDaFcWl1gJrO2x++YopXkL1Cf6zD8+w/z02CKFUQnDPhyqV54hHRM3JtP9N
	 i2vNBQeTZhlQt6/iDl39KuaMIU1VfL4EzaxBxjVxN5KAx1mMDoa1F3LE9aanWLHNNLPGU
	 WOTbd6QwL6LA/TmW+MfRYMBpCnGW4BMScQrZ69+iTBQU4jge1++Z4dMhZcj4DT9aUdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238542;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=8kTFkc1SQZFRTAY1PkZ4hE8zrC/53qbcoSnlYt68xys=;
	b=5QXjt7s1voE7i9jgy4thFiRzxZKHDcwYLSA0V9mPfq59rlP5rOFgDaEDu/PEtg8scLoT
	 VoXlJAuVDzXpG/Hzp67t5Wfmn+uWMuXqcZPylx2zivP9bUSk9KHLWZQbG5rNIPAZkLSP1
	 HMfk+pSujvrZFMs/gob07BxF6ERzPbtKoLRC11r2/AN3qmiK4p5x3LaI/7VW6GLOO9poG
	 B3ASw7LX9NikmyYq+jHHqQsR0g9YJ92NERVJjOKuu0ZSn55VjqJEpsrLGaQHxUYTtnvyt
	 p2LYLDeGvMZKmAhi+GzrX6qq3TojDIIfu5h81PKnEagVEBIq5reVIbTgCZoMKONtLfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=aWIIpH7T;
	arc=none smtp.remote-ip=103.126.93.188
Received: from mail-m93188.xmail.ntesmail.com (mail-m93188.xmail.ntesmail.com [103.126.93.188])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80994606A32A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 01:48:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80994606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=aWIIpH7T
Received: from localhost.localdomain (unknown [61.154.14.87])
	by smtp.qiye.163.com (Hmail) with ESMTP id 52b92425a;
	Thu, 29 Oct 2026 09:48:51 +0800 (GMT+08:00)
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
Subject: [PATCH v2 1/2] scsi: ufs: core: Move the device initialization sequence into a new function
Date: Thu, 29 Oct 2026 09:48:38 +0800
Message-Id: <20261029014839.3390579-2-shawn.lin@rock-chips.com>
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
X-HM-Tid: 0aa185587c5703a4kunmb608b1c4109638
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHkgZVkMYGEtLSUlITEgYH1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ0xZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=aWIIpH7T/sNX8MsAiLUoglRSY4DDGnQ31IvQL/UHHeqglsbKO23CxSpfhgQBLsVumeNGlGjuWx3vpb1jinYMExIwgQUKZD6R5OMHMwvxd0dueLJ9onwtYz3oUgIBeFyeod3ZwbmafOy+507eG5anz39YfHjp29BVgSMK0S2cNrI=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=8kTFkc1SQZFRTAY1PkZ4hE8zrC/53qbcoSnlYt68xys=;
	h=date:mime-version:subject:message-id:from;

Move the link startup and device initialization steps from ufshcd_init()
into a new function ufshcd_full_device_init(), so that the sequence can
be retried as a unit. No functional change intended.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

(no changes since v1)

 drivers/ufs/core/ufshcd.c | 84 +++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..f1e54d719537 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11207,6 +11207,55 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
 	return err;
 }
 
+/**
+ * ufshcd_full_device_init - Link startup and full device initialization
+ * @hba: per-adapter instance
+ *
+ * Execute the whole device initialization sequence used during driver
+ * probe: link startup, MCQ configuration, device verification, device
+ * initialization completion and device parameter setup.
+ *
+ * Return: 0 upon success; < 0 upon failure.
+ */
+static int ufshcd_full_device_init(struct ufs_hba *hba)
+{
+	int err;
+
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+
+	err = ufshcd_link_startup(hba);
+	if (err)
+		return err;
+
+	if (hba->mcq_enabled)
+		ufshcd_config_mcq(hba);
+
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		return 0;
+
+	/* Debug counters initialization */
+	ufshcd_clear_dbg_ufs_stats(hba);
+
+	/* UniPro link is active now */
+	ufshcd_set_link_active(hba);
+
+	/* Verify device initialization by sending NOP OUT UPIU */
+	err = ufshcd_verify_dev_init(hba);
+	if (err)
+		return err;
+
+	/* Initiate UFS initialization, and waiting until completion */
+	err = ufshcd_complete_dev_init(hba);
+	if (err)
+		return err;
+
+	err = ufshcd_device_params_init(hba);
+	if (err)
+		return err;
+
+	return ufshcd_post_device_init(hba);
+}
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -11420,41 +11469,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize hba, detect and initialize UFS device */
 	ktime_t probe_start = ktime_get();
 
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
-
-	err = ufshcd_link_startup(hba);
-	if (err)
-		goto out_release;
-
-	if (hba->mcq_enabled)
-		ufshcd_config_mcq(hba);
-
-	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
-		goto initialized;
-
-	/* Debug counters initialization */
-	ufshcd_clear_dbg_ufs_stats(hba);
-
-	/* UniPro link is active now */
-	ufshcd_set_link_active(hba);
-
-	/* Verify device initialization by sending NOP OUT UPIU */
-	err = ufshcd_verify_dev_init(hba);
-	if (err)
-		goto out_release;
-
-	/* Initiate UFS initialization, and waiting until completion */
-	err = ufshcd_complete_dev_init(hba);
-	if (err)
-		goto out_release;
-
-	err = ufshcd_device_params_init(hba);
-	if (err)
-		goto out_release;
-
-	err = ufshcd_post_device_init(hba);
+	err = ufshcd_full_device_init(hba);
 
-initialized:
 	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
 		goto out_release;
-- 
2.25.1


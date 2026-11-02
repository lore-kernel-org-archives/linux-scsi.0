Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=154.81.10.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793586133;
	b=fxjArN1CNFI6OlKQttdZWmEbJJhdvZAVPEmv+1m6Um8W0JAC77113To26kUCBMdDWn7S
	 K2iWEs0JDBPUfhqwHs8ar/n3/ar/lv8/1ce+J/bDbqpAANMYEVo2p56bqBIPS/Snc924K
	 x66PFcbgwqaHDg/Edh1fVKmTyhPPA/jBj04LSMKLSosSApA15PC8BPx8OPa+vv9caaB4O
	 0nxf/grFl1HVO7yKBV4w+wzp3OBawbxnVptlYhsltfyaJ4QiIhrH9pGidoLapmUkbHh8I
	 V6ZamU4qzj1agQPGRH0HJX7F2gBiHRn8BLlhNgC46UoMuDytEuXwfIdLBAcGl0gYtPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793586133;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=WsV/pVz+kBSHoatUMurOiQfqwn6UNHm3oJuaUeI8ahY=;
	b=mPYdfunK1rM71XbzYbL/t/GOIuFCRnmiWRpoG5DdT/5+3fBbeDc+o4md2q6JeUt2Tppf
	 /ZjP7JiUFGEPr2MNd+CPAqXwjZQVI9kT32gRm2+txlgVzUPHYRMoakBMG8vKMWX12bA6n
	 9FUElWAgGqASN9XhCIXR685eEGL21L+/caDhVXtXygZUXhCt4r9P5PSKYApl3XrWPsS+U
	 vLUx9trIZkvuMutLgQ4TU0iwB9i3I5sDsEM1NMY8OgopUoQksFP06to34RpAnDBQ/8V2R
	 Y+zGF4ceGBYQeE+wVYXmKB+lzR/DEiXDdghP0sDonBE7OwWSUoeDSDNlFhzxOwx4f4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=BF5o+P06;
	arc=none smtp.remote-ip=154.81.10.41
Received: from mail-m1041.netease.com (mail-m1041.netease.com [154.81.10.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F90606A327
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 02:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43F90606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=BF5o+P06
Received: from localhost.localdomain (unknown [61.154.14.87])
	by smtp.qiye.163.com (Hmail) with ESMTP id 531c1cf13;
	Mon, 2 Nov 2026 10:22:02 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-rockchip@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v3 1/2] scsi: ufs: core: Move the device initialization sequence into a new function
Date: Mon,  2 Nov 2026 10:21:53 +0800
Message-Id: <20261102022154.3903115-2-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261102022154.3903115-1-shawn.lin@rock-chips.com>
References: <20261102022154.3903115-1-shawn.lin@rock-chips.com>
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
X-HM-Tid: 0aa19a104edd03a4kunmbd08b4a83acede
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTR1DVh0eSEIdT0IfGU5NGFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ0xZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=BF5o+P06WJg70luHhbGG1IHQsFZ6CCBizEXpHV/nd3SK8O6hMx8SY4y2oNcsVWrxaxAoYd4d4ME6qTMVdbSPNWZ1zCwD0xEc4FSrXe+PxWe2+ZkpsZijHDrejvp/MjuKSjrmYhj77vlch+QXwPyMu6yk5G76VxKvr7v8FLrpsAQ=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=WsV/pVz+kBSHoatUMurOiQfqwn6UNHm3oJuaUeI8ahY=;
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
index fd52deb72d21..8a8083a8f024 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11215,6 +11215,55 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
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
@@ -11428,41 +11477,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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


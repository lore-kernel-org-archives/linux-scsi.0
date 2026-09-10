Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3F7302753
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 01:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005313; cv=none; b=KQJWkoP/O5WIaFsczx6Z+J8S3MtHSt1wZZHrtNI81iiHXk7aue+9PfBxcP8Q5medPH1u8g2vz3L89gSyBtlMpDcqgTW9IfK4aMb+TMXxPHo5AoVMbylaaRzc8RG0pGFoJ1FrgEyqiG7+UIz5mLCyjlufTiTtmXY1jDGTLO9L2tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005313; c=relaxed/simple;
	bh=ESP5vcfHg5EQaCQZksyCAA5yYo0vvPVNjjiY5EjrX4E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jKbDl723rsEigs/0moFH4Ppt10BQWocdk9KhjO8yANK4uu7bJGZj3krSVfy6OScgOXKkRlwW7DB3ZOwp2y3q5AjQjUFBozvyGP+DGKGrwyyUQaLEWCq0sLGLmOqIClBEAXaGP9KbFavfIVqpWYZooP92944IN+kTAya6DI8pX2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jHGi9pv5; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jHGi9pv5"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39b90cc0d5cso4313918a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 18:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789005308; x=1789610108; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ET5/GbgiiB4Lp6CLcqQ3B6Zkpa2YVFmls1cNjryflLY=;
        b=jHGi9pv5SlFq/J2YOpNxkr0nJ2/t1eLBwFJ5bGsVjJSXUh1wgDbSAiOAD+Y433yMkT
         xitMqWMT8ZI7egzvIbVFgM1i3p3lMwdjasA0rktxAbSMx0rwQ+Qd3UJKjCmGf+awU2iM
         pazsWQWy9YrZFMGriwH+1VMoWEu4wifiTvpYwRQ14Li0Ymu2FeFF2lWFIcLBm71YOox/
         eKALELdrLi+N4jYaruM6YdIeC6wDkxES43F7UwR2MCndp2gBCm7AUCo7g7zZKXTZwBxE
         Hrdg4b3MUxu+BW+Ee+XrAtsKDGiGrenaLZeV99kePXV9+wG0leCXJfcbxR05oLYFvtQt
         MNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789005308; x=1789610108;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET5/GbgiiB4Lp6CLcqQ3B6Zkpa2YVFmls1cNjryflLY=;
        b=EW7CQhUcInMkI/RytX60y6/l84jqXabFmZQa6KJGO3roiZtDJCv5q/RwwBg1yn8zsC
         xnYcoVnOAlDqVSXiZVG9LjfogYkcOCZ8beUiRKOt5XR3nFhPjqRCSJjBISrc+OQyPdwu
         Nz9aFq87+/sccJpuYBdl1yg9PGHvXd5MqRHagrlN91CAE27cHQR9dT8Q7vRD5fdwWbhP
         GOmttgNNx4Pr7lMnM1IgS5LKm0UTguXvqQu+l7xVwDYwRp97Dlt7U5ffYxnqrZrkQk4p
         X+E4tYusVaO34T034swwhSzOvK3C5mcEJ0sZczsMILeSyKBp+RAWp2loQjze0UsIuNoH
         cLnw==
X-Forwarded-Encrypted: i=1; AKwUvByLPzE2w/jlZBKUQATw3zKbR+VRxoYD1ZCN5IbzzNHOzE0Yvda66TmFg0c1U+r4bHDT9V1V4OU/t7mr@vger.kernel.org
X-Gm-Message-State: AFuF++n1RdfusejWoV0XE8AHfO+KbHvZ00g4IDWFlM3/gC9Wtt8aSs9S
	jSDaDKxP287bWkHnB9F733S95I5Fd4gDF5nJpN7R9HGd05YuyrRzh6UwNuX9cizyAhHflCm11dl
	1n3HbVbhC/tyPFNtVqPmuGA==
X-Received: from pjte17.prod.google.com ([2002:a17:90a:c211:b0:39d:7360:f8d9])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1641:b0:399:1f8b:d255 with SMTP id 98e67ed59e1d1-39b260dd3fdmr55287009a91.5.1789005307303;
 Wed, 09 Sep 2026 18:55:07 -0700 (PDT)
Date: Thu, 10 Sep 2026 09:55:02 +0800
In-Reply-To: <20260910015503.1991119-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260910015503.1991119-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910015503.1991119-2-stanleyjhu@google.com>
Subject: [PATCH v3 1/2] scsi: ufs: rpmb: Register and unregister ufs_rpmb_bus_type
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Li Qiang <liqiang01@kylinos.cn>, 
	Ao Sun <ao.sun@transsion.com>, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

The UFS RPMB driver defines ufs_rpmb_bus_type and assigns it to the bus
member of struct device for each RPMB device. However, ufs_rpmb_bus_type
is never registered with the driver core via bus_register().

When driver core rejects devices assigned to unregistered buses with
-EINVAL in bus_add_device(), device_register(&ufs_rpmb->dev) in
ufs_rpmb_probe() fails with:
  "bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus
   'ufs_rpmb'"
  "ufshcd: Failed to register UFS RPMB device 0"

Fix this by registering ufs_rpmb_bus_type during UFS core initialization
in ufshcd_core_init() and unregistering it in ufshcd_core_exit(). Add
helper functions ufs_rpmb_bus_register() and ufs_rpmb_bus_unregister(),
guarding their declarations with IS_REACHABLE(CONFIG_RPMB) and inline
fallback stubs for configurations where CONFIG_RPMB is disabled. Mark
ufs_rpmb_bus_register() as __init so its memory can be reclaimed after
module initialization.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c    | 10 ++++++++++
 drivers/ufs/core/ufshcd-priv.h | 13 ++++++++++++-
 drivers/ufs/core/ufshcd.c      | 16 ++++++++++++++--
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index aa925cbb07e8..c7aade96c823 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -28,6 +28,16 @@ static const struct bus_type ufs_rpmb_bus_type = {
 	.name = "ufs_rpmb",
 };
 
+int __init ufs_rpmb_bus_register(void)
+{
+	return bus_register(&ufs_rpmb_bus_type);
+}
+
+void ufs_rpmb_bus_unregister(void)
+{
+	bus_unregister(&ufs_rpmb_bus_type);
+}
+
 /* UFS RPMB device structure */
 struct ufs_rpmb_dev {
 	u8 region_id;
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index e55c2a02c1f5..d5e0cc3edb5b 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -493,10 +493,21 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct ufs_hw_queue *q)
 	return val / sizeof(struct utp_transfer_req_desc);
 }
 
-#if IS_ENABLED(CONFIG_RPMB)
+#if IS_REACHABLE(CONFIG_RPMB)
+int __init ufs_rpmb_bus_register(void);
+void ufs_rpmb_bus_unregister(void);
 int ufs_rpmb_probe(struct ufs_hba *hba);
 void ufs_rpmb_remove(struct ufs_hba *hba);
 #else
+static inline int ufs_rpmb_bus_register(void)
+{
+	return 0;
+}
+
+static inline void ufs_rpmb_bus_unregister(void)
+{
+}
+
 static inline int ufs_rpmb_probe(struct ufs_hba *hba)
 {
 	return 0;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a25b6a0cb5c6..4470e3d65c5c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11584,16 +11584,28 @@ static int __init ufshcd_core_init(void)
 
 	ufs_debugfs_init();
 
+	ret = ufs_rpmb_bus_register();
+	if (ret)
+		goto err_debugfs;
+
 	ret = scsi_register_driver(&ufs_dev_wlun_template);
 	if (ret)
-		ufs_debugfs_exit();
+		goto err_rpmb_bus;
+
+	return 0;
+
+err_rpmb_bus:
+	ufs_rpmb_bus_unregister();
+err_debugfs:
+	ufs_debugfs_exit();
 	return ret;
 }
 
 static void __exit ufshcd_core_exit(void)
 {
-	ufs_debugfs_exit();
 	scsi_unregister_driver(&ufs_dev_wlun_template);
+	ufs_rpmb_bus_unregister();
+	ufs_debugfs_exit();
 }
 
 module_init(ufshcd_core_init);
-- 
2.55.0.1007.g17ff1f9808-goog


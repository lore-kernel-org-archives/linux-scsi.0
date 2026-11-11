Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794407056;
	b=YfF9yRKuZRf/Dxmkh+bLSzJwC3VxS/swVzrFV7NZ1btSMsFUAq9RauY4brlPu1DTXLRv
	 B78ydJ3MQHhlXmDT5noGG8xL6jtPsihzDZP+hBU/QNCYLOzuLFIlU1TJiWECLnwFwNq3d
	 QIIhJ96gJTbLE+INwSAfT6d44OfIO3xg167ed+4Zvv0jpIC0B4vXNpCIrjs/hJK2p7UV5
	 WGg1nqVXEw4s0BjCStRjpVJPXhZrWW6I0f5UXeepvOZyM+r0UfRPKEBo19KFbd3Ih2VID
	 ES4IVjG7qn7c58lklvQQSeaWwMTOHMUkpE4oZYIN/1owgdgkADYaHK53dUwpN5o0sXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407056;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=SkvKw1RkLoUo4P/RmV52C0aJoH59lmWCBYxJx4Vfna0=;
	b=i9Bbw9sAMmxd6VCLXzu8YEpUp/647QrKNi9HzfUcMFeyk6Xh+v6N/C6hcvgopVDXXlRt
	 g3UMnwwMf7thgIOrXNd149ZqfNr1So0CcFlaXuBgk5YTaXPTOqRPc//fXKXJHyfqHRx5W
	 83VypKpEKKY01yMlqyMRX8d9Bv4QFdxsIySVS5Uq7Ami3uwZilzc2EmXGqoTlTyoMWdFn
	 8LenzWv9WvYbpIR9pf365Lcc+1uuqfoYRYXUzxtjMvAI5RyMS+uIIVEWQaqOMhgGh4Unj
	 ydvMzqTjqhHGX3g88ZeItw+6+YJZq1SHhnn2/nNtCtiZyGzoMu2lcvEPxtUNMUeThXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=rKWeDpvM;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DAE606A8B4
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 14:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41DAE606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=rKWeDpvM
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48fd2e38825so1948842f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 06:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1794407054; x=1795011854; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SkvKw1RkLoUo4P/RmV52C0aJoH59lmWCBYxJx4Vfna0=;
        b=rKWeDpvM3gXppe2w1jRx4FDwGNAKUchjBvJal0TxqQh/YSwzenzj6z021+9OEGGkJc
         6xDu+CwxTsiIQs9dXaZW1zMGcGb2MY2Ze4LFuhu0wQunAZhtjj8mh5eeTdtEln8n2kaY
         HDM+uHRB41a89Ckyx3ywLtKOazGptRSKp7wry4CMdH3f09HbqHr72HAAWe7pdmTVpehw
         t9HpUyDPpfR+ixEAM8He+pPQf8b8CSEwLdRqJUsESJWYp7CnHcv1scSb8uD2GIDIEOxB
         F7E+DYbshgAshLvgWXkdjbSdMBVlEXXKCzMhYOG6nlc28TvVyOClwEfQfIQ4LTklc8sy
         goxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794407054; x=1795011854;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SkvKw1RkLoUo4P/RmV52C0aJoH59lmWCBYxJx4Vfna0=;
        b=Y4kfw3lHILxmnUyNTLMK56QSs+NjBRwG0Zsq4jvTl2WiQdMg0FgL7MkYfGWHQmJg4r
         NtFruiQYFCBTg7kdZCqLs0N7jeTHRrFW2wD2NC4zfN3+uPJeUNJtbYavLvlcM7TYKi6K
         CbVknb6azcA3pJgWUcxgF5FziPxA/gQjLG2h02Wuy8ResptvmVF5nQN7+P6+1kvdM7LF
         o7uccJefz1y693dBk6AFzEbPaZPi8hf79jbefEuCvQmeE6/BWBKaMYKXnDRwZBdPldQ/
         FyyNzCIHQ+ZPpVuaiKQ9PEfJGZ7F3L4aJf3xLkyiTnX+sdczm0qUi9xlUwG0VYUjbpwP
         x2Dw==
X-Gm-Message-State: APuU4Z9J6C8cHXLJfXZkv2io6npR9GoMbuY9zq+BjXaYKm70jA4TTLbU
	qbatI8QqlpCwQ9XPwJHXqIF50UDXgNwHh9YoR2/dsf2w6/ebOYpxdaV2dgyophjA8Z8=
X-Gm-Gg: AYBFou0TxQOb4jj3yf3+JBVY/2XWrsBPLv88PvrKbYD3kTJ669SjyaQiC356ic9gvav
	hmcuylyTxB3kucvwCrkhJQjqw5bXNXefi+V9ZC7nyb78Ik8koItU3nAD81sbY0Ce/16VPSmoVTm
	bhuLiT8eklmRz/oKbBPwO478vOhLNDItlORCA4RWsjAUogANtyy7mWmpbWDJW1FtvbkjR9Z8cga
	V4Ctaoxt5rXKFw5GA/wKAafxc1iMGQ0p+56Y7NbEBT3mNuEPECAORy/qIIzAhvHoVZQ421nRK70
	xmJMJGY2sMjuNB4oozvHtCdkyS118PNXovXOylC9Wbq/npB1wVblUmf1wmN8GcVuZwBi9W13Ur0
	8DbBYy5Rx7T5jWnYlMZLSsJDEOO0R0amzrhD83fX1xtjmISv5NXYwcdq95xFYN18axZMO0NQWLx
	brhpYONEVdO/2lpZH4P2QOJ010doOC/VFeRuq8R2qYx3r0rtie6IOJZ1eNLZQ+a2uss69BWtcAH
	be56DLBFEmK5xWgsbLnv+jnxkc4Mk4CUMOuZ9Z0bHnM51bzraHsr124V17/eeLPxF53KPYtitbd
	3Jb316VC4y3LRyOvb8fM4OoRgURA1HFkPn6D+zuAYmL2Nbp/FqWzrsXLevZIlTqS8lhbBus3/GA
	nOyfnlSQiGQ==
X-Received: by 2002:a05:6000:5c7:b0:490:9fe2:6a39 with SMTP id ffacd0b85a97d-499c6027cc4mr4071191f8f.20.1794407053616;
        Wed, 11 Nov 2026 06:24:13 -0800 (PST)
Received: from alchark-surface.localdomain (bba-86-98-194-229.alshamil.net.ae. [86.98.194.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498363df7a5sm11352871f8f.37.2026.11.11.06.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:24:07 -0800 (PST)
From: Alexey Charkov <alchark@flipper.net>
Date: Wed, 11 Nov 2026 18:24:01 +0400
Subject: [PATCH] scsi: ufs: core: Register the RPMB bus before adding
 devices to it
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDINAtTSvWLSrITdJNKi3WTbZINUk2TDZKNrFMUwJqKShKTcusABsXHQv
 hF5cmZaUml4DMUKqtBQDF/kqFcAAAAA==
X-Change-ID: 20261111-ufs-rpmb-bus-c8e4c1c2c49f
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
 Stanley Jhu <stanleyjhu@google.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Avri Altman <avri.altman@sandisk.com>, Can Guo <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
 stable@vger.kernel.org, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3211; i=alchark@flipper.net;
 h=from:subject:message-id; bh=rACyBhlqQdc7vEC+waUwW3Q2wxEerf4GPNn9xVrd1kk=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWR9qWrhLHryfo6Zfv8kgTXmP5Ycq+UK9rIJfnTBefE/R
 eM7n25+6JjIwiDGxWAppsgy99sS26lGfLN2eXh8hZnDygQyRFqkgQEIWBj4chPzSo10jPRMtQ31
 DI10jHWMGLg4BWCq73UwMvTapVw7c+Px7UTL0o0fu0xWTvzBXzvvsdqKE/etJ54MVFzEyHCv4b9
 a2rTNWwKmWhle/3Oy5fFh30eWkzXP6YQY75960pYFAA==
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

ufs_rpmb_probe() puts each RPMB region device on ufs_rpmb_bus_type, but
nothing ever registers that bus. The driver core used to accept such a
device and treat it as having no bus, which hid the problem. Since commit
36f35b8df697 ("driver core: reject devices with unregistered buses"),
device_register() fails instead, so no UFS host registers its RPMB
regions any more:

  bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus 'ufs_rpmb'
  ufshcd-rockchip 2a2d0000.ufshc: Failed to register UFS RPMB device 0

Register the bus when ufshcd-core initializes, before any host driver can
probe, and unregister it on exit.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 drivers/ufs/core/ufs-rpmb.c    | 10 ++++++++++
 drivers/ufs/core/ufshcd-priv.h |  9 +++++++++
 drivers/ufs/core/ufshcd.c      | 14 +++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 756673337648..591e7f2e1474 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -276,5 +276,15 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
 }
 
+int __init ufs_rpmb_bus_init(void)
+{
+	return bus_register(&ufs_rpmb_bus_type);
+}
+
+void ufs_rpmb_bus_exit(void)
+{
+	bus_unregister(&ufs_rpmb_bus_type);
+}
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("OP-TEE UFS RPMB driver");
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 99f654b79035..4f2661036d7b 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -499,9 +499,18 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct ufs_hw_queue *q)
 }
 
 #if IS_ENABLED(CONFIG_RPMB)
+int ufs_rpmb_bus_init(void);
+void ufs_rpmb_bus_exit(void);
 int ufs_rpmb_probe(struct ufs_hba *hba);
 void ufs_rpmb_remove(struct ufs_hba *hba);
 #else
+static inline int ufs_rpmb_bus_init(void)
+{
+	return 0;
+}
+static inline void ufs_rpmb_bus_exit(void)
+{
+}
 static inline int ufs_rpmb_probe(struct ufs_hba *hba)
 {
 	return 0;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c9b2eefbd7b0..4653d497e27b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11687,9 +11687,20 @@ static int __init ufshcd_core_init(void)
 
 	ufs_debugfs_init();
 
+	ret = ufs_rpmb_bus_init();
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
+	ufs_rpmb_bus_exit();
+err_debugfs:
+	ufs_debugfs_exit();
 	return ret;
 }
 
@@ -11697,6 +11708,7 @@ static void __exit ufshcd_core_exit(void)
 {
 	ufs_debugfs_exit();
 	scsi_unregister_driver(&ufs_dev_wlun_template);
+	ufs_rpmb_bus_exit();
 }
 
 module_init(ufshcd_core_init);

---
base-commit: 793807ca13bf3072fc6d16ce6d90e9ab9beff2a5
change-id: 20261111-ufs-rpmb-bus-c8e4c1c2c49f

Best regards,
--  
Alexey Charkov <alchark@flipper.net>


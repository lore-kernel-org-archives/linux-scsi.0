Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED9848C40B
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519625; cv=none; b=PUBv9fpRy27ZUEwFc3PqJRIYT0I4LogfFc74gTe1DVxzZ+4zDSfJDHRO3HxZgkTQIz3vdgdSlmpn4igSChXEsA74Xc2GAJjsuqxX58eQuCEo/BDy5Tt68Yywk1omqmDmb4JpGyskPsHJPPt7SwKkVfA2d6qlZt7aMjeFwaKxfW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519625; c=relaxed/simple;
	bh=ec3f2c/2ovVBbSwOHdK1oiWlSRb218cenPSOQvS+b1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gAgdLM3grme/xf0kOVlaVCMhsXvjwv9SrYSAXFSCPjZC1on512w60Kco40llbe9ZlovioZ1kl9DglLE0JpHv8fTMpU6/iGxNBaWBq7q0bWlx2boj/ASOWqcUG4+QF5uThCGGY5wK1ZZAQAS3mYKm0wJsycS0CmQgB2gqtL6O0Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dkBfu3Cs; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dkBfu3Cs"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so1868875a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 04:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788519623; x=1789124423; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zo7VwFgsbtJ8UJqRREQfIoxVumyrpqsEREUtKGw4Baw=;
        b=dkBfu3CsCjYICrP+RgbLcA7k/mX3cJnwLzQ8qYboK/5hMbEu0b4lleC+DbsAWMkw6h
         UIqWJBXqIg9NLKtxcQQaYBIPQQlMSy628uQax4DnhcifP/xWBK1QWd2ZJmq+xjWWBpfs
         yrKXsOMfJ7AdbRtw19uhTkEGmkwBUMcfBtPUfO89zjbylv2H6yttgUqoDcllXuYi61Zr
         MktX407CUW08k0w+r3MtHgjSOoDqMSBkDAiHfR4cqFeT42qM/3Vb2FyU9PT/juveBf/0
         uMgdL05V3ObtFyqsbk3oFYPw+7Pgb6OJD/BKZDgrEDWsG8K1PGSkiKkjHYA2L2EJvt+7
         o1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519623; x=1789124423;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zo7VwFgsbtJ8UJqRREQfIoxVumyrpqsEREUtKGw4Baw=;
        b=U/dUh5y9zWKIVjnnz29OsymawmTa/xR15gwVF4yqJSEUPcQgpKZx+QVotIEIgut4NO
         m7M6QlCxoQlcAYG1sHt9/tm+O//cWkzeaicyhEWZAMIhmpL5DafLFy89vmgjYeeR74Xp
         NfODNr3ccv7C6x5IMLlrpn6WPCnynQZPQsmJD59Xr2v7sGMFaQMt490czR0Yz3eiluss
         Jxbp//M5UM1+lPBwwFsjffreJR8HF6eHFdUCWbqzgwXmresSvzylCHK0P2VMqRrd0ZSj
         vNUF6INLD9CDJQupVS40mmHUui277olpF3NKKomFOs6+YSHGiBhVfkg7pj5jUbyU3TlY
         WM4w==
X-Forwarded-Encrypted: i=1; AKwUvByoOjphPRt9fmse3EuLcc4pneRhAyA8+eYyunSM7Pcdbi2yPgKjBPdBNR5WfCM84r3vUertJpeg5jB9@vger.kernel.org
X-Gm-Message-State: AFuF++nt71w4pBFZN7Ioxq4tounhL4xXRhkdKJOyUM/KIcHuULmI79ti
	iIs5zkLnd9qigeb8vB5oOeOwTpBfJMM75KkLpmJznV3v/X0EDorrn20iA7JB+faQfyofbgEF4Kd
	8EtCaltxMpydPUuI16eGhuw==
X-Received: from pjye1.prod.google.com ([2002:a17:90a:ee01:b0:398:d6ef:834])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3943:b0:398:d8eb:cb2a with SMTP id 98e67ed59e1d1-39b26273e31mr9007463a91.23.1788519623111;
 Fri, 04 Sep 2026 04:00:23 -0700 (PDT)
Date: Fri,  4 Sep 2026 19:00:17 +0800
In-Reply-To: <20260904110017.3444852-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904110017.3444852-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904110017.3444852-3-stanleyjhu@google.com>
Subject: [PATCH 2/2] scsi: ufs: rpmb: Register and unregister ufs_rpmb_bus_type
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

The UFS RPMB driver assigns its devices to a custom ufs_rpmb_bus_type,
but never registers this bus with the driver core. As a result,
device_register() fails during probe because the driver core rejects
devices attached to unregistered buses with -EINVAL:
  "bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus
   'ufs_rpmb'"
  "ufshcd: Failed to register UFS RPMB device 0"

Resolve this by integrating the bus into the UFS core lifecycle:

1. Bus registration and lifecycle:
   Register ufs_rpmb_bus_type during ufshcd_core_init() before any
   device probe occurs, and unregister it during ufshcd_core_exit().
   Annotate the registration helper with __init to allow init memory
   reclamation.

2. Modular reachability:
   Guard bus helper prototypes with IS_REACHABLE(CONFIG_RPMB) and provide
   inline stubs, preventing link failures when UFS is built-in and RPMB
   is compiled as a module.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c    | 10 ++++++++++
 drivers/ufs/core/ufshcd-priv.h | 11 ++++++++++-
 drivers/ufs/core/ufshcd.c      | 16 ++++++++++++++--
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 4f41d0b64d20..cf8982824b14 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -29,6 +29,16 @@ static const struct bus_type ufs_rpmb_bus_type = {
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
index e55c2a02c1f5..415f9230b164 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -493,10 +493,19 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct ufs_hw_queue *q)
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
+static inline void ufs_rpmb_bus_unregister(void)
+{
+}
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
2.55.0.979.g7e5102b832-goog


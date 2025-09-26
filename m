Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109B3202976
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758929810; cv=none; b=fVcDfwhma9voPLI6DeTss9ekTnGwBkKWF9X6aegNaY18rzZ3W7LJuXAtEK0+PCPMMjVR/cA6v7NmZTp8q6uXT5FugQhsKBcBsFxlF7wct8ZdSmodabyBw/Ah8Lrwmd173j+P42QTSzf8hjPqtznEQ8rebK1wFFL1HDewuxGedpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758929810; c=relaxed/simple;
	bh=I2Mz2aveKudWjBG56cCpDPgKcjygvlC0hAMQrwbfHiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pppbNSBR7iWy0ye7wSKfhGksuxifHSlyXJRAWTuD/spYsFInAcidYfprqbkCaQl5rXDj1l6Bip2dxDzsgl+d2DvyI2HVU801e6fiI2aslFOaVrQkbw4UdZ7lMkN0YRscSB9iKajScVoU4pRTDYlvI99WMf4Gya0+bHePIs/ebFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=HS0CZFIe; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="HS0CZFIe"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77f68fae1a8so3740465b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 16:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1758929807; x=1759534607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mj6zPN/OKSYjQGWBqwR3zeZiuhE+ieUvPsRJbGl8RZQ=;
        b=HS0CZFIeKc75rpLTUl7ceWq1bM1wLxuGDIVRrER63jpKTtVVN+i5cPQZP2PRAsDeiD
         Djh8lUV+QLHKn9VpXBoYNqBoufXv3P95Pu4HE8A0JMK11LXHUodSou78ZtCslGtS5eqq
         A99zaOBNhiSzZbdVY5KAHtczBGqrGLYJOXT9Dm5Ib8f7O2ORb6uP6duyyg6F5L0ol46n
         dd0ocDd+EfYCiX5EQFAE3Pp9WrY+aFhgnN3vvDJPYXCBoNlM9oqY0iBCaiqHgoQz+EYK
         RCiBztXbTwqzVTRykOXm9RwGZgl7U+vftZs+RaGx/B+95+bP/6udeiCEzs1ihY73Nswl
         mJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758929807; x=1759534607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mj6zPN/OKSYjQGWBqwR3zeZiuhE+ieUvPsRJbGl8RZQ=;
        b=SSiZJ8igW790CMw20e0SRM40a4po8qXjgGgOiLPmEDEaIgTbOQmj8K0OZtC12kX3OP
         1fOSt/EDmxeOP9WQEJJQp1x+1/dQqhHYlgEzAsUsr71OKyFrJtUsCH6LqhMysJlyO0T7
         VLdOAhX8YvExnTom5M17x7SZnKOMtJWoYixo07gvRa+4uihC53vc5npW2ORC+6+lYafQ
         8vN2EoGGlzNW6SyonDb4gr6+fDzAKuSse5V7afN4aazd4XQDV4vNJjq9JdCdmT/CcNQz
         00Sk+/ks2Q8IorK8UWRVUCN9u8Vh06UxIYqjUd1qjOIjylWEj1hs9KDSqhtfF9B+CkTu
         mWrQ==
X-Gm-Message-State: AOJu0YzImqcruwf503bzXTZ1l7F9yPtIJGrtOLptqCMwk6nmlTeK71Yl
	qQDKQX2woF/lDlehMWfKppIGLJkyB3R67x37WG7zXOMcIwizD3t9b4CO3iCYAtwjyw==
X-Gm-Gg: ASbGncvJLvuFwOB4Y5Rt+N3wMEiZNS2ivHcuftn4Y6Z07iEfMUj+1ybZPTxZ9/RmdJP
	wmQ0WhnxuxUIoF2rtjYknPFP6dR97wWlnJb4m7nq90JFTlubXQzkBOJ3uXxmMG2B4iOInKG8ExD
	poyIt3g302qzDzzAGJdzKZz5+wRtppDxUWegOV2ybBKoXSXgORqCBPvyiWX3oZLMsu6NjoPNyx/
	n4ooOKMqzlwakPa3vr31FmM67W2b/a0pId/qNwB6sDJo7Gys19xl8U4ohPx7DtHvQCe9beGTw3c
	DTIvd0C0ArKo1v5I7Z2qgT7g3/9794psf9HsHfBtrM0GCt6oODrlfU3IeIp2JSQy5qVMJN9NGN7
	fdGcRH7R3xog06VWSj/CsQkPpRkSQkb/UsKGvvtBjHuMZIhvhFhiwoh/kdA==
X-Google-Smtp-Source: AGHT+IFZEBrKtz1BDhTWgm8mofWtOzIr+Z/c1j14YCTUV+GOrNl6Ivmww8swrYG7BZcL4aDuz7K3PA==
X-Received: by 2002:a05:6a20:918b:b0:24a:8315:7f5 with SMTP id adf61e73a8af0-2e7d3db5fc2mr12114110637.31.1758929807287;
        Fri, 26 Sep 2025 16:36:47 -0700 (PDT)
Received: from sushrut-work-nzvdj.sjc.aristanetworks.com ([74.123.28.17])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55bd160sm5594002a12.47.2025.09.26.16.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 16:36:46 -0700 (PDT)
From: sushrut <sushrut@arista.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sushrut Shirole <sushrut@arista.com>
Subject: [PATCH] scsi: sd: Add sd_stop_on_restart parameter for restart device shutdown
Date: Fri, 26 Sep 2025 23:36:42 +0000
Message-ID: <20250926233642.268514-1-sushrut@arista.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sushrut Shirole <sushrut@arista.com>

Currently, sd_shutdown() skips calling sd_start_stop_device() during
system restart (SYSTEM_RESTART) to avoid delays during reboot, under
the assumption that storage devices will maintain power and don't need
to be explicitly stopped.

However, this assumption doesn't hold for all system designs. Unlike
traditional servers that can maintain storage power during restart,
some enterprise network equipment, embedded systems, and specialized
hardware use centralized power management that immediately cuts power
to all components during restart. This can result in:

- Filesystem corruption due to incomplete writes
- SSD firmware corruption during metadata update operations,
  potentially leading to unrecoverable device failure
- Elevated SMART error counters (e.g., Unexpected_Power_Loss_Ct)
- Potential data loss in systems without proper power-fail protection

While the kernel provides manage_shutdown and manage_runtime_start_stop
flags for fine-grained control in other scenarios, there's currently no
mechanism to ensure proper device shutdown during restart for systems
that require it.

Add a module parameter 'sd_stop_on_restart' (default: false) to allow
administrators to enable device stop operations during system restart.
This maintains backward compatibility while providing the flexibility
needed for diverse hardware configurations.

The parameter follows established patterns in other SCSI drivers
(e.g., smartpqi's disable_ctrl_shutdown) and provides a clean
administrative interface via /sys/module/sd_mod/parameters/.

Signed-off-by: Sushrut Shirole <sushrut@arista.com>
---
 drivers/scsi/sd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..d280b395026d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -116,6 +116,10 @@ static DEFINE_IDA(sd_index_ida);
 static mempool_t *sd_page_pool;
 static struct lock_class_key sd_bio_compl_lkclass;
 
+static bool sd_stop_on_restart;
+module_param(sd_stop_on_restart, bool, 0644);
+MODULE_PARM_DESC(sd_stop_on_restart, "Issue STOP UNIT command on system restart (default: false)");
+
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -4172,6 +4176,9 @@ static void sd_shutdown(struct device *dev)
 
 	if ((system_state != SYSTEM_RESTART &&
 	     sdkp->device->manage_system_start_stop) ||
+	    (system_state == SYSTEM_RESTART &&
+	     sdkp->device->manage_system_start_stop &&
+	     sd_stop_on_restart) ||
 	    (system_state == SYSTEM_POWER_OFF &&
 	     sdkp->device->manage_shutdown) ||
 	    (system_state == SYSTEM_RUNNING &&
-- 
2.51.0


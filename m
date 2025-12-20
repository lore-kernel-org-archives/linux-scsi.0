Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F3199FAB
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 05:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766207785; cv=none; b=BZTZqxEAeWrnN+InrlitpmHMnxPHjZSBq5imDnC50fuvGx9E3gIWPKo6oPiBKE9fvNlFtXB10mOlGhrdW5rBbrSv8QNOqaxg36YuVvh6Pef/yh1q/18mSwd8I8EQDVh6Cgp3rk80TzaOkKJd39d1+aKqzNBlCXt2TMd3AjdYxHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766207785; c=relaxed/simple;
	bh=heCnGnMKMCu+f6dMB1B6olfy5gzoNlLsvvvDaY3i5j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXVPltfxScMEPAqbcuPhKemN68WjGfyCLdSumUYVq7yiHsT07L7Ha0WPNA2O7dVwxuQT4zy0sNi74xmCd3SRCBuKhF261kGCAg3cbNqSsmrn7w3Ukis5TPWTzbcWchzHbDv2x+aDYq1HvLd8I2uemG2MT/C/dqOBjO8gDv0DhRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+Nky+Z5; arc=none smtp.client-ip=74.125.82.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+Nky+Z5"
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-11b6bc976d6so5145741c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 21:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766207783; x=1766812583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ul8Db7t9JCDO2Ye8ac6oZBB5oqxqLdk9bqlSfhPhTMs=;
        b=X+Nky+Z5Cb9xjF/XPmFQp64Ev7CYejklbG+5W/9+vwS3Jc8WeNAykkaOqF4ElnQRRU
         OnTBcHlivZ57ylU9yET49jlzO67kvJ7v6fydmbyjIiDPb1fslBbgd9oY8+Up/Z//H89Z
         lcl3ZGDORat2a9a2Pt3orPeK3JCUCA+zzs3ysyLfen2Ja52Geo7GeMVqUaPCW5mVWmXO
         Jbx4iO7vRsvMdHEScaCGHqdrA/eVLvIkJZClMADT61uSjHwWJ3olCpDFjPrjqb62k9E/
         V8jGuTkJhumTNzabo363TS/rEzrn9Qbaj0q6oKsS+iq2nq2YZFuujIW6CI4O9HTidb9C
         HESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766207783; x=1766812583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ul8Db7t9JCDO2Ye8ac6oZBB5oqxqLdk9bqlSfhPhTMs=;
        b=AlxKHHZgptrFEExUoKnyJEarwCpJIcDr+ddoQP8QHvsnEoKJ3i2a1j5NNiSwnbo9XU
         eeZppinbCyz2RkSLOcrFgoECW02T7lR8p59VWNAwNR0cwdjd3X1Xpvgy8EHmqTNVm1EZ
         JvYbwtmWpB4dyFxXxktpxQMAVoQS54GI1Fr9nKrUP1G8fHxKgJJpPjXfZarvI4ognXI7
         Rd/t/U/Lg5U1l06kK9KpTvP5v8eo5Bk52V+vvAq7VKnwK72Zua/Teewrn4nb0c1z84XN
         JgK2n/mYJ4bQoc3VowaUBPHZs+EdehZUnM67dlJmEZd7X4oQkDPvUT6uGtqE01P1A92e
         LUsA==
X-Gm-Message-State: AOJu0Yw3nZz3U3r9wLo1GFELnjI/NfS59XP8CB9uAFn/2l3KprwWZy1M
	hxO7SYm9FqtE/clYjH97BwpUMVJmJRhmyD+JD9JhZ/pkdHRSOiQrHmo462rySo5n42w=
X-Gm-Gg: AY/fxX44LxAeixnm/um2B1JQ65FWISiLxcjSMkjH6PEFqQkyEm2Hnnm/9Ebwpd6hArB
	As+9ju1nJpymutqX49tudZtdhdashkin7g/enAoiQ4MFz9rZTo5GUpqzovyHMQl/mbxk3ek3sBy
	LuJDSceuwDWINFzo2so3gi7QT44ENcHWEHXL2Yp8l8iMzIVBspLTviJPbGQxtCp3QgVxv1AsxWb
	vFVY7djKq0rbnkKxGs0w50l+OzRvvfxSIbOUJmaf0IAZesGM2SsytqsA/gn4UcR9abVPvrqp2WQ
	/VZ5JLlEHzPP/U22U72uLTtB6WBn4nT3r/sgGXKJFLxdVIuKJ2oS3+Oxa4NnMqs+6u6n4vX0OwZ
	SQL3YeCcZADKVTHO27Be05hGgxZK+KD6Glbzwm73q+un3pcda6Uc6GRJBMOyfT5FGfrNyegzbRS
	+UVS+ljv7Uca1Qgv8KRoR6puNqvqRxr9v+/Pse+F5TuInfiso655mDJOes5o8WkMDpUn+j6rQ8c
	FY0/AK3LDboU6fDXzcVtJVYy2ka0/3Y1+4eDtATJh5n0jJAEL2pirfdYX+xqkKoUUN3PcIZpyM9
	Arfz
X-Google-Smtp-Source: AGHT+IFKlvixvuJDocgXBFIKkO+Bn1KMLjpbeUhp6Kvka6peIADB5s5lein1pfrQ5ASWZTqcoGpi/A==
X-Received: by 2002:a05:7022:248b:b0:119:e569:f865 with SMTP id a92af1059eb24-12171a68795mr6428940c88.2.1766207783273;
        Fri, 19 Dec 2025 21:16:23 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724dd7f5sm16482269c88.5.2025.12.19.21.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 21:16:23 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH 3/5] scsi: aic94xx: remove unused ENTER/EXIT macros
Date: Fri, 19 Dec 2025 21:16:00 -0800
Message-ID: <20251220051602.28029-3-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251220051602.28029-1-enelsonmoore@gmail.com>
References: <20251220051602.28029-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also remove the ASD_ENTER_EXIT definition which enables them.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/aic94xx/Makefile  |  2 +-
 drivers/scsi/aic94xx/aic94xx.h | 10 ----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/scsi/aic94xx/Makefile b/drivers/scsi/aic94xx/Makefile
index db9fbe3a8e4c..a6894138dfcf 100644
--- a/drivers/scsi/aic94xx/Makefile
+++ b/drivers/scsi/aic94xx/Makefile
@@ -6,7 +6,7 @@
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
 
-ccflags-$(CONFIG_AIC94XX_DEBUG) := -DASD_DEBUG -DASD_ENTER_EXIT
+ccflags-$(CONFIG_AIC94XX_DEBUG) := -DASD_DEBUG
 
 obj-$(CONFIG_SCSI_AIC94XX) += aic94xx.o
 aic94xx-y += aic94xx_init.o \
diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index f595bc2ee45e..722fdd7cee11 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -20,16 +20,6 @@
 
 #define asd_printk(fmt, ...)	printk(KERN_NOTICE ASD_DRIVER_NAME ": " fmt, ## __VA_ARGS__)
 
-#ifdef ASD_ENTER_EXIT
-#define ENTER  printk(KERN_NOTICE "%s: ENTER %s\n", ASD_DRIVER_NAME, \
-		__func__)
-#define EXIT   printk(KERN_NOTICE "%s: --EXIT %s\n", ASD_DRIVER_NAME, \
-		__func__)
-#else
-#define ENTER
-#define EXIT
-#endif
-
 #ifdef ASD_DEBUG
 #define ASD_DPRINTK asd_printk
 #else
-- 
2.43.0


Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F82838A736
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788714576; cv=none; b=u24Bpt1cqMuX1RqBvUUSwMLr9EC787HOSi0eThjWrxQxMoqIt2kaik9UyZeR5HXhWctX2wd9KWI/V3uaWUBMgOVkeHzlu68ZzJxpVUHiGRYv6p92LESuicDEgZa+xL9itcFV1CEnMEn2sfry/Mi0bCF4HSR3wTvVmbgAWOPhOU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788714576; c=relaxed/simple;
	bh=z4vVnTQ6k8qjhYyEEMYeB00eQH+JL5e1r54r1OC/qcg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JufylXTkxabYBtTNysXl7oluGF2brdluMSjCDBm1AiDWgg6VoQ4WhZLX0k37bZ1eyQFwTdu42L2NjeRDcpToPLswAkFgRUpMNvp40uxM81IWotAKRUkCBYQ7vYVf7FjBciWhruo0LShbrSRS8jJwHNbhcoXuNe7viaauvEvlXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6RZZfc1; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6RZZfc1"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47fe89fb333so1625463f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2026 10:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788714573; x=1789319373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7FZiVOSi6ZhYBuVkc2WUuJSSDnHcYOHxfXDX6qc9lvE=;
        b=E6RZZfc1lqKcNXb5Ob6IANV5oBITrP6Hp+3TQogRHgcGmuUMwg3lAE7EBCd8n/JDTJ
         gYvEPnXsAMMiMj6X7L7uwQ4hpoy6S/anz4WFgWX15Lt57qqGvHNDge+kAT9fnOKs2kmH
         vC42CNjXfhX/iNj3C6OJL4aX1+ojMzYuySBrgOh6Vby3AgTE3S4FgIJoJ9cjX5jwjRQl
         hotL50eoz9f6OsR4RZjzsNQvb0UCf7YVebPhBHB8e/gpgsL798jg8wZPsKemZAOeDdTY
         hlrwHH8MBU6GwwpzG5RcfkTrH+6nqG/9WyoBXp6W8xIX6d9Zz7LK2l0FmH5pC56H2xZ4
         AHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788714573; x=1789319373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7FZiVOSi6ZhYBuVkc2WUuJSSDnHcYOHxfXDX6qc9lvE=;
        b=oEH47MY827eOZI0kzWSDHcTd1zmIN42ALoNh9qXLdMFQ2ng1dDtvMtOVs+GQUZvmS2
         GlUliE5sQvdZ2elURPVVkiOBuIUY0twv4H9X9Pl8UqruJpJvN71LhISwkSELjGxMzFQW
         CBhGDQJH2qQY9mKYYYLNo1xDASVd2gpqu8acvSLJRYun79LxmJqBC+CbFa/Kak391+uQ
         fGsNY1RgnmUndFP9m/X7o8Bpy+WXQla78aCVYq7xvkoJ/TshAGC04HNZ0LrFJkeWeoU3
         AeCDL72p5bTbStj8svWpYdKN5uHfSwPsuCw/10YuiyKxHcznJ7bS4FewQAxbOfkTMWbx
         sEpg==
X-Forwarded-Encrypted: i=1; AKwUvBz2aknNhC6osqwuKgPYbiLQ43vygVDj6KWRmNlns5r7QrJyScXyXEt8o2etGKj/Om88rZZLopfw0raq@vger.kernel.org
X-Gm-Message-State: AFuF++mLWCfCO86hc7mNQuIJX1A9xE1y+Pf1cvgA6AlYWnyesQYUO7g6
	zAcK1XiOgm2i9qaglZ8pyveV4E6e6JjlehEa9Fjrj/tE5Vav1G1m0NRB
X-Gm-Gg: AYBFou3fSdAhD1OWV8hvLMT/avAZAcG6LvKuE6BpzemmuDudSnJlQTUtCOv42Z0fwXE
	BGGyK0IpLPTFxl0jWu/0xRdjaNn7/I+QJCKkBSe5MQ7dTQUKWVoitz7MVHkgV+tnBpFIP8qCsGI
	QfBpFUQEnhjqhdMuhNoaL8iMwSFBZzeMvKxpiosOwBtIW6hEX5KPEuUeVb4Jgr8Nbh4xbFoqNdR
	vSsK6bS9ezV05Zq5MamwfrmjRY8uOY38lQ8oFgXJov79vHIhvpjyt5YMiRg5EYTh+AsU8Y4DCe0
	YM1jgtY5TPv31Gvie3qKxTaYq32ruqZno+mSBQ3RHouoiUwb9qsghDXwDrVKzaf9fA0hKfvf0fi
	kvQZc5NN7pxzzztyvbEJzlNiAEUjqI7H1ORmw1rDA/0NdTMnUU7OYSg9gGOEhyyLV27KWxG0PED
	dieBCdKqf6a8dxSoOU58WfKjwwsAbKf26rBc0oboQD5gHD8gTGDmSmxKMh+iC8KQUmfAijEyCbs
	wqM6wi5ZfAVxJ/Gppj0NcrshcLz2rUOYLFp4JkWDf9JmUXmyJZu6MFX2oGmIiOvr2/FszKIJD5z
	t1C1nkbmBzDptnIt/jQcCdhUJc2X6/eYxDudq23rIC2TGji25jP9SIWcCSxk1GgbU8Iabu4V
X-Received: by 2002:a5d:5e87:0:b0:485:8a47:5b85 with SMTP id ffacd0b85a97d-4858a475c6bmr15932432f8f.34.1788714572514;
        Sun, 06 Sep 2026 10:09:32 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9d84-5101-9c80-d25b-14b6-410c.310.pool.telefonica.de. [2a02:3100:9d84:5101:9c80:d25b:14b6:410c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885b1320sm22186202f8f.27.2026.09.06.10.09.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Sep 2026 10:09:32 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH] scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn parameter descriptions
Date: Sun,  6 Sep 2026 19:09:25 +0200
Message-Id: <20260906170925.2524-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MODULE_PARM_DESC() lines of use_msix, use_tasklet and read_wwn all
name a parameter zoned, which does not exist, and the use_tasklet one
repeats the use_msix text. modinfo shows three "zoned" entries and no
description for the real parameters.

Name the right parameters and describe use_tasklet.

Fixes: efa1fca45082 ("scsi: pm8001: Remove PM8001_USE_MSIX")
Fixes: 205430290ad0 ("scsi: pm8001: Remove PM8001_USE_TASKLET")
Fixes: 80975adc79dd ("scsi: pm8001: Remove PM8001_READ_VPD")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Three Fixes: tags because the three lines came from three commits of
the same series, all in v6.7.

 drivers/scsi/pm8001/pm8001_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e93ea76b565e..b1ea7cf9d605 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -58,15 +58,15 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
 
 bool pm8001_use_msix = true;
 module_param_named(use_msix, pm8001_use_msix, bool, 0444);
-MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+MODULE_PARM_DESC(use_msix, "Use MSIX interrupts. Default: true");
 
 static bool pm8001_use_tasklet = true;
 module_param_named(use_tasklet, pm8001_use_tasklet, bool, 0444);
-MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+MODULE_PARM_DESC(use_tasklet, "Use tasklets for interrupt handling. Default: true");
 
 static bool pm8001_read_wwn = true;
 module_param_named(read_wwn, pm8001_read_wwn, bool, 0444);
-MODULE_PARM_DESC(zoned, "Get WWN from the controller. Default: true");
+MODULE_PARM_DESC(read_wwn, "Get WWN from the controller. Default: true");
 
 uint pcs_event_log_severity = 0x03;
 module_param(pcs_event_log_severity, int, 0644);

base-commit: 986c24e0fe44f844b44d365b71ce831947f50298
-- 
2.53.0


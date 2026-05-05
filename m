Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7D9329C66
	for <linux-scsi@vger.kernel.org>; Tue,  5 May 2026 22:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778021606; cv=none; b=CYIe7BcaPouFi8AAOxDdAj1TOUdKM7aqwY0NRHDP8PMy7rqh2J+ovaVgPCi68/9nRf2aAU9CISF6IK19Lpejiqy9p56wufPa1Xg+kPtU9WNbh73esKaW0/TNrTcGSzdQGb68+rOgv3PmJTioi+XMmc9nQYA7vXMeMJ6ZvbvVQrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778021606; c=relaxed/simple;
	bh=sd5l3/ubwltH5eDE3ilBqdVcJLJzG7JDFpu5JDjyEr8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qK96fpTzoDFO0sWWSA9pgTaK8XH0qA3ie5vIzNGs0sIJPYWokWvom/nsd33d2JzlCUfSUH13qSBRTuJ0O2FeZPwqXT5iMXtVgHsz/dO1ZhUyH5IYwI0Vk/iT+vzhKZrYTtmhwun2SAOqPKuXeZ3q5GSuErQ/75+MsbNdC2gD818=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r3jL3lZt; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3jL3lZt"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a87782588cso3408507e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2026 15:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778021603; x=1778626403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tTY73pH4T+UuaeO60OUrJ5ucV5e49TbVhQbJqTpUiWU=;
        b=r3jL3lZt1PdCjYU4Th+pjWJeM65Dss6PiDw8xjeQ1dzlE29RPrGyasAex3Ha0XnVFP
         cGvBaFLkFO9yKk5/66s76nlBoGdreRjdBz9z57woeguLjwQUlXZRQhSl9t9+kNvu2wHc
         c+XH7MR5N1VL5cAcQ+OJTnn3whQBwWAA8bQApie8vhN5Kb7YNxfMD16Qk1d4tadkRdz+
         XOE8+PRtnbflXXFga+rSyxnIalWk4Ug4nD6E2jfxDRCcF2roS9t1gSPM2K8t4OsMnebk
         pSBwYjl50kXVlD5xgMjtjHT08Q8cgVUwz7G4Dnck9geCjbSHRKYStI2jOxfYJEcMDPhz
         i2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778021603; x=1778626403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTY73pH4T+UuaeO60OUrJ5ucV5e49TbVhQbJqTpUiWU=;
        b=c6lssNW7LwP9EJ5awh8qYER8hc8+ZNcjpd6VqcfEFW9AS8oppL2ymd+Hlx1XWBAxpf
         lN8Bg/AvCo18I2eRoAtBYhSmGW2j39ERxwr8Z++WPh4lvoJrV2H0FFSAJV3euj7ndpj3
         o7NT/XBc6YbaKgm6P2xcbupi7qG9vTlH8al5fxRCS/SiQuKwmhh+wt4rJaa94fC3Fyuw
         z9qify1KVVgeSfxiTPfDSB+1E88Jc177vl/re/CPepOYfiNzuWB6LOA1gqaH+1ynQMs4
         RjHx6Grwc0nsfu1OaXE1jmlbw+OcFEfT4rvLPr7P4aLrou6fR5Fz6kdYZ2ZP0G1eu7OZ
         yuVw==
X-Gm-Message-State: AOJu0YxxgYfr9ZwWIbc6L9MMRbkler2VbF2hlG7qdHJ8CkkkKAginmW/
	UiQv/UM7lPNNyKcH7f2pAgPRvAUllQyslYHSZeyZIsQlDv8VNcn4SidnW/owgSkQ
X-Gm-Gg: AeBDiettNiXe2rU1rqBtS5YwhDupTg0B9PYru+UwzVxkbyUPnndLbNkMW+0WmaeTOzk
	Zn8QAIu+PbudDe5S+lilAcjRLw0m6JSRMWVVMmPNas41NQyQpFQohUioAOMZaq20kp0bBosHrid
	b0Adk0bnzE5z8K1Ez4T0/pPTwhF6YTPf6+JSXKGW4QLskODU6inAFDToTSgY0j8ZswkG1K/TVxA
	6gM7Kwt0JvwS1u4GrpaBV1TKouLuvtP/CHefulnjjVpymJDguuC06yJhkN7Tz1yOb0VFv9aEAJS
	IUQThhvxFceYQAOpxKBKPXXUdTiqY/M2riNGIbU8TVNfXDPBMu10a+bGUsXgplsK1c9aZfLLFBP
	30y2kJNv1bi0Zn5Ye8Yv6C0UirscTwRSphc+fWjcmyE4F38ixLUBKfe5CSg73B4eaLUhY7Xz3W6
	OT1hdYphYwf6lq8qENO45lBN8L7nyv//WzX0oCwL3t50eXR2SlB5SkWpb/+rexGMBmDDJEhrZCz
	i7XEQ==
X-Received: by 2002:a05:6512:3b86:b0:5a8:7395:182a with SMTP id 2adb3069b0e04-5a887adfd3cmr244737e87.8.1778021602828;
        Tue, 05 May 2026 15:53:22 -0700 (PDT)
Received: from Shofiq.home (87-92-218-151.rev.dnainternet.fi. [87.92.218.151])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3937a9aef4asm34200671fa.4.2026.05.05.15.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 15:53:22 -0700 (PDT)
From: Md Shofiqul Islam <shofiqtest@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	linux-kernel@vger.kernel.org,
	Md Shofiqul Islam <shofiqtest@gmail.com>
Subject: [PATCH] scsi: storvsc: Replace symbolic permissions with octal
Date: Wed,  6 May 2026 01:53:21 +0300
Message-ID: <20260505225321.6785-1-shofiqtest@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Symbolic permissions like S_IRUGO and S_IWUSR are deprecated.
Replace with their octal equivalents as preferred by checkpatch:
 - S_IRUGO|S_IWUSR -> 0644
 - S_IRUGO         -> 0444 (3 instances)
---
 drivers/scsi/storvsc_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6977ca8a0..571ea5491 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -156,7 +156,7 @@ static bool hv_dev_is_fc(struct hv_device *hv_dev);
 #define STORVSC_LOGGING_WARN	2
 
 static int logging_level = STORVSC_LOGGING_ERROR;
-module_param(logging_level, int, S_IRUGO|S_IWUSR);
+module_param(logging_level, int, 0644);
 MODULE_PARM_DESC(logging_level,
 	"Logging level, 0 - None, 1 - Error (default), 2 - Warning.");
 
@@ -345,17 +345,17 @@ static int storvsc_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 static int storvsc_vcpus_per_sub_channel = 4;
 static unsigned int storvsc_max_hw_queues;
 
-module_param(storvsc_ringbuffer_size, int, S_IRUGO);
+module_param(storvsc_ringbuffer_size, int, 0444);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 module_param(storvsc_max_hw_queues, uint, 0644);
 MODULE_PARM_DESC(storvsc_max_hw_queues, "Maximum number of hardware queues");
 
-module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
+module_param(storvsc_vcpus_per_sub_channel, int, 0444);
 MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to subchannels");
 
 static int ring_avail_percent_lowater = 10;
-module_param(ring_avail_percent_lowater, int, S_IRUGO);
+module_param(ring_avail_percent_lowater, int, 0444);
 MODULE_PARM_DESC(ring_avail_percent_lowater,
 		"Select a channel if available ring size > this in percent");
 
-- 
2.51.1


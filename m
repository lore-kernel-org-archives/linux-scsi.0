Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7472BE7D1
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451724; cv=none; b=WUneBA+TC2X1PTFf6IBtCZZLxMoj0bfYllYsNn65jnbcqerxYK0KwlscC/TS3LdcptFNYuAEHVyFEkLQHiBhYBmBwjFOrjo0ZwC7uMLfT3QH899Pe8Wx197pn3Mc1lqENtyP4mNXO1QE4xeis6KxL246slEN6NWsQEGsPSimtUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451724; c=relaxed/simple;
	bh=rzE1gLTO6zGUYTp6p5u2QWMK2Vx18lZCE9BT58MW540=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=emTdnqd3CvYMxR1Mi0N2xTiny0JGBOweGdRiNGLB7MZM/Rqhq/rltdYpDxcQDo2/L2/H392if6ij7AFI2rH4yhaZj3L4fyWHNqGBaAZF8kVqbzuS0af2fKDWjgyCY70b9nIlPTXTPK5SmenS8f+YLpSTpOV3njmrHlASrRJlIUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PlDM0jCc; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PlDM0jCc"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12a71ade78cso3242514c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 08:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774451722; x=1775056522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l7XC/XueJjEED5mEKGtofARfVp5jK0YMd5G18Mcoqus=;
        b=PlDM0jCc0mpFUGpFy9jHqmb3aDdkhnuZtBz7M2C7m9xfk52F92LHz/zEInl5Ho4HQS
         G238rurJIVC82cmL8XpDAyuBgnjpg5S8Un6GUkNBl8cyf91D+eThHjPObdYFDgURAZyx
         tHbWmlgUSOQlHZn6cebWR+EhBaemuw3T2tRkHHyU+LWkDTToVDjblznDYErIqFCfTaqr
         ZboZYMxEF05wJu5xNe1S5QH474NW1tIK1JnIHjMCS722m4SyIZDNUCxI69fmRglKzjcc
         w7DxVQfEswEGWo2L/n6Ri3TlIbjQj3XPybYjlD6fosWmKkPSI7afiCYNpxj5mbaZ7NAA
         mHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451722; x=1775056522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7XC/XueJjEED5mEKGtofARfVp5jK0YMd5G18Mcoqus=;
        b=mr1oAecc9MMvqmIJ/VTk4KwOuwcBWWm4u6DK6tIXQ22VQazcz5HueUo69FnU/LupSJ
         8cCWgCnWMjbbuaOSx4pXW2P1taWBMcLR0w8WinubZrzXH9kXZAU6OMnqJIpDL2NMzY7J
         15LsesK836vAWrqXlnJDdnUt+PZPUvfNPLLxPkZjr19U5tR8ILFzeMMLit08miF1xFmL
         p728lut/HLTUjDLINtcA4gpnbjiDuBwreIVPc8vtgUJNAqs7OGP2ZYT1gGzaImmAkv46
         csNMSaZhImijKoioRz94qRdMyM4vOAyw1y/HfHN4kkTXfAqi/0PfFJH1sMobRntBnzoR
         sy/Q==
X-Gm-Message-State: AOJu0YxwU8mng6NERJllcvxA3vRMKF6vX4q1xeFgAHQx1mJvVwuNnO8r
	WMTfsgbuR/ooYBsiTP0wfZNywcpuAlKoaAKBu5zE/c+qGWkBqqoldxuwGPQtTEF+3qiSHyl+yfo
	TjY4j0Uj9OL4NX8cjyOXISy9nPr39xm/zAvtWlpjxSYN2x9NvkoB9b/axmG1toXu9fDc5tI61x6
	nBgjuyqXSxUvodfqpuKA+UuOgVVKat61XrpwtTSRcwty5NOYk=
X-Gm-Gg: ATEYQzxSO+dMLWlzl2lOJhl2NC+bJoxJDxVBh7najvJ2gGioMRuoenXupuPMiFn5zLf
	IaxHEPUyg12BY9dsyIo7+NEyj5RXNLZp/OQYCG5ax/429anJOrGw4obHqbtYbGaNL3+OMH3dtpX
	XU1Cw0gJFc3Rwo4nPeC+p3ZMFpNWeO+RtaGy3w559f/ryVRvBmCKyAy4iyerBVh7QE1+2+Mtxh+
	Ytutnq7g5epOdBkgtgOrm8fhLDBsNcGzR5RvlQRtTK9tK8RnzF6fRqMdzrckwmVB2Kejm0lMyYB
	PUL+OtCsw7fjyK6LCOgAbhS6yIeZE5DJ6oJb+fBM/U9Okd3KWIOuKZC4jGKLwJz+maqHrnKp8Ag
	wbTb+g9ScDEh5z+pJM6DBsi/brUkGun6mNrWneMqGnlCcbSXcglJUvW7TQkmNZftPs9yweekv4g
	Qs3if+4OcMKo/W+BNDg0rBBSEEq9lwzNWeA+iEek54esxuDf4e6MClmoMa/aJcyvRjgVidnGd46
	3/fkSTK2Cewh7LtuqcPQvbg4t9mpNHfI8axsbBxJZQk8ufuIKutWi4=
X-Received: by 2002:a05:7022:6ba0:b0:128:dab3:f528 with SMTP id a92af1059eb24-12a96e49010mr1864700c88.8.1774451721706;
        Wed, 25 Mar 2026 08:15:21 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.81])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12aa7274231sm46740c88.8.2026.03.25.08.15.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Mar 2026 08:15:21 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org,
	hare@suse.com
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH v2 0/1] scsi: scsi_dh_alua: use device timeout instead of constant
Date: Wed, 25 Mar 2026 08:15:14 -0700
Message-ID: <20260325151515.18688-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch changes the ALUA device handler to use the SCSI device's
configured timeout (rq_timeout) instead of the hardcoded 60-second
ALUA_FAILOVER_TIMEOUT constant. This allows administrators to control
ALUA-related timeouts via the standard SCSI device timeout sysfs
interface (/sys/block/sdX/device/timeout).

Changes in v2:
- Added READ_ONCE() when accessing sdev->request_queue->rq_timeout
  since this value can be modified dynamically by userspace via sysfs
- Added fallback to ALUA_FAILOVER_TIMEOUT if rq_timeout is 0, using
  the ?: operator, to handle any edge cases where the timeout might
  be uninitialized (though sysfs store functions reject 0)
- Retained ALUA_FAILOVER_TIMEOUT constant as the fallback value

Regarding dynamic changes to rq_timeout: this is acceptable because
each SCSI command reads the current timeout when issued. If an admin
changes the timeout mid-operation, subsequent commands will use the
new value. This is actually desirable as it allows administrators to
adjust timeouts on the fly during problematic failovers without
reloading modules.

Brian Bunker (1):
  scsi: scsi_dh_alua: use the device timeout rather than a constant

 drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
2.50.1 (Apple Git-155)


Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF3261B70
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358519; cv=none; b=BiUxYKEsfUQkmg90j9NmNJ5uPAnDX9BYDl43xRS9g3DOxDrdlot2moHEK8khsJ4RRgB30dWM0nU8PrMIYwH2A3vWiNGaEHd+VkzPxXFIR9aaQmXaUPtrvizksDOWYeiKbr9dxApbEhlalmGyV4p+KBS6bW17l2kqde2sFGMypd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358519; c=relaxed/simple;
	bh=5HRfepAGnEBBf638M2mtpXAsj0f4cbxWuJ9K/PP5lGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DlCYYZosPzCh6y7OioQdDzclztpkzv/mrj9NwPsKXZUVXbZtU3gjot3llUFA936osZ5plQv8RPXFxOOZu/Lkmxs8e889HiMZxxICWeh8Xb8wcPbPHQ+rqLTwN8Uz+R6Vvb1B79HOZDvUUxLUr+2wraIJmEhMydt6DvVdgxthsZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=M1Wbw8co; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="M1Wbw8co"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c080efc1eso722665c88.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 09:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776358517; x=1776963317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q0bcrfhoYF72nRKBAt42E6t88M4jYG6aBv9EEJikb/M=;
        b=M1Wbw8coou4OXvZ6x1JWqrr61FCVzpZd995Nzf+loLyvht9borAzpUmTGICe1dzQ0V
         oRi7J3R6bAZzUMNxpNIGiIe9pJyP5h2bLCNdH/iA3yLd5PdqBjMZWi/XWYyItpbN8a+O
         e0nkRyOFnwzQpLgKMPirERUseTXWRvcG0sPZB305PtuD3nMdiOnigX6aI31lVPP021pj
         ayqPa/nfasRXMWj4m2lZtKCG4ztBi0WPxmC2xXNZdwsbdDpmIwa26oBAB6Ohg1XTif3y
         +RGbmeCoU77D9AZG/B/QOcYTZt+Yw9qnJEY/1MkNBdUcNqK2MpIDZ2u0MsnGTTHAheLk
         lXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776358517; x=1776963317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0bcrfhoYF72nRKBAt42E6t88M4jYG6aBv9EEJikb/M=;
        b=Y3mQZKCU0DGD/27qToubQ/8U9GcqQWw3RRQWB9+WRyKfHLz0yiXJ/HuLkZsaiQb4Hc
         HArjeUxnA1I06cGFdSBvbTRYDu90AS3p9FpI8z7BF6xq6l0Ul8O4m8X9dX65EmSEsKDR
         47e9uWZcpdzlfL0nBWclS8wGM9+PpsnIWwuc0E7ncDldGRMgwZdOP5auwBsVIP4NnzAW
         A04RewNfcHcUGUbbFfMLYexkJGkkki7c3ImTccYnudXOxttHsB58u9XVOKRl7Rb1iozT
         NW8B1UaIOT6jhMBJngGzLCew2s1WJoXD8OekR1vDkdjKCaiDkUnVzyH2X9Lza97MG0iN
         XnSQ==
X-Gm-Message-State: AOJu0YzhbH8CIKtBVS9sfWH1NIa4OVz9HMYU/7aGHN57EavdCqMywlcU
	IygAoFktOt/ZtRV8iaibJjmnydbFE3oCzBQhVFck9b7dZPV5IhT+qdFwGGNNalhhIr6Lyum2xjq
	kI+ZnM29bcNol7KQ5rJmMnpMWuM2Uvtm2vmZhfQ2yVfaUNnIU1bfKBSLVgTp/vI7kr+Hq/sTYMi
	mMK1q0vWeHfvj4LXKHa3qV+MetKdbX0Ql/FBVl5EJvIDEIIB4=
X-Gm-Gg: AeBDietm+oUXkxRogUIezYtAg3yAJetB4BHIk7BeyeKtHzXGpA5oA9NIq7qdlKVxMNI
	/s5iXZqw30xDFmzjfJLGiQI30AOfy3jj4RjrY375MpbsXbJce00mE9K4g8mGC5O7ortMPLaYitY
	sRihYETz0nD+MQm+H1lwVrDn08iGZxI+4g4wJOKcvpH3uiJUalmzvjW90NAUo0upGsJsSTjTbEN
	ThaVqHC5mSl07pgqZbSzW8Esggm49AOl+1UfFCz2oznkF/AgBWdJPew/bwJI4wmNC99dUFTvYpu
	DezhnCz8tywTKoiqNHr5A/jVpEDnkccv6w3SHXqvzXjEiBeOgegJMJw2CozhQUhDNLR8HMvmH7G
	zpgUqHsJhInSvuNXc/QaToKDcj3tPBygeHmjfvOSJteg61jgS8loQzoEXVZ2Fgl6BUJYmQqSUmb
	iM2b+VCSihisWLfbznHCBvTBbdQrF5BKhOEhKSN2mJKk1oJ29ZsXgnycLujTU6NVvxd8/O78FMA
	+QAj7nnB7aFldFS28KMthBga8KyEenEo0ATbBNZAK9XkxkFOqFPV8pkOLJyCWd+qkHBV9YftL73
	GTRy/VhBY2Srm44/lZkkc7/mWjBryQUehqw=
X-Received: by 2002:a05:7022:e19:b0:11c:883d:1ef0 with SMTP id a92af1059eb24-12c63123e0bmr1903008c88.15.1776358516876;
        Thu, 16 Apr 2026 09:55:16 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c5e6b6a05sm7461733c88.14.2026.04.16.09.55.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Apr 2026 09:55:15 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org,
	hare@suse.de
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH v4 0/1] scsi: scsi_dh_alua: increase default ALUA timeout to maximum spec value
Date: Thu, 16 Apr 2026 09:55:11 -0700
Message-ID: <20260416165512.26497-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ALUA handler already maps a 0 value (no implicit transition timeout
provided by the target) to the ALUA_FAILOVER_TIMEOUT constant. This
means the kernel is already saying it won't accept an infinite
transition time - it substitutes a finite default instead.

It has been suggested that some arrays may take tens of minutes to
complete transitions, but even today those would be broken by the
current 0-to-60-second translation. The kernel currently caps this.

The SCSI specification allows the implicit transition timeout to be
specified as a single byte, meaning the maximum explicit value is 255
seconds. This patch simply changes the default from an arbitrary 60
seconds to 255, the highest value that could be explicitly
provided by the target per the spec.

This is a minimal, safe change: we're not removing the cap, just
raising the default to match what the spec allows.

Brian Bunker (1):
  scsi: scsi_dh_alua: increase default ALUA timeout to maximum spec
    value

 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.50.1 (Apple Git-155)


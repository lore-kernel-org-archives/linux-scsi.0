Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE606521229
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789568592; cv=none; b=NGChd8ccqcGnpzXtrRmhb3MYy1jfXEbGOI+oNF1ZPmsyHhhET0Qmr9lVmbWBOkMVHV2kTIIsQYzQg4TYpwWCFeIs0KK8cm0U7wWzTakywt0Xg3bv3Fi87SuFDTgj4Psv002ec/U4uKe6XAXtRFCncnBTWIUiIxCZjkzqGKiIlnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789568592; c=relaxed/simple;
	bh=EINPtHVOyicGbgZE3wPjEkEjWD0JYoqcp2SdCRHcjKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=p/h3mdV9h+LNAeoWTFW2GCKPLXfLE+5KjRLwarVHWLLVeLskWTml5YxfkD4/M08V/yZMfOZTbQU52uGMCoa7kTz9cUl4M7hF12L7kTBJ49GEiXayg5tsB7vEW0TZ/+DznEPMRwqL8smdOSbYMUJtcne5LK3/4imToJJV1h2kcwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qj9pMIEL; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qj9pMIEL"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-868b2e5be4eso499723b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 07:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789568589; x=1790173389; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EINPtHVOyicGbgZE3wPjEkEjWD0JYoqcp2SdCRHcjKc=;
        b=Qj9pMIELu9/Z7qdZgggoZb49QLwcDo6Mi/KtnwMKoJubDdtRfKr82a78NUEEidapOU
         gRdoKNBFCBB5Rk3NKyy+PIDtZ6FQber7z2p7Kxl6TFSU5PwAX+6UsZuBWZVSRumVO0l/
         0dUxkfDWa3LdJnGqRjpuhlXETL7WG766aRzpKFu5vybcBQNiJWso5MJQDa4/+3kPKI0A
         kcAFVzIuJ7KSj2CNn1f2zRAU3Avyr4L7oenmLccvb+CLxuiKxRjnaQYN/mQIsypS6l8h
         zcPgnM8Ibh0qOHiEc4z2sJUDzvJ6r1lmdxDBXMGU2X3s7zA0i4uHe/PQ15Otit+0PZcT
         3/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789568589; x=1790173389;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EINPtHVOyicGbgZE3wPjEkEjWD0JYoqcp2SdCRHcjKc=;
        b=Kd1gVjmyggzMbyWWqqnxqBza4xQVVkRyDp3TPY4FDeQI1Z9bO/KCDxjVeouqc7ATpR
         PSNbZIxV7xvjkL9CPnsdjzhHtW+rL79s/TsXZE9u4e1mez1a/pIYJkW6mJLi2alqcJ6X
         RcaPBp874JwXI8lH+O9mo1y85+TGHOww1nmZX9dSI841SXiORNuRhY/dd3Ki/nwTIxSJ
         dib856l3YdgCh5FCR5LGa5fRh0P2rGqDrEeDUcj1QS/yiBq7mfWPmjjnqN1E20jDZMti
         Aew4muEEv/nM4XGWSWnB37T4wPysT/8Ohz+uIAPvv1QE2VcdMrPHQyR5eiP4rngJLmo9
         7xOw==
X-Forwarded-Encrypted: i=1; AKwUvByq/EqBZYgkHBDMoJyol6C+l2IJiEv1tnfnvlHeGeIa6qVdXDV1wWjxALDN2mRCGnTBWSmab77n3Fxm@vger.kernel.org
X-Gm-Message-State: AFuF++lNP2qQLa13jwtUO6TdZkBk4rlotAeHpFP3j+gsVG9b/pyj9QUM
	CwWGa7XpW0kE+45Gync8P0y9XnSaunC5Q8eGqGXZqCo6nNzbRe1I4ljl
X-Gm-Gg: AYBFou39VP3qpSN0zcSUfmVGuJLvoY9ja8+ypjhCYagdI2fmLnTpkIg/CY1Mq0T942W
	mTCmOKhkx3WYHFBB9Wvk7NKwSQx2z//YPaIq3XmxgDhva/VW/7Is7FFytW7BNj8BfXZ+WcSOxVJ
	le2XuOfgAUY3ISfcasIT0GZG/odOcgHL9gGPQWKRfN8swmN9Z/uRiMUwUg7zgCvwwTb4hWq/brd
	Qlgco69G05Eyd7ST4A6wKV0eKc7KqbXsNzVhn7Z1k0WXVoky7QgPCQUKRITAi0xBdgSKlMNwoy/
	BJJIjm3kxq93ckgD6ZwZDq3vtDiPqsl74RwliX202cJVFFivLVuB6enLiLjoFdd+of6vSvUHn4b
	a23ungoGBOHsICEaf0wdxTplvW59LD1kFP5cdr69Li4f1737D4cbghGFyHd0l0BRx9oZrJ7gqw8
	2zvLqLPwmxj3z728KlbhH/4RxuPu3U7ewhlpl3FEHSVNT7WtVPfVeovH+srt4Mj/yQ/GQseJI=
X-Received: by 2002:a05:6a00:4c81:b0:86b:b308:b926 with SMTP id d2e1a72fcca58-87238c81c3dmr5081392b3a.14.1789568588753;
        Wed, 16 Sep 2026 07:23:08 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87201d179aesm1390884b3a.50.2026.09.16.07.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 07:23:08 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH RFC v5 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Date: Wed, 16 Sep 2026 14:23:04 -0000
Message-Id: <202609162200.ReplyLee0916b.lhw@gmail.com>
In-Reply-To: <20260916130602.GS11487@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
 <20260901145204.2BF551F000E9@smtp.kernel.org>
 <202609032000.RFCv2-0.lhw@gmail.com> <202609032000.RFCv2-1.lhw@gmail.com>
 <20260903122408.3CA6B1F00A3A@smtp.kernel.org>
 <20260903161357.GX2133376@google.com> <202609042000.RFCv3-0.lhw@gmail.com>
 <202609042030.RFCv3-1.lhw@gmail.com>
 <20260904131503.355C41F00A3E@smtp.kernel.org>
 <20260910093232.GO2133376@google.com> <202609152112.RFCv4-0.lhw@gmail.com>
 <202609152112.RFCv4-1.lhw@gmail.com>
 <20260915130050.E8CDB1F000FF@smtp.kernel.org>
 <20260916104305.GM11487@google.com> <202609162015.RFCv5-0.lhw@gmail.com>
 <202609162015.RFCv5-1.lhw@gmail.com>
 <20260916122740.921E51F000FF@smtp.kernel.org>
 <20260916130602.GS11487@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

On the three sashiko items: the naming one I took as a fix. The doc
says sections that don't apply are left blank and shows "phy3::wlan"
for that, so v6 uses the empty color section explicitly,
asus-arion-0-0-0-0::led-0, with the "-N" ordinal the naming section
asks for when several LEDs share a function. v6 goes out as its own
thread.

The other two are the same false positives as in every previous
round: kzalloc_obj() has been in include/linux/slab.h since v7.0
(this driver builds against 7.2), and blk_rq_map_kern() takes four
arguments on current kernels, called exactly this way from
scsi_execute_cmd() in drivers/scsi/scsi_lib.c. The bot's reference
tree looks outdated; is there a way to retire these two from further
rounds?

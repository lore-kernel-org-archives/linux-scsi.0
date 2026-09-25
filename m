Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E08048094F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790340330; cv=none; b=rq+VXzcT2YnJa6aj7mPIpyiHULItGlhBQ/kpgj/gadaAbYNAqBNSxiJPPim0+K1yVcE2oCIMFE9KF9qzDYAALcT9EXQiHT2m+KgoiZsZIalR/6dR2xl/2NCxudVAPRzEOmwaeNK+i08U2g6YD0dcmno7Y7VCIjKe25xG5y70PY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790340330; c=relaxed/simple;
	bh=gFBgM+h9vwcAXQ6IgQ/0PgarYfhdhOwkRrgF8syo4DI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=GKWDGejQS8TQBBglbbbZOzdl6iZ6Za6nhC+7Aygt6Gz8s7B0xZ6fu6ZJfCMJQ13Hkn4nuXnYn5WSlD6cqZAHX7TRY6JHaesxiy3rXiOyzFo/75s1OUsgXXiTNSCdaxh3A43faM82QRQYE+n7C13bx1J9tTAGtcWBiFTv0FCBoU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHLo4fYc; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHLo4fYc"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ed9866so5415935ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 05:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790340328; x=1790945128; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gFBgM+h9vwcAXQ6IgQ/0PgarYfhdhOwkRrgF8syo4DI=;
        b=QHLo4fYcFsBEw9KbqWriFiq6l5h2ytJpyfWWWRCT0YBu3lf5BmBYRdGRSV7LHGt5e6
         fNrCXTOFvt/YINk6tPX3GsYO3Amp6agEgMuLImfug0TOS8heV+q+tIMkdP41KcKoRtOs
         f42K5ycJcQdEQWPXaguOV4nHTNP+fJ+Lnh334Q84IgEx9QPNMBRphpRdnwJQDEX6jD8k
         dR3FxrQB72zqfOU+eqxpPiBDzLdVSAgQOOjQm4T1BGSTLTmeb4IuwUnU5C39h+2YgK1I
         gYbn5p60uo8UmYjoe9GVSZuP+4ukDGq4yRzDys7Ne1tMxiDGODLh+/M6dTv0zEXqLbn2
         FriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790340328; x=1790945128;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gFBgM+h9vwcAXQ6IgQ/0PgarYfhdhOwkRrgF8syo4DI=;
        b=ld65eR26QFGTcqT7KzHHgA3Bf4r6u9AAOoWqef3sX34/v49nAT3fQS99tVbnfnAFid
         xBGExHUWAUIdEbAsju5+dQM26UV6FTuXYGfbDUj89Z0wa8Xb7lbufIW1KzU1WKISCyD7
         TFXa0ZkKQHIIb2Xnox3dZZ95iktSG9o+MJhfm2WmFKsA/iI47DsjO468F5NdPrsJMtkO
         8MM4lCQiRMc9zwQ2UQfx2OFTBV7p6Wvgf+VuImH1Dq77ZfGue3rvNIUSvyeOUDK6uLEK
         tD2kb3zVHKDs6bCEDLU4EP4BINWZhDZyLsD7DraExWscbz9cMuPvnqVx1mjUkx3tTDOS
         ufnQ==
X-Forwarded-Encrypted: i=1; AKwUvBzayWoII3wWEtAHas80P6y+iU/gdwdzrZnFjg79mcSFnpIpgVXzY/mV6w8tiMRR0MDBMndByP7izRTX@vger.kernel.org
X-Gm-Message-State: AFuF++lOxUi/54rueC/UvufXT2RkZnWqY4HPO7nrYovqesjt9S5J2ixh
	/QsDBtF9nF2pYZoyfQkKHQxqoemsIoZ7eqauIp9ToR1efIgmrL284g6T
X-Gm-Gg: AYBFou3PMnfD8I4HewBRisXchEu86Ym1hpT0UnWDdYZIxdypX2B7oYUukcdA3vfFid4
	wyoKY600joafOJRJBo3hCdPCkajfydxACxnvJbVKIJe7i4aNFaL6yo7xoor3p5EL4o7PcB1kbOM
	i7lWm1t0v+41AydjnHTnZeeMmu7lldD62MgWXgXvkNMIxyE/jSnZDfcp51Jgb+JUtyfMPQUhAkH
	EiKf17hfrfqK5iAZV1RR5CnibSm/+Y2LIOwOXw4k+4a+ZaHUEREME5ext+0a9TwH/gxKug3yr3N
	sBs/uwOpb9SgOlY2/G9xewGomorOcpfJts4rN3h0r1h7pkoHtofh9jQm2JWYvJsV3UD6WUQMe0S
	VzGx6GEN4XjYA5bjfN2w9b63+PrNwqqxD+ggkTxueWisSzoEeDVOOq9qrFultdIeDsJhit1eA/U
	sRSjlFfYvDtPNyWLxTUZC18oqyi0c1Uj2cjosXxSfAFuLamIDPGVfvlu1HTet7t7SVzqTsxg==
X-Received: by 2002:a17:902:d582:b0:2df:98b4:c294 with SMTP id d9443c01a7336-2df98b4cb7fmr9983615ad.61.1790340327930;
        Fri, 25 Sep 2026 05:45:27 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df913dfea3sm9261685ad.14.2026.09.25.05.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:45:27 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Marco Scardovi <scardracs@disroot.org>,
 Denis Benato <denis.benato@linux.dev>,
 Ilpo =?utf-8?q?J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-leds@vger.kernel.org, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Martin K. Petersen <mkp@kernel.org>,
 linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>, Derek J. Clark <derekjohn.clark@gmail.com>,
 Marco Scardovi <scardracs@disroot.org>, Ahmed Yaseen <yaseen@ghoul.dev>
Subject: Re: [RFC v7 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Fri, 25 Sep 2026 12:45:18 -0000
Message-Id: <202609252118.ReplyMarco2.lhw@gmail.com>
In-Reply-To: <mTEVQW_BRQmYsDDsTddE2A@disroot.org>
References: <UuqOxFagT_OBL0l5ZYtfKg@disroot.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Hi Marco,

Understood, and thanks for leaving the SCSI side with us. I'll pick
up the dynamic class integration shape from your dropped version
and rebase the LED side onto the class once it settles; no
co-authorship, noted. When the SCSI driver is stable I'll post it
against your class here on lore.

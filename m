Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793191935;
	b=4xVYYS6hvfZMFu48pfEABOwfom4OTPRXTOAA1E9tTSaqsLHfssJWmSlvC+PXXXlR/G1N
	 /0rQDwLki6u6DhNYfnG0/WfDOwzAHVHLzsvLij44Yb3TdBKaYRfYEaHqKsXszlAZ4jwsI
	 KzeD4th9xcGslYBaL1nPmi9B+lo9jl0CT+eGMPG4fU7Dnb3AsZ8A/IZ7cPKATIkkFJQiD
	 h7GARblON1dpIzIGN6goCGr6g3/6RJZP8EQrTe3mxas+mCwNB5jedXICiXZTb7t9+KHDD
	 jAdeSXJAgcww1+jnPfxRMxfGwNudAL3d/pg5qC06XKYZ7nxWr47f9O11VpW/jjDfd+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793191935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=jif9CDAVAYhJXkuCpp/HgAnuYrVFMmNUw2aPhFOa0WA=;
	b=fvnxpzH9Z3acOcli90gTUB69zzSuS443bE7yHIB2fhKqE5QJ6Uc0MBf/nlVeGxMmUV6E
	 72XHglNlaxKdkXpVaOtv0iYiYQLLKkH93FtTTFRs/nmX1XT9Xolb6eTL0wocBtjEK241w
	 l0yr5yk294OafavNmbMi1jlEH8HyxFIv3XkQsnkTaE4n+rvKa05h+NpiOuTNbtOOAe54u
	 uPy3xn3iECpv5lIQ2BXconX/92FEbo3oR/LA+4DarQhVlkDtaiZPljHkNplaLqKdZh3el
	 S6qA4VSMzAJN0NsqashulVyGFHWzgDEmU5JlxyJ33SnYnKEGw6pye69d/FCBkYR054g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZKnwUVbT;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7257E606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7257E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZKnwUVbT
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a05effaf8dso696257b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793191935; x=1793796735; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jif9CDAVAYhJXkuCpp/HgAnuYrVFMmNUw2aPhFOa0WA=;
        b=ZKnwUVbTIEGSp3YRgh3c5uKjT02PZpb8VjznUtGAmlyaZaegMduYT+jTcMWxiWUnpW
         ZA4rCNqIZLDv97TYXn/nyqIe67U8TFasmoaaub/5wikT/0QXhdo4aLEzUifNj26SgGbI
         +3Uxb9Whc4EmPZomkH3zEcCJg2MKSC0fTCHCk9M3E08VZbjjLcDUcD5sgejKUoU/xOaE
         QF8lP4uGpqnkxU/4i6A2h64zncOHnLPFid4GRNhKvGOeIJSs6vQA07i7fj6axZfAjsL0
         6HRACEo1ufoTcN5ln4SxVcuwkCZQKfSYlqmaYRLZtS5/rUE2O7sGCqyLiGTAhdTBxZT5
         5Dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793191935; x=1793796735;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jif9CDAVAYhJXkuCpp/HgAnuYrVFMmNUw2aPhFOa0WA=;
        b=gJI6EWpgFRjkiF05Ry9DKDE/MyBJEQ/AFvDFbZHabk7lLKPKXYtRlIuTZBnfEilyH/
         EZAO/mlwsfwdUBmiZjrNAWEfxcOcKyhJx3IYapZDzjDYicj37yJXwAHlOZli1ViJKuHx
         sW60BtNnoMJVdgImru6WwezFxcPNykxwFQvLenTvtwfJrLamIMX2lCTNv1TI2p0xiPS5
         f8GXZCnl1CsB8YI7aHtNPi8yIshpTlW7rTCR7qYWA8lZN0SZHBpGBD6kQvG+VhXsYB1D
         Dj56t8IySNh8i6oalX5ab8LX9gCLX11Mw4eGsGzYs5MdCzXwlv1W0Y7mf5ufTdQT/I4B
         Jiug==
X-Forwarded-Encrypted: i=1; AKwUvBw/n+afN3eR3qqFBf7DiJ7mYXleaiK7TLDFw54JbGMCBb9rHOX6N/+ROARGKZdPNgIo1v/wuChuHrOm@vger.kernel.org
X-Gm-Message-State: AFq9FYI5KoGoSQeI1nU6qsMdB9nu8BvS08q0H6szAoKZLhVspsQdL7zm
	qK8vbkJ7yZJQWuLeQaMwstlSQtNMsntCjIDNtCHIc+QxrgHGucVL8Qud
X-Gm-Gg: AYBFou1CwuEZrVKOVWLe0s6seDzJs7c4xSlP4HE0x9puxT/7uim0REoY/z6UJu2cfAy
	j6v0vFs+4RgYxqiRIiFUT6K9VkYffeBZZrthZBn+H8GOb4o/ZO+1UTrA2r3rjMRrnZz2D39TnIY
	nuHlUa2tSmxFo9b2xSpCJfbMZklGhxn7YAj0N9eJ60dXAnkTwtxgdvQn7Ti2JDdGn+EoaIFyMys
	UulZ2sx4vaFPBlKX2ZFRhttaB7e8qVHoKSwkAbOe/M0oUX7uqlQjud2RQsVmlkFboItZ8KbIUjs
	Dn/0TQbG0qECZ7eveIjG85F+JX4pHQ5DJnYbh+2GJhJbexZoZp+lXPL0VlxKVuVoBOzi5FFWSHs
	coCbV0NSNyZrEjNCVwv+m6eEFR4r+0VFxta94/iuXUde/YOLtQe233fzsOYfd6SYrvEG/YJRGJC
	g0e3hJZpOMryvaNoQRB0GG7YAW7aGJjquyiEygf+ECLADy+MoS73g+ZvoZ16pgFsYUKqkbNb8IV
	LhJ+Bcv5oQKLlZNRkdLhRTSsAC8XX5mqKp6brhLkLijmfRhnmEx70jzEw==
X-Received: by 2002:a05:6a00:3a0e:b0:881:fa65:d507 with SMTP id d2e1a72fcca58-8a6e6a17a2fmr1919876b3a.22.1793191934270;
        Wed, 28 Oct 2026 05:52:14 -0700 (PDT)
Received: from [127.0.1.1] ([240e:46c:8910:7739:c024:4f7e:9059:99de])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6e634ae83sm751438b3a.20.2026.10.28.05.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:52:13 -0700 (PDT)
Message-ID: <6ae1effd.d3aa34e6.c46b1.441f@mx.google.com>
Date: Wed, 28 Oct 2026 05:52:13 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, Pavel Machek <pavel@kernel.org>,
 Martin K . Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
 Marco Scardovi <scardracs@disroot.org>
Subject: Re: (subset) [RFC v10 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB
 LED driver for ROG NVMe enclosures
In-Reply-To: <179319085271.3664457.8130606663267466619.b4-ty@b4>
References: <20261015140051.1159817-1-nbg2974@gmail.com>
 <20261015140051.1159817-2-nbg2974@gmail.com>
 <179319085271.3664457.8130606663267466619.b4-ty@b4>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thanks, Lee. Your reviews along the way made the driver much
better, and I'm glad to see it land.

Liang

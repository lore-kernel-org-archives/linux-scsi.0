Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E459D49C4D0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789640626; cv=none; b=IYqqJ9av0Rc6TJB+XKCwX3Mj609uDkX8wLBAZ5I5wHPNOdJeB8KY7frm3ZvPlQMUmHFNqEQbsfd9qCDAdH43/xr1zMAoTQwf6+ug+wZ127Im3fh7iSWWsMF7p92M4X+MtmXRka+d/+11yWe9UUk0yj7CIoEfOT1SV67GKgXIyvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789640626; c=relaxed/simple;
	bh=B79Sq4VTLvR/AcDoKEQY06XTFQE08CROuBY3LjOGCTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCISrLHCrj0dBBlEQG23YYfX0P3x2XNkkaUYDnFBVwFiazMW5lcQGi/S6cZzlww9G6WkvDrIbNLq2nVYSh3uTTQRJtQJkrLZNTinOiITfVmG7rdadQXUf2G7Z7VzXp272LbDYb47JnrqJUNFz6Fd3Qhg84eSxRwfoJzt1Q278Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=czYboQqC; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="czYboQqC"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843cedd129so458630f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 03:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789640623; x=1790245423; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=smBhTN9/U4mi8V9DsSeIx1UEjzE2dpUakWiDYgy7PQ0=;
        b=czYboQqCi9bvd7UyAHIH6EzpUfxQW5qxFJPMb9ZNgKAH/rDhxLdrWUcgZkPQvj5jsk
         K8+hBIuohT7bDleF8IHeLpzbuMpp4wBtut/3PPyPF1PFM8NV5M7JMia9gr/DWW7NAzVV
         1KhWgYH/ESqm0XqYWj1aUTBD6V0EL+ji9d3mCfBZ/59GA7/LTGhcMglcUjvklYC+NTXC
         6KmJihNDGuHQyYv5kDDsDp/6DYWI2ZsPp2wN8fqxwNaVnRrNqE3Q5+4cDPpFZpgIm3UZ
         xzMNM3lFxD/wiMenQsYG+kxq+1K23xjLKuXFGDngwx198tzE3h8P1CsUmDJ5p4nDjjxF
         y4uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789640623; x=1790245423;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=smBhTN9/U4mi8V9DsSeIx1UEjzE2dpUakWiDYgy7PQ0=;
        b=c/7iOHaMHtOtK2eDmfYNYFqGZd0sI1lj5oe+zfNSrAgvybC0x4W9VespBKMOALKuTp
         CwRFEBgRJ/M5PXeYABoDtWWwm7JW7H62TStiAJWfCRaU2Fy9apcebjogaKrtS6TcEBgD
         DAcut7zseznhkezHhPWR4pi/SkWAa1xRlnhMgLgeY4TH/lBC+9pr4bs94nHYLpPZPAN3
         45jihEXlPiXDQfwrWkgZ6WjHkik50T4k26MHSoy0EexmXEfwhP39TO885ZAmDbHsp7zk
         4Vo7p536dmxGwWks7qJbKGaIt31NVW39VUp/rpoRBePBvKYJGpWl1QUCE/PhjVZshTrg
         Jlrg==
X-Forwarded-Encrypted: i=1; AKwUvBzGpw6Jx2zD/+xjABk/29WUnJBm7y03Jn0jjNiNOVi7EH0OzOL9UTUqaN8EaEnZBrvlSGwfjdYsO53o@vger.kernel.org
X-Gm-Message-State: AFuF++mwv/GHUYDWgCPId/JMVcNcz+rYomukGSsiOlhiNZZxEnbmVnPX
	fQY78xSGuBwdhX+vj8fS+mtH+VO1tdIUsGaC3A7xhQbTkYXYrrZpAQriMTXBHhrHwA0=
X-Gm-Gg: AYBFou1AuoUfwSrM+B4+ApcfaZW/ZEYvH49diX9JXZhFqmT01EChSNrMoJVuRdRFJby
	uP/568SFOI4PnDUjNzTayct+frJATPgBhDLmSgooGK6sMurO55nSz3MUpDWaQDj4Q0d6yc4y0D+
	7zr+4suUqW866dFDM2hleZtowJlGsM9NU4l91cwEpTfItEbYP00NfIPDgvt8TeEYzzx6e1PwJ/k
	e/G+G/6brCNx4oXiuwiq9ROfsoz1bfKC8V17ocib1YHGPjGwK4g8nEgGPL5aj5MpLdOGJBiE/SZ
	lOpWNZUeKVjoCYG7fagWbjFa71sHIH4hN56+49e5al4l7c7Kx3DkpNdzLxh0IID4D8RXMuwL444
	H7RVwn+4WbzumGV/7zAb/UW4AhwEdw8Tn/SHaPdPHFY8d2TWMFCBqFtSwqNiayuoSF3Ge+NRmnU
	KpqmTnzgERb8eO5TKLY+OweoyMeiaGbhlZey5+SgXk9HlYKK5+CJL5//pkX8+P0R/da6vmidwm8
	pWRoEKtRNIEzO9SRvOFk0uYuDy4Ter4ptMiFAUjMFM=
X-Received: by 2002:a05:6000:2303:b0:487:34a:5a3e with SMTP id ffacd0b85a97d-4870cee0b5cmr14494524f8f.3.1789640623043;
        Thu, 17 Sep 2026 03:23:43 -0700 (PDT)
Received: from ?IPV6:2a02:3035:b78:b364:35d1:1f7e:e764:4faa? ([2a02:3035:b78:b364:35d1:1f7e:e764:4faa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf4161fsm13125381f8f.34.2026.09.17.03.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 03:23:42 -0700 (PDT)
Message-ID: <6041fdad-78b9-4310-a86b-f9931563de19@suse.com>
Date: Thu, 17 Sep 2026 12:23:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] uas: JMS578 returns reproducibly incorrect data after host
 reboot
To: Michal Pecio <michal.pecio@gmail.com>, djraszit <djraszit@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern
 <stern@rowland.harvard.edu>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
 <c335085d-a824-4632-ad3a-c06715258c81@suse.com>
 <CAFKhL9f6aLZgerw_7bohbQWvzMxSfd-m-LFcuNP1_p1vWkN4=Q@mail.gmail.com>
 <1320caa3-85b5-47dc-aa2d-56d3b003c6ef@neukum.org>
 <CAFKhL9eTD7DxtxMSMuUVP9cDG7Nq4jvrkTCjYfwr9puZfuC4Gg@mail.gmail.com>
 <20260915233818.5881ad97.michal.pecio@gmail.com>
 <CAFKhL9fL++S1xh+aUCuYbk6EkLQnfUn95y7TBoWaGnPAVP1gYA@mail.gmail.com>
 <20260916204713.22c4f575.michal.pecio@gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260916204713.22c4f575.michal.pecio@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16.09.26 20:47, Michal Pecio wrote:
> On Wed, 16 Sep 2026 19:56:25 +0200, djraszit wrote:

> Looks like JMS578 doesn't like being connected to a booting Pi 4.
> 
> Or maybe it's shutdown? What happens if you:
> 
> - disconnect, shutdown, connect, boot
> - shutdown, disconnect, boot, connect

Maybe it would be worthwhile to shut the RPi down the hard
way, that is by suddenly depriving it of power.

> If the problem is boot (second case works, first case fails), then
> I wonder if it's the firmware or the kernel. Maybe you could plug

But then why does it work at all? You'd have to assume that
the second boot crashes the device.

> the disk after the kernel beigns booting, but before xhci_hcd loads?
> You could blacklist it if it's a module, or bind pci-stub to VL805
> to prevent automatic xhci_hcd activation and widen the time window.

	Regards
		Oliver


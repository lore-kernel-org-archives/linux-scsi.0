Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213F39FCBF
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791799098; cv=none; b=mhPJj6wpfBTxvrjvk780iTGO9aWog7EaHg/R6tRR4ud2EAdDE9VzxnXPoTIi45eSCU06QWw3oIe2J/VvI90WeCKiwCKziPotFi86aMEFXWW4Ez2Kl0ExRhgF2KB9fQyPCm3TyzqRbbSgOHRWDXu9Vt1ROqghxrWZ0BDPM52j/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791799098; c=relaxed/simple;
	bh=+qz45bEvak7AqqpbMhPBAE0YTCALmE3F+7faJ+adWQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K9zvuKRJ63Exrj3UHN+rB1C+APFywOtmj1hL3UeZNnxityK1R53kjU5PZ7dVamAXspL7EZbUIFt5WTpn352ESSKQDbubaYjZLnS7Em9/QfEpB27tf6NPQwHP4XQcj19Tz/qZaxMDOAInYGsCMNzfxrjFtx221i+ulSRCY0EMukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bY7iVa+W; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bY7iVa+W"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a16c1608faso22159045e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 02:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791799095; x=1792403895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYE0bMxPHnmShz4Xu8tYgt5YI11ArchW9zzLXSmu928=;
        b=bY7iVa+WiFosuQG98MKUDtMAeOywHWQXnc01wZjc1OyXiZc/TUgE9jIyUsViRDF/nX
         r9VsAV16kjF3yxq+KbXRyityCOIxSjJf0JwS/U8AHCK4NO475CD4dbYkQ3QiNYK6AXwM
         wNP9lQZc4R5YfCxbQmLH5btvzMm2lqVQ8fZDszqsGay61UGRMSzpnZ7CpicTQOJnPnPf
         tHIPIMvD8AeyxiEF3aV2CGGHVpkb4W+pGUcIlvbwK2zByVTPRYfNoQK0McXdGaCKuvIb
         4/v5fRnchh/WyvHlXjObKnks4tB3wCIckFayM8pNdeCUl3jW2/Ub4ZOt+C7WNqvtZCQP
         wneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791799095; x=1792403895;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EYE0bMxPHnmShz4Xu8tYgt5YI11ArchW9zzLXSmu928=;
        b=T1Hd+XqOTsKNqSpKd/pY8tf8VTcxvMl69IYvwv9CeSiBmCtQ/3pucJ1DpeQZd7FMpG
         xh9MWDsp6nlWk6afeSxlYsYnzRnDb1nNGqQ5x+SMeQJhpLUMiHVb+ZhP+ZflgC1JNPTR
         iP29kqKAJfIuOnn5yKEciVMZ/OvnQ+BK2K4OcmxYyeeAJo65HM5t3gd1Z8hlJvxiuawD
         Jg3cRpAq16v7CemoSzMkDizoqVXZFWJVt7HMdD1IDa/ijdxESI7a47SQmAwLiuEk4UeM
         oIjqk0H3W9laFaunSTzIJXYxYjYllgXn2YgePX0eKJKAb3aXbahpt8QuTi8M6TPI9eph
         4AQA==
X-Forwarded-Encrypted: i=1; AKwUvBxingig5mlUxMXh08+DWAOeo99bcylx4Cw7+zfj7+bQAGBH6R8psZHX1S1Bw7u9AQkI8SPZ85Nl4cPk@vger.kernel.org
X-Gm-Message-State: AFq9FYKdygcDhEWSSCZPfyPhl34N/r6rStPmSijP/APlG3+WyBxdHWVN
	JB0Glkbc8k5tL31yWUMxAd/5hgh8kAQyB9PBezIc7avxs/mTpLHvqkCgVIvPq1l4CE8=
X-Gm-Gg: AYBFou0asTd99SIQOTzOsA8tFi38MlhaQIf7BO3fiV0wKbtL0R3wzYEBBFzyxUWC/L+
	9FJ+hiw01gbxxiY4Wwz5uSDStqqsMwhVoCnSec4IJjEmHhYYVcw6rWGVD0Hpyxqc54QdSh6facu
	a84Lrgjl9cGAVsWtolFWemdCTPYzsVqGM6m8LNSiaDMg7n8jet6FMnKARyU73o3nmBPBF7/MqyL
	B/Fq4qjgr/Do6Mwf05pf+Bb2vfwgaz64y17bWLWUodCZ0kxfw2o3Xt52296K7EgDKQFtB9/gAcD
	yJtrCBu0Jkw7xTTgR578ieamOVp+xbmvFkfJIJypQXbQ0d9VR2VBVoEVdRxvh2PVOHM6HMkpZ3V
	ZhArAMiJNVF6dTd0gOePFs0DKSYeVIRnRLxOeltIHEUA5R7GDJ47v/Shjdv5Ow4QtHlS3JYyS91
	BzPN8CXwOg7+YFc0aj1Acl7ybPv6ISs2BiELqB/DClOQgbcdgqX4o2uhx0uIp4zf6upnqVyArzZ
	yVh0sm/fes44yoOoccTodaAi45iNpswmjH2UcaE3mO7+xNidn0=
X-Received: by 2002:a05:600c:5254:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4a18e4aa11dmr175213145e9.16.1791799094816;
        Mon, 12 Oct 2026 02:58:14 -0700 (PDT)
Received: from ?IPV6:2001:a61:13ea:2801:a5e0:1486:6c57:8b2c? ([2001:a61:13ea:2801:a5e0:1486:6c57:8b2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18c1e33d2sm380625085e9.0.2026.10.12.02.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 02:58:14 -0700 (PDT)
Message-ID: <3cdb8068-7af2-4754-96f9-5177a09cc3bf@suse.com>
Date: Mon, 12 Oct 2026 11:58:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] uas: JMS578 returns reproducibly incorrect data after host
 reboot
To: djraszit <djraszit@gmail.com>, Michal Pecio <michal.pecio@gmail.com>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
 <c335085d-a824-4632-ad3a-c06715258c81@suse.com>
 <CAFKhL9f6aLZgerw_7bohbQWvzMxSfd-m-LFcuNP1_p1vWkN4=Q@mail.gmail.com>
 <1320caa3-85b5-47dc-aa2d-56d3b003c6ef@neukum.org>
 <CAFKhL9eTD7DxtxMSMuUVP9cDG7Nq4jvrkTCjYfwr9puZfuC4Gg@mail.gmail.com>
 <20260915233818.5881ad97.michal.pecio@gmail.com>
 <CAFKhL9fL++S1xh+aUCuYbk6EkLQnfUn95y7TBoWaGnPAVP1gYA@mail.gmail.com>
 <20260916204713.22c4f575.michal.pecio@gmail.com>
 <6041fdad-78b9-4310-a86b-f9931563de19@suse.com>
 <CAFKhL9dmR1KDaBQGta=X5xDCGirzJ8t7u0rH4HUgBoFqN152DA@mail.gmail.com>
 <20260917185650.7fdea3cb.michal.pecio@gmail.com>
 <CAFKhL9dYWLYhkj_687Out_hS3fxORgpCpggag2NwoVYbapyvYg@mail.gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CAFKhL9dYWLYhkj_687Out_hS3fxORgpCpggag2NwoVYbapyvYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.09.26 19:20, djraszit wrote:

> So the current comparison is:
> 
> USB_MSD_PWR_OFF_TIME=1000, bus-powered Genesys:
> -> BAD-data after reboot
> -> invalid alternate GPT
> -> BAD direct-read hash
> 
> USB_MSD_PWR_OFF_TIME=1000, externally powered Genesys:
> -> 5 consecutive reboots GOOD
> 
> USB_MSD_PWR_OFF_TIME=0, VBUS supplied by the Pi:
> -> previously reproducible "Cannot enable" after consecutive reboots
> 
> USB_MSD_PWR_OFF_TIME=0, externally powered Genesys:
> -> several consecutive reboots GOOD

Hi,

if we come back to this , is there anything the kernel can do,
even conceptually speaking?

	Regards
		Oliver


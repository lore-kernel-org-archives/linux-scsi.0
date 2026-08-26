Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACEA43B6FD
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787754018; cv=none; b=T7hYT+0itWsNv8ep1HolVxn+YyCI/Q2Jh/V6JKms3MLoHiPxsWVY5pGyc5Y0KLd7Riwvi/xjv/WnpD78E1Rdes4DPE5bmlJfbl1lrxSaWBzwBrK9PySZdRnrNLLiJC2VNUf2KB7u33aBKW2pEJz/sSve/9KCsj1O5TT5yZJrzpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787754018; c=relaxed/simple;
	bh=wukuL8CwW5Sw95Eq3HK+NwHjNtJ5hpUPHptVYnfF13I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QXB4Znrj+qdo5lS+OhiQ/LQ75b53Iyr1tZqgJ0sOpBf82GKHkUDbvRhCHBTcrKTuG8NfocJC2ZESYVKJCFFApyAhQh4UtGdnHsbQ0O9mQdccQkkGPoFkSeu9q1OvRM0RYs+yoBF7O7LjQUMav0rN11ZiP1zA07hGTOUqmbCbASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cVrkRI/P; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cVrkRI/P"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso1064814a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 07:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787754014; x=1788358814; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/1XUCO5ehW6HIK1UxtZ/MdhG2zZvli3B4/DG5Oizxoc=;
        b=cVrkRI/PMurosqZocvroLG2C2KTArW7gOLQgtIC/Yvq7jlbJhoreSZ7D7umvnULUPW
         Md3KpIdecg4PTIlWfifW/lkmAUj2tfCoqbhm1Qgl8xLfe7mz7kkhvBqymh1w/4fytj65
         KVDkIeY3S0WpxkrzmjxYZstufgX8p6WqiJRD4lIog/FKe4yXYKq7o2O+JDqyxqf1n53j
         R5OVGCiA71M2BeHH9BMGQE77As131utbJpRe0lLLXpukuwGgNR+phrIaWcurAelTYSEh
         5DQlTD6yN6mgMARUfm4NmDbWguE20NQNA8O3J1/i81M2hFlFyNCwGMRKF6MkbH92Nyz4
         G0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787754014; x=1788358814;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/1XUCO5ehW6HIK1UxtZ/MdhG2zZvli3B4/DG5Oizxoc=;
        b=syPjMGboARpca/rxLGXQmO/qrqV7w3e8rTEiNcz9DZn1VCDR/fkBTstEx1xMbVmSUt
         CQ1LCfJILIpoH4sj9KEYyuWF/Wg4sA6C+GPCFbdUT7OYM8GgNWP1ntTE1jGdTY2BQRXo
         RGa3+k4V1rQ0hVdZNr82J2tCacARxHtgeqh+4VBhw08FWpGzZ5CE0IL9jfwe86z3ChkH
         SRdjv4KM6SCnrfmOtN3jpLBcz4CgNebgN4wD9OTKGnUYdWl7GCaAgBkL/UXcLQ9oWGjx
         4Wk6r2Aq1FYRCgfZzuwTiWtZG/7A5Rlu+fRr/V1YOkv3JBl2AE77E/dYmm5hRTPAthFu
         1DdA==
X-Forwarded-Encrypted: i=1; AHgh+RrbULDZ7cjUkJjPU5m1LBMJCwOrR9DfaN6SO1W6BtdiAy9vaUg27HXOaLlQ2r6heRxXnSDveTjNBBCs@vger.kernel.org
X-Gm-Message-State: AFuF++lx4P8JwaOiMgYOk+YrEkqqS/aTg/ZjFv3Ln4aVMo7F0hTCqTXG
	6YsytcdmkjcI/1D+YinNK0RtIGVnezhVkln59BCdLSqjEmcSLz4rkR95
X-Gm-Gg: AR+sD11v4py2WU/UJY4uwofIw3mh4vm8rZKyNJCtDlNZzu2UEpVeOm4iBnT7fshCW86
	iBC1EHnTPPyJUAcrZdlQ7yZKHpAboFW7F+IH1dAgsspFZPHzEoxJrgoMIcagFn4WQmkedW0ZN8W
	VE2zQ6ZwTqQK3ywK3lj63IWlPMshGwxkkLaTzJ7oY66XB5xyA/ONhX0uOsvkIEjb9uGfeERDJrd
	lfLRi1iWR0fvOLgo5L3e9E0jJPgYA+h7fE1oSfVY0smLoI9pA3WwL9gCW7toqHqm50F5USOWC4F
	+p+GBDsRevV1ugBFi/oNi8gEovhpEE5wBMex/LM0RBlYnrSRHgIZEqQim8oFfH9eR5eOzJ0iloY
	cMqJ8ACpXd3RicpRa8JDPa4SNAW73VX0/I2KZihDnBHTodLLfVUYJBn17fqKTkJGyY18ywUZVv+
	KBFUDWQtfw9qtC75hS9pRK6KxwhpcWBO56v3+cSuI5COB+kTJqKEgahpk9Ap7QD9pDfIN8N/QYx
	nwjLveVkou3qCjUPsQOr/3Kp7UuLaEkEQHqpw==
X-Received: by 2002:a17:90a:d2c6:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-3966d3dafb9mr16370184a91.11.1787754014381;
        Wed, 26 Aug 2026 07:20:14 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60bf36sm9592172eec.2.2026.08.26.07.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 07:20:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7532cd0d-6f9d-4278-9216-5d9aea92fa16@roeck-us.net>
Date: Wed, 26 Aug 2026 07:20:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] treewide: fix spelling of "overridden"
To: Linlin Yang <yanglinlin@kylinos.cn>, linux-kernel@vger.kernel.org
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-hwmon@vger.kernel.org, linux-mmc@vger.kernel.org,
 netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org
References: <20260826083715.625136-1-yanglinlin@kylinos.cn>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260826083715.625136-1-yanglinlin@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/26 01:37, Linlin Yang wrote:
> Fix misspelling of "overridden" (missing a 'd') in comments across
> multiple drivers.  The correct spelling "overridden" is already used
> 292 times in the same drivers/ directory.
> 
> All occurrences are in comments only, no functional change.
> 
> Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
> ---
>   .../gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c    | 2 +-
>   .../gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c    | 2 +-
>   .../amd/display/dc/link/protocols/link_edp_panel_control.c    | 4 ++--
>   drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c               | 2 +-
>   drivers/gpu/drm/msm/registers/gen_header.py                   | 2 +-
>   drivers/gpu/drm/nouveau/nouveau_bios.c                        | 2 +-
>   drivers/hwmon/abituguru.c                                     | 2 +-

I would expect this to be a separate patch to even consider applying it.

Guenter


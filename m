Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634601A38C1
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 18:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725994097; cv=none; b=AS8snQYDrArCCZbINhGROhc5slYA3wSMmUhApBMAOsBBw22M/i9smIUD+GziRR3rB88oh8xBqJPKxQyU2fBq+QJAXjKZi3Gh44DN2opxxaFAMuit7z9ex46RV3R2GagswF2+Ta5x2m4posdz1LVAj8yEgxUSvOGovcSq7HdzBcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725994097; c=relaxed/simple;
	bh=exfRCSbeGc10MpECC/7e0V7yMgHOMWsZWQLKlDrqrcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hEKevKeDbvin9tXTK/bp7/5V4fkNqKYAdTv6Pg1a0tOyeyzidFTkdoJGsUgdSjmFOp8bkWY8Hlw7fpikRCVPU4ihScp/wqJ6gkLuOlE0XMyZaIba3gjFk6O4Rh/rbkvSsyOn2ZfTrf7XK1mT9dlAx9rrleECHDiYoeLf6z1aSII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kUDQAkkP; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kUDQAkkP"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-39d47a9ffb9so19048655ab.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 11:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725994094; x=1726598894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h4y68weuYe8VzZteJIbmlHGx6ZRCIwg+66SDRaOQ0Pk=;
        b=kUDQAkkP9s45KUpgoGEAQfA3JED/wygrDeLXG765VwPj/PmD8mVn5kq+8hxFJo1Dmi
         CbNKYNt87K3HhhRzDO3pTSMMGRb6+1pQxi/sLPkfABYefVaT3kHpR0SpnGEuk6/GzK0x
         oNQ4pPlaEbLj5senKZ8qPsne0dQBqWvun9nkBzBSWnpvPHzu0u/ptXhE+VxfOI+lH7qh
         VX1yMOdpgYP8TBEVk4XmBq99STKwDQ5a+JT21NcFMqmpg3CsDbh6KdcbaXJpAIQi0C1y
         VyZ1cNYCLpUjM5uNhk2y9CYQv+saNLrKoGinYUEzp/wfH8zqp/cTQApAMTn9VFQv+4Uo
         Dv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725994094; x=1726598894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h4y68weuYe8VzZteJIbmlHGx6ZRCIwg+66SDRaOQ0Pk=;
        b=rcElJNg5tbLflZaW3ZwP52liQJ2a9tmFZX6qUvMo4NJ+ewtDUoiOpSh02b/B8/fNeu
         WBZfzjpzleuSYQZJrD9kTr3JszPcf9awBhrEGtYCAFL5bT/m24e7I5rB5kin96YmEaXX
         E4PiArvH8McSV6mSlScosS0zxs+CJ1nqP2eGL0AOgetP8qF46H7YuWVOCSsBS48qTfj2
         j4P1HxplZaipLnnFUGyG94dg0v4FdPbLhQVioVyWEWxGn8C7DqsaZqb+H8hfcTrAkIYO
         SvDe41IfYumvN+VfWhOnhGbwqfXNIFjPX4h3Av1CbTkcws624BlXJqtKoTmXfKdcPGZb
         xHQA==
X-Forwarded-Encrypted: i=1; AJvYcCVBmcDOMpcL045Hg+L6jBnRzGwZIJxSloqPekbbR8woPv0pzqCKsiN/MUDNwCvdhgQzFKyAJlu8ojFZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzeAtUH1k6WDWKkLhS7yg1FoafpSa7ezXjdw1Fx/gO8jjfQBafY
	vp0XDmhMGSjjmcM6ZCqNzU8hma9XeiOlC8+LHQsXYOF/9aBdJ7eLSr7LC1N95AA=
X-Google-Smtp-Source: AGHT+IEbci4bFKk4qyfG7I+1DUOrdPWBQtYa+ssZc5w3NRdfD9WSHDse9oCgXPz7cY+ZMf7HVvKJ8w==
X-Received: by 2002:a05:6e02:16cf:b0:39f:5d13:9491 with SMTP id e9e14a558f8ab-3a05745eb8fmr106220205ab.7.1725994094344;
        Tue, 10 Sep 2024 11:48:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a058fd5c85sm21473895ab.23.2024.09.10.11.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 11:48:13 -0700 (PDT)
Message-ID: <e6792bd5-1bd0-4a28-b0c9-7e49f74505f2@kernel.dk>
Date: Tue, 10 Sep 2024 12:48:12 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] fcntl: add F_{SET/GET}_RW_HINT_EX
To: Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, brauner@kernel.org,
 viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
 jlayton@kernel.org, chuck.lever@oracle.com, bvanassche@acm.org
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
 javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>
References: <20240910150200.6589-1-joshi.k@samsung.com>
 <CGME20240910151052epcas5p48b20962753b1e3171daf98f050d0b5af@epcas5p4.samsung.com>
 <20240910150200.6589-4-joshi.k@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240910150200.6589-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 9:01 AM, Kanchan Joshi wrote:
> +static inline bool rw_placement_hint_valid(u64 val)
> +{
> +	if (val <= MAX_PLACEMENT_HINT_VAL)
> +		return true;
> +
> +	return false;
> +}

Nit, why not just:

static inline bool rw_placement_hint_valid(u64 val)
{
	return val <= MAX_PLACEMENT_HINT_VAL;
}

> +static long fcntl_set_rw_hint_ex(struct file *file, unsigned int cmd,
> +			      unsigned long arg)
> +{
> +	struct rw_hint_ex __user *rw_hint_ex_p = (void __user *)arg;
> +	struct rw_hint_ex rwh;
> +	struct inode *inode = file_inode(file);
> +	u64 hint;
> +	int i;
> +
> +	if (copy_from_user(&rwh, rw_hint_ex_p, sizeof(rwh)))
> +		return -EFAULT;
> +	for (i = 0; i < ARRAY_SIZE(rwh.pad); i++)
> +		if (rwh.pad[i])
> +			return -EINVAL;

	if (memchr_inv(rwh.pad, 0, sizeof(rwh.pad)))
		return -EINVAL;

-- 
Jens Axboe

Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E7204032
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 10:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730197043; cv=none; b=rN/Nc+vXQI5kfVV/oyWNqDIiGIJOX+N1QLz1gkt3/RFqhasC2veFQBsZ7FABK4XfjPHrNnsZ+zSmL5+Kgb+kUfFPuMLqZip7dRaUOe2fNkkm8K7XSX9HYfya1Wh49JGlpdXf3Z8RvNRcsLJzweU3ma6L2KFYUzuanaHC4bQ93II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730197043; c=relaxed/simple;
	bh=xXSJ8OOCn9HBEI+kXuJP/EAgN8qA9tljHKVnW45efnk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l+8zD/C7+pv7B0C6rTRkgvo9reat1cvLSixluSwabkZR3a/BDY9Mkc5PD0nqI2CT4j1Htaf8jKonMFkxUZw8YrTm2b54ntBmkyG1GS4U5ntzPKdVd+MJxvUKU/vJJT8Iek0x1BooZGfo7GK5zxchvsWCo8mwJbu74TRGAGVglSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMgvfzKk; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMgvfzKk"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c941623a5aso10040527a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 03:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730197039; x=1730801839; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xXSJ8OOCn9HBEI+kXuJP/EAgN8qA9tljHKVnW45efnk=;
        b=VMgvfzKkY581wpQt5fIekTzRBHCvhTqgdvZHbkKziDbGSmVxs2vaPBNaFXuAjrXj9J
         SBLpUpgg7KjQ6GsqdTyVXfR7oop0eeZv2vZmO2DzVGsYE0MQbMQWkv8U2VIKNH64HCpe
         Fdam0rJ5SQP6ChhuwMAnJOjprYe1apqMuG3BAFND1BoK3EHko8mJ5+w4OFfkcBoTdVPu
         IwEDOGYXnNmICcPwJdaSCK2TThZFyeuxyMldNmoPaVqth6tF0voSSfc3gQ9YFCaXW67/
         wuX6lTxUdK/DAX3rK4deLNMRvG0o7meZMgrDy6fHt25P701BbDcrxCMBYKzKPUNMd93X
         9bAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730197039; x=1730801839;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xXSJ8OOCn9HBEI+kXuJP/EAgN8qA9tljHKVnW45efnk=;
        b=woxaqlGeQpZhDWycGHBnXAVU5Q9+CO0jnaM45Gyj64qO0XcjPuIxZNGihyTKdbXizc
         xmcSFsBJI9NxHikyvnFMEW7OksxwktyEy1rYDVlfIeSwcV6bXDLOJoauRIfwSs4/N2dX
         wc1xUPl2G703F6/V1kG4GDXWguRZhXwN27WxJRMKd6dYNrTOJSC1NXDJRJ1G7DFes4dQ
         ZQZxRFobbt+Pl5I/UEpQvSWX4/YEILq0OSSMV9ZvJDRlWEdYJQ1Z9nBqdBCNyvjIBQIw
         3O+wyByHHAhg6YJtmxcgbC2H0nu6dY2d6jLuKH0bCWSFVpz54Dw2Ae+c7M8LIW+BsF9W
         MBDg==
X-Forwarded-Encrypted: i=1; AJvYcCUnqIs+SkLYr9TEynq/BFCfNA851y5417Hy56Hikdsj1ul56AHNGoKZPze8EDYxItTM361z7YWTHDQz@vger.kernel.org
X-Gm-Message-State: AOJu0YzMBk6o/kcnRCycaUpjw6lFIrO3MxLb7URE18XRX/OFMLbjMOGW
	ah+SBd2WuU/sggRKY5k40hvaTC3pEKpks6k4mCSjbXKu+2YLswNuzHmTjy6Pg/w=
X-Google-Smtp-Source: AGHT+IFfLKrpgiZkQbhfbTdMfsVbPWc7M46gK4NvJB/DlLy9tiRBfr1PGk+s8DOb6uJO1V03kWzeCw==
X-Received: by 2002:a05:6402:51c9:b0:5c5:c2a7:d535 with SMTP id 4fb4d7f45d1cf-5cd2e3543f1mr1177392a12.16.1730197039306;
        Tue, 29 Oct 2024 03:17:19 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cbb6255e20sm3835458a12.12.2024.10.29.03.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 03:17:17 -0700 (PDT)
Message-ID: <330e0b7fce03b2970db80c4b73b611af220b6349.camel@gmail.com>
Subject: Re: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
From: Bean Huo <huobean@gmail.com>
To: Huan Tang <tanghuan@vivo.com>, beanhuo@micron.com, bvanassche@acm.org
Cc: cang@qti.qualcomm.com, linux-scsi@vger.kernel.org, 
	opensource.kernel@vivo.com, richardp@quicinc.com
Date: Tue, 29 Oct 2024 11:17:15 +0100
In-Reply-To: <20241029031114.517-1-tanghuan@vivo.com>
References: 
	<SA6PR08MB10163D9B8FE4BE9DF5A47D9E1DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
	 <20241029031114.517-1-tanghuan@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-10-29 at 11:11 +0800, Huan Tang wrote:
> > On 10/28/24 1:04 PM, Bean Huo wrote:
> > > Even though I don't think it's necessary to enable a Sysfs node
> > > entry
> > > for this configuration.
> >=20
> > Right, a motivation of why this functionality should be available
> > in sysfs is
> > missing. An explanation should be added in the patch description.
> >=20
> > Thanks,
> >=20
> > Bart.
>=20
> Hi Bean & Bart,
>=20
> Motivation: Through the sysfs upper layer code, the WB resize
> function can be used in some scenarios, or related information can be
> obtained indirectly to implement different strategies;
> What is your suggestion? sysfs? exception event? or?
>=20
> Thanks
> Huan

hey Huan,

What specific scenarios would require enabling a sysfs node to control
this function? Dynamically adjusting the WriteBooster (WB) size on the
fly doesn=E2=80=99t seem ideal to me. From my perspective, the main case fo=
r
this feature is if the OEM didn=E2=80=99t correctly define or set the
WriteBooster Buffer size during manufacturing. Even then, adjusting the
WB buffer size wouldn=E2=80=99t be a frequent need. If JEDEC has found a re=
ason
for this feature to be accepted, isn=E2=80=99t there already an interface
available to configure it? Why would we need a duplicate interface for
the same purpose?

Kind regards,
Bean

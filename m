Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6328314287
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 02:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701501; cv=none; b=ukDxVPmcszaKQ0QPLJlXFHLAwFc0eSa6IhTkfDvI9Ppl2JDwVpYS1GK20hzj7r/aqfH9jwGvve/SepaML2nQ4p/UWu7/w1P4x+uX/+vh5SDOvUU0y83W+CaygMWJPZ3Q8a7UdRYgxhWeSHbiIIdV/eggao6REp0rk31h2f7vq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701501; c=relaxed/simple;
	bh=bbMUkaxns8AHvRh8jYe2Eawi/NqWsk6vaShfYeAGqmI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=orjKx9FCDfnBVB0GYBd4iMlZ3oT8icObVGYNk5wb4BhMnv/5yAAulDznC6we0J8N/H+Vrs7r/C8OKJC7SJmlGkUSEyAkfyYo16VRz17gF7kU/1fI2YtxdQBXkM3VerSao0iey+vLjDx4fD3w/XIqJTrhxNhsn8j2LGM4eiuPvGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=BoBP8GEq; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="BoBP8GEq"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3d9dd7e5f6eso2210128b6e.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2024 19:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1721701498; x=1722306298; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbMUkaxns8AHvRh8jYe2Eawi/NqWsk6vaShfYeAGqmI=;
        b=BoBP8GEq7h4mF1jvQADuA+2S+VkAjXrIBPtaRjVJTYlrbsB3gd7Kdfw8GgiYqz75C3
         GPMzifm3tmH4wUtC3O3f0hTPMDyif+ZiJNLFZmfp0udVE3+Q71kyD5mqAsRVGrHVwruE
         Y+Gvn2mTJ32GgxOKIUM1tO2NcsQiPaDVWwu68Uoh/IJ9PtqNJKGrVyoydiX627rM/8VR
         ihWyabkdNQX7Q88coU4e++gLPoF6KJ65ppC/Qq8tyNwViTDBsed/AcVWoMxRMw3HyH4x
         v19n/AouTtmjkKW253t2mnn1wL7CurnEW1lIgLZnPG0RHP+vbmF7lZCO5PFStCJ0cMMo
         q3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721701498; x=1722306298;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bbMUkaxns8AHvRh8jYe2Eawi/NqWsk6vaShfYeAGqmI=;
        b=Bv8kcCpoVURWY/wZvMne5GWX7ltTwIn/X21mGtUxsgh3f5Vm8fGoqZR8tom2iqykSE
         xGxKPI+kZyfwlYqX52XXYvn+uGm3kDKO12JxuXkBiDdVtmUF8K6fmZrfsAq4Htb0HQjC
         m8nVDRrMeMYugrCskofKjCrmj1RPd2yMrrubWx/K7LJGDPKX0BDJ8FHGP23EEl3Jge+d
         TVEzbdwR3y0LEZ4saBdEBxWfpxwuZJbSXviE4BN+Ex6emfAr0Qc8ByjyapryJMHTGyho
         oSF2zUImKjoP9hoHqzVyhzbZEfGfqgkUYUsu1NOKKl4Ekoy/ct7gBr/o7emRcrE5z+lG
         WOSA==
X-Forwarded-Encrypted: i=1; AJvYcCW7L32cnnS6TX1d2f5ExujZmtyJafu23abY7PZppULsU0JFOOG4HqpDtbLo/NoZ72Tlk2icNlkUUJ6SVidCAhqzFr9YcEex/9JqJQ==
X-Gm-Message-State: AOJu0YynRz0+LvZ6KLRBfF14bstK7lnbE7/8q+Ne2R5qg7u8KwZbtTme
	pFKgTyzvS/w1I8wBUb5nnt4GPky65i8qhCt/hKsdV3EHiIcEfplb9wdncpYvNHkGIQzYTvFIgKw
	VBfY8zA==
X-Google-Smtp-Source: AGHT+IGKV0Jr707W/PYg3CdIghKKq9m4koiy0RQBiYd5g1IyKHEH5K5usjE4xPPwdEHv17Qb9PHfzg==
X-Received: by 2002:a05:6808:14d3:b0:3da:a0a5:a254 with SMTP id 5614622812f47-3dae97c892emr7610424b6e.20.1721701497775;
        Mon, 22 Jul 2024 19:24:57 -0700 (PDT)
Received: from smtpclient.apple (vps-bd302c4a.vps.ovh.ca. [2402:1f00:8000:800::34b0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a1a7b45af2sm2637967a12.3.2024.07.22.19.24.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2024 19:24:57 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 0/2] scsi discard fix
From: Li Feng <fengli@smartx.com>
In-Reply-To: <55d9f47b-5833-4e3c-9e56-f56a30083607@kernel.dk>
Date: Tue, 23 Jul 2024 10:24:36 +0800
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>,
 Damien Le Moal <dlemoal@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DA41FB3C-D3DF-4219-B027-5E5A69D92F07@smartx.com>
References: <20240718080751.313102-1-fengli@smartx.com>
 <c1b47037-4754-459f-9e8f-ae4debd3fcf2@kernel.dk>
 <yq1o76pdltx.fsf@ca-mkp.ca.oracle.com>
 <55d9f47b-5833-4e3c-9e56-f56a30083607@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3731.300.101.1.3)

Hi Jens and Martin,

Thank you.=20
I was worried that you were too busy and forgot about these two patches.

> 2024=E5=B9=B47=E6=9C=8823=E6=97=A5 08:37=EF=BC=8CJens Axboe =
<axboe@kernel.dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 7/22/24 5:55 PM, Martin K. Petersen wrote:
>>=20
>> Jens,
>>=20
>>> They can, but is there some dependency that means they should go
>>> through the block tree? Would seem more logical that Martin picked
>>> them up.
>>=20
>> I'll get to them. Busy with a couple of hardware-related regressions
>> right now.
>=20
> All good, just wanted to ensure they weren't waiting on me, as the
> cover letter seemed to indicate.
>=20
> Thanks!
>=20
> --=20
> Jens Axboe
>=20
>=20


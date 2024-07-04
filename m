Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FF71C2A5
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jul 2024 03:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062116; cv=none; b=t15/gy0t0UGZnwVbhGNPp/CfijZNNATILz5vwpkiYb9LS9ypB4sZUIm+tkrqlhrpQHQZri+sBNn5dGufItEto1GgFlC41A2SmaOrjzcV7mi2O50HD4yOBq00C4aItdwNWEYtu5t+4L5m1lMgFUKgIHEaY3bxvhzeD2OsiMUeoAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062116; c=relaxed/simple;
	bh=aiJrCreF6nhZTc0vL6R5K+tzKKSERjB67Jy9IJ7xSVQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=l6++exLlUxrSt1TExV9c/ZarkSPhYZ72iyu2b6LpA7G+WPt4Rg2VK7kecswWnl1mvfTMOiZ+tn08CtGPbmfRKn18O3zAx7xgcH0CzBTpCsU9sztY+sQFBfhCt5n5pHrBwHzWouCtkcJur8M4i31HUk090yaxka8efjLpJUdhV/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=QG7jwYcA; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="QG7jwYcA"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6e7e23b42c3so82724a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2024 20:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1720062113; x=1720666913; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiJrCreF6nhZTc0vL6R5K+tzKKSERjB67Jy9IJ7xSVQ=;
        b=QG7jwYcAdUfcQFG8mwIjkNK626wrMEKB2mbcwT6EHR76ywJgBgYD65iMbopVTILN86
         hDZFu14l8qfFXyEqdc1HUgY5T6YQCpLZ5x57khW9TnghcY0IIBgKt2ixBpEofPqV/mQx
         fU+N4lisiN7lmoR2wQjIxdAg1eiumLVbP57p/QlVgVnzU1XUhhLM0kLBN53UAWhvuJt2
         735rVSdGLgl0Vs127PanoFLYvnYQJiwjTgU36zmZsbrmFfbBFfj9O7QKjrTJrjrZylgO
         7eLwe24X4lfn3Cl/I/rJAFeeLz2YoKIf/sTGMhCfqYeY7YyUha/wD1gMLzA4aKMR97Lf
         hEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720062113; x=1720666913;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiJrCreF6nhZTc0vL6R5K+tzKKSERjB67Jy9IJ7xSVQ=;
        b=Ee5DDViqurYCXcqPtFs/MdnCP7T/ct2vPqMrTWQ10wTedRyeFGtO5UnYNgVPjEioy4
         0pxGDyJJ5ZAbcKDpvMR+GBmNxg4NHsKldcYHbr1iiA21Dq9NxmVIFkAtu+1axDqrVWHN
         lYJlgTBX9AqGqlKSmdSOqu237WkI4er7A86zCNy7KarjbPGeZ7xmPJI/gYvLo7mr9eN4
         WLi3JIFbaYlX7C0/Vw3Ej0xbyJ99A/K2gUFMFeQT02daq6+G+diiP1l0FViop82i0Kte
         7zsjZRejYxV4PPyn5HNOn/+BFbuLcRqZ8S+hfcHI5ou+YQHSFLf6FPigyz7Vr4LXrD+s
         dR0A==
X-Forwarded-Encrypted: i=1; AJvYcCV/eotYkyNjb2TiivfBHFznmvyj5e2j18B4vv/CNAQ7EpHmF9c4BCBspiO5gMfrXkOYXACQ85tBbrRhv4OtPty9CMcuNfLRrGhGgw==
X-Gm-Message-State: AOJu0YyAfJlMkEvD3/Ob+LrHuqOxxYC7lb5Jv4y8hjlXB7T66QD2xvPy
	r4xSR8OzA/o1taRw31lY3Rh7RKIxkkvdIOvnPArVdgbtZTm8OJfG/CY8k+kqaAg=
X-Google-Smtp-Source: AGHT+IGppthVj50QduluUwT2ETsJWZWd3n0XLzpYAWEiDTwHoT9p8vH4s5oPIB4f2k/6kzyeQIv3cw==
X-Received: by 2002:a05:6a20:1594:b0:1bd:2aa5:f177 with SMTP id adf61e73a8af0-1c0cc72bd10mr285893637.11.1720062113323;
        Wed, 03 Jul 2024 20:01:53 -0700 (PDT)
Received: from smtpclient.apple (vps-bd302c4a.vps.ovh.ca. [15.235.142.94])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99a97c196sm295825a91.26.2024.07.03.20.01.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2024 20:01:53 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 3/3] scsi: sd: remove some redundant initialization code
From: Haoqian He <haoqian.he@smartx.com>
In-Reply-To: <cde0a2da-fae1-4f9f-b67f-f3906fc5cce6@kernel.org>
Date: Thu, 4 Jul 2024 11:01:38 +0800
Cc: Christoph Hellwig <hch@infradead.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Li Feng <fengli@smartx.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <344C3711-EE11-41F8-975A-EEA312CCD833@smartx.com>
References: <20240702030118.2198570-1-haoqian.he@smartx.com>
 <20240702030118.2198570-4-haoqian.he@smartx.com>
 <cde0a2da-fae1-4f9f-b67f-f3906fc5cce6@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
X-Mailer: Apple Mail (2.3731.500.231)


> 2024=E5=B9=B47=E6=9C=882=E6=97=A5 11:33=EF=BC=8CDamien Le Moal =
<dlemoal@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 7/2/24 12:01, Haoqian He wrote:
>> Since the memory allocated by kzalloc for sdkp has been
>> initialized to 0, the code that initializes some sdkp
>> fields to 0 is no longer needed.
>>=20
>> Signed-off-by: Haoqian He <haoqian.he@smartx.com>
>> Signed-off-by: Li Feng <fengli@smartx.com>
>=20
> Looks OK to me.
>=20
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>=20
> --=20
> Damien Le Moal
> Western Digital Research
>=20

Hi Martin,

According to the SBC-3 SPEC:
"The device server in a logical unit that supports logical block =
provisioning
management shall set the LBPME bit to one in the parameter data returned =
for
a READ CAPACITY (16) command."

So we can use lbpme bit instead of lbpvpd to indicate if the device is =
thin
provisioned, which was implemented in patch 2 ("scsi: sd: remove =
scsi_disk
field lbpvpd").

Thanks,
Haoqian=

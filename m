Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0F37107E
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625908; cv=none; b=Rtxqd7yOOEoxQx+5Jpx9LNnwbwLsTf6G5M7Gy13a32W+kJxoHdL3eBQFW5ehdXMfUhcBGxXjL+rRHGYqMGFOd3HlU4hT7kMcA43OMpQcSRZhVNcZUytVmG9slY2VfNuORTKlAZpr7C5+14HuYvqvnV6voGeusNjryiVe/NEAkzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625908; c=relaxed/simple;
	bh=4E3/cI2ff13Nq+m47QYVkwCHRa6OfvjvBseA3qycb8I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SXxF8+WTZcTKnQWH9YaDCYkvnSCon/+utjvUdmOk0pnT4qtCV07w35lw4WMIgFhM7siSVcTWbaaWcu9bQrSEyAztjnkwiEhT9ZwZb9kfhAChYLEo6/+wBZ7UH76SLqCzf7HwmjDVuMaeqzB5lyo3gb9CWIUQ2x1sWtpzldW7Bm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=tT3jzINF; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="tT3jzINF"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-794911acb04so1327837b3.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 10:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1769625906; x=1770230706; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4E3/cI2ff13Nq+m47QYVkwCHRa6OfvjvBseA3qycb8I=;
        b=tT3jzINFXaG5Ix9iB5hNVdH1o9GS1Onn59BaLuTw2czsLSSS7pIdHb+rIgD4KaFB9t
         SKZ+HoNsjRmNavR2pCZX2Ut6LY9A8HgsH9eoJRsm6ITpAlQQDvonHIlSnM22Ie4h0G3M
         bLUpv+zuCSzxxCjQt/yaMCfQ2pAzn/1018OhfDF4vhI6dyIVS+8tNDa1r1boMfAzbIPJ
         S/drsvPQmwWr6j3t271D6gsBLdQcN4J7S0u9PFI1NDptrRiez77uACM9Kuvlw0XPEzGa
         MW8JVYvcG0+0WEvCny1GuYdSCm9CvDPNHSR8M8tkBGAtUyFxF2fpYlgpLRTo5Xxmzytj
         b9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769625906; x=1770230706;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4E3/cI2ff13Nq+m47QYVkwCHRa6OfvjvBseA3qycb8I=;
        b=BV6xjpDo+c9bmx4+/YppTs0S27Mpotb/008Ie4hL+R4J6SrBjd+sK7T0KxveaIHhhL
         /6y+Eh8W2dP/tblZ94gMzmRFLL+DB9cMzdNrma53ZZtXPGaqG8Gfd5dPRcIXt2oOyCl2
         rrBTu5lKVSPkIT03Vlf+n7r+iq38g3h5Im1TzSG/zhDiXbDvZOE7EaKXKe1ZLk9T/M1l
         FGDtTjn8HdR0JewxFC6WGv3yn7Hz86BoyUps3NLEVLICPJ/tORRXQFhsDqEXstYx5tYn
         YTJ3H09UGljIlXjxzbaPlU66UTJj62eE+Akl6ofLrMOXdDQUFgd0666RC9ROJcJukZT3
         6FUg==
X-Forwarded-Encrypted: i=1; AJvYcCWV0/YKaw1tpEcjOPaPtmCxwpmwMvmF6RYLi/Y28iv/PDHrJW9W9BFlT++xwQpS/vMxRxI8gt+30B4B@vger.kernel.org
X-Gm-Message-State: AOJu0YxtR64SBEJAcxW4/Na37SLmwY3kv4SoK2D11oGYPsqR6xAETBgd
	izQJoaaYyaacwKBRDGxVBqRC5z1qPTEB+KNHXxdj0MdjzKo27SAgk8OX1s+QW3IWTM4=
X-Gm-Gg: AZuq6aL9+GXXcS8qw6L9nPtsDB3BS24hiVA9iLGeOxXZfEWJBEdrGg3jEUv2AjvCJYf
	YgzzvwXG/x+YXqRCtzFk6/kxYhIWqVM2igwwjU72BYap8LQGo0EWDlnpojbAJ79do8cd/hjxoMc
	Jie/NzDtGnIgaWafaTeTUs//+t8MpfCNQy4j/v9QC4xC2INnHTJI0LyDN7Jd9wrm0v+aTO8PUPo
	MNmsSO36GSOhOux8RWNyLIo0RRlAdeqg60Em8rNk3/D9YkbfKKuRGLKT57BzwZufKvmMeY8b2hh
	ztXkl3GzzdXxJsMawoGu45Jj7N8Nmt56evePQaWdTXXeiwTWWhkRTYtf9z9lfR0RGsK9uLlj70h
	iFA9MCQ6FcglG51hzpb8f8vb/cT/5Z5A+vG/YK5/u7z2z1O3Mvu8Ev6I93CEzR1rTYDv5Ds96gU
	z6CV7UFUM7V4qjsuzr0Pnk+4iFtDWla0oTigofmNDdGMa/0O1dgTBIWakCRvJQik3BthxewX2hc
	USzj0IJMHU+nyd83JJATd2wBBfHlQ==
X-Received: by 2002:a05:690c:2010:b0:794:29e6:791e with SMTP id 00721157ae682-7947ac921a1mr38503337b3.64.1769625905638;
        Wed, 28 Jan 2026 10:45:05 -0800 (PST)
Received: from unknown207bd2cf251a.attlocal.net ([2600:1700:6476:1430:32c7:2b13:eb34:a3c8])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79482767fb2sm14313737b3.6.2026.01.28.10.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 10:45:05 -0800 (PST)
Message-ID: <aae4cf37afbf84ca8ac192acccf984d10d51dc2d.camel@dubeyko.com>
Subject: Re: [LSF/MM/BPF TOPIC] Block storage copy offloading
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Bart Van Assche <bvanassche@acm.org>, "linux-block@vger.kernel.org"
	 <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	 <linux-nvme@lists.infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Slava.Dubeyko@ibm.com
Date: Wed, 28 Jan 2026 10:45:02 -0800
In-Reply-To: <6d648dab-fe05-437e-be25-6c026302322e@acm.org>
References: <0cfe6fe2-3865-4dc2-92a7-74b1240f7b63@acm.org>
	 <eab078c99e17e45632c6b35e2fe1145e9459ff2f.camel@dubeyko.com>
	 <5273400e-5cf8-4d70-a85d-accfb2977d8e@acm.org>
	 <fcd8fae5950ea5888eab5279fa3ebcad1d27bfa4.camel@dubeyko.com>
	 <6d648dab-fe05-437e-be25-6c026302322e@acm.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-01-27 at 11:11 -0800, Bart Van Assche wrote:
> On 1/27/26 10:03 AM, Viacheslav Dubeyko wrote:
> > So, frankly speaking, currently, I don't see the generic technique
> > that
> > can work for all LFS file systems.
> If I change my topic proposal such that it says "some LFS can benefit
> from copy offloading" instead of "all LFS can benefit from copy
> offloading", is that sufficient to agree?
>=20
>=20

I assume that your approach is based on suggestion of capability to
move one or several physical sectors as it is in background and, then,
correct file system metadata on new location of user data (or
metadata). So, you need to do this as part of GC operations because a
file system uses Copy-On-Write (COW) policy. This file system can be
LFS (log-structured) file system or not LFS file system. If file system
based on log concept, then we cannot simply move physical sectors as it
is because we need to extract valid blocks from the log and prepare the
new log. If we can offload this logic into storage device, then we can
use this approach for LFS file systems. Otherwise, we cannot talk about
LFS file systems. If file system uses COW policy, it has GC, but it
doesn't use the log-structured concept, then we can use the suggested
approach. Because, we can move physical sectors as it is in the
background. However, if file system uses compression or encryption,
then situation can be complicated again. Because, logical block could
be smaller than physical sector and some metadata structure needs to
keep the knowledge of the size and location of a particular logical
block. So, again, moving physical sectors as it is could move the
invalidated logical blocks.

Potentially, it needs to talk about COW policy and non-compressed/non-
encrypted data? But it limits the approach significantly. And real
business case should be ready for compression and encryption.

Thanks,
Slava.

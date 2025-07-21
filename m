Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649228C5BC
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753099498; cv=none; b=Bu1Kk3IJZzX1AWOlILeb6SIF1aMmd/KSKvNYqr3IvfUVEh291aKpcI1uDAgWQlKpU+/UbkBwN+xy1jXdyN8I0aVmKPrry+5BNRxrSUhQOcRDKrfQe3sgbPs9jcNMVVW/IstYlbdi6yomKOo47jdugV678Kp2gS/U/OYmsVfuBOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753099498; c=relaxed/simple;
	bh=AgmplPpBkqPJHRgbv/ilKQnYSL6wMtJX7Lhc35iZubw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iUzwTDWXIuJW/GWxHJPWiTr91aCUHYwmZ4+XtpfV2hVUajrWho+xc9H5woNvcBTMYis/7lndm4gox/gsuzjr1vpHfvPRxsfvEQ81DJi0pKP2GD7yzee5HNTnUqSWH3MJYS3oAahZCOUlghqQJSPbi2C4DImJYV23Ucd4bsuVbnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ty9Sb9yT; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ty9Sb9yT"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so3172611f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 05:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753099495; x=1753704295; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yFsy0N8dFit2yuYg6+8lEXnZLwOaEpoo8BHtjGWuFq8=;
        b=Ty9Sb9yTvEGhe+x2nQJ7otZm+LVhHzxmFeZiJMi1mx4cbrFQFhSkTRX2mXujpFZBDm
         GoZvGwi86N9M3oiigTLQ0b4Xef6cqHIHsCfjd6Hkx+80AA0EPTiWYk9H07sGC3xDItz+
         FeZ+oEZN3qMRDnAzl9DxmEjs3lxW8ZS01uQA22EtAk91T3I/nH/CJut4vbqO2S+tTEGu
         +DSAOt2aLsTLwFUsp7fWHluV+wkSBJB8wJWX4ntV3JSEK7E8itbCeWkNotRIpVoBCB7v
         lmjZCpoMT079EvDKplnS6ogXSSfZQsFt4CItGIaj2ul+NNX6j5C2oC0dect5mR1MLNrX
         a9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753099495; x=1753704295;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yFsy0N8dFit2yuYg6+8lEXnZLwOaEpoo8BHtjGWuFq8=;
        b=IK71smj5DfvVb1Hw1izN++W5Qk2HSWu2eZlpPl/Fbv/6Gh048FweQl3tob1VOL9Eka
         tr07TAjSgzhbQGcsffjJBUylBvsAoF9tQNtmcZWf8lXerMmeJUVCCOTY12Mme2L/cGpC
         ZV3iBzY4C4aeCyS6b5YZTAr6cYQHVvaq280Q7vCph+wr9M4maYaqJhp1CXCNo4Rdr+TF
         pKtm9w0CkWDFygPhrXJKNXxXRj1yiIFFYjPY+e3CzXmy4Hp0rzorOltQa18fOC35BK4i
         J9q7mytPynVBz0sDcPeuurBoERTAoDZzao3JwruzCd8c19mOA3yMRAqBfZdERpAONlrw
         x7PA==
X-Forwarded-Encrypted: i=1; AJvYcCX65bDhs5UwDtUbpbW7eOvUyv3Jbd5LZwsghbIY6Pyl/FVqNwxapDW2rtBemFoscHub139FZn/orsEw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw23hlw8viW7cU4Vu4K6ZbQH2/kf+wlouerEaVWzpenpZSLBhlv
	El17gzJiz2oe0uUMjTgw+B67pgPCPIdTR52uYOmNWclxfbSvn9KtAXXDgKqMziOgEpw=
X-Gm-Gg: ASbGncuBI/jVSxMhlzp/rQL6U5cfWKAmmAvQfy+P2yQGp2omQ5ZfxOBr/PRpsMDGKgL
	AWTo8m5hiyFYy0JC5ixuouGhASyAFTgJETtlmI88RQeRbezIYi5+eUd3hiZ0c9i8O+SzaKP/TW2
	hPv/UyuD/+eP6MC0bubRiGlsCHj5rnmdMkwnx3IR/PXOI9gt1+DzaxL1PhTROQ2QZQhjQJy8A3l
	oWDOj747d1LFNovVb45xNcn1c0xKp6PaorS+oPyVXjq6aKaVP0xlgz1HiQqvnnVUnaL56q7WWQU
	wFlAzpV8ySrgKaS6P6LXFsSitPz/JyFlCnGtniisytK8iQ23R8831XmykM8ohpT+8y0VvY3VC8a
	QiLVuyHUhkJ6UBzQMDTOegrib/w==
X-Google-Smtp-Source: AGHT+IGjfeFn2Z+6zri73vruVzHD1bBxX9f1u0kiaMUuw25HI377CkPNalTMB/vUfycg6NzuXJEDNg==
X-Received: by 2002:a05:6000:2385:b0:3a4:dd8e:e16d with SMTP id ffacd0b85a97d-3b60e4c2194mr16565406f8f.15.1753099495341;
        Mon, 21 Jul 2025 05:04:55 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca487a5sm10222123f8f.42.2025.07.21.05.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:04:54 -0700 (PDT)
Message-ID: <1e06161bf49a3a88c4ea2e7a406815be56114c4f.camel@linaro.org>
Subject: Re: [PATCH RFT v3 3/3] ufs: core: delegate the interrupt service
 routine to a threaded irq handler
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Neil Armstrong <neil.armstrong@linaro.org>, Alim Akhtar	
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche	 <bvanassche@acm.org>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Griffin <peter.griffin@linaro.org>,
 Will McVicker <willmcvicker@google.com>, kernel-team@android.com, Tudor
 Ambarus <tudor.ambarus@linaro.org>
Date: Mon, 21 Jul 2025 13:04:53 +0100
In-Reply-To: <20250407-topic-ufs-use-threaded-irq-v3-3-08bee980f71e@linaro.org>
References: 
	<20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org>
	 <20250407-topic-ufs-use-threaded-irq-v3-3-08bee980f71e@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+build1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

On Mon, 2025-04-07 at 12:17 +0200, Neil Armstrong wrote:
> On systems with a large number request slots and unavailable MCQ ESI,
> the current design of the interrupt handler can delay handling of
> other subsystems interrupts causing display artifacts, GPU stalls
> or system firmware requests timeouts.
>=20
> Since the interrupt routine can take quite some time, it's
> preferable to move it to a threaded handler and leave the
> hard interrupt handler wake up the threaded interrupt routine,
> the interrupt line would be masked until the processing is
> finished in the thread thanks to the IRQS_ONESHOT flag.
>=20
> When MCQ & ESI interrupts are enabled the I/O completions are now
> directly handled in the "hard" interrupt routine to keep IOPs high
> since queues handling is done in separate per-queue interrupt routines.

This patch adversely affects Pixel 6 UFS performance. It has a
UFSHCI v3.x controller I believe (and therefore probably all
devices with < v4) - if my limited understanding is correct,
MCQ & ESI are a feature of v4 controllers only.

On Pixel 6, fio reports following performance on linux-next with
this patch:

read [1] / write [2]:
   READ: bw=3D17.1MiB/s (17.9MB/s), 17.1MiB/s-17.1MiB/s (17.9MB/s-17.9MB/s)=
, io=3D684MiB (718MB), run=3D40001-40001msec
  WRITE: bw=3D20.6MiB/s (21.5MB/s), 20.6MiB/s-20.6MiB/s (21.5MB/s-21.5MB/s)=
, io=3D822MiB (862MB), run=3D40003-40003msec

With this patch reverted, performance changes back to:

read [1] / write [2]:

   READ: bw=3D19.9MiB/s (20.8MB/s), 19.9MiB/s-19.9MiB/s (20.8MB/s-20.8MB/s)=
, io=3D795MiB (833MB), run=3D40001-40001msec
  WRITE: bw=3D28.0MiB/s (29.4MB/s), 28.0MiB/s-28.0MiB/s (29.4MB/s-29.4MB/s)=
, io=3D1122MiB (1176MB), run=3D40003-40003msec

all over multiple runs.

which is a ~26% reduction for write and ~14% reduction for read.

PCBenchmark even reports performance drops of ~41%.


I don't know much about UFS at this stage, but could the code simply
check for the controller version and revert to original behaviour
if < v4? Any thoughts on such a change?


[1]: fio --name=3Drandread --rw=3Drandread --ioengine=3Dlibaio --direct=3D1=
 \
         --bs=3D4k --numjobs=3D1 --size=3D1g --ramp_time=3D10 --runtime=3D4=
0 --time_based \
         --end_fsync=3D1 --group_reporting --filename=3D/foo

[2]: fio --name=3Drandwrite --rw=3Drandwrite --ioengine=3Dlibaio --direct=
=3D1 \
         --bs=3D4k --numjobs=3D1 --size=3D1g --ramp_time=3D10 --runtime=3D4=
0 --time_based \
         --end_fsync=3D1 --group_reporting --filename=3D/foo

Cheers,
Andre'

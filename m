Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAC12D0C7E
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753099849; cv=none; b=WA1pIW2GscdjT483JzDgX+pW8wfJIsh6kY2MkH4RoLuA0eZr9v06ByaObEfLkXtgYC22yFWjHolfsMmsQ1ma0WYTjDP2tXDuv6vMNJORvd/kPWbEu/SOE+o/u7oZ0Gou4LDlBRzVnLRXmowpwv6hbHmGevZ8DHF1MFyyN02xT7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753099849; c=relaxed/simple;
	bh=n2r3B6altUPpKltXRh6LT7irfPPbs+66nbggbg37vs4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=allyts+MxUhDu1hFjd+9v1iyT0jBwuGV+tERMVOr1g2iAWX/K5TXOu0U3CdN8RT99/J8h2ejpREnkUhUf/zP7F/speIF6mTFgoA6e1IYH8PrvCvzm1wk1uGuZdl+Z7kNvTTPeUbmSJkyejjvajSsPCMk09GNNv/gY8BoVYpcQuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pZFWyXmD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pZFWyXmD"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a53359dea5so1958233f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 05:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753099845; x=1753704645; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IQGYtSjwm8ZBk8yiUr1gkmcZ3W0DPvO/dSFuH1qnolA=;
        b=pZFWyXmDMCIw1Pz54uBsxL5O/hbHgfShSMewwgV8mszkO68YOBIiYGQr3iwGZ4NwkN
         Sljvkh+yYlvET6fmkU3cV9e75o54kIoe/VrEmRkStzquFrXMvrzFHmQLykN4UAVhviJu
         LWGrdVQlio+VOe97rth/9fLisrHRgqsXPnmynWcLxNSebTBLo91L0Tnq8ga3X9Y2vlOg
         CCX4V8DAwyVjZvFWEnWu2bRQSMuywcJZBRsmiHgxR0NUHWAutAVmCyQf8kWaD44Q993V
         ZRMHAd0bYYpRy/cZt76Ul/s6NUREYHSfTOiVChiSOwj7A8HXbW8xNY1xHoEQLye2S8bS
         6hKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753099845; x=1753704645;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IQGYtSjwm8ZBk8yiUr1gkmcZ3W0DPvO/dSFuH1qnolA=;
        b=dsEHxxwvKrnqvqTiSa3TbhDZNFu2a5w32cjQNcYSyrTDfh8jxR/1+kGrY2aA3Vcv8f
         gaeEgjcXCBpjYRRxd/MGtuyFUwbl3OpoTaXPRnNOySpRB5zTXLoHezZ7wcMm7BuEEytI
         ZACQ+DGqAP/NeLLCClR96PZVvevrirGLgzPBCWV60KhHcv0nDscgmQ1oW+ELRhjguykp
         zObrF9sbw/WwkGUL3GN0Qumg2t2gpb7x1KC7g58d0qDEM22VvpKYpZxAzhZQnoV8t0bd
         0kRm622QFSnkIxpGay7TR5FGdB7qi1iAQ50grEYnXHheMwUdNWV7JCTxmL2+dKzH906P
         Uujg==
X-Forwarded-Encrypted: i=1; AJvYcCWBiUbL1lj0yUTV4ISMbNSYd5NuROaQkg1yeHGBvwbR6UhY2NFapSlwjSyDYhQGJHLOMlQv+7l6M9Qd@vger.kernel.org
X-Gm-Message-State: AOJu0YyHFZZkVjHoY5PS0SQ7HUba8zBv22utAFPMa2MBcqYFYvQtRPHb
	KYe4jyJITvAkbgEbaiVTaFDmINGm8Sjgvp33Hd1AmL5yCN5qmojJG/mrAqYHJIx99vw=
X-Gm-Gg: ASbGncuCbWbQLW0HWf6M5hZ6Kbl/QZzyp/MfGLSff5edZtq34MhJR8CAN7aCdLwMfUF
	vjq19eSJpuOoSQOVHRVuOLmdaxlXc7ULU6MSBWpOoJm24knl4izV2ChU7fKWpXzFTOzpLSN0+CE
	1zhvK/DTkZ/J/entFmSwnfL2r9rlOcFHwhFIczXRr92dvuaGXf9qS4n5I2lXj8KPiRQIaNyYNHH
	oInezuD1MawW0UfQMvGi5wW/cfRWHLrNoMEuUj+r7jD+KinqkUpEa5mvsRVAlSQtHubai2B4cyX
	W28epdQNyEVbkKtZGMTcjyH//OLHV21C2GZmXHP6NR76aKLeQjNZX/aUy3cbz7JQJ8Pr4tu7fgC
	98q2MCbz4BauLQOom7BVFvgrpfA==
X-Google-Smtp-Source: AGHT+IFC0ohH6DhVvOUrM3tqnXguszZ6/TVXCACeW4yApUHn6usADv/+L6MBPOWG7pJVIWX8OuqrJw==
X-Received: by 2002:a05:6000:2c12:b0:3b4:9721:2b16 with SMTP id ffacd0b85a97d-3b60e523deamr17084415f8f.36.1753099845431;
        Mon, 21 Jul 2025 05:10:45 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d95esm10266983f8f.75.2025.07.21.05.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:10:44 -0700 (PDT)
Message-ID: <4935395591bc8baef39d2acc491c6c40889090d9.camel@linaro.org>
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
Date: Mon, 21 Jul 2025 13:10:43 +0100
In-Reply-To: <1e06161bf49a3a88c4ea2e7a406815be56114c4f.camel@linaro.org>
References: 
	<20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org>
		 <20250407-topic-ufs-use-threaded-irq-v3-3-08bee980f71e@linaro.org>
	 <1e06161bf49a3a88c4ea2e7a406815be56114c4f.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+build1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-07-21 at 13:04 +0100, Andr=C3=A9 Draszik wrote:
> Hi,
>=20
> On Mon, 2025-04-07 at 12:17 +0200, Neil Armstrong wrote:
> > On systems with a large number request slots and unavailable MCQ ESI,
> > the current design of the interrupt handler can delay handling of
> > other subsystems interrupts causing display artifacts, GPU stalls
> > or system firmware requests timeouts.
> >=20
> > Since the interrupt routine can take quite some time, it's
> > preferable to move it to a threaded handler and leave the
> > hard interrupt handler wake up the threaded interrupt routine,
> > the interrupt line would be masked until the processing is
> > finished in the thread thanks to the IRQS_ONESHOT flag.
> >=20
> > When MCQ & ESI interrupts are enabled the I/O completions are now
> > directly handled in the "hard" interrupt routine to keep IOPs high
> > since queues handling is done in separate per-queue interrupt routines.
>=20
> This patch adversely affects Pixel 6 UFS performance. It has a
> UFSHCI v3.x controller I believe (and therefore probably all
> devices with < v4) - if my limited understanding is correct,
> MCQ & ESI are a feature of v4 controllers only.
>=20
> On Pixel 6, fio reports following performance on linux-next with
> this patch:
>=20
> read [1] / write [2]:
> =C2=A0=C2=A0 READ: bw=3D17.1MiB/s (17.9MB/s), 17.1MiB/s-17.1MiB/s (17.9MB=
/s-17.9MB/s), io=3D684MiB (718MB), run=3D40001-40001msec
> =C2=A0 WRITE: bw=3D20.6MiB/s (21.5MB/s), 20.6MiB/s-20.6MiB/s (21.5MB/s-21=
.5MB/s), io=3D822MiB (862MB), run=3D40003-40003msec
>=20
> With this patch reverted, performance changes back to:
>=20
> read [1] / write [2]:
>=20
> =C2=A0=C2=A0 READ: bw=3D19.9MiB/s (20.8MB/s), 19.9MiB/s-19.9MiB/s (20.8MB=
/s-20.8MB/s), io=3D795MiB (833MB), run=3D40001-40001msec
> =C2=A0 WRITE: bw=3D28.0MiB/s (29.4MB/s), 28.0MiB/s-28.0MiB/s (29.4MB/s-29=
.4MB/s), io=3D1122MiB (1176MB), run=3D40003-40003msec
>=20
> all over multiple runs.
>=20
> which is a ~26% reduction for write and ~14% reduction for read.
>=20
> PCBenchmark even reports performance drops of ~41%.

Additional fio results (numjobs=3D8 instead of 1):

current linux-next:

fio --name=3Drandread --rw=3Drandread --ioengine=3Dlibaio --direct=3D1 --bs=
=3D4k --numjobs=3D8 --size=3D1g --runtime=3D30 --time_based --end_fsync=3D1=
 --
group_reporting --filename=3D/foo
   READ: bw=3D52.1MiB/s (54.6MB/s), 52.1MiB/s-52.1MiB/s (54.6MB/s-54.6MB/s)=
, io=3D1562MiB (1638MB), run=3D30001-30001msec
  WRITE: bw=3D74.7MiB/s (78.3MB/s), 74.7MiB/s-74.7MiB/s (78.3MB/s-78.3MB/s)=
, io=3D2242MiB (2351MB), run=3D30004-30004msec


with patch reverted:

fio --name=3Drandread --rw=3Drandread --ioengine=3Dlibaio --direct=3D1 --bs=
=3D4k --numjobs=3D8 --size=3D1g --runtime=3D30 --time_based --end_fsync=3D1=
 --
group_reporting --filename=3D/foo
   READ: bw=3D83.5MiB/s (87.6MB/s), 83.5MiB/s-83.5MiB/s (87.6MB/s-87.6MB/s)=
, io=3D2506MiB (2628MB), run=3D30001-30001msec
  WRITE: bw=3D83.3MiB/s (87.4MB/s), 83.3MiB/s-83.3MiB/s (87.4MB/s-87.4MB/s)=
, io=3D2501MiB (2622MB), run=3D30003-30003msec



which is an even higher 37% reduction for read.

A.

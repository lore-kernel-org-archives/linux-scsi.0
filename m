Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7F1531D2
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730362804; cv=none; b=Mg3r+eFo0/8HJ9nQrFM3lqWCxClL3gfl41yZlkdKHOkJrCBNRidhnlJUsKifdT+VRMfKtBt0fE0FsLhGidxZcZCW85XffMijDblEinWHMB+2NWn7bD3Yz3rYkTz0ZyLZcI457R2C9QhteIhiwheJgccUmo5EeHNHpTDI6qKWhpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730362804; c=relaxed/simple;
	bh=CX8S5Y9npSRGCV5zzlSrljLQ2sJgae3kpGxmZLzONUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GsecDgkWMEvmaHrncXAaTBxIKEgDycgLHUqJOgMtWgMr8xqopbpcW+KAFWeaaN11awAUc2apDd68qKaQN8tOdBwcqjTJtkW0R8VDlVatw/KBOk/Jzac77CC96rnX9xT+RgjGoPlzOPWlCjLrvzmbNhAFMfLhbvATSqC9KEbWmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com; spf=none smtp.mailfrom=owltronix.com; dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b=IvbfBnAp; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b="IvbfBnAp"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so985956a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 01:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20230601.gappssmtp.com; s=20230601; t=1730362800; x=1730967600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHihNpINELIVjK3l3rTKLlYaMgvUEcgArJNIc8J5kNA=;
        b=IvbfBnApArGei0oWtsKAVEQG7VN+j4k7cjcjTAljywxgnGUC21T9V6QusjJWA3dt6I
         VrXhYiqpPum6wLLZDFVlf0zkIFU+v+pazOyV09JB6bgxo84wXzWapcahqdFZlKg93ogP
         UiKP7hq6tcPL0cWefutUKOo6HddaoS1mlBmJPMziW6i+/NBk5FDKKnogYyw87CkPxjdH
         0Si/EAGAQ5vjveNofRNgnsIqf1ZQBXTLGxau/Dh+9eRKVnC9wwN2mx8grS1P+Euy+7E5
         H/fSDBOvpigv2t60Hvsbum6EqrOZt1lOUf0nW2IWLltzZmWydrOWrPquA3dvfSKnDnzK
         q0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730362800; x=1730967600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHihNpINELIVjK3l3rTKLlYaMgvUEcgArJNIc8J5kNA=;
        b=FUUAkA+KPl9kn+SdteDm8VKbqul+HFNBooBoWamik30ri9XKZYd20zeOvxUBuEWMsv
         EV6S7x7hbhoHHzoAgxxHFTE2ZZftzOEezFavI3UGFC2BlVTE54uhdfQCNYOPqGMxmHiL
         lRJzYmO/GnWSgb1zj4ZEfLCxpfb8EtqbBB6Ml04xAG0O1z0Q2YubRXyJ1bEG4o3DQ/bu
         LW6UjKeoV86nHHI1VOUYslPq1+ff5D5AamDio1wzSutgIRs85GphQzv+vokdrmC0AVDh
         rDw6we81Q5GEM9JG8COxQT5fc2JmVRbY5A++EzqnFQXXbF/6FPqW4SIv4Tax6ja3uhRA
         3pUA==
X-Forwarded-Encrypted: i=1; AJvYcCVIYuYEA6uB3KglJq5LyopyOjv/Bh3e62BfTCX+zbk6SnwfQY6+2vMy/dvocaXUTqFgL+iP+tsuLbv/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy64hvnKltBz5lQtDc1XoJgYosvtenjaPZr31J/6tE8QTNojh/Q
	VW7ZoCuZWr68HfWlWqZt43xWFaCKSJn7BEZI9u7zrnwanby2ZIWJ7Dqpx0+VFy8VQTn45YJoCKM
	0S0b+wpOOo7fGiIgGvvlXWZvg9WfWajXg01ssgQ==
X-Google-Smtp-Source: AGHT+IH8+r7Wg2Co4/bqHDcfHF1OtsjwdU/NhWvyCsNdTstwhoydYvHp6WgT8/ZbDKKPHXfyJqAdxDuKmLBM29l3xGo=
X-Received: by 2002:a05:6402:13c7:b0:5c9:547d:99 with SMTP id
 4fb4d7f45d1cf-5cbbf889742mr15743282a12.2.1730362800416; Thu, 31 Oct 2024
 01:20:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com> <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com> <20241030165708.GA11009@lst.de>
 <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
From: Hans Holmberg <hans@owltronix.com>
Date: Thu, 31 Oct 2024 09:19:51 +0100
Message-ID: <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, 
	javier.gonz@samsung.com, bvanassche@acm.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 11:33=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Wed, Oct 30, 2024 at 05:57:08PM +0100, Christoph Hellwig wrote:
> > On Wed, Oct 30, 2024 at 10:42:59AM -0600, Keith Busch wrote:
> > > With FDP (with some minor rocksdb changes):
> > >
> > > WAF:        1.67
> > > IOPS:       1547
> > > READ LAT:   1978us
> > > UPDATE LAT: 2267us
> >
> > Compared to the Numbers Hans presented at Plumbers for the Zoned XFS co=
de,
> > which should work just fine with FDP IFF we exposed real write streams,
> > which roughly double read nad wirte IOPS and reduce the WAF to almost
> > 1 this doesn't look too spectacular to be honest, but it sure it someth=
ing.
>
> Hold up... I absolutely appreciate the work Hans is and has done. But
> are you talking about this talk?
>
> https://lpc.events/event/18/contributions/1822/attachments/1464/3105/Zone=
d%20XFS%20LPC%20Zoned%20MC%202024%20V1.pdf
>
> That is very much apples-to-oranges. The B+ isn't on the same device
> being evaluated for WAF, where this has all that mixed in. I think the
> results are pretty good, all things considered.

No. The meta data IO is just 0.1% of all writes, so that we use a
separate device for that in the benchmark really does not matter.

Since we can achieve a WAF of ~1 for RocksDB on flash, why should we
be content with another 67% of unwanted device side writes on top of
that?

It's of course impossible to compare your benchmark figures and mine
directly since we are using different devices, but hey, we definitely
have an opportunity here to make significant gains for FDP if we just
provide the right kernel interfaces.

Why shouldn't we expose the hardware in a way that enables the users
to make the most out of it?

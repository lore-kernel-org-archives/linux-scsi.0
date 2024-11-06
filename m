Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84385201256
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 14:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903200; cv=none; b=VObezg8+PkKP1/7xPsuTVFVCCNyNVeFd+WiUyMIUtD3yOIGotn0KyDNCB95u8gp96i7MIV16552rJ0J7xrwEVaNj3OabcpFaYjIfjaTygwoQyU72XpmyJjeXRKnYlH9ICFpt4+Jb21VXDs+wUgEqjMdPJiBfX+4L3jrlMupLV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903200; c=relaxed/simple;
	bh=ipqB5GhZfhZeP6+Fw73KMpW7vTqNOHY4wT9od9XDnNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HU7TLHq9E8OtSEuzZig3797UoF/AxVhraWLERVKKq1y+6kvvCTRS4uww0NhkETcNfLTOnCaz4z9orz7V7XB6T3Mzn4zLQPUDO3TdBY+IdaUPoNwbn+/T+6lDA2VNnE/AXodLFf9Uy303Ar3M4CtOYDagQeChis/pMclulnU1T5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com; spf=none smtp.mailfrom=owltronix.com; dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b=K0ELk7ZO; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b="K0ELk7ZO"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a0c7abaa6so792934766b.2
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 06:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20230601.gappssmtp.com; s=20230601; t=1730903197; x=1731507997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipqB5GhZfhZeP6+Fw73KMpW7vTqNOHY4wT9od9XDnNU=;
        b=K0ELk7ZOqojBpwfYYFVtlhrgVqwWO9F5XOz+slzrpH7whuThi5sFINpU1Uz2YObfRL
         RdopoaQbBe9AIueM/xK9qkRcpHa4xbkp9sQ1ZgrPkDzzmE6dLuYVXBoLaa6zn4ZF0Por
         aMkFouowSW3zErpN1orbPemdy6YLrb8rvl6H36Mru773Dx3Alieh0RZkjYs3iM53nH21
         8dKWaSlRjYHBC2QXhw1BILFPGFrs3nbW/kufRc7QIZUFCc7FI/o1OFoXFUAe2c9bWdp/
         qg5rqdNPPloEYVDahsor2ScfawUvljWuiK9BhvMKOazWXD1ys8NY8ELcl7iP6fOW5snV
         Y5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730903197; x=1731507997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipqB5GhZfhZeP6+Fw73KMpW7vTqNOHY4wT9od9XDnNU=;
        b=sA7L34NAGmp5wTaf4H2FwNAJSo76jMwAkI2hqMJti8dGWRgPurC31UXZ6BSETG8K57
         a8zth26QrxndHPxkRfPlSAYQOrTuvMFK1SODjK6x5+Fy4swZa8wSD3sPj8E9dxjWm9Nu
         WkuMBo7LVhYtP/R0gO3zZPHInDPsRaGpuSPrEZ7E4o7vXfeBjt5y//fBNOR6nnhbfzrv
         4IFDdEnY1BczSNaWiVidibzTNxOsdGizYHq7WEeHMb/aaGwa9Vvo+beIooKSdy4hj/bC
         Chj6CFCHyEhjm3W7hXtEB5q/YRnHdg7+Ae17+ARKdEReuqwIvd7efwG55EsVQC99mr52
         zyHw==
X-Forwarded-Encrypted: i=1; AJvYcCUzZ6p68AumcEq6Xyr+ZvpS/ENa1UmQdxyo9vohoFv/NE6aryFNBv+nfjLXet7+ZhD0AeX8gRSu2H05@vger.kernel.org
X-Gm-Message-State: AOJu0YwUxxJpsG8STLQSecDbXhSJvuwlkOg5CvXBOCPom/U8wwpBi13o
	lzVdx5INHOTw+1A/S2TckGPcuZZZVduxCqgxmyi2Fwm574vlHXpo76cxHSFI2BpYoe69KQ4Kaf0
	+hRlkrawg6FaCqiXXjT0KTPmeTDJOIkOO2CN7fw==
X-Google-Smtp-Source: AGHT+IGTNjawymGmZtRv6kzFPFouB6jfAmX0w1MWjwjaaSmC15ADSV9RR263VUeTaevgARYiFWCXry3+rk2bBInzbBw=
X-Received: by 2002:a17:907:2dac:b0:a99:6791:5449 with SMTP id
 a640c23a62f3a-a9e6587df7fmr2121988466b.52.1730903196776; Wed, 06 Nov 2024
 06:26:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de> <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
 <20241030155052.GA4984@lst.de> <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
 <20241030165708.GA11009@lst.de> <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
 <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
 <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com> <CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>
 <ZyTqZ3UR39VTHSA2@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <ZyTqZ3UR39VTHSA2@kbusch-mbp.dhcp.thefacebook.com>
From: Hans Holmberg <hans@owltronix.com>
Date: Wed, 6 Nov 2024 15:26:25 +0100
Message-ID: <CANr-nt0stXUn38EawwQPa+fGmgvHE7Ch8LH7tGyNp5NPpm1m0w@mail.gmail.com>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, 
	javier.gonz@samsung.com, bvanassche@acm.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 3:49=E2=80=AFPM Keith Busch <kbusch@kernel.org> wrot=
e:
>
> On Fri, Nov 01, 2024 at 08:16:30AM +0100, Hans Holmberg wrote:
> > On Thu, Oct 31, 2024 at 3:06=E2=80=AFPM Keith Busch <kbusch@kernel.org>=
 wrote:
> > > On Thu, Oct 31, 2024 at 09:19:51AM +0100, Hans Holmberg wrote:
> > > > No. The meta data IO is just 0.1% of all writes, so that we use a
> > > > separate device for that in the benchmark really does not matter.
> > >
> > > It's very little spatially, but they overwrite differently than other
> > > data, creating many small holes in large erase blocks.
> >
> > I don't really get how this could influence anything significantly.(If =
at all).
>
> Fill your filesystem to near capacity, then continue using it for a few
> months. While the filesystem will report some available space, there
> may not be many good blocks available to erase. Maybe.

For *this* benchmark workload, the metadata io is such a tiny fraction
so I doubt the impact on wa could be measured.
I completely agree it's a good idea to separate metadata from data
blocks in general. It is actually a good reason for letting the file
system control write stream allocation for all blocks :)

> > I believe it would be worthwhile to prototype active fdp data
> > placement in xfs and evaluate it. Happy to help out with that.
>
> When are we allowed to conclude evaluation? We have benefits my
> customers want on well tested kernels, and wish to proceed now.

Christoph has now wired up prototype support for FDP on top of the
xfs-rt-zoned work + this patch set, and I have had time to look over
it and started doing some testing on HW.
In addition to the FDP support, metadata can also be stored on the
same block device as the data.

Now that all placement handles are available, we can use the full data
separation capabilities of the underlying storage, so that's good.
We can map out the placement handles to different write streams much
like we assign open zones for zoned storage and this opens up for
supporting data placement heuristics for a wider range use cases (not
just the RocksDB use case discussed here).

The big pieces that are missing from the FDP plumbing as I see it is
the ability to read reclaim unit size and syncing up the remaining
capacity of the placement units with the file system allocation
groups, but I guess that can be added later.

I've started benchmarking on the hardware I have at hand, iterating on
a good workload configuration. It will take some time to get to some
robust write amp measurements since the drives are very big and
require a painfully long warmup time.

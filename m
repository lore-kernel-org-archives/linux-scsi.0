Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAAB3D6491
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776243508; cv=pass; b=TzXNdAgXoOVixGRj1M9WE/gH0LLhbDLAe1ADT9xzdku96OpaHqca/LzL2OgmM6i0IxWAK/rud/xaP5jatz9rnxrwrPpU3+W5MdpBURPJJ37why3Mp/VO7VbBNhbweGxXEmh2H444jUtDiNva9SphdaiumWjTCZYrwTtCWEabdbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776243508; c=relaxed/simple;
	bh=NmZn8YaVwP7ozh9+ymcLzBd4heHiFWdC0pHFeYEhGzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RGhuvD1tiFsW1q+mxPJCUnWRfSXFMYYMQNZVtKa7sss3RBkUuVh1nYWsZTMgoS4uMQoxeuZ8JDW8eYFOtkqrTlPiUZkYeVwsURg3X+pH1DQJdrZNUbhBX5VKfA0tazHowvyRLQHWTlSOPUvETaiijyZjO3MyvUchWNhRBbLCFZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiUPt9CS; arc=pass smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiUPt9CS"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-47952229034so2001740b6e.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 01:58:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776243506; cv=none;
        d=google.com; s=arc-20240605;
        b=P4G1XiDybmcHUKBqvgdalW4RRy1Z62znfTwg7zjayTibGPfP5Ut0vu68okt0BwGLCf
         p4DBXNUd7816irapP5X9qse4W6T8qmPmSTzUHKIYnBMeFrUtm9ljYWKX56b3p2TWN10U
         g06041EqHt47OeJ0IkN1ibkoLnH3+xIEafERrwgPsube1o+uwyUU+jchTfEnry1e5/tp
         5dQGiGpy64w/vPJD30MYgEUoLvkokrjJD4u2m2M1BgzkkCHWnTl4z//wA5LTVZh09gte
         CYAHV7ws4S3QK7IEIfIN6ccPrSHLLulYG4BIIgh2HfFgqsscgOH/9wJ16rh0/xIjwwr8
         Ma9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NmZn8YaVwP7ozh9+ymcLzBd4heHiFWdC0pHFeYEhGzA=;
        fh=JFZy3CmHcpDXV3BWyXr43wY7HVzRLIkw7gPZIFvEPhM=;
        b=cuJieX3yj8RXskJk8jfO4Gzf0Xz3YLmwX6waTbRrKmwcWzrtQBu+ru6q0KvyLVuVAe
         FGk0jCUdJvhRs2ZT5M+4ym4bqTlg2EouThxghTE5Wo+2EkWzKm2vXBc8vzsta6WcK+W5
         gQWRyCfCKEX792tkXkku1EofnpDKohRLr/il7Ih7vyZgMdyjVjDlogWWpmrYRD5Y836/
         rSy7u65T5H6kKThsNaIrF+FuNBbLN4GDLe4UMFMukrB/bh0ibfHXH8YEo7DWGa26rnE3
         3JIduWhuKNl4tHEDluqb9tmaG5opMgFaTrZT+oHyxaI9BQXeC2RquKs2vdeUjBcQipZb
         zlUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776243506; x=1776848306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmZn8YaVwP7ozh9+ymcLzBd4heHiFWdC0pHFeYEhGzA=;
        b=UiUPt9CSQKWVfDF5vSnsZ26CXWIcvyyKj/UN3qAwB0mKS8FL6WyTdf4hW+59Hw2F5J
         XlAoQi3UNj6LXVdhkLurd1F78Ypy7SuiCHowYci5ZKo2/IfdZIE4V7ZqnSnaX8N7q6Ao
         rkSE56TTCPIc27+7QpbOx4vcP2cee8V+2K/OTbSBSnF19GgiN8npX1xtMNqvjpGyGBxE
         fdFHBui+H9NXExzW8IzAmTiIqp2GSXZA/Lti77acnN2z+2LPCuMzSzyYRS4fVgjuFzmH
         phDCuhML6PZSdfKEwSJl1q6Jl58u60ewAtealQJqEgbLX3uXPPFYla0DwsMZXNfMJigM
         x7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776243506; x=1776848306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NmZn8YaVwP7ozh9+ymcLzBd4heHiFWdC0pHFeYEhGzA=;
        b=M7RiUnCzDfjuiE2Psd6gwnL6ktDg3z8PXk8GJYnSZlvfMFm3rt7OK2o/alp+btpOWg
         tX/eIFtpV8Abt/1BuPwUKKYUDalV+IJc3WPDU+TuCBrIQT5AyMF244+xCc8RB4FIefS1
         r7LullBIa85d2dAN2eJ3A+nC87b0E9B8nQaj/XY91dQwrmI+Jr6qy4B26Kvc08AGEx7r
         s2aDLWqbwVJwpaAVMLlKOFEOpc6zCMg63zNp/XFnLk1UQeutAo0+mzo6dzUeHy/B7Fuk
         CTrBUcfCD22KK/r0WERjUa3RzJ948D5BIu7pkagMghY1rqutYIfLw9UvRCa04sEgH9Dg
         uebw==
X-Forwarded-Encrypted: i=1; AFNElJ+ah+U7ITJpNgTp4SB33dCJxnv6ubA4QHN9brU7j+D4kU+5WtHJMNFmP7hsh1ZHf8W4V10MPJ7JhyHt@vger.kernel.org
X-Gm-Message-State: AOJu0YwMjPE+R7b+WiH9n4Z1sQWAVw5swN3gjFndp6Qn6+cZCXdbYNvj
	sll+p7B9eiJbUbDp61ACl5U2uIBiQkFIQ7LbFvLcOQUzI4n3n4EpI/4dA7b56/K97acw6WmoTva
	9cfcyPft1h3QWKMMQd0xG54zyCD4xnGY=
X-Gm-Gg: AeBDietgIqM/2VvO6dmyMLeQAd+xXCw+x0efdO1OSnQ1ORc/frbQYE/aRgemWfeCzJ8
	eC6AaHTyT9WzFPc7F5CCFRjYQ0hTtdRjz3nPexOzZ/f80mVNVEZWL0FVs8DY/EIsFYpptYwwSt/
	Lygf21T/8oN3hYllt8WU+DHTh98f+aFiWTwYMH5OO/NBU0+2PJKCSmduxTApQqasfwk+g5shQ0m
	isu9N2ikqai/zaGoHF6WpprX1WxALsEBdTmbGfz7cprm5qYKQ4JatYgN4AVtN5fpS2JzCRj0F8K
	V1fXCMmNaeOZVwGFr/2PK0JhD+ELo3kCH2hBOS0kiw==
X-Received: by 2002:a05:6808:c162:b0:467:91:fb26 with SMTP id
 5614622812f47-4789f111a6dmr9948231b6e.37.1776243505664; Wed, 15 Apr 2026
 01:58:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora> <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora> <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora> <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
 <ad0Hk48y5JEeMlFk@fedora> <20260415083458.UD3cF5IQ@linutronix.de>
In-Reply-To: <20260415083458.UD3cF5IQ@linutronix.de>
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 15 Apr 2026 16:58:14 +0800
X-Gm-Features: AQROBzBesZ1I4COKhVLm4yVWD97BVXXbWvhA1t-bSTLWqOPST2qVCo792OkUIh8
Message-ID: <CACVXFVMPO_JZMSbELnsKzUpXZ7M1sF7cHETUtdqEFT73gn9shA@mail.gmail.com>
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Aaron Tomlin <atomlin@atomlin.com>, Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, 
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, mst@redhat.com, 
	aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, 
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, 
	shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com, 
	sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, 
	longman@redhat.com, chenridong@huawei.com, hare@suse.de, kch@nvidia.com, 
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 4:35=E2=80=AFPM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2026-04-13 23:11:15 [+0800], Ming Lei wrote:
> > > > What matters is that IO won't interrupt isolated CPU.
> > >
> > > The isolcpus=3Dmanaged_irq acts as a "best effort" avoidance algorith=
m rather
> > > than a strict, unbreakable constraint. This is indicated in the propo=
sed
> > > changes to Documentation/core-api/irq/managed_irq.rst [1].
> >
> > Yes, it is "best effort", but isolated cpu is only take as effective CP=
U
> > for the hw queue's irq iff all others are offline. Which is just fine f=
or typical
> > use cases, in which IO isn't submitted from isolated CPU.
>
> Couldn't we tackle this by limiting the number of managed interrupts the
> device asks for and then limiting the CPUs it could be bound to?
>
> So if have house keeping CPUs 0/1 and isolated 2-63 then managed_irq=3D i=
s
> futile since it use 64 interrupts and map each to one CPU. Even if the
> device supports less it would map them evenly across available CPUs.
>
> If the user wishes to initiate I/O from all CPUs but not be bother by
> interrupts we could limit the device to ask for 2 interrupts instead of
> 64 (with the consequence of more queue sharing) and then limit those two
> interrupts to CPU 0 and 1 instead to CPU 0-31 and 32-63 like it would be
> now the case.
>
> Wouldn't that be what the io_queue flag tries to do?

Yes, that is why I call it one optimization, however it does introduce
cost of CPU offline failure, please see patch 11.

Thanks,
Ming Lei

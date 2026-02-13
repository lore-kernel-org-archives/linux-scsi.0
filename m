Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F47260D
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 14:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770992334; cv=pass; b=Ay5u+Ss/Dr5LDwWLjTXu+GbOzYRRV7tN/iOlikZt6wnH5DjfnR9YQp4VfCw9ubvjMJirSwNHtT1X9cGFPZXIHImxsSL/vamHehS5TbNLBTbUxss4nqybpiqUnMA1CuDcCsbZqtR6C5IBat/K5LLhIcNWUrf9IvyQS51E95bcvj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770992334; c=relaxed/simple;
	bh=Ha0e4einRl3gVJ7lhbitIv1TiCEvi7y86FMnr1d+VD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OjiF/DeWZMfK+xp4/7nb4fAqraxFXfusg3Fy0Wbeo+0o9lc6OoGkFpL6n5dE8x7kEmCrpfCnSMbcDHimRRFS3TTsQheL8G1X95+kg5esbKL0gGrd8K1blpGWqIVhPWrnva2kPvoEePa7akBx87KSXE/9XylEttnBeohS+H+F3JU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=HwCxI9eK; arc=pass smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="HwCxI9eK"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-38707d4c8b9so8946741fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 06:18:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770992331; cv=none;
        d=google.com; s=arc-20240605;
        b=ADsGmrZWFWovLxoqkQemC/KzBw7uHydY9qcPnCAMiH1BdUsZHvAnGcj4+EI3LHie1F
         SeiiZQLlxlo7G84qB+Gby3nDm3lYozBCDhPdWwN15BUq8qBxPwnW/aKqzXSBk0VEZMAo
         JbntPVGOOqzd8RLRIPwd6PN+X9Fh7544yI3xjtAYTaTVxOanDeSOE9xRov7sAkstNTFf
         dXr90nfZYvpJLJmP4+5G5GF3jVbRqj+PRvJk5qADvZd/U5Do65WVEiyp2640m9WRnl2k
         3fkDF9kWAhIv+Bxhg/j1yyjWYdO2mcPf48OsaXdf5c5BlbITmP/mcQokXn8TrpypMEaR
         O5FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PPZ5UjJXZiG/dIIj7T0/FHqJccKNEyOB/oHBxQ8dlL8=;
        fh=yjzCDGxDhqrTanwUBZ5gWpcirWbqTmbvh9y0kN3/yI0=;
        b=PgR3Jp6QNpBfK0PfO9MQVckTswEYizQYxcn0tGV26i7rc4P+fjcnwf8z71naAOAK6P
         JEdiVznYnlmH9CPu6Sq16UL5R0cIH0geQlO2bLrRDzLq+MI64MhhpSYs93yB+2PDbbiv
         zqVlNvMEtCPzcWKrAsXTPinKMpf6Qo4cdtZRwQKhXyPy4/9zJnNHJ2L+2kUxy7dCO1m1
         n1xZwInvXluCx8ft7+7dZRrtLxMi6rX1O2BtZ3ycc3jdoxu1SGWH3HH0cXVrgqNR0MZN
         JX7qh0504Iomaklmo+m7+x133p2xJ8EgHoTgEaYPaUTHTzA5WDpJi+F3SGxkjjlChZgd
         HNyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1770992331; x=1771597131; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPZ5UjJXZiG/dIIj7T0/FHqJccKNEyOB/oHBxQ8dlL8=;
        b=HwCxI9eKLLHVxIfM5mr0TCpepOyc3HQMEeqhJj3ekauYTRhlSf+qm9qOEJmwpTLCCG
         Dp4q8eImGfN3tyj104lq8omX9sIEn1ic/AWo+2qme4IVMpnAUOwnAbuYrn3BTKNa288M
         cu4Ngx51+wo40DOMyAQr5UshLfo665ku642jd/dsOKrPWvrMpnYmPak6Gl0ESCS3rCca
         cR79y2ney5yvp41NmA9tAockBu77wQ1f0LgirGtgNredrXWqgCl6S6E4SJzhFIRGaf0V
         JJHs3G9pIbVHNd3ZwM4PtOP+pkGAonixNcNnfxiuRLDIeD2H+fSC7IuO4obH/3kQFaYm
         KfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770992331; x=1771597131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PPZ5UjJXZiG/dIIj7T0/FHqJccKNEyOB/oHBxQ8dlL8=;
        b=eExHa6Zetdj7L5mAwPeWgGcCPBith3+LdHrVA9MfNNhmvDfAu4ZQMNMttHyvW2gE+z
         QFIdSRqKnIcA0vC0DpuCK+IkDa+QasI//LfzHj6CYxVFpUn8D0nmZxRJSyqN0vLGTx/v
         J1NoNQZ4J/F3vSkvkYNpLNqsWpF4ehb08E8u5U/DRG68AgR4KsOxhYbJ8oa6M+hV6SrK
         Zt2K2uhbEQux1JZgOl9T0FavvENMRkXFhIE82Fi2vMrey6odG2OOY9kZqpvyVeB76aGp
         R2yoCGEJc0566L+IC3uf4KAMqRFH6LVJO0s5gCbs72b/slUP9HHrRT7ZF097W8yUv3wv
         wL7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVmJJrkXjey0xuKtkZRhoH29RjAb/VddQAOF1eaXZAiy9PAi13STc0I+jAM33Q8wMMWHZz531nV92sg@vger.kernel.org
X-Gm-Message-State: AOJu0YxG+lOdcnivfXxiQbPo8qFmfEUdK6SKymX2y7JCmS4o00tF6Baz
	DDYAqkFiyfaqiwGbwSe66VqJg1gmCnEYfteLwnNBjaUTyidMQLnxLMzxaGofjU5tBwRYJ0TjJM8
	slJndhhGyEeXegDgLKC1cFHskbg6yghfAvCLjkPrLPQ==
X-Gm-Gg: AZuq6aI1yOHmcnanKgEDs7Aw9HRPjKs5b10/iIy+F+i1/kQTBx0dC19MbU9JZAVaivc
	bzKvIxq7adlQibFbXTNFpeE4Q30AjRherrH+WYBPcn9gDZZ17S4iwDau4BKUav+3MbsDvm2R12z
	cY87DC9jjew530tSJZf1yIJZYZePjhlkcUBBHFg+9KTI0PX+mHprixeb7yDuJLvr6zkpIiC+hQU
	6LRELUgCis+qUZ5hZU7m6BeakiqFA+R7g4pY15Jh0qNAxzkKH6cuUaTHlhrv1xLsNgeDDfYEiKa
	NrcbGF52Jfazxe9l8TJ64sVxXxUPz9/SAVHDLMcvxv7iOvb7dRoWBYYlv7ZOQe+BnWvQy99qh/e
	WttM=
X-Received: by 2002:a05:651c:f17:b0:387:1c06:f744 with SMTP id
 38308e7fff4ca-3881054c449mr6460791fa.23.1770992330706; Fri, 13 Feb 2026
 06:18:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local> <aY77ogf5nATlJUg_@shinmob>
In-Reply-To: <aY77ogf5nATlJUg_@shinmob>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Fri, 13 Feb 2026 15:18:39 +0100
X-Gm-Features: AZwV_QiMQawRDF7MErqQBuWp-MuhZWG8Dupe7ZsjeFBjsuqumHNHXRrm7OHAk1I
Message-ID: <CAJpMwyi7-g0Oh2aJHQcrbf4zQN-2Z9oGBCDRdQbt4drQKqUN7Q@mail.gmail.com>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Daniel Wagner <dwagner@suse.de>, Chaitanya Kulkarni <chaitanyak@nvidia.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Christian Brauner <brauner@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>, 
	"willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz" <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 13, 2026 at 12:25=E2=80=AFPM Shinichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> On Feb 12, 2026 / 08:52, Daniel Wagner wrote:
> > On Wed, Feb 11, 2026 at 08:35:30PM +0000, Chaitanya Kulkarni wrote:
> > >    For the storage track at LSFMMBPF2026, I propose a session dedicat=
ed to
> > >    blktests to discuss expansion plan and CI integration progress.

I am interested in this topic.

> >
> > Thanks for proposing this topic.
>
> Chaitanya, my thank also goes to you.
>
> > Just a few random topics which come to mind we could discuss:
> >
> > - blktests has gain a bit of traction and some folks run on regular
> >   basis these tests. Can we gather feedback from them, what is working
> >   good, what is not? Are there feature wishes?
>
> Good topic, I also would like to hear about it.
>
> FYI, from the past LSFMM sessions and hallway talks, major feedbacks I ha=
d
> received are these two:
>
>  1. blktests CI infra looks missing (other than CKI by Redhat)
>     -> Some activities are ongoing to start blktests CI service.
>        I hope the status are shared at the session.
>
>  2. blktests are rather difficult to start using for some new users
>     -> I think config example is demanded, so that new users can
>        just copy it to start the first run, and understand the
>        config options easily.

+1 to this.

>
> > - Do we need some sort of configuration tool which allows to setup a
> >   config? I'd still have a TODO to provide a config example with all
> >   knobs which influence blktests, but I wonder if we should go a step
> >   further here, e.g. something like kdevops has?
>
> Do you mean the "make menuconfig" style? Most of the blktests users are
> familiar with menuconfig, so that would be an idea. If users really want
> it, we can think of it. IMO, blktests still do not have so many options,
> then config.example would be simpler and more appropriate, probably.
>
> > - Which area do we lack tests? Should we just add an initial simple
> >   tests for the missing areas, so the basic infra is there and thus
> >   lowering the bar for adding new tests?
>
> To identify the uncovered area, I think code coverage will be useful. A f=
ew
> years ago, I measured it and shared in LSFMM, but that measurement was do=
ne for
> each source tree directory. The coverage ratio by source file will be mor=
e
> helpful to identify the missing area. I don't have time slot to measure i=
t,
> so if anyone can do it and share the result, it will be appreciated. Once=
 we
> know the missing areas, it sounds a good idea to add initial samples for =
each
> of the areas.
>
> > - The recent addition of kmemleak shows it's a great idea to enable mor=
e
> >   of the kernel test infrastructure when running the tests.
>
> Completely agreed.
>
> >   Are there more such things we could/should enable?
>
> I'm also interested in this question :)
>
> > - I would like to hear from Shin'ichiro if he is happy how things
> >   are going? :)
>
> More importantly, I would like to listen to voices from storage sub-syste=
m
> developers to see if they are happy or not, especially the maintainers.

I like the idea of blktests.
We have internal tests which we run for RNBD (and RTRS).
And I plan to port the RNBD ones to blktests.

>
> From my view, blktests keep on finding kernel bugs. I think it demonstrat=
es the
> value of this community effort, and I'm happy about it. Said that, I find=
 what
> blktests can improve more, of course. Here I share the list of improvemen=
t
> opportunities from my view point (I already mentioned the first three ite=
ms).
>
>  1. We can have more CI infra to make the most of blktests
>  2. We can add config examples to help new users
>  3. We can measure code coverage to identify missing test areas
>  4. Long standing failures make test result reports dirty
>     - I feel lockdep WARNs are tend to be left unfixed rather long period=
.
>       How can we gather effort to fix them?
>  5. We can refactor and clean up blktests framework for ease of maintaina=
nce
>       (e.g. trap handling)
>  6. Some users run blktests with built-in kernel modules, which makes a n=
umber
>     of test cases skipped. We can add more built-in kernel modules suppor=
t to
>     expand test coverage for such use case.

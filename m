Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA061A9B58
	for <linux-scsi@vger.kernel.org>; Sun, 15 Feb 2026 21:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771190323; cv=pass; b=h6+RoSwGd+9UoKp5riZ2PLFFKygOuuZMUQLNWe1L+bg/LRh05g6i4125ISBraWZdRLYjzYPw7adirFynQtbRv+k9WRmqxWaPWO76yu2vxu/idjTppXwf4NfueyKkC7M1Lou26qsfeJnJ3Fbj/n4/vzvk0m3Jz/zbdy8cvK3TLfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771190323; c=relaxed/simple;
	bh=kHKJYV8nnw8Z8vztJHTpu6iFGyZWzK74DCx4AAtkr30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eJvj4BGH7/5JBTyf1FvU4q0U17NZn4EZ31dAjRSlbwtDM78OLob6ok/PaBS3R/Kr/u+844C3aoAxU+O7J+SOaHiWMBdXUuTqCzWqczkNjTLdxe1eCqkIKff+m3w1X4sU/O4dry0OY5Y1pkEO+cRBk3fk0ogfNZbPVmWVhALGZqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=P0N2Rfgi; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="P0N2Rfgi"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-385c2f88618so19734821fa.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Feb 2026 13:18:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771190320; cv=none;
        d=google.com; s=arc-20240605;
        b=hX6GIN2EbDmIZeWQHP5znIYL5AsgCU/0SIfARYBQFkU+d6ShJYQl33B5AL7eaURyVK
         7q9qbwdE5LNpyLbkLc0jZi3WcinnppT0zexC5NFHxM8nVhfrdkEhQ72hk8N1jaOvpx+z
         6yrqXnEZ8Eln2aHBt9eliAVmr6JY+iVOabCoSZAtKsbzAXx+5QtOMDob3FTfFrThco2k
         Gp6bQHWQpxww/lSYfL+2ZEzxFvJzQPWwqVA0UtIdR30v6GKgrkXGGhs+DdsbyjWOODwN
         gXSmBpHRA+SfkvFBciD8TE4ZMtDHtx3k/5KpghO0mdnuwxgGW+Tib1mQcwwE1S/yDXGc
         kFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nh5TnaSI7rZPj2uhgnsZBl8QSuJdZuhEOKvh+vqqOKs=;
        fh=MqQRCFca53zIKptsF22WJUixYx79BJnP9bw+i0DIDho=;
        b=koe0cFwSv+IfZ5nBcuVKYiDBofA14u/CDU21VGAm8S8ikQEQBgZ4Lzr2OEIg4V+wcs
         YVvzCffTdQ/IVH2LXg4nrxbbrepnis9ZiJxke/lDLMaUTPI0CMUUJt/ujwKNWv9BFZNF
         qOLKZnbsmJPT1wHc8Q5mxRYR0/R3soXdvCKXEH9PM5OhRNOHoJflbg1uQrD3tZ2p3NXI
         ZAoqn19oL3N+qYImwNr8W4jLqpDcp9uVwE1BqtZSW0wpFppBEfssi2GRJ6B6/33TFkSA
         qppHTGgFTCQY5jjnefvPZLUDAYTi4oW83MWUSq/v5vzBHE9qeKIXOuJ1FVSAyadFs6Yo
         nLPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1771190320; x=1771795120; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nh5TnaSI7rZPj2uhgnsZBl8QSuJdZuhEOKvh+vqqOKs=;
        b=P0N2RfgiPzN4CIynQyVmn8d3n6n9uuP7CBn0ef4S3xG/F8oQzqUWj7JSo/bP9gaBPD
         uAmxfKcp7OB+r2tiEgGjYd1Kx3Uq+4z7FSTQqXyUKyF9EJK7XD2qZvRBIq5O/i0pPYGv
         p3B2P5uzhbrqeCa1PaY/o+TSf+VQF77SEzikQSc+PcelJVFYsAPqlqzZvT7y9Ke1mu18
         fQDMuWHWBP1T/G0+Cx8xgVsvHUGipS8av/Rbk2j07mRtgB0/RYA+n559ngBRZ+uZIDrH
         Mqh9LRqmYu/QwVbgexFaC4gnD9YdIara2f+ZUb+ZOYiwfNq4QieLLnNf7m5wrUHc23HX
         o7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771190320; x=1771795120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nh5TnaSI7rZPj2uhgnsZBl8QSuJdZuhEOKvh+vqqOKs=;
        b=i1o0tRRa+In7BiRUVf3RXb2HptKwTZzmfEW0POcwQ5fO2zxHVmLDmXbH2wr6WH9jYj
         5sonnfcuNTJaWSfrACBRhwFwrA4NWLUFnQdinJUDtQPth9GZTDrO5NrFm1rnKfnX4UQh
         hrs2SLSdLnEAz8ciFfQCF86XHUfgUp+lbXR4zz4dfqp6BH89IPPkZN3Xm24ffkkTeEF5
         KCPTSEmYRHqswZfd3hrPaEOk2tvPmwv6+YV3F/+UXHh7jA3Y57xOhEhwwyPPdAR9lZM4
         Y63sEAx8czuzdxFtEvXtNrx1lIEDLTBuYb9a4Z9d9NjXFs9WhGHRA/g6lPqU3wh38eg+
         SqXA==
X-Forwarded-Encrypted: i=1; AJvYcCXojaYYv3RWRgqILTWXpin94BNX+cvnYfri0YIktCzKdJADg6N9HtfGe38youh5gMKAwn3ydKzhpBtu@vger.kernel.org
X-Gm-Message-State: AOJu0YzewybTd82/wqNrYaI7OMBnWVxZl69y46l1YmAmTS0hKhaBy+9S
	34BwhuIhztxSizmVrITenkzz5LnXwjfjbFkszRK40RnX91VRzDl/Q5FA602kzxkaYCL7tQI1nX6
	eyk4xdi9JWlw06KnJ3LeyW403FJuir6vBFwcd7X+JMA==
X-Gm-Gg: AZuq6aItuUqDDmodnMn37Djff2n4ABx4UVvXzKgLaQ7GopMlsCAhkeXv3SZXd29x9i8
	e+Tyfvg1k9mLneOzE4Gn0Izgxrbdjwk3Q1av4Cx5oM5AYzjh2zus+enUcdDfWWwTqDdUkyQgTkR
	2K/UeDSp3jWQyoKK8ucHTSkCrV89F56FVjw1UZSO1PJmntYo0JRmWnjId/aT3XO31kD/IvKafqX
	kyOg8uHkcwbxcr6jHgJ1mQgY3t05TlHGrZiUaQ942WgzIxvHhwAyK4yq6Gzo9Dxq4oySbSIkrCw
	i0uBkCtc0o8TbCZ2N2Rs6VMml1klOMnFbcs3T8VeQH6nh2ZF9esSCfsnklDmmbmAhBCCDWafIsH
	XYTtq2Ew3znfmWQ6yXRo7dcU=
X-Received: by 2002:a2e:a781:0:b0:383:1d89:8d0c with SMTP id
 38308e7fff4ca-38810525294mr24772281fa.15.1771190319860; Sun, 15 Feb 2026
 13:18:39 -0800 (PST)
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
Date: Sun, 15 Feb 2026 22:18:28 +0100
X-Gm-Features: AaiRm50UiUfxjs0q7nnu2kE7OqfPsAIU6uDVz4YX8OUdHbhFYRNnEhFTdkEJv9w
Message-ID: <CAJpMwyis1iZB2dQMC4VC8stVhRhOg0mfauCWQd_Nv8Ojb+X-Yw@mail.gmail.com>
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
>
> From my view, blktests keep on finding kernel bugs. I think it demonstrat=
es the
> value of this community effort, and I'm happy about it. Said that, I find=
 what
> blktests can improve more, of course. Here I share the list of improvemen=
t
> opportunities from my view point (I already mentioned the first three ite=
ms).

A possible feature for blktest could be integration with something
like virtme-ng.
Running on VM can be versatile and fast. The run can be made parallel
too, by spawning multiple VMs simultaneously.

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

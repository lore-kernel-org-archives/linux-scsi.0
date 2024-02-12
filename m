Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CFA4D135
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2024 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707775629; cv=none; b=knweEzcRbO7bHiMQMy1mWtyPySSB30lI12NcVjVJzvXj45olFd0DDDuT8DB0PC2BbBo7yHaSDnMbGJ5QZuDacrkGdgpUtPQdJEGpvPw9f/yMBBHQ3pNuU5ynfIOQhHHtooq5n6FOlxLohlMwOXA8oL6BhVahSiOzann2MXT+8+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707775629; c=relaxed/simple;
	bh=K+9d+RzKH5dsvZK1vSKFlvqS1ubtGB6tUUGV4Hxnrcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9KFmIn1kdiaiXCoEDk1lHLquv2dhVi+f9sB+8RTbaaFMQXryv3Ra9CTnoVC/l6mbP2OaO8phjuCWO622QLbRbtoD0Pi9AbSFLRlp2DMqCJ3a6Dwhp5JL9vmErzI16XWmcZtP0oH2Quo7QqurVZmx02iOJSMDTjZCO3ZpKdRflE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rCwbI8Kl; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rCwbI8Kl"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d8aadc624dso27121535ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2024 14:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707775627; x=1708380427; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hdYsVJZ8Ora4iYnpb5KhpDVHQp//SzZSwGCN56T/AUA=;
        b=rCwbI8KllAdlVoCVrB0b7ylCz70x6xxjZtyBxYx0YvqgpvVmbcVbKLoCsXyM2n6LxL
         SUDpEBU10vZwjJ4GbfPUWYAmmgaZtKyIOC7NeXCeEMQD+nUWC7pTpw6gCHcR4aNKsl8C
         0YbUZsOSmHwIGWlJQpiPqOoII3KJADZz01wYKAbcg2IFGnRHs0rxL351s4jfKk5H8gul
         n+vHfj8x9eiGO7P+/l1RARLBybOs/uXDTNPuBmxSoZaKd5zV1FC6KHRMD3zAqrLESwt4
         tgcjwdjmffjMXteZSG6Ra4svTqCF+C3XDP1RPLo/JS6NzNR7KaUPIGYTDVYzvGou0s/c
         7x6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707775627; x=1708380427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdYsVJZ8Ora4iYnpb5KhpDVHQp//SzZSwGCN56T/AUA=;
        b=qK3uiJlJbPXsfQVU6bHD1iLrndonZsYyvrAf3lcd75gWoo7UtktU7ObQ8H3iGwpyD6
         oe/k6KZfWAaFQ9bWwoxh9lv6dx3GYdyn714W7GUkSoQNLPNGFSQGCvhVL9sBaxNwq4yE
         BBjMfPTf0XOWMhLIbywg0xzYHcSgx61nZ4QImvhl+j5pgCd6+cnqpMYJq2mJdWFJ6o89
         zmJ/27RzSyn6eVJiAjoag0l5COI6JUYPPxPa5TAfiJScdvxBW5L8OnXnufqRakelQzQT
         avBwtExxfr9biOwrm0cEoDv4TdTOUUl/WzqqM8w2TUzTCe2GJuSl+9XJAJMdW/5j99DT
         d6qA==
X-Forwarded-Encrypted: i=1; AJvYcCXrKKHz9dtaordWedlUK4U92nkJhT1IUpSjmm8bRBQJaXtiv5SaXl2+sWzW+y/sOwmI7cGmK2MvkkSLvogmAW7/4KnpxCkrwK1hlQ==
X-Gm-Message-State: AOJu0YzKDA9gqjAeMCkNAagYqlqvYplUSuZ7ZbYRV0Z/Sin0eAsVcVNu
	L/UYm+Z8e8I7tEL04n7q7xHC3u/KKWfaga0e0LzylyQ1O+HbkPCDV/8Y/SBAZI4=
X-Google-Smtp-Source: AGHT+IGaGxGMtVNxwY57a75FxouCmxRA8F9ezxcGzJMqapTK57ZCd099OQZYPv1Zwae9AMhdE608kw==
X-Received: by 2002:a17:903:22ca:b0:1d9:d8d2:eabb with SMTP id y10-20020a17090322ca00b001d9d8d2eabbmr7857477plg.46.1707775626950;
        Mon, 12 Feb 2024 14:07:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXxIt4/SfEYX7HaojQTjTYucUuLHj8DuvbaDMOWISnbQ9PtBBz9MmhfTWbayWFO+027RmfX5weuFlbQ58Zf5GHbsugzCZ7VK+JiRK67D4qcD7HneVmqTWlRCaLqUi4B57asLAyVOHqj+V3CtzjsUwJEQCwTUKEolB3eOai9t5Rs3n9vRhSCmUprbSWcw33frZpfza6KwKY0dSnZtBqk93nt4zvqXxz9McL8gev2OVrOnSvEfNzBcGzzNaW/v6IzUOUilRxjKMiYDDVoDtg6musEghJJlZDCrX1tuu9gCcHLeqhLaee1n4ZuLAsGcxh5GgAvUbchMKvhOk/BWKbDrMzy7trHcBuJLOWc8+7ZZYVTlHKZgUEsb0HSHhNWA8ICUJhHqbqnX5iub7FdPi/cP4Uvi1vrq3useTA9
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id u11-20020a170903308b00b001d6f091ca04sm820043plc.13.2024.02.12.14.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 14:07:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rZeS7-005fsr-2C;
	Tue, 13 Feb 2024 09:07:03 +1100
Date: Tue, 13 Feb 2024 09:07:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Removing GFP_NOFS
Message-ID: <ZcqWh3OyMGjEsdPz@dread.disaster.area>
References: <ZZcgXI46AinlcBDP@casper.infradead.org>
 <ZZzP6731XwZQnz0o@dread.disaster.area>
 <3ba0dffa-beea-478f-bb6e-777b6304fb69@kernel.org>
 <ZcUQfzfQ9R8X0s47@tiehlicka>
 <3aa399bb-5007-4d12-88ae-ed244e9a653f@kernel.org>
 <ZclyYBO0vcQHZ5dV@dread.disaster.area>
 <5p4zwxtfqwm3wgvzwqfg6uwy5m3lgpfypij4fzea63gu67ve4t@77to5kukmiic>
 <ZcmgFThkhh9HYsXh@dread.disaster.area>
 <cepmpv7vdq7i6277wheqqnqsniqnkomvh7sn3535rcacvorkuu@5caayyz44qzr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cepmpv7vdq7i6277wheqqnqsniqnkomvh7sn3535rcacvorkuu@5caayyz44qzr>

On Mon, Feb 12, 2024 at 02:30:02PM -0500, Kent Overstreet wrote:
> On Mon, Feb 12, 2024 at 03:35:33PM +1100, Dave Chinner wrote:
> > On Sun, Feb 11, 2024 at 09:06:33PM -0500, Kent Overstreet wrote:
> > > That's because in general most code in the IO path knows how to make
> > > effective use of biosets and mempools (which may take some work! you
> > > have to ensure that you're always able to make forward progress when
> > > memory is limited, and in particular that you don't double allocate from
> > > the same mempool if you're blocking the first allocation from
> > > completing/freeing).
> > 
> > Yes, I understand this, and that's my point: NOIO context tends to
> > be able to use mempools and other mechanisms to prevent memory
> > allocation failure, not NOFAIL.
> > 
> > The IO layers are request based and that enables one-in, one out
> > allocation pools that can guarantee single IO progress. That's all
> > the IO layers need to guarantee to the filesystems so that forwards
> > progress can always be made until memory pressure.
> > 
> > However, filesystems cannot guarantee "one in, one out" allocation
> > behaviour. A transaction can require a largely unbound number of
> > memory allocations to succeed to make progress through to
> > completion, and so things like mempools -cannot be used- to prevent
> > memory allocation failures whilst providing a forwards progress
> > guarantee.
> 
> I don't see that that's actually true. There's no requirement that
> arbitrarily large IOs must be done atomically, within a single
> transaction:

*cough*

metadata Io needs to be set up, issued and completed before the
transaction can make progress, and then the transaction will hold
onto that metadata until it is committed and unlocked.

That means we hold every btree buffer we walk along a path in the
transaction, and if the cache is cold it means we might need to
allocate and read dozens of metadata buffers in a single
transaction.

> there's been at most talk of eventually doing atomic writes
> through the pagecache, but the people on that can't even finish atomic
> writes through the block layer, so who knows when that'll happen.

What's atomic data writes got to do with metadata transaction
contexts?

> I generally haven't been running into filesyste operations that require
> an unbounded number of memory allocations (reflink is a bit of an
> exception in the current bcachefs code, and even that is just a
> limitation I could solve if I really wanted to...)

Step outside of bcachefs for a minute, Kent. Not everything works
the same way or has the same constraints and/or freedoms as the
bcachefs implementation....

> > Hence a NOFAIL scope if useful at the filesystem layer for
> > filesystem objects to ensure forwards progress under memory
> > pressure, but it is compeltely unnecessary once we transition to the
> > IO layer where forwards progress guarantees ensure memory allocation
> > failures don't impede progress.
> > 
> > IOWs, we only need NOFAIL at the NOFS layers, not at the NOIO
> > layers. The entry points to the block layer should transition the
> > task to NOIO context and restore the previous context on exit. Then
> > it becomes relatively trivial to apply context based filtering of
> > allocation behaviour....
> > 
> > > > i.e NOFAIL scopes are not relevant outside the subsystem that sets
> > > > it.  Hence we likely need helpers to clear and restore NOFAIL when
> > > > we cross an allocation context boundaries. e.g. as we cross from
> > > > filesystem to block layer in the IO stack via submit_bio(). Maybe
> > > > they should be doing something like:
> > > > 
> > > > 	nofail_flags = memalloc_nofail_clear();
> > > 
> > > NOFAIL is not a scoped thing at all, period; it is very much a
> > > _callsite_ specific thing, and it depends on whether that callsite has a
> > > fallback.
> > 
> > *cough*
> > 
> > As I've already stated, NOFAIL allocation has been scoped in XFS for
> > the past 20 years.
> > 
> > Every memory allocation inside a transaction *must* be NOFAIL unless
> > otherwise specified because memory allocation inside a dirty
> > transaction is a fatal error.
> 
> Say you start to incrementally mempoolify your allocations inside a
> transaction - those mempools aren't going to do anything if there's a
> scoped NOFAIL, and sorting that out is going to get messy fast.

How do you mempoolify something that can have thousands of
concurrent contexts with in-flight objects across multiple
filesystems that might get stashed in a LRU rather than freed when
finished with? Not to mention that each context has an unknown
demand on the mempool before it can complete and return objects to
the mempool?

We talked about this a decade ago at LSFMM (2014, IIRC) with the MM
developers and nothing about mempools has changed since.

> > However, that scoping has never been
> > passed to the NOIO contexts below the filesytsem - it's scoped
> > purely within the filesystem itself and doesn't pass on to other
> > subsystems the filesystem calls into.
> 
> How is that managed?

Our own internal memory allocation wrappers. go look at what remains
in fs/xfs/kmem.c. See the loop there in kmem_alloc()? It's
guaranteeing NOFAIL behaviour unless KM_MAYFAIL is passed to the
allocation. Look at xlog_kvmalloc() - same thing, except it is
always run within transaction context (the "xlog" prefix is a
giveaway) and so will block until allocation succeeds.

IOWs, we scoped everything by having our own internal allocation
wrappers than never fail. In removing these wrappers (which is where
my "scoped NOFAIL" comments in this thread originated from) the
proliferation of __GFP_NOFAIL annotations across meant we went from
pretty much zero usage of __GFP_NOFAIL to having almost a hundred
allocation sites annotated with __GFP_NOFAIL. And it adds a
maintenance landmine for us - we now have to ensure that all future
allocations within a transaction scope are marked __GFP_NOFAIL.

Hence I'm looking for ways to move this NOFAIL scoping into the
generic memory allocation code to replace the scoping we current
have via subsystem-specific allocation wrappers.

> > > > > - NOWAIT - as said already, we need to make sure we're not turning an
> > > > > allocation that relied on too-small-to-fail into a null pointer exception or
> > > > > BUG_ON(!page).
> > > > 
> > > > Agreed. NOWAIT is removing allocation failure constraints and I
> > > > don't think that can be made to work reliably. Error injection
> > > > cannot prove the absence of errors  and so we can never be certain
> > > > the code will always operate correctly and not crash when an
> > > > unexepected allocation failure occurs.
> > > 
> > > You saying we don't know how to test code?
> > 
> > Yes, that's exactly what I'm saying.
> > 
> > I'm also saying that designing algorithms that aren't fail safe is
> > poor design. If you get it wrong and nothing bad can happen as a
> > result, then the design is fine.
> > 
> > But if the result of missing something accidentally is that the
> > system is guaranteed to crash when that is hit, then failure is
> > guaranteed and no amount of testing will prevent that failure from
> > occurring.
> > 
> > And we suck at testing, so we absolutely need to design fail
> > safe algorithms and APIs...
> 
> GFP_NOFAIL dosen't magically make your algorithm fail safe, though.

I never said it did - this part of the conversation was about the
failure prone design of proposed -NOWAIT- scoping, not about
trying to codify a generic mechanism for scoped behaviour we've been
using successfully for the past 20 years...

> Suren and I are trying to get memory allocation profiling into 6.9, and
> I'll be posting the improved fault injection immediately afterwards -
> this is what I used to use to make sure every allocation failure path in
> the bcachefs predecessor was tested. Hopefully that'll make things
> easier...

Tha all sounds good, but after a recent spate of "CI and post
integration testing didn't uncover fs bugs that fstests reproduced
until after tested kernels were released to test systems", I have
little confidence in the ability of larger QA organisations, let
alone individuals, to test filesystem code adequately when they are
constrained either by time or resources.

The fact of the matter is that we are all constrained by time
and resources. Hence adding more new testing methods that add time
and resources to validate new code and backports of fixes to the
test matrix overhead does nothing to improve that situation.

We need to start designing our code in a way that doesn't require
extensive testing to validate it as correct. If the only way to
validate new code is correct is via stochastic coverage via error
injection, then that is a clear sign we've made poor design choices
along the way.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

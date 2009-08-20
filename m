From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Re: Performance issues with Areca 1680 SAS Controllers
Date: Thu, 20 Aug 2009 11:00:02 +0300
Message-ID: <20090820080002.GO19938@edu.joroinen.fi>
References: <20090819140848.GW19938@edu.joroinen.fi> <200908192247543597389@usish.com> <20090819164029.GZ19938@edu.joroinen.fi> <c268e4660908191929u3f11c733oc68a0d50a3e5aca8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from edu.joroinen.fi ([194.89.68.130]:40478 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZHTIAC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 04:00:02 -0400
Content-Disposition: inline
In-Reply-To: <c268e4660908191929u3f11c733oc68a0d50a3e5aca8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Wang Jinpu <jack_wang@usish.com>, Nick Cheng <nick.cheng@areca.com.tw>, Andrew Morton <akpm@linux-foundation.org>, Michael Fuckner <michael@fuckner.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Erich Chen <erich@areca.com.tw>

On Wed, Aug 19, 2009 at 07:29:07PM -0700, Drew wrote:
> > The problem is while Areca is doing the flushing _all_ IOs are really slow,
> > including the other raid-10 array for the OS, which uses totally separate physical disks.
> >
> > Opening another shell in screen takes at least 30 seconds, starting "top"
> > takes forever etc..
> >
> > While Areca is flushing the caches (and all the IOs are slow), "iostat 1"
> > doesn't show any "leftover" IOs from the benchmark. So the benchmark was
> > really using direct IO, bypassing kernel caches.
> >
> > I tried with different io-schedulers (cfq,deadline,noop) but they didn't
> > have big effect.. which makes sense, since the OS/kernel is not doing any
> > big IO when the 'stalling' happens.
> >
> > Is there some way to make Areca NOT use all cpu-power for cache flushing?
> 
> Is top showing 100% cpu usage?
> 

No, cpu usage is almost 0%. I was talking about cpu-usage of _Areca_ controller.

When the disktest-benchmark ends, Linux cpu usage goes to 0%, and there's no IO
anymore (checked with "iostat 1"). 

But _Areca_ is still flushing it's caches, and all the IO will be slow, even
when there's no load in _Linux_. 

-- Pasi

> It wouldn't surprise me if the Areca's internal bus / processor is
> getting swamped. With the RAID60 chewing through two PQ calculations
> over 14 disks I'd expect the performance of other arrays on the
> controller would take a hit
> 
> I've seen similar symptoms when moving massive amounts of data between
> disks on my servers. IO maxes out the bus, system responsiveness goes
> down as evidenced by slowly loading apps, and top still shows minimal
> CPU usage.
> 
> 
> -- 
> Drew
> 
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie

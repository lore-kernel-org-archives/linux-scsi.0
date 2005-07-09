From: Mark Overmeer <Mark@Overmeer.net>
Subject: Re: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Sat, 9 Jul 2005 12:03:41 +0200
Message-ID: <20050709120341.B18919@speeltuin.ATComputing.nl>
References: <1120844190.19677.46.camel@markh1.pdx.osdl.net> <1120844507.19828.70.camel@ryan2.internal.autoweb.net> <Pine.LNX.4.60.0507082014210.14785@kepler.fjfi.cvut.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from speeltuin.ATComputing.nl ([195.108.229.26]:527 "EHLO
	speeltuin.ATComputing.nl") by vger.kernel.org with ESMTP
	id S261599AbVGIKDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 06:03:42 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0507082014210.14785@kepler.fjfi.cvut.cz>; from drab@kepler.fjfi.cvut.cz on Fri, Jul 08, 2005 at 08:17:39PM +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Drab <drab@kepler.fjfi.cvut.cz>
Cc: Ryan Anderson <ryan@autoweb.net>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

* Martin Drab (drab@kepler.fjfi.cvut.cz) [050708 20:19]:
> > On Fri, 2005-07-08 at 10:36 -0700, Mark Haverkamp wrote:
> > > Martin Drab found that he could get aacraid timeouts with high load on
> > > his controller / disk drive combinations.  After some experimentation
> > > Mark Salyzyn has come up with a patch to reduce the default max_sectors
> > > to something that will keep the controller from being overloaded and
> > > will eliminate the timeout issues.
> > 
> > Would hitting this timeout issue cause the container to go offline?
> 
> Yes. See my previous report to LKML.
> (http://lkml.org/lkml/2005/7/5/194)
>  
> > If so, I think this may fix the issues I was having 6 months ago.  (We
> > ended up taking the aacraid controller out of our production
> > environment, in frustration.)

The figures you have are comparible to my measurements: ~40MB/s r/w
Which is very poor when each disk can do better on its own.

I have three configurations:
  Adaptec 2410SA with 4x250GB,   stable since it came in, about 18 months

  Adaptec 2810SA with 8x250GB,   not really stable (1)

  Adaptec 2810SA with 7x300GB,   stable (2)

ad (2):  With 8 disks, it was unstable.  Over 2TB is not a good idea,
even not when split in 2x4 disks or otherwise.  Didn't get it to work.

ad (1): crashed every 3 months losing disks.  Then, it started to give
firmware kernel crashes.  Got a replacement card, which didn't crash:
data was back, but one of the ports (#7) was dead.  Replaced it by again
a new card: now all disks were seen... but somewhere lost all my data :(((
Not the end of disaster: after two weeks, the data was lost again, under
load conditions.  It reports different disks to fail, but especially on
the high port numbers.  Have used various firmware versions and many
different kernels. 

Now I have changed my strategy: buying only motherboards with 4xSATA on
it (ICH6).  4 disks striped give me 200MB/s (performance gain of 5x)

>From 
   1 system with 7x300GB RAID5 2810SA, 2.8GHz P4, 2GB, Asus P4P800-E Deluxe
   eff. ~40MB/s  1675GB netto
   sept 2004: 3450 euro ex VAT

To
   2 systems each 4x400GB RAID0, 3.0GHz P4, 1GB, Asus P5GDC-V Deluxe
   each eff. ~200MB/s  1100GB netto
   june 2005: 2850 euro ex VAT together!

Comparing apples and oranges: the second configuration is stable, faster,
and redundant.  The first is larger and pseudo-redundant.
-- 
               MarkOv

------------------------------------------------------------------------
drs Mark A.C.J. Overmeer                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net

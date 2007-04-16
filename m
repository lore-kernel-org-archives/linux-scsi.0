From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 13:08:57 -0700
Message-ID: <20070416200857.GH10822@andrew-vasquezs-computer.local>
References: <20070416.010218.130850966.davem@davemloft.net> <20070416163712.GA10822@andrew-vasquezs-computer.local> <20070416.123743.07452378.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:17214 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030936AbXDPUJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 16:09:01 -0400
Content-Disposition: inline
In-Reply-To: <20070416.123743.07452378.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Mon, 16 Apr 2007, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 16 Apr 2007 09:37:12 -0700
> 
> > On Mon, 16 Apr 2007, David Miller wrote:
> > 
> > > But even if that fails, I think the fallback code should be put back,
> > > since it obviously was used by at least one system and it's probable
> > > that there are some other applications of using this qla2xxx chip that
> > > will have an empty NVRAM too.
> > 
> > Then they should really get their NVRAM corrected, if in fact their
> > NVRAMs are cleared.
> > 
> > > I can understand the apprehension in using a fixed port_name[] value,
> > > since it could conflict with other FC controllers on the mesh, but if
> > > that is so important just choose some random value that is a valid FC
> > > ID or use some characteristic ID that can be used to compose part of
> > > the port WWN in order to give it at least some uniqueness.
> > 
> > Look, there's a fine balance here that we must strike -- the solution
> > that you're proposing implies that there's some 'random' bit-space
> > within the IEEE NAA with which one can safely encode without stomping
> > on any valid OUI.
> 
> The fact is that your driver was significantly more robust
> previously, and now it's so less robust that it now fails for
> people.
> 
> That's totally unacceptable.
> 
> Just like the sparc64 systsems, others depending upon this fallback
> behavior the qla2xxx driver had are going to break and they are not
> going to be able to just go and fix their hardware and re-flash the
> NVRAM.
> 
> Every user on the planet is going to be 1,000 times more happy with a
> big fat warning in their kernel log saying that things might not go
> right, but the driver is going to try anyways, rather than a complete
> non-attempt to make things work.
> 
> You replaced a possible failure with a guarenteed one.
> 
> %99.9999999 of people are never going to run into a FC ID collision.
> They have an onboard FC controller and a disk or two.

Sorry, but in a SATA/SCSI environment that may be true, but in the
case of FC that expectation is unrealistic.  There are thousands of FC
installations where there are several thousand endpoints (including
initiators and targets) all interconnected.  Let's use your case --
just connect two sparc machines within the same fabric to your
storage, with the old code, there's still a problem.

> They DON'T
> CARE, they want their systems to work and if you don't give them that
> you're not being a good driver maintainer.

Let's push aside attitudes and unrealistic statistics, could we
perhaps agree to re-add the use of doctored NVRAM (and thus
non-random WWPN/WWNN) when NVRAM is corrupted or non-present with a
module-parameter (which defaults to 0) which indicates the user
*really* knows what she is doing and recognizes WWPN collisions may
occur -- non-zero the parameter value indicates doctored values will
be used, zero value (the default) fails initialization.  In both cases
a big FAT warning is issued.

> You BROKE things, therefore you must FIX it.
>
> Now I'm happy to code up the sparc OFW property bits but your attitude
> and perspective on this absolutely has to change and the old fallback
> code still has to go back in there, possible FC ID collisions or not.

That would be great,  I'd like to insure the balance is maintained for
*all* our users.



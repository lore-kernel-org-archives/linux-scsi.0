From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Major qla2xxx regression on sparc64
Date: Wed, 18 Apr 2007 18:13:46 +0100
Message-ID: <20070418171346.GA16471@infradead.org>
References: <20070416.010218.130850966.davem@davemloft.net> <20070416163712.GA10822@andrew-vasquezs-computer.local> <20070416.123743.07452378.davem@davemloft.net> <20070416200857.GH10822@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35734 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992876AbXDRRN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 13:13:57 -0400
Content-Disposition: inline
In-Reply-To: <20070416200857.GH10822@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Mon, Apr 16, 2007 at 01:08:57PM -0700, Andrew Vasquez wrote:
> Sorry, but in a SATA/SCSI environment that may be true, but in the
> case of FC that expectation is unrealistic.  There are thousands of FC
> installations where there are several thousand endpoints (including
> initiators and targets) all interconnected.  Let's use your case --
> just connect two sparc machines within the same fabric to your
> storage, with the old code, there's still a problem.

Multi-initiator setups are probably the majority in the FC world by now.
But there has been a time around 2000 where various of companies thought
FC is so l33t that they'd put it in as default.  E.g. the early SGI
Origin 3000 used to have FC-attached root disks.  I think Sun has similar
machines.

> > They DON'T
> > CARE, they want their systems to work and if you don't give them that
> > you're not being a good driver maintainer.
> 
> Let's push aside attitudes and unrealistic statistics, could we
> perhaps agree to re-add the use of doctored NVRAM (and thus
> non-random WWPN/WWNN) when NVRAM is corrupted or non-present with a
> module-parameter (which defaults to 0) which indicates the user
> *really* knows what she is doing and recognizes WWPN collisions may
> occur -- non-zero the parameter value indicates doctored values will
> be used, zero value (the default) fails initialization.  In both cases
> a big FAT warning is issued.

I don't think a module option is a good idea at this point.  The problem
is you broke some so far perfectly working setups, which is not okay.
The only first step can be printing a really big warning.  After this
has been in for a while (at lest half a year) we can make it a non-default
option or turn if off completely in case the warning never triggered in
practice.

The only resonable thing for 2.6.21 is to put in David's patch, possible
with an even more drastic warning when the rom is invalid and there's
no prom-fallback available.

Note that I expect Sun put in the invalid ROM intentionally, as we have
similar cases with other cards that have totally messed up ROMs in
Sun-branded versions.  Personally I think that's an utterly bad decision
from Sun's side, but we'll have to live with this.

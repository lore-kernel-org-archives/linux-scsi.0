From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sym53c8xx_2 negotiates improperly
Date: Sun, 15 Oct 2006 17:21:00 -0500
Message-ID: <1160950861.3544.30.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0610151329300.8184@monarch.fast.net>
	 <1160934902.3544.14.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0610151406320.8184@monarch.fast.net>
	 <1160939042.3544.24.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0610151749080.6669@monarch.fast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15009 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932152AbWJOWVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 18:21:10 -0400
In-Reply-To: <Pine.LNX.4.64.0610151749080.6669@monarch.fast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Steven N. Hirsch" <shirsch@adelphia.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Please don't drop linux-scsi ... it's always possible someone else will
be interested in the Q&A.

On Sun, 2006-10-15 at 18:04 -0400, Steven N. Hirsch wrote:
> On Sun, 15 Oct 2006, James Bottomley wrote:
> 
> > On Sun, 2006-10-15 at 14:10 -0400, Steven N. Hirsch wrote:
> > > I'll take a look at the 2.6.18 driver.  Was the Quantum placed on a 
> > > blacklist somewhere?  Or, is the fix vendor neutral?
> > 
> > The fix is vendor neutral ... it's just to be more careful about setting
> > the initial PPR parameters.
> 
> I backported this as best I could into the SuSE 2.6.16 kernel, which 
> consisted of using sym_hipd.c and sym_hipd.h from 2.6.18 along with the 
> latter's version of scsi_transport_spi.c and its header.

Er, I think it would be much easier just to test vanilla 2.6.18

> >From what I can see, this is where all the PPR parameters are handled.  
> The modules built fine but did not solve the problem.
> 
> Is there a means to completely disable PPR negotiation with some hope of 
> getting U160 operation?

No, that's impossible: PPR negotiation is physically required for u160
and above.

> I have a support request in to Seagate, but I'm guessing this unit is an 
> OEM pull and they'll tell me to go fly a kite...

Try seeing if you can manually push it to u160:

echo 12.5 > /sys/class/spi_transport/target0:0:0/period

then do some activity to the disc (to force the renegotiation) like
fdisk.

Then see if the setting stuck:

cat /sys/class/spi_transport/target0:0:0/period

If it did, then there's likely something in the initial PPR the drive
doesn't like.

James



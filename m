From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cciss: Fix warnings during compilation under
 32bitenvironment
Date: Fri, 20 Apr 2007 11:43:37 -0700
Message-ID: <20070420114337.12a67141.akpm@linux-foundation.org>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
	<1176995934.31764.7.camel@mulgrave.il.steeleye.com>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
	<1176999730.31764.15.camel@mulgrave.il.steeleye.com>
	<558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
	<20070419222028.d33c7f86.akpm@linux-foundation.org>
	<1177074641.3718.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767182AbXDTSnw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2007 14:43:52 -0400
In-Reply-To: <1177074641.3718.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Cameron, Steve" <Steve.Cameron@hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 20 Apr 2007 09:10:41 -0400
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Thu, 2007-04-19 at 22:20 -0700, Andrew Morton wrote:
> > On Thu, 19 Apr 2007 16:27:26 -0000 "Cameron, Steve" <Steve.Cameron@hp.com> wrote:
> > > 
> > > Something like 
> > > 
> > > if (sizeof(blah) > 4) {
> > >    do all the assignments with shifts
> > > }
> > > 
> > > might be slighly better since the CDB is already zeroed
> > > by cmd_alloc() and doesn't need to be zeroed a 2nd time.
> > > 
> > > -- steve
> > > 
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> > > Sent: Thu 4/19/2007 11:22 AM
> > > To: Miller, Mike (OS Dev)
> > > Cc: Hisashi Hifumi; akpm@linux-foundation.org; jens.axboe@oracle.com; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Cameron, Steve
> > > Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bitenvironment
> > >  
> > > On Thu, 2007-04-19 at 16:12 +0000, Miller, Mike (OS Dev) wrote:
> > > > > > Nak. You still haven't told where you saw these warnings. What 
> > > > > > compiler are you using? I do not see these in my 32-bit environment.
> > > > > 
> > > > > I think it's seen with CONFIG_LBD=n on 32 bits
> > > > > 
> > > > > In that configuration, sector_t is a u32 (it's u64 even on 32 
> > > > > bits with CONFIG_LBD=y).  The proposed code change is a 
> > > > > simple cut and paste from the sd driver.
> > > > 
> > > > Isn't there a better way than testing each one?
> > > 
> > > It's not such a bad option.  The sizeof() test is compile time
> > > determinable, so the compiler simply zeros the fields in the
> > > CONFIG_LBD=n case and does the shift for CONFIG_LBD=y.  It certainly
> > > never compiles to four inline condition checks.
> > > 
> > 
> > Boy you guys make a mess of a nice email trail :(
> > 
> > 
> > --- linux-2.6.21-rc7.org/drivers/block/cciss.c	2007-04-17 16:36:02.000000000 +0900
> > +++ linux-2.6.21-rc7/drivers/block/cciss.c	2007-04-17 16:25:53.000000000 +0900
> > @@ -2552,10 +2552,10 @@ static void do_cciss_request(request_que
> >  	} else {
> >  		c->Request.CDBLen = 16;
> >  		c->Request.CDB[1]= 0;
> > -		c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
> > -		c->Request.CDB[3]= (start_blk >> 48) & 0xff;
> > -		c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> > -		c->Request.CDB[5]= (start_blk >> 32) & 0xff;
> > +		c->Request.CDB[2]= sizeof(start_blk) > 4 ? (start_blk >> 56) & 0xff : 0;	//MSB
> > +		c->Request.CDB[3]= sizeof(start_blk) > 4 ? (start_blk >> 48) & 0xff : 0;
> > +		c->Request.CDB[4]= sizeof(start_blk) > 4 ? (start_blk >> 40) & 0xff : 0;
> > +		c->Request.CDB[5]= sizeof(start_blk) > 4 ? (start_blk >> 32) & 0xff : 0;
> >  		c->Request.CDB[6]= (start_blk >> 24) & 0xff;
> >  		c->Request.CDB[7]= (start_blk >> 16) & 0xff;
> >  		c->Request.CDB[8]= (start_blk >>  8) & 0xff;
> > 
> > This is not the first time we've hit this problem and presumably it won't
> > be the last time.
> > 
> > Could we do something like
> > 
> > #if (BITS_PER_LONG > 32) || defined(CONFIG_LBD)
> > #define sector_upper_32(sector) ((sector) >> 32)
> > #else
> > #define sector_upper_32(sector) (0)
> > #endif
> > 
> > and then cciss can do
> > 
> > -	c->Request.CDB[2]= start_blk >> 56;
> > +	c->Request.CDB[2]= sector_upper_32(start_blk) >> 24;
> > 
> > which will do the right thing.
> 
> Sure, we could do that.  The slight problem is that we don't have
> general agreement in the kernel how to handle sector_t.  So, the only
> consumer in scsi, sd, does the sizeof(block) ? thing.  If you look in
> libata you'll see that it unconditionally uses a u64 for picking up the
> value of sector_t so the shift is never invalid ... if we're going to
> start making macros for handling this, we probably need to ask the
> janitors to fix all of our existing code to use them ... or we could
> just let sleeping dogs lie ..

Let's decide how we _should_ do it, implement that, then teach cciss about
it, then try to ensure that new code uses the approved interfaces.  Over
time, people may (or may not) migrate existing code over to the new
interfaces.

They may also merge new code which uses open-coded hand-rolled stuff, too :(

> Is there even a valid use for CONFIG_LBD=n anymore, anyway?

Lots and lots and lots of systems don't have any disks larger than 2TB.

CONFIG_LBD=y gives us an additional 3kb of instructions on i386
allnoconfig.  Other architectures might do less well.  It's not a huge
difference, but that's the way in which creeping bloatiness happens.


From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: [PATCH] cciss: Fix warnings during compilation under
 32bitenvironment
Date: Fri, 20 Apr 2007 17:39:57 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
 <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
 <1176995934.31764.7.camel@mulgrave.il.steeleye.com>
 <226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
 <1176999730.31764.15.camel@mulgrave.il.steeleye.com>
 <558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
 <20070419222028.d33c7f86.akpm@linux-foundation.org>
 <1177074641.3718.5.camel@mulgrave.il.steeleye.com>
 <20070420114337.12a67141.akpm@linux-foundation.org>
 <1177095007.3718.43.camel@mulgrave.il.steeleye.com>
 <20070420123041.94aac1e1.akpm@linux-foundation.org>
 <1177100459.3718.45.camel@mulgrave.il.steeleye.com>
 <20070420141218.a0222472.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1767274AbXDTVkQ@vger.kernel.org>
In-Reply-To: <20070420141218.a0222472.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Cameron, Steve" <Steve.Cameron@hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 20 Apr 2007, Andrew Morton wrote:

> On Fri, 20 Apr 2007 16:20:59 -0400
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Fri, 2007-04-20 at 12:30 -0700, Andrew Morton wrote:
> > > On Fri, 20 Apr 2007 14:50:06 -0400
> > > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > > 
> > > > > CONFIG_LBD=y gives us an additional 3kb of instructions on i386
> > > > > allnoconfig.  Other architectures might do less well.  It's not a huge
> > > > > difference, but that's the way in which creeping bloatiness happens.
> > > > 
> > > > OK, sure, but if we really care about this saving, then unconditionally
> > > > casting to u64 is therefore wrong as well ... this is starting to open
> > > > quite a large can of worms ...
> > > > 
> > > > For the record, if we have to do this, I fancy sector_upper_32() ... we
> > > > should already have some similar accessor for dma_addr_t as well.
> > > 
> > > hm.  How about this?
> > > 
> > > --- a/include/linux/kernel.h~upper-32-bits
> > > +++ a/include/linux/kernel.h
> > > @@ -40,6 +40,17 @@ extern const char linux_proc_banner[];
> > >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > >  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > >  
> > > +/**
> > > + * upper_32_bits - return bits 32-63 of a number
> > > + * @n: the number we're accessing
> > > + *
> > > + * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
> > > + * the "right shift count >= width of type" warning when that quantity is
> > > + * 32-bits.
> > > + */
> > > +#define upper_32_bits(n) (((u64)(n)) >> 32)
> > 
> > Won't this have the unwanted side effect of promoting everything in a
> > calculation to long long on 32 bit platforms, even if n was only 32
> > bits?
> 
> bummer.
> 
> > > +
> > > +
> > >  #define	KERN_EMERG	"<0>"	/* system is unusable			*/
> > >  #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
> > >  #define	KERN_CRIT	"<2>"	/* critical conditions			*/
> > > _
> > > 
> > > It seems to generate the desired code.  I avoided Alan's ((n >> 31) >> 1)
> > > trick because it'll generate peculiar results with signed 64-bit
> > > quantities.
> > 
> > I've seen the trick done similarly with ((n >> 16) >> 16) which
> > shouldn't have the issue.
> 
> That works if we know the caller is treating the return value as 32 bits,
> but we don't know that.
> 
> If we have
> 
> #define upper_32_bits(x)  ((x >> 16) >> 16)
> 
> then
> 
> 	upper_32_bits(0x8888777766665555)
> 
> will return 0x88887777 if it's treated as 32-bits, but it'll return
> 0xffffffff88887777 if the caller is using 64-bits.
> 
> I spose
> 
> #define upper_32_bits(x)  ((u32)((x >> 16) >> 16))
> 
> will do the trick.

What about this?

#define upper_32_bits(x) (sizeof(x) == 8 ? (u64)(x) >> 32 : 0)

The u64 cast prevents the sign bit from being carried over and therefore 
eliminates the need for a subsequent cast to u32 since the upper 32 of the 
result will be 0. Shouldn't be any case where an integer gets promoted if 
64 bits is the largest possible promotion.

Assuming, of course, I'm not an idiot. Which I somewhat frequently am.

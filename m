From: Tejun Heo <tj@kernel.org>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 18:20:54 +0100
Message-ID: <20110117172054.GJ27123@htj.dyndns.org>
References: <20110113192558.GE16039@MAIL.13thfloor.at>
 <20110114142018.GA978@htj.dyndns.org>
 <20110114165957.GH16039@MAIL.13thfloor.at>
 <20110114170407.GE978@htj.dyndns.org>
 <20110114173759.GI16039@MAIL.13thfloor.at>
 <20110117154042.GG27123@htj.dyndns.org>
 <1295281131.3015.44.camel@mulgrave.site>
 <20110117171312.GL16039@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110117171312.GL16039@MAIL.13thfloor.at>
Sender: linux-ide-owner@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 17, 2011 at 06:13:12PM +0100, Herbert Poetzl wrote:
> > So perhaps it should be. If you look at the equivalent topology on
> > SAS, our expanders have a bsg device node precisely so that we can do
> > this.
> 
> I agree, the PMP should get a device or at least some kind of
> interface to address them, especially as the SATA topology can
> get quite complicated too, for example it seems that PMPs can
> be daisy chained in an infinite sequence like this
> 
>        /      /      /
>  --[PM]---[PM]---[PM]-- - -
>        \      \      \

Oh, no, that's not allowed.  You can't address destinations that way.
PMP is primarily a switch, not a router.

> > Sure, as long as it speaks standard ses-2, there shouldn't be a
> > protocol problem. The main problem is recognition: ses has to bind
> > to an enclosure device. It can bind either to an explicit device
> > (about all the enclosures I've seen so far) where the ses device has
> > a separate address in the SCSI topology or an implicit device (where
> > another SCSI device indicates it has an enclosure port embedded in
> > it). As currently coded, our ses driver only does the former probably
> > the best way is to expose the ses device via libata and we'll simply
> > bind to it.
> 
> so AHCI em_messages use standard ses-2 or did I misinterpret
> this (for me cryptical) information?

AFAIK, it just doesn't care.  It could be ses-2 or whatever else.  It
just transmits the binary blob it receives via sysfs and vice-versa.

Thanks.

-- 
tejun

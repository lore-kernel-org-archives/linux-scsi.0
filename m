From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Wed, 11 Dec 2002 09:08:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1313340000.1039622906@aslan.scsiguy.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021211153935.A23704@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

>> Why is this based on Alpha1 and not Alpha2.
> 
> Because that's a) what James put in the BK tree and b) that's what I
> downloaded from your website today for reference.

Where did you download it from.  This file is Alpha2 based:

http://people.FreeBSD.org/~gibbs/linux/SRC/aic79xx-linux-2.5.tar.gz

>> driver has to build all the way back to 2.4.7 (RedHat 7.2 support).
> 
> RedHat only supports kernel 2.4.18 for RH7.2/i386 and 2.4.9 with tons of
> hacks for the other arches, so your argument is void.

Tell that to the OEMs that Adaptec has to support.  They still test and
require 7.2 drivers.

> Not to mention the
> only support that is dropped by my changes is for builtin support <
> 2.2.18.

I'll have to verify that.

>> Removing ifdefs just makes it harder for me to merge in changes from
>> external trees.  Yes, the ifdefs are ugly, but so is the Linux SCSI layer
>> and the unmanaged way that interfaces have been changed without any
>> consideration to backwards compatibility (eg. the HIGHIO stuff could have
>> been done with 0 impact to drivers, but wasn't for some strange reason).
> 
> linux driver interface change between stable series, face it.

I have no problem with interfaces changing for good reason, but, for
example,
a driver that alread sets unchecked_isa_dma to 0 and uses the PCI dma mask
shouldn't have to set addition flags (with different names in different
vendor's trees) to enable HIGHIO.  It's yet-another *stupid* interface
change.

> And a driver with tons of ifdefs is utter crap.

I agree with that, but since we have to build for something like 35
different
kernel versions (major vendor releases plus all of their errata), there is
not much choice as a vendor.  Without the ifdefs, one of those builds 
invariably gets broken by a minor driver update because the person doing
the update doesn't understand how their change will effect the support for
the other kernels.

> Interestingly only vendor driver use that shitty scheme.

Yes, because the vendor actually has to support all of those versions
unlike some guy who hacks this stuff in his spare time and could care
less about anyone else's requirements but his own.  So your choice becomes
either accept the ifdefs so that the vendor can sell its products by meeting
OEM/Channel demands, or have the vendor exit the Linux market and not even
attempt to support their product.

--
Justin

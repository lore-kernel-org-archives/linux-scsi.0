From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Wed, 11 Dec 2002 13:23:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1335910000.1039638215@aslan.btc.adaptec.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
 <1221760000.1039627865@aslan.btc.adaptec.com>
 <20021211181745.A30253@infradead.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021211181745.A30253@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> On Wed, Dec 11, 2002 at 10:31:05AM -0700, Justin T. Gibbs wrote:
>> Okay.  Sine the choice directive is now gone, is there a compelling
>> reason to put the "old" aic7xxx driver Kconfig directives in the same
>> Kconfig file as the new driver?
> 
> I wanted to have it just below the other one.

Well, what I originally did was split the Kconfig into Kconfig.aic7xxx
and Kconfig.aic79xx and source both of them.  Assuming the choice syntax
worked as expected, this should have allowed me to choose between the
new and old driver and just have the aic79xx driver handled separately.
I never got the choice stuff to work, so I punted.  I'd rather have the
split Kconfig's than have the aic7xxx_old stuff in the new driver's
Kconfig source.

>> It is kind of nice to have the separation since
>> Adaptec cannot support the old driver.
> 
> Well, it usually just works (TM) :)  But I don't really see a relation
> between Kconfig entries and what's supported by whom.  The MAINTAINERS
> file in the toplevel directory is the only place where certain drivers/
> subsystems are claimed supported.

I just mean in terms of having to maintain any new or changed settings
for Doug's driver in the Kconfig file that is largely for the new driver.
It just creates another point of coordination.

> I also take it that you were also
>> unable to make the choice directive do the right thing?  That was the
>> original reason for removing the "old driver" Kconfig directives.  The
>> way your patch stands now, I don't believe there is anything to prevent
>> both drivers from being compiled statically into the kernel.  If so, the
>> resulting kernel will not boot.
> 
> Yupp, it currently crashes when I have both compiled in.  Dough, any
> chance you could fix that?  A PCI driver is not supposed to stop over
> already claimed device.

If you use the sanctioned PCI entry points, the PCI code seems to take
care of this.  Unfortunately, aic7xxx_old still manually pokes at devices.
The bug will have to be fixed there.

> I'll try to find out how to get the old depency for both not beeing
> allowed to be compiled in into the new Kconfig scheme until then.

Okay.

--
Justin


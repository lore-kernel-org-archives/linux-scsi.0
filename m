From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [2/5] Improve 53c700 /proc/interrupt output
Date: Sat, 19 Mar 2005 16:23:07 +0000
Message-ID: <20050319162307.GM21986@parcelfarce.linux.theplanet.co.uk>
References: <20050319035626.97A54496108@palinux.hppa> <1111247587.5525.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30182 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262587AbVCSQXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 11:23:08 -0500
Content-Disposition: inline
In-Reply-To: <1111247587.5525.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <willy@parisc-linux.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Mar 19, 2005 at 09:53:07AM -0600, James Bottomley wrote:
> On Fri, 2005-03-18 at 20:56 -0700, Matthew Wilcox wrote:
> > Request the IRQ in the name of the chip rather than the bus address.
> 
> This I don't really like for two reasons:
> 
> 1) I don't know of any other driver that uses the actual chip name in
> the interrupt (most use either the driver name or the module name)

I'm fine with that.

> 2) As someone with a large number of these things in a single box,
> knowing which actual device is going up in /proc/interrupts is valuable
> to me

You can get that information through /sys ...

# for i in /sys/class/scsi_host/*; do echo -n "`basename $i` "; irq=`cat $i/device/../irq`; grep $irq /proc/interrupts; done
host0  67:      11349             CPU  zalon
host1  68:         15             CPU  zalon
host2  16:         50        GSC-ASIC  53c710

> How about I look at abstracting the name so that the glue driver (in
> your case lasi700) can set the name?

That would work too ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

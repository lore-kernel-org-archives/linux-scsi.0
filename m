From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Tue, 2 Oct 2007 16:47:40 -0700 (PDT)
Message-ID: <842443.13470.qm@web31811.mail.mud.yahoo.com>
References: <46FC38F2.2070206@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:43370 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753124AbXJBXrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 19:47:41 -0400
In-Reply-To: <46FC38F2.2070206@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

--- Jeff Garzik <jeff@garzik.org> wrote:
> Michael Reed wrote:
> 
> > as having a unique WWN should be a product requirement, is an indicator of
> > a problem.  Shouldn't the proper solution be to have the card repaired?
> > Arbitrarily assigning a WWN could mask or introduce other problems, in particular
> > with regard to storage connectivity.

This is absolutely correct.

> If you are an admin suffering from the /common/ problem of missing or 
> invalid NVRAM, would you rather wait for card repair or get it going 
> immediately?

If you have a SAS HA, and it is missing its NVRAM (erased, etc), then
this is something catastrophic, and you have much bigger problems to solve
than just to "generate" a WWN.

It is extremely, extremely *uncommon* for SAS HA to be missing their
manufacturing sector/NVRAM, for products out in the field.  Internally
bound HAs, for testing, validation, etc, may be missing their MS/NVRAM,
but those products are never supposed to leave the testing/validation
process, without the "packager" writing their MS/NVRAM into the device.

> The standard Linux policy for unique ids like ethernet MAC has been, for 
> the 98% case where you have a useful MAC from the hardware, of course 
> use it.  For the 2% case, you give the admin solutions for supplying a 
> useful MAC.

So the same rule of principle applies to SAS HAs, to quote:
   "you give the admin solutions for supplying a useful WWN [was: MAC]"

If the SAS HA does NOT have a WWN, then you'll just complain in the
kernel log, and not start it up, unless the admin has provided one
via kernel/module parameter.

In the case where a WWN is missing, it is essential that userspace
provides a WWN to the driver, possibly via a kernel/module parameter,
and then the driver will use that WWN to assign to the HA.

But you MUST NOT establish policy by "generating" it internally in the
kernel.  I know it would be "cool", but it is unsound.  So instead,
establish mechanism.

> Mirroring decades of ethernet NIC history, the HBA silicon and the 
> source of the unique id are most often vastly different.  Normally it is 
> a different chip on the same board, but sometimes the unique id source 
> is not on the same board at all.
> 
> For those reasons and more, Linux users have a LONG history of running 
> into situations where, for one reason or another, their silicon is fine 
> but their unique id is not.  I've heard them all:
> 	- hw from government auction, had NVRAM intentionally wiped
> 	- hw resale w/ NVRAM wiped by paranoid corporate IT staff
> 	- hw with NVRAM chip missing
> 	- old hw out of warranty
> 	- old dev kit (they rarely ship with useful NVRAM data)
> 	- and plenty more
> 
> We have to behave sanely in the 2% case.  "refuse to operate" is just 
> not an option, when this problem case is so historically clear, and so 
> easy to work around.
> 
> Linux drivers have to continue operating long after support contracts 
> run out, long after chip EOL, and sometimes, long after companies go out 
> of business.

This still does not justify "let's generate it in the kernel".
If the MS/NVRAM is missing and thus there is no hw WWN, then it
should be left to the admin to provide one via a kernel/module option.

   Luben


From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: Patches for SCSI scanning
Date: Thu, 22 Apr 2004 06:09:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF27C5FFAA.EA9F440A-ONC1256E7D.0083C7A7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29346 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S263183AbUDVEJf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 00:09:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>





> On Tue, Apr 20, 2004 at 11:08:49AM -0500, James Bottomley wrote:
> > This looks like it needs fixing in our lun mapping support, doesn't it,
> > rather than trying to work around it with a flag?
>
> Any ideas?
> We need to use full 8byte LUNs then.
> * We can use them as opaque handles. Clean, but resulting in crazy
numbers
>   which sysadmins will hate us for.
> * Reorder the bytes as currently done, but for all 8 of them. Less clean
>   conceptually, but resulting in low LUNs and not changing the behaviour
>   for already supported devices.
>
> I'm in favour of the second solution.

Yes, full-size LUNs as opaque handles is the right way.

Just have the mid-layer store the 64 bit value that the device
reports on REPORT_LUNS. Then, transports that do not allow us to simply
copy a given 64 bit value into some sufficiently sized field
used to address LUNs pick whichever bits of a 64 bit LUN
they are interested in. SCSI documents must have made provision for this
sort of "compression", which makes perfectly sense for _these_ transports.

But there is no reason to punish other transports by mutilating their
LUNs and by forcing them to make guesses about what was cut away. To all
performance fetishists: What an avoidable effort it is to recover a 64
bit LUN from a compressed 32 bit value by shifting and swapping and padding
bits and bytes for each SCSI command to be issued!

Let's retain the full-size LUN by default and allow transports to
to derive a reduced variant, if appropriate. I am all for tranport specific
helper
functions doing that, instead of requiring each parallel SCSI driver
providing its
own (potentially buggy) routine. This should be done once, if applicable,
i.e. when the midlayer has spotted a new LUN. A smaller LUN might be
derived
either by calling into the lldd for that purpose, or by having the midlayer
call some transport specific helper function directly - controlled by some
scsi_host_template flag. There might be even more elegant ways. You name
it.

As to sysfs and friends, we can then choose to either always pick the
fullsize
64 bit LUN, or the <=64 bit LUN appropriate for a particular transport /
lldd.
I would not object to the latter.

Actually, we concluded that 64 bit LUNs are the way to go earlier on
linux-scsi
(http://marc.theaimsgroup.com/?l=linux-scsi&m=104258317622498&w=2)
And there was some guy who was about to volunteer for that task,
but did not come around to it, but tied up by 2.4 maintenance, alas.

However, want a patch? :)

Cheers,
Martin


Kurt Garloff <garloff@suse.de>@vger.kernel.org on 21.04.2004 15:48:46

Sent by:    linux-scsi-owner@vger.kernel.org


To:    James Bottomley <James.Bottomley@steeleye.com>
cc:    Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton
       <akpm@osdl.org>
Subject:    Re: Patches for SCSI scanning



On Tue, Apr 20, 2004 at 11:08:49AM -0500, James Bottomley wrote:
> This looks like it needs fixing in our lun mapping support, doesn't it,
> rather than trying to work around it with a flag?

Any ideas?
We need to use full 8byte LUNs then.
* We can use them as opaque handles. Clean, but resulting in crazy numbers
  which sysadmins will hate us for.
* Reorder the bytes as currently done, but for all 8 of them. Less clean
  conceptually, but resulting in low LUNs and not changing the behaviour
  for already supported devices.

I'm in favour of the second solution.
Want a patch?

Regards,
--
Kurt Garloff  <garloff@suse.de>                            Cologne, DE
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)




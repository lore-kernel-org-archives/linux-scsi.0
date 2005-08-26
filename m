From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 14:16:47 -0400
Message-ID: <430F5C8F.3030708@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>	 <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com>	 <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>	 <430F46AA.2050305@adaptec.com> <1125076960.5079.61.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:26063 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965165AbVHZSQv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 14:16:51 -0400
In-Reply-To: <1125076960.5079.61.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 08/26/05 13:22, James Bottomley wrote:
> On Fri, 2005-08-26 at 12:43 -0400, Luben Tuikov wrote:
> 
>>>A move away from forced HCIL addressing would be a good thing.
>>>
>>>However, its impossible to completely move away from addressing, as 
>>>userspace and the SCSI core need ways to route CDBs to devices based on 
>>>address.
>>
>>They can use _anyone_ label in the label list of the LU.
> 
> 
> I think what Jeff means is that the mid-layer needs to know which LLD to
> send the CDB to.

No, I thought he meant about user space apps, *NOT* SCSI Core.

Since, the transport found the device on the domain (NOT LU!)
it then calls SCSI Core to register it.

So you have:

task->scsi_domain_device->lldd->lldd_execute_task(task).

> This is the routing information (and is really just
> the host number).

No host numbers, no routing information.  This is all
transparent to SCSI Core, and NONE of its business.

> The LLD takes the rest of the information to work out
> where it's sending the CDB.  For SPI this is often just PUN and LUN.
> For FC it's usually WWPN and LUN.  Currently the information we send
> down is the endpoint, represented by the scsi_device.

Hmm, ok here we go again: FC details, SPI details, etc.

Just think about this: FC and iSCSI and USB and FireWire
_invent_ the HCIL tuple.  I repeat, they _invent_ it,
only to accomodate the ancient SCSI Core stack.

SCSI Core should know about "struct scsi_domain_device *dev".
It uses _that_ and the LUN to send a CDB to a device.
Here is the tuple:
   (struct scsi_domain_device *dev, LUN)

Please do not mention FC ro SPI details anymore.  If you do,
then you have to mention ALL possible transports' details:
including *but not limited to*: Infiniband, SAS, iSCSI, USB
FireWire, etc.

Shall we keep them separated?

>>The label itself is opaque to SCSI Core.  It may mean something
>>to users, it may mean something to the protocol layer, but to
>>SCSI Core it is completely opaque, and SCSI Core should _not_
>>try to interpret it/them.
> 
> Labelling devices is policy.  That's the bit we're trying to push up to
> the user via tools like udev.  The routing information we need is
> already inherent in the structure of the scsi generic device tree. So,
> by and large, the mid layer doesn't care what the numbers contained
> within the struct scsi_device are.  It just uses a scsi_device to send a
> CDB.  The LLDs however, do care.  SPI LLDs want to find channel, id
> (target) and lun numbers.  FC drivers map id to wwpn internally and so
> would probably quite like a way of sticking the wwpn into the id instead
> of having a fictitious number.

1. I don't get it.
2. Why are you _again_ messing with transport layers and mentioning their
   details?
We all appreciate you knowledge of FC and SPI, but it is completely
irrelevant for this discussion.

LLDDs will set the (non-existant yet) void *lldd_dev pointer appropriately
in the scsi_domain_device struct.  They will _never_ know about LUs.

> The point is that labels are user policy and managed at user level.  The

Not _all_ labels.

As I said, I repeat: a storage vendor has names on the front of their
storage box: Dopey, Sleepy and Bashful of the 3 huge mega disks they
store in there.

How would you know which is which in the OS?  If the OS reports an
error to one of the disks, but the storage controller says everything
is ok, how would you map the HCIL to Dopey, Sleepy or Bashful?

Been there, done that.

Think about this: up until now, we've _inherently_ known the mapping
between /dev/sdX and the actual hardware disk in our system.

This is no longer the case when you have remote or pseudo-remote
storage, plus the fact that someone _packaged_ it for you in a nice
shiny box.  What if you have to go through 2 expanders, an FC bridge,
another, and another expander to get to the device which is enclosed in
a black box which you cannot easily open and see the WWN (which again
is just another _label_)?  But can freely look at the front and see
the names Dopey, Sleepy and Bashful?

For all those reasons, I say that labels are property of the object
and _each_ layer can add a label to the object: from the transport
to the FS, to again repeat myself.

> representations used in the generic device tree shows what the kernel
> actually uses and should be the preferred form for the transport.

So what will the kernel actually use?

Look at here: each layer adds their own label: /dev/sda, LABEL=/,
WWN, etc, etc.

Each layer communicates with the object by the label _it_ gave,
since _that_label_ makes sense to it.

> So what's really needed is a scheme that allows the LLDs to use the id
> transparently without having to map it to what they really want while

No, I completely and wholeheartedly disagree.  HCIL _must_ go away.

> not breaking all the current SPI users (or which patches up every SPI
> driver).

I agree, current SPI users shouldn't be affected.

	Luben


From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sat, 20 Aug 2005 13:23:04 -0400
Message-ID: <430766F8.1090100@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17564 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932585AbVHTRXV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Aug 2005 13:23:21 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/20/05 00:15, James.Smart@Emulex.Com wrote:
> Ok, so I guess I owe you a response. I hesitate, as this discussion
> always becomes larger than it should.
> 
> There are 2 key points:
> - the target id is logical for everything but SPI
> - following old SPI behavior, users expect the same devices to
>   be enumerated at the same target ids, regardless of whether
>   that enumeration is at the next link event, driver load/unload,
>   or system reboot. The corollary for this is that the device's
>   name should have remained the same as well.

I don't mind LLDD giving channel and id to SCSI Core.  Not at all.
What I mind is the _way_ it is done.

Just consider this (and I'm sure you have the same sentiments):
slave alloc gives you channel and id and lun/2 to find out
the device it wants to poke at...  And the really sad part is
that NO ONE at linux-scsi finds this objectionable.   This should've
been thrown out 5 years ago (well slave alloc wasn't around then)
when iSCSI was making its way in, and when people suggested it.
Sadly it was shot down by the Maintainers and this is what we
have here today.

> For FC, target ids are typically assigned to devices on a
> 1st-seen-1st-assigned basis. For several reasons, there can be
> changes in port discovery order after link events (cable pulls,
> etc). For 2.4 kernels, the driver typically maintained a mapping
> within the driver to ensure the same device showed up at the same
> target id, even if it disappeared for some amount of time. If FC
> was the boot device, wacky methods were used to ensure the mapping
> persisted boot-to-boot.

This is all _fine_ and I don't mind it at all.

> For SAS, looking at Christoph's code - 
> The target id comes from the LLDD. So either the LLDD maintains a
> map of SAS port addresses to target ids, or the mapping could change,
> same as FC. Christoph's argument is that FC's issue was historical.
> SAS is sufficiently new that folks are now smart enough to use udev.
> My contention is that people will expect the same behavior out of
> SAS as they did w/ FC. To them its all "just SCSI".

Ok, to answer both your and Jeff's email, this is how this all is done:

Let, (channel, id) tuple be *just another label*!

For a domain device or LU in a domain device you can have a myriad of
labels, depending on a myriad of things, like
	- how you got to the device
	- what transport you used to get the device
	- what kind of device it actually is,
	- what kind of interrogation methods it replies to,
	- what kind of VPD it has if any,
	- what the Command Set driver named it (sdX, stX),
	- etc.

Now, the function of a LLDD is to provide access to the
transport, this is done by the LLDD implementing SAM's
Execute Task and the TMFs.

Next, the transport layer uses those to interrogate the domain
the LLDD provides access to and find out any domain devices.
Each domain device is then registered with SCSI Core,
using something like a "struct domain_device".

Now _that_ "struct domain_device" can have as many and as varied
_labels_ as you want: (channel, id), WWN, Funky name1, Funky name2,
name given by the Command Set driver, which as kept in the
struct domain_device.

Then you expose _those_ labels to user space and let programs
use whatever label they want.  The kernel itself can use
the struct domain device to address the device, but anyone
else from user space can use one of the labels: WWN, (channel,id),
etc.

This will give you backward compatibility, plus it would allow
for SCSI Core to be completely rewritten in the spirit of
SAM and enter the 21 century.

	Luben


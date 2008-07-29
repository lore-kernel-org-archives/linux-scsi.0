From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Subtle but oops causing problem with class_device->device
	conversion
Date: Tue, 29 Jul 2008 13:06:30 -0500
Message-ID: <1217354790.6103.36.camel@localhost.localdomain>
References: <1217353348.6103.20.camel@localhost.localdomain>
	 <1217354388.31362.2.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60364 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbYG2SG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 14:06:58 -0400
In-Reply-To: <1217354388.31362.2.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2008-07-29 at 19:59 +0200, Kay Sievers wrote:
> On Tue, 2008-07-29 at 12:42 -0500, James Bottomley wrote:
> > It's taken me a while to track this down.  Basically there's an oops in
> > scsi_transport_spi that's directly caused by this.
> > 
> > What happened is that you made all class devices become real devices and
> > be parented to devices they were formerly allied to through the class
> > device dev pointer.  This means that effectively you expanded the child
> > list of every device to include not only its real children but also its
> > class devices.
> > 
> > This breaks in device_for_each_child *if* the routine in the iterator
> > doesn't perform checks on the devices it gets back (scsi_transport_spi
> > was assuming that every device it got was embedded in a struct
> > scsi_device because they're the only logical children of a scsi_target).
> > 
> > I can fix the SCSI breakage, but the whole tree will need auditing to
> > check that nothing else is using this assumption.
> 
> I guess it's caused by:
>   [SCSI] add scsi_host and scsi_target to scsi_bus
> 
>   This patch implements scsi_host and scsi_target device types
>   and adds both to the scsi_bus.
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b0ed43360fdca227048d88a08290365cb681c1a8
> 
> and not by the re-parenting, so it should be limited to SCSI, right?

No .. read the email.  It's caused by adding extra children to the
device via the class_device conversion.  device_for_each_child doesn't
care what the type is (although that might be a potential generic fix
for this).

So, it's definitely not confined to SCSI.

James



From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: RE: suspending I/Os to a device
Date: Mon, 26 Apr 2004 10:12:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E704E37A88@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61331 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263301AbUDZRNc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2004 13:13:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>


So it may be better to make this a hotplug feature since it is not
necessarily FC specific? When the FC driver gets a LIP or RSCN event, there
is potential for a device to be removed, or a new device added. In addition
to add / remove if there was a suspended state the device could put in,
assuming it would transition to added or removed shortly afterwards, that
would also meet the requirements for FC.

--
Jon Infante
Emulex


-----Original Message-----
From: Patrick Mansfield [mailto:patmans@us.ibm.com]
Sent: Monday, April 26, 2004 9:40 AM
To: James Bottomley
Cc: Infante, Jon; Linux SCSI Reflector
Subject: Re: suspending I/Os to a device


On Fri, Apr 23, 2004 at 07:28:30PM -0400, James Bottomley wrote:

> Actually, there is no interface because no-one has had any prior
> requirements for this.
> 
> This is effectively a FC specific thing, and I believe you know because
> you get a lip event telling you the target has gone, so it sounds like
> the ideal thing to handle in the FC transport class (since it would
> apply to all FC HBAs) The target reconnect timeout would then be a
> transport class property and we'd start failing I/Os when it expired.  I
> would guess there needs to be an additional state in the device state
> model like SUSPEND (QUIESCE doesn't quite fit because it allows the
> pending queue to drain and the error handler to operate), but we can
> accomodate that.

Attaching your USB or firewire device to another port is not much
different.

We should someday allow removal and re-attachment of any disk, or the
replacement of the transport (like hotplug pci card, or the cables),
without having to close or unmount the disk.

-- Patrick Mansfield

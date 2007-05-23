From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Un-remove aacraid devices
Date: Wed, 23 May 2007 13:56:56 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B91@otce2k301.adaptec.com>
References: <465438AD.8000406@suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B5C@otce2k301.adaptec.com> <1179940022.5569.7.camel@mulgrave.il.steeleye.com> <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B78@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:53466 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbXEWR5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 13:57:00 -0400
Content-class: urn:content-classes:message
In-reply-to: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B78@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Another note, the old old aacraid driver used to report removable device
in the inquiry. We found we could mitigate the devices report somewhat
by reporting a fixed dfisk inquiry, but turning on the removable bit for
the scsi device after the scan but before attachment by setting this in
the read capacity call. This hack showed the applications that we were a
fixed disk, but the OS responded as if we were a removable.

Hannes, which user space tools are having troubles with the removable
device designation?

-- Mark

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Wednesday, May 23, 2007 1:17 PM
To: James Bottomley
Cc: Hannes Reinecke; SCSI Mailing List
Subject: RE: [PATCH] Un-remove aacraid devices

The applications may issue the start of an expansion, but then
disappear. The Firmware is responsible for completing the job with the
help of the driver. We issue a scsi_rescan_device when the job is
completed, removable bit set turns off the capacity & partition table
caching.

We would need a similar exported kernel interface for the aacraid driver
to call after we receive the scan requests via the event (AIF) stream
from the Firmware. I can not propose adding a flag to
scsi_rescan_device, as that would change an interface, so a new call
scsi_rescan_device_blkrrpart?

We have external RAID enclosures that report they are removable devices
so that they may also transition through expansion. It is merely half a
lie; it does indicate that the media can change ;-}

-- Mark

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Wednesday, May 23, 2007 1:07 PM
To: Salyzyn, Mark
Cc: Hannes Reinecke; SCSI Mailing List
Subject: RE: [PATCH] Un-remove aacraid devices

On Wed, 2007-05-23 at 12:35 -0400, Salyzyn, Mark wrote:
> NAK
> 
> This will break all our management applications, and will not allow us
to manipulate the array configurations from within Linux. This will also
break online expansion of capacity.
> 
> This flag has been set from the beginning to allow partition tables,
capacity and device locking to be changed without requiring an
intervening reboot or needing the device to be taken offline. Fixed disk
result in these pieces of information being cached.

I thought this problem had been solved since at least 2000 (when
LifeKeeper ran into the same issue) by sending the BLKRRPART ioctl to
the device ... whether removable or not, this forces a reread of all the
vital information (always providing nothing has the nodes open, of
course, we can't physically yank the information out of applications
using it).

If there's something BLKRRPART isn't doing we can probably fix it ...
that's certainly better than lying to the kernel about the devices.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

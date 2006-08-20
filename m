From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Error 1 & scsi_add_device()
Date: Sun, 20 Aug 2006 11:38:17 -0500
Message-ID: <1156091897.3726.54.camel@mulgrave.il.steeleye.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F02B1CAAA@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14574 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750897AbWHTQi0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 12:38:26 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F02B1CAAA@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

On Thu, 2006-08-17 at 10:02 -0400, Salyzyn, Mark wrote:
> None of this leads me to believe there is any kref node corruption,
> but
> code could expect that if a device existed at the nexus and the
> subsystem acquired another reference to the node based on the nexus
> rather than the scsi_device, thus using scsi_device_lookup, that they
> would get an unexpected NULL pointer and choke. I have not inspected
> the
> code for such a path (yet), but feel we have risks in any case that
> need
> to be addressed.
> 
> The aacraid driver should stop calling scsi_remove_device when an
> array
> is deleted ... or ...
> 
> I believe what needs to be added is a check for sdev->sdev_state ==
> SDEV_DEL in __scsi_device_lookup_by_target and __scsi_device_lookup in
> scsi.c:

That would solve some of this... but that's not quite the whole of it,
unfortunately.  The error 1 problem is caused by the external namespace
visibility, which the SDEV_DEL check will prevent (the device only goes
into DEL after the namespace entry has been removed, so its now safe to
repopulate it with a new device).

However, there's a race you probably haven't come across yet where you
do the same thing and get a device in SDEV_CANCEL.  This means currently
visible but dying (i.e. the only state it's going from CANCEL is DEL).

To fix all of this, we probably need better state model checking in
probe_and_add_lun() plus a parameter that says "wait and create a new
device if this one is being removed" ... I suspect we can cannibalise
the rescan parameter for that.

James


The three relevant states in the model are SDEV_CREATED (this means the
device exists b


From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 16:49:21 -0400
Message-ID: <yq13a7zfl7y.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.0908101518020.4223-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:63775 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZHJUtk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 16:49:40 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908101518020.4223-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 10 Aug 2009 16:13:40 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

>> First of all we're not going to send EVPD=1 out to devices reporting
>> SCSI_SPC_2 or lower anymore, making some of this discussion moot in
>> the short term.

Alan> Ah.  Has this change been posted anywhere yet?

ffd4bc2a984fab40ed969163efdff321490e8032


Alan> Does Vista also do this querying?  I've got access to a machine
Alan> running Vista, so I can test the USB storage stack behavior.

Dunno.


Alan> How will Windows 7 deal with all those old buggy USB devices?
Alan> (You probably don't have any idea...)

Nope :)


Alan> No, there isn't.  There are USB device IDs, but they are assigned
Alan> more or less randomly by the manufacturers -- they don't form a
Alan> nicely increasing sequence of revision numbers.

But let's assume for a second that USB drives with 4KB physical blocks
will be USB 3.0.  I think that's a likely scenario.  Couldn't we do
something like?

   /* Dumb down SCSI level for USB 1.1 and 2.0 devices */
   if (le16_to_cpu(udev->descriptor.bcdUSB) <= 0x0200 
       && sdev->scsi_level > SCSI_2)
          sdev->sdev_target->scsi_level = sdev->scsi_level = SCSI_2;

I'm sure that won't catch all devices.  But it would at least be a step
in the right direction.  And if that breaks we can revisit.


Alan> Even worse, the device-reported SCSI rev. is completely
Alan> independent of the ID for the bridge chip, which is where the
Alan> failures seem to occur.  (Although it's hard to be certain which
Alan> component is failing.)

If the bridge doesn't provide the SCSI rev. where does it come from?  Or
are you saying there's a USB "target" chip and then a USB-SATA bridge
chip behind it?


Alan> I'm not keen on the idea of collecting more failure data by
Alan> changing the driver so as to cause failures!

I wasn't thinking a hard fail.  More like a:

  printk(KERN_ERR "Please mail this info to linux-scsi@vger...");

and have that sit in Fedora/Ubuntu for 6 months.

But if there's nothing we can key off of then there's no point.

-- 
Martin K. Petersen	Oracle Linux Engineering

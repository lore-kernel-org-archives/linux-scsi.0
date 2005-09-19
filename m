From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: SG_FLAG_LUN_INHIBIT broken?
Date: Mon, 19 Sep 2005 09:58:02 -0700
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BE20@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:14808 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S932501AbVISQ6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2005 12:58:04 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org


> 
> Timothy,
> No it doesn't work. It hasn't worked since the lk 2.2
> series. It has been renamed to:
> SG_FLAG_UNUSED_LUN_INHIBIT
> 
> Notice that addition of the _UNUSED_ . It is pretty old
> stuff, SCSI-2 commands reserved the 3 top bits in byte
> one for the lun. Nowadays luns are 64 bit quantities that
> are sent to the target outside the cdb which carries the
> SCSI command.
> 
> I thought it had been removed from the mid level, but ...
> 
> <...snip...>
> 
> The above code is a worry because a lot of devices
> just place 0 in the version (byte 2 of an INQUIRY
> response). Perhaps scsi_level in sysfs
> (/sys/class/scsi_device/<h:c:i:l>/device/scsi_level)
> should be writable.

The kernel makes no mention of it that I found, but it's
in a header and the original SG_IO docs so it makes it
seem like it exists.  In addition someone on the USB mailing
list pointed me to it a couple of days ago to solve the issue
I discussed in the original mail.

The USB devs don't seem to have interest in treating USB
devices as entities other than SCSI-2 because the devices tend
to lie about their revision and really only work with scsi-2
commands (according to them). So that knocks
/sys/class/scsi_device/<h:c:i:l>/device/scsi_level out of
the water since they want the device to stay scsi2.

If SG_FLAG_LUN_INHIBIT worked, this wouldn't be an issue
because even though these are seen as scsi2 devices,
for raw commands the LUN issue could be stopped.  However,
I'm still open to other solutions if SG_FLAG_LUN_INHIBIT
can't come back.

Regards,
Tim Thelin


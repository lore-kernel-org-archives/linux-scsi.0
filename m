From: Gal Rosen <galr@storwize.com>
Subject: SCSI device rescan, detection of disconnected device, or switched
	devices.
Date: Mon, 28 Jul 2008 15:32:28 +0300
Message-ID: <1217248348.4133.51.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:22357 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbYG1Mc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 08:32:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

=EF=BB=BFHello all,

=EF=BB=BF=EF=BB=BFI know that when adding new device there is no proble=
m;
by echo "- - -" >/sys/class/scsi_host/hostX/scan the SCSI subsystem wil=
l
recognize the new device and new /dev/sgX device will be created, but i=
f
someone remove a device, scan will only recognize that the report luns
has changed, but it will not remove the /dev/sgX device.
If now someone add new device it will mapped to the /dev/sgX that
previously mapped to the device that just removed.

1. Why the SCSI subsystem doesn't release devices that removed ?

2. In the situation that I described above someone can switched devices
without notifying the application that use those devices. The
notification will come only when the next SCSI command will return with
unit attention saying "Power on, reset, or bus device reset occured", o=
r
if device just removed without adding new device it will return
"Reported luns data has changed".
If I have an application that control SCSI devices using sg driver and =
I
would like to have the ability to change configuration online, what is
the preferred way to rescan the bus and update the application that sgX
that previously controls device Y is now controlling device Z ?
In other words, what is the best way for the application to identify
that device has been removed or changed ?

3. I am using Qlogic firmware ability to create virtual ports, and I
notice that on disconnect and then reconnect the FC cable, the sg
mapping can changed. If on module load the physical port got sg0, and o=
n
creating vport it got sg1, now the SCSI subsystem scans the vport first
and mapped it to sg0 and the physical port gets sg1.
Is there a way to control the mapping (scanning) ?

Best regards,
Gal Rosen
Senior Software Engineer
www.storwize.com

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

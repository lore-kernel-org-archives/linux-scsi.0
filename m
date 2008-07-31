From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SCSI device rescan, detection of disconnected device, or	switched
 devices.
Date: Thu, 31 Jul 2008 10:34:52 +0200
Message-ID: <4891792C.6020304@s5r6.in-berlin.de>
References: <1217248348.4133.51.camel@galr-linux>	 <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40121 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYGaIfo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 04:35:44 -0400
In-Reply-To: <1217487434.25491.34.camel@galr-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: linux-scsi@vger.kernel.org

Gal Rosen wrote:
> I will try to make my question more clear.
> I would like to put a box between the client and the storage, and to be
> fully transparent against the host. All changes on the storage
> (add/remove/extend devices) should be present automatically to the
> client. In a direct connection between client and storage the
> administrator will coordinate between the client and storage before
> making any changes, in my configuration I do not want to add
> administration work on my box that stands between the client and the
> storage.
> Addition is simple, the application on my box can once in a while scan
> the SCSI BUS, and then the Linux system will create new sg devices.
> In removal of a device the Linux system will not remove sg devices after
> scan. In that case again I can do it from my application, such when I
> get attention on SCSI command, I can decide to remove the device by
> echoing to the /sys file system.

I really don't know how the FibreChannel drivers handle device removal.
But from what I gather from the documentation of
fc_remote_port_delete(), which the qla2xxx drivers use, the /dev/sg
devices should automatically disappear
  - after a connection loss timeout,
  - provided that userspace doesn't have the device file opened
    (among else this is manifest in the kernel in a reference count of
    the logical unit device representation),
  - provided that you manage your device files with udev.

http://lxr.linux.no/linux+v2.6.26/drivers/scsi/scsi_transport_fc.c#L2756

That would be basically just like SCSI device files are created and
destroyed on the fly for USB or FireWire devices for example.  Except
that FC has the additional configurable connection loss timeout which
hides temporary connection losses from applications.

(However, better wait for an answer of somebody who actually uses FC or
knows the drivers.  I only have experience with FireWire.)
-- 
Stefan Richter
-=====-==--- -=== =====
http://arcgraph.de/sr/

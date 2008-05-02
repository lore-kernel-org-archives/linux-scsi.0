From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SCSI state model, and "soft" host removal
Date: Fri, 02 May 2008 18:19:00 +0200
Message-ID: <481B3EF4.9070605@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0805011615430.2186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44209 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082AbYEBQTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:19:41 -0400
In-Reply-To: <Pine.LNX.4.44L0.0805011615430.2186-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> Second, concerning soft host removal...  I have in mind a situation
> where a user wants to unbind usb-storage from a device in a clean, safe
> manner, without unplugging anything.  Existing commands should be
> allowed to complete, caches should be flushed, and so on.  Is there any
> way to do this?

I haven't tried it with usb-storage, or any other SCSI low-level driver, 
but here is something which works with sbp2 or firewire-sbp2:

# readlink /sys/bus/scsi/devices/2\:0\:0\:0
../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:02.0/fw2/fw2.0/host2/target2:0:0/2:0:0:0

# readlink \
/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:02.0/fw2/fw2.0/driver
../../../../../../../bus/firewire/drivers/sbp2

# echo -n fw2.0 > /sys/bus/firewire/drivers/sbp2/unbind

This results in:
May  2 17:43:54 stein sd 2:0:0:0: [sdd] Synchronizing SCSI cache
May  2 17:43:54 stein firewire_sbp2: released fw2.0, target 2:0:0

The code which does this is is of course the struct driver.remove 
callback of fw-sbp2.c.  This or another place in fw-sbp2.c drops the 
last reference on the SBP-2 target representation, and 
sbp2_release_target() is called.  This looks up all struct scsi_device 
instances which belong to the target and performs
	scsi_remove_device(sdev);
	scsi_device_put(sdev);
on them.  This causes, among else, calls to the .shutdown() method of 
the SCSI highlevel driver which is bound to the device, e.g. 
sd_shutdown() which among else sends a SYNCHRONIZE CACHE command if 
applicable.

After that, the Scsi_Host is being removed because we (currently) 
instantiate one Scsi_Host per target, not one per initiator port.

Almost the same happens in drivers/ieee1394/sbp2.c, except that this one 
has simply one Scsi_Host per logical unit (i.e. per scsi_device) rather 
than per target.

> It used to be that scsi_remove_host() would cancel all outstanding
> commands.  Isn't that still true?  If so, is there any way to
> accomplish what I want?

Previous iterations of sbp2 and firewire-sbp2 had, independently of each 
other, also simply calls to scsi_remove_host() without previous 
scsi_remove_device().  I believe the semantics of scsi_remove_host() 
changed though over the time... and I gather this is why you are asking 
in the first place.

I don't remember how scsi_remove_host() behaved when.  I only see in the 
git history that I added the scsi_remove_device() in sbp2.c between 
2.6.14-rc2 and -rc3.  I did this with the explicit goal to support "soft 
removal" like you are asking for for usb-storage.
-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/

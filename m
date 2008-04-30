From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Hack to fix not working spindown over Firewire
Date: Wed, 30 Apr 2008 15:31:41 +0200
Message-ID: <481874BD.5010807@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33609 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYD3Ncs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 09:32:48 -0400
In-Reply-To: <20080429232606.GA14261@dose.home.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Tino Keitel wrote:
> I like the manage_start_stop feature of the SD driver to spin down the
> hard disks (SATA and USB) during suspend. However, it didn't work with
> my Firewire hard disk.
> 
> After some research I found out that I can spin down the disk with
> sg_start --pc=2, and spin it up with sg_start --pc=1. I adopted this
> into sd_start_stop_device() with the vendor name of the device
> hardcoded (see the attached patch) and now my Firewire hard disk spins
> down on suspend and spins up on resume.
> 
> Is there any chance to get this behaviour without such ugly changes to
> the kernel? I had to make it conditional by checking the device as
> otherwise the SATA disk reports an error.
[...]
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1788,8 +1788,16 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  	struct scsi_device *sdp = sdkp->device;
>  	int res;
>  
> -	if (start)
> +	if (start) {
>  		cmd[4] |= 1;	/* START */
> +		if(!strncmp(sdp->vendor, "WDC WD32", 8)) {
> +			cmd[4] |= (1 << 4); /* power condition */
> +		}
> +	} else {
> +		if(!strncmp(sdp->vendor, "WDC WD32", 8)) {
> +			cmd[4] |= (2 << 4); /* power condition */
> +		}
> +	}
>  
>  	if (!scsi_device_online(sdp))
>  		return -ENODEV;

For LKML:  There was previous discussion on linux1394-user and LSML.
http://marc.info/?t=120720546800001
The enclosure is a Raidsonic ICY Box.

Responsible for the spindown behavior is the IDE-to-FireWire bridge
controller which is a Prolific PL-3507, and its firmware which is
different from the USB firmware.  Also, there are different firmwares in
the wild for PL-3507.

The sdp->vendor string is assembled by the firmware from data gathered
from the IDE device.  It is therefore not suitable to detect affected
devices.

The traditional way to handle things like this is:

   - Implement this as a workaround in sd.

   - Make this workaround conditional on a quirks flag in
     struct scsi_device.

   - Switch this flag on in a place where it can be reliably
     detected that this device needs it.  There is an interface
     to do this in userspace.  But in this particular case, the
     best place is the sbp2 driver (ond firewire-sbp2 driver),
     because it can detect PL-3507 firmwares by means of firmware
     identifiers.

Tino, to find the firmware marker you can for example:
# echo 0x1000 > /sys/module/sbp2/parameters/workarounds
Then plug in the disk and
# dmesg | grep sbp2

On the other hand, perhaps we can enable the workaround unconditional
for all firewire disks (switch in the flag in sbp2 and firewire-sbp2
without looking at the device) or for all RBC disks (switch on the flag
in sd.c if sdev->type == TYPE_RBC).

RBC clause 5.4.1 states that support of the following POWER CONDITION
values in the START STOP UNIT cdb is mandatory:
0 = No change in power condition
1 = Place device in Active condition
2 = Place device in Idle condition
3 = Place device in Standby condition
5 = Place device in Sleep condition
There is also optional support for 7 = Device Control, which is
uninteresting for our purposes.  According to the description of Active,
Idle, Standby, Sleep in RBC, we do most certainly want code 1 on resume,
and rather 3 than 2 on suspend. 5 instead of 3 or 2 might even be better
from the POV of energy consumption but a "device reset may be required
before access to the device is allowed" which I'd rather not deal with.

Tino, does the scsi stack log the device as "Direct-Access-RBC" after it
was plugged in?

Note to self:  Test sg_start --pc={1,3} with all the various SBP-2
bridges I have access to...
-- 
Stefan Richter
-=====-==--- -=-- ====-
http://arcgraph.de/sr/

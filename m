From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Sun, 01 Jul 2007 13:07:18 +0200
Message-ID: <46878AE6.7040303@s5r6.in-berlin.de>
References: <725061.42209.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33100 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbXGALHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jul 2007 07:07:30 -0400
In-Reply-To: <725061.42209.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Swen Schillig <swen@vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> --- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Among else:  It should provide a framework which enables userspace to
>> find the unique object identifiers (that are required to uniquely and
>> persistently identify logical units) always in the same place.  (That's
>> just my opinion.  Current userspace tools like e.g. udev scripts are
>> adapted to hunt those identifiers down in various places, and this works
>> too.)
> 
> This information can be had by using default SPC commands, issued by
> specialized userspace tools.  For example the SG tools maintained by Doug.

I did a quick test with twelve SBP-2 devices.  Only four of them
implement the mandatory VPD pages.  But they show only vendor specific
identifiers which are incidentally world wide unique, but are not
guaranteed to be.  The results in detail:

1.) an MMC device: does not support INQUIRY with EVPD=1  (sg_inq says:
invalid VPD response; probably a STANDARD INQUIRY response)

2.) an SBC device which I suspect is rather an RBC device: does not
support EVPD=1 either (returns: Invalid Request)

3.) another SBC device from a different vendor and with a different
controller, which I too suspect is really an RBC device:  Returns
corrupt INQUIRY data which look as if (only) VPD page 0x1f was
implemented; but it isn't. (if any non-zero VPD page code is specified,
sg_inq says: invalid VPD response; probably a STANDARD INQUIRY response)

4.) an RBC device from the same vendor as device 2 and with a newer
revision of controller and firmware of that of device 2:  behaves like
device 3, even though hardware and firmware are very different from device 3

5.-7.) three RBC devices from the same vendor but with different
controllers  and quite different years of production:   They all
implement VPD pages 0x80 = Unit Serial Number and 0x83 = Device
Identification, which fulfills the minimal requirement according to RBC.
 Alas the Device Identification page merely contains a Vendor Specific
Identifier which SPC says is not guaranteed to be globally unique.  In
these two cases it happens to be the same as the upper 64 bits of the
SBP-3 Target port identifier, the EUI-64.

8.) an MMC device from the same vendor as devices 5-7 bit with yet
another different controller:  does not support EVPD=1  (returns:
Invalid Request)

9.) yet one more RBC device, a Mac in target disk mode:  does not
support INQUIRY with EVPD=1  (returns: Invalid Request)

10.) an RBC device with the same bridge as one of the devices 5-7 but
from a different vendor:  Behaves like devices 5-7

11.) an MMC device with possibly same controller as device 1 but from a
different vendor:  behaves like device 1

12.) a dual LU device with a controller like device 3.  I plugged a HDD
and a DVD-ROM into it so that LU 00 00 is a SBC device (perhaps more
like an RBC device) and LU 00 01 is an MMC device.  LU 00 00 behaves
like device 3.  LU 00 01 behaves like device 1.

For the heck of it I also tried REPORT LUNS on device 12:
# sg_luns /dev/sdd
Report Luns command not supported (support mandatory in SPC-3)
# sg_luns /dev/sr0
REPORT LUNS command error: SCSI status: Check Condition
 Fixed format, current;  Sense key: Not Ready
 Additional sense: Medium not present

 Raw sense data (in hex):
        70 00 02 00 00 00 00 0a  00 00 00 00 3a 00 00 00
        00 00
plus...: Driver_status=0x08 [DRIVER_SENSE, SUGGEST_OK]

-- 
Stefan Richter
-=====-=-=== -=== ----=
http://arcgraph.de/sr/

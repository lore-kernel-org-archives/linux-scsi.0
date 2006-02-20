From: "F. Poncin" <cr27587@chello.be>
Subject: Re: Fw: slab error in cache_free_debugcheck(): cache `sgpool-8':
Date: Mon, 20 Feb 2006 20:44:52 +0100
Message-ID: <43FA1C34.40604@chello.be>
References: <20051017002339.5156d7f4.akpm@osdl.org> <4353754B.1040500@s5r6.in-berlin.de> <4353FDAD.1010204@chello.be> <43F9019C.3010505@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amsfep18-int.chello.nl ([213.46.243.13]:24918 "EHLO
	amsfep18-int.chello.nl") by vger.kernel.org with ESMTP
	id S932660AbWBTTo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 14:44:56 -0500
In-Reply-To: <43F9019C.3010505@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

Stefan Richter wrote:

> F. Poncin wrote on 2005-10-17:
>
>> Stefan Richter wrote:
>>
>>> Andrew Morton wrote:
>>>
>>>> THis is rather deadly. Is it likely to be a 1394 bug, or scsi?
>>>
>>>
>>> I am not sure.
>>
>>
>> No impact on disk access.
>>
>>>> Begin forwarded message:
>>>
>>> ...
>>>
>>>> Summary: slab error in cache_free_debugcheck(): cache `sgpool-8':=20
>>>> double free, or memory outside object was overwritten
>>>> Kernel version: 2.6.14-rc4-g9149ccfa
>>>> Steps to reproduce: on boot
>>>> Hardware: Dell 8300 + External USB disk enclosures
>>>
> ...
>
>> Brand new Seagate USB/FireWire External Hard Drive -=20
>> http://www.seagate.com/products/personal/external.html
>> Connected through FireWire to PCI card: FireWire (IEEE 1394): Agere=20
>> Systems (former Lucent Microelectronics) FW323 (rev 61)
>>
>> The older Seagate model (same size) is not affected.
>> Vendor: ST340083 Model: 2A Rev:
>> Type: Direct-Access-RBC ANSI SCSI revision: 04
>
> ...
>
>>>> scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
>>>> ieee1394: sbp2: Logged into SBP-2 device
>>>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>>>> Vendor: Initio Model: ST3400832A Rev: 4.07
>>>> Type: Direct-Access ANSI SCSI revision: 00
>>>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>>>> slab error in cache_free_debugcheck(): cache `sgpool-8': double=20
>>>> free, or memory outside object was overwritten
>>>
> ...
>
>>>> c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
>>>> sdc: asking for cache data failed
>>>> sdc: assuming drive cache: write through
>>>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>>>> slab error in cache_free_debugcheck(): cache `sgpool-8': double=20
>>>> free, or memory outside object was overwritten
>>>
> ...
>
> Finally there is news for Initio SBP-2 bridges.
> http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D114038995826749
>
> Could you try the scsi_mod parameters mentioned there?
>
> Alternatively, update to the latest 1394 drivers (soon to be in -mm,=20
> curently only at=20
> http://www.kernel.org/git/?p=3Dlinux/kernel/git/scjody/ieee1394.git o=
r=20
> http://me.in-berlin.de/~s5r6/linux1394/updates/ ) and load sbp2 with=20
> "modprobe sbp2 force_inquiry_hack=3D1" before connecting the disk.
>
> If either one of these workarounds helps I would be interested in the=
=20
> firmware revision which is logged by sbp2 with force_inquiry_hack=3D1=
=2E=20
> You can get this value with unpatched drivers too.



On my side, the problem seems to be "solved" since mid-December /=20
end-December (linus-git).

latest linus-git:
ieee1394: sbp2: sbp2_firmware_revision =3D 407

ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
Vendor: Initio Model: ST3400832A Rev: 4.07
Type: Direct-Access ANSI SCSI revision: 00
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 13 00 00
sdc: got wrong page
sdc: assuming drive cache: write through
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 13 00 00
sdc: got wrong page
sdc: assuming drive cache: write through
sdc: sdc1
sd 8:0:0:0: Attached scsi disk sdc

#echo 8192 > /sys/module/scsi_mod/parameters/default_dev_flags
#modprobe sbp2

ieee1394: Error parsing configrom for node 0-00:1023
=3D> device not recognised.

#echo "Initio:0KLAT80:8192" >=20
/sys/module/scsi_mod/parameters/default_dev_flags
#modprobe sbp2

ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=3D1)
ieee1394: sbp2: Try serialize_io=3D0 for better performance
scsi9 : SBP-2 IEEE-1394
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
Vendor: Initio Model: ST3400832A Rev: 4.07
Type: Direct-Access ANSI SCSI revision: 00
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 13 00 00
sdc: assuming drive cache: write through
SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 13 00 00
sdc: assuming drive cache: write through
sdc: sdc1
sd 9:0:0:0: Attached scsi disk sdc

--
=46r=C3=A9d=C3=A9ric Poncin
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

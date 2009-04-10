From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
Date: Thu, 09 Apr 2009 20:38:43 -0400
Message-ID: <49DE9513.7050607@interlog.com>
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48276 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZDJAiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 20:38:51 -0400
In-Reply-To: <49DDF744.1090209@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Jeff Garzik wrote:
> Mark Lord wrote:
>> Alan Cox wrote:
>>> Something like this then ?
>>>
>>>
>>> The legacy old IDE API for this is a bit primitive so we try and map 
>>> stuff
>>> sensibly onto it.
>>>
>>> - Add flags2 as we ran out of flags
>>> - Set PIO over DMA devices to report 32bit
>>> - Add ability to change the PIO32 settings if the controller permits it
>>> - Add that functionality into the sff drivers
>>> - Add that functionality into the VLB legacy driver
>>> - Turn on the 32bit PIO on the ninja32 and add support there
>>>
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>> ..
>>
>> By all means go ahead with something like this,
>> and thanks for doing it, Alan.
>>
>> But.. these do look rather suspiciously like sysfs attrs to me.
>>
>> We didn't have a sysfs in the IDE days (so Gadi added the klunky
>> procfs "settings" thing for there), but we do now.
>>
>> I'm happy to update hdparm to check sysfs if that's where this
>> ends up, or to do almost nothing for it if we stick with the ioctls.
> 
> hmmm, Tejun's storage summit presentation would be quite relevant at 
> this juncture :)
> 
> The short answer:  we need a control mechanism for tasks such SATA PHY 
> twiddling, host controller reset, host controller configuration 
> (set/clear 32-bit I/O in this example), ...
> 
> sysfs attrs are desired for this, but we've held off largely because 
> this is all intertwined with the long term direction of "storage model", 
> "transport protocol" and libata's eventual move away from strict SCSI 
> dependency.
> 
> I think the best place for sysfs attr attachment is an ata_transport 
> module, something that's needed to be written for quite a while.  You 
> can see some of the eventual direction in scsi_transport_*.[ch] and 
> raid_class.c.
> 
> Eventually I hope to reach a point where the current crop of SATA+SAS 
> controllers out in the field (e.g. mvsas) will attach to 
> scsi_transport_sas or ata_transport, depending on controller port 
> configuration and attached device(s).  And for the sake of users' 
> sanity, a single utility should be used to configure a SATA+SAS 
> controller port.  Requiring use of hdparm when the port is in SATA mode, 
> and sg_* when the port is in SAS mode, is a bit annoying.

The original question seemed to be about PATA. sysfs
attributes would be one solution. Another solution is
for libata to implement the SAT (ref: sat2r06.pdf at
www.t10.org) specific mode page called "PATA Control"
(see section 12.3.2). The latter solution may well work
with FCoE, iSCSI, FC, USB, 1394 and SAS. Currently there
is no SATA equivalent to that mode page.
In the PATA case surprise me and choose the better solution.

Getting to the host phy directly connected to a SATA disk
is a particularly thorny problem and a no go area for
sysfs in all but the direct connect case. For example
a SATA "host" phy connected to a SATA disk attached to
a SAS expander can be controlled via the SAS SMP protocol.

hdparm assumes the device it is talking to is a PATA or
SATA disk (with some support for the ATA part of an
ATAPI device). hdparm is now capable of talking to
such devices irrespective of whether the OS sees a
ATA transport (PATA or SATA) or one of those other (evil)
SCSI friendly transports (same list as above). My
sg3_utils are lower level utilities that mostly map
directly to SCSI or ATA commands. Feel free to write
a utility that unifies the attributes of
PATA/SATA/FC/SCSI/SAS/logical disks and OSD devices :-)

As for the freestanding ata_transport idea which transport
would a mvsas host adapter belong to which has one phy
connected to a SATA disk, another connected to a SAS disk and
a third one connected to a SAS expander with lots of SATA
disks the other side of that?

Doug Gilbert


From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Add some kind of unique_id attribute to disks in scsi mid layer?
Date: Fri, 04 Feb 2011 15:22:07 -0500
Message-ID: <4D4C5FEF.20807@interlog.com>
References: <20110204193651.GM9565@beardog.cce.hp.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49463 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1BDUWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2011 15:22:17 -0500
In-Reply-To: <20110204193651.GM9565@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org

On 11-02-04 02:36 PM, scameron@beardog.cce.hp.com wrote:
> Would it be a reasonable idea to add some sort of unique_id attribute
> to scsi devices in the mid layer?
>
> For example, sg_inq, from sg3_utils, will print out a serial number:
>
> [root@localhost scameron]# sg_inq /dev/sda
> standard INQUIRY:
>    PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>    [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>    SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>    EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>    [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>      length=56 (0x38)   Peripheral device type: disk
>   Vendor identification: HP
>   Product identification: LOGICAL VOLUME
>   Product revision level: 3.66
>   Unit serial number: 50014380065020C0
>
> And there's also some stuff in page 0x83 on some devices which might
> be useful as suck an identifier:
>
> [root@localhost scameron]# sg_inq --page 0x83 /dev/sda
> VPD INQUIRY: Device Identification page
>    Designation descriptor number 1, descriptor length: 20
>      designator_type: NAA,  code_set: Binary
>      associated with the addressed logical unit
>        NAA 6, IEEE Company_id: 0x508b
>        Vendor Specific Identifier: 0x1001ce88b
>        Vendor Specific Identifier Extension: 0x746f381eedf6577
>        [0x600508b1001ce88b0746f381eedf6577]
>    Designation descriptor number 2, descriptor length: 8
>      designator_type: vendor specific [0x0],  code_set: Binary
>      associated with the addressed logical unit
>   00     00 00 00 00                                         ....
> [root@localhost scameron]#
>
> The hpsa driver, for example, currently exports a "unique_id"
> attribute itself for disks, which is the same data reported by
> inquire page 0x83.
>
> [root@localhost 0:0:0:1]# pwd
> /sys/bus/scsi/devices/0:0:0:1
> [root@localhost 0:0:0:1]# cat unique_id
> 600508B1001CE88B0746F381EEDF6577
>
> It occurs to me that maybe something
> like that would be useful for all disks serviced by the scsi mid layer.
> For example, kdump userland stuff, as typically implemented,
> has a very small ramdisk which it operates from, and has a fairly
> simple minded way of recognizing which disk is which (e.g. looks at
> vendor, model, rev, and type attributes, arguably not a very good way
> to do it, as just flashing firmware on a drive will change the rev, but
> won't mean the disk is not the same disk, for example, and likewise, all
> disks on a given Smart Array will carry the same vendor/model/rev/type,
> and type?  Type is always going to be zero for a disk anyhow.)
>
> So kdump needs some kind of a unique_id to help it out, but would prefer
> not to carry around e.g. sg_inq in the kdump initrd (so you may ask
> "stuffing it in the kernel is a better idea?")  Well, _if_ the LLDs are
> typically already getting this info (as in the case of hpsa and cciss
> at least) maybe they should have some standard way of informing the
> mid layer, so the midlayer could expose this attribute in a standard way?
> Or, maybe the mid layer could send down the necessary inquiries to get
> the information itself with no interface changes needed?
>
> Well, this seems like such an obvious idea, that the mere fact that it
> is not already implemented makes me think there may be some good reason
> why not.

Yes, indeed :-)

The problem is those pesky little storage devices that
(ab)use the SCSI command set (e.g. some USB keys). Some of
them lock up when given anything other than a bog standard
INQUIRY command requesting a 36 byte response with
EVPD=0. After the lock up such devices typically need a
power cycle to come back to life, then if the OS sends them
the same command again that locked them up ... you
probably get the idea.

Redmond seems to like globally unique identifiers (GUIDs)
for storage devices, I wonder how they handle this problem.
A heuristic based in the transport may be one approach.

Doug Gilbert





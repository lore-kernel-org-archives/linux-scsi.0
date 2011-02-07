From: Hannes Reinecke <hare@suse.de>
Subject: Re: Add some kind of unique_id attribute to disks in scsi mid layer?
Date: Mon, 07 Feb 2011 08:33:20 +0100
Message-ID: <4D4FA040.8080201@suse.de>
References: <20110204193651.GM9565@beardog.cce.hp.com> <4D4C5FEF.20807@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1BGHZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2011 02:25:12 -0500
In-Reply-To: <4D4C5FEF.20807@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org

On 02/04/2011 09:22 PM, Douglas Gilbert wrote:
> On 11-02-04 02:36 PM, scameron@beardog.cce.hp.com wrote:
>> Would it be a reasonable idea to add some sort of unique_id attribut=
e
>> to scsi devices in the mid layer?
>>
>> For example, sg_inq, from sg3_utils, will print out a serial number:
>>
>> [root@localhost scameron]# sg_inq /dev/sda
>> standard INQUIRY:
>>    PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x05  [SPC-3]
>>    [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_forma=
t=3D2
>>    SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  BQue=3D0
>>    EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D0
>>    [RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  Cm=
dQue=3D1
>>      length=3D56 (0x38)   Peripheral device type: disk
>>   Vendor identification: HP
>>   Product identification: LOGICAL VOLUME
>>   Product revision level: 3.66
>>   Unit serial number: 50014380065020C0
>>
>> And there's also some stuff in page 0x83 on some devices which might
>> be useful as suck an identifier:
>>
>> [root@localhost scameron]# sg_inq --page 0x83 /dev/sda
>> VPD INQUIRY: Device Identification page
>>    Designation descriptor number 1, descriptor length: 20
>>      designator_type: NAA,  code_set: Binary
>>      associated with the addressed logical unit
>>        NAA 6, IEEE Company_id: 0x508b
>>        Vendor Specific Identifier: 0x1001ce88b
>>        Vendor Specific Identifier Extension: 0x746f381eedf6577
>>        [0x600508b1001ce88b0746f381eedf6577]
>>    Designation descriptor number 2, descriptor length: 8
>>      designator_type: vendor specific [0x0],  code_set: Binary
>>      associated with the addressed logical unit
>>   00     00 00 00 00                                         ....
>> [root@localhost scameron]#
>>
>> The hpsa driver, for example, currently exports a "unique_id"
>> attribute itself for disks, which is the same data reported by
>> inquire page 0x83.
>>
>> [root@localhost 0:0:0:1]# pwd
>> /sys/bus/scsi/devices/0:0:0:1
>> [root@localhost 0:0:0:1]# cat unique_id
>> 600508B1001CE88B0746F381EEDF6577
>>
>> It occurs to me that maybe something
>> like that would be useful for all disks serviced by the scsi mid lay=
er.
>> For example, kdump userland stuff, as typically implemented,
>> has a very small ramdisk which it operates from, and has a fairly
>> simple minded way of recognizing which disk is which (e.g. looks at
>> vendor, model, rev, and type attributes, arguably not a very good wa=
y
>> to do it, as just flashing firmware on a drive will change the rev, =
but
>> won't mean the disk is not the same disk, for example, and likewise,=
 all
>> disks on a given Smart Array will carry the same vendor/model/rev/ty=
pe,
>> and type?  Type is always going to be zero for a disk anyhow.)
>>
>> So kdump needs some kind of a unique_id to help it out, but would pr=
efer
>> not to carry around e.g. sg_inq in the kdump initrd (so you may ask
>> "stuffing it in the kernel is a better idea?")  Well, _if_ the LLDs =
are
>> typically already getting this info (as in the case of hpsa and ccis=
s
>> at least) maybe they should have some standard way of informing the
>> mid layer, so the midlayer could expose this attribute in a standard=
 way?
>> Or, maybe the mid layer could send down the necessary inquiries to g=
et
>> the information itself with no interface changes needed?
>>
>> Well, this seems like such an obvious idea, that the mere fact that =
it
>> is not already implemented makes me think there may be some good rea=
son
>> why not.
>=20
> Yes, indeed :-)
>=20
> The problem is those pesky little storage devices that
> (ab)use the SCSI command set (e.g. some USB keys). Some of
> them lock up when given anything other than a bog standard
> INQUIRY command requesting a 36 byte response with
> EVPD=3D0. After the lock up such devices typically need a
> power cycle to come back to life, then if the OS sends them
> the same command again that locked them up ... you
> probably get the idea.
>=20
> Redmond seems to like globally unique identifiers (GUIDs)
> for storage devices, I wonder how they handle this problem.
> A heuristic based in the transport may be one approach.
>=20
Main problem is that device do not exactly have _one_ unique ID, but
rather several; check scsi_id to approve the real complexity here.
So when adding this field we would actually move quite some bit of
policy into the kernel.

The transport ID OTOH is well defined and actually used in some
contexts (persistent reservation spring to mind here).
Having that in sysfs would be great.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

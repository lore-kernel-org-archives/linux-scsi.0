From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Thu, 09 Sep 2010 09:13:52 -0500
Message-ID: <4C88EBA0.3000100@redhat.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com> <20100903221303.GA9527@localhost.localdomain> <4C876B47.50805@gmail.com> <4C88BBB2.8080309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab0IIOOA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2010 10:14:00 -0400
In-Reply-To: <4C88BBB2.8080309@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-scsi@vger.kernel.org, Wouter Naaktgeboren <wouter_naaktgeboren@xs4all.nl>

Konstantinos Skarlatos wrote:
>  On 8/9/2010 1:53 =C3=8E=C2=BC=C3=8E=C2=BC, Konstantinos Skarlatos wr=
ote:
>>  On 4/9/2010 1:13 =C3=8F=E2=82=AC=C3=8E=C2=BC, David Milburn wrote:
>>> On Fri, Aug 06, 2010 at 08:21:16PM +0300, Konstantinos Skarlatos wr=
ote:
>>>> >    Hello,
>>>> > >  Does this patch fix any of the mvs_abort_task:rc=3D 5 and the=
 other
>>>> >  problems that are being reported for this driver? for more info=
=20
>>>> please
>>>> >  seehttp://marc.info/?l=3Dlinux-scsi&m=3D127583131805429&w=3D2
>>>> >=20
>>> Hello,
>>>
>>> Can you see if this patch prevents the ata_qc_issue warning?
>>>
>>> Thanks,
>>> David
>>>
>>>   drivers/scsi/libsas/sas_ata.c |    1 +
>>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_ata.c=20
>>> b/drivers/scsi/libsas/sas_ata.c
>>> index 042153c..ddbade7 100644
>>> --- a/drivers/scsi/libsas/sas_ata.c
>>> +++ b/drivers/scsi/libsas/sas_ata.c
>>> @@ -347,6 +347,7 @@ static int sas_ata_scr_read(struct ata_link=20
>>> *link, unsigned int sc_reg_in,
>>>   static struct ata_port_operations sas_sata_ops =3D {
>>>       .phy_reset        =3D sas_ata_phy_reset,
>>>       .post_internal_cmd    =3D sas_ata_post_internal,
>>> +    .qc_defer               =3D ata_std_qc_defer,
>>>       .qc_prep        =3D ata_noop_qc_prep,
>>>       .qc_issue        =3D sas_ata_qc_issue,
>>>       .qc_fill_rtf        =3D sas_ata_qc_fill_rtf,
>>
>> Hello,
>>
>> I have been unable to patch my kernel, I am a noob at this and the=20
>> method i used a few months ago to apply Srinivas patches for mvsas=20
>> does not work now. I have asked for help from my distro (arch linux)=
,=20
>> but if you have a quick and easy way for me to patch sas_ata.c and=20
>> reload the module without reboots or complete kernel recompilations =
I=20
>> would be grateful to hear it.
>>
>> Kind regards
> Hi, I finally managed to compile libsas. Here is dmesg output when=20
> loading mvsas (BTW what do the messages about ata38.00 mean?). I will=
=20
> report back when I do more testing

Hi, looks like the first couple of attempts to IDENTIFY DEVICE failed. =
This
patch should prevent mixing NCQ and non-NCQ commands so you shouldn't
see the warning from ata_qc_issue(). Thanks.

>=20
> mvsas 0000:05:00.0: mvsas: driver version 0.8.2
> mvsas 0000:05:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) ->=
=20
> IRQ 18
> mvsas 0000:05:00.0: setting latency timer to 64
> mvsas 0000:05:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
> scsi13 : mvsas
> drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 1
> drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 3
> drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 7
> drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map f
> ata38.00: ATA-8: ST31500541AS, CC34, max UDMA/133
> ata38.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata38.00: qc timeout (cmd 0xec)
> ata38.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
> ata38.00: revalidation failed (errno=3D-5)
> drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[1]:rc=
=3D 0
> ata38.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
> ata38: limiting SATA link speed to 1.5 Gbps
> ata38.00: limiting speed to UDMA/133:PIO3
> drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[1]:rc=
=3D 0
> ata38.00: ATA-8: ST31500541AS, CC34, max UDMA/133
> ata38.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata38.00: configured for UDMA/133
> scsi 13:0:0:0: Direct-Access     ATA      ST31500541AS     CC34 PQ: 0=
=20
> ANSI: 5
> sd 13:0:0:0: Attached scsi generic sg1 type 0
> sd 13:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:0:0: [sdb] Write Protect is off
> sd 13:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 13:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdb:
> ata39.00: ATA-8: ST31500541AS, CC32, max UDMA/133
> ata39.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>  sdb1
> sd 13:0:0:0: [sdb] Attached SCSI disk
> ata39.00: configured for UDMA/133
> scsi 13:0:1:0: Direct-Access     ATA      ST31500541AS     CC32 PQ: 0=
=20
> ANSI: 5
> sd 13:0:1:0: Attached scsi generic sg2 type 0
> sd 13:0:1:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:1:0: [sdc] Write Protect is off
> sd 13:0:1:0: [sdc] Mode Sense: 00 3a 00 00
> sd 13:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdc: sdc1
> sd 13:0:1:0: [sdc] Attached SCSI disk
> ata40.00: ATA-8: WDC WD15EADS-00S2B0, 01.00A01, max UDMA/133
> ata40.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata40.00: configured for UDMA/133
> scsi 13:0:2:0: Direct-Access     ATA      WDC WD15EADS-00S 01.0 PQ: 0=
=20
> ANSI: 5
> sd 13:0:2:0: Attached scsi generic sg3 type 0
> sd 13:0:2:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:2:0: [sdd] Write Protect is off
> sd 13:0:2:0: [sdd] Mode Sense: 00 3a 00 00
> sd 13:0:2:0: [sdd] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdd:
> ata41.00: ATA-8: ST31500541AS, CC32, max UDMA/133
> ata41.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata41.00: configured for UDMA/133
> scsi 13:0:3:0: Direct-Access     ATA      ST31500541AS     CC32 PQ: 0=
=20
> ANSI: 5
> sd 13:0:3:0: Attached scsi generic sg4 type 0
> sd 13:0:3:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:3:0: [sde] Write Protect is off
> sd 13:0:3:0: [sde] Mode Sense: 00 3a 00 00
> sd 13:0:3:0: [sde] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sde: sde1
> sd 13:0:3:0: [sde] Attached SCSI disk
> ata42.00: ATA-8: ST31500541AS, CC34, max UDMA/133
> ata42.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata42.00: configured for UDMA/133
> scsi 13:0:4:0: Direct-Access     ATA      ST31500541AS     CC34 PQ: 0=
=20
> ANSI: 5
> sd 13:0:4:0: [sdf] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:4:0: [sdf] Write Protect is off
> sd 13:0:4:0: [sdf] Mode Sense: 00 3a 00 00
> sd 13:0:4:0: [sdf] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
> sd 13:0:4:0: Attached scsi generic sg5 type 0
>  sdf:
> ata43.00: ATA-8: ST31500541AS, CC34, max UDMA/133
> ata43.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata43.00: configured for UDMA/133
> scsi 13:0:5:0: Direct-Access     ATA      ST31500541AS     CC34 PQ: 0=
=20
> ANSI: 5
> sd 13:0:5:0: Attached scsi generic sg6 type 0
> sd 13:0:5:0: [sdg] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:5:0: [sdg] Write Protect is off
> sd 13:0:5:0: [sdg] Mode Sense: 00 3a 00 00
> sd 13:0:5:0: [sdg] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdg:
> ata44.00: ATA-8: ST31500541AS, CC32, max UDMA/133
> ata44.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata44.00: configured for UDMA/133
> scsi 13:0:6:0: Direct-Access     ATA      ST31500541AS     CC32 PQ: 0=
=20
> ANSI: 5
> sd 13:0:6:0: Attached scsi generic sg7 type 0
> sd 13:0:6:0: [sdh] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:6:0: [sdh] Write Protect is off
> sd 13:0:6:0: [sdh] Mode Sense: 00 3a 00 00
> sd 13:0:6:0: [sdh] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdh: sdh1
> sd 13:0:6:0: [sdh] Attached SCSI disk
> ata45.00: ATA-8: ST31500541AS, CC34, max UDMA/133
> ata45.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata45.00: configured for UDMA/133
> scsi 13:0:7:0: Direct-Access     ATA      ST31500541AS     CC34 PQ: 0=
=20
> ANSI: 5
> sd 13:0:7:0: Attached scsi generic sg8 type 0
> sd 13:0:7:0: [sdi] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:7:0: [sdi] Write Protect is off
> sd 13:0:7:0: [sdi] Mode Sense: 00 3a 00 00
> sd 13:0:7:0: [sdi] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdi:
> ata46.00: ATA-8: ST31500541AS, CC32, max UDMA/133
> ata46.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata46.00: configured for UDMA/133
> scsi 13:0:8:0: Direct-Access     ATA      ST31500541AS     CC32 PQ: 0=
=20
> ANSI: 5
> sd 13:0:8:0: Attached scsi generic sg9 type 0
> sd 13:0:8:0: [sdj] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:8:0: [sdj] Write Protect is off
> sd 13:0:8:0: [sdj] Mode Sense: 00 3a 00 00
> sd 13:0:8:0: [sdj] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdj: sdj1
> sd 13:0:8:0: [sdj] Attached SCSI disk
> ata47.00: qc timeout (cmd 0x27)
> ata47.00: failed to read native max address (err_mask=3D0x4)
> ata47.00: HPA support seems broken, skipping HPA handling
> drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[a]:rc=
=3D 0
>  sdi1
> sd 13:0:7:0: [sdi] Attached SCSI disk
> ata47.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> ata47.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata47.00: configured for UDMA/133
> scsi 13:0:9:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0=
=20
> ANSI: 5
> sd 13:0:9:0: Attached scsi generic sg10 type 0
> sd 13:0:9:0: [sdk] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 13:0:9:0: [sdk] Write Protect is off
> sd 13:0:9:0: [sdk] Mode Sense: 00 3a 00 00
> sd 13:0:9:0: [sdk] Write cache: enabled, read cache: enabled, doesn't=
=20
> support DPO or FUA
>  sdk: sdk1
> sd 13:0:9:0: [sdk] Attached SCSI disk
>  sdf1
> sd 13:0:4:0: [sdf] Attached SCSI disk
>  sdg1
> sd 13:0:5:0: [sdg] Attached SCSI disk
>  sdd1
> sd 13:0:2:0: [sdd] Attached SCSI disk
> ata48.00: qc timeout (cmd 0x27)
> ata48.00: failed to read native max address (err_mask=3D0x4)
> ata48.00: HPA support seems broken, skipping HPA handling
> drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[b]:rc=
=3D 0
> ata48.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> ata48.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata48.00: configured for UDMA/133
> scsi 13:0:10:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: =
0=20
> ANSI: 5
> sd 13:0:10:0: Attached scsi generic sg11 type 0
> sd 13:0:10:0: [sdl] 2930277168 512-byte logical blocks: (1.50 TB/1.36=
 TiB)
> sd 13:0:10:0: [sdl] Write Protect is off
> sd 13:0:10:0: [sdl] Mode Sense: 00 3a 00 00
> sd 13:0:10:0: [sdl] Write cache: enabled, read cache: enabled, doesn'=
t=20
> support DPO or FUA
>  sdl:
> ata49.00: ATA-8: ST31500541AS, CC32, max UDMA/133
> ata49.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>  sdl1
> sd 13:0:10:0: [sdl] Attached SCSI disk
> ata49.00: configured for UDMA/133
> scsi 13:0:11:0: Direct-Access     ATA      ST31500541AS     CC32 PQ: =
0=20
> ANSI: 5
> sd 13:0:11:0: Attached scsi generic sg12 type 0
> sd 13:0:11:0: [sdm] 2930277168 512-byte logical blocks: (1.50 TB/1.36=
 TiB)
> sd 13:0:11:0: [sdm] Write Protect is off
> sd 13:0:11:0: [sdm] Mode Sense: 00 3a 00 00
> sd 13:0:11:0: [sdm] Write cache: enabled, read cache: enabled, doesn'=
t=20
> support DPO or FUA
>  sdm: sdm1
> sd 13:0:11:0: [sdm] Attached SCSI disk
> ata50.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
> ata50.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata50.00: configured for UDMA/133
> scsi 13:0:12:0: Direct-Access     ATA      WDC WD15EADS-00P 01.0 PQ: =
0=20
> ANSI: 5
> sd 13:0:12:0: Attached scsi generic sg13 type 0
> sd 13:0:12:0: [sdn] 2930277168 512-byte logical blocks: (1.50 TB/1.36=
 TiB)
> sd 13:0:12:0: [sdn] Write Protect is off
> sd 13:0:12:0: [sdn] Mode Sense: 00 3a 00 00
> sd 13:0:12:0: [sdn] Write cache: enabled, read cache: enabled, doesn'=
t=20
> support DPO or FUA
>  sdn:
> scsi 13:0:13:0: Enclosure         HP       HP SAS EXP Card  1.00 PQ: =
0=20
> ANSI: 5
> ses 13:0:13:0: Attached Enclosure device
> ses 13:0:13:0: Attached scsi generic sg14 type 13
>  sdn1
> sd 13:0:12:0: [sdn] Attached SCSI disk
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G)
 SAS cards
Date: Wed, 10 Jun 2009 22:40:38 +0400
Message-ID: <4A2FFE26.5050408@vlnb.net>
References: <49E4B6D5.9060007@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com> <4A2D2E8F.6090207@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103BB6034@CORPUSMX50C.corp.emc.com> <5FF020A1CFFEEC49BD1E09530C4FF595714E369F@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZFJSpg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 14:45:36 -0400
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF595714E369F@SC-VEXCH1.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: "Foster_Brian@emc.com" <Foster_Brian@emc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

Andy Yan, on 06/09/2009 05:27 AM wrote:
> Brian,
> Please set unique SAS address for each SAS port of target controller,
> and make sure you do correct connection, you can get the SAS address =
of
> attaching device from "attach sas address ".Then enable target mode a=
nd
> add target LUN.

Do you mean "add target LUN and then enable target mode"? Otherwise an=20
initiator can connect while there are no LUNs configured on the target=20
and confused by it.

> Regards
> Andy Yan
>=20
> -----Original Message-----
> From: Foster_Brian@emc.com [mailto:Foster_Brian@emc.com]=20
> Sent: 2009=E5=B9=B46=E6=9C=889=E6=97=A5 2:14
> To: vst@vlnb.net
> Cc: linux-scsi@vger.kernel.org; scst-devel@lists.sourceforge.net; And=
y Yan; James.Bottomley@HansenPartnership.com
> Subject: RE: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and=
 88SE94xx(6G) SAS cards
>=20
>=20
>=20
>> Foster_Brian@emc.com, on 06/05/2009 10:10 PM wrote:
>>>> Hi All,
>>>>
>>>> I'm glad to announce that a target driver for Marvell 88SE64xx(3G)
> and
>>>> 88SE94xx(6G) SAS cards has been just added in the SCST SVN
> repository.
>>> A
>>>> lot of thanks to Marvell and Andy Yan!
>>>>
>>>> This driver allows to use a SAS controller based on Marvell
> 88SE64xx
>>> or
>>>> 88SE94xx chips as a SAN storage server (target). More info you can
>>> find
>>>> on the SCST page http://scst.sourceforge.net.
>>>>
>>>> You can download the driver from SCST SVN by running a command:
>>>>
>>>> $ svn co https://scst.svn.sourceforge.net/svnroot/scst
>>>>
>>> Hi Vlad/Andy,
>>>
>>> Is this target driver expected to work with 6320 cards as well?
> Using
>>> this driver, I was able to discover a SATA drive connected to the
> 6320
>>> in initiator mode.
>>>
>>> I connected the 6320 directly to a second 6320 on another machine,
> set
>>> up a virtual LUN with SCST (added to the default group, etc.) and
>>> enabled target mode, but I'm not seeing anything on the initiator
> side.
>> Double check you don't have in the kernel log messages like "tgt_dev
> for
>> LUN X not found, command to unexisting LU?" (I assume you have SCST
>> tracing enabled, it is by default so in the SVN trunk/). If you do,
> then
>> you didn't setup the virtual LUN correctly.
>>
>> Vlad
>=20
> Thanks Vlad. I think my SCST configuration is Ok. I did experiment
> previously with the iSCSI target and the scst_local driver, and both
> worked fine.
>=20
> Andy,
>=20
> Thanks for the README. I followed the steps in the file and see the s=
ame
> result. The following shows the commands I'm using and the associated
> output.=20
>=20
> On the target side, I load the SCST/mvsas drivers and enable target
> mode. This looks like it works, but my 'target_mode' file is slightly
> different from what is shown in the README:
>=20
> root@ix12-1:/sys/class/scsi_host/host17# cat target_mode
> phy  dev sas address     attach dev type   attach sas address  target
> mode
> 0    5005043011ab0000                      0                   0
> 1    5005043011ab0000                      0                   0
> 2    5005043011ab0000                      0                   0
> 3    5005043011ab0000                      0                   0
>=20
> root@ix12-1:/sys/class/scsi_host/host17# echo "enable 1" > target_mod=
e
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_init.c
> 898:get enable
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_init.c
> 853:Enable phy1
> Jun  8 09:53:20 ix12-1 kernel: scst: Target mvst_scst (db0f2cc0) for
> template mvst_scst registered successfully
> Jun  8 09:53:20 ix12-1 kernel: [3054]: mvst_register_tgt_handler:Enab=
le
> lun for host 0(0,db140000)
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 2290:initiator attaching 0000000000000000,map 2 on port[1]
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 2199:set phy 0 to target mode
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 2199:set phy 1 to target mode
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 2199:set phy 2 to target mode
> Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 2199:set phy 3 to target mode
> Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 1779:Reset phy[0] to notify iniator
> Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 1779:Reset phy[1] to notify iniator
> Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 1779:Reset phy[2] to notify iniator
> Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 1779:Reset phy[3] to notify iniator
> Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
> 2301:Enable target mode......
>=20
> root@ix12-1:/sys/class/scsi_host/host17# cat target_mode
> phy  dev sas address     attach dev type   attach sas address  target
> mode
> 0    5005043011ab0000                      0                   1
> 1    5005043011ab0000                      0                   1
> 2    5005043011ab0000                      0                   1
> 3    5005043011ab0000                      0                   1
>=20
> Next, I create the virtual LUN and add it to the default group as LUN=
 0:
>=20
> root@ix12-1:/proc/scsi_tgt/vdisk# echo "open test
> /mnt/soho_storage/disk" > vdisk
> Jun  8 09:54:27 ix12-1 kernel: dev_vdisk: Registering virtual FILEIO
> device test
> Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4=
791
> Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4=
792
> Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4=
793
> Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4=
794
> Jun  8 09:54:27 ix12-1 kernel: dev_vdisk: Attached SCSI target virtua=
l
> disk test (file=3D"/mnt/soho_storage/disk", fs=3D1000MB, bs=3D512,
> nblocks=3D2048000, cyln=3D1000)
> Jun  8 09:54:27 ix12-1 kernel: scst: Attached SCSI target mid-level t=
o
> virtual device test (id 1)
> Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4=
795
>=20
> root@ix12-1:/proc/scsi_tgt# echo "add test" > groups/Default/devices
> Jun  8 09:55:19 ix12-1 kernel: scst: Added device test to group Defau=
lt
> (LUN 0, rd_only 0)
>=20
> ... and finally, I load the mvsas driver on the initiator side:
>=20
> root@ix12-2:/# modprobe mvsas
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi0, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi1, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi2, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi5, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi6, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi7, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi8, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi9, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi10, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi12, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi13, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi14, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level a=
t
> scsi15, channel 0, id 0, lun 0, type 0
> Jun  8 21:56:04 ix12-2 kernel: scst: Processing thread started, PID 9=
166
> Jun  8 21:56:04 ix12-2 kernel: scst: Init thread started, PID 9167
> Jun  8 21:56:04 ix12-2 kernel: scst: Task management thread started, =
PID
> 9168
> Jun  8 21:56:04 ix12-2 kernel: scst: SCST version 1.0.1 loaded
> successfully (max mem for commands 221MB, per device 88MB)
> Jun  8 21:56:04 ix12-2 kernel: scst: Enabled features: TRACING
> Jun  8 21:56:04 ix12-2 kernel: scst: Management thread started, PID 9=
169
> Jun  8 21:56:04 ix12-2 kernel: mvsas 0000:03:00.0: mvsas: driver vers=
ion
> 0.8.3
> Jun  8 21:56:04 ix12-2 kernel: mvsas 0000:03:00.0: PCI INT A ->
> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
> Jun  8 21:56:04 ix12-2 kernel: mvsas 0000:03:00.0: setting latency ti=
mer
> to 64
> Jun  8 21:56:05 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
> 491:Init flash rom ok,flash type is 0x101.
> Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
> 527:Phy 0 SAS ADDRESS 5005043011ab0000
> Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
> 527:Phy 1 SAS ADDRESS 5005043011ab0000
> Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
> 527:Phy 2 SAS ADDRESS 5005043011ab0000
> Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
> 527:Phy 3 SAS ADDRESS 5005043011ab0000
> Jun  8 21:56:06 ix12-2 kernel: mvsas 0000:03:00.0: mvsas: PCI-E x1,
> Bandwidth Usage: 2.5 Gbps
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1246:port 0 attach dev info is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1248:port 0 attach sas addr is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1246:port 1 attach dev info is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1248:port 1 attach sas addr is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1246:port 2 attach dev info is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1248:port 2 attach sas addr is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1246:port 3 attach dev info is 0
> Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
> 1248:port 3 attach sas addr is 0
> Jun  8 21:56:08 ix12-2 kernel: scsi17 : mvsas
> Jun  8 21:56:08 ix12-2 kernel: scst: Target template mvst_scst
> registered successfully
>=20
> At this point I would have expected a new SCSI disk to appear for the
> virtual LUN, any thoughts? Thanks.
>=20
> Brian
> N=E5=AB=A5=E5=8F=89=E9=9D=A3=E7=AC=A1y=EE=8C=B7=E6=B0=8Ab=E7=9E=82=EE=
=83=91=E5=8D=83v=E8=B1=9D=EF=BF=BD)=E8=97=93{.n=EF=BF=BD+=E5=A3=8F=EE=9A=
=8F{=E5=8C=97=EF=BF=BD"=E5=A6=A0ay=EF=BF=BD=1D=E8=95=A0=E8=B7=88=EF=BF=BD=
,j=07=EE=84=9Bf=EF=BC=82=E7=A9=90=E6=AE=9D=E9=84=97=EF=BF=BD=1E=E7=95=90=
=E3=82=A2=EF=BF=BD=0C=E2=92=8E=EE=9B=90:+v=E5=A2=BE=E5=A6=9B=E9=91=9A=E8=
=B1=B0=E7=A8=9B=EF=BF=BD=EF=BF=BD=07=E7=8F=A3=E8=B5=99zZ+=E5=87=92=E6=AE=
=A0=E5=A8=B8=EE=95=90"=E6=BF=9F!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

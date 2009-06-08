From: Foster_Brian@emc.com
Subject: RE: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G) SAS cards
Date: Mon, 8 Jun 2009 14:14:01 -0400
Message-ID: <D27CA15508148C428A25104ADEFAAC8103BB6034@CORPUSMX50C.corp.emc.com>
References: <49E4B6D5.9060007@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com> <4A2D2E8F.6090207@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:17274 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZFHSOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 14:14:15 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4A2D2E8F.6090207@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, ayan@marvell.com, James.Bottomley@HansenPartnership.com



> Foster_Brian@emc.com, on 06/05/2009 10:10 PM wrote:
> >> Hi All,
> >>
> >> I'm glad to announce that a target driver for Marvell 88SE64xx(3G)
and
> >> 88SE94xx(6G) SAS cards has been just added in the SCST SVN
repository.
> > A
> >> lot of thanks to Marvell and Andy Yan!
> >>
> >> This driver allows to use a SAS controller based on Marvell
88SE64xx
> > or
> >> 88SE94xx chips as a SAN storage server (target). More info you can
> > find
> >> on the SCST page http://scst.sourceforge.net.
> >>
> >> You can download the driver from SCST SVN by running a command:
> >>
> >> $ svn co https://scst.svn.sourceforge.net/svnroot/scst
> >>
> >
> > Hi Vlad/Andy,
> >
> > Is this target driver expected to work with 6320 cards as well?
Using
> > this driver, I was able to discover a SATA drive connected to the
6320
> > in initiator mode.
> >
> > I connected the 6320 directly to a second 6320 on another machine,
set
> > up a virtual LUN with SCST (added to the default group, etc.) and
> > enabled target mode, but I'm not seeing anything on the initiator
side.
> 
> Double check you don't have in the kernel log messages like "tgt_dev
for
> LUN X not found, command to unexisting LU?" (I assume you have SCST
> tracing enabled, it is by default so in the SVN trunk/). If you do,
then
> you didn't setup the virtual LUN correctly.
> 
> Vlad

Thanks Vlad. I think my SCST configuration is Ok. I did experiment
previously with the iSCSI target and the scst_local driver, and both
worked fine.

Andy,

Thanks for the README. I followed the steps in the file and see the same
result. The following shows the commands I'm using and the associated
output. 

On the target side, I load the SCST/mvsas drivers and enable target
mode. This looks like it works, but my 'target_mode' file is slightly
different from what is shown in the README:

root@ix12-1:/sys/class/scsi_host/host17# cat target_mode
phy  dev sas address     attach dev type   attach sas address  target
mode
0    5005043011ab0000                      0                   0
1    5005043011ab0000                      0                   0
2    5005043011ab0000                      0                   0
3    5005043011ab0000                      0                   0

root@ix12-1:/sys/class/scsi_host/host17# echo "enable 1" > target_mode
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_init.c
898:get enable
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_init.c
853:Enable phy1
Jun  8 09:53:20 ix12-1 kernel: scst: Target mvst_scst (db0f2cc0) for
template mvst_scst registered successfully
Jun  8 09:53:20 ix12-1 kernel: [3054]: mvst_register_tgt_handler:Enable
lun for host 0(0,db140000)
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
2290:initiator attaching 0000000000000000,map 2 on port[1]
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
2199:set phy 0 to target mode
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
2199:set phy 1 to target mode
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
2199:set phy 2 to target mode
Jun  8 09:53:20 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
2199:set phy 3 to target mode
Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
1779:Reset phy[0] to notify iniator
Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
1779:Reset phy[1] to notify iniator
Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
1779:Reset phy[2] to notify iniator
Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
1779:Reset phy[3] to notify iniator
Jun  8 09:53:22 ix12-1 kernel: /home/brian/scst/mvsas_tgt/mv_tgt.c
2301:Enable target mode......

root@ix12-1:/sys/class/scsi_host/host17# cat target_mode
phy  dev sas address     attach dev type   attach sas address  target
mode
0    5005043011ab0000                      0                   1
1    5005043011ab0000                      0                   1
2    5005043011ab0000                      0                   1
3    5005043011ab0000                      0                   1

Next, I create the virtual LUN and add it to the default group as LUN 0:

root@ix12-1:/proc/scsi_tgt/vdisk# echo "open test
/mnt/soho_storage/disk" > vdisk
Jun  8 09:54:27 ix12-1 kernel: dev_vdisk: Registering virtual FILEIO
device test
Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4791
Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4792
Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4793
Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4794
Jun  8 09:54:27 ix12-1 kernel: dev_vdisk: Attached SCSI target virtual
disk test (file="/mnt/soho_storage/disk", fs=1000MB, bs=512,
nblocks=2048000, cyln=1000)
Jun  8 09:54:27 ix12-1 kernel: scst: Attached SCSI target mid-level to
virtual device test (id 1)
Jun  8 09:54:27 ix12-1 kernel: scst: Processing thread started, PID 4795

root@ix12-1:/proc/scsi_tgt# echo "add test" > groups/Default/devices
Jun  8 09:55:19 ix12-1 kernel: scst: Added device test to group Default
(LUN 0, rd_only 0)

... and finally, I load the mvsas driver on the initiator side:

root@ix12-2:/# modprobe mvsas
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi0, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi1, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi2, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi5, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi6, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi7, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi8, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi9, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi10, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi12, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi13, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi14, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Attached SCSI target mid-level at
scsi15, channel 0, id 0, lun 0, type 0
Jun  8 21:56:04 ix12-2 kernel: scst: Processing thread started, PID 9166
Jun  8 21:56:04 ix12-2 kernel: scst: Init thread started, PID 9167
Jun  8 21:56:04 ix12-2 kernel: scst: Task management thread started, PID
9168
Jun  8 21:56:04 ix12-2 kernel: scst: SCST version 1.0.1 loaded
successfully (max mem for commands 221MB, per device 88MB)
Jun  8 21:56:04 ix12-2 kernel: scst: Enabled features: TRACING
Jun  8 21:56:04 ix12-2 kernel: scst: Management thread started, PID 9169
Jun  8 21:56:04 ix12-2 kernel: mvsas 0000:03:00.0: mvsas: driver version
0.8.3
Jun  8 21:56:04 ix12-2 kernel: mvsas 0000:03:00.0: PCI INT A ->
Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
Jun  8 21:56:04 ix12-2 kernel: mvsas 0000:03:00.0: setting latency timer
to 64
Jun  8 21:56:05 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
491:Init flash rom ok,flash type is 0x101.
Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
527:Phy 0 SAS ADDRESS 5005043011ab0000
Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
527:Phy 1 SAS ADDRESS 5005043011ab0000
Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
527:Phy 2 SAS ADDRESS 5005043011ab0000
Jun  8 21:56:06 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_spi.c
527:Phy 3 SAS ADDRESS 5005043011ab0000
Jun  8 21:56:06 ix12-2 kernel: mvsas 0000:03:00.0: mvsas: PCI-E x1,
Bandwidth Usage: 2.5 Gbps
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1246:port 0 attach dev info is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1248:port 0 attach sas addr is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1246:port 1 attach dev info is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1248:port 1 attach sas addr is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1246:port 2 attach dev info is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1248:port 2 attach sas addr is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1246:port 3 attach dev info is 0
Jun  8 21:56:08 ix12-2 kernel: /home/brian/scst/mvsas_tgt/mv_sas.c
1248:port 3 attach sas addr is 0
Jun  8 21:56:08 ix12-2 kernel: scsi17 : mvsas
Jun  8 21:56:08 ix12-2 kernel: scst: Target template mvst_scst
registered successfully

At this point I would have expected a new SCSI disk to appear for the
virtual LUN, any thoughts? Thanks.

Brian

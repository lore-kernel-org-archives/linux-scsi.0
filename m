From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 3.0, URGENT
Date: Thu, 22 Sep 2011 19:40:54 -0600
Message-ID: <201109221940.54840.thomas@fjellstrom.ca>
References: <201109162002.13801.thomas@fjellstrom.ca> <201109182218.00295.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:44324 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1IWBlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 21:41:04 -0400
In-Reply-To: <201109182218.00295.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>, yxlraid@gmail.com

On September 18, 2011, Thomas Fjellstrom wrote:
> On September 16, 2011, Thomas Fjellstrom wrote:
> > Hi, its me again.
> > 
> > Just updated to 3.0 last night, after the card had locked up twice in as
> > many days. However, I just heard some unsettling noises come from my
> > raid array, like one of the disks was being re-initialized several
> > times. spinning up and down a few times, etc.
> > 
> > When I got to look at the logs, I find this:
> > 
[snip logs]
> > 
> > So, it seems to have at least recovered this time, rather than locking
> > up, unfortunately now my raid5 array is rebuilding. Thankfully it seems
> > to have been able to use the mdraid bitmap feature, as it only took 20
> > minutes.
> 
> So now 20+ hours after that, I get another error, and the card has locked
> up, but this time without trying to reinitialize anything.
> 
[snip logs]
> 
> The only questionable message before that is from kvm:
> 
> [180085.863989] kvm: page allocation failure: order:1, mode:0x20
> 
> Which is about 21 hours before the sas error. So it is (probably?) not
> related.


All right, new event just now. Drive started kicking on and off like before,
but this time, the kernel/card has decided to kick ALL of the drives in
succession.

logs from this go-round:

[336077.612307] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 2084:Release slot [6] tag[6], task [ffff8801d308c540]:
[336077.612332] sas: sas_ata_task_done: SAS error 8a
[336077.612366] sas: Enter sas_scsi_recover_host
[336077.612385] ata14: sas eh calling libata cmd error handler
[336077.612401] ata9: sas eh calling libata port error handler
[336077.612426] ata10: sas eh calling libata port error handler
[336077.612440] ata11: sas eh calling libata port error handler
[336077.612454] ata12: sas eh calling libata port error handler
[336077.612467] ata13: sas eh calling libata port error handler
[336077.612479] ata14: sas eh calling libata port error handler
[336077.612493] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[336077.613795] ata14.00: failed command: FLUSH CACHE EXT
[336077.615073] ata14.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336077.615078]          res 01/04:00:f8:13:9d/00:00:26:00:00/40 Emask 0x12 (ATA bus error)
[336077.617623] ata14.00: status: { ERR }
[336077.618915] ata14.00: error: { ABRT }
[336077.620225] ata14: hard resetting link
[336077.620233] sas: sas_ata_hard_reset: Found ATA device.
[336077.622279] sas: sas_ata_task_done: SAS error 8a
[336077.622395] sas: sas_ata_task_done: SAS error 8a
[336077.622408] ata14.00: both IDENTIFYs aborted, assuming NODEV
[336077.622419] ata14.00: revalidation failed (errno=-2)
[336079.622296] sd 0:0:5:0: [sdi] Synchronizing SCSI cache
[336082.620081] ata14: hard resetting link
[336082.620101] sas: sas_ata_hard_reset: Found ATA device.
[336082.620131] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x41)
[336082.620140] ata14.00: revalidation failed (errno=-5)
[336087.620036] ata14: hard resetting link
[336087.620048] sas: sas_ata_hard_reset: Found ATA device.
[336087.620078] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x41)
[336087.620087] ata14.00: revalidation failed (errno=-5)
[336087.621409] ata14.00: disabled
[336087.621431] ata14: EH complete
[336087.621441] ata15: sas eh calling libata port error handler
[336087.621458] sas: --- Exit sas_scsi_recover_host
[336087.621532] md: super_written gets error=-5, uptodate=0
[336087.621543] md/raid:md1: Disk failure on sdi, disabling device.
[336087.621548] md/raid:md1: Operation continuing on 6 devices.
[336087.633709] sd 0:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336087.633726] sd 0:0:5:0: [sdi] Stopping disk
[336087.633753] sd 0:0:5:0: [sdi] START_STOP FAILED
[336087.633760] sd 0:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336087.729909] RAID conf printout:
[336087.729919]  --- level:5 rd:7 wd:6
[336087.729927]  disk 0, o:1, dev:sdf
[336087.729933]  disk 1, o:1, dev:sdg
[336087.729939]  disk 2, o:1, dev:sdd
[336087.729944]  disk 3, o:1, dev:sde
[336087.729950]  disk 4, o:1, dev:sdj
[336087.729955]  disk 5, o:0, dev:sdi
[336087.729960]  disk 6, o:1, dev:sdh
[336087.780031] RAID conf printout:
[336087.780042]  --- level:5 rd:7 wd:6
[336087.780051]  disk 0, o:1, dev:sdf
[336087.780058]  disk 1, o:1, dev:sdg
[336087.780064]  disk 2, o:1, dev:sdd
[336087.780075]  disk 3, o:1, dev:sde
[336087.780081]  disk 4, o:1, dev:sdj
[336087.780087]  disk 6, o:1, dev:sdh
[336092.088009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336094.140009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336101.140008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336103.192008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336105.244008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336126.672008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336128.724020] mvsas 0000:04:00.0: Phy6 : No sig fis
[336130.776027] mvsas 0000:04:00.0: Phy6 : No sig fis
[336132.828019] mvsas 0000:04:00.0: Phy6 : No sig fis
[336134.880020] mvsas 0000:04:00.0: Phy6 : No sig fis
[336136.932028] mvsas 0000:04:00.0: Phy6 : No sig fis
[336138.984011] mvsas 0000:04:00.0: Phy6 : No sig fis
[336141.036007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336143.088028] mvsas 0000:04:00.0: Phy6 : No sig fis
[336145.140016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336147.192015] mvsas 0000:04:00.0: Phy6 : No sig fis
[336149.244008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336151.296008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336153.348016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336155.036013] sas: phy-0:6 added to port-0:5, phy_mask:0x40 ( 600000000000000)
[336155.039108] sas: DOING DISCOVERY on port 5, pid:241
[336155.040784] sas: couldn't normalize sense
[336155.040882] sas: couldn't normalize sense
[336155.041323] sas: couldn't normalize sense
[336155.041360] sas: couldn't normalize sense
[336155.041385] sas: couldn't normalize sense
[336155.041397] sas: DONE DISCOVERY on port 5, pid:241, result:-70
[336155.400022] mvsas 0000:04:00.0: Phy6 : No sig fis
[336157.036020] mvsas 0000:04:00.0: Phy6 : No sig fis
[336157.452015] mvsas 0000:04:00.0: Phy6 : No sig fis
[336159.088011] mvsas 0000:04:00.0: Phy6 : No sig fis
[336159.504015] mvsas 0000:04:00.0: Phy6 : No sig fis
[336161.140019] mvsas 0000:04:00.0: Phy6 : No sig fis
[336161.556007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336163.192028] mvsas 0000:04:00.0: Phy6 : No sig fis
[336163.614344] mvsas 0000:04:00.0: Phy6 : No sig fis
[336165.052912] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336169.083708] mvsas 0000:04:00.0: Phy6 : No sig fis
[336171.094357] mvsas 0000:04:00.0: Phy6 : No sig fis
[336173.144028] mvsas 0000:04:00.0: Phy6 : No sig fis
[336175.196016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336177.248009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336178.764591] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336179.300010] mvsas 0000:04:00.0: Phy6 : No sig fis
[336180.772010] mvsas 0000:04:00.0: Phy6 : No sig fis
[336181.376430] mvsas 0000:04:00.0: Phy6 : No sig fis
[336182.824021] mvsas 0000:04:00.0: Phy6 : No sig fis
[336183.404026] mvsas 0000:04:00.0: Phy6 : No sig fis
[336184.876009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336185.456027] mvsas 0000:04:00.0: Phy6 : No sig fis
[336186.104503] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336186.928025] mvsas 0000:04:00.0: Phy6 : No sig fis
[336187.508027] mvsas 0000:04:00.0: Phy6 : No sig fis
[336188.104009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336189.016735] mvsas 0000:04:00.0: Phy6 : No sig fis
[336189.560026] mvsas 0000:04:00.0: Phy6 : No sig fis
[336190.156010] mvsas 0000:04:00.0: Phy6 : No sig fis
[336191.032009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336191.612007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336191.954511] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336204.656009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336206.708027] mvsas 0000:04:00.0: Phy6 : No sig fis
[336208.760017] mvsas 0000:04:00.0: Phy6 : No sig fis
[336210.592819] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336215.904035] sas: command 0xffff880132eb5b80, task 0xffff88018ecb7640, timed out: BLK_EH_NOT_HANDLED
[336215.904053] sas: command 0xffff88022310c280, task 0xffff88018ecb7d40, timed out: BLK_EH_NOT_HANDLED
[336215.904071] sas: command 0xffff88022310c480, task 0xffff88018ecb72c0, timed out: BLK_EH_NOT_HANDLED
[336215.904087] sas: command 0xffff880101c4a9c0, task 0xffff8801be42ae00, timed out: BLK_EH_NOT_HANDLED
[336215.904101] sas: command 0xffff880101c4adc0, task 0xffff88018ecb7480, timed out: BLK_EH_NOT_HANDLED
[336215.904115] sas: command 0xffff8800c16acd80, task 0xffff88018ecb7100, timed out: BLK_EH_NOT_HANDLED
[336215.904243] sas: Enter sas_scsi_recover_host
[336215.904251] sas: trying to find task 0xffff88018ecb7d40
[336215.904259] sas: sas_scsi_find_task: aborting task 0xffff88018ecb7d40
[336215.904273] sas: sas_scsi_find_task: querying task 0xffff88018ecb7d40
[336215.904282] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 5
[336215.904295] sas: sas_scsi_find_task: task 0xffff88018ecb7d40 failed to abort
[336215.904303] sas: task 0xffff88018ecb7d40 is not at LU: I_T recover
[336215.904311] sas: I_T nexus reset for dev 0500000000000000
[336216.019328] sas: sas_form_port: phy5 belongs to port4 already(1)!
[336216.436020] mvsas 0000:04:00.0: Phy6 : No sig fis
[336218.112077] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[4]:rc= 0
[336218.112097] sas: I_T 0500000000000000 recovered
[336218.112107] sas: sas_ata_task_done: SAS error 8d
[336218.112123] sas: trying to find task 0xffff88018ecb72c0
[336218.112130] sas: sas_scsi_find_task: aborting task 0xffff88018ecb72c0
[336218.112142] sas: sas_scsi_find_task: querying task 0xffff88018ecb72c0
[336218.112151] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 5
[336218.112163] sas: sas_scsi_find_task: task 0xffff88018ecb72c0 failed to abort
[336218.112171] sas: task 0xffff88018ecb72c0 is not at LU: I_T recover
[336218.112178] sas: I_T nexus reset for dev 0700000000000000
[336218.252109] sas: sas_form_port: phy7 belongs to port6 already(1)!
[336218.488009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336218.692478] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336220.320045] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[6]:rc= 0
[336220.320065] sas: I_T 0700000000000000 recovered
[336220.320075] sas: sas_ata_task_done: SAS error 8d
[336220.320090] sas: trying to find task 0xffff8801be42ae00
[336220.320097] sas: sas_scsi_find_task: aborting task 0xffff8801be42ae00
[336220.320109] sas: sas_scsi_find_task: querying task 0xffff8801be42ae00
[336220.320118] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 5
[336220.320130] sas: sas_scsi_find_task: task 0xffff8801be42ae00 failed to abort
[336220.320138] sas: task 0xffff8801be42ae00 is not at LU: I_T recover
[336220.320145] sas: I_T nexus reset for dev 0200000000000000
[336220.461268] sas: sas_form_port: phy2 belongs to port2 already(1)!
[336220.540007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336221.112022] mvsas 0000:04:00.0: Phy6 : No sig fis
[336222.528044] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[2]:rc= 0
[336222.528064] sas: I_T 0200000000000000 recovered
[336222.528074] sas: sas_ata_task_done: SAS error 8d
[336222.528092] sas: trying to find task 0xffff88018ecb7480
[336222.528100] sas: sas_scsi_find_task: aborting task 0xffff88018ecb7480
[336222.528112] sas: sas_scsi_find_task: querying task 0xffff88018ecb7480
[336222.528121] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 5
[336222.528133] sas: sas_scsi_find_task: task 0xffff88018ecb7480 failed to abort
[336222.528141] sas: task 0xffff88018ecb7480 is not at LU: I_T recover
[336222.528148] sas: I_T nexus reset for dev 0100000000000000
[336222.668186] sas: sas_form_port: phy1 belongs to port1 already(1)!
[336222.672128] mvsas 0000:04:00.0: Phy6 : No sig fis
[336223.164010] mvsas 0000:04:00.0: Phy6 : No sig fis
[336224.736650] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[336224.724018] mvsas 0000:04:00.0: Phy6 : No sig fis
[336224.770012] sas: I_T 0100000000000000 recovered
[336224.770023] sas: sas_ata_task_done: SAS error 8d
[336224.770038] sas: trying to find task 0xffff88018ecb7640
[336224.770045] sas: sas_scsi_find_task: aborting task 0xffff88018ecb7640
[336224.770059] sas: sas_scsi_find_task: querying task 0xffff88018ecb7640
[336224.770068] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 5
[336224.770081] sas: sas_scsi_find_task: task 0xffff88018ecb7640 failed to abort
[336224.770089] sas: task 0xffff88018ecb7640 is not at LU: I_T recover
[336224.770096] sas: I_T nexus reset for dev 0300000000000000
[336224.893130] sas: sas_form_port: phy3 belongs to port3 already(1)!
[336225.216016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336226.776017] mvsas 0000:04:00.0: Phy6 : No sig fis
[336226.976056] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[3]:rc= 0
[336226.976077] sas: I_T 0300000000000000 recovered
[336226.976086] sas: sas_ata_task_done: SAS error 8d
[336226.976100] sas: trying to find task 0xffff88018ecb7100
[336226.976107] sas: sas_scsi_find_task: aborting task 0xffff88018ecb7100
[336226.976119] sas: sas_scsi_find_task: querying task 0xffff88018ecb7100
[336226.976128] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 5
[336226.976140] sas: sas_scsi_find_task: task 0xffff88018ecb7100 failed to abort
[336226.976148] sas: task 0xffff88018ecb7100 is not at LU: I_T recover
[336226.976155] sas: I_T nexus reset for dev 0000000000000000
[336227.115496] sas: sas_form_port: phy0 belongs to port0 already(1)!
[336227.268016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336228.828006] mvsas 0000:04:00.0: Phy6 : No sig fis
[336229.184058] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[0]:rc= 0
[336229.184078] sas: I_T 0000000000000000 recovered
[336229.184126] sas: sas_ata_task_done: SAS error 8d
[336229.184142] ata9: sas eh calling libata port error handler
[336229.184160] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
[336229.185461] ata9.00: failed command: FLUSH CACHE EXT
[336229.186719] ata9.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336229.186725]          res 01/04:00:02:00:00/00:00:00:00:00/40 Emask 0x3 (HSM violation)
[336229.189330] ata9.00: status: { ERR }
[336229.190637] ata9.00: error: { ABRT }
[336229.191928] ata9: hard resetting link
[336229.332843] sas: sas_form_port: phy0 belongs to port0 already(1)!
[336229.362079] mvsas 0000:04:00.0: Phy6 : No sig fis
[336230.231814] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336231.396036] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[0]:rc= 0
[336231.396057] sas: sas_ata_hard_reset: Found ATA device.
[336231.396123] sas: sas_ata_task_done: SAS error 2
[336231.396375] sas: sas_ata_task_done: SAS error 2
[336231.396398] ata9.00: both IDENTIFYs aborted, assuming NODEV
[336231.396408] ata9.00: revalidation failed (errno=-2)
[336236.396046] ata9: hard resetting link
[336236.536967] sas: sas_form_port: phy0 belongs to port0 already(1)!
[336238.604053] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[0]:rc= 0
[336238.604073] sas: sas_ata_hard_reset: Found ATA device.
[336238.605307] sas: sas_ata_task_done: SAS error 2
[336238.605345] ata9.00: both IDENTIFYs aborted, assuming NODEV
[336238.605357] ata9.00: revalidation failed (errno=-2)
[336240.043050] sas: phy-0:6 added to port-0:5, phy_mask:0x40 ( 600000000000000)
[336240.043087] sas: DOING DISCOVERY on port 5, pid:241
[336240.043284] sas: couldn't normalize sense
[336240.043419] sas: couldn't normalize sense
[336240.044275] sas: couldn't normalize sense
[336240.044544] sas: couldn't normalize sense
[336240.044571] sas: couldn't normalize sense
[336240.044582] sas: DONE DISCOVERY on port 5, pid:241, result:-70
[336242.043419] mvsas 0000:04:00.0: Phy6 : No sig fis
[336243.604046] ata9: hard resetting link
[336243.745079] sas: sas_form_port: phy0 belongs to port0 already(1)!
[336244.092008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336244.279844] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336245.812054] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[0]:rc= 0
[336245.812074] sas: sas_ata_hard_reset: Found ATA device.
[336245.813309] sas: sas_ata_task_done: SAS error 2
[336245.813328] ata9.00: both IDENTIFYs aborted, assuming NODEV
[336245.813337] ata9.00: revalidation failed (errno=-2)
[336245.814641] ata9.00: disabled
[336245.814670] ata9: EH complete
[336245.814680] ata10: sas eh calling libata port error handler
[336245.814697] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
[336245.815988] ata10.00: failed command: FLUSH CACHE EXT
[336245.817315] ata10.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336245.817320]          res 01/04:00:02:00:00/00:00:00:00:00/40 Emask 0x3 (HSM violation)
[336245.819970] ata10.00: status: { ERR }
[336245.821318] ata10.00: error: { ABRT }
[336245.821332] ata10: hard resetting link
[336245.961948] sas: sas_form_port: phy1 belongs to port1 already(1)!
[336246.144015] mvsas 0000:04:00.0: Phy6 : No sig fis
[336246.335759] mvsas 0000:04:00.0: Phy6 : No sig fis
[336248.028054] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[336248.028074] sas: sas_ata_hard_reset: Found ATA device.
[336248.029238] sas: sas_ata_task_done: SAS error 2
[336248.029261] ata10.00: both IDENTIFYs aborted, assuming NODEV
[336248.029270] ata10.00: revalidation failed (errno=-2)
[336248.196020] mvsas 0000:04:00.0: Phy6 : No sig fis
[336248.384016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336248.576916] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336250.248019] mvsas 0000:04:00.0: Phy6 : No sig fis
[336250.436009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336251.004009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336252.300029] mvsas 0000:04:00.0: Phy6 : No sig fis
[336252.488004] mvsas 0000:04:00.0: Phy6 : No sig fis
[336253.028066] ata10: hard resetting link
[336253.056499] mvsas 0000:04:00.0: Phy6 : No sig fis
[336253.210941] sas: sas_form_port: phy1 belongs to port1 already(1)!
[336254.352012] mvsas 0000:04:00.0: Phy6 : No sig fis
[336254.540025] mvsas 0000:04:00.0: Phy6 : No sig fis
[336255.236072] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[336255.216024] mvsas 0000:04:00.0: Phy6 : No sig fis
[336255.261731] sas: sas_ata_hard_reset: Found ATA device.
[336255.262912] sas: sas_ata_task_done: SAS error 2
[336255.262928] ata10.00: both IDENTIFYs aborted, assuming NODEV
[336255.262937] ata10.00: revalidation failed (errno=-2)
[336256.441487] mvsas 0000:04:00.0: Phy6 : No sig fis
[336256.592011] mvsas 0000:04:00.0: Phy6 : No sig fis
[336257.268022] mvsas 0000:04:00.0: Phy6 : No sig fis
[336257.890198] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336258.456008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336258.644027] mvsas 0000:04:00.0: Phy6 : No sig fis
[336259.320009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336259.888012] mvsas 0000:04:00.0: Phy6 : No sig fis
[336260.260040] ata10: hard resetting link
[336260.400925] sas: sas_form_port: phy1 belongs to port1 already(1)!
[336260.508008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336260.696016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336261.372023] mvsas 0000:04:00.0: Phy6 : No sig fis
[336261.940009] mvsas 0000:04:00.0: Phy6 : No sig fis
[336262.134525] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336262.468065] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[336262.468085] sas: sas_ata_hard_reset: Found ATA device.
[336262.469277] sas: sas_ata_task_done: SAS error 2
[336262.469293] ata10.00: both IDENTIFYs aborted, assuming NODEV
[336262.469303] ata10.00: revalidation failed (errno=-2)
[336262.470547] ata10.00: disabled
[336262.470574] ata10: EH complete
[336262.470584] ata11: sas eh calling libata port error handler
[336262.470600] ata11.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
[336262.471840] ata11.00: failed command: FLUSH CACHE EXT
[336262.473107] ata11.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336262.473112]          res 01/04:00:02:00:00/00:00:00:00:00/40 Emask 0x3 (HSM violation)
[336262.475588] ata11.00: status: { ERR }
[336262.476877] ata11.00: error: { ABRT }
[336262.478130] ata11: hard resetting link
[336262.618411] sas: sas_form_port: phy2 belongs to port2 already(1)!
[336262.632358] mvsas 0000:04:00.0: Phy6 : No sig fis
[336262.748013] mvsas 0000:04:00.0: Phy6 : No sig fis
[336263.424007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336263.992007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336264.624020] mvsas 0000:04:00.0: Phy6 : No sig fis
[336264.684012] mvsas 0000:04:00.0: Phy6 : No sig fis
[336264.729914] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[2]:rc= 0
[336264.729938] sas: sas_ata_hard_reset: Found ATA device.
[336264.731152] sas: sas_ata_task_done: SAS error 2
[336264.731168] ata11.00: both IDENTIFYs aborted, assuming NODEV
[336264.731178] ata11.00: revalidation failed (errno=-2)
[336264.800016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336265.476014] mvsas 0000:04:00.0: Phy6 : No sig fis
[336266.044007] mvsas 0000:04:00.0: Phy6 : No sig fis
[336266.740249] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336269.728057] ata11: hard resetting link
[336269.868007] sas: sas_form_port: phy2 belongs to port2 already(1)!
[336270.931312] sas: phy-0:6 added to port-0:5, phy_mask:0x40 ( 600000000000000)
[336270.931348] sas: DOING DISCOVERY on port 5, pid:234
[336270.933271] sas: DONE DISCOVERY on port 5, pid:234, result:0
[336271.936042] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[2]:rc= 0
[336271.936062] sas: sas_ata_hard_reset: Found ATA device.
[336271.937244] sas: sas_ata_task_done: SAS error 2
[336271.937261] ata11.00: both IDENTIFYs aborted, assuming NODEV
[336271.937270] ata11.00: revalidation failed (errno=-2)
[336273.524008] mvsas 0000:04:00.0: Phy6 : No sig fis
[336275.576025] mvsas 0000:04:00.0: Phy6 : No sig fis
[336275.694665] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336276.936088] ata11: hard resetting link
[336276.971509] sas: sas_form_port: phy2 belongs to port2 already(1)!
[336277.638416] mvsas 0000:04:00.0: Phy6 : No sig fis
[336278.280016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336279.144039] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[2]:rc= 0
[336279.144059] sas: sas_ata_hard_reset: Found ATA device.
[336279.145261] sas: sas_ata_task_done: SAS error 2
[336279.145279] ata11.00: both IDENTIFYs aborted, assuming NODEV
[336279.145288] ata11.00: revalidation failed (errno=-2)
[336279.146535] ata11.00: disabled
[336279.146564] ata11: EH complete
[336279.146574] ata12: sas eh calling libata port error handler
[336279.146590] ata12.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
[336279.147804] ata12.00: failed command: FLUSH CACHE EXT
[336279.149073] ata12.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336279.149078]          res 01/04:00:02:00:00/00:00:00:00:00/40 Emask 0x3 (HSM violation)
[336279.151637] ata12.00: status: { ERR }
[336279.152933] ata12.00: error: { ABRT }
[336279.154183] ata12: hard resetting link
[336279.277325] sas: sas_form_port: phy3 belongs to port3 already(1)!
[336279.680712] mvsas 0000:04:00.0: Phy6 : No sig fis
[336280.332023] mvsas 0000:04:00.0: Phy6 : No sig fis
[336281.360053] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[3]:rc= 0
[336281.360072] sas: sas_ata_hard_reset: Found ATA device.
[336281.361255] sas: sas_ata_task_done: SAS error 2
[336281.361271] ata12.00: both IDENTIFYs aborted, assuming NODEV
[336281.361280] ata12.00: revalidation failed (errno=-2)
[336281.732028] mvsas 0000:04:00.0: Phy6 : No sig fis
[336282.384019] mvsas 0000:04:00.0: Phy6 : No sig fis
[336283.784025] mvsas 0000:04:00.0: Phy6 : No sig fis
[336284.436016] mvsas 0000:04:00.0: Phy6 : No sig fis
[336285.836018] mvsas 0000:04:00.0: Phy6 : No sig fis
[336286.360058] ata12: hard resetting link
[336286.483412] sas: sas_form_port: phy3 belongs to port3 already(1)!
[336286.488013] mvsas 0000:04:00.0: Phy6 : No sig fis
[336287.096103] sas: sas_form_port: phy6 belongs to port5 already(1)!
[336288.568067] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[3]:rc= 0
[336288.568087] sas: sas_ata_hard_reset: Found ATA device.
[336288.569263] sas: sas_ata_task_done: SAS error 2
[336288.569279] ata12.00: both IDENTIFYs aborted, assuming NODEV
[336288.569288] ata12.00: revalidation failed (errno=-2)
[336293.568068] ata12: hard resetting link
[336293.691475] sas: sas_form_port: phy3 belongs to port3 already(1)!
[336295.776058] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[3]:rc= 0
[336295.776078] sas: sas_ata_hard_reset: Found ATA device.
[336295.777251] sas: sas_ata_task_done: SAS error 2
[336295.777268] ata12.00: both IDENTIFYs aborted, assuming NODEV
[336295.777277] ata12.00: revalidation failed (errno=-2)
[336295.778477] ata12.00: disabled
[336295.778505] ata12: EH complete
[336295.778515] ata13: sas eh calling libata port error handler
[336295.778531] ata13.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
[336295.779727] ata13.00: failed command: FLUSH CACHE EXT
[336295.780959] ata13.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336295.780964]          res 01/04:00:02:00:00/00:00:00:00:00/40 Emask 0x3 (HSM violation)
[336295.783398] ata13.00: status: { ERR }
[336295.784635] ata13.00: error: { ABRT }
[336295.785840] ata13: hard resetting link
[336295.908875] sas: sas_form_port: phy5 belongs to port4 already(1)!
[336297.992120] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[4]:rc= 0
[336297.992141] sas: sas_ata_hard_reset: Found ATA device.
[336297.993387] sas: sas_ata_task_done: SAS error 2
[336297.993424] ata13.00: both IDENTIFYs aborted, assuming NODEV
[336297.993436] ata13.00: revalidation failed (errno=-2)
[336302.992048] ata13: hard resetting link
[336303.114876] sas: sas_form_port: phy5 belongs to port4 already(1)!
[336305.200055] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[4]:rc= 0
[336305.200075] sas: sas_ata_hard_reset: Found ATA device.
[336305.201298] sas: sas_ata_task_done: SAS error 2
[336305.201316] ata13.00: both IDENTIFYs aborted, assuming NODEV
[336305.201325] ata13.00: revalidation failed (errno=-2)
[336310.200068] ata13: hard resetting link
[336310.322919] sas: sas_form_port: phy5 belongs to port4 already(1)!
[336312.408040] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[4]:rc= 0
[336312.408060] sas: sas_ata_hard_reset: Found ATA device.
[336312.409251] sas: sas_ata_task_done: SAS error 2
[336312.409269] ata13.00: both IDENTIFYs aborted, assuming NODEV
[336312.409277] ata13.00: revalidation failed (errno=-2)
[336312.410467] ata13.00: disabled
[336312.410498] ata13: EH complete
[336312.410509] ata15: sas eh calling libata port error handler
[336312.410524] ata15.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
[336312.411712] ata15.00: failed command: FLUSH CACHE EXT
[336312.412941] ata15.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[336312.412946]          res 01/04:00:02:00:00/00:00:00:00:00/40 Emask 0x3 (HSM violation)
[336312.415324] ata15.00: status: { ERR }
[336312.416496] ata15.00: error: { ABRT }
[336312.417633] ata15: hard resetting link
[336312.558061] sas: sas_form_port: phy7 belongs to port6 already(1)!
[336314.624041] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[6]:rc= 0
[336314.624061] sas: sas_ata_hard_reset: Found ATA device.
[336314.625268] sas: sas_ata_task_done: SAS error 2
[336314.625284] ata15.00: both IDENTIFYs aborted, assuming NODEV
[336314.625293] ata15.00: revalidation failed (errno=-2)
[336319.628017] ata15: hard resetting link
[336319.770143] sas: sas_form_port: phy7 belongs to port6 already(1)!
[336321.836042] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[6]:rc= 0
[336321.836063] sas: sas_ata_hard_reset: Found ATA device.
[336321.837273] sas: sas_ata_task_done: SAS error 2
[336321.837298] ata15.00: both IDENTIFYs aborted, assuming NODEV
[336321.837307] ata15.00: revalidation failed (errno=-2)
[336326.836070] ata15: hard resetting link
[336326.977246] sas: sas_form_port: phy7 belongs to port6 already(1)!
[336329.048032] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[6]:rc= 0
[336329.048052] sas: sas_ata_hard_reset: Found ATA device.
[336329.049249] sas: sas_ata_task_done: SAS error 2
[336329.049271] ata15.00: both IDENTIFYs aborted, assuming NODEV
[336329.049280] ata15.00: revalidation failed (errno=-2)
[336329.050385] ata15.00: disabled
[336329.050412] ata15: EH complete
[336329.050420] sas: --- Exit sas_scsi_recover_host
[336329.050667] sd 0:0:0:0: [sdd] Unhandled error code
[336329.050675] sd 0:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.050686] sd 0:0:0:0: [sdd] CDB: Read(10): 28 00 3c 89 aa
[336329.050709] sd 0:0:0:0: [sdd] Unhandled error code
[336329.050719] sd 0:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.050733] sd 0:0:0:0: [sdd] CDB: Write(10) 80 00 00 08 00
[336329.050749] end_request: I/O error, dev sdd, sector 1015655040
[336329.050772] sd 0:0:0:0: [sdd] Unhandled error code
[336329.050778] sd 0:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.050786] sd 0:0:0:0: [sdd] CDB: Read(10): 28 00 73 0d 65 08 00 00 c0 00
[336329.050801] end_request: I/O error, dev sdd, sector 1930257672
[336329.050817] sd 0:0:0:0: [sdd] Unhandled error code
[336329.050823] sd 0:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.050831] sd 0:0:0:0: [sdd] CDB: Read(10): 28 00 73 0d 65 e8 00 03 20 00
[336329.050845] end_request: I/O error, dev sdd, sector 1930257896
[336329.050905] sd 0:0:3:0: [sdg] Unhandled error code
[336329.050911] sd 0:0:3:0: [sdg]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.050920] sd 0:0:3:0: [sdg] CDB: Read(10): 28 00 26 9c a8 78 00 00 08 00
[336329.050933] end_request: I/O error, dev sdg, sector 647800952
[336329.050947] sd 0:0:3:0: [sdg] Unhandled error code
[336329.050952] sd 0:0:3:0: [sdg]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.050961] sd 0:0:3:0: [sdg] CDB: Read(10): 28 00 26 9c a8 c8 00 00 08 00
[336329.050974] end_request: I/O error, dev sdg, sector 647801032
[336329.051082] sd 0:0:1:0: [sde] Unhandled error code
[336329.051087] sd 0:0:1:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051096] sd 0:0:1:0: [sde] CDB: Write(10): 2a 00 00 00 00 00 00 00 02 00
[336329.051109] end_request: I/O error, dev sde, sector 0
[336329.051117] end_request: I/O error, dev sde, sector 0
[336329.051123] md: super_written gets error=-5, uptodate=0
[336329.051133] md/raid:md1: Disk failure on sde, disabling device.
[336329.051137] md/raid:md1: Operation continuing on 5 devices.
[336329.051160] sd 0:0:1:0: [sde] Unhandled error code
[336329.051165] sd 0:0:1:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051174] sd 0:0:1:0: [sde] CDB: Read(10): 28 00 26 86 3d b0 00 00 10 00
[336329.051187] end_request: I/O error, dev sde, sector 646331824
[336329.051205] sd 0:0:1:0: [sde] Unhandled error code
[336329.051211] sd 0:0:1:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051219] sd 0:0:1:0: [sde] CDB: Read(10): 28 00 73 0d 65 08 00 04 00 00
[336329.051233] end_request: I/O error, dev sde, sector 1930257672
[336329.051250] sd 0:0:2:0: [sdf] Unhandled error code
[336329.051256] sd 0:0:2:0: [sdf]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051264] sd 0:0:2:0: [sdf] CDB: Write(10): 2a 00 00 00 00 00 00 00 02 00
[336329.051277] end_request: I/O error, dev sdf, sector 0
[336329.051285] end_request: I/O error, dev sdf, sector 0
[336329.051291] md: super_written gets error=-5, uptodate=0
[336329.051300] md/raid:md1: Disk failure on sdf, disabling device.
[336329.051303] md/raid:md1: Operation continuing on 4 devices.
[336329.051319] sd 0:0:2:0: [sdf] Unhandled error code
[336329.051325] sd 0:0:2:0: [sdf]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051333] sd 0:0:2:0: [sdf] CDB: Read(10): 28 00 73 0d 65 08 00 04 00 00
[336329.051347] end_request: I/O error, dev sdf, sector 1930257672
[336329.051364] sd 0:0:4:0: [sdh] Unhandled error code
[336329.051369] sd 0:0:4:0: [sdh]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051378] sd 0:0:4:0: [sdh] CDB: Write(10): 2a 00 00 00 00 00 00 00 02 00
[336329.051391] end_request: I/O error, dev sdh, sector 0
[336329.051398] end_request: I/O error, dev sdh, sector 0
[336329.051404] md: super_written gets error=-5, uptodate=0
[336329.051411] md/raid:md1: Disk failure on sdh, disabling device.
[336329.051415] md/raid:md1: Operation continuing on 3 devices.
[336329.051426] sd 0:0:4:0: [sdh] Unhandled error code
[336329.051432] sd 0:0:4:0: [sdh]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051440] sd 0:0:4:0: [sdh] CDB: Read(10): 28 00 26 9b e4 c0 00 00 08 00
[336329.051454] end_request: I/O error, dev sdh, sector 647750848
[336329.051470] sd 0:0:4:0: [sdh] Unhandled error code
[336329.051475] sd 0:0:4:0: [sdh]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051484] sd 0:0:4:0: [sdh] CDB: Read(10): 28 00 73 0d 65 b0 00 04 00 00
[336329.051497] end_request: I/O error, dev sdh, sector 1930257840
[336329.051514] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051519] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051528] sd 0:0:6:0: [sdj] CDB: Write(10): 2a 00 00 00 00 00 00 00 02 00
[336329.051541] end_request: I/O error, dev sdj, sector 0
[336329.051548] end_request: I/O error, dev sdj, sector 0
[336329.051553] md: super_written gets error=-5, uptodate=0
[336329.051561] md/raid:md1: Disk failure on sdj, disabling device.
[336329.051565] md/raid:md1: Operation continuing on 2 devices.
[336329.051576] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051581] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051590] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c a5 90 00 00 08 00
[336329.051603] end_request: I/O error, dev sdj, sector 647800208
[336329.051615] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051620] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051629] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c a6 18 00 00 08 00
[336329.051642] end_request: I/O error, dev sdj, sector 647800344
[336329.051653] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051659] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051667] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c a6 28 00 00 08 00
[336329.051680] end_request: I/O error, dev sdj, sector 647800360
[336329.051691] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051697] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051705] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c a0 b0 00 00 08 00
[336329.051719] end_request: I/O error, dev sdj, sector 647798960
[336329.051730] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051735] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051743] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c a0 70 00 00 08 00
[336329.051757] end_request: I/O error, dev sdj, sector 647798896
[336329.051768] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051774] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051782] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c a0 00 00 00 20 00
[336329.051795] end_request: I/O error, dev sdj, sector 647798784
[336329.051807] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051812] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051821] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 26 9c 9f e8 00 00 10 00
[336329.051834] end_request: I/O error, dev sdj, sector 647798760
[336329.051845] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051850] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051859] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 69 32 95 60 00 00 08 00
[336329.051872] end_request: I/O error, dev sdj, sector 1764922720
[336329.051887] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051893] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051901] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 73 0d 62 e8 00 03 18 00
[336329.051915] end_request: I/O error, dev sdj, sector 1930257128
[336329.051932] sd 0:0:6:0: [sdj] Unhandled error code
[336329.051937] sd 0:0:6:0: [sdj]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.051946] sd 0:0:6:0: [sdj] CDB: Read(10): 28 00 73 0d 66 00 00 03 08 00
[336329.051959] end_request: I/O error, dev sdj, sector 1930257920
[336329.192371] : 2a 00 00 00 00 00 00 00 02 00
[336329.192388] end_request: I/O error, dev sdd, sector 0
[336329.195799] end_request: I/O error, dev sdd, sector 0
[336329.196244] md: super_written gets error=-5, uptodate=0
[336329.196244] md/raid:md1: Disk failure on sdd, disabling device.
[336329.196244] md/raid:md1: Operation continuing on 1 devices.
[336329.206083] sd 0:0:3:0: [sdg] Unhandled error code
[336329.206090] sd 0:0:3:0: [sdg]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.206104] sd 0:0:3:0: [sdg] CDB: Write(10): 2a 00 00 00 00 00 00 00 02 00
[336329.206175] end_request: I/O error, dev sdg, sector 0
[336329.209586] end_request: I/O error, dev sdg, sector 0
[336329.212880] md: super_written gets error=-5, uptodate=0
[336329.212888] md/raid:md1: Disk failure on sdg, disabling device.
[336329.212893] md/raid:md1: Operation continuing on 0 devices.
[336329.219534] sd 0:0:3:0: [sdg] Unhandled error code
[336329.219545] sd 0:0:3:0: [sdg]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.219562] sd 0:0:3:0: [sdg] CDB: Read(10):
[336329.219580] RAID conf printout:
[336329.219590]  --- level:5 rd:7 wd:0
[336329.219600]  disk 0, o:0, dev:sdf
[336329.219608]  28 00 3c 89 a9 c0 00 00 08 00
[336329.219642] end_request: I/O error, dev sdg, sector 1015654848
[336329.219663] sd 0:0:3:0: [sdg] Unhandled error code
[336329.219670] sd 0:0:3:0: [sdg]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.219682] sd 0:0:3:0: [sdg] CDB: Read(10): 28 00 73 0d 65 08 00 01 60 00
[336329.219710] end_request: I/O error, dev sdg, sector 1930257672
[336329.219728] sd 0:0:3:0: [sdg] Unhandled error code
[336329.219735] sd 0:0:3:0: [sdg]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[336329.219747] sd 0:0:3:0: [sdg] CDB: Read(10): 28 00 73 0d 66 88 00 02 80 00
[336329.219776] end_request: I/O error, dev sdg, sector 1930258056
[336329.222304]  disk 1, o:0, dev:sdg
[336329.222310]  disk 2, o:0, dev:sdd
[336329.222315]  disk 3, o:0, dev:sde
[336329.222321]  disk 4, o:0, dev:sdj
[336329.222326]  disk 6, o:0, dev:sdh
[336329.264049] RAID conf printout:
[336329.264058]  --- level:5 rd:7 wd:0
[336329.264065]  disk 1, o:0, dev:sdg
[336329.264071]  disk 2, o:0, dev:sdd
[336329.264076]  disk 3, o:0, dev:sde
[336329.264081]  disk 4, o:0, dev:sdj
[336329.264087]  disk 6, o:0, dev:sdh
[336329.264103] RAID conf printout:
[336329.264108]  --- level:5 rd:7 wd:0
[336329.264114]  disk 1, o:0, dev:sdg
[336329.264119]  disk 2, o:0, dev:sdd
[336329.264124]  disk 3, o:0, dev:sde
[336329.264129]  disk 4, o:0, dev:sdj
[336329.264134]  disk 6, o:0, dev:sdh
[336329.312133] RAID conf printout:
[336329.312142]  --- level:5 rd:7 wd:0
[336329.312149]  disk 1, o:0, dev:sdg
[336329.312155]  disk 2, o:0, dev:sdd
[336329.312160]  disk 3, o:0, dev:sde
[336329.312166]  disk 4, o:0, dev:sdj
[336329.312180] RAID conf printout:
[336329.312185]  --- level:5 rd:7 wd:0
[336329.312190]  disk 1, o:0, dev:sdg
[336329.312195]  disk 2, o:0, dev:sdd
[336329.312200]  disk 3, o:0, dev:sde
[336329.312205]  disk 4, o:0, dev:sdj
[336329.380056] RAID conf printout:
[336329.380065]  --- level:5 rd:7 wd:0
[336329.380072]  disk 1, o:0, dev:sdg
[336329.380077]  disk 2, o:0, dev:sdd
[336329.380083]  disk 3, o:0, dev:sde
[336329.380098] RAID conf printout:
[336329.380103]  --- level:5 rd:7 wd:0
[336329.380108]  disk 1, o:0, dev:sdg
[336329.380113]  disk 2, o:0, dev:sdd
[336329.380118]  disk 3, o:0, dev:sde
[336329.416082] RAID conf printout:
[336329.416092]  --- level:5 rd:7 wd:0
[336329.416100]  disk 1, o:0, dev:sdg
[336329.416107]  disk 2, o:0, dev:sdd
[336329.416121] RAID conf printout:
[336329.416126]  --- level:5 rd:7 wd:0
[336329.416131]  disk 1, o:0, dev:sdg
[336329.416137]  disk 2, o:0, dev:sdd
[336329.416312] RAID conf printout:
[336329.416322]  --- level:5 rd:7 wd:0
[336329.416330]  disk 1, o:0, dev:sdg
[336329.416346] RAID conf printout:
[336329.416352]  --- level:5 rd:7 wd:0
[336329.416357]  disk 1, o:0, dev:sdg
[336329.420507] RAID conf printout:
[336329.420515]  --- level:5 rd:7 wd:0
[336329.429210] XFS (md1): I/O error occurred: meta-data dev md1 block 0xe92f0bf8       ("xfs_trans_read_buf") error 5 buf count 4096
[336329.429341] Buffer I/O error on device md1, logical block 485972532
[336329.429348] lost page write due to I/O error on md1
[336329.429360] Buffer I/O error on device md1, logical block 485972533
[336329.429366] lost page write due to I/O error on md1
[336329.429374] Buffer I/O error on device md1, logical block 485972534
[336329.429380] lost page write due to I/O error on md1
[336329.429387] Buffer I/O error on device md1, logical block 485972535
[336329.429392] lost page write due to I/O error on md1
[336329.429399] Buffer I/O error on device md1, logical block 485972536
[336329.429405] lost page write due to I/O error on md1
[336329.429412] Buffer I/O error on device md1, logical block 485972537
[336329.429417] lost page write due to I/O error on md1
[336329.429424] Buffer I/O error on device md1, logical block 485972538
[336329.429430] lost page write due to I/O error on md1
[336329.429437] Buffer I/O error on device md1, logical block 485972539
[336329.429443] lost page write due to I/O error on md1
[336329.429450] Buffer I/O error on device md1, logical block 485972540
[336329.429456] lost page write due to I/O error on md1
[336329.429462] Buffer I/O error on device md1, logical block 485972541
[336329.429468] lost page write due to I/O error on md1
[336329.431515] XFS (md1): I/O error occurred: meta-data dev md1 block 0xe90ebca8       ("xlog_iodone") error 5 buf count 32768
[336329.431531] XFS (md1): xfs_do_force_shutdown(0x2) called from line 891 of file /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/fs/xfs/xfs_log.c.  Return address = 0xffffffffa050a758
[336329.431598] XFS (md1): Log I/O Error Detected.  Shutting down filesystem
[336329.431606] XFS (md1): Please umount the filesystem and rectify the problem(s)
[336359.520105] XFS (md1): xfs_log_force: error 5 returned.
[336389.600065] XFS (md1): xfs_log_force: error 5 returned.
[336419.680073] XFS (md1): xfs_log_force: error 5 returned.
[336449.760067] XFS (md1): xfs_log_force: error 5 returned.
[336479.840083] XFS (md1): xfs_log_force: error 5 returned.
[336509.920068] XFS (md1): xfs_log_force: error 5 returned.
[336533.065989] nfsd: non-standard errno: 5
[336540.000067] XFS (md1): xfs_log_force: error 5 returned.
[336570.080069] XFS (md1): xfs_log_force: error 5 returned.
[336600.160082] XFS (md1): xfs_log_force: error 5 returned.

So this time, I may have lost my entire raid array. I'm going to attempt to
reboot, or re-assemble the array at some point, probably tonight, to see
if my array is hosed or not.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

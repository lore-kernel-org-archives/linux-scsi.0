From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 23 Feb 2010 11:11:17 +0100 (CET)
Message-ID: <16370.87.210.74.220.1266919877.squirrel@ketsers.dhs.org>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
    <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
    <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
    <6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
    <73e903671002170516r6df93ea6o6e0ee256cb8f7a59@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100223111117_99713"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:33968 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0BWKLU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 05:11:20 -0500
Received: from ns1.emsolutions.nl (www-data@localhost.localdomain [127.0.0.1])
	by ns1.emsolutions.nl (8.13.8/8.13.8/Debian-3) with ESMTP id o1NABIlJ001909
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 11:11:18 +0100
In-Reply-To: <73e903671002170516r6df93ea6o6e0ee256cb8f7a59@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

------=_20100223111117_99713
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi Srinivas,

I finally had some time to test your new patch.

1) After numerous hotplug actions with SAS and SATA disks I still can't
get any kernel panic to occur :)

2) I can finally boot a system with 3x 6480 controllers loaded with SATA
disks without a kernel panic.

3) Raid5/6 initialization completes without dropping the disks one after
another.

4) One thing that occured was the following: during a raid1 initialization
of 2 SAS disks and a raid5 init of 8x SSD's i got a call trace by
libata-core.c (see attachment for details). The system continued to work
fine after the trace.

Great work, this is a much more stable driver now!

Kind regards,
Caspar Smit

> On Wed, Feb 17, 2010 at 12:53 PM, Srinivas Naga Venkatasatya
> Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
>> Hi Smit,
>>
>> This patch is not exactly replaced with Nov-09 patches.
>> My patch addresses the RAID5/6 issues also. Below issues are addressed
>> by my patch.
>> 1. Tape issues.
>> 2. RAID-5/6 I/O fails.
>> 3. LVM IO fails and subsequent init 6 hang (connect SAS+SATA in cascaded
>>        expanders, crate volume group and logical volumes, run file I/O  
>>       (alltest), unplug one drive)
>> 4. Disk stress I/O on 4096 sector size.
>> 5. Hot insertion of drives giving panic.
>> 6. 'fdisk -l' hangs with hot plugging of SATA/SAS drives in expander
>> while      IO (Diskstress and alltest) is going on and IO stopped.
>>
>> I can't combined my patch with November-09 patches. James also rejected
>> those patches as those are not proper. Let me know if you have issues
>> with my patch.
>>
>> --Srini.
>
>
> I haven't tested yet, but looks like you're doing excellent work, and
> your documentation/overview of the work is superb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------=_20100223111117_99713
Content-Type: text/x-log; name="mvsas-patch.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mvsas-patch.log"

[ 1100.142515] xfs_db[3741]: segfault at 40 ip 00007f77b49b14aa sp 00007fff97e87ec0 error 4 in libpthread-2.7.so[7f77b49a9000+16000]
[ 1105.078922] xfs_db[3762]: segfault at 40 ip 00007f358fc264aa sp 00007fff802ba850 error 4 in libpthread-2.7.so[7f358fc1e000+16000]
[ 1108.135893] xfs_db[3777]: segfault at 40 ip 00007f10890a04aa sp 00007fff2f96c140 error 4 in libpthread-2.7.so[7f1089098000+16000]
[ 1131.700988] md: md1 stopped.
[ 1131.701083] md: unbind<sdg>
[ 1131.717573] md: export_rdev(sdg)
[ 1131.717665] md: unbind<sdh>
[ 1131.737511] md: export_rdev(sdh)
[ 1131.737617] md: unbind<sdi>
[ 1131.769010] md: export_rdev(sdi)
[ 1131.769115] md: unbind<sdj>
[ 1131.801010] md: export_rdev(sdj)
[ 1131.801110] md: unbind<sdk>
[ 1131.833010] md: export_rdev(sdk)
[ 1131.833111] md: unbind<sdd>
[ 1131.865009] md: export_rdev(sdd)
[ 1131.865108] md: unbind<sde>
[ 1131.897010] md: export_rdev(sde)
[ 1131.897115] md: unbind<sdf>
[ 1131.929009] md: export_rdev(sdf)
[ 1140.771637] md: md0 stopped.
[ 1140.771723] md: unbind<sdm>
[ 1140.785584] md: export_rdev(sdm)
[ 1140.785672] md: unbind<sdl>
[ 1140.809512] md: export_rdev(sdl)
[ 1160.695681] md: bind<sdb>
[ 1160.729238] md: bind<sdc>
[ 1160.771823] raid1: md0 is not clean -- starting background reconstruction
[ 1160.771899] raid1: raid set md0 active with 2 out of 2 mirrors
[ 1160.771991] md0: detected capacity change from 0 to 299999887360
[ 1160.772138]  md0: unknown partition table
[ 1160.777851] md: md0 switched to read-write mode.
[ 1160.778032] md: resync of RAID array md0
[ 1160.778103] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1160.778176] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[ 1160.778277] md: using 128k window, over a total of 292968640 blocks.
[ 1188.740257] md: bind<sdd>
[ 1188.742869] md: bind<sde>
[ 1188.746254] md: bind<sdf>
[ 1188.748809] md: bind<sdg>
[ 1188.752187] md: bind<sdh>
[ 1188.754698] md: bind<sdi>
[ 1188.758394] md: bind<sdj>
[ 1188.762040] md: bind<sdk>
[ 1188.805114] async_tx: api initialized (async)
[ 1188.806118] xor: automatically using best checksumming function: generic_sse
[ 1188.825503]    generic_sse:  7623.000 MB/sec
[ 1188.825574] xor: using function: generic_sse (7623.000 MB/sec)
[ 1188.893508] raid6: int64x1   1658 MB/s
[ 1188.961522] raid6: int64x2   2219 MB/s
[ 1189.029509] raid6: int64x4   1809 MB/s
[ 1189.097524] raid6: int64x8   1476 MB/s
[ 1189.165520] raid6: sse2x1    3208 MB/s
[ 1189.233504] raid6: sse2x2    5342 MB/s
[ 1189.301514] raid6: sse2x4    6115 MB/s
[ 1189.301583] raid6: using algorithm sse2x4 (6115 MB/s)
[ 1189.307208] md: raid6 personality registered for level 6
[ 1189.307281] md: raid5 personality registered for level 5
[ 1189.307351] md: raid4 personality registered for level 4
[ 1189.307517] raid5: md1 is not clean -- starting background reconstruction
[ 1189.307606] raid5: device sdk operational as raid disk 7
[ 1189.307677] raid5: device sdj operational as raid disk 6
[ 1189.307748] raid5: device sdi operational as raid disk 5
[ 1189.307824] raid5: device sdh operational as raid disk 4
[ 1189.307904] raid5: device sdg operational as raid disk 3
[ 1189.307975] raid5: device sdf operational as raid disk 2
[ 1189.308053] raid5: device sde operational as raid disk 1
[ 1189.308124] raid5: device sdd operational as raid disk 0
[ 1189.309007] raid5: allocated 8490kB for md1
[ 1189.309106] 7: w=1 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309178] 6: w=2 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309249] 5: w=3 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309320] 4: w=4 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309402] 3: w=5 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309488] 2: w=6 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309560] 1: w=7 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309631] 0: w=8 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[ 1189.309704] raid5: raid level 5 set md1 active with 8 out of 8 devices, algorithm 2
[ 1189.309793] RAID5 conf printout:
[ 1189.309871]  --- rd:8 wd:8
[ 1189.309952]  disk 0, o:1, dev:sdd
[ 1189.310020]  disk 1, o:1, dev:sde
[ 1189.310088]  disk 2, o:1, dev:sdf
[ 1189.310155]  disk 3, o:1, dev:sdg
[ 1189.310223]  disk 4, o:1, dev:sdh
[ 1189.310290]  disk 5, o:1, dev:sdi
[ 1189.310374]  disk 6, o:1, dev:sdj
[ 1189.310452]  disk 7, o:1, dev:sdk
[ 1189.310554] md1: detected capacity change from 0 to 1120292569088
[ 1189.310798]  md1: unknown partition table
[ 1189.316651] md: md1 switched to read-write mode.
[ 1189.316769] md: resync of RAID array md1
[ 1189.316841] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1189.316913] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[ 1189.317016] md: using 128k window, over a total of 156290816 blocks.
[ 1284.699817] xfs_db[7994]: segfault at 40 ip 00007f70c0b364aa sp 00007fff884bea30 error 4 in libpthread-2.7.so[7f70c0b2e000+16000]
[ 1296.888175] md: bind<sdl>
[ 1297.219915] md: bind<sdm>
[ 1297.276953] md: raid0 personality registered for level 0
[ 1297.277236] raid0: looking at sdm
[ 1297.277325] raid0:   comparing sdm(976772864)
[ 1297.277431]  with sdm(976772864)
[ 1297.277586] raid0:   END
[ 1297.277667] raid0:   ==> UNIQUE
[ 1297.277773] raid0: 1 zones
[ 1297.284951] raid0: looking at sdl
[ 1297.285020] raid0:   comparing sdl(976772864)
[ 1297.285075]  with sdm(976772864)
[ 1297.285232] raid0:   EQUAL
[ 1297.285300] raid0: FINAL 1 zones
[ 1297.285374] raid0: done.
[ 1297.285443] raid0 : md_size is 1953545728 sectors.
[ 1297.285513] ******* md2 configuration *********
[ 1297.285613] zone0=[sdl/sdm/]
[ 1297.285823]         zone offset=0kb device offset=0kb size=976772864kb
[ 1297.285897] **********************************
[ 1297.285898] 
[ 1297.286080] md2: detected capacity change from 0 to 1000215412736
[ 1297.288874]  md2: unknown partition table
[ 1342.746487] xfs_db[9907]: segfault at 40 ip 00007f164988d4aa sp 00007fffcea0bc30 error 4 in libpthread-2.7.so[7f1649885000+16000]
[ 1834.791615] ------------[ cut here ]------------
[ 1834.791722] WARNING: at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/ata/libata-core.c:5186 ata_qc_issue+0x10a/0x347 [libata]()
[ 1834.791823] Hardware name: X7DWU
[ 1834.791890] Modules linked in: raid0 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx iscsi_trgt crc32c nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs coretemp w83627hf w83793 hwmon_vid loop netconsole configfs i2c_i801 evdev rng_core i2c_core ioatdma uhci_hcd ehci_hcd container usbcore nls_base i5k_amb snd_pcsp snd_pcm snd_timer snd soundcore snd_page_alloc i5400_edac edac_core button processor shpchp pci_hotplug dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid10 raid1 md_mod thermal fan thermal_sys mvsas libsas scsi_transport_sas sata_mv e1000e igb dca ext3 jbd mbcache sd_mod crc_t10dif ata_piix libata scsi_mod
[ 1834.795527] Pid: 3070, comm: smartd Not tainted 2.6.32-bpo.2-amd64 #1
[ 1834.795527] Call Trace:
[ 1834.795527]  [<ffffffffa0034129>] ? ata_qc_issue+0x10a/0x347 [libata]
[ 1834.795527]  [<ffffffffa0034129>] ? ata_qc_issue+0x10a/0x347 [libata]
[ 1834.795527]  [<ffffffff8104dbe4>] ? warn_slowpath_common+0x77/0xa3
[ 1834.795527]  [<ffffffffa0038471>] ? ata_scsi_pass_thru+0x0/0x238 [libata]
[ 1834.795527]  [<ffffffffa0034129>] ? ata_qc_issue+0x10a/0x347 [libata]
[ 1834.795527]  [<ffffffffa0038471>] ? ata_scsi_pass_thru+0x0/0x238 [libata]
[ 1834.795527]  [<ffffffffa00008a5>] ? scsi_done+0x0/0xc [scsi_mod]
[ 1834.795527]  [<ffffffffa003966a>] ? __ata_scsi_queuecmd+0x185/0x1dc [libata]
[ 1834.795527]  [<ffffffffa00008a5>] ? scsi_done+0x0/0xc [scsi_mod]
[ 1834.795527]  [<ffffffffa010ad48>] ? sas_queuecommand+0x93/0x283 [libsas]
[ 1834.795527]  [<ffffffffa0000b77>] ? scsi_dispatch_cmd+0x1c0/0x23c [scsi_mod]
[ 1834.795527]  [<ffffffffa0006325>] ? scsi_request_fn+0x4be/0x506 [scsi_mod]
[ 1834.795527]  [<ffffffffa000620c>] ? scsi_request_fn+0x3a5/0x506 [scsi_mod]
[ 1834.795527]  [<ffffffff81177ba0>] ? __blk_run_queue+0x35/0x66
[ 1834.795527]  [<ffffffff8116f914>] ? elv_insert+0xad/0x260
[ 1834.795527]  [<ffffffff8117af74>] ? blk_execute_rq_nowait+0x5d/0x89
[ 1834.795527]  [<ffffffff8117b035>] ? blk_execute_rq+0x95/0xd0
[ 1834.795527]  [<ffffffff81177077>] ? __freed_request+0x26/0x82
[ 1834.795527]  [<ffffffff811770f6>] ? freed_request+0x23/0x41
[ 1834.795527]  [<ffffffff81055efe>] ? capable+0x22/0x41
[ 1834.795527]  [<ffffffff8117e1c1>] ? sg_io+0x280/0x3b5
[ 1834.795527]  [<ffffffff8104a182>] ? try_to_wake_up+0x249/0x259
[ 1834.795527]  [<ffffffff8117e7f5>] ? scsi_cmd_ioctl+0x217/0x3f2
[ 1834.795527]  [<ffffffff8103a7a5>] ? scale_rt_power+0x1f/0x64
[ 1834.795527]  [<ffffffff81188057>] ? kobject_get+0x12/0x17
[ 1834.795527]  [<ffffffff8117ce78>] ? get_disk+0x95/0xb4
[ 1834.795527]  [<ffffffffa0079a7e>] ? sd_ioctl+0x9d/0xcb [sd_mod]
[ 1834.795527]  [<ffffffff8117c1e9>] ? __blkdev_driver_ioctl+0x69/0x7e
[ 1834.795527]  [<ffffffff8117c9e4>] ? blkdev_ioctl+0x7e6/0x836
[ 1834.795527]  [<ffffffff81110e93>] ? blkdev_open+0x0/0x96
[ 1834.795527]  [<ffffffff81110efa>] ? blkdev_open+0x67/0x96
[ 1834.795527]  [<ffffffff810ebc59>] ? __dentry_open+0x1c4/0x2bf
[ 1834.795527]  [<ffffffff810f729a>] ? do_filp_open+0x4c4/0x92b
[ 1834.795527]  [<ffffffff8110fcce>] ? block_ioctl+0x38/0x3c
[ 1834.795527]  [<ffffffff810f8ede>] ? vfs_ioctl+0x21/0x6c
[ 1834.795527]  [<ffffffff810f942c>] ? do_vfs_ioctl+0x48d/0x4cb
[ 1834.795527]  [<ffffffff810e4405>] ? virt_to_head_page+0x9/0x2b
[ 1834.795527]  [<ffffffff810f94bb>] ? sys_ioctl+0x51/0x70
[ 1834.795527]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[ 1834.795527] ---[ end trace f12657df187e0997 ]---
------=_20100223111117_99713--


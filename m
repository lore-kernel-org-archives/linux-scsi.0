From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 3.0
Date: Sun, 18 Sep 2011 22:18:00 -0600
Message-ID: <201109182218.00295.thomas@fjellstrom.ca>
References: <201109162002.13801.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201109162002.13801.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On September 16, 2011, Thomas Fjellstrom wrote:
> Hi, its me again.
> 
> Just updated to 3.0 last night, after the card had locked up twice in as many
> days. However, I just heard some unsettling noises come from my raid array,
> like one of the disks was being re-initialized several times. spinning up and
> down a few times, etc.
> 
> When I got to look at the logs, I find this:
> 
> [21051.403115] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 2084:Release slot [0] tag[0], task [ffff88013ed982c0]:
> [21051.403134] sas: sas_ata_task_done: SAS error 8a
> [21051.407099] sas: Enter sas_scsi_recover_host
> [21051.407099] ata14: sas eh calling libata cmd error handler
> [21051.407099] ata9: sas eh calling libata port error handler
> [21051.407099] ata10: sas eh calling libata port error handler
> [21051.407099] ata11: sas eh calling libata port error handler
> [21051.407099] ata12: sas eh calling libata port error handler
> [21051.407099] ata13: sas eh calling libata port error handler
> [21051.407099] ata14: sas eh calling libata port error handler
> [21051.407099] sas: sas_ata_task_done: SAS error 8a
> [21051.407099] ata14: failed to read log page 10h (errno=-5)
> [21051.414118] ata14.00: exception Emask 0x1 SAct 0x1 SErr 0x0 action 0x6
> [21051.414118] ata14.00: failed command: READ FPDMA QUEUED
> [21051.417174] ata14.00: cmd 60/10:00:b0:a9:37/00:00:0e:00:00/40 tag 0 ncq 8192 in
> [21051.417180]          res 01/04:00:f8:e4:c6/00:00:47:00:00/40 Emask 0x3 (HSM violation)
> [21051.419797] ata14.00: status: { ERR }
> [21051.421106] ata14.00: error: { ABRT }
> [21051.422427] ata14: hard resetting link
> [21051.422434] sas: sas_ata_hard_reset: Found ATA device.
> [21051.422446] sas: sas_ata_task_done: SAS error 8a
> [21051.422476] sas: sas_ata_task_done: SAS error 8a
> [21051.422484] ata14.00: both IDENTIFYs aborted, assuming NODEV
> [21051.422491] ata14.00: revalidation failed (errno=-2)
> [21053.443487] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21055.460022] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21055.631886] sas: sas_form_port: phy6 belongs to port5 already(1)!
> [21056.420060] ata14: hard resetting link
> [21056.420070] sas: sas_ata_hard_reset: Found ATA device.
> [21056.486683] ata14.00: configured for UDMA/133
> [21056.486708] ata14: EH complete
> [21056.486718] ata15: sas eh calling libata port error handler
> [21056.486735] sas: --- Exit sas_scsi_recover_host
> [21056.665913] sas: sas_ata_task_done: SAS error 8a
> [21056.665947] sas: Enter sas_scsi_recover_host
> [21056.665958] ata14: sas eh calling libata cmd error handler
> [21056.665973] ata9: sas eh calling libata port error handler
> [21056.665996] ata10: sas eh calling libata port error handler
> [21056.666011] ata11: sas eh calling libata port error handler
> [21056.666024] ata12: sas eh calling libata port error handler
> [21056.666035] ata13: sas eh calling libata port error handler
> [21056.666047] ata14: sas eh calling libata port error handler
> [21056.666066] sas: sas_ata_task_done: SAS error 8a
> [21056.666079] ata14: failed to read log page 10h (errno=-5)
> [21056.667428] ata14.00: exception Emask 0x1 SAct 0x1 SErr 0x0 action 0x6
> [21056.668777] ata14.00: failed command: READ FPDMA QUEUED
> [21056.670091] ata14.00: cmd 60/08:00:a8:ed:2e/00:00:10:00:00/40 tag 0 ncq 4096 in
> [21056.670095]          res 01/04:00:20:59:6d/00:00:02:00:00/40 Emask 0x3 (HSM violation)
> [21056.672687] ata14.00: status: { ERR }
> [21056.674070] ata14.00: error: { ABRT }
> [21056.675399] ata14: hard resetting link
> [21056.675405] sas: sas_ata_hard_reset: Found ATA device.
> [21056.675418] sas: sas_ata_task_done: SAS error 8a
> [21056.675480] sas: sas_ata_task_done: SAS error 8a
> [21056.675489] ata14.00: both IDENTIFYs aborted, assuming NODEV
> [21056.675496] ata14.00: revalidation failed (errno=-2)
> [21057.512008] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21058.624012] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21059.564016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21060.676016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21061.616006] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21061.672045] ata14: hard resetting link
> [21061.672055] sas: sas_ata_hard_reset: Found ATA device.
> [21061.672116] sas: sas_ata_task_done: SAS error 2
> [21061.672193] sas: sas_ata_task_done: SAS error 2
> [21061.672208] ata14.00: both IDENTIFYs aborted, assuming NODEV
> [21061.672216] ata14.00: revalidation failed (errno=-2)
> [21062.728006] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21064.324014] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21064.780018] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21066.376015] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21066.672061] ata14: hard resetting link
> [21066.672070] sas: sas_ata_hard_reset: Found ATA device.
> [21066.672124] sas: sas_ata_task_done: SAS error 2
> [21066.672168] sas: sas_ata_task_done: SAS error 2
> [21066.672183] ata14.00: both IDENTIFYs aborted, assuming NODEV
> [21066.672190] ata14.00: revalidation failed (errno=-2)
> [21066.673517] ata14.00: disabled
> [21066.673542] ata14: EH complete
> [21066.673550] ata15: sas eh calling libata port error handler
> [21066.673570] sas: --- Exit sas_scsi_recover_host
> [21066.673690] sd 8:0:5:0: [sdi] Unhandled error code
> [21066.673697] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [21066.673707] sd 8:0:5:0: [sdi] CDB: Read(10): 28 00 10 2e ed a8 00 00 08 00
> [21066.673738] end_request: I/O error, dev sdi, sector 271510952
> [21066.679965] sd 8:0:5:0: [sdi] Unhandled error code
> [21066.679971] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [21066.679979] sd 8:0:5:0: [sdi] CDB: Write(10): 2a 00 00 00 00 02 00 00 05 00
> [21066.679997] end_request: I/O error, dev sdi, sector 2
> [21066.686083] end_request: I/O error, dev sdi, sector 2
> [21066.690044] md: super_written gets error=-5, uptodate=0
> [21066.690044] md/raid:md1: Disk failure on sdi, disabling device.
> [21066.690044] md/raid:md1: Operation continuing on 6 devices.
> [21066.742358] RAID conf printout:
> [21066.742361]  --- level:5 rd:7 wd:6
> [21066.742363]  disk 0, o:1, dev:sdf
> [21066.742364]  disk 1, o:1, dev:sdg
> [21066.742366]  disk 2, o:1, dev:sdd
> [21066.742367]  disk 3, o:1, dev:sde
> [21066.742369]  disk 4, o:1, dev:sdj
> [21066.742370]  disk 5, o:0, dev:sdi
> [21066.742371]  disk 6, o:1, dev:sdh
> [21066.745218] RAID conf printout:
> [21066.745227]  --- level:5 rd:7 wd:6
> [21066.745234]  disk 0, o:1, dev:sdf
> [21066.745240]  disk 1, o:1, dev:sdg
> [21066.745245]  disk 2, o:1, dev:sdd
> [21066.745249]  disk 3, o:1, dev:sde
> [21066.745264]  disk 4, o:1, dev:sdj
> [21066.745269]  disk 6, o:1, dev:sdh
> [21066.832016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21068.428013] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21068.895664] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21070.480008] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21070.936016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21072.532018] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21072.988016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21074.584017] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21075.040016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21076.636009] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21077.092020] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21077.886806] sas: sas_form_port: phy6 belongs to port5 already(1)!
> [21098.260007] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21100.312016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21100.512833] sas: sas_form_port: phy6 belongs to port5 already(1)!
> [21119.388007] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21121.472339] sd 8:0:5:0: [sdi] Synchronizing SCSI cache
> [21121.472460] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [21121.472474] sd 8:0:5:0: [sdi] Stopping disk
> [21121.472512] sd 8:0:5:0: [sdi] START_STOP FAILED
> [21121.472521] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [21124.632016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21133.336022] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21135.424511] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21137.440016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [21138.137603] sas: phy-8:6 added to port-8:5, phy_mask:0x40 ( 600000000000000)
> [21138.137636] sas: DOING DISCOVERY on port 5, pid:235
> [21138.140579] sas: Enter sas_scsi_recover_host
> [21138.140584] ata9: sas eh calling libata port error handler
> [21138.140595] ata10: sas eh calling libata port error handler
> [21138.140600] ata11: sas eh calling libata port error handler
> [21138.140605] ata12: sas eh calling libata port error handler
> [21138.140609] ata13: sas eh calling libata port error handler
> [21138.140614] ata15: sas eh calling libata port error handler
> [21138.140619] ata16: sas eh calling libata port error handler
> [21138.140627] sas: sas_ata_hard_reset: Found ATA device.
> [21138.167643] ata16.00: ATA-8: ST31000528AS, CC34, max UDMA/133
> [21138.167649] ata16.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [21138.207197] ata16.00: configured for UDMA/133
> [21138.207217] sas: --- Exit sas_scsi_recover_host
> [21138.207436] scsi 8:0:7:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
> [21138.207899] sd 8:0:7:0: Attached scsi generic sg8 type 0
> [21138.208030] sd 8:0:7:0: [sdk] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [21138.208220] sd 8:0:7:0: [sdk] Write Protect is off
> [21138.208229] sd 8:0:7:0: [sdk] Mode Sense: 00 3a 00 00
> [21138.208281] sd 8:0:7:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [21138.208380] sas: DONE DISCOVERY on port 5, pid:235, result:0
> [21138.225975]  sdk: unknown partition table
> [21138.226482] sd 8:0:7:0: [sdk] Attached SCSI disk
> [72609.206763] sd 8:0:7:0: [sdk] Synchronizing SCSI cache
> [72609.206890] sd 8:0:7:0: [sdk]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [72609.206904] sd 8:0:7:0: [sdk] Stopping disk
> [72609.206935] sd 8:0:7:0: [sdk] START_STOP FAILED
> [72609.206941] sd 8:0:7:0: [sdk]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [72612.720016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [72614.772017] mvsas 0000:04:00.0: Phy6 : No sig fis
> [72616.824016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [72618.876020] mvsas 0000:04:00.0: Phy6 : No sig fis
> [72620.064059] sas: phy-8:6 added to port-8:5, phy_mask:0x40 ( 600000000000000)
> [72620.064569] sas: DOING DISCOVERY on port 5, pid:227
> [72620.067073] sas: Enter sas_scsi_recover_host
> [72620.067083] ata9: sas eh calling libata port error handler
> [72620.067105] ata10: sas eh calling libata port error handler
> [72620.067120] ata11: sas eh calling libata port error handler
> [72620.067133] ata12: sas eh calling libata port error handler
> [72620.067144] ata13: sas eh calling libata port error handler
> [72620.067157] ata15: sas eh calling libata port error handler
> [72620.067168] ata17: sas eh calling libata port error handler
> [72620.067180] sas: sas_ata_hard_reset: Found ATA device.
> [72620.094238] ata17.00: ATA-8: ST31000528AS, CC34, max UDMA/133
> [72620.094249] ata17.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [72620.133748] ata17.00: configured for UDMA/133
> [72620.133770] sas: --- Exit sas_scsi_recover_host
> [72620.133922] scsi 8:0:8:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
> [72620.134411] sd 8:0:8:0: [sdk] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [72620.134423] sd 8:0:8:0: Attached scsi generic sg8 type 0
> [72620.134596] sas: DONE DISCOVERY on port 5, pid:227, result:0
> [72620.134655] sd 8:0:8:0: [sdk] Write Protect is off
> [72620.134664] sd 8:0:8:0: [sdk] Mode Sense: 00 3a 00 00
> [72620.134754] sd 8:0:8:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [72620.152891]  sdk: unknown partition table
> [72620.153465] sd 8:0:8:0: [sdk] Attached SCSI disk
> [76711.440019] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76713.492006] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76715.544016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76717.599362] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76719.648015] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76721.700012] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76722.598654] sas: sas_form_port: phy6 belongs to port5 already(1)!
> [76725.900016] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76727.952017] mvsas 0000:04:00.0: Phy6 : No sig fis
> [76728.103256] sas: sas_form_port: phy6 belongs to port5 already(1)!
> 
> So, it seems to have at least recovered this time, rather than locking up,
> unfortunately now my raid5 array is rebuilding. Thankfully it seems to have
> been able to use the mdraid bitmap feature, as it only took 20 minutes.
> 

So now 20+ hours after that, I get another error, and the card has locked up,
but this time without trying to reinitialize anything.

[257834.976018] sas: command 0xffff880223a45480, task 0xffff880104a07940, timed out: BLK_EH_NOT_HANDLED
[258000.920151] INFO: task nfsd:12690 blocked for more than 120 seconds.
[258000.921453] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.922715] nfsd            D ffff880223cb5120     0 12690      2 0x00000000
[258000.922727]  ffff880223cb5120 0000000000000046 0000000000000282 0000000000000900
[258000.922740]  ffff880224ee1650 0000000000012800 ffff88010bccbfd8 ffff88010bccbfd8
[258000.922750]  0000000000012800 ffff880223cb5120 0000000000012800 0000000000012800
[258000.922760] Call Trace:
[258000.922777]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.922789]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258000.922801]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.922811]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.922821]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.922831]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.922841]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.922850]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.922861]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.922872]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.922900]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258000.922910]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.922922]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.922931]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.922940]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.922949]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.923005]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.923016]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.923036]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.923056]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.923076]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.923101]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.923120]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.923146]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.923165]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.923181]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.923189]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.923199]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.923209]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.923217]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.923224] INFO: task nfsd:12691 blocked for more than 120 seconds.
[258000.924573] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.925920] nfsd            D ffff880185575610     0 12691      2 0x00000000
[258000.925931]  ffff880185575610 0000000000000046 0000000000000246 0000000000000001
[258000.925942]  ffff880185574f20 0000000000012800 ffff880185e83fd8 ffff880185e83fd8
[258000.925952]  0000000000012800 ffff880185575610 0000000000012800 0000000000012800
[258000.925961] Call Trace:
[258000.925972]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.925981]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.925990]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.925999]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.926008]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.926017]  [<ffffffff810b5137>] ? page_waitqueue+0x3/0x6d
[258000.926026]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.926035]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.926044]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.926065]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258000.926074]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.926085]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.926094]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.926102]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.926111]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.926158]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.926168]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.926187]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.926205]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.926225]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.926249]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.926267]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.926290]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.926309]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.926325]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.926332]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.926341]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.926350]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.926358]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.926364] INFO: task nfsd:12692 blocked for more than 120 seconds.
[258000.927690] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.929054] nfsd            D ffff880185574f20     0 12692      2 0x00000000
[258000.929064]  ffff880185574f20 0000000000000046 ffff88010291b140 ffffffff812b9ec3
[258000.929075]  ffff880226db8f60 0000000000012800 ffff8801f930ffd8 ffff8801f930ffd8
[258000.929085]  0000000000012800 ffff880185574f20 0000000000012800 0000000000012800
[258000.929095] Call Trace:
[258000.929104]  [<ffffffff812b9ec3>] ? tcp_established_options+0x2d/0xa4
[258000.929114]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.929122]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258000.929132]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.929141]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.929150]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.929159]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.929169]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.929178]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.929187]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.929197]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.929217]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258000.929228]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.929240]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.929249]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.929257]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.929266]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.929313]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.929323]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.929342]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.929361]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.929380]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.929404]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.929423]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.929446]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.929464]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.929482]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.929490]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.929498]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.929508]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.929516]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.929522] INFO: task nfsd:12693 blocked for more than 120 seconds.
[258000.930827] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.932153] nfsd            D ffff880185574830     0 12693      2 0x00000000
[258000.932163]  ffff880185574830 0000000000000046 ffffffff81008032 ffffffff81008626
[258000.932173]  ffff880226db8f60 0000000000012800 ffff88010c937fd8 ffff88010c937fd8
[258000.932183]  0000000000012800 ffff880185574830 0000000000012800 0000000000012800
[258000.932192] Call Trace:
[258000.932200]  [<ffffffff81008032>] ? load_TLS+0x7/0xa
[258000.932208]  [<ffffffff81008626>] ? __switch_to+0xc9/0x1fb
[258000.932218]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.932226]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258000.932235]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.932244]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.932253]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.932262]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.932272]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.932280]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.932289]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.932299]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.932319]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258000.932328]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.932340]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.932349]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.932357]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.932366]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.932412]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.932423]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.932441]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.932460]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.932479]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.932487]  [<ffffffff8133cbae>] ? reschedule_interrupt+0xe/0x20
[258000.932511]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.932530]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.932553]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.932571]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.932589]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.932596]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.932605]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.932614]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.932621]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.932628] INFO: task nfsd:12694 blocked for more than 120 seconds.
[258000.933933] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.935218] nfsd            D ffff880185574140     0 12694      2 0x00000000
[258000.935227]  ffff880185574140 0000000000000046 0000000000000000 ffff880223ecc000
[258000.935237]  ffff880226db8f60 0000000000012800 ffff8801965ddfd8 ffff8801965ddfd8
[258000.935247]  0000000000012800 ffff880185574140 0000000000012800 0000000000012800
[258000.935256] Call Trace:
[258000.935266]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.935274]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258000.935283]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.935292]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.935301]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.935310]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.935320]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.935328]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.935338]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.935348]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.935367]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258000.935377]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.935389]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.935398]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.935406]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.935415]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.935461]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.935471]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.935490]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.935508]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.935527]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.935551]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.935570]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.935592]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.935611]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.935628]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.935636]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.935645]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.935654]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.935661]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.935668] INFO: task nfsd:12695 blocked for more than 120 seconds.
[258000.936997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.938388] nfsd            D ffff880224ee1650     0 12695      2 0x00000000
[258000.938397]  ffff880224ee1650 0000000000000046 ffff880159118540 ffffffffa04b680b
[258000.938408]  ffff880185574830 0000000000012800 ffff880215ff1fd8 ffff880215ff1fd8
[258000.938418]  0000000000012800 ffff880224ee1650 0000000000012800 0000000000012800
[258000.938427] Call Trace:
[258000.938443]  [<ffffffffa04b680b>] ? br_dev_queue_push_xmit+0x72/0x76 [bridge]
[258000.938454]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.938462]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258000.938472]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.938480]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.938489]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.938498]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.938508]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.938516]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.938526]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.938535]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.938546]  [<ffffffff810bb63c>] ? __free_one_page+0x214/0x295
[258000.938555]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.938566]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.938575]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.938583]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.938592]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.938638]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.938648]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.938667]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.938686]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.938705]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.938729]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.938747]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.938770]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.938788]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.938806]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.938813]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.938822]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.938831]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.938838]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.938845] INFO: task nfsd:12697 blocked for more than 120 seconds.
[258000.940156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.941464] nfsd            D ffff880224ee0870     0 12697      2 0x00000000
[258000.941473]  ffff880224ee0870 0000000000000046 0000000000000282 0000000000000600
[258000.941483]  ffff880226d460c0 0000000000012800 ffff88014107ffd8 ffff88014107ffd8
[258000.941493]  0000000000012800 ffff880224ee0870 0000000000012800 0000000000012800
[258000.941503] Call Trace:
[258000.941512]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258000.941521]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258000.941530]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258000.941539]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258000.941548]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258000.941557]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258000.941566]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258000.941575]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258000.941584]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258000.941594]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.941613]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258000.941623]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258000.941635]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258000.941644]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258000.941652]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258000.941661]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258000.941707]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258000.941717]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258000.941736]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258000.941754]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258000.941773]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258000.941797]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258000.941816]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258000.941838]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258000.941857]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258000.941874]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258000.941882]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.941890]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.941899]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.941907]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258000.941920] INFO: task kworker/2:3:19027 blocked for more than 120 seconds.
[258000.943279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258000.944625] kworker/2:3     D ffff8801ad9f4100     0 19027      2 0x00000000
[258000.944636]  ffff8801ad9f4100 0000000000000046 ffff88017ac3e580 00000000d7744850
[258000.944646]  ffff8801a608cf20 0000000000012800 ffff88009cbe7fd8 ffff88009cbe7fd8
[258000.944656]  0000000000012800 ffff8801ad9f4100 0000000000012800 0000000000012800
[258000.944666] Call Trace:
[258000.944677]  [<ffffffff81071f28>] ? arch_local_irq_save+0x14/0x1d
[258000.944724]  [<ffffffffa050f1c1>] ? xlog_wait+0x4f/0x65 [xfs]
[258000.944733]  [<ffffffff8103f0a4>] ? try_to_wake_up+0x199/0x199
[258000.944781]  [<ffffffffa0511b47>] ? _xfs_log_force_lsn+0x1cf/0x205 [xfs]
[258000.944830]  [<ffffffffa051bde9>] ? _xfs_trans_commit+0x110/0x20d [xfs]
[258000.944878]  [<ffffffffa052c530>] ? trace_xfs_irele+0x3b/0x3b [xfs]
[258000.944925]  [<ffffffffa052c530>] ? trace_xfs_irele+0x3b/0x3b [xfs]
[258000.944972]  [<ffffffffa052c56d>] ? xfs_sync_worker+0x3d/0x70 [xfs]
[258000.944982]  [<ffffffff8105b943>] ? process_one_work+0x193/0x28f
[258000.944992]  [<ffffffff8105cacf>] ? worker_thread+0xef/0x172
[258000.945001]  [<ffffffff8105c9e0>] ? manage_workers.clone.17+0x15b/0x15b
[258000.945010]  [<ffffffff8105c9e0>] ? manage_workers.clone.17+0x15b/0x15b
[258000.945019]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258000.945027]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258000.945036]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258000.945044]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258120.944114] INFO: task nfsd:12690 blocked for more than 120 seconds.
[258120.945449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258120.946730] nfsd            D ffff880223cb5120     0 12690      2 0x00000000
[258120.946742]  ffff880223cb5120 0000000000000046 0000000000000282 0000000000000900
[258120.946755]  ffff880224ee1650 0000000000012800 ffff88010bccbfd8 ffff88010bccbfd8
[258120.946766]  0000000000012800 ffff880223cb5120 0000000000012800 0000000000012800
[258120.946776] Call Trace:
[258120.946793]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258120.946805]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[258120.946817]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258120.946828]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258120.946838]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258120.946847]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258120.946858]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258120.946867]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258120.946879]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258120.946890]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258120.946917]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258120.946929]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258120.946941]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258120.946950]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258120.946959]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258120.946969]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258120.947027]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258120.947039]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258120.947061]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258120.947082]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258120.947104]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258120.947130]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258120.947150]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258120.947178]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258120.947198]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258120.947218]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258120.947227]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258120.947238]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258120.947249]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258120.947259]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13
[258120.947268] INFO: task nfsd:12691 blocked for more than 120 seconds.
[258120.948607] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[258120.949975] nfsd            D ffff880185575610     0 12691      2 0x00000000
[258120.949988]  ffff880185575610 0000000000000046 0000000000000246 0000000000000001
[258120.950001]  ffff880185574f20 0000000000012800 ffff880185e83fd8 ffff880185e83fd8
[258120.950012]  0000000000012800 ffff880185575610 0000000000012800 0000000000012800
[258120.950024] Call Trace:
[258120.950035]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[258120.950046]  [<ffffffff810b5eac>] ? lock_page+0x20/0x20
[258120.950056]  [<ffffffff8133576b>] ? io_schedule+0x5b/0x75
[258120.950066]  [<ffffffff810b5eb5>] ? sleep_on_page+0x9/0x10
[258120.950076]  [<ffffffff81335cee>] ? __wait_on_bit_lock+0x3c/0x85
[258120.950087]  [<ffffffff810b5137>] ? page_waitqueue+0x3/0x6d
[258120.950097]  [<ffffffff810b5e86>] ? __lock_page+0x5d/0x63
[258120.950107]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[258120.950118]  [<ffffffff8111b14f>] ? __generic_file_splice_read+0x245/0x409
[258120.950141]  [<ffffffffa0624aaa>] ? put_cred+0x1c/0x1c [nfsd]
[258120.950151]  [<ffffffff81154d1d>] ? find_acceptable_alias+0x1f/0xe4
[258120.950163]  [<ffffffff8111a071>] ? page_cache_pipe_buf_release+0x12/0x12
[258120.950174]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[258120.950183]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[258120.950193]  [<ffffffff8111b350>] ? generic_file_splice_read+0x3d/0x65
[258120.950242]  [<ffffffffa0526366>] ? xfs_file_splice_read+0xe5/0x12f [xfs]
[258120.950253]  [<ffffffff8111a1c7>] ? splice_direct_to_actor+0xb6/0x178
[258120.950274]  [<ffffffffa062591b>] ? dget+0x1e/0x1e [nfsd]
[258120.950293]  [<ffffffffa0625d79>] ? nfsd_vfs_read.clone.5+0x75/0x129 [nfsd]
[258120.950315]  [<ffffffffa0626703>] ? nfsd_read+0x1ca/0x231 [nfsd]
[258120.950340]  [<ffffffffa062d2ab>] ? nfsd3_proc_read+0xd0/0x111 [nfsd]
[258120.950360]  [<ffffffffa06227c6>] ? nfsd_dispatch+0xdf/0x1bd [nfsd]
[258120.950384]  [<ffffffffa056bcee>] ? svc_process+0x3d5/0x5e9 [sunrpc]
[258120.950404]  [<ffffffffa0622028>] ? nfsd_shutdown+0x28/0x28 [nfsd]
[258120.950423]  [<ffffffffa0622110>] ? nfsd+0xe8/0x131 [nfsd]
[258120.950432]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[258120.950442]  [<ffffffff8133ce24>] ? kernel_thread_helper+0x4/0x10
[258120.950452]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[258120.950461]  [<ffffffff8133ce20>] ? gs_change+0x13/0x13

The only questionable message before that is from kvm:

[180085.863989] kvm: page allocation failure: order:1, mode:0x20

Which is about 21 hours before the sas error. So it is (probably?) not related.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

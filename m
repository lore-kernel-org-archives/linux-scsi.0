From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Wed, 9 Sep 2009 14:07:10 -0600
Message-ID: <200909091407.10111.tfjellstrom@shaw.ca>
References: <200909090414.41274.tfjellstrom@shaw.ca> <4AA7F965.6020408@garzik.org> <200909091310.26058.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753723AbZIIUHM@vger.kernel.org>
In-Reply-To: <200909091310.26058.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed September 9 2009, Thomas Fjellstrom wrote:
> On Wed September 9 2009, Jeff Garzik wrote:
> > On 09/09/2009 12:30 PM, Thomas Fjellstrom wrote:
> > > No errors on that disk. Other than the one above, and its more of a
> > > warning. However, I just rebooted to add some extra drives, thinking
> > > everything was working a little better now that I've updated to
> > > 2.6.31-rc9, I'm treated to the following two messages right after boot
> > > (and a system lockup to boot):
> > >
> > > kernel: [  971.033138] ------------[ cut here ]------------
> > > kernel: [  971.033211] WARNING: at drivers/ata/libata-core.c:4913
> > > __ata_qc_complete+0x5a/0xe1 [libata]()
> > > kernel: [  971.033217] Hardware name: GA-MA790FXT-UD5P
> > > kernel: [  971.033221] Modules linked in: powernow_k8
> > > cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave
> > > kvm_amd kvm nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
> > > bridge stp it87 hwmon_vid adt7473 firewire_sbp2 loop md_mod
> > > snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
> > > snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event
> > > snd_seq snd_timer snd_seq_device snd amd64_edac_mod edac_core i2c_piix4
> > > soundcore snd_page_alloc i2c_core evdev wmi parport_pc button parport
> > > processor ext3 jbd mbcache dm_mod sg sr_mod cdrom sd_mod crc_t10dif
> > > usbhid ata_generic ide_pci_generic hid mvsas firewire_ohci libsas
> > > firewire_core crc_itu_t scsi_transport_sas r8169 atiixp ide_core floppy
> > > ahci mii ohci_hcd libata ehci_hcd scsi_mod thermal fan thermal_sys
> > > [last unloaded: scsi_wait_scan]
> > > kernel: [  971.033337] Pid: 0, comm: swapper Not tainted 2.6.31-rc9 #2
> > > kernel: [  971.033342] Call Trace:
> > > kernel: [  971.033346]<IRQ>   [<ffffffffa00562ca>] ?
> > > __ata_qc_complete+0x5a/0xe1 [libata]
> > > kernel: [  971.033434]  [<ffffffffa00562ca>] ?
> > > __ata_qc_complete+0x5a/0xe1 [libata]
> > > kernel: [  971.033446]  [<ffffffff8104aca0>] ?
> > > warn_slowpath_common+0x77/0xa3 kernel: [  971.033455]
> > > [<ffffffff81038d06>] ? enqueue_task+0x5c/0x65 kernel: [  971.033496]
> > > [<ffffffffa00562ca>] ? __ata_qc_complete+0x5a/0xe1 [libata]
> > > kernel: [  971.033519]  [<ffffffffa00f7b59>] ?
> > > sas_ata_task_done+0x178/0x210 [libsas]
> > > kernel: [  971.033528]  [<ffffffff8115ead1>] ? blk_run_queue+0x21/0x35
> > > kernel: [  971.033548]  [<ffffffffa010e2ce>] ?
> > > mvs_slot_complete+0x3df/0x41b [mvsas]
> > > kernel: [  971.033565]  [<ffffffffa010e39c>] ? mvs_int_rx+0x92/0x101
> > > [mvsas] kernel: [  971.033583]  [<ffffffffa01112ba>] ?
> > > mvs_int_full+0x25/0x88 [mvsas] kernel: [  971.033600]
> > > [<ffffffffa011134e>] ? mvs_64xx_isr+0x31/0x40 [mvsas] kernel: [
> > > 971.033617]  [<ffffffffa010d0e5>] ? mvs_interrupt+0x61/0x78 [mvsas]
> > > kernel: [  971.033625]  [<ffffffff8108aaac>] ?
> > > handle_IRQ_event+0x58/0x135 kernel: [  971.033633] 
> > > [<ffffffff8108c1a1>] ? handle_fasteoi_irq+0x7d/0xb5 kernel: [ 
> > > 971.033642]
> > > [<ffffffff8101388d>] ? handle_irq+0x17/0x1d
> >
> > That warning is triggered when an ata_queued_cmd is passed to completion
> > without the ATA_QCFLAG_ACTIVE flag being set (which indicates the qc was
> > started with some activity).
> >
> > That possibly indicates the low-level driver (or libsas) was passing an
> > already-completed cmd to libata.
> >
> > > The added hard drives are connected to a Supermicro AOC-SASLP-MV8,
> > > which is based on a marvel MV64460/64461/64462 chipset, which uses the
> > > sata_mv driver.
> >
> > Surely you mean 'mvsas' driver?
> 
> Yes, sorry I did mean mvsas.
> 
> I am more concerned about the actual oops/BUG rather than the warning
>  though. Unless the problem causing the warning is also causing the oops.
> 
> > 	Jeff
> 

Thanks for taking a look so far. But I'm having more and more trouble with 
this card as the days go by:

[  464.792214] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  464.792222] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  494.816170] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  494.816179] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  494.816192] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  494.816197] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  525.817335] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  525.817343] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  525.817358] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  525.817363] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  556.816148] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  556.816157] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  556.816170] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  556.816175] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  587.816171] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  587.816179] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  587.816193] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  587.816199] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  600.616255] INFO: task mount:4395 blocked for more than 120 seconds.
[  600.616263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[  600.616270] mount         D 0000000000000000     0  4395   4229 0x00000000
[  600.616281]  ffff88012fb6f780 0000000000000082 ffff8800b808ddc8 
ffff8800b80f3d60
[  600.616290]  ffff880128923c90 0000000000014800 000000000000f800 
ffff88012dd91840
[  600.616299]  ffff88012dd91b38 0000000300000008 0000000000000000 
ffff88010c5bfa88
[  600.616308] Call Trace:
[  600.616324]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[  600.616335]  [<ffffffff810adc63>] ? __pagevec_free+0x29/0x3b
[  600.616343]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[  600.616351]  [<ffffffff810a8e69>] ? sync_page+0x0/0x46
[  600.616361]  [<ffffffff812dc8cb>] ? io_schedule+0x63/0xa5
[  600.616368]  [<ffffffff810a8eaa>] ? sync_page+0x41/0x46
[  600.616376]  [<ffffffff812dcade>] ? __wait_on_bit_lock+0x3f/0x84
[  600.616383]  [<ffffffff810a8e55>] ? __lock_page+0x5d/0x63
[  600.616391]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[  600.616401]  [<ffffffff810b0ad4>] ? pagevec_lookup+0x17/0x1e
[  600.616408]  [<ffffffff810b1bbd>] ? truncate_inode_pages_range+0x288/0x318
[  600.616418]  [<ffffffff810fc8cb>] ? set_blocksize+0xc2/0xd2
[  600.616426]  [<ffffffff810fc8f2>] ? sb_set_blocksize+0x17/0x43
[  600.616477]  [<ffffffffa04aa8e0>] ? ext4_fill_super+0x1cc/0x2060 [ext4]
[  600.616486]  [<ffffffff8117593b>] ? snprintf+0x44/0x4c
[  600.616493]  [<ffffffff810fb5b7>] ? check_disk_change+0x22/0x52
[  600.616501]  [<ffffffff812dd680>] ? __down_write_nested+0x15/0xab
[  600.616524]  [<ffffffff810dbfe6>] ? get_sb_bdev+0x111/0x159
[  600.616571]  [<ffffffffa04aa714>] ? ext4_fill_super+0x0/0x2060 [ext4]
[  600.616582]  [<ffffffff810dbc44>] ? vfs_kern_mount+0x95/0x111
[  600.616593]  [<ffffffff810dbd13>] ? do_kern_mount+0x43/0xe2
[  600.616607]  [<ffffffff810ef49d>] ? do_mount+0x767/0x7d6
[  600.616620]  [<ffffffff810ef591>] ? sys_mount+0x85/0xc8
[  600.616633]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[  618.816175] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                                                                                                                        
[  618.816184] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5                                                                                                                                                                        
[  618.816196] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                                                                                                                        
[  618.816201] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5                                                                                                                                                                        
[  618.816241] sd 1:0:3:0: [sdf] Unhandled error code                                                                                                                                                                                       
[  618.816247] sd 1:0:3:0: [sdf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[  618.816255] end_request: I/O error, dev sdf, sector 160                                                                                                                                                                                  
[  618.816263] Buffer I/O error on device md2, logical block 20                                                                                                                                                                             
[  618.816274] Buffer I/O error on device md2, logical block 21                                                                                                                                                                             
[  618.816280] Buffer I/O error on device md2, logical block 22                                                                                                                                                                             
[  618.816285] Buffer I/O error on device md2, logical block 23                                                                                                                                                                             
[  618.816291] Buffer I/O error on device md2, logical block 24                                                                                                                                                                             
[  618.816298] Buffer I/O error on device md2, logical block 25                                                                                                                                                                             
[  618.816307] Buffer I/O error on device md2, logical block 26                                                                                                                                                                             
[  618.816316] Buffer I/O error on device md2, logical block 27                                                                                                                                                                             
[  618.816324] Buffer I/O error on device md2, logical block 28                                                                                                                                                                             
[  618.816331] Buffer I/O error on device md2, logical block 29                                                                                                                                                                             
[  649.780185] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                                                                                                                        
[  649.780194] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5                                                                                                                                                                        
[  649.780208] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                                                                                                                        
[  649.780214] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5                                                                                                                                                                        
[  649.780293] ------------[ cut here ]------------                                                                                                                                                                                         
[  649.780366] WARNING: at drivers/ata/libata-core.c:5129 
ata_qc_issue+0x10a/0x347 [libata]()                                                                                                                                               
[  649.780373] Hardware name: GA-MA790FXT-UD5P                                                                                                                                                                                              
[  649.780377] Modules linked in: ext4 jbd2 crc16 raid0 powernow_k8 
cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave kvm_amd 
kvm nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp it87 
hwmon_vid adt7473 firewire_sbp2 loop md_mod snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_midi snd_rawmidi snd_seq_midi_event amd64_edac_mod snd_seq edac_core 
snd_timer snd_seq_device snd soundcore i2c_piix4 snd_page_alloc i2c_core evdev 
parport_pc wmi parport button processor ext3 jbd mbcache dm_mod usbhid hid sg 
sr_mod cdrom sd_mod crc_t10dif ata_generic ide_pci_generic firewire_ohci 
firewire_core ohci_hcd crc_itu_t atiixp ide_core mvsas ehci_hcd ahci libsas 
libata scsi_transport_sas scsi_mod r8169 mii floppy thermal fan thermal_sys 
[last unloaded: scsi_wait_scan]
[  649.780499] Pid: 3185, comm: hddtemp Not tainted 2.6.31-rc9 #2
[  649.780504] Call Trace:
[  649.780551]  [<ffffffffa0074f90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  649.780593]  [<ffffffffa0074f90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  649.780607]  [<ffffffff8104aca0>] ? warn_slowpath_common+0x77/0xa3
[  649.780649]  [<ffffffffa00790ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata]
[  649.780690]  [<ffffffffa0074f90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  649.780733]  [<ffffffffa00401d6>] ? scsi_get_command+0x75/0x97 [scsi_mod]
[  649.780776]  [<ffffffffa00790ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata]
[  649.780815]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
[  649.780858]  [<ffffffffa007a4d5>] ? __ata_scsi_queuecmd+0x185/0x1dc 
[libata]
[  649.780896]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
[  649.780918]  [<ffffffffa00a3c8e>] ? sas_queuecommand+0x83/0x25d [libsas]
[  649.780956]  [<ffffffffa003fa7c>] ? scsi_dispatch_cmd+0x1c0/0x23c 
[scsi_mod]
[  649.780996]  [<ffffffffa0044ff0>] ? scsi_request_fn+0x3a5/0x506 [scsi_mod]
[  649.781006]  [<ffffffff810546e0>] ? del_timer+0x59/0x62
[  649.781016]  [<ffffffff81163b70>] ? blk_execute_rq_nowait+0x65/0x89
[  649.781032]  [<ffffffffa014164f>] ? sg_common_write+0x489/0x4ab [sg]
[  649.781042]  [<ffffffff8115df56>] ? __freed_request+0x26/0x83
[  649.781056]  [<ffffffffa01421da>] ? sg_new_write+0x23e/0x269 [sg]
[  649.781070]  [<ffffffffa0142473>] ? sg_ioctl+0x26e/0xb63 [sg]
[  649.781080]  [<ffffffff81100f38>] ? inotify_d_instantiate+0x12/0x39
[  649.781088]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
[  649.781098]  [<ffffffff810d80bf>] ? fd_install+0x2e/0x5a
[  649.781105]  [<ffffffff810e5247>] ? vfs_ioctl+0x56/0x6c
[  649.781111]  [<ffffffff810e570a>] ? do_vfs_ioctl+0x437/0x475
[  649.781118]  [<ffffffff810e5799>] ? sys_ioctl+0x51/0x70
[  649.781128]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[  649.781134] ---[ end trace 9005373b1b9c6eb7 ]---
[  680.781672] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  680.781681] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  711.781672] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  711.781681] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  741.816069] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  741.816078] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  741.816090] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  741.816096] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  772.820160] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  772.820168] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  772.820181] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  772.820186] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  803.816212] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  803.816220] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  803.816233] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  803.816239] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  803.816264] sd 1:0:3:0: [sdf] Unhandled error code
[  803.816270] sd 1:0:3:0: [sdf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[  803.816278] end_request: I/O error, dev sdf, sector 512
[  803.816284] __ratelimit: 70 callbacks suppressed
[  803.816290] Buffer I/O error on device md2, logical block 64

That's after bringing up a raid0 array I build a few days ago on 4 perfectly 
good (Seagate Baracuda 1TB 7200.12) disks, without the bad disk plugged in. I 
try to mount it, and the driver hangs. Anything trying to access any of the 4 
disks hangs as well.

I know this array worked a few days ago. The most major change I've made was 
upgrade from -rc8 (or -rc5, not sure if I mounted the array under -rc8) to
-rc9.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

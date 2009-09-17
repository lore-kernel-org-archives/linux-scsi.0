From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: 2.6.31-git4 mvsas DRIVER_TIMEOUT
Date: Thu, 17 Sep 2009 09:39:52 -0600
Message-ID: <200909170939.52637.tfjellstrom@shaw.ca>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909122256.50474.tfjellstrom@shaw.ca> <200909151020.40205.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IhlsKESfl/croZf"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200909151020.40205.tfjellstrom@shaw.ca>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_IhlsKESfl/croZf
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

On Tue September 15 2009, Thomas Fjellstrom wrote:
> On Sat September 12 2009, Thomas Fjellstrom wrote:
> > On Sat September 12 2009, Jeff Garzik wrote:
> > > On 09/10/2009 07:55 PM, Thomas Fjellstrom wrote:
> > > > On Wed September 9 2009, Thomas Fjellstrom wrote:
> > > >> On Wed September 9 2009, Thomas Fjellstrom wrote:
> > > >>> On Wed September 9 2009, Jeff Garzik wrote:
> > > >>>> On 09/09/2009 12:30 PM, Thomas Fjellstrom wrote:
> > > >>>>> No errors on that disk. Other than the one above, and its more of
> > > >>>>> a warning. However, I just rebooted to add some extra drives,
> > > >>>>> thinking everything was working a little better now that I've
> > > >>>>> updated to 2.6.31-rc9, I'm treated to the following two messages
> > > >>>>> right after boot (and a system lockup to boot):
> > > >>>>>
> > > >>>>> kernel: [  971.033138] ------------[ cut here ]------------
> > > >>>>> kernel: [  971.033211] WARNING: at drivers/ata/libata-core.c:4913
> > > >>>>> __ata_qc_complete+0x5a/0xe1 [libata]()
> > > >>>>> kernel: [  971.033217] Hardware name: GA-MA790FXT-UD5P
> > > >>>>> kernel: [  971.033221] Modules linked in: powernow_k8
> > > >>>>> cpufreq_conservative cpufreq_stats cpufreq_userspace
> > > >>>>> cpufreq_powersave kvm_amd kvm nfsd exportfs nfs lockd fscache
> > > >>>>> nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid adt7473
> > > >>>>> firewire_sbp2 loop md_mod
> > > >>>>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
> > > >>>>> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi
> > > >>>>> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
> > > >>>>> amd64_edac_mod edac_core i2c_piix4 soundcore snd_page_alloc
> > > >>>>> i2c_core evdev wmi parport_pc button parport processor ext3 jbd
> > > >>>>> mbcache dm_mod sg sr_mod cdrom sd_mod crc_t10dif usbhid
> > > >>>>> ata_generic ide_pci_generic hid mvsas firewire_ohci libsas
> > > >>>>> firewire_core crc_itu_t
> > > >>>>> scsi_transport_sas r8169 atiixp ide_core floppy ahci mii ohci_hcd
> > > >>>>> libata ehci_hcd scsi_mod thermal fan thermal_sys [last unloaded:
> > > >>>>> scsi_wait_scan]
> > > >>>>> kernel: [  971.033337] Pid: 0, comm: swapper Not tainted
> > > >>>>> 2.6.31-rc9 #2 kernel: [  971.033342] Call Trace:
> > > >>>>> kernel: [  971.033346]<IRQ>    [<ffffffffa00562ca>] ?
> > > >>>>> __ata_qc_complete+0x5a/0xe1 [libata]
> > > >>>>> kernel: [  971.033434]  [<ffffffffa00562ca>] ?
> > > >>>>> __ata_qc_complete+0x5a/0xe1 [libata]
> > > >>>>> kernel: [  971.033446]  [<ffffffff8104aca0>] ?
> > > >>>>> warn_slowpath_common+0x77/0xa3 kernel: [  971.033455]
> > > >>>>> [<ffffffff81038d06>] ? enqueue_task+0x5c/0x65 kernel: [
> > > >>>>> 971.033496] [<ffffffffa00562ca>] ? __ata_qc_complete+0x5a/0xe1
> > > >>>>> [libata] kernel: [  971.033519]  [<ffffffffa00f7b59>] ?
> > > >>>>> sas_ata_task_done+0x178/0x210 [libsas]
> > > >>>>> kernel: [  971.033528]  [<ffffffff8115ead1>] ?
> > > >>>>> blk_run_queue+0x21/0x35 kernel: [  971.033548]
> > > >>>>> [<ffffffffa010e2ce>] ?
> > > >>>>> mvs_slot_complete+0x3df/0x41b [mvsas]
> > > >>>>> kernel: [  971.033565]  [<ffffffffa010e39c>] ?
> > > >>>>> mvs_int_rx+0x92/0x101 [mvsas] kernel: [  971.033583]
> > > >>>>> [<ffffffffa01112ba>] ?
> > > >>>>> mvs_int_full+0x25/0x88 [mvsas] kernel: [  971.033600]
> > > >>>>> [<ffffffffa011134e>] ? mvs_64xx_isr+0x31/0x40 [mvsas] kernel: [
> > > >>>>> 971.033617]  [<ffffffffa010d0e5>] ? mvs_interrupt+0x61/0x78
> > > >>>>> [mvsas] kernel: [  971.033625]  [<ffffffff8108aaac>] ?
> > > >>>>> handle_IRQ_event+0x58/0x135 kernel: [  971.033633]
> > > >>>>> [<ffffffff8108c1a1>] ? handle_fasteoi_irq+0x7d/0xb5 kernel: [
> > > >>>>> 971.033642]
> > > >>>>> [<ffffffff8101388d>] ? handle_irq+0x17/0x1d
> > > >>>>
> > > >>>> That warning is triggered when an ata_queued_cmd is passed to
> > > >>>> completion without the ATA_QCFLAG_ACTIVE flag being set (which
> > > >>>> indicates the qc was started with some activity).
> > > >>>>
> > > >>>> That possibly indicates the low-level driver (or libsas) was
> > > >>>> passing an already-completed cmd to libata.
> > > >>>>
> > > >>>>> The added hard drives are connected to a Supermicro
> > > >>>>> AOC-SASLP-MV8, which is based on a marvel MV64460/64461/64462
> > > >>>>> chipset, which uses the sata_mv driver.
> > > >>>>
> > > >>>> Surely you mean 'mvsas' driver?
> > > >>>
> > > >>> Yes, sorry I did mean mvsas.
> > > >>>
> > > >>> I am more concerned about the actual oops/BUG rather than the
> > > >>> warning though. Unless the problem causing the warning is also
> > > >>> causing the oops.
> > > >>>
> > > >>>> 	Jeff
> > > >>
> > > >> Thanks for taking a look so far. But I'm having more and more
> > > >> trouble with this card as the days go by:
> > > >>
> > > >> [  464.792214] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  464.792222] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  494.816170] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  494.816179] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  494.816192] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  494.816197] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  525.817335] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  525.817343] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  525.817358] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  525.817363] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  556.816148] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  556.816157] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  556.816170] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  556.816175] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  587.816171] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  587.816179] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  587.816193] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  587.816199] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  600.616255] INFO: task mount:4395 blocked for more than 120
> > > >> seconds. [  600.616263] "echo 0>
> > > >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > >> [  600.616270] mount         D 0000000000000000     0  4395   4229
> > > >>   0x00000000 [  600.616281]  ffff88012fb6f780 0000000000000082
> > > >>   ffff8800b808ddc8 ffff8800b80f3d60
> > > >> [  600.616290]  ffff880128923c90 0000000000014800 000000000000f800
> > > >> ffff88012dd91840
> > > >> [  600.616299]  ffff88012dd91b38 0000000300000008 0000000000000000
> > > >> ffff88010c5bfa88
> > > >> [  600.616308] Call Trace:
> > > >> [  600.616324]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
> > > >> [  600.616335]  [<ffffffff810adc63>] ? __pagevec_free+0x29/0x3b
> > > >> [  600.616343]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
> > > >> [  600.616351]  [<ffffffff810a8e69>] ? sync_page+0x0/0x46
> > > >> [  600.616361]  [<ffffffff812dc8cb>] ? io_schedule+0x63/0xa5
> > > >> [  600.616368]  [<ffffffff810a8eaa>] ? sync_page+0x41/0x46
> > > >> [  600.616376]  [<ffffffff812dcade>] ? __wait_on_bit_lock+0x3f/0x84
> > > >> [  600.616383]  [<ffffffff810a8e55>] ? __lock_page+0x5d/0x63
> > > >> [  600.616391]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
> > > >> [  600.616401]  [<ffffffff810b0ad4>] ? pagevec_lookup+0x17/0x1e
> > > >> [  600.616408]  [<ffffffff810b1bbd>] ?
> > > >>   truncate_inode_pages_range+0x288/0x318 [  600.616418]
> > > >>   [<ffffffff810fc8cb>] ? set_blocksize+0xc2/0xd2
> > > >> [  600.616426]  [<ffffffff810fc8f2>] ? sb_set_blocksize+0x17/0x43
> > > >> [  600.616477]  [<ffffffffa04aa8e0>] ? ext4_fill_super+0x1cc/0x2060
> > > >> [ext4] [  600.616486]  [<ffffffff8117593b>] ? snprintf+0x44/0x4c
> > > >> [  600.616493]  [<ffffffff810fb5b7>] ? check_disk_change+0x22/0x52
> > > >> [  600.616501]  [<ffffffff812dd680>] ? __down_write_nested+0x15/0xab
> > > >> [  600.616524]  [<ffffffff810dbfe6>] ? get_sb_bdev+0x111/0x159
> > > >> [  600.616571]  [<ffffffffa04aa714>] ? ext4_fill_super+0x0/0x2060
> > > >> [ext4] [  600.616582]  [<ffffffff810dbc44>] ?
> > > >> vfs_kern_mount+0x95/0x111 [  600.616593]  [<ffffffff810dbd13>] ?
> > > >> do_kern_mount+0x43/0xe2 [  600.616607]  [<ffffffff810ef49d>] ?
> > > >> do_mount+0x767/0x7d6
> > > >> [  600.616620]  [<ffffffff810ef591>] ? sys_mount+0x85/0xc8
> > > >> [  600.616633]  [<ffffffff81010a02>] ?
> > > >> system_call_fastpath+0x16/0x1b [  618.816175]
> > > >> drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5 [  618.816184]
> > > >> drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5 [  618.816196]
> > > >> drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5 [  618.816201]
> > > >> drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5 [  618.816241]
> > > >> sd 1:0:3:0: [sdf] Unhandled error code
> > > >> [  618.816247] sd 1:0:3:0: [sdf] Result: hostbyte=DID_OK
> > > >> driverbyte=DRIVER_TIMEOUT
> > > >> [  618.816255] end_request: I/O error, dev sdf, sector 160
> > > >> [  618.816263] Buffer I/O error on device md2, logical block 20
> > > >> [  618.816274] Buffer I/O error on device md2, logical block 21
> > > >> [  618.816280] Buffer I/O error on device md2, logical block 22
> > > >> [  618.816285] Buffer I/O error on device md2, logical block 23
> > > >> [  618.816291] Buffer I/O error on device md2, logical block 24
> > > >> [  618.816298] Buffer I/O error on device md2, logical block 25
> > > >> [  618.816307] Buffer I/O error on device md2, logical block 26
> > > >> [  618.816316] Buffer I/O error on device md2, logical block 27
> > > >> [  618.816324] Buffer I/O error on device md2, logical block 28
> > > >> [  618.816331] Buffer I/O error on device md2, logical block 29
> > > >> [  649.780185] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  649.780194] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  649.780208] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  649.780214] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  649.780293] ------------[ cut here ]------------
> > > >> [  649.780366] WARNING: at drivers/ata/libata-core.c:5129
> > > >> ata_qc_issue+0x10a/0x347 [libata]()
> > > >> [  649.780373] Hardware name: GA-MA790FXT-UD5P
> > > >> [  649.780377] Modules linked in: ext4 jbd2 crc16 raid0 powernow_k8
> > > >> cpufreq_conservative cpufreq_stats cpufreq_userspace
> > > >> cpufreq_powersave kvm_amd kvm nfsd exportfs nfs lockd fscache
> > > >> nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid adt7473
> > > >> firewire_sbp2 loop md_mod snd_hda_codec_realtek
> > > >> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> > > >> snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event amd64_edac_mod
> > > >> snd_seq edac_core snd_timer snd_seq_device snd soundcore i2c_piix4
> > > >> snd_page_alloc i2c_core evdev parport_pc wmi parport button
> > > >> processor ext3 jbd mbcache dm_mod usbhid hid sg sr_mod cdrom sd_mod
> > > >> crc_t10dif ata_generic ide_pci_generic firewire_ohci firewire_core
> > > >> ohci_hcd crc_itu_t atiixp ide_core mvsas ehci_hcd ahci libsas libata
> > > >> scsi_transport_sas scsi_mod r8169 mii floppy thermal fan thermal_sys
> > > >> [last unloaded: scsi_wait_scan] [  649.780499] Pid: 3185, comm:
> > > >> hddtemp Not tainted 2.6.31-rc9 #2 [  649.780504] Call Trace: [ 
> > > >> 649.780551]  [<ffffffffa0074f90>] ? ata_qc_issue+0x10a/0x347
> > > >> [libata] [  649.780593]  [<ffffffffa0074f90>] ?
> > > >> ata_qc_issue+0x10a/0x347 [libata] [  649.780607] 
> > > >> [<ffffffff8104aca0>] ? warn_slowpath_common+0x77/0xa3 [  649.780649]
> > > >>  [<ffffffffa00790ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata] [ 
> > > >> 649.780690]
> > > >> [<ffffffffa0074f90>] ?
> > > >> ata_qc_issue+0x10a/0x347 [libata] [  649.780733] 
> > > >> [<ffffffffa00401d6>] ? scsi_get_command+0x75/0x97 [scsi_mod] [ 
> > > >> 649.780776]
> > > >> [<ffffffffa00790ce>] ?
> > > >>   ata_scsi_pass_thru+0x0/0x240 [libata] [  649.780815]
> > > >> [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod] [  649.780858]
> > > >> [<ffffffffa007a4d5>] ? __ata_scsi_queuecmd+0x185/0x1dc [libata]
> > > >> [  649.780896]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
> > > >> [  649.780918]  [<ffffffffa00a3c8e>] ? sas_queuecommand+0x83/0x25d
> > > >> [libsas] [  649.780956]  [<ffffffffa003fa7c>] ?
> > > >> scsi_dispatch_cmd+0x1c0/0x23c [scsi_mod]
> > > >> [  649.780996]  [<ffffffffa0044ff0>] ? scsi_request_fn+0x3a5/0x506
> > > >>   [scsi_mod] [  649.781006]  [<ffffffff810546e0>] ?
> > > >> del_timer+0x59/0x62 [  649.781016]  [<ffffffff81163b70>] ?
> > > >> blk_execute_rq_nowait+0x65/0x89 [  649.781032]  [<ffffffffa014164f>]
> > > >> ? sg_common_write+0x489/0x4ab [sg] [  649.781042] 
> > > >> [<ffffffff8115df56>] ? __freed_request+0x26/0x83 [  649.781056] 
> > > >> [<ffffffffa01421da>] ? sg_new_write+0x23e/0x269 [sg] [  649.781070] 
> > > >> [<ffffffffa0142473>] ? sg_ioctl+0x26e/0xb63 [sg] [  649.781080] 
> > > >> [<ffffffff81100f38>] ? inotify_d_instantiate+0x12/0x39 [ 
> > > >> 649.781088]  [<ffffffff8105eee6>] ?
> > > >> autoremove_wake_function+0x0/0x2e [  649.781098] 
> > > >> [<ffffffff810d80bf>] ? fd_install+0x2e/0x5a
> > > >> [  649.781105]  [<ffffffff810e5247>] ? vfs_ioctl+0x56/0x6c
> > > >> [  649.781111]  [<ffffffff810e570a>] ? do_vfs_ioctl+0x437/0x475
> > > >> [  649.781118]  [<ffffffff810e5799>] ? sys_ioctl+0x51/0x70
> > > >> [  649.781128]  [<ffffffff81010a02>] ?
> > > >> system_call_fastpath+0x16/0x1b [  649.781134] ---[ end trace
> > > >> 9005373b1b9c6eb7 ]---
> > > >> [  680.781672] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  680.781681] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  711.781672] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  711.781681] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  741.816069] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  741.816078] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  741.816090] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  741.816096] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  772.820160] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  772.820168] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  772.820181] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  772.820186] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  803.816212] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  803.816220] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  803.816233] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > >> [  803.816239] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > >> [  803.816264] sd 1:0:3:0: [sdf] Unhandled error code
> > > >> [  803.816270] sd 1:0:3:0: [sdf] Result: hostbyte=DID_OK
> > > >> driverbyte=DRIVER_TIMEOUT
> > > >> [  803.816278] end_request: I/O error, dev sdf, sector 512
> > > >> [  803.816284] __ratelimit: 70 callbacks suppressed
> > > >> [  803.816290] Buffer I/O error on device md2, logical block 64
> > > >>
> > > >> That's after bringing up a raid0 array I build a few days ago on 4
> > > >>   perfectly good (Seagate Baracuda 1TB 7200.12) disks, without the
> > > >> bad disk plugged in. I try to mount it, and the driver hangs.
> > > >> Anything trying to access any of the 4 disks hangs as well.
> > > >>
> > > >> I know this array worked a few days ago. The most major change I've
> > > >> made was upgrade from -rc8 (or -rc5, not sure if I mounted the array
> > > >> under -rc8) to -rc9.
> > > >
> > > > Hi, just wondering if anyone has had a chance to look at this, or if
> > > > there's some patches I should try out, or if you need me to do some
> > > > testing, I'd be glad to, thanks :)
> > >
> > > I was hoping that some VM would jump in.  The BUG in question is, from
> > > mm/slab.c:
> > >
> > >                  /*
> > >                   * The slab was either on partial or free list so
> > >                   * there must be at least one object available for
> > >                   * allocation.
> > >                   */
> > >                  BUG_ON(slabp->inuse >= cachep->num);
> > >
> > > So I wonder if that is a double-free, indicating a bug in
> > > SCSI/libsas/mvsas, or a VM problem of some sort.
> > >
> > > Was free memory low on that machine, at that point, perchance?
> >
> > Its remotely possible do to leaks in programs, but even konqueror and
> >  firefox don't eat up memory _that_ fast, so its very unlikely. This
> >  machine has 4G ram.
> >
> > > 	Jeff
> 
> Ok, I've managed to figure out one of my problems, the WD drive[s] don't
>  much like hddtemp and smartmon running all the time. I disabled them and
>  ran a long read test on the drives on a different controller, and they
>  work fine.
> 
> Things however are not so rosy, trying to do anything with the Marvell
>  based SAS card causes errors.
> 
> I've attached the dmesg log from a fresh boot of 2.6.31-git4 (with the edac
> amd patch applied).
> 
> I suspect somehow the card isn't initializing things right, as the
>  "Activity" lights on my hotswap bays are on for the two Seagate Baracuda
>  drives, not on full, but on none the less.
> 

I've tried yet again to get this stuff working, the two WD drives are now happily located on my mainboard's SATA ports, so they can't interfear with anything (in case they are overly picky or slow about various things, they are WD Green drives after all). I've also made sure to disable hddtemp and smartd.

The WD Green array works great, near 200MB/s throughput on my mainboard's controller.

But the mvsas controller continues to kill itself minutes after I try to do something with it. It starts with a bunch of these messages:

[ 1270.698287] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                             
[ 1270.698296] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5  

then the kernel sd/sata code gets upset and returns a bunch of these:

[ 1424.705240] sd 0:0:1:0: [sdf] Unhandled error code                                                                                            
[ 1424.705247] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT                                                               
[ 1424.705256] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 10 00 00 03 50 00  
[ 1424.705278] end_request: I/O error, dev sdf, sector 4096                                                                                      
[ 1424.705287] Buffer I/O error on device md1, logical block 2176 

And on till everything just gives up and the controller locks up completely. hotswaping disks won't get them back, and shutting down fails when the kernel attempts to shut down LVM volumes (even though I don't have any), and synchronize the drive's SCSI cache.

I've attached my full dmesg from this boot. Maybe it'll help.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

--Boundary-00=_IhlsKESfl/croZf
Content-Type: text/plain;
  charset="UTF-8";
  name="mvsas.dmesg2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mvsas.dmesg2"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-git4 (root@natasha) (gcc version 4.3.4 (Debian 4.3.4-2) ) #6 SMP PREEMPT Tue Sep 15 09:16:41 MDT 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-git4 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfde0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfdf0000 - 00000000cfe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 0000CFE00000 mask FFFFFFE00000 uncachable
[    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
[    0.000000]   5 base 000120000000 mask FFFFF0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfde0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfde0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfc00000 page 2M
[    0.000000]  00cfc00000 - 00cfde0000 page 4k
[    0.000000] kernel direct mapping tables up to cfde0000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ a000-c000
[    0.000000] RAMDISK: 376ee000 - 37fef4bf
[    0.000000] ACPI: RSDP 00000000000f7550 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfde3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfde30c0 0731E (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000cfde0000 00040
[    0.000000] ACPI: SSDT 00000000cfdea4c0 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000cfdead80 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfdeadc0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 00000000cfdeae00 0030A (v01 GBT    GBT   B0 5455312E BG 53450101)
[    0.000000] ACPI: APIC 00000000cfdea400 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000038fff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001641f14]    TEXT DATA BSS ==> [0001000000 - 0001641f14]
[    0.000000]   #3 [00376ee000 - 0037fef4bf]          RAMDISK ==> [00376ee000 - 0037fef4bf]
[    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
[    0.000000]   #5 [0001642000 - 0001642106]              BRK ==> [0001642000 - 0001642106]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f5b40] f5b40
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000cfde0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1047933
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 105 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833048 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfde0000 - 00000000cfde3000
[    0.000000] PM: Registered nosave memory: 00000000cfde3000 - 00000000cfdf0000
[    0.000000] PM: Registered nosave memory: 00000000cfdf0000 - 00000000cfe00000
[    0.000000] PM: Registered nosave memory: 00000000cfe00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cfe00000 (gap: cfe00000:10200000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages at ffff880028022000, static data 90528 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030804
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-git4 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 8d2c000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 4050428k/4980736k available (3034k kernel code, 789004k absent, 141304k reserved, 1662k data, 592k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2612.389 MHz processor.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000]   alloc irq_desc for 24 on node 0
[    0.000000]   alloc kstat_irqs on node 0
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.001999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5224.77 BogoMIPS (lpj=2612385)
[    0.001999] Security Framework initialized
[    0.001999] SELinux:  Disabled at boot.
[    0.001999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002832] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003439] Mount-cache hash table entries: 256
[    0.003602] Initializing cgroup subsys ns
[    0.003657] Initializing cgroup subsys cpuacct
[    0.003713] Initializing cgroup subsys devices
[    0.003768] Initializing cgroup subsys freezer
[    0.003823] Initializing cgroup subsys net_cls
[    0.003897] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003954] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004003] CPU 0/0x0 -> Node 0
[    0.004057] tseg: 00cfe00000
[    0.004059] CPU: Physical Processor ID: 0
[    0.004113] CPU: Processor Core ID: 0
[    0.004167] mce: CPU supports 6 MCE banks
[    0.004226] using C1E aware idle routine
[    0.004280] Performance Counters: AMD PMU driver.
[    0.004377] ... version:                 0
[    0.004431] ... bit width:               48
[    0.004485] ... generic counters:        4
[    0.004539] ... value mask:              0000ffffffffffff
[    0.004594] ... max period:              00007fffffffffff
[    0.004649] ... fixed-purpose counters:  0
[    0.004703] ... counter mask:            000000000000000f
[    0.005320] ACPI: Core revision 20090521
[    0.014065] Setting APIC routing to flat
[    0.015439] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025505] CPU0: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.025996] System has AMD C1E enabled
[    0.025996] Switch to broadcast mode on CPU0
[    0.026133] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] Calibrating delay using timer specific routine.. 5223.73 BogoMIPS (lpj=2611869)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 1/0x1 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.097672] CPU1: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.098084] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.099005] Switch to broadcast mode on CPU1
[    0.099058] Booting processor 2 APIC 0x2 ip 0x6000
[    0.001999] Initializing CPU#2
[    0.001999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611893)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 2/0x2 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 3
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.170662] CPU2: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.171077] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.171993] Switch to broadcast mode on CPU2
[    0.172052] Booting processor 3 APIC 0x3 ip 0x6000
[    0.001999] Initializing CPU#3
[    0.001999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611892)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 3/0x3 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 2
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.243659] CPU3: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.244066] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.244984] Brought up 4 CPUs
[    0.244983] Switch to broadcast mode on CPU3
[    0.245090] Total of 4 processors activated (20896.07 BogoMIPS).
[    0.245252] CPU0 attaching sched-domain:
[    0.245254]  domain 0: span 0-3 level MC
[    0.245256]   groups: 0 1 2 3
[    0.245261]   domain 1: span 0-3 level NODE
[    0.245263]    groups: 0-3 (cpu_power = 4096)
[    0.245267] CPU1 attaching sched-domain:
[    0.245269]  domain 0: span 0-3 level MC
[    0.245270]   groups: 1 2 3 0
[    0.245274]   domain 1: span 0-3 level NODE
[    0.245276]    groups: 0-3 (cpu_power = 4096)
[    0.245279] CPU2 attaching sched-domain:
[    0.245281]  domain 0: span 0-3 level MC
[    0.245282]   groups: 2 3 0 1
[    0.245286]   domain 1: span 0-3 level NODE
[    0.245288]    groups: 0-3 (cpu_power = 4096)
[    0.245291] CPU3 attaching sched-domain:
[    0.245293]  domain 0: span 0-3 level MC
[    0.245294]   groups: 3 0 1 2
[    0.245298]   domain 1: span 0-3 level NODE
[    0.245299]    groups: 0-3 (cpu_power = 4096)
[    0.246028] Booting paravirtualized kernel on bare hardware
[    0.246158] regulator: core version 0.5
[    0.246158] NET: Registered protocol family 16
[    0.246158] node 0 link 0: io port [a000, ffff]
[    0.246158] TOM: 00000000d0000000 aka 3328M
[    0.246964] Fam 10h mmconf [e0000000, e00fffff]
[    0.246966] node 0 link 0: mmio [a0000, bffff]
[    0.246968] node 0 link 0: mmio [d0000000, dfffffff]
[    0.246971] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.246973] node 0 link 0: mmio [e0000000, e05fffff] ==> [e0100000, e05fffff]
[    0.246976] TOM2: 0000000130000000 aka 4864M
[    0.247031] bus: [00,05] on node 0 link 0
[    0.247033] bus: 00 index 0 io port: [0, ffff]
[    0.247034] bus: 00 index 1 mmio: [a0000, bffff]
[    0.247036] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.247038] bus: 00 index 3 mmio: [e0600000, ffffffff]
[    0.247039] bus: 00 index 4 mmio: [e0100000, e05fffff]
[    0.247041] bus: 00 index 5 mmio: [130000000, fcffffffff]
[    0.247050] ACPI: bus type pci registered
[    0.247113] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.247113] PCI: MCFG area at e0000000 reserved in E820
[    0.258325] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.258381] PCI: Using configuration type 1 for base access
[    0.260074] bio: create slab <bio-0> at 0
[    0.260339] ACPI: EC: Look up EC in DSDT
[    0.267427] ACPI: Interpreter enabled
[    0.267484] ACPI: (supports S0 S3 S4 S5)
[    0.267720] ACPI: Using IOAPIC for interrupt routing
[    0.273185] ACPI: No dock devices found.
[    0.273204] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.274141] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.274141] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.274141] pci 0000:00:02.0: PME# disabled
[    0.274161] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.274218] pci 0000:00:07.0: PME# disabled
[    0.274298] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.274355] pci 0000:00:09.0: PME# disabled
[    0.274435] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.274491] pci 0000:00:0b.0: PME# disabled
[    0.274588] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.274595] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.274601] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.274607] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.274613] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.274620] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.274668] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.274718] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.274732] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.274732] pci 0000:00:12.2: supports D1 D2
[    0.274732] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.274732] pci 0000:00:12.2: PME# disabled
[    0.274732] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.274732] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.274732] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.274732] pci 0000:00:13.2: supports D1 D2
[    0.274732] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.274732] pci 0000:00:13.2: PME# disabled
[    0.274732] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.274732] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.274732] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.274732] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.274732] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.274732] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.274732] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.274769] pci 0000:00:14.2: PME# disabled
[    0.274917] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.275050] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.275057] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.275065] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.275070] pci 0000:01:00.0: reg 24 io port: [0xcf00-0xcf7f]
[    0.275075] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275139] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.275142] pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.275145] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.275176] pci 0000:02:00.0: reg 10 io port: [0xbe00-0xbeff]
[    0.275190] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdbff000-0xfdbfffff]
[    0.275200] pci 0000:02:00.0: reg 20 64bit mmio: [0xfdbf8000-0xfdbfbfff]
[    0.275206] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275232] pci 0000:02:00.0: supports D1 D2
[    0.275234] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275292] pci 0000:02:00.0: PME# disabled
[    0.275400] pci 0000:00:07.0: bridge io port: [0xb000-0xbfff]
[    0.275402] pci 0000:00:07.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.275405] pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
[    0.275437] pci 0000:03:00.0: reg 10 io port: [0xee00-0xeeff]
[    0.275451] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdfff000-0xfdffffff]
[    0.275460] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff8000-0xfdffbfff]
[    0.275466] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275493] pci 0000:03:00.0: supports D1 D2
[    0.275495] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275553] pci 0000:03:00.0: PME# disabled
[    0.275660] pci 0000:00:09.0: bridge io port: [0xe000-0xefff]
[    0.275663] pci 0000:00:09.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
[    0.275666] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.275701] pci 0000:04:00.0: reg 18 io port: [0xdf00-0xdf7f]
[    0.275713] pci 0000:04:00.0: reg 20 64bit mmio: [0xfdef0000-0xfdefffff]
[    0.275718] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x03ffff]
[    0.275739] pci 0000:04:00.0: supports D1
[    0.275740] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.275798] pci 0000:04:00.0: PME# disabled
[    0.275897] pci 0000:00:0b.0: bridge io port: [0xd000-0xdfff]
[    0.275900] pci 0000:00:0b.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.275903] pci 0000:00:0b.0: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.275970] pci 0000:05:0e.0: reg 10 32bit mmio: [0xfdaff000-0xfdaff7ff]
[    0.275983] pci 0000:05:0e.0: reg 14 32bit mmio: [0xfdaf8000-0xfdafbfff]
[    0.276038] pci 0000:05:0e.0: supports D1 D2
[    0.276039] pci 0000:05:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.276098] pci 0000:05:0e.0: PME# disabled
[    0.276184] pci 0000:00:14.4: transparent bridge
[    0.276241] pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
[    0.276245] pci 0000:00:14.4: bridge 32bit mmio: [0xfda00000-0xfdafffff]
[    0.276249] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd900000-0xfd9fffff]
[    0.276264] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.276515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.276590] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.276643] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.276689] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.276734] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
[    0.298144] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.298400] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.298767] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.299383] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.300007] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.300599] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.301180] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.301771] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.303445] usbcore: registered new interface driver usbfs
[    0.303445] usbcore: registered new interface driver hub
[    0.303451] usbcore: registered new device driver usb
[    0.303968] PCI: Using ACPI for IRQ routing
[    0.304029] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.304096] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.304235] PCI-DMA: Disabling AGP.
[    0.304235] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.304235] PCI-DMA: using GART IOMMU.
[    0.304235] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.305200] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.305466] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.307993] hpet: hpet2 irq 24 for MSI
[    0.311717] pnp: PnP ACPI init
[    0.311783] ACPI: bus type pnp registered
[    0.315014] pnp 00:0d: mem resource (0xd6c00-0xd7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315083] pnp 00:0d: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315152] pnp 00:0d: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315221] pnp 00:0d: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315298] pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315367] pnp 00:0d: mem resource (0x100000-0xcfddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315557] pnp: PnP ACPI: found 14 devices
[    0.315612] ACPI: ACPI bus type pnp unregistered
[    0.315673] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.315730] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.315787] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.315847] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.315904] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.315961] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.316018] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.316075] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.316132] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.316188] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.316245] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.316318] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.316376] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.316432] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.316489] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.316546] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.316604] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.316660] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.316717] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.316774] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.316835] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.316895] system 00:0d: iomem range 0xcfde0000-0xcfdfffff could not be reserved
[    0.316962] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.317020] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.317086] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.317144] system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.322282] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.322339] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.322396] pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
[    0.322453] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.322521] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.322577] pci 0000:00:07.0:   IO window: 0xb000-0xbfff
[    0.322633] pci 0000:00:07.0:   MEM window: 0xfdc00000-0xfdcfffff
[    0.322690] pci 0000:00:07.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.322758] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.322815] pci 0000:00:09.0:   IO window: 0xe000-0xefff
[    0.322871] pci 0000:00:09.0:   MEM window: 0xfd800000-0xfd8fffff
[    0.322928] pci 0000:00:09.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.322995] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    0.323051] pci 0000:00:0b.0:   IO window: 0xd000-0xdfff
[    0.323108] pci 0000:00:0b.0:   MEM window: 0xfde00000-0xfdefffff
[    0.323165] pci 0000:00:0b.0:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
[    0.323232] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.323298] pci 0000:00:14.4:   IO window: 0xa000-0xafff
[    0.323357] pci 0000:00:14.4:   MEM window: 0xfda00000-0xfdafffff
[    0.323415] pci 0000:00:14.4:   PREFETCH window: 0xfd900000-0xfd9fffff
[    0.323478]   alloc irq_desc for 18 on node 0
[    0.323480]   alloc kstat_irqs on node 0
[    0.323488] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.323546] pci 0000:00:02.0: setting latency timer to 64
[    0.323550]   alloc irq_desc for 19 on node 0
[    0.323552]   alloc kstat_irqs on node 0
[    0.323558] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.323616] pci 0000:00:07.0: setting latency timer to 64
[    0.323620]   alloc irq_desc for 17 on node 0
[    0.323621]   alloc kstat_irqs on node 0
[    0.323628] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.323686] pci 0000:00:09.0: setting latency timer to 64
[    0.323690] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.323747] pci 0000:00:0b.0: setting latency timer to 64
[    0.323755] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.323757] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.323759] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.323761] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
[    0.323763] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.323765] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.323767] pci_bus 0000:02: resource 1 mem: [0xfdc00000-0xfdcfffff]
[    0.323769] pci_bus 0000:02: resource 2 pref mem [0xfdb00000-0xfdbfffff]
[    0.323771] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.323773] pci_bus 0000:03: resource 1 mem: [0xfd800000-0xfd8fffff]
[    0.323775] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.323778] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.323779] pci_bus 0000:04: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.323781] pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
[    0.323784] pci_bus 0000:05: resource 0 io:  [0xa000-0xafff]
[    0.323786] pci_bus 0000:05: resource 1 mem: [0xfda00000-0xfdafffff]
[    0.323787] pci_bus 0000:05: resource 2 pref mem [0xfd900000-0xfd9fffff]
[    0.323790] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.323791] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.323877] NET: Registered protocol family 2
[    0.324076] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.325068] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.327318] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.327638] TCP: Hash tables configured (established 524288 bind 65536)
[    0.327695] TCP reno registered
[    0.327879] NET: Registered protocol family 1
[    0.327979] Trying to unpack rootfs image as initramfs...
[    0.487577] Freeing initrd memory: 9221k freed
[    0.491407] audit: initializing netlink socket (disabled)
[    0.491474] type=2000 audit(1253200139.490:1): initialized
[    0.491807] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.492020] VFS: Disk quotas dquot_6.5.2
[    0.492106] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.492206] msgmni has been set to 7929
[    0.493455] alg: No test for stdrng (krng)
[    0.493580] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.493647] io scheduler noop registered
[    0.493701] io scheduler anticipatory registered
[    0.493755] io scheduler deadline registered
[    0.493829] io scheduler cfq registered (default)
[    0.511333] Switched to high resolution mode on CPU 1
[    0.511335] Switched to high resolution mode on CPU 3
[    0.511338] Switched to high resolution mode on CPU 2
[    0.512031] Switched to high resolution mode on CPU 0
[    0.565310] pci 0000:01:00.0: Boot video device
[    0.565444]   alloc irq_desc for 25 on node 0
[    0.565446]   alloc kstat_irqs on node 0
[    0.565454] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.565459] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.565605]   alloc irq_desc for 26 on node 0
[    0.565607]   alloc kstat_irqs on node 0
[    0.565612] pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
[    0.565615] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.565737]   alloc irq_desc for 27 on node 0
[    0.565738]   alloc kstat_irqs on node 0
[    0.565743] pcieport-driver 0000:00:09.0: irq 27 for MSI/MSI-X
[    0.565747] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.565886]   alloc irq_desc for 28 on node 0
[    0.565888]   alloc kstat_irqs on node 0
[    0.565892] pcieport-driver 0000:00:0b.0: irq 28 for MSI/MSI-X
[    0.565895] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.568712] Linux agpgart interface v0.103
[    0.573085] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.573285] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.573713] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.575226] brd: module loaded
[    0.575346] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.575562] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.575618] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.575772] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.575962] mice: PS/2 mouse device common for all mice
[    0.576067] rtc_cmos 00:05: RTC can wake from S4
[    0.576168] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.576253] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.576340] cpuidle: using governor ladder
[    0.576399] cpuidle: using governor menu
[    0.576455] No iBFT detected.
[    0.576794] TCP cubic registered
[    0.576908] NET: Registered protocol family 10
[    0.577384] lo: Disabled Privacy Extensions
[    0.577705] Mobile IPv6
[    0.577758] NET: Registered protocol family 17
[    0.577961] registered taskstats version 1
[    0.578174] rtc_cmos 00:05: setting system clock to 2009-09-17 15:09:00 UTC (1253200140)
[    0.578280] Freeing unused kernel memory: 592k freed
[    0.578463] Write protecting the kernel read-only data: 4108k
[    0.600285] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.685770] Floppy drive(s): fd0 is 1.44M
[    0.703420] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.703495] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.703600] r8169 0000:02:00.0: setting latency timer to 64
[    0.703632]   alloc irq_desc for 29 on node 0
[    0.703634]   alloc kstat_irqs on node 0
[    0.703646] r8169 0000:02:00.0: irq 29 for MSI/MSI-X
[    0.704161] eth0: RTL8168d/8111d at 0xffffc90000666000, 00:24:1d:18:f8:b2, XID 081000c0 IRQ 29
[    0.705822] FDC 0 is a post-1991 82077
[    0.727770] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.727847] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.727938] r8169 0000:03:00.0: setting latency timer to 64
[    0.727969]   alloc irq_desc for 30 on node 0
[    0.727971]   alloc kstat_irqs on node 0
[    0.727983] r8169 0000:03:00.0: irq 30 for MSI/MSI-X
[    0.728537] eth1: RTL8168d/8111d at 0xffffc90000634000, 00:24:1d:18:f8:f3, XID 081000c0 IRQ 30
[    0.729095] SCSI subsystem initialized
[    0.755516] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.756318] libata version 3.00 loaded.
[    0.759213] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.760524] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.760615] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.760733] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.760822] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    0.760904] ehci_hcd 0000:00:12.2: debug port 1
[    0.760979] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    0.767816] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.767893] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.767950] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.768046] usb usb1: Product: EHCI Host Controller
[    0.768101] usb usb1: Manufacturer: Linux 2.6.31-git4 ehci_hcd
[    0.768160] usb usb1: SerialNumber: 0000:00:12.2
[    0.768261] usb usb1: configuration #1 chosen from 1 choice
[    0.768340] hub 1-0:1.0: USB hub found
[    0.768399] hub 1-0:1.0: 6 ports detected
[    0.768646] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[    0.768712] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.768771] mvsas 0000:04:00.0: setting latency timer to 64
[    0.768834]   alloc irq_desc for 16 on node 0
[    0.768835]   alloc kstat_irqs on node 0
[    0.768844] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.768924] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.769022] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 2
[    0.769120] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    0.770429] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    0.773358] Uniform Multi-Platform E-IDE driver
[    0.778340]   alloc irq_desc for 22 on node 0
[    0.778343]   alloc kstat_irqs on node 0
[    0.778354] firewire_ohci 0000:05:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.823157] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.823214] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.823280] usb usb2: Product: OHCI Host Controller
[    0.823335] usb usb2: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.823390] usb usb2: SerialNumber: 0000:00:12.0
[    0.823503] usb usb2: configuration #1 chosen from 1 choice
[    0.823581] hub 2-0:1.0: USB hub found
[    0.823642] hub 2-0:1.0: 3 ports detected
[    0.823814] ahci 0000:00:11.0: version 3.0
[    0.823824] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.823986] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.824062] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.824440] scsi1 : ahci
[    0.824594] scsi2 : ahci
[    0.824692] scsi3 : ahci
[    0.824789] scsi4 : ahci
[    0.824887] scsi5 : ahci
[    0.824982] scsi6 : ahci
[    0.825148] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    0.825215] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    0.825282] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 22
[    0.825350] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    0.825419] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    0.825486] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    0.825626] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.825702] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.825802] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[    0.825887] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    0.825967] ehci_hcd 0000:00:13.2: debug port 1
[    0.826049] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    0.832117] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.832189] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.832246] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.832315] usb usb3: Product: EHCI Host Controller
[    0.832370] usb usb3: Manufacturer: Linux 2.6.31-git4 ehci_hcd
[    0.832430] usb usb3: SerialNumber: 0000:00:13.2
[    0.832519] usb usb3: configuration #1 chosen from 1 choice
[    0.832597] hub 3-0:1.0: USB hub found
[    0.832655] hub 3-0:1.0: 6 ports detected
[    0.832935] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    0.832997] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.833085] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    0.833150]     ide0: BM-DMA at 0xfa00-0xfa07
[    0.833221] atiixp 0000:00:14.1: simplex device: DMA disabled
[    0.833281] ide1: DMA disabled
[    0.833343] Probing IDE interface ide0...
[    0.838010] firewire_ohci: Added fw-ohci device 0000:05:0e.0, OHCI version 1.10
[    1.130126] ata4: SATA link down (SStatus 0 SControl 300)
[    1.251117] usb 2-3: new low speed USB device using ohci_hcd and address 2
[    1.283127] ata1: softreset failed (device not ready)
[    1.283185] ata1: applying SB600 PMP SRST workaround and retrying
[    1.283255] ata5: softreset failed (device not ready)
[    1.283311] ata5: applying SB600 PMP SRST workaround and retrying
[    1.283383] ata2: softreset failed (device not ready)
[    1.283439] ata2: applying SB600 PMP SRST workaround and retrying
[    1.284138] ata6: softreset failed (device not ready)
[    1.284196] ata6: applying SB600 PMP SRST workaround and retrying
[    1.338148] firewire_core: created device fw0: GUID 001a9c2c0000241d, S400
[    1.361129] Probing IDE interface ide1...
[    1.364133] ide1: no devices on the port
[    1.364234] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.364368] ide1 at 0x170-0x177,0x376 on irq 15
[    1.364546] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.364618] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.364707] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    1.364790] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    1.400177] usb 2-3: New USB device found, idVendor=046d, idProduct=c01d
[    1.400236] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.400297] usb 2-3: Product: USB-PS/2 Optical Mouse
[    1.400358] usb 2-3: Manufacturer: Logitech
[    1.400458] usb 2-3: configuration #1 chosen from 1 choice
[    1.420146] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.420207] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.420273] usb usb4: Product: OHCI Host Controller
[    1.420328] usb usb4: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.420383] usb usb4: SerialNumber: 0000:00:12.1
[    1.420479] usb usb4: configuration #1 chosen from 1 choice
[    1.420559] hub 4-0:1.0: USB hub found
[    1.420619] hub 4-0:1.0: 3 ports detected
[    1.420774] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.420841] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.420921] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.421020] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    1.436504] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.436580] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.436651] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.437090] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    1.437157] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.437215] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.438050] ata1.00: configured for UDMA/133
[    1.449201] scsi 1:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    1.463769] ata2.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    1.463827] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.475047] ata6.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    1.475106] ata6.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.476149] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.476207] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.476280] usb usb5: Product: OHCI Host Controller
[    1.476339] usb usb5: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.476398] usb usb5: SerialNumber: 0000:00:13.0
[    1.476498] usb usb5: configuration #1 chosen from 1 choice
[    1.476576] hub 5-0:1.0: USB hub found
[    1.476636] hub 5-0:1.0: 3 ports detected
[    1.476784] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.476853] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.476938] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    1.477028] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.480761] ata6.00: configured for UDMA/133
[    1.503573] ata2.00: configured for UDMA/133
[    1.514176] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    1.533141] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.533202] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.533268] usb usb6: Product: OHCI Host Controller
[    1.533322] usb usb6: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.533378] usb usb6: SerialNumber: 0000:00:13.1
[    1.533470] usb usb6: configuration #1 chosen from 1 choice
[    1.533545] hub 6-0:1.0: USB hub found
[    1.533606] hub 6-0:1.0: 3 ports detected
[    1.533757] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.533824] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.533907] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.533986] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.589149] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.589210] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.589275] usb usb7: Product: OHCI Host Controller
[    1.589330] usb usb7: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.589385] usb usb7: SerialNumber: 0000:00:14.5
[    1.589472] usb usb7: configuration #1 chosen from 1 choice
[    1.589548] hub 7-0:1.0: USB hub found
[    1.589607] hub 7-0:1.0: 2 ports detected
[    1.701147] ata3: softreset failed (device not ready)
[    1.701209] ata3: applying SB600 PMP SRST workaround and retrying
[    1.838145] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    1.838204] ata5.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.844813] ata5.00: configured for UDMA/133
[    1.854117] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.855398] ata3.00: ATAPI: PIONEER DVD-RW  DVR-212D, 1.21, max UDMA/66
[    1.857073] ata3.00: configured for UDMA/66
[    1.880598] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212D 1.21 PQ: 0 ANSI: 5
[    1.880835] scsi 5:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    1.881034] scsi 6:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    1.884075] usbcore: registered new interface driver hiddev
[    1.889279] sd 1:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.889389] sd 1:0:0:0: [sda] Write Protect is off
[    1.889445] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.889460] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.889612]  sda: sda2
[    1.890260] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.890336] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.890389] sd 5:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    1.890419] sd 5:0:0:0: [sdc] Write Protect is off
[    1.890421] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.890435] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.890523]  sdc:
[    1.890664] sd 2:0:0:0: [sdb] Write Protect is off
[    1.890769] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.890783] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.890926]  sdb:
[    1.891211] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb2/2-3/2-3:1.0/input/input2
[    1.891392] generic-usb 0003:046D:C01D.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-3/input0
[    1.891489] usbcore: registered new interface driver usbhid
[    1.891545] usbhid: v2.6:USB HID core driver
[    1.892594] sd 6:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    1.892689] sd 6:0:0:0: [sdd] Write Protect is off
[    1.892745] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.892760] sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.892912]  sdd: sdb1 sdb2 sdb3 sdb4
[    1.935663] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    1.935731] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    1.939800] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    1.939867] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    1.941430] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.948128] CE: hpet increasing min_delta_ns to 15000 nsec
[    1.972098]  [LDM] sdc1
[    1.972544] sd 5:0:0:0: [sdc] Attached SCSI disk
[    1.975515]  [LDM] sdd1
[    1.975911] sd 6:0:0:0: [sdd] Attached SCSI disk
[    1.995866] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    1.995927] Uniform CD-ROM driver Revision: 3.20
[    1.996065] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.000456] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.000534] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.000609] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    2.000682] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    2.000754] sd 6:0:0:0: Attached scsi generic sg4 type 0
[    5.148149] drivers/scsi/mvsas/mv_sas.c 1214:port 0 attach dev info is 2000400
[    5.148152] drivers/scsi/mvsas/mv_sas.c 1216:port 0 attach sas addr is 0
[    5.349122] drivers/scsi/mvsas/mv_sas.c 1214:port 1 attach dev info is 0
[    5.349124] drivers/scsi/mvsas/mv_sas.c 1216:port 1 attach sas addr is 1
[    5.550122] drivers/scsi/mvsas/mv_sas.c 1214:port 2 attach dev info is 20000000
[    5.550124] drivers/scsi/mvsas/mv_sas.c 1216:port 2 attach sas addr is 2
[    5.751124] drivers/scsi/mvsas/mv_sas.c 1214:port 3 attach dev info is 20000
[    5.751126] drivers/scsi/mvsas/mv_sas.c 1216:port 3 attach sas addr is 3
[    5.852106] drivers/scsi/mvsas/mv_sas.c 1214:port 4 attach dev info is 0
[    5.852108] drivers/scsi/mvsas/mv_sas.c 1216:port 4 attach sas addr is 0
[    5.953100] drivers/scsi/mvsas/mv_sas.c 1214:port 5 attach dev info is 0
[    5.953102] drivers/scsi/mvsas/mv_sas.c 1216:port 5 attach sas addr is 0
[    6.054119] drivers/scsi/mvsas/mv_sas.c 1214:port 6 attach dev info is 0
[    6.054121] drivers/scsi/mvsas/mv_sas.c 1216:port 6 attach sas addr is 0
[    6.155102] drivers/scsi/mvsas/mv_sas.c 1214:port 7 attach dev info is 0
[    6.155104] drivers/scsi/mvsas/mv_sas.c 1216:port 7 attach sas addr is 0
[    6.155109] scsi0 : mvsas
[    6.155755] drivers/scsi/mvsas/mv_sas.c 380:phy 0 byte dmaded.
[    6.155758] drivers/scsi/mvsas/mv_sas.c 380:phy 1 byte dmaded.
[    6.155761] drivers/scsi/mvsas/mv_sas.c 380:phy 2 byte dmaded.
[    6.155764] drivers/scsi/mvsas/mv_sas.c 380:phy 3 byte dmaded.
[    6.157026] drivers/scsi/mvsas/mv_sas.c 1365:found dev[0:5] is gone.
[    6.182821] device-mapper: uevent: version 1.0.3
[    6.183075] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    6.184083] ata7.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.184142] ata7.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.198727] kjournald starting.  Commit interval 5 seconds
[    6.198733] EXT3-fs: mounted filesystem with ordered data mode.
[    6.223745] ata7.00: configured for UDMA/133
[    6.223850] scsi 0:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.224960] drivers/scsi/mvsas/mv_sas.c 1365:found dev[1:5] is gone.
[    6.252349] ata8.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.252409] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.292358] ata8.00: configured for UDMA/133
[    6.292453] scsi 0:0:1:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.293511] drivers/scsi/mvsas/mv_sas.c 1365:found dev[2:5] is gone.
[    6.320750] ata9.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.320808] ata9.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.353096] udev: starting version 141
[    6.360400] ata9.00: configured for UDMA/133
[    6.360497] scsi 0:0:2:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.362087] drivers/scsi/mvsas/mv_sas.c 1365:found dev[3:5] is gone.
[    6.363279] ata10.00: ATA-8: ST31000523AS, CC35, max UDMA/133
[    6.363338] ata10.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.364654] ata10.00: configured for UDMA/133
[    6.364746] scsi 0:0:3:0: Direct-Access     ATA      ST31000523AS     CC35 PQ: 0 ANSI: 5
[    6.392373] processor LNXCPU:00: registered as cooling_device0
[    6.392479] processor LNXCPU:01: registered as cooling_device1
[    6.392568] processor LNXCPU:02: registered as cooling_device2
[    6.392656] processor LNXCPU:03: registered as cooling_device3
[    6.393835] ACPI: WMI: Mapper loaded
[    6.395381] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    6.395453] ACPI: Power Button [PWRF]
[    6.395556] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    6.395624] ACPI: Power Button [PWRB]
[    6.415585] parport_pc 00:0a: reported by Plug and Play ACPI
[    6.415695] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.442688] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    6.442759] ACPI: Device needs an ACPI driver
[    6.442832] piix4_smbus: probe of 0000:00:14.0 failed with error -16
[    6.464706] EDAC MC: Ver: 2.1.0 Sep 15 2009
[    6.465373] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.498834] EDAC amd64_edac:  Ver: 3.2.0 Sep 15 2009
[    6.501532] EDAC amd64: This node reports that Memory ECC is currently disabled.
[    6.501606] EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTROL device (0000:00:18.3) should be enabled
[    6.501675] EDAC amd64: WARNING: ECC is NOT currently enabled by the BIOS. Module will NOT be loaded.
[    6.501676]     Either Enable ECC in the BIOS, or use the 'ecc_enable_override' parameter.
[    6.501677]     Might be a BIOS bug, if BIOS says ECC is enabled
[    6.501678]     Use of the override can cause unknown side effects.
[    6.519331] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    6.569783] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.610642] hda_codec: ALC889A: BIOS auto-probing.
[    6.612227] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[    6.802809] Adding 8385920k swap on /dev/sdb4.  Priority:-1 extents:1 across:8385920k 
[    6.824560] EXT3 FS on sda2, internal journal
[    6.845570] loop: module loaded
[    6.859741] it87: Found IT8720F chip at 0x228, revision 5
[    6.859811] it87: in3 is VCC (+5V)
[    7.163458] sd 0:0:0:0: Attached scsi generic sg5 type 0
[    7.163613] sd 0:0:1:0: Attached scsi generic sg6 type 0
[    7.163752] sd 0:0:2:0: Attached scsi generic sg7 type 0
[    7.163888] sd 0:0:3:0: Attached scsi generic sg8 type 0
[    7.164034] sd 0:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.164130] sd 0:0:0:0: [sde] Write Protect is off
[    7.164186] sd 0:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    7.164201] sd 0:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.164369]  sde:
[    7.164523] sd 0:0:1:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.164673] sd 0:0:1:0: [sdf] Write Protect is off
[    7.164730] sd 0:0:1:0: [sdf] Mode Sense: 00 3a 00 00
[    7.164744] sd 0:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.164904]  sdf:
[    7.165083] sd 0:0:2:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.165127] sd 0:0:3:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.165157] sd 0:0:3:0: [sdh] Write Protect is off
[    7.165159] sd 0:0:3:0: [sdh] Mode Sense: 00 3a 00 00
[    7.165173] sd 0:0:3:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.165261]  sdh:
[    7.165467] sd 0:0:2:0: [sdg] Write Protect is off
[    7.165572] sd 0:0:2:0: [sdg] Mode Sense: 00 3a 00 00
[    7.165587] sd 0:0:2:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.165736]  sdg: unknown partition table
[    7.172112] sd 0:0:1:0: [sdf] Attached SCSI disk
[    7.174611]  unknown partition table
[    7.174797] sd 0:0:2:0: [sdg] Attached SCSI disk
[    7.178964]  unknown partition table
[    7.179149] sd 0:0:3:0: [sdh] Attached SCSI disk
[    7.181915]  unknown partition table
[    7.182117] sd 0:0:0:0: [sde] Attached SCSI disk
[    7.188782] kjournald starting.  Commit interval 5 seconds
[    7.189266] EXT3 FS on sdb3, internal journal
[    7.189366] EXT3-fs: mounted filesystem with ordered data mode.
[    7.350222] Bridge firewalling registered
[    7.352854] device eth0 entered promiscuous mode
[    7.354040] r8169: eth0: link up
[    7.354098] r8169: eth0: link up
[    7.356020] br0: port 1(eth0) entering learning state
[   17.690086] br0: no IPv6 routers present
[   18.165072] eth0: no IPv6 routers present
[   22.355095] br0: port 1(eth0) entering forwarding state
[   24.376527] RPC: Registered udp transport module.
[   24.376593] RPC: Registered tcp transport module.
[   24.387307] Slow work thread pool: Starting up
[   24.387410] Slow work thread pool: Ready
[   24.387488] FS-Cache: Loaded
[   24.403083] FS-Cache: Netfs 'nfs' registered for caching
[   24.416229] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   24.577351] svc: failed to register lockdv1 RPC service (errno 97).
[   24.922273] kvm: Nested Virtualization enabled
[   24.922331] kvm: Nested Paging enabled
[   24.959112] powernow-k8: Found 1 AMD Phenom(tm) II X4 810 Processor processors (4 cpu cores) (version 2.20.00)
[   24.959149] powernow-k8:    0 : pstate 0 (2600 MHz)
[   24.959151] powernow-k8:    1 : pstate 1 (1900 MHz)
[   24.959153] powernow-k8:    2 : pstate 2 (1400 MHz)
[   24.959154] powernow-k8:    3 : pstate 3 (800 MHz)
[   33.746793] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   33.746800] vboxdrv: Successfully done.
[   33.746806] vboxdrv: Found 4 processor cores.
[   33.746898] VBoxDrv: dbg - g_abExecMemory=ffffffffa04d38e0
[   33.747108] vboxdrv: fAsync=0 offMin=0x757 offMax=0xe71d
[   33.747272] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   33.747358] vboxdrv: Successfully loaded version 3.0.6 (interface 0x000e0000).
[   33.960935] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa066f620
[   33.967893] VBoxNetAdp: dbg - g_abExecMemory=ffffffffa06861e0
[   35.621809] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   35.622316] NFSD: starting 90-second grace period
[   35.701831] process `upsagentd' is using obsolete setsockopt SO_BSDCOMPAT
[   35.975705] lo: Disabled Privacy Extensions
[   65.024395] warning: `VirtualBox' uses 32-bit capabilities (legacy support in use)
[   66.178882] VBoxTestOGL[4282]: segfault at 0 ip 00007fb25a2d4450 sp 00007fff1fcb4510 error 4 in libGL.so.185.18.31[7fb25a255000+8d000]
[  302.348354] md: nonpersistent superblock ...
[  302.348365] md: bind<sdc1>
[  302.348442] md: nonpersistent superblock ...
[  302.348448] md: bind<sdd1>
[  302.353180] md: raid0 personality registered for level 0
[  302.353500] raid0: looking at sdd1
[  302.353507] raid0:   comparing sdd1(3907024896)
[  302.353514]  with sdd1(3907024896)
[  302.353518] raid0:   END
[  302.353522] raid0:   ==> UNIQUE
[  302.353527] raid0: 1 zones
[  302.353532] raid0: looking at sdc1
[  302.353538] raid0:   comparing sdc1(3907024896)
[  302.353543]  with sdd1(3907024896)
[  302.353548] raid0:   EQUAL
[  302.353552] raid0: FINAL 1 zones
[  302.353559] raid0: done.
[  302.353564] raid0 : md_size is 7814049792 sectors.
[  302.353570] ******* md0 configuration *********
[  302.353574] zone0=[sdc1/sdd1/]
[  302.353587]         zone offset=0kb device offset=0kb size=3907024896kb
[  302.353592] **********************************
[  302.353594] 
[  302.353615] md0: detected capacity change from 0 to 4000793493504
[  302.356806] udevadm[4433]: segfault at 0 ip 00007f2384cbf210 sp 00007fff8018b698 error 4 in libc-2.9.so[7f2384c46000+147000]
[  302.357921]  md0: unknown partition table
[  302.374074] udevadm[4435]: segfault at 0 ip 00007fe1017b0210 sp 00007fffbf0b2318 error 4 in libc-2.9.so[7fe101737000+147000]
[  302.397608] udevadm[4437]: segfault at 0 ip 00007f1fc3efa210 sp 00007fff8371caf8 error 4 in libc-2.9.so[7f1fc3e81000+147000]
[  306.680709] fuse init (API version 7.12)
[  314.379406] md: md0 stopped.
[  314.379423] md: unbind<sdd1>
[  314.385323] md: export_rdev(sdd1)
[  314.385342] md: unbind<sdc1>
[  314.389185] md: export_rdev(sdc1)
[  314.389267] md0: detected capacity change from 4000793493504 to 0
[  324.772114] md: nonpersistent superblock ...
[  324.772146] md: bind<sdd1>
[  324.772198] md: nonpersistent superblock ...
[  324.772204] md: bind<sdc1>
[  324.775189] raid0: looking at sdc1
[  324.775198] raid0:   comparing sdc1(3907024896)
[  324.775204]  with sdc1(3907024896)
[  324.775208] raid0:   END
[  324.775212] raid0:   ==> UNIQUE
[  324.775216] raid0: 1 zones
[  324.775220] raid0: looking at sdd1
[  324.775225] raid0:   comparing sdd1(3907024896)
[  324.775230]  with sdc1(3907024896)
[  324.775233] raid0:   EQUAL
[  324.775238] raid0: FINAL 1 zones
[  324.775244] raid0: done.
[  324.775248] raid0 : md_size is 7814049792 sectors.
[  324.775253] ******* md0 configuration *********
[  324.775257] zone0=[sdd1/sdc1/]
[  324.775268]         zone offset=0kb device offset=0kb size=3907024896kb
[  324.775272] **********************************
[  324.775275] 
[  324.775297] md0: detected capacity change from 0 to 4000793493504
[  324.778951]  md0: AHDI p2 p3
[  458.204320] md: md0 still in use.
[  458.204502] md: md0 still in use.
[  458.243576] md: md1 stopped.
[  458.251343] md: bind<sdf>
[  458.251562] md: bind<sdg>
[  458.251760] md: bind<sdh>
[  458.251964] md: bind<sde>
[  458.254889] raid0: looking at sde
[  458.254898] raid0:   comparing sde(1953524736)
[  458.254904]  with sde(1953524736)
[  458.254909] raid0:   END
[  458.254912] raid0:   ==> UNIQUE
[  458.254916] raid0: 1 zones
[  458.254921] raid0: looking at sdh
[  458.254926] raid0:   comparing sdh(1953524736)
[  458.254932]  with sde(1953524736)
[  458.254936] raid0:   EQUAL
[  458.254940] raid0: looking at sdg
[  458.254945] raid0:   comparing sdg(1953524736)
[  458.254949]  with sde(1953524736)
[  458.254953] raid0:   EQUAL
[  458.254958] raid0: looking at sdf
[  458.254962] raid0:   comparing sdf(1953524736)
[  458.254967]  with sde(1953524736)
[  458.254970] raid0:   EQUAL
[  458.254975] raid0: FINAL 1 zones
[  458.254982] raid0: done.
[  458.254987] raid0 : md_size is 7814098944 sectors.
[  458.254992] ******* md1 configuration *********
[  458.254996] zone0=[sde/sdf/sdg/sdh/]
[  458.255011]         zone offset=0kb device offset=0kb size=3907049472kb
[  458.255016] **********************************
[  458.255018] 
[  458.255048] md1: detected capacity change from 0 to 4000818659328
[  458.256875]  md1: unknown partition table
[  469.691312] EXT4-fs (md1): barriers enabled
[  471.043829] kjournald2 starting: pid 4630, dev md1:8, commit interval 5 seconds
[  471.046846] EXT4-fs (md1): internal journal on md1:8
[  471.046859] EXT4-fs (md1): delayed allocation enabled
[  471.046868] EXT4-fs: file extents enabled
[  471.513516] EXT4-fs: mballoc enabled
[  471.513533] EXT4-fs (md1): recovery complete
[  471.513962] EXT4-fs (md1): mounted filesystem with ordered data mode
[  708.957454] JBD: barrier-based sync failed on md1:8 - disabling barriers
[ 1203.133284] CE: hpet increasing min_delta_ns to 22500 nsec
[ 1270.698287] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1270.698296] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1270.698329] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1270.698335] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1270.698363] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1270.698369] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1270.698395] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1270.698400] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1301.698368] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1301.698377] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1301.698415] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1301.698421] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1301.698452] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1301.698458] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1301.698486] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1301.698491] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1331.704161] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1331.704170] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1331.704203] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1331.704209] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1331.704237] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1331.704242] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1331.704268] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1331.704274] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1362.704211] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1362.704220] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1362.704254] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1362.704260] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1362.704288] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1362.704294] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1362.704321] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1362.704326] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1393.704179] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1393.704189] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1393.704223] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1393.704229] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1393.704258] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1393.704263] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1393.704289] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1393.704294] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1424.705080] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1424.705090] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1424.705122] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1424.705128] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1424.705157] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1424.705162] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1424.705188] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1424.705193] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1424.705240] sd 0:0:1:0: [sdf] Unhandled error code
[ 1424.705247] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.705256] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 10 00 00 03 50 00
[ 1424.705278] end_request: I/O error, dev sdf, sector 4096
[ 1424.705287] Buffer I/O error on device md1, logical block 2176
[ 1424.705297] Buffer I/O error on device md1, logical block 2177
[ 1424.705303] Buffer I/O error on device md1, logical block 2178
[ 1424.705309] Buffer I/O error on device md1, logical block 2179
[ 1424.705315] Buffer I/O error on device md1, logical block 2180
[ 1424.705320] Buffer I/O error on device md1, logical block 2181
[ 1424.705326] Buffer I/O error on device md1, logical block 2182
[ 1424.705332] Buffer I/O error on device md1, logical block 2183
[ 1424.705338] Buffer I/O error on device md1, logical block 2184
[ 1424.705344] Buffer I/O error on device md1, logical block 2185
[ 1424.705471] sd 0:0:1:0: [sdf] Unhandled error code
[ 1424.705475] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.705482] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 0c 00 00 04 00 00
[ 1424.705501] end_request: I/O error, dev sdf, sector 3072
[ 1424.705654] sd 0:0:1:0: [sdf] Unhandled error code
[ 1424.705659] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.705666] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 08 00 00 04 00 00
[ 1424.705684] end_request: I/O error, dev sdf, sector 2048
[ 1424.705829] sd 0:0:1:0: [sdf] Unhandled error code
[ 1424.705834] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.705841] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 07 58 00 00 a8 00
[ 1424.705860] end_request: I/O error, dev sdf, sector 1880
[ 1424.705903] sd 0:0:1:0: [sdf] Unhandled error code
[ 1424.705907] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.705914] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 03 58 00 04 00 00
[ 1424.705935] end_request: I/O error, dev sdf, sector 856
[ 1424.706110] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706115] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706122] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 11 10 00 02 f0 00
[ 1424.706144] end_request: I/O error, dev sde, sector 4368
[ 1424.706256] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706260] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706268] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 10 00 00 01 08 00
[ 1424.706286] end_request: I/O error, dev sde, sector 4096
[ 1424.706334] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706339] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706346] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 0d 18 00 02 e8 00
[ 1424.706364] end_request: I/O error, dev sde, sector 3352
[ 1424.706481] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706485] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706493] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 0d 10 00 00 08 00
[ 1424.706514] end_request: I/O error, dev sde, sector 3344
[ 1424.706534] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706539] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706547] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 09 e0 00 03 28 00
[ 1424.706565] end_request: I/O error, dev sde, sector 2528
[ 1424.706689] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706694] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706701] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 08 90 00 00 78 00
[ 1424.706719] end_request: I/O error, dev sde, sector 2192
[ 1424.706762] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706767] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706774] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 04 08 00 04 00 00
[ 1424.706792] end_request: I/O error, dev sde, sector 1032
[ 1424.706941] sd 0:0:0:0: [sde] Unhandled error code
[ 1424.706946] sd 0:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.706954] sd 0:0:0:0: [sde] CDB: Read(10): 28 00 00 00 04 00 00 00 08 00
[ 1424.706974] end_request: I/O error, dev sde, sector 1024
[ 1424.706999] sd 0:0:2:0: [sdg] Unhandled error code
[ 1424.707019] sd 0:0:2:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707026] sd 0:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 0c 08 00 03 f8 00
[ 1424.707045] end_request: I/O error, dev sdg, sector 3080
[ 1424.707191] sd 0:0:2:0: [sdg] Unhandled error code
[ 1424.707195] sd 0:0:2:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707202] sd 0:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 0c 00 00 00 08 00
[ 1424.707221] end_request: I/O error, dev sdg, sector 3072
[ 1424.707241] sd 0:0:2:0: [sdg] Unhandled error code
[ 1424.707246] sd 0:0:2:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707253] sd 0:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 08 00 00 04 00 00
[ 1424.707274] end_request: I/O error, dev sdg, sector 2048
[ 1424.707434] sd 0:0:2:0: [sdg] Unhandled error code
[ 1424.707439] sd 0:0:2:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707446] sd 0:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 04 00 00 04 00 00
[ 1424.707464] end_request: I/O error, dev sdg, sector 1024
[ 1424.707630] sd 0:0:2:0: [sdg] Unhandled error code
[ 1424.707634] sd 0:0:2:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707642] sd 0:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 00 00 00 04 00 00
[ 1424.707660] end_request: I/O error, dev sdg, sector 0
[ 1424.707824] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.707829] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707836] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 0f 18 00 00 e8 00
[ 1424.707855] end_request: I/O error, dev sdh, sector 3864
[ 1424.707907] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.707912] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.707919] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 0c 08 00 03 10 00
[ 1424.707937] end_request: I/O error, dev sdh, sector 3080
[ 1424.708055] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.708060] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.708067] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 0c 00 00 00 08 00
[ 1424.708085] end_request: I/O error, dev sdh, sector 3072
[ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 00 00 04 00 00
[ 1424.708137] end_request: I/O error, dev sdh, sector 2048
[ 1424.708304] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.708308] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.708315] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 04 00 00 04 00 00
[ 1424.708334] end_request: I/O error, dev sdh, sector 1024
[ 1424.708495] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.708499] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1424.708507] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 00 00 00 04 00 00
[ 1424.708525] end_request: I/O error, dev sdh, sector 0
[ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1485.704076] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1485.704085] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1516.704142] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1516.704145] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1547.704191] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1547.704200] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1578.704212] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1578.704221] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1609.702034] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1609.702037] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1609.702049] sd 0:0:1:0: [sdf] Unhandled error code
[ 1609.702052] sd 0:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1609.702055] sd 0:0:1:0: [sdf] CDB: Read(10): 28 00 00 00 03 58 00 00 08 00
[ 1609.702062] end_request: I/O error, dev sdf, sector 856
[ 1609.702065] __ratelimit: 1991 callbacks suppressed
[ 1609.702067] Buffer I/O error on device md1, logical block 235

--Boundary-00=_IhlsKESfl/croZf--

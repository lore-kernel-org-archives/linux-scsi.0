From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Tue, 15 Sep 2009 10:20:40 -0600
Message-ID: <200909151020.40205.tfjellstrom@shaw.ca>
References: <200909090414.41274.tfjellstrom@shaw.ca> <4AAC4022.4040805@garzik.org> <200909122256.50474.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Y77rK251rKJN8kV"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200909122256.50474.tfjellstrom@shaw.ca>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_Y77rK251rKJN8kV
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Sat September 12 2009, Thomas Fjellstrom wrote:
> On Sat September 12 2009, Jeff Garzik wrote:
> > On 09/10/2009 07:55 PM, Thomas Fjellstrom wrote:
> > > On Wed September 9 2009, Thomas Fjellstrom wrote:
> > >> On Wed September 9 2009, Thomas Fjellstrom wrote:
> > >>> On Wed September 9 2009, Jeff Garzik wrote:
> > >>>> On 09/09/2009 12:30 PM, Thomas Fjellstrom wrote:
> > >>>>> No errors on that disk. Other than the one above, and its more of a
> > >>>>> warning. However, I just rebooted to add some extra drives,
> > >>>>> thinking everything was working a little better now that I've
> > >>>>> updated to 2.6.31-rc9, I'm treated to the following two messages
> > >>>>> right after boot (and a system lockup to boot):
> > >>>>>
> > >>>>> kernel: [  971.033138] ------------[ cut here ]------------
> > >>>>> kernel: [  971.033211] WARNING: at drivers/ata/libata-core.c:4913
> > >>>>> __ata_qc_complete+0x5a/0xe1 [libata]()
> > >>>>> kernel: [  971.033217] Hardware name: GA-MA790FXT-UD5P
> > >>>>> kernel: [  971.033221] Modules linked in: powernow_k8
> > >>>>> cpufreq_conservative cpufreq_stats cpufreq_userspace
> > >>>>> cpufreq_powersave kvm_amd kvm nfsd exportfs nfs lockd fscache
> > >>>>> nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid adt7473
> > >>>>> firewire_sbp2 loop md_mod
> > >>>>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
> > >>>>> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi
> > >>>>> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
> > >>>>> amd64_edac_mod edac_core i2c_piix4 soundcore snd_page_alloc
> > >>>>> i2c_core evdev wmi parport_pc button parport processor ext3 jbd
> > >>>>> mbcache dm_mod sg sr_mod cdrom sd_mod crc_t10dif usbhid ata_generic
> > >>>>> ide_pci_generic hid mvsas firewire_ohci libsas firewire_core
> > >>>>> crc_itu_t
> > >>>>> scsi_transport_sas r8169 atiixp ide_core floppy ahci mii ohci_hcd
> > >>>>> libata ehci_hcd scsi_mod thermal fan thermal_sys [last unloaded:
> > >>>>> scsi_wait_scan]
> > >>>>> kernel: [  971.033337] Pid: 0, comm: swapper Not tainted 2.6.31-rc9
> > >>>>> #2 kernel: [  971.033342] Call Trace:
> > >>>>> kernel: [  971.033346]<IRQ>    [<ffffffffa00562ca>] ?
> > >>>>> __ata_qc_complete+0x5a/0xe1 [libata]
> > >>>>> kernel: [  971.033434]  [<ffffffffa00562ca>] ?
> > >>>>> __ata_qc_complete+0x5a/0xe1 [libata]
> > >>>>> kernel: [  971.033446]  [<ffffffff8104aca0>] ?
> > >>>>> warn_slowpath_common+0x77/0xa3 kernel: [  971.033455]
> > >>>>> [<ffffffff81038d06>] ? enqueue_task+0x5c/0x65 kernel: [ 
> > >>>>> 971.033496] [<ffffffffa00562ca>] ? __ata_qc_complete+0x5a/0xe1
> > >>>>> [libata] kernel: [  971.033519]  [<ffffffffa00f7b59>] ?
> > >>>>> sas_ata_task_done+0x178/0x210 [libsas]
> > >>>>> kernel: [  971.033528]  [<ffffffff8115ead1>] ?
> > >>>>> blk_run_queue+0x21/0x35 kernel: [  971.033548] 
> > >>>>> [<ffffffffa010e2ce>] ?
> > >>>>> mvs_slot_complete+0x3df/0x41b [mvsas]
> > >>>>> kernel: [  971.033565]  [<ffffffffa010e39c>] ?
> > >>>>> mvs_int_rx+0x92/0x101 [mvsas] kernel: [  971.033583] 
> > >>>>> [<ffffffffa01112ba>] ?
> > >>>>> mvs_int_full+0x25/0x88 [mvsas] kernel: [  971.033600]
> > >>>>> [<ffffffffa011134e>] ? mvs_64xx_isr+0x31/0x40 [mvsas] kernel: [
> > >>>>> 971.033617]  [<ffffffffa010d0e5>] ? mvs_interrupt+0x61/0x78 [mvsas]
> > >>>>> kernel: [  971.033625]  [<ffffffff8108aaac>] ?
> > >>>>> handle_IRQ_event+0x58/0x135 kernel: [  971.033633]
> > >>>>> [<ffffffff8108c1a1>] ? handle_fasteoi_irq+0x7d/0xb5 kernel: [
> > >>>>> 971.033642]
> > >>>>> [<ffffffff8101388d>] ? handle_irq+0x17/0x1d
> > >>>>
> > >>>> That warning is triggered when an ata_queued_cmd is passed to
> > >>>> completion without the ATA_QCFLAG_ACTIVE flag being set (which
> > >>>> indicates the qc was started with some activity).
> > >>>>
> > >>>> That possibly indicates the low-level driver (or libsas) was passing
> > >>>> an already-completed cmd to libata.
> > >>>>
> > >>>>> The added hard drives are connected to a Supermicro AOC-SASLP-MV8,
> > >>>>> which is based on a marvel MV64460/64461/64462 chipset, which uses
> > >>>>> the sata_mv driver.
> > >>>>
> > >>>> Surely you mean 'mvsas' driver?
> > >>>
> > >>> Yes, sorry I did mean mvsas.
> > >>>
> > >>> I am more concerned about the actual oops/BUG rather than the warning
> > >>>   though. Unless the problem causing the warning is also causing the
> > >>> oops.
> > >>>
> > >>>> 	Jeff
> > >>
> > >> Thanks for taking a look so far. But I'm having more and more trouble
> > >> with this card as the days go by:
> > >>
> > >> [  464.792214] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  464.792222] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  494.816170] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  494.816179] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  494.816192] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  494.816197] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  525.817335] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  525.817343] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  525.817358] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  525.817363] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  556.816148] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  556.816157] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  556.816170] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  556.816175] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  587.816171] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  587.816179] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  587.816193] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  587.816199] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  600.616255] INFO: task mount:4395 blocked for more than 120
> > >> seconds. [  600.616263] "echo 0> 
> > >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > >> [  600.616270] mount         D 0000000000000000     0  4395   4229
> > >>   0x00000000 [  600.616281]  ffff88012fb6f780 0000000000000082
> > >>   ffff8800b808ddc8 ffff8800b80f3d60
> > >> [  600.616290]  ffff880128923c90 0000000000014800 000000000000f800
> > >> ffff88012dd91840
> > >> [  600.616299]  ffff88012dd91b38 0000000300000008 0000000000000000
> > >> ffff88010c5bfa88
> > >> [  600.616308] Call Trace:
> > >> [  600.616324]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
> > >> [  600.616335]  [<ffffffff810adc63>] ? __pagevec_free+0x29/0x3b
> > >> [  600.616343]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
> > >> [  600.616351]  [<ffffffff810a8e69>] ? sync_page+0x0/0x46
> > >> [  600.616361]  [<ffffffff812dc8cb>] ? io_schedule+0x63/0xa5
> > >> [  600.616368]  [<ffffffff810a8eaa>] ? sync_page+0x41/0x46
> > >> [  600.616376]  [<ffffffff812dcade>] ? __wait_on_bit_lock+0x3f/0x84
> > >> [  600.616383]  [<ffffffff810a8e55>] ? __lock_page+0x5d/0x63
> > >> [  600.616391]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
> > >> [  600.616401]  [<ffffffff810b0ad4>] ? pagevec_lookup+0x17/0x1e
> > >> [  600.616408]  [<ffffffff810b1bbd>] ?
> > >>   truncate_inode_pages_range+0x288/0x318 [  600.616418]
> > >>   [<ffffffff810fc8cb>] ? set_blocksize+0xc2/0xd2
> > >> [  600.616426]  [<ffffffff810fc8f2>] ? sb_set_blocksize+0x17/0x43
> > >> [  600.616477]  [<ffffffffa04aa8e0>] ? ext4_fill_super+0x1cc/0x2060
> > >> [ext4] [  600.616486]  [<ffffffff8117593b>] ? snprintf+0x44/0x4c
> > >> [  600.616493]  [<ffffffff810fb5b7>] ? check_disk_change+0x22/0x52
> > >> [  600.616501]  [<ffffffff812dd680>] ? __down_write_nested+0x15/0xab
> > >> [  600.616524]  [<ffffffff810dbfe6>] ? get_sb_bdev+0x111/0x159
> > >> [  600.616571]  [<ffffffffa04aa714>] ? ext4_fill_super+0x0/0x2060
> > >> [ext4] [  600.616582]  [<ffffffff810dbc44>] ?
> > >> vfs_kern_mount+0x95/0x111 [  600.616593]  [<ffffffff810dbd13>] ?
> > >> do_kern_mount+0x43/0xe2 [  600.616607]  [<ffffffff810ef49d>] ?
> > >> do_mount+0x767/0x7d6
> > >> [  600.616620]  [<ffffffff810ef591>] ? sys_mount+0x85/0xc8
> > >> [  600.616633]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
> > >> [  618.816175] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  618.816184] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  618.816196] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  618.816201] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  618.816241] sd 1:0:3:0: [sdf] Unhandled error code
> > >> [  618.816247] sd 1:0:3:0: [sdf] Result: hostbyte=DID_OK
> > >> driverbyte=DRIVER_TIMEOUT
> > >> [  618.816255] end_request: I/O error, dev sdf, sector 160
> > >> [  618.816263] Buffer I/O error on device md2, logical block 20
> > >> [  618.816274] Buffer I/O error on device md2, logical block 21
> > >> [  618.816280] Buffer I/O error on device md2, logical block 22
> > >> [  618.816285] Buffer I/O error on device md2, logical block 23
> > >> [  618.816291] Buffer I/O error on device md2, logical block 24
> > >> [  618.816298] Buffer I/O error on device md2, logical block 25
> > >> [  618.816307] Buffer I/O error on device md2, logical block 26
> > >> [  618.816316] Buffer I/O error on device md2, logical block 27
> > >> [  618.816324] Buffer I/O error on device md2, logical block 28
> > >> [  618.816331] Buffer I/O error on device md2, logical block 29
> > >> [  649.780185] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  649.780194] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  649.780208] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  649.780214] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  649.780293] ------------[ cut here ]------------
> > >> [  649.780366] WARNING: at drivers/ata/libata-core.c:5129
> > >> ata_qc_issue+0x10a/0x347 [libata]()
> > >> [  649.780373] Hardware name: GA-MA790FXT-UD5P
> > >> [  649.780377] Modules linked in: ext4 jbd2 crc16 raid0 powernow_k8
> > >> cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave
> > >>   kvm_amd kvm nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss
> > >> sunrpc bridge stp it87 hwmon_vid adt7473 firewire_sbp2 loop md_mod
> > >> snd_hda_codec_realtek
> > >> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> > >> snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event amd64_edac_mod
> > >> snd_seq edac_core snd_timer snd_seq_device snd soundcore i2c_piix4
> > >> snd_page_alloc i2c_core evdev parport_pc wmi parport button processor
> > >> ext3 jbd mbcache dm_mod usbhid hid sg sr_mod cdrom sd_mod crc_t10dif
> > >> ata_generic ide_pci_generic firewire_ohci firewire_core ohci_hcd
> > >> crc_itu_t atiixp ide_core mvsas ehci_hcd ahci libsas libata
> > >> scsi_transport_sas scsi_mod r8169 mii floppy thermal fan thermal_sys
> > >> [last unloaded: scsi_wait_scan] [  649.780499] Pid: 3185, comm:
> > >> hddtemp Not tainted 2.6.31-rc9 #2 [  649.780504] Call Trace:
> > >> [  649.780551]  [<ffffffffa0074f90>] ? ata_qc_issue+0x10a/0x347
> > >> [libata] [  649.780593]  [<ffffffffa0074f90>] ?
> > >> ata_qc_issue+0x10a/0x347 [libata] [  649.780607]  [<ffffffff8104aca0>]
> > >> ? warn_slowpath_common+0x77/0xa3 [  649.780649]  [<ffffffffa00790ce>]
> > >> ? ata_scsi_pass_thru+0x0/0x240 [libata] [  649.780690] 
> > >> [<ffffffffa0074f90>] ?
> > >> ata_qc_issue+0x10a/0x347 [libata] [  649.780733]  [<ffffffffa00401d6>]
> > >> ? scsi_get_command+0x75/0x97 [scsi_mod] [  649.780776]
> > >> [<ffffffffa00790ce>] ?
> > >>   ata_scsi_pass_thru+0x0/0x240 [libata] [  649.780815]
> > >> [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod] [  649.780858]
> > >> [<ffffffffa007a4d5>] ? __ata_scsi_queuecmd+0x185/0x1dc [libata]
> > >> [  649.780896]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
> > >> [  649.780918]  [<ffffffffa00a3c8e>] ? sas_queuecommand+0x83/0x25d
> > >> [libsas] [  649.780956]  [<ffffffffa003fa7c>] ?
> > >> scsi_dispatch_cmd+0x1c0/0x23c [scsi_mod]
> > >> [  649.780996]  [<ffffffffa0044ff0>] ? scsi_request_fn+0x3a5/0x506
> > >>   [scsi_mod] [  649.781006]  [<ffffffff810546e0>] ?
> > >> del_timer+0x59/0x62 [  649.781016]  [<ffffffff81163b70>] ?
> > >> blk_execute_rq_nowait+0x65/0x89 [  649.781032]  [<ffffffffa014164f>] ?
> > >> sg_common_write+0x489/0x4ab [sg] [  649.781042]  [<ffffffff8115df56>]
> > >> ? __freed_request+0x26/0x83 [  649.781056]  [<ffffffffa01421da>] ?
> > >> sg_new_write+0x23e/0x269 [sg] [  649.781070]  [<ffffffffa0142473>] ?
> > >> sg_ioctl+0x26e/0xb63 [sg] [  649.781080]  [<ffffffff81100f38>] ?
> > >> inotify_d_instantiate+0x12/0x39 [  649.781088]  [<ffffffff8105eee6>] ?
> > >> autoremove_wake_function+0x0/0x2e [  649.781098]  [<ffffffff810d80bf>]
> > >> ? fd_install+0x2e/0x5a
> > >> [  649.781105]  [<ffffffff810e5247>] ? vfs_ioctl+0x56/0x6c
> > >> [  649.781111]  [<ffffffff810e570a>] ? do_vfs_ioctl+0x437/0x475
> > >> [  649.781118]  [<ffffffff810e5799>] ? sys_ioctl+0x51/0x70
> > >> [  649.781128]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
> > >> [  649.781134] ---[ end trace 9005373b1b9c6eb7 ]---
> > >> [  680.781672] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  680.781681] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  711.781672] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  711.781681] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  741.816069] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  741.816078] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  741.816090] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  741.816096] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  772.820160] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  772.820168] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  772.820181] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  772.820186] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  803.816212] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  803.816220] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  803.816233] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > >> [  803.816239] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > >> [  803.816264] sd 1:0:3:0: [sdf] Unhandled error code
> > >> [  803.816270] sd 1:0:3:0: [sdf] Result: hostbyte=DID_OK
> > >> driverbyte=DRIVER_TIMEOUT
> > >> [  803.816278] end_request: I/O error, dev sdf, sector 512
> > >> [  803.816284] __ratelimit: 70 callbacks suppressed
> > >> [  803.816290] Buffer I/O error on device md2, logical block 64
> > >>
> > >> That's after bringing up a raid0 array I build a few days ago on 4
> > >>   perfectly good (Seagate Baracuda 1TB 7200.12) disks, without the bad
> > >> disk plugged in. I try to mount it, and the driver hangs. Anything
> > >> trying to access any of the 4 disks hangs as well.
> > >>
> > >> I know this array worked a few days ago. The most major change I've
> > >> made was upgrade from -rc8 (or -rc5, not sure if I mounted the array
> > >> under -rc8) to -rc9.
> > >
> > > Hi, just wondering if anyone has had a chance to look at this, or if
> > > there's some patches I should try out, or if you need me to do some
> > > testing, I'd be glad to, thanks :)
> >
> > I was hoping that some VM would jump in.  The BUG in question is, from
> > mm/slab.c:
> >
> >                  /*
> >                   * The slab was either on partial or free list so
> >                   * there must be at least one object available for
> >                   * allocation.
> >                   */
> >                  BUG_ON(slabp->inuse >= cachep->num);
> >
> > So I wonder if that is a double-free, indicating a bug in
> > SCSI/libsas/mvsas, or a VM problem of some sort.
> >
> > Was free memory low on that machine, at that point, perchance?
> 
> Its remotely possible do to leaks in programs, but even konqueror and
>  firefox don't eat up memory _that_ fast, so its very unlikely. This
>  machine has 4G ram.
> 
> > 	Jeff
> >
> >

Ok, I've managed to figure out one of my problems, the WD drive[s] don't much 
like hddtemp and smartmon running all the time. I disabled them and ran a long 
read test on the drives on a different controller, and they work fine.

Things however are not so rosy, trying to do anything with the Marvell based 
SAS card causes errors.

I've attached the dmesg log from a fresh boot of 2.6.31-git4 (with the edac 
amd patch applied).

I suspect somehow the card isn't initializing things right, as the "Activity" 
lights on my hotswap bays are on for the two Seagate Baracuda drives, not on 
full, but on none the less.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

--Boundary-00=_Y77rK251rKJN8kV
Content-Type: text/plain;
  charset="UTF-8";
  name="mvsas.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mvsas.dmesg"

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
[    0.000000] Detected 2611.762 MHz processor.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000]   alloc irq_desc for 24 on node 0
[    0.000000]   alloc kstat_irqs on node 0
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.001999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5223.51 BogoMIPS (lpj=2611758)
[    0.001999] Security Framework initialized
[    0.001999] SELinux:  Disabled at boot.
[    0.001999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002842] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003447] Mount-cache hash table entries: 256
[    0.003611] Initializing cgroup subsys ns
[    0.003666] Initializing cgroup subsys cpuacct
[    0.003722] Initializing cgroup subsys devices
[    0.003777] Initializing cgroup subsys freezer
[    0.003832] Initializing cgroup subsys net_cls
[    0.003906] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003964] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004002] CPU 0/0x0 -> Node 0
[    0.004057] tseg: 00cfe00000
[    0.004058] CPU: Physical Processor ID: 0
[    0.004112] CPU: Processor Core ID: 0
[    0.004167] mce: CPU supports 6 MCE banks
[    0.004227] using C1E aware idle routine
[    0.004281] Performance Counters: AMD PMU driver.
[    0.004378] ... version:                 0
[    0.004432] ... bit width:               48
[    0.004486] ... generic counters:        4
[    0.004541] ... value mask:              0000ffffffffffff
[    0.004596] ... max period:              00007fffffffffff
[    0.004651] ... fixed-purpose counters:  0
[    0.004705] ... counter mask:            000000000000000f
[    0.005328] ACPI: Core revision 20090521
[    0.014065] Setting APIC routing to flat
[    0.015425] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025489] CPU0: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.025996] System has AMD C1E enabled
[    0.025996] Switch to broadcast mode on CPU0
[    0.026133] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611892)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 1/0x1 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.097668] CPU1: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.098084] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.099005] Switch to broadcast mode on CPU1
[    0.099059] Booting processor 2 APIC 0x2 ip 0x6000
[    0.001999] Initializing CPU#2
[    0.001999] Calibrating delay using timer specific routine.. 5223.79 BogoMIPS (lpj=2611895)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 2/0x2 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 3
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.170738] CPU2: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.171077] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.171993] Switch to broadcast mode on CPU2
[    0.172052] Booting processor 3 APIC 0x3 ip 0x6000
[    0.001999] Initializing CPU#3
[    0.001999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611890)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 3/0x3 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 2
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.243720] CPU3: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.244066] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.244984] Brought up 4 CPUs
[    0.244983] Switch to broadcast mode on CPU3
[    0.245091] Total of 4 processors activated (20894.87 BogoMIPS).
[    0.245254] CPU0 attaching sched-domain:
[    0.245256]  domain 0: span 0-3 level MC
[    0.245258]   groups: 0 1 2 3
[    0.245263]   domain 1: span 0-3 level NODE
[    0.245264]    groups: 0-3 (cpu_power = 4096)
[    0.245269] CPU1 attaching sched-domain:
[    0.245270]  domain 0: span 0-3 level MC
[    0.245272]   groups: 1 2 3 0
[    0.245276]   domain 1: span 0-3 level NODE
[    0.245277]    groups: 0-3 (cpu_power = 4096)
[    0.245281] CPU2 attaching sched-domain:
[    0.245282]  domain 0: span 0-3 level MC
[    0.245284]   groups: 2 3 0 1
[    0.245288]   domain 1: span 0-3 level NODE
[    0.245289]    groups: 0-3 (cpu_power = 4096)
[    0.245293] CPU3 attaching sched-domain:
[    0.245294]  domain 0: span 0-3 level MC
[    0.245296]   groups: 3 0 1 2
[    0.245299]   domain 1: span 0-3 level NODE
[    0.245301]    groups: 0-3 (cpu_power = 4096)
[    0.246027] Booting paravirtualized kernel on bare hardware
[    0.246159] regulator: core version 0.5
[    0.246159] NET: Registered protocol family 16
[    0.246159] node 0 link 0: io port [a000, ffff]
[    0.246159] TOM: 00000000d0000000 aka 3328M
[    0.246159] Fam 10h mmconf [e0000000, e00fffff]
[    0.246159] node 0 link 0: mmio [a0000, bffff]
[    0.246159] node 0 link 0: mmio [d0000000, dfffffff]
[    0.246159] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.246159] node 0 link 0: mmio [e0000000, e05fffff] ==> [e0100000, e05fffff]
[    0.246159] TOM2: 0000000130000000 aka 4864M
[    0.246965] bus: [00,05] on node 0 link 0
[    0.246966] bus: 00 index 0 io port: [0, ffff]
[    0.246968] bus: 00 index 1 mmio: [a0000, bffff]
[    0.246970] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.246971] bus: 00 index 3 mmio: [e0600000, ffffffff]
[    0.246973] bus: 00 index 4 mmio: [e0100000, e05fffff]
[    0.246975] bus: 00 index 5 mmio: [130000000, fcffffffff]
[    0.246984] ACPI: bus type pci registered
[    0.247047] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.247047] PCI: MCFG area at e0000000 reserved in E820
[    0.258636] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.258692] PCI: Using configuration type 1 for base access
[    0.260076] bio: create slab <bio-0> at 0
[    0.261155] ACPI: EC: Look up EC in DSDT
[    0.267647] ACPI: Interpreter enabled
[    0.267704] ACPI: (supports S0 S3 S4 S5)
[    0.268034] ACPI: Using IOAPIC for interrupt routing
[    0.273201] ACPI: No dock devices found.
[    0.273301] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.273978] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.274023] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.274080] pci 0000:00:02.0: PME# disabled
[    0.274164] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.274221] pci 0000:00:07.0: PME# disabled
[    0.274302] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.274358] pci 0000:00:09.0: PME# disabled
[    0.274438] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.274495] pci 0000:00:0b.0: PME# disabled
[    0.274549] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.274549] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.274549] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.274549] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.274549] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.274549] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.274549] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.274549] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.274549] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.274549] pci 0000:00:12.2: supports D1 D2
[    0.274549] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.274549] pci 0000:00:12.2: PME# disabled
[    0.274549] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.274549] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.274549] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.274561] pci 0000:00:13.2: supports D1 D2
[    0.274563] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.274621] pci 0000:00:13.2: PME# disabled
[    0.274781] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.274788] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.274794] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.274800] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.274806] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.274866] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.274906] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.274962] pci 0000:00:14.2: PME# disabled
[    0.275112] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.275239] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.275247] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.275254] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.275259] pci 0000:01:00.0: reg 24 io port: [0xcf00-0xcf7f]
[    0.275264] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275329] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.275331] pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.275335] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.275366] pci 0000:02:00.0: reg 10 io port: [0xbe00-0xbeff]
[    0.275380] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdbff000-0xfdbfffff]
[    0.275389] pci 0000:02:00.0: reg 20 64bit mmio: [0xfdbf8000-0xfdbfbfff]
[    0.275395] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275422] pci 0000:02:00.0: supports D1 D2
[    0.275424] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275482] pci 0000:02:00.0: PME# disabled
[    0.275590] pci 0000:00:07.0: bridge io port: [0xb000-0xbfff]
[    0.275593] pci 0000:00:07.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.275596] pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
[    0.275628] pci 0000:03:00.0: reg 10 io port: [0xee00-0xeeff]
[    0.275642] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdfff000-0xfdffffff]
[    0.275653] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff8000-0xfdffbfff]
[    0.275659] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275687] pci 0000:03:00.0: supports D1 D2
[    0.275688] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275747] pci 0000:03:00.0: PME# disabled
[    0.275855] pci 0000:00:09.0: bridge io port: [0xe000-0xefff]
[    0.275857] pci 0000:00:09.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
[    0.275861] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.275896] pci 0000:04:00.0: reg 18 io port: [0xdf00-0xdf7f]
[    0.275908] pci 0000:04:00.0: reg 20 64bit mmio: [0xfdef0000-0xfdefffff]
[    0.275913] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x03ffff]
[    0.275976] pci 0000:04:00.0: supports D1
[    0.275978] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.276036] pci 0000:04:00.0: PME# disabled
[    0.276136] pci 0000:00:0b.0: bridge io port: [0xd000-0xdfff]
[    0.276139] pci 0000:00:0b.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.276142] pci 0000:00:0b.0: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.276205] pci 0000:05:0e.0: reg 10 32bit mmio: [0xfdaff000-0xfdaff7ff]
[    0.276214] pci 0000:05:0e.0: reg 14 32bit mmio: [0xfdaf8000-0xfdafbfff]
[    0.276269] pci 0000:05:0e.0: supports D1 D2
[    0.276270] pci 0000:05:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.276329] pci 0000:05:0e.0: PME# disabled
[    0.276415] pci 0000:00:14.4: transparent bridge
[    0.276472] pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
[    0.276476] pci 0000:00:14.4: bridge 32bit mmio: [0xfda00000-0xfdafffff]
[    0.276481] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd900000-0xfd9fffff]
[    0.276496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.276747] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.276822] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.276875] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.276920] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.276969] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
[    0.298384] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.298433] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.299045] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.299639] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.300254] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.300847] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.301461] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.302045] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.303720] usbcore: registered new interface driver usbfs
[    0.303720] usbcore: registered new interface driver hub
[    0.304048] usbcore: registered new device driver usb
[    0.304054] PCI: Using ACPI for IRQ routing
[    0.304054] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.304083] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.304224] PCI-DMA: Disabling AGP.
[    0.304224] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.304224] PCI-DMA: using GART IOMMU.
[    0.304224] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.305518] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.305784] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.307992] hpet: hpet2 irq 24 for MSI
[    0.311712] pnp: PnP ACPI init
[    0.311778] ACPI: bus type pnp registered
[    0.314656] pnp 00:0d: mem resource (0xd6c00-0xd7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.314725] pnp 00:0d: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.314794] pnp 00:0d: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.314863] pnp 00:0d: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.314932] pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315008] pnp 00:0d: mem resource (0x100000-0xcfddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.315197] pnp: PnP ACPI: found 14 devices
[    0.315251] ACPI: ACPI bus type pnp unregistered
[    0.315313] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.315370] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.315427] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.315486] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.315544] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.315601] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.315658] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.315715] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.315772] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.315829] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.315887] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.315944] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.316009] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.316066] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.316124] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.316181] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.316238] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.316295] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.316352] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.316409] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.316471] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.316531] system 00:0d: iomem range 0xcfde0000-0xcfdfffff could not be reserved
[    0.316598] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.316656] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.316723] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.316781] system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.321911] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.321976] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.322037] pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
[    0.322095] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.322163] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.322219] pci 0000:00:07.0:   IO window: 0xb000-0xbfff
[    0.322276] pci 0000:00:07.0:   MEM window: 0xfdc00000-0xfdcfffff
[    0.322333] pci 0000:00:07.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.322401] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.322457] pci 0000:00:09.0:   IO window: 0xe000-0xefff
[    0.322514] pci 0000:00:09.0:   MEM window: 0xfd800000-0xfd8fffff
[    0.322571] pci 0000:00:09.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.322638] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    0.322695] pci 0000:00:0b.0:   IO window: 0xd000-0xdfff
[    0.322751] pci 0000:00:0b.0:   MEM window: 0xfde00000-0xfdefffff
[    0.322808] pci 0000:00:0b.0:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
[    0.322875] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.322932] pci 0000:00:14.4:   IO window: 0xa000-0xafff
[    0.322998] pci 0000:00:14.4:   MEM window: 0xfda00000-0xfdafffff
[    0.323057] pci 0000:00:14.4:   PREFETCH window: 0xfd900000-0xfd9fffff
[    0.323119]   alloc irq_desc for 18 on node 0
[    0.323121]   alloc kstat_irqs on node 0
[    0.323129] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.323187] pci 0000:00:02.0: setting latency timer to 64
[    0.323191]   alloc irq_desc for 19 on node 0
[    0.323193]   alloc kstat_irqs on node 0
[    0.323199] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.323257] pci 0000:00:07.0: setting latency timer to 64
[    0.323261]   alloc irq_desc for 17 on node 0
[    0.323262]   alloc kstat_irqs on node 0
[    0.323269] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.323327] pci 0000:00:09.0: setting latency timer to 64
[    0.323331] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.323388] pci 0000:00:0b.0: setting latency timer to 64
[    0.323395] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.323397] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.323400] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.323402] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
[    0.323404] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.323406] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.323408] pci_bus 0000:02: resource 1 mem: [0xfdc00000-0xfdcfffff]
[    0.323410] pci_bus 0000:02: resource 2 pref mem [0xfdb00000-0xfdbfffff]
[    0.323412] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.323414] pci_bus 0000:03: resource 1 mem: [0xfd800000-0xfd8fffff]
[    0.323416] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.323418] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.323420] pci_bus 0000:04: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.323422] pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
[    0.323424] pci_bus 0000:05: resource 0 io:  [0xa000-0xafff]
[    0.323426] pci_bus 0000:05: resource 1 mem: [0xfda00000-0xfdafffff]
[    0.323428] pci_bus 0000:05: resource 2 pref mem [0xfd900000-0xfd9fffff]
[    0.323430] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.323431] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.323520] NET: Registered protocol family 2
[    0.323721] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.324722] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.326995] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.327312] TCP: Hash tables configured (established 524288 bind 65536)
[    0.327369] TCP reno registered
[    0.327556] NET: Registered protocol family 1
[    0.327655] Trying to unpack rootfs image as initramfs...
[    0.487166] Freeing initrd memory: 9221k freed
[    0.491042] audit: initializing netlink socket (disabled)
[    0.491108] type=2000 audit(1253029919.490:1): initialized
[    0.491448] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.491662] VFS: Disk quotas dquot_6.5.2
[    0.491748] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.491848] msgmni has been set to 7929
[    0.492141] alg: No test for stdrng (krng)
[    0.492250] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.492317] io scheduler noop registered
[    0.492371] io scheduler anticipatory registered
[    0.492426] io scheduler deadline registered
[    0.492501] io scheduler cfq registered (default)
[    0.511061] Switched to high resolution mode on CPU 2
[    0.511063] Switched to high resolution mode on CPU 3
[    0.511066] Switched to high resolution mode on CPU 1
[    0.523825] Switched to high resolution mode on CPU 0
[    0.573318] pci 0000:01:00.0: Boot video device
[    0.573476]   alloc irq_desc for 25 on node 0
[    0.573478]   alloc kstat_irqs on node 0
[    0.573486] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.573491] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.573649]   alloc irq_desc for 26 on node 0
[    0.573651]   alloc kstat_irqs on node 0
[    0.573655] pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
[    0.573659] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.573788]   alloc irq_desc for 27 on node 0
[    0.573789]   alloc kstat_irqs on node 0
[    0.573794] pcieport-driver 0000:00:09.0: irq 27 for MSI/MSI-X
[    0.573798] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.573935]   alloc irq_desc for 28 on node 0
[    0.573937]   alloc kstat_irqs on node 0
[    0.573941] pcieport-driver 0000:00:0b.0: irq 28 for MSI/MSI-X
[    0.573944] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.577018] Linux agpgart interface v0.103
[    0.581391] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.581590] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.582034] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.583735] brd: module loaded
[    0.583856] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.584089] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.584151] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.584320] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.584558] mice: PS/2 mouse device common for all mice
[    0.584668] rtc_cmos 00:05: RTC can wake from S4
[    0.584766] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.584852] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.584939] cpuidle: using governor ladder
[    0.584993] cpuidle: using governor menu
[    0.585051] No iBFT detected.
[    0.585403] TCP cubic registered
[    0.585519] NET: Registered protocol family 10
[    0.585985] lo: Disabled Privacy Extensions
[    0.586321] Mobile IPv6
[    0.586375] NET: Registered protocol family 17
[    0.586573] registered taskstats version 1
[    0.586785] rtc_cmos 00:05: setting system clock to 2009-09-15 15:52:00 UTC (1253029920)
[    0.586891] Freeing unused kernel memory: 592k freed
[    0.587083] Write protecting the kernel read-only data: 4108k
[    0.627289] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.712011] SCSI subsystem initialized
[    0.747656] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.748451] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.748541] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.748658] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.748748] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    0.748829] ehci_hcd 0000:00:12.2: debug port 1
[    0.748906] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    0.750170] libata version 3.00 loaded.
[    0.753601] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.753679] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.753778] r8169 0000:02:00.0: setting latency timer to 64
[    0.753810]   alloc irq_desc for 29 on node 0
[    0.753812]   alloc kstat_irqs on node 0
[    0.753824] r8169 0000:02:00.0: irq 29 for MSI/MSI-X
[    0.754347] eth0: RTL8168d/8111d at 0xffffc9000065c000, 00:24:1d:18:f8:b2, XID 081000c0 IRQ 29
[    0.756012] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.756087] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.756145] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.756211] usb usb1: Product: EHCI Host Controller
[    0.756266] usb usb1: Manufacturer: Linux 2.6.31-git4 ehci_hcd
[    0.756323] usb usb1: SerialNumber: 0000:00:12.2
[    0.756428] usb usb1: configuration #1 chosen from 1 choice
[    0.756506] hub 1-0:1.0: USB hub found
[    0.756565] hub 1-0:1.0: 6 ports detected
[    0.757298] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.759808] ahci 0000:00:11.0: version 3.0
[    0.759823]   alloc irq_desc for 22 on node 0
[    0.759825]   alloc kstat_irqs on node 0
[    0.759835] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.760029] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.760098] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.760476] scsi0 : ahci
[    0.760625] scsi1 : ahci
[    0.760723] scsi2 : ahci
[    0.760815] scsi3 : ahci
[    0.760910] scsi4 : ahci
[    0.761001] scsi5 : ahci
[    0.761168] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    0.761235] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    0.761303] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 22
[    0.761371] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    0.761438] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    0.761505] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    0.763638] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.763709] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.763796] r8169 0000:03:00.0: setting latency timer to 64
[    0.763829]   alloc irq_desc for 30 on node 0
[    0.763831]   alloc kstat_irqs on node 0
[    0.763842] r8169 0000:03:00.0: irq 30 for MSI/MSI-X
[    0.764385] eth1: RTL8168d/8111d at 0xffffc9000063e000, 00:24:1d:18:f8:f3, XID 081000c0 IRQ 30
[    0.765675] Uniform Multi-Platform E-IDE driver
[    0.767168] Floppy drive(s): fd0 is 1.44M
[    0.768163] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.768247] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.768357] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.768445] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    0.768526] ehci_hcd 0000:00:13.2: debug port 1
[    0.768600] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    0.775123] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.775203] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.775264] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.775330] usb usb2: Product: EHCI Host Controller
[    0.775389] usb usb2: Manufacturer: Linux 2.6.31-git4 ehci_hcd
[    0.775445] usb usb2: SerialNumber: 0000:00:13.2
[    0.775548] usb usb2: configuration #1 chosen from 1 choice
[    0.775625] hub 2-0:1.0: USB hub found
[    0.775684] hub 2-0:1.0: 6 ports detected
[    0.775898]   alloc irq_desc for 16 on node 0
[    0.775900]   alloc kstat_irqs on node 0
[    0.775909] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.775993] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.776089] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.776190] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    0.782234] FDC 0 is a post-1991 82077
[    0.830158] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.830217] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.830283] usb usb3: Product: OHCI Host Controller
[    0.830338] usb usb3: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.830394] usb usb3: SerialNumber: 0000:00:12.0
[    0.830502] usb usb3: configuration #1 chosen from 1 choice
[    0.830581] hub 3-0:1.0: USB hub found
[    0.830643] hub 3-0:1.0: 3 ports detected
[    0.830810] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.830883] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.830975] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.831067] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    0.886133] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.886196] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.886265] usb usb4: Product: OHCI Host Controller
[    0.886320] usb usb4: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.886376] usb usb4: SerialNumber: 0000:00:12.1
[    0.886476] usb usb4: configuration #1 chosen from 1 choice
[    0.886555] hub 4-0:1.0: USB hub found
[    0.886615] hub 4-0:1.0: 3 ports detected
[    0.886761] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.886831] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.886914] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.887017] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    0.941149] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.941210] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.941275] usb usb5: Product: OHCI Host Controller
[    0.941330] usb usb5: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.941386] usb usb5: SerialNumber: 0000:00:13.0
[    0.941473] usb usb5: configuration #1 chosen from 1 choice
[    0.941547] hub 5-0:1.0: USB hub found
[    0.941607] hub 5-0:1.0: 3 ports detected
[    0.941759] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.941824] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.941905] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.941990] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    0.997152] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.997214] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.997280] usb usb6: Product: OHCI Host Controller
[    0.997335] usb usb6: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.997390] usb usb6: SerialNumber: 0000:00:13.1
[    0.997485] usb usb6: configuration #1 chosen from 1 choice
[    0.997562] hub 6-0:1.0: USB hub found
[    0.997623] hub 6-0:1.0: 3 ports detected
[    0.997780] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.997852] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.997938] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.998029] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.053150] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.053208] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.053274] usb usb7: Product: OHCI Host Controller
[    1.053329] usb usb7: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.053385] usb usb7: SerialNumber: 0000:00:14.5
[    1.053489] usb usb7: configuration #1 chosen from 1 choice
[    1.053567] hub 7-0:1.0: USB hub found
[    1.053628] hub 7-0:1.0: 2 ports detected
[    1.068332] ata4: SATA link down (SStatus 0 SControl 300)
[    1.068431] ata5: SATA link down (SStatus 0 SControl 300)
[    1.068441] ata6: SATA link down (SStatus 0 SControl 300)
[    1.221144] ata1: softreset failed (device not ready)
[    1.221202] ata1: applying SB600 PMP SRST workaround and retrying
[    1.222037] ata2: softreset failed (device not ready)
[    1.222040] ata2: applying SB600 PMP SRST workaround and retrying
[    1.258138] usb 3-3: new low speed USB device using ohci_hcd and address 2
[    1.375141] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.378131] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.378780] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    1.378839] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.379654] ata1.00: configured for UDMA/133
[    1.390200] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    1.402294] ata2.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    1.402351] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.408324] usb 3-3: New USB device found, idVendor=046d, idProduct=c01d
[    1.408382] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.408439] usb 3-3: Product: USB-PS/2 Optical Mouse
[    1.408494] usb 3-3: Manufacturer: Logitech
[    1.408601] usb 3-3: configuration #1 chosen from 1 choice
[    1.442033] ata2.00: configured for UDMA/133
[    1.453166] scsi 1:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    1.639133] ata3: softreset failed (device not ready)
[    1.639190] ata3: applying SB600 PMP SRST workaround and retrying
[    1.792129] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.793403] ata3.00: ATAPI: PIONEER DVD-RW  DVR-212D, 1.21, max UDMA/66
[    1.795117] ata3.00: configured for UDMA/66
[    1.817918] scsi 2:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212D 1.21 PQ: 0 ANSI: 5
[    1.822691] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    1.822760] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.822841] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    1.822902]     ide0: BM-DMA at 0xfa00-0xfa07
[    1.822972] atiixp 0000:00:14.1: simplex device: DMA disabled
[    1.823038] ide1: DMA disabled
[    1.823101] Probing IDE interface ide0...
[    1.829383] sd 0:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.829483] sd 0:0:0:0: [sda] Write Protect is off
[    1.829539] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.829554] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.829710]  sda: sda2
[    1.830446] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.830988] sd 1:0:0:0: [sdb] Write Protect is off
[    1.831048] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.831064] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.831219]  sdb:
[    1.831426] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.835786] firewire_ohci 0000:05:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.835923] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[    1.835985] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.836059] mvsas 0000:04:00.0: setting latency timer to 64
[    1.839732] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    1.849066]  sdb1 sdb2 sdb3 sdb4
[    1.875571] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.879772] usbcore: registered new interface driver hiddev
[    1.884413] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input2
[    1.884530] generic-usb 0003:046D:C01D.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-3/input0
[    1.884629] usbcore: registered new interface driver usbhid
[    1.884686] usbhid: v2.6:USB HID core driver
[    1.893059] firewire_ohci: Added fw-ohci device 0000:05:0e.0, OHCI version 1.10
[    1.896569] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    1.896629] Uniform CD-ROM driver Revision: 3.20
[    1.896766] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.901509] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.901587] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.901662] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    2.342138] Probing IDE interface ide1...
[    2.345142] ide1: no devices on the port
[    2.345240] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.345387] ide1 at 0x170-0x177,0x376 on irq 15
[    2.392087] firewire_core: created device fw0: GUID 001a9c2c0000241d, S400
[    6.219153] drivers/scsi/mvsas/mv_sas.c 1214:port 0 attach dev info is 2040400
[    6.219156] drivers/scsi/mvsas/mv_sas.c 1216:port 0 attach sas addr is 0
[    6.420147] drivers/scsi/mvsas/mv_sas.c 1214:port 1 attach dev info is 40000
[    6.420150] drivers/scsi/mvsas/mv_sas.c 1216:port 1 attach sas addr is 1
[    6.621152] drivers/scsi/mvsas/mv_sas.c 1214:port 2 attach dev info is 20000000
[    6.621154] drivers/scsi/mvsas/mv_sas.c 1216:port 2 attach sas addr is 2
[    6.822142] drivers/scsi/mvsas/mv_sas.c 1214:port 3 attach dev info is 20400
[    6.822144] drivers/scsi/mvsas/mv_sas.c 1216:port 3 attach sas addr is 3
[    6.923123] drivers/scsi/mvsas/mv_sas.c 1214:port 4 attach dev info is 0
[    6.923125] drivers/scsi/mvsas/mv_sas.c 1216:port 4 attach sas addr is 0
[    7.024125] drivers/scsi/mvsas/mv_sas.c 1214:port 5 attach dev info is 0
[    7.024127] drivers/scsi/mvsas/mv_sas.c 1216:port 5 attach sas addr is 0
[    7.225132] drivers/scsi/mvsas/mv_sas.c 1214:port 6 attach dev info is 80200
[    7.225134] drivers/scsi/mvsas/mv_sas.c 1216:port 6 attach sas addr is 6
[    7.426132] drivers/scsi/mvsas/mv_sas.c 1214:port 7 attach dev info is 4
[    7.426134] drivers/scsi/mvsas/mv_sas.c 1216:port 7 attach sas addr is 7
[    7.426142] scsi6 : mvsas
[    7.426546] drivers/scsi/mvsas/mv_sas.c 380:phy 0 byte dmaded.
[    7.426549] drivers/scsi/mvsas/mv_sas.c 380:phy 1 byte dmaded.
[    7.426552] drivers/scsi/mvsas/mv_sas.c 380:phy 2 byte dmaded.
[    7.426555] drivers/scsi/mvsas/mv_sas.c 380:phy 3 byte dmaded.
[    7.426558] drivers/scsi/mvsas/mv_sas.c 380:phy 6 byte dmaded.
[    7.426560] drivers/scsi/mvsas/mv_sas.c 380:phy 7 byte dmaded.
[    7.430919] drivers/scsi/mvsas/mv_sas.c 1365:found dev[0:5] is gone.
[    7.462967] ata7.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    7.463026] ata7.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.467537] ata7.00: configured for UDMA/133
[    7.467642] scsi 6:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    7.473020] drivers/scsi/mvsas/mv_sas.c 1365:found dev[1:5] is gone.
[    7.487533] device-mapper: uevent: version 1.0.3
[    7.487662] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    7.496655] ata8.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    7.496714] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.502491] ata8.00: configured for UDMA/133
[    7.502592] scsi 6:0:1:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    7.503758] drivers/scsi/mvsas/mv_sas.c 1365:found dev[2:5] is gone.
[    7.503783] kjournald starting.  Commit interval 5 seconds
[    7.503787] EXT3-fs: mounted filesystem with ordered data mode.
[    7.530908] ata9.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.530968] ata9.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.570669] ata9.00: configured for UDMA/133
[    7.570762] scsi 6:0:2:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.571863] drivers/scsi/mvsas/mv_sas.c 1365:found dev[3:5] is gone.
[    7.573256] ata10.00: ATA-8: ST31000523AS, CC35, max UDMA/133
[    7.573315] ata10.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.574633] ata10.00: configured for UDMA/133
[    7.574729] scsi 6:0:3:0: Direct-Access     ATA      ST31000523AS     CC35 PQ: 0 ANSI: 5
[    7.575757] drivers/scsi/mvsas/mv_sas.c 1365:found dev[4:5] is gone.
[    7.602839] ata11.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.602898] ata11.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.642437] ata11.00: configured for UDMA/133
[    7.642543] scsi 6:0:4:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.643728] drivers/scsi/mvsas/mv_sas.c 1365:found dev[5:5] is gone.
[    7.657807] udev: starting version 141
[    7.670910] ata12.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.670968] ata12.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.698125] processor LNXCPU:00: registered as cooling_device0
[    7.698229] processor LNXCPU:01: registered as cooling_device1
[    7.698318] processor LNXCPU:02: registered as cooling_device2
[    7.703555] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    7.703628] ACPI: Power Button [PWRF]
[    7.703733] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    7.703800] ACPI: Power Button [PWRB]
[    7.705339] ACPI: WMI: Mapper loaded
[    7.706260] processor LNXCPU:03: registered as cooling_device3
[    7.707888] parport_pc 00:0a: reported by Plug and Play ACPI
[    7.707997] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    7.712103] ata12.00: configured for UDMA/133
[    7.712209] scsi 6:0:5:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.754951] EDAC MC: Ver: 2.1.0 Sep 15 2009
[    7.755966] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    7.756059] ACPI: Device needs an ACPI driver
[    7.756345] piix4_smbus: probe of 0000:00:14.0 failed with error -16
[    7.773138] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    7.774502] EDAC amd64_edac:  Ver: 3.2.0 Sep 15 2009
[    7.785522] EDAC amd64: This node reports that Memory ECC is currently disabled.
[    7.785593] EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTROL device (0000:00:18.3) should be enabled
[    7.785669] EDAC amd64: WARNING: ECC is NOT currently enabled by the BIOS. Module will NOT be loaded.
[    7.785670]     Either Enable ECC in the BIOS, or use the 'ecc_enable_override' parameter.
[    7.785672]     Might be a BIOS bug, if BIOS says ECC is enabled
[    7.785672]     Use of the override can cause unknown side effects.
[    7.786497] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    7.862848] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.903655] hda_codec: ALC889A: BIOS auto-probing.
[    7.905056] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[    8.117628] Adding 8385920k swap on /dev/sdb4.  Priority:-1 extents:1 across:8385920k 
[    8.139214] EXT3 FS on sda2, internal journal
[    8.158737] loop: module loaded
[    8.175283] it87: Found IT8720F chip at 0x228, revision 5
[    8.175347] it87: in3 is VCC (+5V)
[    8.431249] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    8.431400] sd 6:0:1:0: Attached scsi generic sg4 type 0
[    8.431545] sd 6:0:2:0: Attached scsi generic sg5 type 0
[    8.431687] sd 6:0:3:0: Attached scsi generic sg6 type 0
[    8.431834] sd 6:0:4:0: Attached scsi generic sg7 type 0
[    8.431978] sd 6:0:5:0: Attached scsi generic sg8 type 0
[    8.441605] sd 6:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.441704] sd 6:0:0:0: [sdc] Write Protect is off
[    8.441760] sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.441775] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.441951]  sdc:
[    8.442772] sd 6:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.442926] sd 6:0:1:0: [sdd] Write Protect is off
[    8.442932] sd 6:0:2:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.442960] sd 6:0:2:0: [sde] Write Protect is off
[    8.442962] sd 6:0:2:0: [sde] Mode Sense: 00 3a 00 00
[    8.442976] sd 6:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.443062]  sde:
[    8.443106] sd 6:0:3:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.443140] sd 6:0:3:0: [sdf] Write Protect is off
[    8.443142] sd 6:0:3:0: [sdf] Mode Sense: 00 3a 00 00
[    8.443156] sd 6:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.443230]  sdf:
[    8.443285] sd 6:0:4:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.443310] sd 6:0:4:0: [sdg] Write Protect is off
[    8.443312] sd 6:0:4:0: [sdg] Mode Sense: 00 3a 00 00
[    8.443326] sd 6:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.443396]  sdg:
[    8.443692] sd 6:0:1:0: [sdd] Mode Sense: 00 3a 00 00
[    8.443759] sd 6:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.443915]  sdd:
[    8.444063] sd 6:0:5:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.444216] sd 6:0:5:0: [sdh] Write Protect is off
[    8.444275] sd 6:0:5:0: [sdh] Mode Sense: 00 3a 00 00
[    8.444290] sd 6:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.444444]  sdh: unknown partition table
[    8.457731] sd 6:0:2:0: [sde] Attached SCSI disk
[    8.458925]  unknown partition table
[    8.459105] sd 6:0:3:0: [sdf] Attached SCSI disk
[    8.461269]  unknown partition table
[    8.461416] sd 6:0:4:0: [sdg] Attached SCSI disk
[    8.464300]  unknown partition table
[    8.464478] sd 6:0:5:0: [sdh] Attached SCSI disk
[    8.483210] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    8.483284] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    8.494429] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    8.494516] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    8.524232]  [LDM] sdd1
[    8.524693] sd 6:0:1:0: [sdd] Attached SCSI disk
[    8.533599]  [LDM] sdc1
[    8.534023] sd 6:0:0:0: [sdc] Attached SCSI disk
[    8.538760] kjournald starting.  Commit interval 5 seconds
[    8.539079] EXT3 FS on sdb3, internal journal
[    8.539184] EXT3-fs: mounted filesystem with ordered data mode.
[    8.802739] Bridge firewalling registered
[    8.805415] device eth0 entered promiscuous mode
[    8.806549] r8169: eth0: link up
[    8.806607] r8169: eth0: link up
[    8.810739] br0: port 1(eth0) entering learning state
[   19.126139] eth0: no IPv6 routers present
[   19.510163] br0: no IPv6 routers present
[   23.810107] br0: port 1(eth0) entering forwarding state
[   31.409676] RPC: Registered udp transport module.
[   31.409741] RPC: Registered tcp transport module.
[   31.421002] Slow work thread pool: Starting up
[   31.421128] Slow work thread pool: Ready
[   31.421212] FS-Cache: Loaded
[   31.436534] FS-Cache: Netfs 'nfs' registered for caching
[   31.449701] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   31.562846] svc: failed to register lockdv1 RPC service (errno 97).
[   31.996154] kvm: Nested Virtualization enabled
[   31.996212] kvm: Nested Paging enabled
[   32.033986] powernow-k8: Found 1 AMD Phenom(tm) II X4 810 Processor processors (4 cpu cores) (version 2.20.00)
[   32.034024] powernow-k8:    0 : pstate 0 (2600 MHz)
[   32.034025] powernow-k8:    1 : pstate 1 (1900 MHz)
[   32.034027] powernow-k8:    2 : pstate 2 (1400 MHz)
[   32.034028] powernow-k8:    3 : pstate 3 (800 MHz)
[   42.264791] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   42.265213] NFSD: starting 90-second grace period
[   42.328104] process `upsagentd' is using obsolete setsockopt SO_BSDCOMPAT
[   42.552171] lo: Disabled Privacy Extensions
[   63.457379] CE: hpet increasing min_delta_ns to 15000 nsec
[  526.190992] md: nonpersistent superblock ...
[  526.191004] md: bind<sdc1>
[  526.191066] md: nonpersistent superblock ...
[  526.191072] md: bind<sdd1>
[  526.195795] md: raid0 personality registered for level 0
[  526.196035] raid0: looking at sdd1
[  526.196042] raid0:   comparing sdd1(3907024896)
[  526.196049]  with sdd1(3907024896)
[  526.196053] raid0:   END
[  526.196057] raid0:   ==> UNIQUE
[  526.196061] raid0: 1 zones
[  526.196065] raid0: looking at sdc1
[  526.196070] raid0:   comparing sdc1(3907024896)
[  526.196076]  with sdd1(3907024896)
[  526.196080] raid0:   EQUAL
[  526.196084] raid0: FINAL 1 zones
[  526.196090] raid0: done.
[  526.196095] raid0 : md_size is 7814049792 sectors.
[  526.196100] ******* md0 configuration *********
[  526.196104] zone0=[sdc1/sdd1/]
[  526.196114]         zone offset=0kb device offset=0kb size=3907024896kb
[  526.196120] **********************************
[  526.196122] 
[  526.196143] md0: detected capacity change from 0 to 4000793493504
[  526.201459]  md0: AHDI p2 p3
[  543.245569] fuse init (API version 7.12)
[  702.355284] md: md0 still in use.
[  702.355451] md: md0 still in use.
[  702.376872] md: md1 stopped.
[  702.378841] md: bind<sdh>
[  702.379056] md: bind<sde>
[  702.379272] md: bind<sdf>
[  702.379588] md: bind<sdg>
[  702.383347] raid0: looking at sdg
[  702.383356] raid0:   comparing sdg(1953524736)
[  702.383362]  with sdg(1953524736)
[  702.383367] raid0:   END
[  702.383371] raid0:   ==> UNIQUE
[  702.383376] raid0: 1 zones
[  702.383380] raid0: looking at sdf
[  702.383385] raid0:   comparing sdf(1953524736)
[  702.383390]  with sdg(1953524736)
[  702.383395] raid0:   EQUAL
[  702.383399] raid0: looking at sde
[  702.383404] raid0:   comparing sde(1953524736)
[  702.383409]  with sdg(1953524736)
[  702.383413] raid0:   EQUAL
[  702.383418] raid0: looking at sdh
[  702.383423] raid0:   comparing sdh(1953524736)
[  702.383428]  with sdg(1953524736)
[  702.383432] raid0:   EQUAL
[  702.383436] raid0: FINAL 1 zones
[  702.383444] raid0: done.
[  702.383449] raid0 : md_size is 7814098944 sectors.
[  702.383453] ******* md1 configuration *********
[  702.383457] zone0=[sdg/sdh/sde/sdf/]
[  702.383472]         zone offset=0kb device offset=0kb size=3907049472kb
[  702.383477] **********************************
[  702.383479] 
[  702.383511] md1: detected capacity change from 0 to 4000818659328
[  702.386921]  md1: unknown partition table
[  702.389900] udevadm[4910]: segfault at 0 ip 00007ffc359b3210 sp 00007fffaf594428 error 4 in libc-2.9.so[7ffc3593a000+147000]
[  702.405240] udevadm[4942]: segfault at 0 ip 00007fca51565210 sp 00007fffd2a8e888 error 4 in libc-2.9.so[7fca514ec000+147000]
[  702.428359] udevadm[4943]: segfault at 0 ip 00007f084ac9c210 sp 00007fff4bf980f8 error 4 in libc-2.9.so[7f084ac23000+147000]
[  702.471517] udevadm[4944]: segfault at 0 ip 00007f9f40516210 sp 00007fff3205ceb8 error 4 in libc-2.9.so[7f9f4049d000+147000]
[  702.554772] udevadm[4945]: segfault at 0 ip 00007ff19c866210 sp 00007fffbca60ac8 error 4 in libc-2.9.so[7ff19c7ed000+147000]
[  702.718201] udevadm[4946]: segfault at 0 ip 00007f0eb2430210 sp 00007fff913ea648 error 4 in libc-2.9.so[7f0eb23b7000+147000]
[  703.041658] udevadm[4947]: segfault at 0 ip 00007f0c023e2210 sp 00007fff71cd85c8 error 4 in libc-2.9.so[7f0c02369000+147000]
[  703.684932] udevadm[4948]: segfault at 0 ip 00007fc533a38210 sp 00007fff22c45ff8 error 4 in libc-2.9.so[7fc5339bf000+147000]
[  721.058033] udev: starting version 141
[  737.701210] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  737.701220] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  737.701235] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  737.701241] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  737.701252] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  737.701257] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  767.704192] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  767.704202] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  767.704218] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  767.704224] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  767.704234] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  767.704240] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  798.704096] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  798.704105] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  798.704120] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  798.704126] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  798.704137] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  798.704142] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  829.704053] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  829.704062] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  829.704077] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  829.704084] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  829.704094] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  829.704099] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  840.491275] INFO: task mdadm:4951 blocked for more than 120 seconds.
[  840.491283] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  840.491289] mdadm         D ffff880104c50890     0  4951      1 0x00000000
[  840.491301]  ffff88012f1e5850 0000000000000082 ffff880104c50e20 ffff880104c50890
[  840.491313]  ffff880104c50890 ffff8800be4fe000 0000000000010890 ffff8800be4fffd8
[  840.491323]  ffff880104c50890 ffff880104c50b98 00000001a1527180 ffff8800a1527180
[  840.491332] Call Trace:
[  840.491349]  [<ffffffff810171fb>] ? read_tsc+0xa/0x20
[  840.491361]  [<ffffffff8106a924>] ? getnstimeofday+0x55/0xaf
[  840.491371]  [<ffffffff812f2aef>] ? io_schedule+0x73/0xb7
[  840.491381]  [<ffffffff811079c7>] ? __blockdev_direct_IO+0x952/0xaa2
[  840.491390]  [<ffffffff810f0e5a>] ? dput+0x23/0x144
[  840.491400]  [<ffffffff810c1f31>] ? __inc_zone_state+0x10/0x74
[  840.491410]  [<ffffffff81105deb>] ? blkdev_direct_IO+0x45/0x4a
[  840.491418]  [<ffffffff811050fb>] ? blkdev_get_blocks+0x0/0x8b
[  840.491428]  [<ffffffff810b1c3f>] ? generic_file_aio_read+0xf6/0x53d
[  840.491438]  [<ffffffff810b622a>] ? __alloc_pages_nodemask+0xf8/0x56a
[  840.491447]  [<ffffffff810e23d9>] ? do_sync_read+0xce/0x113
[  840.491457]  [<ffffffff810631ee>] ? autoremove_wake_function+0x0/0x2e
[  840.491465]  [<ffffffff810c7123>] ? handle_mm_fault+0x6b3/0x6ec
[  840.491473]  [<ffffffff811053a9>] ? block_ioctl+0x38/0x3c
[  840.491482]  [<ffffffff812f3d27>] ? _spin_lock_irqsave+0x25/0x47
[  840.491489]  [<ffffffff810e2e02>] ? vfs_read+0xa6/0xff
[  840.491496]  [<ffffffff810e2f17>] ? sys_read+0x45/0x6e
[  840.491505]  [<ffffffff81010ac2>] ? system_call_fastpath+0x16/0x1b
[  860.704049] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  860.704058] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  860.704073] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  860.704079] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  860.704089] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  860.704094] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  891.704173] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  891.704183] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  891.704199] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  891.704205] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  891.704216] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  891.704221] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  891.704240] sd 6:0:3:0: [sdf] Unhandled error code
[  891.704247] sd 6:0:3:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  891.704256] sd 6:0:3:0: [sdf] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
[  891.704280] end_request: I/O error, dev sdf, sector 0
[  891.704289] Buffer I/O error on device sdf, logical block 0
[  891.704302] Buffer I/O error on device sdf, logical block 1
[  891.704309] Buffer I/O error on device sdf, logical block 2
[  891.704316] Buffer I/O error on device sdf, logical block 3
[  891.704374] sd 6:0:4:0: [sdg] Unhandled error code
[  891.704379] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  891.704387] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 00 00 00 50 00 03 b0 00
[  891.704409] end_request: I/O error, dev sdg, sector 80
[  891.704416] Buffer I/O error on device md1, logical block 10
[  891.704426] Buffer I/O error on device md1, logical block 11
[  891.704433] Buffer I/O error on device md1, logical block 12
[  891.704439] Buffer I/O error on device md1, logical block 13
[  891.704445] Buffer I/O error on device md1, logical block 14
[  891.704452] Buffer I/O error on device md1, logical block 15
[  891.704573] sd 6:0:0:0: [sdc] Unhandled error code
[  891.704578] sd 6:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  891.704585] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 e8 e0 7f 80 00 00 08 00
[  891.704606] end_request: I/O error, dev sdc, sector 3907026816
[  922.701059] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  922.701069] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  922.701083] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  922.701089] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  922.701097] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  922.701102] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  922.701110] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  922.701115] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  953.701077] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  953.701086] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  953.701102] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  953.701108] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  953.701116] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  953.701121] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  953.701140] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  953.701146] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  960.491270] INFO: task mdadm:4989 blocked for more than 120 seconds.
[  960.491279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  960.491286] mdadm         D ffff88002806e8d0     0  4989   4717 0x00000004
[  960.491298]  ffff88012fb42750 0000000000000086 ffff8800a013dbb8 ffff8800a013dbb4
[  960.491310]  ffff88012b88cb08 ffff8800a013c000 0000000000010890 ffff8800a013dfd8
[  960.491320]  ffff8800c4965080 ffff8800c4965388 000000022b88cb08 ffff8800b05ba400
[  960.491330] Call Trace:
[  960.491402]  [<ffffffffa0020210>] ? scsi_request_fn+0x421/0x4f9 [scsi_mod]
[  960.491416]  [<ffffffff812f2aef>] ? io_schedule+0x73/0xb7
[  960.491427]  [<ffffffff811079c7>] ? __blockdev_direct_IO+0x952/0xaa2
[  960.491436]  [<ffffffff810f0e5a>] ? dput+0x23/0x144
[  960.491446]  [<ffffffff810c1f31>] ? __inc_zone_state+0x10/0x74
[  960.491456]  [<ffffffff81105deb>] ? blkdev_direct_IO+0x45/0x4a
[  960.491464]  [<ffffffff811050fb>] ? blkdev_get_blocks+0x0/0x8b
[  960.491474]  [<ffffffff810b1c3f>] ? generic_file_aio_read+0xf6/0x53d
[  960.491485]  [<ffffffff810b622a>] ? __alloc_pages_nodemask+0xf8/0x56a
[  960.491493]  [<ffffffff810e23d9>] ? do_sync_read+0xce/0x113
[  960.491504]  [<ffffffff810631ee>] ? autoremove_wake_function+0x0/0x2e
[  960.491512]  [<ffffffff810c7123>] ? handle_mm_fault+0x6b3/0x6ec
[  960.491520]  [<ffffffff811053a9>] ? block_ioctl+0x38/0x3c
[  960.491529]  [<ffffffff812f3d27>] ? _spin_lock_irqsave+0x25/0x47
[  960.491537]  [<ffffffff810e2e02>] ? vfs_read+0xa6/0xff
[  960.491544]  [<ffffffff810e2f17>] ? sys_read+0x45/0x6e
[  960.491552]  [<ffffffff81010ac2>] ? system_call_fastpath+0x16/0x1b
[  984.701191] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  984.701200] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  984.701216] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  984.701222] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  984.701230] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  984.701235] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  984.701243] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  984.701249] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1015.701948] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1015.701958] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1015.701973] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1015.701979] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1015.701987] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1015.701992] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1015.701999] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1015.702009] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1046.701062] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1046.701071] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1046.701087] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1046.701093] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1046.701101] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1046.701106] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1046.701114] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1046.701119] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1076.704177] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1076.704187] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1076.704202] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1076.704208] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1076.704216] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1076.704221] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1076.704228] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1076.704233] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1076.704251] sd 6:0:3:0: [sdf] Unhandled error code
[ 1076.704257] sd 6:0:3:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1076.704266] sd 6:0:3:0: [sdf] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[ 1076.704290] end_request: I/O error, dev sdf, sector 0
[ 1076.704298] __ratelimit: 112 callbacks suppressed
[ 1076.704305] Buffer I/O error on device sdf, logical block 0
[ 1076.704333] sd 6:0:4:0: [sdg] Unhandled error code
[ 1076.704337] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1076.704345] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 00 00 00 50 00 00 08 00
[ 1076.704367] end_request: I/O error, dev sdg, sector 80
[ 1076.704374] Buffer I/O error on device md1, logical block 10
[ 1076.704390] sd 6:0:1:0: [sdd] Unhandled error code
[ 1076.704395] sd 6:0:1:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1076.704402] sd 6:0:1:0: [sdd] CDB: Read(10): 28 00 e8 e0 7f 80 00 00 08 00
[ 1076.704423] end_request: I/O error, dev sdd, sector 3907026816
[ 1076.704439] sd 6:0:0:0: [sdc] Unhandled error code
[ 1076.704444] sd 6:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1076.704452] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 e8 e0 7f 80 00 00 08 00
[ 1076.704473] end_request: I/O error, dev sdc, sector 3907026816
[ 1107.701941] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1107.701951] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1137.704187] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1137.704197] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1168.704058] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1168.704067] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1199.704173] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1199.704182] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1230.704182] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1230.704191] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1261.704201] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1261.704210] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1261.704235] sd 6:0:4:0: [sdg] Unhandled error code
[ 1261.704242] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1261.704250] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 00 00 00 50 00 00 08 00
[ 1261.704272] end_request: I/O error, dev sdg, sector 80
[ 1261.704281] Buffer I/O error on device md1, logical block 10
[ 1292.701214] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1292.701224] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1322.704439] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1322.704448] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1353.704079] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1353.704088] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1384.704189] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1384.704198] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1415.705275] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1415.705285] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1446.704173] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1446.704183] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1446.704207] sd 6:0:4:0: [sdg] Unhandled error code
[ 1446.704214] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1446.704222] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 00 00 00 50 00 00 08 00
[ 1446.704244] end_request: I/O error, dev sdg, sector 80
[ 1446.704253] Buffer I/O error on device md1, logical block 10
[ 1477.701143] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1477.701153] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1507.704171] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1507.704180] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1538.704085] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1538.704094] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1569.698294] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1569.698304] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1599.704179] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1599.704188] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1630.704175] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1630.704184] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1630.704208] sd 6:0:4:0: [sdg] Unhandled error code
[ 1630.704215] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1630.704223] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 00 00 00 50 00 00 08 00
[ 1630.704245] end_request: I/O error, dev sdg, sector 80
[ 1630.704254] Buffer I/O error on device md1, logical block 10

--Boundary-00=_Y77rK251rKJN8kV--

From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Wed, 9 Sep 2009 13:10:26 -0600
Message-ID: <200909091310.26058.tfjellstrom@shaw.ca>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca> <4AA7F965.6020408@garzik.org>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AA7F965.6020408@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed September 9 2009, Jeff Garzik wrote:
> On 09/09/2009 12:30 PM, Thomas Fjellstrom wrote:
> > No errors on that disk. Other than the one above, and its more of a
> > warning. However, I just rebooted to add some extra drives, thinking
> > everything was working a little better now that I've updated to
> > 2.6.31-rc9, I'm treated to the following two messages right after boot
> > (and a system lockup to boot):
> >
> > kernel: [  971.033138] ------------[ cut here ]------------
> > kernel: [  971.033211] WARNING: at drivers/ata/libata-core.c:4913
> > __ata_qc_complete+0x5a/0xe1 [libata]()
> > kernel: [  971.033217] Hardware name: GA-MA790FXT-UD5P
> > kernel: [  971.033221] Modules linked in: powernow_k8
> > cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave
> > kvm_amd kvm nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
> > bridge stp it87 hwmon_vid adt7473 firewire_sbp2 loop md_mod
> > snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
> > snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> > snd_timer snd_seq_device snd amd64_edac_mod edac_core i2c_piix4 soundcore
> > snd_page_alloc i2c_core evdev wmi parport_pc button parport processor
> > ext3 jbd mbcache dm_mod sg sr_mod cdrom sd_mod crc_t10dif usbhid
> > ata_generic ide_pci_generic hid mvsas firewire_ohci libsas firewire_core
> > crc_itu_t scsi_transport_sas r8169 atiixp ide_core floppy ahci mii
> > ohci_hcd libata ehci_hcd scsi_mod thermal fan thermal_sys [last unloaded:
> > scsi_wait_scan]
> > kernel: [  971.033337] Pid: 0, comm: swapper Not tainted 2.6.31-rc9 #2
> > kernel: [  971.033342] Call Trace:
> > kernel: [  971.033346]<IRQ>   [<ffffffffa00562ca>] ?
> > __ata_qc_complete+0x5a/0xe1 [libata]
> > kernel: [  971.033434]  [<ffffffffa00562ca>] ?
> > __ata_qc_complete+0x5a/0xe1 [libata]
> > kernel: [  971.033446]  [<ffffffff8104aca0>] ?
> > warn_slowpath_common+0x77/0xa3 kernel: [  971.033455] 
> > [<ffffffff81038d06>] ? enqueue_task+0x5c/0x65 kernel: [  971.033496] 
> > [<ffffffffa00562ca>] ? __ata_qc_complete+0x5a/0xe1 [libata]
> > kernel: [  971.033519]  [<ffffffffa00f7b59>] ?
> > sas_ata_task_done+0x178/0x210 [libsas]
> > kernel: [  971.033528]  [<ffffffff8115ead1>] ? blk_run_queue+0x21/0x35
> > kernel: [  971.033548]  [<ffffffffa010e2ce>] ?
> > mvs_slot_complete+0x3df/0x41b [mvsas]
> > kernel: [  971.033565]  [<ffffffffa010e39c>] ? mvs_int_rx+0x92/0x101
> > [mvsas] kernel: [  971.033583]  [<ffffffffa01112ba>] ?
> > mvs_int_full+0x25/0x88 [mvsas] kernel: [  971.033600] 
> > [<ffffffffa011134e>] ? mvs_64xx_isr+0x31/0x40 [mvsas] kernel: [ 
> > 971.033617]  [<ffffffffa010d0e5>] ? mvs_interrupt+0x61/0x78 [mvsas]
> > kernel: [  971.033625]  [<ffffffff8108aaac>] ?
> > handle_IRQ_event+0x58/0x135 kernel: [  971.033633]  [<ffffffff8108c1a1>]
> > ? handle_fasteoi_irq+0x7d/0xb5 kernel: [  971.033642] 
> > [<ffffffff8101388d>] ? handle_irq+0x17/0x1d
> 
> That warning is triggered when an ata_queued_cmd is passed to completion
> without the ATA_QCFLAG_ACTIVE flag being set (which indicates the qc was
> started with some activity).
> 
> That possibly indicates the low-level driver (or libsas) was passing an
> already-completed cmd to libata.
> 
> > The added hard drives are connected to a Supermicro AOC-SASLP-MV8, which
> > is based on a marvel MV64460/64461/64462 chipset, which uses the sata_mv
> > driver.
> 
> Surely you mean 'mvsas' driver?

Yes, sorry I did mean mvsas.

I am more concerned about the actual oops/BUG rather than the warning though. 
Unless the problem causing the warning is also causing the oops.

> 	Jeff
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

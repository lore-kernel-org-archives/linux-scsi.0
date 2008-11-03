From: Matthias Andree <matthias.andree@gmx.de>
Subject: WARNING in 2.6.27.4 pci-dma::dma_free_coherent, during unload of
	sym53c8xx_2
Date: Mon, 3 Nov 2008 02:36:47 +0100
Message-ID: <20081103013647.GA27549@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58568 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754135AbYKCBgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Nov 2008 20:36:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org

Hi,

I killall -9'ed "taper" because my SCSI hardware was going haywire,
and tried to rmmod sym53c8xx, and got a nice warning from the kernel -
shown below.

[Please Cc: replies, I'm subscribed to linux-kernel@, but not linux-scsi@]

The machine had been suspended to disk before (via /sys/power/state).

------------[ cut here ]------------
WARNING: at arch/x86/kernel/pci-dma.c:376 dma_free_coherent+0x80/0x90()
Modules linked in: nls_utf8 nls_cp437 vfat fat lp tun iptable_mangle ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT ipt_recent nf_conntrack_ipv4 xt_state xt_TCPMSS xt_tcpudp pppoe pppox af_packet ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables snd_pcm_oss snd_mixer_oss snd_seq ipv6 nf_conntrack_sip nf_conntrack_irc nf_conntrack_ftp nf_conntrack it87 hwmon_vid hwmon fuse dm_crypt ufs xfs loop dm_mod bnep rfcomm l2cap tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 snd_via82xx snd_via82xx_modem tvaudio snd_ac97_codec msp3400 snd_mpu401_uart ppdev ns558 rtc_cmos st bttv ohci1394 rtc_core floppy gameport snd_rawmidi rtc_lib ac97_bus snd_seq_device ieee1394 serio_raw snd_pcm videodev btusb snd_timer via_rhine snd_page_alloc v
 4l1_compat snd usb_storage soundcore bluetooth i2c_viapro ir_common compat_ioctl32 i2c_algo_bit v4l2_common videobuf_dma_sg usblp videobuf_core btcx_risc sr_mod tveeprom cdrom sg 3c59x i2c_core mii parport_pc parport button joydev usbhid uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif via82cxxx ide_core pata_amd sata_nv edd ext3 mbcache jbd fan sym53c8xx(-) sata_via pata_via thermal processor
Pid: 27228, comm: rmmod Not tainted 2.6.27.4-default #14
 [<c037681a>] ? printk+0x18/0x1e
 [<c0129874>] warn_on_slowpath+0x54/0x80
 [<c0122bad>] ? check_preempt_wakeup+0x16d/0x1a0
 [<c0123cb6>] ? try_to_wake_up+0xd6/0x1a0
 [<c0140475>] ? enqueue_hrtimer+0x75/0x120
 [<c0123d8b>] ? default_wake_function+0xb/0x10
 [<c013d3cb>] ? autoremove_wake_function+0x1b/0x50
 [<c014b1b7>] ? smp_call_function_mask+0x47/0x1c0
 [<c0112d10>] ? do_flush_tlb_all+0x0/0x60
 [<c01cce2f>] ? free_proc_entry+0x5f/0x80
 [<c01cce2f>] ? free_proc_entry+0x5f/0x80
 [<c0108320>] dma_free_coherent+0x80/0x90
 [<f8851791>] ___free_dma_mem_cluster+0x61/0x90 [sym53c8xx]
 [<f885162f>] __sym_mfree+0xaf/0xf0 [sym53c8xx]
 [<c0112cc4>] ? flush_tlb_all+0x14/0x20
 [<f88516c4>] __sym_mfree_dma+0x54/0xc0 [sym53c8xx]
 [<f884aa74>] sym_hcb_free+0x74/0x1a0 [sym53c8xx]
 [<f884887f>] sym_free_resources+0x3f/0x70 [sym53c8xx]
 [<f884893c>] sym_detach+0x8c/0xa0 [sym53c8xx]
 [<f884897c>] sym2_remove+0x2c/0x50 [sym53c8xx]
 [<c0233ce9>] pci_device_remove+0x19/0x40
 [<c0293d44>] __device_release_driver+0x74/0xb0
 [<c0293e0f>] driver_detach+0x8f/0xa0
 [<c02930b3>] bus_remove_driver+0x73/0xa0
 [<c0294291>] driver_unregister+0x31/0x40
 [<c0233f14>] pci_unregister_driver+0x24/0x80
 [<f8852465>] sym2_exit+0xd/0x28 [sym53c8xx]
 [<c014f8df>] sys_delete_module+0x15f/0x220
 [<c017a3b2>] ? do_munmap+0x1d2/0x230
 [<c0103cdd>] sysenter_do_call+0x12/0x21
 =======================
---[ end trace 5fc8814f2abc34b4 ]---
------------[ cut here ]------------

-- 
Matthias Andree

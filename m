From: Marko Macek <Marko.Macek@gmx.net>
Subject: oops when removing storage device with no actual drive
Date: Tue, 16 Aug 2005 21:20:38 +0200
Message-ID: <43023C86.8050705@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:51115 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932381AbVHPTWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 15:22:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hello.

Kernel 2.6.12.4 (or -2.6.12-1.1398_FC4)

Below is a backtrace for a 100% reproducible oops. Recipe:

1. External usb disk enclosure for an IDE drive.
2. Drive set to slave instead of master (or cable-select, probably). 
Jumper is set to Master, all is fine.
3. No drive found after plugging in (maybe OK)
4. OOPS happens as soon as I turn off or unplug the device.

usb-storage: device found at 26
usb-storage: waiting for device to settle before scanning
scsi: Device offlined - not ready after error recovery: host 4 channel 0 
id 0 lu
n 0
usb 2-7: USB disconnect, address 26
usb-storage: device scan complete
Unable to handle kernel NULL pointer dereference at virtual address 00000048
 printing eip:
c0199cb3
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: usb_storage radeon ipv6 parport_pc lp parport autofs4 
rfcomm
l2cap sunrpc ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables 
binfmt_m
isc dm_mod video button battery ac ati_remote ohci1394 ieee1394 usblp 
joydev uhc
i_hcd ehci_hcd budget l64781 ves1820 budget_core saa7146 ttpci_eeprom 
stv0299 td
a8083 ves1x93 dvb_core tuner saa7134 video_buf v4l2_common v4l1_compat 
ir_common
 videodev pdc202xx_new shpchp i2c_viapro i2c_core snd_emu10k1_synth 
snd_emux_syn
th snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi 
snd_ac97_codec snd_
seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_
mixer_oss snd_pcm snd_timer snd_page_alloc snd_util_mem snd_hwdep snd 
soundcore
sk98lin floppy ext3 jbd raid1 sata_promise sata_via libata sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c0199cb3>]    Not tainted VLI
EFLAGS: 00010292   (2.6.12.4)
EIP is at sysfs_hash_and_remove+0x13/0xeb
eax: 00000000   ebx: edecc64c   ecx: 00000000   edx: 00000066
esi: edecc644   edi: f885dc20   ebp: f885dbc0   esp: f7b25e34
ds: 007b   es: 007b   ss: 0068
Process khubd (pid: 114, threadinfo=f7b25000 task=f7b22520)
Stack: c033ca3c 00000000 c0314e16 edecc64c edecc644 f885dc20 f885dbc0 
c023eeaa
       f885dc28 edecc644 edecc400 ef278c28 e4392480 c023eee8 edecc590 
f884b6a5
       ef278bf8 edecc400 ef278c00 f884b787 00000202 f7b25000 f7b25000 
ef278c04
Call Trace:
 [<c0314e16>] __down+0xb6/0x140
 [<c023eeaa>] class_device_del+0x8a/0xc0
 [<c023eee8>] class_device_unregister+0x8/0x10
 [<f884b6a5>] scsi_remove_device+0x65/0xa0 [scsi_mod]
 [<f884b787>] __scsi_remove_target+0xa7/0x110 [scsi_mod]
 [<f884a7a2>] scsi_forget_host+0x52/0xb0 [scsi_mod]
 [<f88425d1>] scsi_remove_host+0x11/0x60 [scsi_mod]
 [<f8d75b1f>] storage_disconnect+0x5f/0x79 [usb_storage]
 [<c0278982>] usb_unbind_interface+0x32/0x60
 [<c023dbc0>] device_release_driver+0x50/0x70
 [<c023de20>] bus_remove_device+0x70/0xc0
 [<c023cdf5>] device_del+0x65/0xa0
 [<c028045b>] usb_disable_device+0x9b/0xf0
 [<c027adac>] usb_disconnect+0x9c/0x150
 [<c027be3e>] hub_port_connect_change+0x4e/0x3c0
 [<c0279a88>] clear_port_feature+0x48/0x50
 [<c027c436>] hub_events+0x286/0x3e0
 [<c027c5df>] hub_thread+0x4f/0x110
 [<c0134580>] autoremove_wake_function+0x0/0x50
 [<c027c590>] hub_thread+0x0/0x110
 [<c0101325>] kernel_thread_helper+0x5/0x10
Code: c4 b9 17 00 8d 74 26 00 e9 3f ff ff ff 8d 74 26 00 8d bc 27 00 00 
00 00 55
 57 56 53 83 ec 0c 89 44 24 04 89 14 24 ba 66 00 00 00 <8b> 70 48 8b 58 
08 b8 a2
 17 33 c0 e8 1d 2a f8 ff ff 4b 70 0f 88
 

    Mark

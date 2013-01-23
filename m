From: Kouichi ONO <kou1.ono@gmail.com>
Subject: linux-3.7.4: BUG: unable to handle kernel NULL pointer dereference
 at target_fabric_port_link
Date: Thu, 24 Jan 2013 01:07:24 +0900 (JST)
Message-ID: <20130124.010724.710820132553071688.kou1.ono@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
after upgrade from 3.7.3 to 3.7.4, I got NULL pointer dereference at
target_fabric_port_link().

Jan 22 23:58:52  kernel: [   89.333115] BUG: unable to handle kernel NULL pointer dereference at           (null)
Jan 22 23:58:52  kernel: [   89.333251] IP: [<ffffffffa049d988>] target_fabric_port_link+0x18/0x100 [target_core_mod]
Jan 22 23:58:52  kernel: [   89.333382] PGD 40b94c067 PUD 40b8de067 PMD 0
Jan 22 23:58:52  kernel: [   89.333564] Oops: 0000 [#1] PREEMPT SMP
Jan 22 23:58:52  kernel: [   89.333756] Modules linked in: iscsi_target_mod target_core_pscsi target_core_file target_core_iblock binfmt_misc target
_core_mod iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common camellia
_generic camellia_x86_64 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic glue_helper blowfish_generic blowfish_x86_64 blowfish_common dlm cast5_avx_x
86_64 cast5_generic sctp sha512_generic sha256_generic crypto_null bridge stp llc nf_conntrack_ipv6 nf_defrag_ipv6 xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 k
vm_intel kvm crc32c_intel aesni_intel ablk_helper cryptd xts lrw gf128mul iTCO_wdt snd_hda_codec_hdmi microcode psmouse serio_raw pcspkr snd_hda_codec_realt
ek lpc_ich mfd_core snd_ice1724 snd_ak4113 snd_hda_intel snd_pt2258 snd_hda_codec snd_i2c snd_ak4114 snd_hwdep snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_pcm_os
s snd_mixer_oss snd_ac97_codec ac97_bus snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss snd_
Jan 22 23:58:52  kernel: seq_midi snd_rawmidi snd_seq_midi_event snd_seq rtc_cmos snd_seq_device snd_timer snd mei soundcore button vhost_net tun w8
3627ehf hwmon_vid coretemp hwmon acpi_cpufreq mperf processor firewire_sbp2 firewire_core crc_itu_t evdev fuse ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_
nodemanager ocfs2_stackglue configfs autofs4 usb_storage sg ata_generic pata_acpi sr_mod cdrom pata_marvell xhci_hcd e1000e ehci_hcd
Jan 22 23:58:52  kernel: [   89.339089] CPU 7
Jan 22 23:58:52  kernel: [   89.339132] Pid: 4050, comm: ln Tainted: G        W    3.7.4-dirty #1                  /DP67BG
Jan 22 23:58:52  kernel: [   89.339277] RIP: 0010:[<ffffffffa049d988>]  [<ffffffffa049d988>] target_fabric_port_link+0x18/0x100 [target_core_mod]
Jan 22 23:58:52  kernel: [   89.339413] RSP: 0018:ffff88040d45de78  EFLAGS: 00010286
Jan 22 23:58:52  kernel: [   89.339476] RAX: ffffffffa04bc840 RBX: ffff880404d499dc RCX: 0000000000000000
Jan 22 23:58:52  kernel: [   89.339538] RDX: 0000000000000007 RSI: ffff88040c70a7b0 RDI: ffff88040e4d2070
Jan 22 23:58:52  kernel: [   89.339609] RBP: ffff88040d45de98 R08: 0000000000000002 R09: fefefefefefefeff
Jan 22 23:58:52  kernel: [   89.339677] R10: 2f2f2f2f2f2f2f2f R11: 0000000000000000 R12: ffff88040b189440
Jan 22 23:58:52  kernel: [   89.339742] R13: ffff88040e4d2070 R14: ffff88040c70a7b0 R15: ffff88040c5dfb58
Jan 22 23:58:52  kernel: [   89.339807] FS:  00007f3edb7ef700(0000) GS:ffff88041f5c0000(0000) knlGS:0000000000000000
Jan 22 23:58:52  kernel: [   89.339893] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 22 23:58:52  kernel: [   89.339960] CR2: 0000000000000000 CR3: 000000040cc92000 CR4: 00000000000407e0
Jan 22 23:58:52  kernel: [   89.340030] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 22 23:58:52  kernel: [   89.340098] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 22 23:58:52  kernel: [   89.340161] Process ln (pid: 4050, threadinfo ffff88040d45c000, task ffff88040d91c840)
Jan 22 23:58:52  kernel: [   89.340243] Stack:
Jan 22 23:58:52  kernel: [   89.340302]  ffff880404d499dc ffff88040b189440 ffff88040e4d2070 ffff88040c70a7b0
Jan 22 23:58:52  kernel: [   89.340559]  ffff88040d45def8 ffffffffa005f02d ffff88040d45deb8 ffff88040ba1e800
Jan 22 23:58:52  kernel: [   89.340802]  ffff88040ebcabe0 ffff880404d49980 ffff88040d45dee8 0000000000000000
Jan 22 23:58:52  kernel: [   89.341057] Call Trace:
Jan 22 23:58:52  kernel: [   89.341125]  [<ffffffffa005f02d>] configfs_symlink+0x12d/0x340 [configfs]
Jan 22 23:58:52  kernel: [   89.341189]  [<ffffffff8113aa6d>] vfs_symlink+0x8d/0xf0
Jan 22 23:58:52  kernel: [   89.341250]  [<ffffffff8113e5b9>] sys_symlinkat+0x59/0x90
Jan 22 23:58:52  kernel: [   89.341322]  [<ffffffff8113e601>] sys_symlink+0x11/0x20
Jan 22 23:58:52  kernel: [   89.341391]  [<ffffffff816c1892>] system_call_fastpath+0x16/0x1b
Jan 22 23:58:52  kernel: [   89.341456] Code: 8b 65 f8 c9 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e0 4c 89 65
e8 4c 89 6d f0 4c 89 75 f8 <81> 3c 25 00 00 00 00 ef de ed fe 75 76 48 8b 47 30 48 83 7f f0
Jan 22 23:58:52  kernel: [   89.344386] RIP  [<ffffffffa049d988>] target_fabric_port_link+0x18/0x100 [target_core_mod]
Jan 22 23:58:52  kernel: [   89.344526]  RSP <ffff88040d45de78>
Jan 22 23:58:52  kernel: [   89.344592] CR2: 0000000000000000
Jan 22 23:58:52  kernel: [   89.344673] ---[ end trace 60b2bd0028e165d0 ]---


At target_fabric_port_link(), struct se_device *dev is used before set?

Thanks,

Kouichi ONO

From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sat, 31 Mar 2018 23:08:47 +0200
Message-ID: <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
References: <20180331015903.GA29398@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180331015903.GA29398@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 31, 2018 at 3:59 AM, Wakko Warner <wakko@animx.eu.org> wrote:
> I reported this before but noone responded.

Because you're sending only to LKML.
CC'ing storage folks.

> I have an iscsi target setup with /dev/sr[012] using pscsi.  On the
> initiator, I mount only 1 disc.  Then I issue find -type f | xargs cat >
> /dev/null  Then after a few seconds, I get 2 oops and the system has to b=
e
> hard reset.
>
> I noticed if I cat /dev/sr1 from the initiator, it doesn't crash.  I was
> also able to burn without crashing.
>
> Here's the OOPS:
> [2692.733468] WARNING: CPU: 8 PID: 0 at /usr/src/linux/dist/4.15.14-nobkl=
cd/drivers/scsi/scsi_lib.c:1068 scsi_init_io+0x111/0x1a0 [scsi_mod]
> [2692.734154] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_p=
rison dm_bufio raid456 async_raid6_recov async_memcpy async_pq async_xor as=
ync_tx xor raid6_pq libcrc32c crc32c_generic md_mod dm_crypt algif_skcipher=
 af_alg dm_mod dax ext4 crc16 mbcache jbd2 af_packet iscsi_target_mod tcm_l=
oop vhost_scsi vhost target_core_file target_core_iblock target_core_pscsi =
target_core_mod nfsd exportfs dummy bridge stp llc ib_iser rdma_cm iw_cm ib=
_cm ib_core ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi netco=
nsole configfs sr_mod cdrom adt7475 hwmon_vid sd_mod sg coretemp x86_pkg_te=
mp_thermal kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_int=
el ghash_clmulni_intel pcbc snd_hda_codec_realtek snd_hda_codec_generic nou=
veau video led_class drm_kms_helper cfbfillrect syscopyarea cfbimgblt
> [2692.737388]  sysfillrect sysimgblt snd_hda_intel fb_sys_fops cfbcopyare=
a snd_hda_codec ttm snd_hda_core snd_pcm_oss drm snd_mixer_oss agpgart snd_=
pcm igb snd_timer snd aesni_intel soundcore hwmon aes_x86_64 i2c_algo_bit a=
hci mpt3sas crypto_simd i2c_core libahci glue_helper mptsas raid_class liba=
ta mptscsih scsi_transport_sas mptbase scsi_mod wmi button unix
> [2692.737388] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 4.15.14 #1
> [2692.737388] Hardware name: Dell Inc. Precision T5610/0WN7Y6, BIOS A16 0=
2/05/2018
> [2692.737388] RIP: 0010:scsi_init_io+0x111/0x1a0 [scsi_mod]
> [2692.737388] RSP: 0018:ffff8806b7a03d78 EFLAGS: 00010046
> [2692.737388] RAX: 0000000000000000 RBX: ffff8806aa4a9c00 RCX: 0000000000=
000000
> [2692.737388] RDX: 0000000000000000 RSI: ffff8806aa4a9c00 RDI: ffff8806aa=
4a9d48
> [2692.737388] RBP: ffff8806aa4a9d48 R08: 0000000000000000 R09: ffff8806aa=
4a9d80
> [2692.737388] R10: ffff8806ab949088 R11: 0000000000000000 R12: ffff8806b2=
9bb000
> [2692.737388] R13: 0000000000000000 R14: ffff8806b29bb000 R15: ffff8806ac=
4f6950
> [2692.737388] FS:  0000000000000000(0000) GS:ffff8806b7a00000(0000) knlGS=
:0000000000000000
> [2692.737388] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [2692.737388] CR2: 00007f1359a8b756 CR3: 0000000001c09003 CR4: 0000000000=
1606e0
> [2692.737388] Call Trace:
> [2692.737388]  <IRQ>
> [2692.737388]  ? scsi_setup_cmnd+0xb3/0x140 [scsi_mod]
> [2692.737388]  ? scsi_prep_fn+0x53/0x130 [scsi_mod]
> [2692.737388]  ? blk_peek_request+0x136/0x220
> [2692.737388]  ? scsi_request_fn+0x2b/0x510 [scsi_mod]
> [2692.737388]  ? __blk_run_queue+0x34/0x50
> [2692.737388]  ? blk_run_queue+0x26/0x40
> [2692.737388]  ? scsi_run_queue+0x229/0x2b0 [scsi_mod]
> [2692.737388]  ? scsi_io_completion+0x3ce/0x5a0 [scsi_mod]
> [2692.737388]  ? blk_done_softirq+0x67/0x80
> [2692.737388]  ? __do_softirq+0xdb/0x1dd
> [2692.737388]  ? irq_exit+0xa3/0xb0
> [2692.737388]  ? do_IRQ+0x45/0xc0
> [2692.737388]  ? common_interrupt+0x77/0x77
> [2692.737388]  </IRQ>
> [2692.737388]  ? cpuidle_enter_state+0x124/0x200
> [2692.737388]  ? cpuidle_enter_state+0x119/0x200
> [2692.737388]  ? do_idle+0xdc/0x180
> [2692.737388]  ? cpu_startup_entry+0x14/0x20
> [2692.737388]  ? secondary_startup_64+0xa5/0xb0
> [2692.737388] Code: 8b 7b 30 e8 d2 6b 20 e1 49 8b 17 4c 89 ff 89 c6 89 44=
 24 04 e8 81 81 22 e1 85 c0 41 89 c4 74 55 41 bc 02 00 00 00 e9 39 ff ff ff=
 <0f> 0b 41 bc 01 00 00 00 e9 2c ff ff ff 48 8b 3d 6b dc 00 00 be
> [2692.737388] ---[ end trace 9801970f9b249e10 ]---
> [2692.737388] ------------[ cut here ]------------
> [2692.737388] kernel BUG at /usr/src/linux/dist/4.15.14-nobklcd/block/blk=
-core.c:3235!
> [2692.737388] invalid opcode: 0000 [#1] PREEMPT SMP
> [2692.737388] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_p=
rison dm_bufio raid456 async_raid6_recov async_memcpy async_pq async_xor as=
ync_tx xor raid6_pq libcrc32c crc32c_generic md_mod dm_crypt algif_skcipher=
 af_alg dm_mod dax ext4 crc16 mbcache jbd2 af_packet iscsi_target_mod tcm_l=
oop vhost_scsi vhost target_core_file target_core_iblock target_core_pscsi =
target_core_mod nfsd exportfs dummy bridge stp llc ib_iser rdma_cm iw_cm ib=
_cm ib_core ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi netco=
nsole configfs sr_mod cdrom adt7475 hwmon_vid sd_mod sg coretemp x86_pkg_te=
mp_thermal kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_int=
el ghash_clmulni_intel pcbc snd_hda_codec_realtek snd_hda_codec_generic nou=
veau video led_class drm_kms_helper cfbfillrect syscopyarea cfbimgblt
> [2692.737388]  sysfillrect sysimgblt snd_hda_intel fb_sys_fops cfbcopyare=
a snd_hda_codec ttm snd_hda_core snd_pcm_oss drm snd_mixer_oss agpgart snd_=
pcm igb snd_timer snd aesni_intel soundcore hwmon aes_x86_64 i2c_algo_bit a=
hci mpt3sas crypto_simd i2c_core libahci glue_helper mptsas raid_class liba=
ta mptscsih scsi_transport_sas mptbase scsi_mod wmi button unix
> [2692.737388] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G        W        4.=
15.14 #1
> [2692.737388] Hardware name: Dell Inc. Precision T5610/0WN7Y6, BIOS A16 0=
2/05/2018
> [2692.737388] RIP: 0010:__blk_end_request_all+0x50/0x60
> [2692.737388] RSP: 0018:ffff8806b7a03df8 EFLAGS: 00010002
> [2692.737388] RAX: 0000000000000001 RBX: ffff8806ac4f6950 RCX: 0000000000=
000000
> [2692.737388] RDX: 0000000000000001 RSI: ffff8806ac36a480 RDI: 0000000000=
000000
> [2692.737388] RBP: 0000000000000001 R08: 0000000000000000 R09: ffff8806aa=
4a9d80
> [2692.737388] R10: ffff8806ab949088 R11: 0000000000000000 R12: ffff8806aa=
4a9c00
> [2692.737388] R13: ffff8806ac4f6950 R14: 0000000000000246 R15: ffff8806ac=
4f6950
> [2692.737388] FS:  0000000000000000(0000) GS:ffff8806b7a00000(0000) knlGS=
:0000000000000000
> [2692.737388] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [2692.737388] CR2: 00007f1359a8b756 CR3: 0000000001c09003 CR4: 0000000000=
1606e0
> [2692.737388] Call Trace:
> [2692.737388]  <IRQ>
> [2692.737388]  ? blk_peek_request+0x173/0x220
> [2692.737388]  ? scsi_request_fn+0x2b/0x510 [scsi_mod]
> [2692.737388]  ? __blk_run_queue+0x34/0x50
> [2692.737388]  ? blk_run_queue+0x26/0x40
> [2692.737388]  ? scsi_run_queue+0x229/0x2b0 [scsi_mod]
> [2692.737388]  ? scsi_io_completion+0x3ce/0x5a0 [scsi_mod]
> [2692.737388]  ? blk_done_softirq+0x67/0x80
> [2692.737388]  ? __do_softirq+0xdb/0x1dd
> [2692.737388]  ? irq_exit+0xa3/0xb0
> [2692.737388]  ? do_IRQ+0x45/0xc0
> [2692.737388]  ? common_interrupt+0x77/0x77
> [2692.737388]  </IRQ>
> [2692.737388]  ? cpuidle_enter_state+0x124/0x200
> [2692.737388]  ? cpuidle_enter_state+0x119/0x200
> [2692.737388]  ? do_idle+0xdc/0x180
> [2692.737388]  ? cpu_startup_entry+0x14/0x20
> [2692.737388]  ? secondary_startup_64+0xa5/0xb0
> [2692.737388] Code: ff ff ff 84 c0 75 24 c3 0f 0b 48 8b 87 40 01 00 00 31=
 c9 48 85 c0 74 df 8b 48 58 40 0f b6 f6 8b 57 58 e8 04 ff ff ff 84 c0 74 dc=
 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 41 54 55 53 48
> [2692.737388] RIP: __blk_end_request_all+0x50/0x60 RSP: ffff8806b7a03df8
> [2692.737388] ---[ end trace 9801970f9b249e11 ]---
> [2692.737388] Kernel panic - not syncing: Fatal exception in interrupt
> [2692.737388] Kernel Offset: disabled
> [2692.737388] ---[ end Kernel panic - not syncing: Fatal exception in int=
errupt



--=20
Thanks,
//richard

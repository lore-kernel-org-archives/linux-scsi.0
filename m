From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sun, 1 Apr 2018 12:36:05 -0400
Message-ID: <20180401163604.GB25011@animx.eu.org>
References: <20180331015903.GA29398@animx.eu.org>
 <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
 <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180401113721.GA8471@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Wakko Warner wrote:
> Bart Van Assche wrote:
> > On Sat, 2018-03-31 at 18:12 -0400, Wakko Warner wrote:
> > > Richard Weinberger wrote:
> > > > On Sat, Mar 31, 2018 at 3:59 AM, Wakko Warner <wakko@animx.eu.org> wrote:
> > > > > I reported this before but noone responded.
> > > > 
> > > > Because you're sending only to LKML.
> > > > CC'ing storage folks.
> > > 
> > > Thank you.  I wasn't sure who I needed to send it to.
> > 
> > Can you share the output of lsscsi? I would like to know whether or not you
> > are using a (S)ATA CDROM.
> 
> >From the target:
> [4:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr0 
> [5:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr1 
> [6:0:0:0]    cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr2 
> 
> >From the initiator:
> [19:0:0:0]   cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr1
> [19:0:0:1]   cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr2
> [19:0:0:2]   cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr3
> 
> 
> I tested 4.14.32 last night with the same oops.  4.9.91 works fine.
> >From the initiator, if I do cat /dev/sr1 > /dev/null it works.  If I mount
> /dev/sr1 and then do find -type f | xargs cat > /dev/null the target
> crashes.  I'm using the builtin iscsi target with pscsi.  I can burn from
> the initiator with out problems.  I'll test other kernels between 4.9 and
> 4.14.

So I've tested 4.x.y where x one of 10 11 12 14 15 and y is the latest patch
(except for 4.15 which was 1 behind)
Each of these kernels crash within seconds or immediate of doing find -type
f | xargs cat > /dev/null from the initiator.

I did a diff between 4.9.91 and 4.10.17 on scsi_lib.c.  Here's the
difference around the line reported (in this case 1043).  I've added the
4.10.17 oops at the end:

@@ -1029,10 +1038,10 @@ int scsi_init_io(struct scsi_cmnd *cmd)
        struct scsi_device *sdev = cmd->device;
        struct request *rq = cmd->request;
        bool is_mq = (rq->mq_ctx != NULL);
-       int error;
+       int error = BLKPREP_KILL;
 
-       if (WARN_ON_ONCE(!rq->nr_phys_segments))
-               return -EINVAL;
+       if (WARN_ON_ONCE(!blk_rq_nr_phys_segments(rq)))
+               goto err_exit;
 
        error = scsi_init_sgtable(rq, &cmd->sdb);
        if (error)

Oops:
[ 158.157590] ------------[ cut here ]------------
[ 158.157601] WARNING: CPU: 0 PID: 0 at /usr/src/linux/dist/4.10.17-nobklcd/drivers/scsi/scsi_lib.c:1043 scsi_init_io+0x1d7/0x1e0 [scsi_mod]
[ 158.157603] Modules linked in: iscsi_target_mod tcm_loop af_packet vhost_scsi vhost target_core_file target_core_iblock target_core_pscsi target_core_mod nfsd exportfs dummy bridge stp llc ib_iser rdma_cm iw_cm ib_cm ib_core ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi netconsole configfs sr_mod cdrom sd_mod sg adt7475 hwmon_vid coretemp x86_pkg_temp_thermal kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc snd_hda_codec_realtek snd_hda_codec_generic nouveau video led_class drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm drm agpgart snd_hda_intel snd_hda_codec snd_hda_core mptsas snd_pcm_oss snd_mixer_oss mptscsih mpt3sas snd_pcm mptbase snd_timer raid_class aesni_intel snd scsi_tran
 sport_sas
[ 158.157634]  igb soundcore aes_x86_64 crypto_simd ahci glue_helper libahci hwmon libata i2c_algo_bit i2c_core scsi_mod wmi hed button unix
[ 158.157642] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.17 #1
[ 158.157644] Hardware name: Dell Inc. Precision T5610/0WN7Y6, BIOS A16 02/05/2018
[ 158.157645] Call Trace:
[ 158.157647]  <IRQ>
[ 158.157651]  ? dump_stack+0x46/0x5a
[ 158.157653]  ? __warn+0xb4/0xd0
[ 158.157656]  ? scsi_init_io+0x1d7/0x1e0 [scsi_mod]
[ 158.157658]  ? scsi_setup_cmnd+0x4c/0x140 [scsi_mod]
[ 158.157661]  ? scsi_prep_fn+0xe3/0x170 [scsi_mod]
[ 158.157663]  ? swiotlb_unmap_sg_attrs+0x44/0x60
[ 158.157665]  ? blk_peek_request+0x130/0x200
[ 158.157668]  ? scsi_request_fn+0x2b/0x510 [scsi_mod]
[ 158.157670]  ? __blk_run_queue+0x2a/0x40
[ 158.157672]  ? blk_run_queue+0x1c/0x30
[ 158.157675]  ? scsi_run_queue+0x229/0x2b0 [scsi_mod]
[ 158.157677]  ? scsi_io_completion+0x3d6/0x5c0 [scsi_mod]
[ 158.157680]  ? blk_done_softirq+0x67/0x80
[ 158.157682]  ? __do_softirq+0xdb/0x200
[ 158.157683]  ? irq_exit+0xa3/0xb0
[ 158.157686]  ? do_IRQ+0x45/0xc0
[ 158.157689]  ? common_interrupt+0x7c/0x7c
[ 158.157690]  </IRQ>
[ 158.157693]  ? cpuidle_enter_state+0x144/0x1f0
[ 158.157694]  ? cpuidle_enter_state+0x139/0x1f0
[ 158.157696]  ? do_idle+0xd3/0x190
[ 158.157698]  ? cpu_startup_entry+0x14/0x20
[ 158.157700]  ? start_kernel+0x391/0x399
[ 158.157701]  ? start_cpu+0x14/0x14
[ 158.157703] ---[ end trace 8d60c2e92fac2697 ]---
[ 158.157711] ------------[ cut here ]------------
[ 158.157732] kernel BUG at /usr/src/linux/dist/4.10.17-nobklcd/block/blk-core.c:2916!
[ 158.157755] invalid opcode: 0000 [#1] PREEMPT SMP
[ 158.157770] Modules linked in: iscsi_target_mod tcm_loop af_packet vhost_scsi vhost target_core_file target_core_iblock target_core_pscsi target_core_mod nfsd exportfs dummy bridge stp llc ib_iser rdma_cm iw_cm ib_cm ib_core ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi netconsole configfs sr_mod cdrom sd_mod sg adt7475 hwmon_vid coretemp x86_pkg_temp_thermal kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc snd_hda_codec_realtek snd_hda_codec_generic nouveau video led_class drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm drm agpgart snd_hda_intel snd_hda_codec snd_hda_core mptsas snd_pcm_oss snd_mixer_oss mptscsih mpt3sas snd_pcm mptbase snd_timer raid_class aesni_intel snd scsi_tran
 sport_sas
[ 158.157968]  igb soundcore aes_x86_64 crypto_simd ahci glue_helper libahci hwmon libata i2c_algo_bit i2c_core scsi_mod wmi hed button unix
[ 158.158005] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.10.17 #1
[ 158.158024] Hardware name: Dell Inc. Precision T5610/0WN7Y6, BIOS A16 02/05/2018
[ 158.158045] task: ffffffff8180e4c0 task.stack: ffffffff81800000
[ 158.158063] RIP: 0010:__blk_end_request_all+0x2a/0x30
[ 158.158077] RSP: 0018:ffff8806b7803df0 EFLAGS: 00010002
[ 158.158093] RAX: 0000000000000001 RBX: ffff8806abfdb2f0 RCX: 0000000000000000
[ 158.158113] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8806abfdb2f0
[ 158.158134] RBP: ffff8806accb28d0 R08: 0000000000000000 R09: 0000000000000000
[ 158.158153] R10: ffffffff81806a40 R11: 0000000000000000 R12: 00000000ffffff87
[ 158.158173] R13: 00000000fffffffb R14: 00000000fffffffb R15: 0000000000000000
[ 158.158193] FS:  0000000000000000(0000) GS:ffff8806b7800000(0000) knlGS:0000000000000000
[ 158.158215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 158.158231] CR2: 00007ffdeb1091b8 CR3: 0000000001809000 CR4: 00000000001406f0
[ 158.158250] Call Trace:
[ 158.158258]  <IRQ>
[ 158.158265]  ? blk_peek_request+0x16b/0x200
[ 158.158279]  ? scsi_request_fn+0x2b/0x510 [scsi_mod]
[ 158.158294]  ? __blk_run_queue+0x2a/0x40
[ 158.158306]  ? blk_run_queue+0x1c/0x30
[ 158.158319]  ? scsi_run_queue+0x229/0x2b0 [scsi_mod]
[ 158.158334]  ? scsi_io_completion+0x3d6/0x5c0 [scsi_mod]
[ 158.158350]  ? blk_done_softirq+0x67/0x80
[ 158.158362]  ? __do_softirq+0xdb/0x200
[ 158.158374]  ? irq_exit+0xa3/0xb0
[ 158.158384]  ? do_IRQ+0x45/0xc0
[ 158.158394]  ? common_interrupt+0x7c/0x7c
[ 158.158407]  </IRQ>
[ 158.158415]  ? cpuidle_enter_state+0x144/0x1f0
[ 158.158429]  ? cpuidle_enter_state+0x139/0x1f0
[ 158.158443]  ? do_idle+0xd3/0x190
[ 158.158453]  ? cpu_startup_entry+0x14/0x20
[ 158.158466]  ? start_kernel+0x391/0x399
[ 158.158478]  ? start_cpu+0x14/0x14
[ 158.158488] Code: 00 48 8b 87 70 01 00 00 31 c9 48 85 c0 75 0d 8b 57 58 e8 1a ff ff ff 84 c0 75 10 c3 8b 48 58 8b 57 58 e8 0a ff ff ff 84 c0 74 f0 <0f> 0b 0f 1f 40 00 41 56 41 55 41 bd fb ff ff ff 41 54 41 bc 87 
[ 158.158550] RIP: __blk_end_request_all+0x2a/0x30 RSP: ffff8806b7803df0
[ 158.161579] ---[ end trace 8d60c2e92fac2698 ]---
[ 158.161579] Kernel panic - not syncing: Fatal exception in interrupt
[ 158.161579] Kernel Offset: disabled
[ 158.161579] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.

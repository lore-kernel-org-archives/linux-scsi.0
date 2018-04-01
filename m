From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sun, 1 Apr 2018 14:27:23 -0400
Message-ID: <20180401182723.GA31755@animx.eu.org>
References: <20180331015903.GA29398@animx.eu.org>
 <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
 <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
 <20180401163604.GB25011@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180401163604.GB25011@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Wakko Warner wrote:
> Wakko Warner wrote:
> > Bart Van Assche wrote:
> > > On Sat, 2018-03-31 at 18:12 -0400, Wakko Warner wrote:
> > > > Richard Weinberger wrote:
> > > > > On Sat, Mar 31, 2018 at 3:59 AM, Wakko Warner <wakko@animx.eu.org> wrote:
> > > > > > I reported this before but noone responded.
> > > > > 
> > > > > Because you're sending only to LKML.
> > > > > CC'ing storage folks.
> > > > 
> > > > Thank you.  I wasn't sure who I needed to send it to.
> > > 
> > > Can you share the output of lsscsi? I would like to know whether or not you
> > > are using a (S)ATA CDROM.
> > 
> > >From the target:
> > [4:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr0 
> > [5:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr1 
> > [6:0:0:0]    cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr2 
> > 
> > >From the initiator:
> > [19:0:0:0]   cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr1
> > [19:0:0:1]   cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr2
> > [19:0:0:2]   cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr3
> > 
> > 
> > I tested 4.14.32 last night with the same oops.  4.9.91 works fine.
> > >From the initiator, if I do cat /dev/sr1 > /dev/null it works.  If I mount
> > /dev/sr1 and then do find -type f | xargs cat > /dev/null the target
> > crashes.  I'm using the builtin iscsi target with pscsi.  I can burn from
> > the initiator with out problems.  I'll test other kernels between 4.9 and
> > 4.14.
> 
> So I've tested 4.x.y where x one of 10 11 12 14 15 and y is the latest patch
> (except for 4.15 which was 1 behind)
> Each of these kernels crash within seconds or immediate of doing find -type
> f | xargs cat > /dev/null from the initiator.

I tried 4.10.0.  It doesn't completely lockup the system, but the device
that was used hangs.  So from the initiator, it's /dev/sr1 and from the
target it's /dev/sr0.  Attempting to read /dev/sr0 after the oops causes the
process to hang in D state.

Here's the oops.  There was also another line that was not seen in the newer
kernels.
[ 323.105044] ------------[ cut here ]------------
[ 323.105057] WARNING: CPU: 0 PID: 0 at /usr/src/linux/dist/4.10/drivers/scsi/scsi_lib.c:1043 scsi_init_io+0x143/0x1f0 [scsi_mod]
[ 323.105058] Modules linked in: iscsi_target_mod af_packet tcm_loop vhost_scsi vhost target_core_file target_core_iblock target_core_pscsi target_core_mod nfsd exportfs dummy bridge stp llc ib_iser rdma_cm iw_cm ib_cm ib_core ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi netconsole configfs sr_mod cdrom sd_mod sg adt7475 hwmon_vid coretemp x86_pkg_temp_thermal kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc snd_hda_codec_realtek snd_hda_codec_generic nouveau video led_class drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm drm snd_hda_intel agpgart snd_hda_codec snd_hda_core snd_pcm_oss igb snd_mixer_oss aesni_intel snd_pcm aes_x86_64 hwmon snd_timer crypto_simd i2c_algo_bit mptsas snd
  glue_helper
[ 323.105089]  mpt3sas i2c_core mptscsih soundcore ahci mptbase raid_class libahci scsi_transport_sas libata scsi_mod button wmi hed unix
[ 323.105097] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0 #1
[ 323.105098] Hardware name: Dell Inc. Precision T5610/0WN7Y6, BIOS A16 02/05/2018
[ 323.105100] Call Trace:
[ 323.105101]  <IRQ>
[ 323.105105]  ? dump_stack+0x46/0x5a
[ 323.105107]  ? __warn+0xb4/0xd0
[ 323.105110]  ? scsi_init_io+0x143/0x1f0 [scsi_mod]
[ 323.105113]  ? scsi_setup_cmnd+0x4c/0x140 [scsi_mod]
[ 323.105115]  ? scsi_prep_fn+0xe3/0x170 [scsi_mod]
[ 323.105118]  ? swiotlb_unmap_sg_attrs+0x44/0x60
[ 323.105119]  ? blk_peek_request+0x130/0x200
[ 323.105122]  ? scsi_request_fn+0x2b/0x510 [scsi_mod]
[ 323.105124]  ? __blk_run_queue+0x2a/0x40
[ 323.105126]  ? blk_run_queue+0x1c/0x30
[ 323.105129]  ? scsi_run_queue+0x229/0x2b0 [scsi_mod]
[ 323.105131]  ? scsi_io_completion+0x3d6/0x5c0 [scsi_mod]
[ 323.105133]  ? blk_done_softirq+0x67/0x80
[ 323.105135]  ? __do_softirq+0xdb/0x200
[ 323.105137]  ? irq_exit+0xa3/0xb0
[ 323.105139]  ? do_IRQ+0x45/0xc0
[ 323.105141]  ? common_interrupt+0x7c/0x7c
[ 323.105142]  </IRQ>
[ 323.105145]  ? cpuidle_enter_state+0x144/0x1f0
[ 323.105146]  ? cpuidle_enter_state+0x139/0x1f0
[ 323.105148]  ? do_idle+0xd3/0x190
[ 323.105150]  ? cpu_startup_entry+0x14/0x20
[ 323.105152]  ? start_kernel+0x391/0x399
[ 323.105154]  ? start_cpu+0x14/0x14
[ 323.105155] ---[ end trace f38cc734e4921bdc ]---
[ 323.105157] blk_peek_request: bad return=-22

From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Wed, 18 Jul 2007 10:33:20 -0700
Message-ID: <20070718103320.4b6ad7b3.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
	<20070712135750.2a4a4a54.rdunlap@xenotime.net>
	<469B38CC.50501@panasas.com>
	<20070717171607.ffc278eb.rdunlap@xenotime.net>
	<469DDD74.2060208@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__18_Jul_2007_10_33_20_-0700_KWTQzV_fETVsXbn+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:50262 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755836AbXGRR3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 13:29:04 -0400
Received: from midway.site ([71.117.236.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 10:28:57 -0700
In-Reply-To: <469DDD74.2060208@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Wed__18_Jul_2007_10_33_20_-0700_KWTQzV_fETVsXbn+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Jul 2007 12:29:24 +0300 Boaz Harrosh wrote:

> Randy Dunlap wrote:
> > On Mon, 16 Jul 2007 12:22:20 +0300 Boaz Harrosh wrote:
> > 
> >> If you could do some testing it is grate. The first 3 patches do not
> >> need scsi-misc specifically. Any post 2.6.20 tree will do. The last patch
> >> could be done together with attached patch on any 2.6.22 tree.
> >> (Apply attached patch anywhere before the last patch (4/4) of the patchset)
> >> Though I do recommend scsi-misc tree.
> > 
> > I took 2.6.22, backed out Christoph's aha152x.c patch (using
> > completion for timeouts), added your 5 patches, and then tested.
> > Does that sound OK?
> > 
> Yes what you did is perfect
> I was not aware of "Christoph's aha152x.c patch" is that in scsi-misc?
> I'm almost positive I did a git-pull before I sent the patches.
> Sorry about that.
> 
> >> Testing:
> > 
> > I booted/tested 4 times.  2 Oopsen and 2 of
> > could-never-mount-the-device-due-to-reset-problems.
> > Log is attached.
> > 
> > 
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> Thank you for testing and helping me with this.
> 
> I found one thing that should definitely trash the Reset
> and do funny things. But I'm not sure it is it at all.
> If below does not work, could you pleas do a small bisect
> of my patches.
> 
> first patch first, than 2nd, 3rd ,accessors thing, and 4th 

Hi,

I don't see the reset problem after applying this patch, but I'm
still seeing an Oops in datao_run.  Log is attached.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--Multipart=_Wed__18_Jul_2007_10_33_20_-0700_KWTQzV_fETVsXbn+
Content-Type: text/x-log;
 name="aha15-reset.log"
Content-Disposition: attachment;
 filename="aha15-reset.log"
Content-Transfer-Encoding: 7bit

Jul 18 09:11:24 dragon kernel: klogd 1.4.1, log source = /proc/kmsg started.
Jul 18 09:11:24 dragon kernel: [   22.360000] Adding 2104472k swap on /dev/sda6.  Priority:-1 extents:1 across:2104472k
Jul 18 09:18:22 dragon kernel: [  472.804000] SysRq : Changing Loglevel
Jul 18 09:18:22 dragon kernel: [  472.804000] Loglevel set to 9
Jul 18 09:18:26 dragon kernel: [  476.380000] pccard: PCMCIA card inserted into slot 0
Jul 18 09:18:26 dragon kernel: [  476.380000] cs: memory probe 0xdfc00000-0xdfcfffff: excluding 0xdfc00000-0xdfc0ffff 0xdfcf0000-0xdfcfffff
Jul 18 09:18:26 dragon kernel: [  476.384000] pcmcia: registering new device pcmcia0.0
Jul 18 09:18:27 dragon kernel: [  476.536000] aha152x: resetting bus...
Jul 18 09:18:27 dragon kernel: [  476.892000] aha152x2: vital data: rev=1, io=0x2340 (0x2340/0x2340), irq=3, scsiid=7, reconnect=enabled, parity=enabled, synchronous=enabled, delay=100, extended translation=disabled
Jul 18 09:18:28 dragon kernel: [  476.892000] aha152x2: trying software interrupt, ok.
Jul 18 09:18:28 dragon kernel: [  477.900000] scsi2 : Adaptec 152x SCSI driver; $Revision: 2.7 $
Jul 18 09:18:29 dragon kernel: [  478.956000] (scsi2:4:0) Synchronous Data Transfer Request period = 200 ns offset = 8 
Jul 18 09:18:29 dragon kernel: [  478.956000] scsi 2:0:4:0: Direct-Access     iomega   jaz 2GB          E.17 PQ: 0 ANSI: 2
Jul 18 09:18:32 dragon udevd-event[6207]: wait_for_sysfs: waiting for '/sys/devices/platform/host2/target2:0:4/2:0:4:0/ioerr_cnt' failed
Jul 18 09:18:38 dragon kernel: [  478.960000] sd 2:0:4:0: [sdb] Spinning up disk............ready
Jul 18 09:18:38 dragon kernel: [  488.000000] sd 2:0:4:0: [sdb] 2091050 512-byte hardware sectors (1071 MB)
Jul 18 09:18:38 dragon kernel: [  488.004000] sd 2:0:4:0: [sdb] Write Protect is off
Jul 18 09:18:38 dragon kernel: [  488.004000] sd 2:0:4:0: [sdb] Mode Sense: 39 00 10 08
Jul 18 09:18:38 dragon kernel: [  488.008000] sd 2:0:4:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jul 18 09:18:38 dragon kernel: [  488.012000] sd 2:0:4:0: [sdb] 2091050 512-byte hardware sectors (1071 MB)
Jul 18 09:18:38 dragon kernel: [  488.012000] sd 2:0:4:0: [sdb] Write Protect is off
Jul 18 09:18:38 dragon kernel: [  488.012000] sd 2:0:4:0: [sdb] Mode Sense: 39 00 10 08
Jul 18 09:18:38 dragon kernel: [  488.016000] sd 2:0:4:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jul 18 09:18:38 dragon kernel: [  488.016000]  sdb: sdb4
Jul 18 09:18:38 dragon kernel: [  488.048000] sd 2:0:4:0: [sdb] Attached SCSI removable disk
Jul 18 09:18:38 dragon kernel: [  488.052000] sd 2:0:4:0: Attached scsi generic sg2 type 0
Jul 18 09:18:38 dragon kernel: [  488.624000] pcmcia: Detected deprecated PCMCIA ioctl usage from process: hald.
Jul 18 09:18:38 dragon kernel: [  488.624000] pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
Jul 18 09:18:38 dragon kernel: [  488.624000] pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
Jul 18 09:19:13 dragon kernel: [  523.408000] kjournald starting.  Commit interval 5 seconds
Jul 18 09:19:13 dragon kernel: [  523.408000] EXT3-fs warning: checktime reached, running e2fsck is recommended
Jul 18 09:19:13 dragon kernel: [  523.492000] EXT3 FS on sdb4, internal journal
Jul 18 09:19:13 dragon kernel: [  523.492000] EXT3-fs: recovery complete.
Jul 18 09:19:13 dragon kernel: [  523.556000] EXT3-fs: mounted filesystem with ordered data mode.
Jul 18 09:20:18 dragon kernel: [  588.000000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
Jul 18 09:20:18 dragon kernel: [  588.000000]  printing eip:
Jul 18 09:20:18 dragon kernel: [  588.000000] f8879284
Jul 18 09:20:18 dragon kernel: [  588.000000] *pde = 00000000
Jul 18 09:20:18 dragon kernel: [  588.000000] Oops: 0000 [#1]
Jul 18 09:20:18 dragon kernel: [  588.000000] SMP 
Jul 18 09:20:18 dragon kernel: [  588.000000] Modules linked in: aha152x_cs loop sr_mod yenta_socket rsrc_nonstatic pcmcia pcmcia_core ipw2200
Jul 18 09:20:18 dragon kernel: [  588.000000] CPU:    0
Jul 18 09:20:18 dragon kernel: [  588.000000] EIP:    0060:[<f8879284>]    Not tainted VLI
Jul 18 09:20:18 dragon kernel: [  588.000000] EFLAGS: 00010206   (2.6.22 #4)
Jul 18 09:20:18 dragon kernel: [  588.000000] EIP is at datao_run+0xd1/0x1f3 [aha152x_cs]
Jul 18 09:20:18 dragon kernel: [  588.000000] eax: c271abe0   ebx: c27078f4   ecx: 00000040   edx: 00002356
Jul 18 09:20:18 dragon kernel: [  588.000000] esi: 00000000   edi: 00000040   ebp: c252bf28   esp: c252bef4
Jul 18 09:20:18 dragon kernel: [  588.000000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Jul 18 09:20:18 dragon kernel: [  588.000000] Process events/0 (pid: 6, ti=c252a000 task=c2506030 task.ti=c252a000)
Jul 18 09:20:18 dragon kernel: [  588.000000] Stack: 00000282 c27078f4 c252bf28 f8878ce8 c24d8558 00000000 c2707560 00002340 
Jul 18 09:20:18 dragon kernel: [  588.000000]        c24ded90 00000286 c27078f4 00000001 00000000 c252bf64 f8877332 000001f4 
Jul 18 09:20:18 dragon kernel: [  588.000000]        c2405b20 c252bf48 c0126a7d c24db680 0000234c c2707560 00011940 00000001 
Jul 18 09:20:18 dragon kernel: [  588.000000] Call Trace:
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c0103553>] show_trace_log_lvl+0x1a/0x2f
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c0103605>] show_stack_log_lvl+0x9d/0xa5
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c01037d0>] show_registers+0x1c3/0x295
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c01039b3>] die+0x111/0x213
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c033adc8>] do_page_fault+0x43c/0x50f
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c033975a>] error_code+0x72/0x78
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<f8877332>] run+0x378/0x450 [aha152x_cs]
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c0126322>] run_workqueue+0x80/0x105
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c0126bfd>] worker_thread+0xcb/0xd6
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c01291a5>] kthread+0x3b/0x62
Jul 18 09:20:18 dragon kernel: [  588.000000]  [<c01031ef>] kernel_thread_helper+0x7/0x10
Jul 18 09:20:18 dragon kernel: [  588.000000]  =======================
Jul 18 09:20:18 dragon kernel: [  588.000000] Code: 40 03 00 00 83 c2 12 ee 83 fe 01 7e 44 8b 43 04 89 f7 d1 ff 89 f9 8b 90 f8 00 00 00 89 55 e0 8b 93 40 03 00 00 8b 75 e0 83 c2 16 <f3> 66 6f 8b 75 e0 8d 14 3f 6b cf fe 01 d6 89 b0 f8 00 00 00 8b 
Jul 18 09:20:18 dragon kernel: [  588.000000] EIP: [<f8879284>] datao_run+0xd1/0x1f3 [aha152x_cs] SS:ESP 0068:c252bef4
Jul 18 09:20:48 dragon kernel: [  618.000000] (scsi2:4:0) cannot abort running or disconnected command
Jul 18 09:20:48 dragon kernel: [  618.000000] (scsi2:4:0) cannot reset current device
Jul 18 09:21:28 dragon kernel: [  658.016000] sd 2:0:4:0: scsi: Device offlined - not ready after error recovery
Jul 18 09:21:28 dragon kernel: [  658.016000] sd 2:0:4:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
Jul 18 09:21:28 dragon kernel: [  658.016000] end_request: I/O error, dev sdb, sector 507944
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63489
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63490
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63491
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63492
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63493
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63494
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:28 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63495
Jul 18 09:21:28 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:29 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63496
Jul 18 09:21:29 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:29 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63497
Jul 18 09:21:29 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:29 dragon kernel: [  658.016000] Buffer I/O error on device sdb4, logical block 63498
Jul 18 09:21:29 dragon kernel: [  658.016000] lost page write due to I/O error on sdb4
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] Aborting journal on device sdb4.
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Jul 18 09:21:29 dragon kernel: [  658.016000] end_request: I/O error, dev sdb, sector 524320
Jul 18 09:21:29 dragon kernel: [  658.016000] EXT3-fs error (device sdb4) in ext3_ordered_writepage: IO failure
Jul 18 09:21:29 dragon kernel: [  658.016000] ext3_abort called.
Jul 18 09:21:29 dragon kernel: [  658.016000] EXT3-fs error (device sdb4): ext3_journal_start_sb: Detected aborted journal
Jul 18 09:21:29 dragon kernel: [  658.016000] Remounting filesystem read-only
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device
Jul 18 09:21:29 dragon kernel: [  658.016000] sd 2:0:4:0: rejecting I/O to offline device

--Multipart=_Wed__18_Jul_2007_10_33_20_-0700_KWTQzV_fETVsXbn+--

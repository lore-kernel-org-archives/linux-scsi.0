From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: qlogicpti driver hangs the machine
Date: Tue, 23 Sep 2008 09:59:18 -0600
Message-ID: <20080923155917.GE27204@parisc-linux.org>
References: <Pine.SOC.4.64.0809231753570.14966@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45071 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYIWP7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2008 11:59:18 -0400
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0809231753570.14966@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

On Tue, Sep 23, 2008 at 06:06:03PM +0300, Meelis Roos wrote:
> I tried to use Qlogic wide SE SCSI SBus controllers. First tied one in 
> Sparcstation 5 (sparc32) with etch and sarge installers, then tried 
> another in E3500. Both tries on SS5 hung when loadin qlogicpti module. 
> E3500 conf doesn't autoload SBus drivers and the card was properly 
> inserted only after installation, so I tried to modprobe qlogicpti after 
> booting up. This also results in a hang but outputs that much on console 
> before hanging. Maybe the error handling spinlock lockup gives a clue to 
> someone...

What kernel version is this trace from?

> [ 3570.576359] qlogicpti0: IRQ 12 SCSI ID 7 (Firmware v1.31.32)(FCode 1.21 95/05/18)
> [ 3571.002975] qlogicpti0: [Fast Wide, using single ended interface]
> [ 3571.078001] scsi2 : PTI Qlogic,ISP SBUS SCSI irq 12 regs at 000001c520010000
> [ 3571.667582] scsi 2:0:2:0: Direct-Access     FUJITSU  M2954ESP SUN4.2G 2545 PQ: 0 ANSI: 2
> [ 3571.768584] sd 2:0:2:0: [sdg] 8385121 512-byte hardware sectors (4293 MB)
> [ 3571.852563] sd 2:0:2:0: [sdg] Write Protect is off
> [ 3571.907932] sd 2:0:2:0: [sdg] Mode Sense: 9f 00 00 08
> [ 3571.973016] sd 2:0:2:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [ 3572.082467] sd 2:0:2:0: [sdg] 8385121 512-byte hardware sectors (4293 MB)
> [ 3572.166373] sd 2:0:2:0: [sdg] Write Protect is off
> [ 3572.221718] sd 2:0:2:0: [sdg] Mode Sense: 9f 00 00 08
> [ 3572.286814] sd 2:0:2:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [ 3572.394250]  sdg: unknown partition table
> [ 3572.455839] sd 2:0:2:0: [sdg] Attached SCSI disk
> [ 3572.511006] sd 2:0:2:0: Attached scsi generic sg7 type 0
> [ 3578.075788] qlogicpti0: Aborting cmd for tgt[2] lun[0]
> [ 3578.137633] qlogicpti0: Aborting cmd for tgt[2] lun[1]
> [ 3696.467069] BUG: spinlock lockup on CPU#7, scsi_eh_2/1737, fffff8004d0f8060
> [ 3696.548319] Call Trace:
> [ 3696.577498]  [0000000000590e5c] _raw_spin_lock+0xfc/0x160
> [ 3696.642105]  [000000000069dc5c] _spin_lock_irqsave+0x1c/0x40
> [ 3696.709816]  [00000000005d5090] scsi_send_eh_cmnd+0x70/0x280
> [ 3696.777530]  [00000000005d52c4] scsi_eh_tur+0x24/0xa0
> [ 3696.837958]  [00000000005d5f8c] scsi_error_handler+0x2cc/0x3c0
> [ 3696.907783]  [000000000047676c] kthread+0x4c/0x80
> [ 3696.964032]  [000000000042707c] kernel_thread+0x3c/0x60
> [ 3697.026543]  [0000000000476694] kthreadd+0x174/0x200
> [ 3697.086064]   CPU[  6]: TSTATE[0000009980009602] TPC[000000000069dc40] TNPC[000000000069dc44] TASK[NULL:-1]
> [ 3697.202709]              TPC[_spin_lock_irqsave+0x0/0x40] O7[complete+0x14/0x60] I7[scsi_eh_done+0x24/0x40] RPC[qpti_intr+0]
> [ 3697.359973] * CPU[  7]: TSTATE[0000000080009625] TPC[0000000000427074] TNPC[0000000000427078] TASK[scsi_eh_2:1737]
> [ 3697.483975]              TPC[kernel_thread+0x34/0x60] O7[kernel_thread+0x8/0x60] I7[kthreadd+0x174/0x200] RPC[0x0]
> 
> -- 
> Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

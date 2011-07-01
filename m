From: Roland Dreier <roland@kernel.org>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Fri, 1 Jul 2011 11:07:10 -0700
Message-ID: <CAL1RGDVFR5eYHOX-jiUrU4_Ezw19FzNcCcyo0qKNYictK5He5g@mail.gmail.com>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com> <1308242275.2436.56.camel@mulgrave>
 <20110616184023.GA2362@osiris.boeblingen.de.ibm.com> <20110620153021.GA2572@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:32962 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751874Ab1GASHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2011 14:07:31 -0400
Received: by mail-qy0-f180.google.com with SMTP id 30so2988986qyk.18
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2011 11:07:30 -0700 (PDT)
In-Reply-To: <20110620153021.GA2572@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

We seem to be hitting something similar, running 2.6.39.2.
Did anyone make any progress on this?  (I'm happy to try and
gather more info but I probably won't be able to seriously
debug until next week)

Anyway, we have a system with two mpt2sas adapters that
have 4 paths to a JBOD, and we're using dm-multipath to the
drives in the JBOD.  Killing one of the drives (ie yanking the
drive, so all 4 paths go down at once) leads nearly instantly to:

[  768.999560] device-mapper: multipath: Failing path 8:48.
[  769.005151] device-mapper: multipath: Failing path 8:48.
[  769.010919] device-mapper: table: 252:4: multipath: error getting device
[  769.017708] device-mapper: ioctl: error adding target to table
[  769.023696] device-mapper: multipath: Failing path 8:48.
[  769.030979] BUG: unable to handle kernel paging request at 0000000200000000
[  769.038119] IP: [<0000000200000000>] 0x1ffffffff
[  769.042859] PGD 0
[  769.045264] Oops: 0010 [#1] SMP
[  769.048671] last sysfs file:
/sys/devices/pci0000:00/0000:00:07.0/0000:09:00.0/host11/port-11:0/expander-11:0/port-11:0:1/end_device-11:0:1/target11:0:1/11:0:1:0/block/sdd/uevent
[  769.064690] CPU 6
[  769.066835] Modules linked in: target_core_pscsi target_core_file
target_core_iblock tcm_loop target_core_mod configfs ps_bdrv
ipmi_devintf ipmi_si ipmi_msghandler serio_raw ioatdma i7core_edac dca
edac_core ses enclosure usb_storage mpt2sas qla2xxx usbhid
scsi_transport_sas ahci uas scsi_transport_fc libahci e1000e hid
mlx4_core scsi_tgt raid_class [last unloaded: evbug]
[  769.102323]
[  769.104141] Pid: 30, comm: kworker/6:0 Not tainted 2.6.39.2+ #1
Xyratex Storage Server        /HS-1235T-ATX
[  769.116224] RIP: 0010:[<0000000200000000>]  [<0000000200000000>] 0x1ffffffff
[  769.123679] RSP: 0018:ffff880c1b1a1cc8  EFLAGS: 00010082
[  769.129317] RAX: ffff8806165cc780 RBX: ffff880614cd06c0 RCX: 0000000000000000
[  769.136808] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff880614cd06c0
[  769.144298] RBP: ffff880c1b1a1ce0 R08: 0000000000000000 R09: 0000000000000001
[  769.151789] R10: ffff880c0ecd2af0 R11: ffff880619b40400 R12: ffff880614cd06c0
[  769.159279] R13: 0000000000000002 R14: 0000000000000002 R15: ffff880614cd4010
[  769.166770] FS:  0000000000000000(0000) GS:ffff880c3fc00000(0000)
knlGS:0000000000000000
[  769.175210] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  769.181284] CR2: 0000000200000000 CR3: 0000000001a03000 CR4: 00000000000006e0
[  769.188772] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  769.196254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  769.203746] Process kworker/6:0 (pid: 30, threadinfo
ffff880c1b1a0000, task ffff880c1b1996b0)
[  769.212617] Stack:
[  769.214694]  ffffffff8123290a ffff880c19d54338 ffff880c19d54338
ffff880c1b1a1d10
[  769.222669]  ffffffff81232a63 ffff880c19d54338 ffff880614cd06c0
0000000000000002
[  769.230636]  ffffc900189b7040 ffff880c1b1a1d40 ffffffff812357ad
ffff880c1b1a1d60
[  769.238600] Call Trace:
[  769.241118]  [<ffffffff8123290a>] ? elv_drain_elevator+0x2a/0x80
[  769.247452]  [<ffffffff81232a63>] __elv_add_request+0x103/0x280
[  769.253697]  [<ffffffff812357ad>] add_acct_request+0x3d/0x50
[  769.259680]  [<ffffffff81235825>] blk_insert_cloned_request+0x65/0x90
[  769.266449]  [<ffffffff813b332e>] dm_dispatch_request+0x3e/0x70
[  769.272692]  [<ffffffff813b4e3b>] dm_request_fn+0x16b/0x240
[  769.278588]  [<ffffffff81237300>] ? perf_trace_block_unplug+0xe0/0xe0
[  769.285353]  [<ffffffff81237340>] blk_delay_work+0x40/0x60
[  769.291218]  [<ffffffff8106954a>] process_one_work+0x11a/0x420
[  769.297375]  [<ffffffff8106a5a3>] worker_thread+0x163/0x340
[  769.303274]  [<ffffffff8106a440>] ? manage_workers.clone.21+0x240/0x240
[  769.310212]  [<ffffffff8106f2d6>] kthread+0x96/0xa0
[  769.315421]  [<ffffffff814de1a4>] kernel_thread_helper+0x4/0x10
[  769.321662]  [<ffffffff8106f240>] ? kthread_worker_fn+0x190/0x190
[  769.328079]  [<ffffffff814de1a0>] ? gs_change+0x13/0x13
[  769.333632] Code:  Bad RIP value.

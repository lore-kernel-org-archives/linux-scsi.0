From: Roland Dreier <roland@kernel.org>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Tue, 5 Jul 2011 17:34:16 -0700
Message-ID: <CAG4TOxM=-8P495xSNvySOhOcKwqCNun99SNmkC1LTUon4jQxXQ@mail.gmail.com>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com> <1308242275.2436.56.camel@mulgrave>
 <20110616184023.GA2362@osiris.boeblingen.de.ibm.com> <20110620153021.GA2572@osiris.boeblingen.de.ibm.com>
 <CAL1RGDVFR5eYHOX-jiUrU4_Ezw19FzNcCcyo0qKNYictK5He5g@mail.gmail.com> <1309547081.2722.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48794 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1GFAeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2011 20:34:36 -0400
Received: by iwn6 with SMTP id 6so5654973iwn.19
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jul 2011 17:34:36 -0700 (PDT)
In-Reply-To: <1309547081.2722.33.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Fri, Jul 1, 2011 at 12:04 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> The first obvious question is does it reproduce with git HEAD? =A0If =
yes,
> then it's an unfixed reference bug, if no, we forgot to backport the =
fix
> (we should be able to find it easily enough).

Hi James,

Yes, I'm able to reproduce with v3.0-rc5-170-gba466c7.

I booted with slub_debug=3DFZUP and the 6b pattern in RAX pretty much
does prove that this is a use-after-free issue.  Any thoughts about
how to pin this down before I muddle on in my lowbrow way?

    general protection fault: 0000 [#1] SMP
    CPU 7
    Modules linked in: kvm_intel kvm serio_raw i7core_edac edac_core
ioatdma dca pci_stub ses
   id usb_storage qla2xxx mpt2sas ahci hid uas libahci e1000e
scsi_transport_fc scsi_transport
    raid_class scsi_tgt

    Pid: 12458, comm: blkid Not tainted 3.0.0-rc5+ #1

    RIP: 0010:[<ffffffff81233867>]  [<ffffffff81233867>]
elv_drain_elevator+0x27/0x80
    RSP: 0018:ffff880614e9fa48  EFLAGS: 00010096
    RAX: 6b6b6b6b6b6b6b6b RBX: ffff880610bb0000 RCX: 0000000000000000
    RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff880610bb0000
    RBP: ffff880614e9fa58 R08: 0000000000000000 R09: 0000000000000001
    R10: ffff880c0a7dca70 R11: ffff880615622440 R12: ffff880610bb0000
    R13: 0000000000000002 R14: 0000000000000002 R15: ffff880c0db01160
    FS:  00007fe46457a760(0000) GS:ffff880c3fc20000(0000) knlGS:0000000=
000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007fe463c86330 CR3: 0000000c0cc0c000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process blkid (pid: 12458, threadinfo ffff880614e9e000, task
ffff8806190eae20)
    Stack:
     ffff880c0d9f03c8 ffff880c0d9f03c8 ffff880614e9fa88 ffffffff812339a=
8
     ffff880c0d9f03c8 ffff880610bb0000 0000000000000002 ffffc9001bd5e04=
0
     ffff880614e9fab8 ffffffff812366fd ffff880614e9fad8 ffff880610bb000=
0
    Call Trace:
     [<ffffffff812339a8>] __elv_add_request+0xe8/0x280
     [<ffffffff812366fd>] add_acct_request+0x3d/0x50
     [<ffffffff81236775>] blk_insert_cloned_request+0x65/0x90
     [<ffffffff813b8d4e>] dm_dispatch_request+0x3e/0x70
     [<ffffffff813ba850>] dm_request_fn+0x160/0x250
     [<ffffffff81236e88>] queue_unplugged+0x48/0xd0
     [<ffffffff8123b03d>] blk_flush_plug_list+0x1ed/0x250
     [<ffffffff810e98f0>] ? sleep_on_page+0x20/0x20
     [<ffffffff814db895>] io_schedule+0x75/0xd0
     [<ffffffff810e98fe>] sleep_on_page_killable+0xe/0x40
     [<ffffffff814dbf9a>] __wait_on_bit_lock+0x5a/0xc0
     [<ffffffff810e9857>] __lock_page_killable+0x67/0x70
     [<ffffffff8106d650>] ? autoremove_wake_function+0x40/0x40
     [<ffffffff810eb5c5>] generic_file_aio_read+0x405/0x720
     [<ffffffff81146962>] do_sync_read+0xd2/0x110
     [<ffffffff8121e393>] ? security_file_permission+0x93/0xb0
     [<ffffffff81146c81>] ? rw_verify_area+0x61/0xf0
     [<ffffffff81147143>] vfs_read+0xc3/0x180
     [<ffffffff81147251>] sys_read+0x51/0x90
     [<ffffffff814e5942>] system_call_fastpath+0x16/0x1b
    Code: c3 0f 1f 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 89
fb 0f 1f 80 00 00 00 00
    01 00 00 00 48 89 df 48 8b 00 <ff> 50 28 85 c0 75 ea 8b 93 f0 03
00 00 85 d2 74 14 8b 05 f

    RIP  [<ffffffff81233867>] elv_drain_elevator+0x27/0x80
     RSP <ffff880614e9fa48>
    ---[ end trace 5dbd03e7295023d7 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

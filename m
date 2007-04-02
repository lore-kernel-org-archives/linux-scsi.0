From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Mon, 2 Apr 2007 11:20:48 +0200
Message-ID: <20070402112048.047867c1@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
	<1175257751.3760.19.camel@mulgrave.il.steeleye.com>
	<460D12B8.6050101@gmail.com>
	<1175278774.3760.44.camel@mulgrave.il.steeleye.com>
	<20070401195943.GA29627@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070401195943.GA29627@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2 Apr 2007 04:59:43 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Okay, here's preliminary patch.  I've tested it very lightly so it's
> likely to contain bugs and definitely needs to be splitted.

Cool. However, there's something fishy there (not sure whether it's in
your patch or a latent bug in the ccw bus code that just has been
uncovered):

------------[ cut here ]------------
kernel BUG at mm/slab.c:607!
illegal operation: 0001 [#1]
CPU:    1    Not tainted
Process kslowcrw (pid: 36, task: 0000000001a80cc0, ksp:
0000000001a87ce0) Krnl PSW : 0404000180000000 00000000000b21b0
(kfree+0x144/0x154) R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0
EA:3 Krnl GPRS: 0000000000000000 0000000000000000 00000000009836d8
000003fffd22ffe0 00000000000b20aa 0000000000396ba8 0000000001a6d100
0000000000986c88 0700000001a879d8 0000000000555428 000000000344a5b0
0000000001a879c8 000000000344a500 0000000000390ca8 00000000000b20aa
0000000001a879c8 Krnl Code: 00000000000b21a2: e392c0480024
stg     %r9,72(%r2,%r12) 00000000000b21a8: a7f4ffc9           brc
15,1000b213a 00000000000b21ac: a7f40001           brc     15,b21ae
          >00000000000b21b0: a7f4ff9d           brc     15,1000b20ea
           00000000000b21b4: e33030100004       lg      %r3,16(%r3)
           00000000000b21ba: a7f4ff90           brc     15,1000b20da
           00000000000b21be: 0707               bcr     0,%r7
           00000000000b21c0: eb8ff0580024       stmg
%r8,%r15,88(%r15) Call Trace:
([<00000000000b20aa>] kfree+0x3e/0x154)
 [<00000000001166f2>] release_sysfs_dirent+0x3e/0xf4
 [<0000000000114914>] sysfs_hash_and_remove+0x150/0x154
 [<0000000000118aec>] remove_files+0x48/0x68
 [<0000000000118b84>] sysfs_remove_group+0x78/0xe8
 [<00000000001cce3c>] device_remove_groups+0x48/0x68
 [<00000000001cd4c0>] device_remove_attrs+0x3c/0x7c
 [<00000000001cd70e>] device_del+0x20e/0x3a8
 [<00000000001cd8d2>] device_unregister+0x2a/0x44
 [<000000000022fb2c>] css_sch_device_unregister+0x3c/0x54
 [<0000000000230124>] css_evaluate_subchannel+0x2f0/0x400
 [<000000000023041a>] css_trigger_slow_path+0xda/0x154
 [<0000000000054c9a>] run_workqueue+0x136/0x1fc
 [<0000000000054e3a>] worker_thread+0xda/0x170
 [<000000000005b05a>] kthread+0x122/0x15c
 [<0000000000019912>] kernel_thread_starter+0x6/0xc
 [<000000000001990c>] kernel_thread_starter+0x0/0xc

This happens when I detach a device (which causes it to be
unregistered). I'll look at it when I'm fully operational.

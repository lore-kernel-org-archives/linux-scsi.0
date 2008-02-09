From: =?ISO-8859-1?Q?Kim_H=F8jgaard-Hansen?= <kimhh@control.aau.dk>
Subject: arcmsr + archttp64 calls dma_free_coherent() with irqs disabled -
 dmesg filled with warnings
Date: Sat, 09 Feb 2008 16:31:23 +0100
Message-ID: <47ADC74B.9080009@control.aau.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cicero-fbr1.cybercity.dk ([212.242.40.5]:62020 "EHLO
	cicero-fbr1.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbYBIQSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 11:18:34 -0500
Received: from smtp1.cybercity.dk (smtp1.cybercity.dk [212.242.43.251])
	by cicero-fbr1.cybercity.dk (Postfix) with ESMTP id 088A53FA6E5
	for <linux-scsi@vger.kernel.org>; Sat,  9 Feb 2008 16:33:31 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich@areca.com.tw
Cc: linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com


The following was reported by Joshua Hoblitt on Gentoo bugzilla when
using the arcmsr driver (see https://bugs.gentoo.org/208493)

When starting up the Areca RAID card http pass through proxy called
archttp dmesg is completely filled with messages as:

WARNING: at arch/x86/kernel/pci-dma_64.c:169 dma_free_coherent()
Pid: 8232, comm: archttp64 Not tainted 2.6.24-gentoo #1

Call Trace:
 [<ffffffff80212f24>] dma_alloc_coherent+0x1ba/0x1d2
 [<ffffffff80212c53>] dma_free_coherent+0x43/0x82
 [<ffffffff88044b65>] :arcmsr:arcmsr_queue_command+0x368/0x959
 [<ffffffff8042078f>] scsi_dispatch_cmd+0x1a9/0x1fe
 [<ffffffff804259c4>] scsi_request_fn+0x26f/0x33e
 [<ffffffff8038a781>] blk_execute_rq_nowait+0x7a/0x8e
 [<ffffffff80425471>] scsi_execute_async+0x345/0x394
 [<ffffffff8022d813>] __wake_up_common+0x41/0x74
 [<ffffffff8045b9dc>] sg_common_write+0x6b7/0x6ef
 [<ffffffff8045bc31>] sg_cmd_done+0x0/0x1d6
 [<ffffffff8022e200>] __dequeue_entity+0x1c/0x32
 [<ffffffff8045bc0e>] sg_new_write+0x1fa/0x21d
 [<ffffffff8045c31a>] sg_ioctl+0x218/0xa31
 [<ffffffff8024dc70>] hrtimer_cancel+0xc/0x16
 [<ffffffff8058d483>] do_nanosleep+0x55/0x7e
 [<ffffffff8024de3b>] hrtimer_nanosleep+0x5b/0xfe
 [<ffffffff802a5539>] do_ioctl+0x55/0x6b
 [<ffffffff802a579c>] vfs_ioctl+0x24d/0x266
 [<ffffffff802a57f1>] sys_ioctl+0x3c/0x5f
 [<ffffffff8020be2e>] system_call+0x7e/0x83

----------------------

The warning was added in dma_free_coherent()  (pci-dma_64.c and
pci-dma_32.c) in kernel 2.6.24 to avoid portability issues with drivers
using this function.

The commit details why this warning was added:

--------------------

dma_free_coherent() needs irqs enabled (sigh)

On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newis=
h
call context requirement: unlike its dma_alloc_coherent() sibling, it m=
ay
not be called with IRQs disabled.  (This was new behavior on ARM as of =
late
2005, caused by ARM SMP updates.) This little surprise can be annoyingl=
y
driver-visible.

Since it looks like that restriction won't be removed, this patch chang=
es
the definition of the API to include that requirement.  Also, to help c=
atch
nonportable drivers, it updates the x86 and swiotlb versions to include=
 the
relevant warnings.  (I already observed that it trips on the
bus_reset_tasklet of the new firewire_ohci driver.)

--------------

the commit can be seen here:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3Daa24886e379d2b641c5117e178b15ce1d5d366ba

If additional info is needed this can be provided and we would be happy=
 to ask the user to test any available patches.

Best regards

Kim H=F8jgaard-Hansen
Gentoo Kernel team

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

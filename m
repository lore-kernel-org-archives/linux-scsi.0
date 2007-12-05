From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: stex driver - kernel panics
Date: Wed, 5 Dec 2007 22:49:14 +0100
Message-ID: <200712052249.20782.eike-kernel@sf-tec.de>
References: <47571259.9060608@nortel.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1512721.uh5BDqoit0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:35003 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXLEVtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 16:49:32 -0500
In-Reply-To: <47571259.9060608@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Rendell <rendell@nortel.com>
Cc: linux-scsi@vger.kernel.org

--nextPart1512721.uh5BDqoit0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sean Rendell wrote:
> Hi all,
>
> I was wondering if someone knows how to debug this.  I have a HP xw4300 PC
> with 2G RAM and 3GHz P4.  Included is a Promise EX8350 RAID card with 4
> drives configured as RAID5.  While doing some lengthy disk exercises (ie cp
> a 200G directory of files) the kernel usually panics.
>
> This is the 2.6.23 kernel patched to 2.6.24-rc4.  The only module is the
> stex driver, all other drivers are in the kernel.
>
> Can anyone debug this?  (I am not a software guy)  Do you need more info?
>
> cya
> Sean
>
>
> (copied by hand from the screen)
> raidology:/home# mkdir foo
> raidology:/home# cp -a * foo/
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 40 3c a7 17 00 00 08 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 06 85 cc 17 00 01 00 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 31 1c 66 27 00 00 08 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 4f 1f 87 f7 00 00 08 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 4a 07 d1 ef 00 00 08 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 18 8e 33 30 00 00 01 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 18 8e 33 3f 00 00 08 00
> stex(0000:11:0e.0): aborting command
> sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 02 ba 77 b7 00 00 08 00
> BUG: unable to handle kernel NULL pointer dereference at virtual address
> 00000000 printing eip: 00000000 *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: stex
>
> Pid: 0, comm: swapper Not tainted (2.6.24-rc4loca-RAID5-02 #1)
> EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU:0
> EIP is at run_init_process+0x3fefff40/0x20
> EAX: f7760900 EBX: f7548d78 ECX: f7760900 EDX: 00000000
> ESI: f7760900 EDI: f7f6eaa0 EBP: f7f6ea70 ESP: c04ebeec
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS:0068
> Process swapper (pid: 0, ti=c04ea000 task=c04b53a0 task.ti=c04ea000)
> Stack: f887c4be c04ebf24 c04ebf1c c04ebf2c f8d9e000 f7f6eaa0 00000001
> 00ced0bd f7f6ea70 f8d9e000 00000246 00000001 f887ceb2 f7670e80 00000000
> 00000000 00000010 c013dff5 c04df580 00000010 00000000 c04df5b0 c013f7d4
> 00000800 Call Trace:
>  [<f887c4be>] stex_mu_intr+0x10e/0x4f0 [stex]
>  [<f887ceb2>] stex_intr+0x42/0x70 [stex]
>  [<c013dff5>] handle_IRQ_event+0x25/0x60
>  [<c013f7d4>] handle_fasteoi_irq+0x74/0xf0
>  [<c01056dd>] do_IRQ+0x3b/0x80
>  [<c010f957>] smp_apic_timer_interrupt+0x57/0x90
>  [<c010354f>] common_interrupt+0x23/0x28
>  [<c0100c16>] mwait_idle_with_hints+0x46/0x60
>  [<c0100f85>] cpu_idle+0x65/0x80
>  [<c04f0cbf>] start_kernel+0x2af/0x2f0
>  [<c04f0400>] unknown_bootoption+0x0/0x1f0
>  =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] run_init_process=0x3fefff40/0x20 SS:ESP 0068:c04ebeec
> Kernel panic - not syncing: Fatal exception in interrupt

gdb stex.o
l *stex_mu_intr+0x10e

That will give you the exact line that failed

Greeting,

Eike

--nextPart1512721.uh5BDqoit0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHVxzgXKSJPmm5/E4RAo1aAJ9QTITIlXjxS+zvIcR3ZdE94roH9gCePDLr
D0MqjxuGggWt/QuuIgSTDlU=
=DCVC
-----END PGP SIGNATURE-----

--nextPart1512721.uh5BDqoit0--

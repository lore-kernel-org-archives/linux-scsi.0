From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Fw: [Bugme-new] [Bug 5566] New: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
Date: Fri, 11 Nov 2005 08:41:12 -0800
Message-ID: <20051111164111.GB458@andrew-vasquezs-powerbook-g4-15.local>
References: <20051111020619.5a73ad37.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:3952 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750867AbVKKQlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 11:41:14 -0500
Content-Disposition: inline
In-Reply-To: <20051111020619.5a73ad37.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Fri, 11 Nov 2005, Andrew Morton wrote:

> Begin forwarded message:
> 
> Date: Mon, 7 Nov 2005 14:49:17 -0800
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 5566] New: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=5566
> 
>            Summary: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
>     Kernel Version: 2.6.13+
>             Status: NEW
>           Severity: normal
>              Owner: andrew.vasquez@qlogic.com
>          Submitter: gator@cs.tu-berlin.de
> 
> 
> Most recent kernel where this bug did not occur: 2.6.12
> Starting around kernel version 2.6.13, the scsi_eh_x and scsi_wq_x
> processes that are created per scsi host will not terminate if the
> driver for the scsi interface is removed. I don't know whether there
> are any serious problems involved with this, but one thing that is
> definitely annoying, is that the process list fills very quickly when
> modules are loaded/unloaded on demand, because 2 new processes will
> be created every time the driver for a scsi adapter gets loaded.
> 
> (I guess, this happens with all scsi host modules - in my case, the
> "culprit" is a qlogic fibre channel driver that gets loaded only when
> needed.)

Seems there appear to be some reference-counting problems here, as the
task trace:

scsi_eh_2     S 00000001     0 10399     19         10452   900 (L-TLB)
f5144fa4 f5144f94 00000004 00000001 c19b2560 c0370b15 f5144fa4 00000004
       00000002 00000002 00000001 00000000 f383f31c 00000001 f1d32d54 00000001
       ffffffff c1b3a030 c19b2560 00000001 0000166d 6db5a7a1 00000022 c1ac0540
Call Trace:
 [<c0370b15>] schedule+0x6a5/0xd0d
 [<c02919cd>] scsi_error_handler+0x0/0x12e
 [<c0291a09>] scsi_error_handler+0x3c/0x12e
 [<c012ef91>] kthread+0xa3/0xcd
 [<c012eeee>] kthread+0x0/0xcd
 [<c0101119>] kernel_thread_helper+0x5/0xb
scsi_wq_2     S 00000003     0 10452     19         11613 10399 (L-TLB)
eb196f3c eb196f28 00000004 00000003 c02957b4 f7f1e79c 00000040 ee08cebc
       eccf2540 00000001 00000000 00000000 e8fdd540 f04ac17c f04ac320 e8fdd540
       00000000 c19c2ec0 c19c2560 00000003 000761f8 d13d8b02 00000022 e8fdd540
Call Trace:
 [<c02957b4>] __scsi_scan_target+0xaf/0x12d
 [<c012ae53>] worker_thread+0x147/0x24a
 [<f8835f20>] fc_scsi_scan_rport+0x0/0x40 [scsi_transport_fc]
 [<c0116b80>] default_wake_function+0x0/0x12
 [<c0116b80>] default_wake_function+0x0/0x12
 [<c012ad0c>] worker_thread+0x0/0x24a
 [<c012ef91>] kthread+0xa3/0xcd
 [<c012eeee>] kthread+0x0/0xcd
 [<c0101119>] kernel_thread_helper+0x5/0xb

has the workqueue thread stuck:

  out_reap:
	/* now determine if the target has any children at all
	and if not, nuke it */
	scsi_target_reap(starget);

	put_device(&starget->dev);
  }

at the final put_device() in __scsi_scan_target().

I'm still trying to figure out the call paths which take us there
during module unload.  James, any ideas on the ref-counting?

--
av

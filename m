From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: Tue, 28 Sep 2004 16:17:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928151722.GA16153@parcelfarce.linux.theplanet.co.uk>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com> <20040928142104.GC3373@krispykreme.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33256 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267881AbUI1PRX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 11:17:23 -0400
Content-Disposition: inline
In-Reply-To: <20040928142104.GC3373@krispykreme.ozlabs.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Wed, Sep 29, 2004 at 12:21:04AM +1000, Anton Blanchard wrote:
> With that patch I still managed to get an oops. There is a fair amount
> of bad hardware in the box but oopsing is pretty anti social.
> 
> Looks like a refcount problem. We kref_get'ed something already freed,
> then finally oopsed in scsi_device_get, trying to access address
> 0x100510.

__scsi_iterate_devices is part of a shost_for_each_device() loop.  That
means we had a scsi_device sitting on the shost->__devices list with a
zero refcount.  I'll see if I can spot the leak in my current sources,
but some of the behaviour has changed recently and it may be gone.

> scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 11 lun 0
> Badness in kref_get at lib/kref.c:32
> Call Trace:
> [c0000032fcab3bd0] [c0000032fcab3c50] 0xc0000032fcab3c50 (unreliable)
> [c0000032fcab3c50] [c00000000021f5b8] .get_device+0x20/0x3c
> [c0000032fcab3cc0] [c000000000294c60] .scsi_device_get+0x38/0xe4
> [c0000032fcab3d40] [c000000000294e30] .__scsi_iterate_devices+0x60/0xfc
> [c0000032fcab3de0] [c000000000299bf8] .scsi_run_host_queues+0x34/0x58
> [c0000032fcab3e60] [c0000000002989f8] .scsi_error_handler+0x268/0xaa0
> [c0000032fcab3f90] [c000000000017aac] .kernel_thread+0x4c/0x68
> sym.0014:03:01.0:11:control msgout: c.
> 
> NIP: C000000000294C48 XER: 0000000020000000 LR: C000000000294E30
> REGS: c0000032fcab3a40 TRAP: 0300   Not tainted  (2.6.9-rc2-bml)
> MSR: 9000000000001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
> DAR: 0000000000100510, DSISR: 0000000040000000
> TASK: c000002bfd33d3c0[1494] 'scsi_eh_2' THREAD: c0000032fcab0000 CPU: 14
> GPR00: FFFFFFFFFFFFFFFA C0000032FCAB3CC0 C0000000007297B8 00000000001000F0 
> GPR04: C00000000E112800 0000000000000001 0000000000000000 0000000000000000 
> GPR08: 0000000000000000 0000000000100100 C000001DFF875C28 9000000000009032 
> GPR12: 0000000024FFFF22 C000000000545880 0000000000000000 0000000000000000 
> GPR16: 0000000000000000 C00000000040D190 C000000000587058 C0000032FCAB3ED0 
> GPR20: 00000000000000FC C00000000040D190 C000000000587058 C0000032FCAB3F00 
> GPR24: C0000032FCAB3EF0 0000040180000000 C000000073847BB0 C00000000E112800 
> GPR28: 9000000000009032 C000000FFFFA8800 00000000001002D8 00000000001000F0 
> NIP [c000000000294c48] .scsi_device_get+0x20/0xe4
> LR [c000000000294e30] .__scsi_iterate_devices+0x60/0xfc
> Call Trace:
> [c0000032fcab3cc0] [c000000000294da8] .scsi_device_put+0x9c/0xc4 (unreliable)
> [c0000032fcab3d40] [c000000000294e30] .__scsi_iterate_devices+0x60/0xfc
> [c0000032fcab3de0] [c000000000299bf8] .scsi_run_host_queues+0x34/0x58
> [c0000032fcab3e60] [c0000000002989f8] .scsi_error_handler+0x268/0xaa0
> [c0000032fcab3f90] [c000000000017aac] .kernel_thread+0x4c/0x68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Thu, 10 Feb 2005 10:07:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502101002120.887-100000@ida.rowland.org>
References: <20050210105650.GA1070@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:9732 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262135AbVBJPHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 10:07:53 -0500
In-Reply-To: <20050210105650.GA1070@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Thu, 10 Feb 2005, Olaf Hering wrote:

> I see a few refcount handling bugs in the scsi and/or usb layer.
> With a vanilla kernel, plugging an usb stick in , and remove it a few
> times:
> 
> 
> usb 2-1: USB disconnect, address 4
> Oops: kernel access of bad area, sig: 11 [#1]
> NIP: CDD3E424 LR: CDD05398 SP: C9713F40 REGS: c9713e90 TRAP: 0300    Not tainted
> MSR: 00009032 EE: 1 PR: 0 FP: 0 ME: 1 IR/DR: 11
> DAR: 00000130, DSISR: 40000000
> TASK = cae312c0[6674] 'scsi_eh_2' THREAD: c9712000
> Last syscall: -1 
> GPR00: 00010718 C9713F40 CAE312C0 00000000 CDD146D0 00000001 00000000 00009032 
> GPR08: CAABF078 00000000 CB604800 C2801200 44088028 00000000 C07C67B8 00000004 
> GPR16: C07D8B9A C07D69D0 CDD30000 C9713F90 C03B286C C03433D8 C9713FA8 CDD30000 
> GPR24: CAABF078 00000000 C2801200 00000000 C9713FA0 CAABF078 FFFFFFF0 C1711600 
> NIP [cdd3e424] bus_reset+0x64/0x134 [usb_storage]
> LR [cdd05398] scsi_try_bus_reset+0x8c/0x104 [scsi_mod]
> Call trace:
>  [cdd05398] scsi_try_bus_reset+0x8c/0x104 [scsi_mod]
>  [cdd068c4] scsi_error_handler+0x86c/0xe68 [scsi_mod]
>  [c0006c2c] kernel_thread+0x44/0x60

It's hard to tell for sure, but this looks much like the SCSI midlayer bug
encountered by Srihari Vijayaraghavan in

http://marc.theaimsgroup.com/?l=linux-usb-devel&m=110535224408095&w=2

My response (unfortunately the email thread continuity got messed up) was

http://marc.theaimsgroup.com/?l=linux-scsi&m=110537890416616&w=2

And Mike Anderson's response was

http://marc.theaimsgroup.com/?l=linux-scsi&m=110538854224319&w=2

His explanation was "Currently scsi_host_cancel being called from
scsi_remove_host appears to not do anything as scsi_forget_host removes
the devices from the list it iterates over."  I don't know whether this 
problem has been fixed yet.

Alan Stern


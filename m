From: James Smart <James.Smart@Emulex.Com>
Subject: Re: PCI error recovery for the Emulex LPFC
Date: Tue, 31 Oct 2006 08:51:08 -0500
Message-ID: <454754CC.8040308@emulex.com>
References: <20061030222047.GN6360@austin.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19883 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1423275AbWJaNvY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 08:51:24 -0500
In-Reply-To: <20061030222047.GN6360@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, rlary@us.ibm.com, James Smart <James.Smart@Emulex.Com>

Linas,

I don't know of anything in this area.
I also need a deeper understand of what the error was, and how,
that was injected. This play into it.

Also, PCI error recovery is not a simple task. There are many
aspects to the adapter messaging interface and the affects of the
PCI error recovery scheme that has to be closely looked at. DMA
errors can be very fatal, even if the PCI bus survives. In many
cases, the only safe recovery is a hard adapter reset (with little
to no interaction with the adapter to clean up). We can discuss
this more offline if you'd like.

-- james s


Linas Vepstas wrote:
> Hi James,
> 
> I recently started fiddling with the emulex lpfc driver
> with the idea of adding PCI error recovery support to
> the driver.  I'm trying to figure out how to proceed.
> 
> Some background: In IBM pSeries, and now newer PCI-E
> based systems, things like parity errors, etc. on the 
> PCI bus are detected by the PCI bridge chip, which
> then freezes all further traffic to the adapter. 
> When an error condition is detected, there's a 
> handful of callbacks made to the device driver, which
> can then try to recover from the error, and move 
> forward.  
> 
> When io is frozen, mmio reads return all 0xffff's ...
> I injected an error on the lpfc, and the (so far, 
> completely unmodified) driver promptly crashed on me:
> 
> 0:mon> excp
> cpu 0x0: Vector: 300 (Data Access) at [c0000003fbed3890]
>     pc: d000000000aa23c0: .lpfc_dev_loss_tmo_callbk+0x68/0x238 [lpfc]
>     lr: c0000000002e9dac: .fc_starget_delete+0x90/0x17c
>     sp: c0000003fbed3b10
>    msr: 9000000000009032
>    dar: 6b6b6b6b6b6b7753
>  dsisr: 40000000
>   current = 0xc0000003fa4ac7f0
>   paca    = 0xc000000000523300
>     pid   = 4714, comm = fc_wq_1
> 
> 0:mon> t
> [c0000003fbed3bf0] c0000000002e9dac .fc_starget_delete+0x90/0x17c
> [c0000003fbed3c80] c0000000002ebc5c .fc_rport_final_delete+0x80/0x124
> [c0000003fbed3d20] c000000000067268 .run_workqueue+0xdc/0x168
> [c0000003fbed3dc0] c000000000067d0c .worker_thread+0x140/0x1b0
> [c0000003fbed3ee0] c00000000006c24c .kthread+0x124/0x174
> [c0000003fbed3f90] c000000000024d20 .kernel_thread+0x4c/0x68
> 
> This is on 2.6.19-rc1-git11 -- I'll try to track this down 
> further, but thought I'd mention it now. Does sucha crash 
> look familiar?
> 
> -- Linas Vepstas
> 
> 
> 

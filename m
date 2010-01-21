From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: qlogic lockdep warning
Date: Thu, 21 Jan 2010 12:38:23 -0800
Message-ID: <CD882469-BBED-443E-A07D-4AB92FBB9DDB@qlogic.com>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11872 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0AUUiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2010 15:38:24 -0500
In-Reply-To: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@hansenpartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Jan 20, 2010, at 5:10 PM, Yinghai Lu wrote:

> [   77.814629] calling  qla2x00_module_init+0x0/0x12b @ 1
> [   77.818427] QLogic Fibre Channel HBA Driver: 8.03.02-k0
> [   77.834218] qla2xxx 0000:86:00.0: PCI INT A -> GSI 59 (level,  
> low) -> IRQ 59
> [   77.839720] qla2xxx 0000:86:00.0: MSI-X vector count: 31
> [   77.854678] qla2xxx 0000:86:00.0: Found an ISP2532, irq 59, iobase
> 0xffffc9002acb0000
> [   77.871740] qla2xxx 0000:86:00.0: using 64bit consistent DMA mask
> [   77.876934]   alloc irq_desc for 88 on node 3
> [   77.879181]   alloc kstat_irqs on node 3
> [   77.894822] qla2xxx 0000:86:00.0: irq 88 for MSI/MSI-X
> [   77.899210]   alloc irq_desc for 89 on node 3
> [   77.913580]   alloc kstat_irqs on node 3
> [   77.916743] qla2xxx 0000:86:00.0: irq 89 for MSI/MSI-X
> [   77.920996] qla2xxx 0000:86:00.0: Configuring PCI space...
> [   77.937287] qla2xxx 0000:86:00.0: setting latency timer to 64
> [   77.951598] qla2xxx 0000:86:00.0: enabling Mem-Wr-Inval
> [   77.962879] ------------[ cut here ]------------
> [   77.965784] WARNING: at kernel/lockdep.c:2332
> trace_hardirqs_on_caller+0xc6/0x14b()
> [   77.977492] Hardware name: Sun
> [   77.979485] Modules linked in:
> [   77.994337] Pid: 0, comm: swapper Not tainted
> 2.6.33-rc4-tip-yh-03949-g3a8e3f5-dirty #64
> [   78.000120] Call Trace:
> [   78.013298]  <IRQ>  [<ffffffff81076b54>] warn_slowpath_common 
> +0x7c/0x94
> [   78.017746]  [<ffffffff81cd712c>] ? _raw_spin_unlock_irq+0x30/0x36
> [   78.035171]  [<ffffffff81076b80>] warn_slowpath_null+0x14/0x16
> [   78.040152]  [<ffffffff810a2ae8>] trace_hardirqs_on_caller 
> +0xc6/0x14b
> [   78.055400]  [<ffffffff810a2b7a>] trace_hardirqs_on+0xd/0xf
> [   78.058951]  [<ffffffff81cd712c>] _raw_spin_unlock_irq+0x30/0x36
> [   78.074889]  [<ffffffff816461ef>] qla24xx_msix_default+0x243/0x281
> [   78.091598]  [<ffffffff810a5752>] ? __lock_release+0xa5/0xae
> [   78.096799]  [<ffffffff810c02ae>] handle_IRQ_event+0x53/0x113
> [   78.111568]  [<ffffffff810c2061>] handle_edge_irq+0xf3/0x13b
> [   78.116255]  [<ffffffff81035109>] handle_irq+0x24/0x2f
> [   78.132063]  [<ffffffff81cdc4b4>] do_IRQ+0x5c/0xc3
> [   78.134684]  [<ffffffff81cd7393>] ret_from_intr+0x0/0xf
> [   78.137903]  <EOI>  [<ffffffff81039a56>] ? mwait_idle+0xaf/0xbb
> [   78.155674]  [<ffffffff81039a4d>] ? mwait_idle+0xa6/0xbb
> [   78.158600]  [<ffffffff81031c7c>] cpu_idle+0x61/0xa1
> [   78.174333]  [<ffffffff81c85d7a>] rest_init+0x7e/0x80
> [   78.178122]  [<ffffffff82832d1f>] start_kernel+0x316/0x31d
> [   78.193623]  [<ffffffff82832297>] x86_64_start_reservations 
> +0xa7/0xab
> [   78.198924]  [<ffffffff8283237f>] x86_64_start_kernel+0xe4/0xeb
> [   78.214540] ---[ end trace be4529f30a2e4ef5 ]---
> [   78.225365] qla2xxx 0000:86:00.0: Configure NVRAM parameters...
> [   78.243079] qla2xxx 0000:86:00.0: Verifying loaded RISC code...
> [   78.247917] qla2xxx 0000:86:00.0: firmware: using built-in firmware
> ql2500_fw.bin
>

could you enable error-logging (ql2xextended_error_logging=1) and send  
over the full
kernel-messages output for the failure.


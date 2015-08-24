From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: isci, INTx mode, race condition
Date: Mon, 24 Aug 2015 16:14:19 +0200
Message-ID: <55DB26BB.3010000@intel.com>
References: <55D4A85F.1080304@real-time-systems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55D4A85F.1080304@real-time-systems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Fausser <kernel_tk@real-time-systems.com>, intel-linux-scu@intel.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/19/2015 06:01 PM, Stefan Fausser wrote:
> Dear all,
> 
> attached are two patches for the "isci" module (CONFIG_SCSI_ISCI).
> 
> Both patches apply to the current Linux kernel, retrieved by GIT (4.2.0-rc7).
> 
> The first patch (init.patch) is for reproducing the problem with the "Intel(R) C600 SAS Controller" in INTx Mode, see below. The second patch (host.patch) is for fixing this problem.
> 
> The problem:
> 
> By applying the first patch "init.patch", the "Intel(R) C600 SAS Controller" (now abbreviated by SAS) generates level-triggered INTx Interrupts instead of (edge-triggered) MSI-X Interrupts.
> 
> In the ISR (isci_intx_isr), the controller determines if the interrupt is due to a normal operation (normal interrrupt) or an error. In the case of a normal interrupt, a tasklet is scheduled that should handle the normal interrupt. However, in the ISR, the interrupts are left unmasked and the SAS device may trigger the next interrupt after the ISR has left and before the tasklet has been scheduled.
> 
> Thus, with this patch "init.patch" and on my system (Intel C600 chipset series), the SAS device repeatedly level-triggers the interrupt and the tasklet to handle the interrupt never gets scheduled. This will result in a soft-lockup on the executing core.
> 
> In my investigations, the above described problem occurs in all Linux kernel version starting from 3.5 and up to to-day.
> 
> The fix:
> 
> By applying the second patch "host.patch", the interrupts are masked in the INTx ISR in case of a normal interrupt. Thus, the scheduler has enough time to schedule the handling tasklet. In the tasklet (see sci_controller_completion_handler), the interrupts are unmasked again.
> 
> Please let me know if you need any other information.
> 
> Kind Regards,
> 
> Stefan
> 

Hi Stefan,

I tried to reproduce this issue using just the init.patch and I had no
soft lockups, but they started occuring after I added some delays in
isci_intx_isr(). The host.patch fixed this and I think the solution is
correct.

Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Thanks,
Artur

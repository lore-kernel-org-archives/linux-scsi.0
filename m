From: Joe Malicki <jmalicki@metacarta.com>
Subject: Re: megaraid_sas xscale interrupt mask?
Date: Mon, 08 Jan 2007 10:59:33 -0500
Message-ID: <45A26A65.6080801@metacarta.com>
References: <0631C836DBF79F42B5A60C8C8D4E822989085B@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silene.metacarta.com ([65.77.47.18]:45268 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161327AbXAHQDd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 11:03:33 -0500
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822989085B@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: linux-poweredge@dell.com, "Keith R. Baker" <krbaker+dpe@metacarta.com>, linux-scsi@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

Hi Sumant,

Thanks for the quick response!  I don't believe we're having any issues
with the mask - we're just trying to debug some issues we're
having with some controllers with 2.6.17.13, and that's the only
real semantic difference (other than crashdump mode) between
RHEL 4 kernels and 2.6.17.13, and it spooked me that the changelog
didn't mention that it was intentional... I really appreciate the
response, it helps us eliminate possibilities and doubt.

Thanks!
Joe

Patro, Sumant wrote:
> Hello Joe,
> 
> 	The mask value 0x1f is to mask out interrupts. The value in the
> current kernel code is appropriate for all controllers that the driver
> supports. 
> 
> 	Are you seeing any specific issue in driver with this mask
> value?
> 	
> Regards,
> 
> Sumant 
> 
> -----Original Message-----
> From: Joe Malicki [mailto:jmalicki@metacarta.com] 
> Sent: Wednesday, January 03, 2007 5:41 PM
> To: Patro, Sumant
> Cc: linux-poweredge@dell.com; Keith R. Baker; linux-scsi@vger.kernel.org
> Subject: megaraid_sas xscale interrupt mask?
> 
> Hi Sumant,
> 
> While trying to debug Dell PERC 5/i RAID controller problems we've been
> having with the megaraid_sas driver, we've been inspecting differences
> between the Red Hat EL 4 kernel (which Dell officially supports) versus
> the stock Linux 2.6.17.13 driver we use.  We found a very interesting
> change, introduced into linux 2.6.16, that seems very odd to us:
> 
> http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/51f889b
> d09bafd2d/cbbe2a30b8c2eb94?lnk=st&q=outbound_intr_mask+0x1f+0x00000001&r
> num=1#cbbe2a30b8c2eb94
> 
> The title of the thread is "megaraid_sas: new template defined to
> represent each type of controllers", and introduces this curious change:
> 
>  /**
>   * megasas_disable_intr -      Disables interrupts
>   * @regs:                      MFI register set
>   */
>  static inline void
>  megasas_disable_intr(struct megasas_register_set __iomem * regs)  {
> -       u32 mask = readl(&regs->outbound_intr_mask) & (~0x00000001);
> +       u32 mask = 0x1f;
>         writel(mask, &regs->outbound_intr_mask);
> 
>         /* Dummy readl to force pci flush */
> 
> Interrupts are enabled by writing "1" to the same register.
> 
> Is there a specific reason for this?  Is it possible that Dell PERC 5/i
> controllers differ from LSI controllers in this respect?  It seems odd
> that this change would be introduced without any explanation for what
> it's meant to do, so I am very curious if it could be an inadvertently
> introduced bug that is causing some problems.
> 
> Thanks!
> Joe Malicki
> 

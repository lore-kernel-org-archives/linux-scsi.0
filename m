From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas - Add the dumy readl to force
 PCI flush
Date: Mon, 4 Aug 2008 17:41:28 -0700
Message-ID: <20080804174128.a0877c27.akpm@linux-foundation.org>
References: <FFD04EB4FBD32E4B929B6CFDEDA6AA0D632A9F@NAMAIL1.ad.lsil.com>
	<4B6A08C587958942AA3002690DD4F8C31B08093F@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbYHEAlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 20:41:40 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C31B08093F@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'James.Bottomley@SteelEye.com'" <James.Bottomley@SteelEye.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@linuxfoundation.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Austria, Winston" <Winston.Austria@lsi.com>, "poswald@novell.com" <poswald@novell.com>

On Fri, 1 Aug 2008 10:19:07 -0600 "Yang, Bo" <Bo.Yang@lsi.com> wrote:

> MegaRAID SAS Driver get unexpected Interrupt.  Add the dumy readl to force PCI flush will fix this issue.
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> ---
> drivers/scsi/megaraid/megaraid_sas.c |    6 ++++++
> 1 files changed, 6 insertions(+)
> 
> diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2008-07-31 12:00:58.000000000 -0400
> +++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2008-07-31 12:30:35.000000000 -0400
> @@ -198,6 +198,9 @@ megasas_clear_intr_xscale(struct megasas
>          */
>         writel(status, &regs->outbound_intr_status);
> 
> +       /* Dummy readl to force pci flush */
> +       readl(&regs->outbound_intr_status);
> +
>         return 0;
>  }
> 
> @@ -293,6 +296,9 @@ megasas_clear_intr_ppc(struct megasas_re
>          */
>         writel(status, &regs->outbound_doorbell_clear);
> 
> +       /* Dummy readl to force pci flush */
> +       readl(&regs->outbound_doorbell_clear);
> +
>         return 0;
>  }
>  /**

These patches all had their tabs replaced with spaces.  I fixed them up.

Please always run checkpatch on all patches.  checkpatch found this:

ERROR: Macros with complex values should be enclosed in parenthesis
#182: FILE: drivers/scsi/megaraid/megaraid_sas.h:586:
+#define MFI_GEN2_ENABLE_INTERRUPT_MASK		0x00000001 | 0x00000004

which is a potential source of bugs.  I queued a patch to fix that also.

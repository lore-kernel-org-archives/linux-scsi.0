From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lockdep warning in qla2xxx
Date: Wed, 7 May 2008 12:09:04 -0600
Message-ID: <20080507180904.GA19219@parisc-linux.org>
References: <20080506182341.GN19219@parisc-linux.org> <20080506213729.GH57975@plap4.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46280 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761864AbYEGSJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 14:09:05 -0400
Content-Disposition: inline
In-Reply-To: <20080506213729.GH57975@plap4.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 06, 2008 at 02:37:29PM -0700, Andrew Vasquez wrote:
> Ok, admitently, my parsing of lockdep warnings is pretty weak, but I
> guess what's happening here is that lockdep is detecting the
> interrupt-handler is run in both process and interrupt context with
> irqs-enabled in the former case.

I believe you to be correct.

> During init-time and error-recovery (after a RISC reset), the driver
> disables interrupts and 'polls' for completions by calling
> qla2x00_poll():
> 
> 	static inline void
> 	qla2x00_poll(scsi_qla_host_t *ha)
> 	{
> 		ha->isp_ops->intr_handler(0, ha);
> 	}
> 
> which in-turn calls the ISP registered interrupt handler.  One
> possible solution to silence lockdep is to disable local interrupts
> while the handler is polled...  This though seems fairly heavy handed.
> Does something like the following make sense???
> 
> ---
> 
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index e9bae27..92fafbd 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -34,7 +34,11 @@ qla2x00_debounce_register(volatile uint16_t __iomem *addr)
>  static inline void
>  qla2x00_poll(scsi_qla_host_t *ha)
>  {
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>  	ha->isp_ops->intr_handler(0, ha);
> +	local_irq_restore(flags);
>  }

Looks like the right idea to me.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

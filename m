From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] - mptfusion - fix panic loading driver statically
 compile d
Date: Thu, 28 Apr 2005 15:48:40 -0700
Message-ID: <20050428154840.24b51549.akpm@osdl.org>
References: <91888D455306F94EBD4D168954A9457C0225D199@nacos172.co.lsil.com>
	<1114727284.5022.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:44219 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262313AbVD1WsT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 18:48:19 -0400
In-Reply-To: <1114727284.5022.25.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Thu, 2005-04-28 at 16:15 -0600, Moore, Eric Dean wrote:
> > This patch can also be found at this URL:
> > ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.01/
> > 
> > Changelog:
> > (1) For statically linked drivers, fusion_init was not called,
> > added call from mpt_register so its called when one of the scsi lld load.
> > (2) little endian fix in mpt_put_msg_frame/mpt_get_msg_frame
> > (3) Clarify help desc in Kconfig for FUSION_MAX_SGE.
> 
> Surely this is just a simple link order problem?  Can't we solve it like
> the attached?
> 
> James
> 
> --- k/drivers/message/fusion/Makefile  (mode:100644)
> +++ l/drivers/message/fusion/Makefile  (mode:100644)
> @@ -32,7 +32,7 @@
>  
>  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-} LSI_LOGIC
>  
> -obj-$(CONFIG_FUSION_SPI)	+= mptspi.o mptscsih.o mptbase.o
> -obj-$(CONFIG_FUSION_FC)		+= mptfc.o mptscsih.o mptbase.o
> +obj-$(CONFIG_FUSION_SPI)	+=  mptbase.o mptspi.o mptscsih.o
> +obj-$(CONFIG_FUSION_FC)		+=  mptbase.o mptfc.o mptscsih.o
>  obj-$(CONFIG_FUSION_CTL)	+= mptctl.o
>  obj-$(CONFIG_FUSION_LAN)	+= mptlan.o

That would be a last resort :( I seem to recall people saying that this
might not work over all extant binutilses, too.

Doing something explicit via initcall levels sounds nicer.

I agree that we don't understand what's going on yet - fusion_init() should
have been called *sometime*, no matter what the linkage order is, and no
matter what the chosen initcall levels.

Booting with `initcall_debug' will tell us which initcalls are being
called, and in which order.


From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
 resources.
Date: Thu, 10 Dec 2009 09:43:38 -0600
Message-ID: <1260459818.2457.77.camel@mulgrave.site>
References: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZLJPnk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 10:43:40 -0500
In-Reply-To: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pravin Bathija <pbathija@amcc.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org, Eric.Moore@lsi.com

On Wed, 2009-12-02 at 17:51 -0800, Pravin Bathija wrote:
> Powerpc 44x uses 36 bit real address while the real address defined
>     in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
>     fails to initialize. This fix changes the data types representing the real
>     address from unsigned long 32-bit types to resource_size_t which is 64-bit. The
>     driver has been tested, the disks get discovered correctly and can do IO.
> 
> Signed-off-by: Pravin Bathija <pbathija@amcc.com>
> Acked-by: Feng Kan <fkan@amcc.com>
> Acked-by: Fushen Chen <fchen@amcc.com>
> Acked-by: Loc Ho <lho@amcc.com>
> Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
> Acked-by: Victor Gallardo <vgallardo@amcc.com>
> ---
>  drivers/message/fusion/mptbase.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 5d496a9..9f14a60 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1511,7 +1511,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  {
>  	u8		__iomem *mem;
>  	int		 ii;
> -	unsigned long	 mem_phys;
> +	resource_size_t	 mem_phys;

You never actually compiled this, did you?

drivers/message/fusion/mptbase.c: In function 'mpt_mapresources':
drivers/message/fusion/mptbase.c:1680: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'resource_size_t'

I'll just fold the fix in

James

---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 162923f..85bc6a6 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1677,8 +1677,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		return -EINVAL;
 	}
 	ioc->memmap = mem;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
-	    ioc->name, mem, mem_phys));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %llx\n",
+	    ioc->name, mem, (unsigned long long)mem_phys));
 
 	ioc->mem_phys = mem_phys;
 	ioc->chip = (SYSIF_REGS __iomem *)mem;



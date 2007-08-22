From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
Date: Wed, 22 Aug 2007 18:57:11 +0200
Message-ID: <46CC6AE7.1070005@googlemail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6112.9030705@googlemail.com> <20070822162802.GJ9163@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:8469 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761908AbXHVQ6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2007 12:58:36 -0400
Received: by nf-out-0910.google.com with SMTP id g13so168096nfb
        for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 09:58:34 -0700 (PDT)
In-Reply-To: <20070822162802.GJ9163@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Aug 22, 2007 at 06:15:14PM +0200, Gabriel C wrote:
>> advansys.c:(.init.text+0x38ea): undefined reference to `isa_register_driver'
>> I guess advansys_{init,exit} is missing some #ifdef's ..
> 
> That's one conclusion.  I prefer to think that the ISA support should
> behave the same as the PCI and EISA support:

Yes right , your patch fixes the problem.

> 
> ----
> 
> When CONFIG_ISA is disabled, the isa_driver support will not be compiled
> in.  Define stubs so that we don't get link-time errors.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> diff --git a/include/linux/isa.h b/include/linux/isa.h
> index 1b85533..b0270e3 100644
> --- a/include/linux/isa.h
> +++ b/include/linux/isa.h
> @@ -22,7 +22,18 @@ struct isa_driver {
>  
>  #define to_isa_driver(x) container_of((x), struct isa_driver, driver)
>  
> +#ifdef CONFIG_ISA
>  int isa_register_driver(struct isa_driver *, unsigned int);
>  void isa_unregister_driver(struct isa_driver *);
> +#else
> +static inline int isa_register_driver(struct isa_driver *d, unsigned int i)
> +{
> +	return 0;
> +}
> +
> +static inline void isa_unregister_driver(struct isa_driver *d)
> +{
> +}
> +#endif
>  
>  #endif /* __LINUX_ISA_H */
> 

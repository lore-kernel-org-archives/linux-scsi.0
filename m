From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [2.6 patch] more MCA_LEGACY dependencies
Date: Fri, 2 Jul 2004 20:30:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040702183004.GJ28324@fs.tum.de>
References: <20040702002459.GI28324@fs.tum.de> <20040702130719.GC13384@lorien.prodam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:24036 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264893AbUGBSaP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2004 14:30:15 -0400
Content-Disposition: inline
In-Reply-To: <20040702130719.GC13384@lorien.prodam>
List-Id: linux-scsi@vger.kernel.org
To: mcalinux@acc.umu.se, tao@acc.umu.se, linux-kernel@vger.kernel.org, jgarzik@pobox.com, linux-net@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Fri, Jul 02, 2004 at 10:07:19AM -0300, Luiz Fernando N. Capitulino wrote:
>...
> |  static int __init smctr_chk_mca(struct net_device *dev)
> |  {
> | -#ifdef CONFIG_MCA
> | +#ifdef CONFIG_MCA_LEGACY
> |  	struct net_local *tp = netdev_priv(dev);
> |  	int current_slot;
> |  	__u8 r1, r2, r3, r4, r5;
> | @@ -626,7 +626,7 @@
> |  	return (0);
> |  #else
> |  	return (-1);
> | -#endif /* CONFIG_MCA */
> | +#endif /* CONFIG_MCA_LEGACY */
> |  }
> 
>  what about doing things like that for #ifdef/#endif inside
> functions? (not compiled):
>...
> +#ifdef CONFIG_MCA_LEGACY
>  static int __init smctr_chk_mca(struct net_device *dev)
>  {
> -#ifdef CONFIG_MCA
>  	struct net_local *tp = netdev_priv(dev);
>  	int current_slot;
>  	__u8 r1, r2, r3, r4, r5;
>...
> --- a/drivers/net/tokenring/smctr.h	2003-10-08 16:24:14.000000000 -0300
> +++ a~/drivers/net/tokenring/smctr.h	2004-07-02 09:56:56.000000000 -0300
> @@ -9,6 +9,11 @@
>  
>  #ifdef __KERNEL__
>  
> +/* when !CONFIG_MCA_LEGACY */
> +#ifndef CONFIG_MCA_LEGACY
> +static inline smctr_chk_mca(struct net_device *dev) { return (-1); }
> +#endif
> +
>...

What's the advantage of your approach?
All it seems to do is to make the code less readable.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Wed, 20 Oct 2010 11:25:19 -0400
Message-ID: <4CBF09DF.8000308@redhat.com>
References: <1287447149-28678-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab0JTPZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 11:25:21 -0400
In-Reply-To: <1287447149-28678-1-git-send-email-huangj@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Hi Jing,

A few more potential issues I noticed after looking through this patch.  
These are not necessarily problems with this patch, but are highlighted 
by the patch.  Perhaps these could be addressed in a subsequent patch or 
patch set?

Rob

> diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
> index 71c0b5a..d60e472 100644
> --- a/drivers/scsi/bfa/bfa_ioc.h
> +++ b/drivers/scsi/bfa/bfa_ioc.h
> @@ -62,9 +62,9 @@ struct bfa_sge_s {
>  };
>  
>  #define bfa_sge_word_swap(__sge) do {					     \
> -	((u32 *)(__sge))[0] = bfa_os_swap32(((u32 *)(__sge))[0]);      \
> -	((u32 *)(__sge))[1] = bfa_os_swap32(((u32 *)(__sge))[1]);      \
> -	((u32 *)(__sge))[2] = bfa_os_swap32(((u32 *)(__sge))[2]);      \
> +	((u32 *)(__sge))[0] = swab32(((u32 *)(__sge))[0]);      \
> +	((u32 *)(__sge))[1] = swab32(((u32 *)(__sge))[1]);      \
> +	((u32 *)(__sge))[2] = swab32(((u32 *)(__sge))[2]);      \
>  } while (0)
>   

Is bfa_sge_word_swap used anywhere?  I didn't see it.

snip

> +#define bfa_mem_read(_raddr, _off)	swab32(readl(((_raddr) + (_off))))
>   
>  #define bfa_mem_write(_raddr, _off, _val)	\
> -					bfa_os_mem_write(_raddr, _off, _val)
> +			writel(swab32((_val)), ((_raddr) + (_off)))
>   

Do bfa_mem_read/write() belong here after your cleanup?  Could you 
explain these a bit if they are required?

snip

> diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
> index d928dca..f9edc75 100644
> --- a/drivers/scsi/bfa/bfa_os_inc.h
> +++ b/drivers/scsi/bfa/bfa_os_inc.h
> @@ -65,12 +65,6 @@ do {									\
>  	((_x) & 0x00ff00) |			\
>  	(((_x) & 0xff0000) >> 16))
>  
> -#define bfa_os_swap32(_x)			\
> -	((((_x) & 0xff) << 24)		|	\
> -	(((_x) & 0x0000ff00) << 8)	|	\
> -	(((_x) & 0x00ff0000) >> 8)	|	\
> -	(((_x) & 0xff000000) >> 24))
> -
>  #define bfa_os_swap_sgaddr(_x)  ((u64)(                                 \
>  	(((u64)(_x) & (u64)0x00000000000000ffull) << 32)        |       \
>  	(((u64)(_x) & (u64)0x000000000000ff00ull) << 32)        |       \
> @@ -82,7 +76,7 @@ do {									\
>  	(((u64)(_x) & (u64)0xff00000000000000ull) >> 32)))
>   

The sg byte swapping code above lead me to look at the sg code in the 
bfa driver and I saw that bfa doesn't use scsi_for_each_sg() from what I 
can tell.

Is scsi_for_each_sg() use pretty standard for mass storage drivers these 
days?

Is the byte swapping required if the more traditional sg implementation 
is used?

>  
>  #ifndef __BIGENDIAN
> -#define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
> +#define bfa_os_hton3b(_x)  bfa_swap_3b(_x)
>   

Should bfa_os_hton3b and related functionality be relocated 
appropriately and implemented in common form to the other common byte 
swapping code?



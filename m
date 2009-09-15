From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
 resources
Date: Tue, 15 Sep 2009 20:29:38 +1000
Message-ID: <1253010578.8375.220.camel@pasglop>
References: <1252455333-9925-1-git-send-email-pbathija@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:41618 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZIOK3p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2009 06:29:45 -0400
In-Reply-To: <1252455333-9925-1-git-send-email-pbathija@amcc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pbathija@amcc.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org


> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 5d496a9..d5b0f15 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1510,11 +1510,12 @@ static int
>  mpt_mapresources(MPT_ADAPTER *ioc)
>  {
>  	u8		__iomem *mem;
> +	u8		__iomem *port;
>  	int		 ii;
> -	unsigned long	 mem_phys;
> -	unsigned long	 port;
> -	u32		 msize;
> -	u32		 psize;
> +	phys_addr_t	 mem_phys;
> +	phys_addr_t	 port_phys;
> +	resource_size_t	 msize;
> +	resource_size_t	 psize;

Is phys_addr_t defined for all archs nowadays ? Why not use
resource_size_t for everything ? resource_size_t is a bit of a misnomer,
it's not a type supposed to reference a "size" but really a physical
address (or a size)... it's been called resource_size_t I believe
because it's "sized" appropriately for holding a physical address.

Cheers,
Ben.



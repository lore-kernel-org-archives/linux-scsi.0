From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: add writeq definition if needed
Date: Wed, 09 Jun 2010 11:04:17 -0500
Message-ID: <4C0FBB81.1040803@linux.vnet.ibm.com>
References: <20100608224308.499532262@linux.vnet.ibm.com> <4C0FB247.7000007@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56197 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab0FIQSB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2010 12:18:01 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o59GGQPe015747
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2010 12:16:26 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o59GG51b125716
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2010 12:17:58 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o59G4EXZ030156
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2010 10:04:15 -0600
In-Reply-To: <4C0FB247.7000007@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: ben@decadent.org.uk, James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 06/09/2010 10:24 AM, Wayne Boyer wrote:
> Compiling the driver will fail on 32 bit powerpc and other
> architectures where writeq is not defined.  This patch adds a
> definition for writeq.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-06-08 10:06:48.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-06-08 15:14:42.000000000 -0700
> @@ -1860,4 +1860,12 @@ static inline int ipr_sdt_is_fmt2(u32 sd
>  	return 0;
>  }
> 
> +#ifndef writeq
> +static inline void writeq(u64 val, void __iomem *addr)
> +{
> +        writel(((u32) (val >> 32)), addr);
> +        writel(((u32) (val)), (addr + 4));
> +}
>  #endif
> +
> +#endif /* _IPR_H */
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center



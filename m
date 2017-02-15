From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/16] aacraid: Prevent E3 lockup when deleting units
Date: Wed, 15 Feb 2017 09:20:06 +0100
Message-ID: <20bffbde-6a46-96f3-f0ee-889d9a029721@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-5-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750859AbdBOIUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:20:12 -0500
In-Reply-To: <20170214204446.14808-5-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> Arrconf management utility at times sends fibs with AdapterProcessed set
> in its fibs. This causes the controller to panic and lockup.
> 
> Fixed by failing the commands that have AdapterProcessed set in its flag.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 6220b47..f7a3bcb 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -522,6 +522,10 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
>  
>  	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
>  		return -EBUSY;
> +
> +	if (hw_fib->header.XferState & cpu_to_le32(AdapterProcessed))
> +		return -EINVAL;
> +

As far as I can see the fib_xfer_state enum isn't an exported as an
official ABI, so it's a good candidate (whole of aacraid.h actually) for
the next round of camel case removals.

Anyways, this can wait:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

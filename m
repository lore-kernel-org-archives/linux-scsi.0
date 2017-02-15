From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 12/16] aacraid: Skip IOP reset on controller panic(SMART
 Family)
Date: Wed, 15 Feb 2017 09:49:10 +0100
Message-ID: <a94e11f2-1a59-0454-416b-8a1139cb2794@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-13-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdBOItM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:49:12 -0500
In-Reply-To: <20170214204446.14808-13-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> When the SMART family of controller panic (KERNEL_PANIC) , they do not
                            ^ controllers?                ^ extra space
> honor IOP resets. So better to skip it and directly perform a IWBR reset.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---
>  drivers/scsi/aacraid/src.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index b23c818..5bb9865 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -714,6 +714,12 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
>  		pr_err("%s%d: adapter kernel panic'd %x.\n",
>  				dev->name, dev->id, bled);
>  
> +	/*
> +	 * WHen there is a BlinkLED, IOP_RESET has not effect
           ^ When
> +	 */
> +	if (bled >= 2 && dev->sa_firmware && (reset_type & HW_IOP_RESET))
                                             ^ No need for the
                                               parenthesis
> +		reset_type &= ~HW_IOP_RESET;
> +
>  	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
>  
>  	switch (reset_type) {
> 

Apart from that,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

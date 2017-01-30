From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 08/24] aacraid: Added support for response path
Date: Mon, 30 Jan 2017 10:50:06 +0100
Message-ID: <20170130095006.GE3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-9-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbdA3JuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 04:50:14 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-9-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:37AM -0800, Raghava Aditya Renukunta wrote:
> This patch enables the driver to actually process the I/O, or srb replies
> from adapter. In addition to any HBA1000 or SmartIOC2000 adapter events.
> 
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

Sorry for not completely reviewing the patchset before you reposted.

> @@ -475,16 +475,26 @@ int aac_get_containers(struct aac_dev *dev)
>  
>  	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
>  		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
> -	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
> -			GFP_KERNEL);
> -	if (!fsa_dev_ptr)
> -		return -ENOMEM;
> +	if ((dev->fsa_dev == NULL) ||
> +		(dev->maximum_num_containers != maximum_num_containers)) {
> +
> +		fsa_dev_ptr = dev->fsa_dev;

Comparison has precedence over logical OR. See
http://en.cppreference.com/w/c/language/operator_precedence


>  
> -	dev->fsa_dev = fsa_dev_ptr;
> -	dev->maximum_num_containers = maximum_num_containers;
> +		dev->fsa_dev = kzalloc(sizeof(*fsa_dev_ptr) *
> +				maximum_num_containers,	GFP_KERNEL);

kcalloc()?

[...]


> @@ -251,8 +250,9 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
>  	BUG_ON(fibptr == NULL);
>  	dev = fibptr->dev;
>  
> -	if (fibptr->hw_fib_va->header.XferState &
> -	    cpu_to_le32(NoMoreAifDataAvailable)) {
> +	if ((fibptr->hw_fib_va->header.XferState &
> +	    cpu_to_le32(NoMoreAifDataAvailable)) ||
> +		dev->sa_firmware) {

Again unnecessary parenthesis.

>  		aac_fib_complete(fibptr);
>  		aac_fib_free(fibptr);
>  		return;
> @@ -282,8 +282,8 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
>   *	know there is a response on our normal priority queue. We will pull off
>   *	all QE there are and wake up all the waiters before exiting.
>   */
> -unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
> -			int isAif, int isFastResponse, struct hw_fib *aif_fib)
> +unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
> +	int isFastResponse, struct hw_fib *aif_fib)

Isn't this exactly the same but now with broken indent?

[...]

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

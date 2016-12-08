From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] ibmvscsi: add write memory barrier to CRQ processing
Date: Thu, 8 Dec 2016 10:06:43 +0100
Message-ID: <20161208090643.GC4789@linux-x5ow.site>
References: <1481153486-5185-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34105 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750827AbcLHJGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 04:06:46 -0500
Content-Disposition: inline
In-Reply-To: <1481153486-5185-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com

On Wed, Dec 07, 2016 at 05:31:26PM -0600, Tyrel Datwyler wrote:
> The first byte of each CRQ entry is used to indicate whether an entry is
> a valid response or free for the VIOS to use. After processing a
> response the driver sets the valid byte to zero to indicate the entry is
> now free to be reused. Add a memory barrier after this write to ensure
> no other stores are reordered when updating the valid byte.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index d9534ee..2f5b07e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -232,6 +232,7 @@ static void ibmvscsi_task(void *data)
>  		while ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
>  			ibmvscsi_handle_crq(crq, hostdata);
>  			crq->valid = VIOSRP_CRQ_FREE;
> +			wmb();
>  		}
>  
>  		vio_enable_interrupts(vdev);
> @@ -240,6 +241,7 @@ static void ibmvscsi_task(void *data)
>  			vio_disable_interrupts(vdev);
>  			ibmvscsi_handle_crq(crq, hostdata);
>  			crq->valid = VIOSRP_CRQ_FREE;
> +			wmb();
>  		} else {
>  			done = 1;
>  		}

Is this something you have seen in the wild or just a "better save than sorry"
barrier?

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

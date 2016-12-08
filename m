From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] ibmvscsi: add write memory barrier to CRQ processing
Date: Fri, 9 Dec 2016 00:29:08 +0100
Message-ID: <272a1724-be64-9e5f-c5bb-3b71f389f029@redhat.com>
References: <1481153486-5185-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34641 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932457AbcLHX3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2016 18:29:17 -0500
Received: by mail-wm0-f66.google.com with SMTP id g23so317825wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2016 15:29:16 -0800 (PST)
In-Reply-To: <1481153486-5185-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com



On 08/12/2016 00:31, Tyrel Datwyler wrote:
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

Should this driver use virt_wmb instead?

Paolo

>  		} else {
>  			done = 1;
>  		}
> 

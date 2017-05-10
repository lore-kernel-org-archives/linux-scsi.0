From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sg: don't return bogus Sg_requests
Date: Wed, 10 May 2017 09:47:00 +0200
Message-ID: <2a250d8f-15f8-a23a-89d6-2df3983a4385@suse.de>
References: <20170510074139.11179-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510074139.11179-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Andrey Konovalov <andreyknvl@google.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 05/10/2017 09:41 AM, Johannes Thumshirn wrote:
> If the list search in sg_get_rq_mark() fails to find a valid request, we
> return a bogus element. This then can later lead to a GPF in sg_remove_scat().
> 
> So don't return bogus Sg_requests in sg_get_rq_mark() but NULL in case the
> list search doesn't find a valid request.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/sg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0a38ba01b7b4..abfde23fa186 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2078,7 +2078,7 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
>  		}
>  	}
>  	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> -	return resp;
> +	return (resp->done == 2) ? resp : NULL;
>  }
>  
>  /* always adds to end of list */
> 
Not quite.
Please return 'resp' directly from within the loop.
With this fix we run into the risk that by chance the uninitialized
'resp' pointer contains a '2' at the 'done' location, triggering this
issue again.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

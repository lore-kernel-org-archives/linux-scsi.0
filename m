From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi: sg: don't return bogus Sg_requests
Date: Wed, 10 May 2017 15:37:56 -0400
Message-ID: <ec8d85ca-10c6-b857-049d-74fedc55aba7@interlog.com>
References: <20170510075340.12125-1-jthumshirn@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510075340.12125-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Andrey Konovalov <andreyknvl@google.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 2017-05-10 03:53 AM, Johannes Thumshirn wrote:
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
> Changes to v1:
> * Directly return found element within the loop (Hannes)
>
>  drivers/scsi/sg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0a38ba01b7b4..82c33a6edbea 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2074,11 +2074,12 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
>  		if ((1 == resp->done) && (!resp->sg_io_owned) &&
>  		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
>  			resp->done = 2;	/* guard against other readers */
> -			break;
> +			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> +			return resp;
>  		}
>  	}
>  	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> -	return resp;
> +	return NULL;
>  }
>
>  /* always adds to end of list */
>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

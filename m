From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/9] dm-mpath: don't call scsi_dh_attach when we want to
 retain the attached handler
Date: Thu, 30 Apr 2015 14:25:35 -0400
Message-ID: <20150430182535.GC30542@redhat.com>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
 <1430415151-30948-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbD3SZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 14:25:36 -0400
Content-Disposition: inline
In-Reply-To: <1430415151-30948-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, Apr 30 2015 at  1:32pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-mpath.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 9fb91ca..f6d40d3 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -591,9 +591,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  			kfree(m->hw_handler_params);
>  			m->hw_handler_params = NULL;
>  		}
> -	}
> -
> -	if (m->hw_handler_name) {
> +	} else if (m->hw_handler_name) {
>  		/*
>  		 * Increments scsi_dh reference, even when using an
>  		 * already-attached handler.
> @@ -604,15 +602,15 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  			dm_put_device(ti, p->path.dev);
>  			goto bad;
>  		}
> +	}
>  
> -		if (m->hw_handler_params) {
> -			r = scsi_dh_set_params(q, m->hw_handler_params);
> -			if (r < 0) {
> -				ti->error = "unable to set hardware "
> -							"handler parameters";
> -				dm_put_device(ti, p->path.dev);
> -				goto bad;
> -			}
> +	if (m->hw_handler_name && m->hw_handler_params) {
> +		r = scsi_dh_set_params(q, m->hw_handler_params);
> +		if (r < 0) {
> +			ti->error = "unable to set hardware "
> +						"handler parameters";
> +			dm_put_device(ti, p->path.dev);
> +			goto bad;
>  		}
>  	}
>  

Would prefer to see the old weird error message line wrapping fixed up
to be on a single line (80 cols be damned).

Acked-by: Mike Snitzer <snitzer@redhat.com>

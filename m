From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] RFC: have dm-mpath use already attached
	scsi_dh
Date: Wed, 22 Apr 2009 10:32:24 -0700
Message-ID: <1240421544.19442.6.camel@chandra-ubuntu>
References: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu>
	<49EEE071.9060902@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49EEE071.9060902@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I agree with Hannes, that we should allow multipath to override the
default attachment, mainly to give control to the user.

But, I have a small issue with the attached patch. See below.

On Wed, 2009-04-22 at 11:16 +0200, Hannes Reinecke wrote:
> Hi Mike,
> 
<snip>

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 095f77b..46d01d9 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -592,12 +592,25 @@ static struct pgpath *parse_path(struct arg_set
> *as, struct path_selector *ps,
>  	}
> 
>  	if (m->hw_handler_name) {
> -		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
> -				   m->hw_handler_name);
> +		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
> +
> +		r = scsi_dh_attach(q, m->hw_handler_name);
> +		if (r == -EBUSY) {
> +			/*
> +			 * Already attached to different hw_handler,
> +			 * try to reattach with correct one.
> +			 */
> +			scsi_dh_detach(q);
> +			r = scsi_dh_attach(q, m->hw_handler_name);
> +		}
>  		if (r < 0) {
> +			ti->error = "error attaching hardware handler";
>  			dm_put_device(ti, p->path.dev);
>  			goto bad;
>  		}
> +	} else {
> +		/* Play safe and detach hardware handler */
> +		scsi_dh_detach(bdev_get_queue(p->path.dev->bdev));
>  	}

I prefer not to detach a previously attached hardware handler, if
multipath doesn't have any handler associated with the device. Leaving
it will not do any hard to multipath as the multipath layer would not
call scsi_dh_activate for the device.

Device handler would just handle the sense code as defined in the
kernel.
 
> 
>  	r = ps->type->add_path(ps, &p->path, as->argc, as->argv,
> &ti->error);

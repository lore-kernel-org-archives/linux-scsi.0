From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-mpath: Allow 'default' hardware handler
Date: Mon, 2 Apr 2012 13:04:26 -0400
Message-ID: <20120402170426.GA28901@redhat.com>
References: <1333385035-6663-1-git-send-email-hare@suse.de>
 <1333385035-6663-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2DBREh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 13:04:37 -0400
Content-Disposition: inline
In-Reply-To: <1333385035-6663-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Mon, Apr 02 2012 at 12:43pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> This patch introduces a 'default' hardware handler for dm-mpath.
> When specifying '1 default' dm-multipath will be using the currently
> attached hardware handler.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 922a338..bbf950f 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -586,15 +586,19 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  
>  	if (m->hw_handler_name) {
>  		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
> +		char *hw_handler = NULL;
>  
> -		r = scsi_dh_attach(q, m->hw_handler_name);
> +		if (strncmp(m->hw_handler_name, "default", 6))
> +			hw_handler = m->hw_handler_name;

Should be: if (strncmp(m->hw_handler_name, "default", 7))

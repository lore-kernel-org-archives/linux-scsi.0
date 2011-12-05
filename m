From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-mpath: Clear map_context pointer when
 requeuing
Date: Mon, 05 Dec 2011 09:15:03 -0500
Message-ID: <1323094503.2159.9.camel@f14-work>
References: <1322663118-53387-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1LEOQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Dec 2011 09:16:25 -0500
In-Reply-To: <1322663118-53387-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, James Bottomley <jbottomley@parallels.com>

On Wed, 2011-11-30 at 15:25 +0100, Hannes Reinecke wrote:
> When requeing a request we should be clearing the map_context
> pointer, otherwise we might access an invalid memory location.
> 
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/md/dm-mpath.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5e0090e..e6fad46 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
>  	map_context->ptr = mpio;
>  	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
>  	r = map_io(m, clone, mpio, 0);
> -	if (r < 0 || r == DM_MAPIO_REQUEUE)
> +	if (r < 0 || r == DM_MAPIO_REQUEUE) {
>  		mempool_free(mpio, m->mpio_pool);
> +		map_context->ptr = NULL;
> +	}
>  
>  	return r;
>  }

Ack.




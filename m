From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] md: raid10: add prerequisite to run underneath dm-raid
Date: Tue, 03 May 2016 13:51:22 -0400
Message-ID: <1462297882.16133.40.camel@HansenPartnership.com>
References: <1462297378-771-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58168 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933771AbcECRvZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2016 13:51:25 -0400
In-Reply-To: <1462297378-771-1-git-send-email-heinzm@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: heinzm@redhat.com, linux-scsi@vger.kernel.org

On Tue, 2016-05-03 at 19:42 +0200, heinzm@redhat.com wrote:
> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> In case md runs underneath the dm-raid target, the mddev does not 
> have a request queue or gendisk, thus avoid accesses to it.
> 
> This patch adds two missing conditionals to the raid10 personality.

-EWRONGLIST.  drivers/md is handled by linux-raid@vger.kernel.org

James

> 
> Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>
> 
> ---
>  drivers/md/raid10.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e3fd725..84e24e6 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3782,8 +3782,10 @@ static int raid10_resize(struct mddev *mddev,
> sector_t sectors)
>  			return ret;
>  	}
>  	md_set_array_sectors(mddev, size);
> -	set_capacity(mddev->gendisk, mddev->array_sectors);
> -	revalidate_disk(mddev->gendisk);
> +	if (mddev->queue) {
> +		set_capacity(mddev->gendisk, mddev->array_sectors);
> +		revalidate_disk(mddev->gendisk);
> +	}
>  	if (sectors > mddev->dev_sectors &&
>  	    mddev->recovery_cp > oldsize) {
>  		mddev->recovery_cp = oldsize;
> @@ -4593,8 +4595,10 @@ static void raid10_finish_reshape(struct mddev
> *mddev)
>  			set_bit(MD_RECOVERY_NEEDED, &mddev
> ->recovery);
>  		}
>  		mddev->resync_max_sectors = size;
> -		set_capacity(mddev->gendisk, mddev->array_sectors);
> -		revalidate_disk(mddev->gendisk);
> +		if (mddev->queue) {
> +			set_capacity(mddev->gendisk, mddev
> ->array_sectors);
> +			revalidate_disk(mddev->gendisk);
> +		}
>  	} else {
>  		int d;
>  		for (d = conf->geo.raid_disks ;


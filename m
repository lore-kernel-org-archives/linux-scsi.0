From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/1] block: don't overwrite max_sectors if user has set
 it
Date: Fri, 10 Apr 2015 14:04:49 -0400
Message-ID: <1428689089.4807.191.camel@localhost.localdomain>
References: <1428649720-14316-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbbDJSG7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 14:06:59 -0400
In-Reply-To: <1428649720-14316-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, axboe@fb.com

On Fri, 2015-04-10 at 02:08 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> If the user has set max_sectors in sysfs, but the disk is revalidated
> due to it being removable or having write protections and it being
> opened, or dm/md claiming it, or something like a scsi rescan, etc,
> then we are overwriting the user specified max_sectors value. This patch
> only has us set the max_sectors if the new max_hw_sectors is smaller
> or if the user has not changed max_sectors.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  block/blk-settings.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 12600bf..d6c7b0c 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -248,6 +248,10 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
>   *    filesystem type requests.  This value can be overridden on a
>   *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
>   *    The soft limit can not exceed max_hw_sectors.
> + *
> + *    If this is called as a result of a revalidation then we will only
> + *    override the user specified max_sectors if the new max_hw_sectors is
> + *    smaller.
>   **/
>  void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_sectors)
>  {
> @@ -257,7 +261,11 @@ void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_
>  		       __func__, max_hw_sectors);
>  	}
>  
> -	limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
> +	if (limits->max_sectors == limits->max_hw_sectors ||
> +	    max_hw_sectors < limits->max_sectors)
> +		limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
> +	else
> +		limits->max_hw_sectors = max_hw_sectors;
>  }
>  EXPORT_SYMBOL(blk_limits_max_hw_sectors);
>  

Thanks for posting this, Mike.

(For some context, this fixes a problem where a user had a storage
array connected via iSCSI that reported incorrect information in the
block limits VPD page, and generated an error on a large write.  Setting
max_sectors_kb via sysfs didn't fix it because the value was being
overwritten when the iSCSI connection was re-established.)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



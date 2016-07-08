From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/2] sd: don't use the ALL_TG_PT bit for reservations
Date: Fri, 8 Jul 2016 10:56:18 -0500
Message-ID: <6116ef14-c5f9-f3be-c37e-3f6901b85459@redhat.com>
References: <1467980631-18945-1-git-send-email-hch@lst.de>
 <1467980631-18945-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbcGHP4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2016 11:56:20 -0400
In-Reply-To: <1467980631-18945-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org

On 07/08/2016 07:23 AM, Christoph Hellwig wrote:
> These only work if the we use the same initiator ID for all path,
> which might not be true if we use different protocols, or even just
> different HBAs.
> 
> Instead dm-mpath will grow support to register all path manually
> later in this series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 60bff78..42b4d05 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1613,8 +1613,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
>  		return -EOPNOTSUPP;
>  	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
>  			old_key, new_key, 0,
> -			(1 << 0) /* APTPL */ |
> -			(1 << 2) /* ALL_TG_PT */);
> +			(1 << 0) /* APTPL */);
>  }
>  
>  static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

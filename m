From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] [SCSI] target: checking for NULL instead of IS_ERR
Date: Sat, 15 Jan 2011 12:52:24 -0800
Message-ID: <1295124744.22813.8.camel@haakon2.linux-iscsi.org>
References: <20110115140300.GC2721@bicker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110115140300.GC2721@bicker>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-01-15 at 17:03 +0300, Dan Carpenter wrote:
> blkdev_get_by_path() returns an ERR_PTR() or error and it doesn't return
> a NULL.  It looks like this bug would be easy to trigger by mistake.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Good catch here Dan..  This was added after a linux-next build failure
over the holidays, but I completely missed the fact that it returns
ERR_PTR..  Thanks for spotting this one!

The same problem exists in target_core_pscsi.c:pscsi_create_type_disk()
as well..  Committed both fixes as 862ede4cbaf in
lio-core-2.6.git/linus-38-rc1 against the .38 mainline target merge, and
cherry picked into scsi-post-merge-2.6.git/for-jejb..

James, please make sure this fix is included in your next pull to Linus.

--nab

> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index c6e0d75..3456135 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -154,7 +154,7 @@ static struct se_device *iblock_create_virtdevice(
>  
>  	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
>  				FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
> -	if (!(bd))
> +	if (IS_ERR(bd))
>  		goto failed;
>  	/*
>  	 * Setup the local scope queue_limits from struct request_queue->limits

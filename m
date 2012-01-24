From: walter harms <wharms@bfs.de>
Subject: Re: [patch] target: handle empty string writes in sysfs
Date: Tue, 24 Jan 2012 11:55:45 +0100
Message-ID: <4F1E8E31.1070507@bfs.de>
References: <20120124084036.GB29097@elgon.mountain>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120124084036.GB29097@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 24.01.2012 09:40, schrieb Dan Carpenter:
> These are root only and we're not likely to hit the problem in practise,
> but it makes a the static checkers happy.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 0955bb8..9b86330 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1707,6 +1707,8 @@ static ssize_t target_core_store_dev_alias(
>  	se_dev->su_dev_flags |= SDF_USING_ALIAS;
>  	read_bytes = snprintf(&se_dev->se_dev_alias[0], SE_DEV_ALIAS_LEN,
>  			"%s", page);

Would it help to check page==NULL or *page==0 at start ?
Now you have se_dev->su_dev_flags initialised.

re,
 wh


> +	if (read_bytes == 0)
> +		return -EINVAL;
>  
>  	if (se_dev->se_dev_alias[read_bytes - 1] == '\n')
>  		se_dev->se_dev_alias[read_bytes - 1] = '\0';
> @@ -1756,6 +1758,8 @@ static ssize_t target_core_store_dev_udev_path(
>  	se_dev->su_dev_flags |= SDF_USING_UDEV_PATH;
>  	read_bytes = snprintf(&se_dev->se_dev_udev_path[0], SE_UDEV_PATH_LEN,
>  			"%s", page);
> +	if (read_bytes == 0)
> +		return -EINVAL;
>  
>  	if (se_dev->se_dev_udev_path[read_bytes - 1] == '\n')
>  		se_dev->se_dev_udev_path[read_bytes - 1] = '\0';
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

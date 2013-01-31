From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch 2/2] target: don't truncate the fail intr address
Date: Thu, 31 Jan 2013 12:31:40 -0800
Message-ID: <1359664300.6300.30.camel@haakon2.linux-iscsi.org>
References: <20130131081909.GC14812@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51667 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3AaUbm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2013 15:31:42 -0500
In-Reply-To: <20130131081909.GC14812@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 2013-01-31 at 11:19 +0300, Dan Carpenter wrote:
> The temporary buffer was only 32 characters but ->last_intr_fail_ip_addr
> is a 48 character buffer.  We don't need to use a temporary buffer at
> all, we can just print directly to "page".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Also applied to for-next.

Thanks Dan!

--nab

> Compile tested only.
> 
> diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
> index 54a6f38..464b420 100644
> --- a/drivers/target/iscsi/iscsi_target_stat.c
> +++ b/drivers/target/iscsi/iscsi_target_stat.c
> @@ -429,16 +429,19 @@ static ssize_t iscsi_stat_tgt_attr_show_attr_fail_intr_addr(
>  	struct iscsi_tiqn *tiqn = container_of(igrps,
>  			struct iscsi_tiqn, tiqn_stat_grps);
>  	struct iscsi_login_stats *lstat = &tiqn->login_stats;
> -	unsigned char buf[32];
> +	int ret;
>  
>  	spin_lock(&lstat->lock);
> -	if (lstat->last_intr_fail_ip_family == AF_INET6)
> -		snprintf(buf, 32, "[%s]", lstat->last_intr_fail_ip_addr);
> -	else
> -		snprintf(buf, 32, "%s", lstat->last_intr_fail_ip_addr);
> +	if (lstat->last_intr_fail_ip_family == AF_INET6) {
> +		ret = snprintf(page, PAGE_SIZE, "[%s]\n",
> +			       lstat->last_intr_fail_ip_addr);
> +	} else {
> +		ret = snprintf(page, PAGE_SIZE, "%s\n",
> +			       lstat->last_intr_fail_ip_addr);
> +	}
>  	spin_unlock(&lstat->lock);
>  
> -	return snprintf(page, PAGE_SIZE, "%s\n", buf);
> +	return ret;
>  }
>  ISCSI_STAT_TGT_ATTR_RO(fail_intr_addr);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



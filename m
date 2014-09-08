From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [patch] xen-scsiback: clean up a type issue in scsiback_make_tpg()
Date: Mon, 08 Sep 2014 13:31:57 +0200
Message-ID: <540D93AD.3050500@suse.com>
References: <20140908111735.GB6947@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaIHLb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 07:31:59 -0400
In-Reply-To: <20140908111735.GB6947@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>

On 09/08/2014 01:17 PM, Dan Carpenter wrote:
> This code was confusing because we had an unsigned long and then we
> compared it to UINT_MAX and then we stored it in a u16.  How many bytes
> is this supposed to have: 2, 4 or 16???
>
> I've made it a u16 throughout.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Juergen Gross <jgross@suse.com>

Thanks,

Juergen

>
> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index 7b565632..ad11258 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -1885,13 +1885,14 @@ scsiback_make_tpg(struct se_wwn *wwn,
>   			struct scsiback_tport, tport_wwn);
>
>   	struct scsiback_tpg *tpg;
> -	unsigned long tpgt;
> +	u16 tpgt;
>   	int ret;
>
>   	if (strstr(name, "tpgt_") != name)
>   		return ERR_PTR(-EINVAL);
> -	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
> -		return ERR_PTR(-EINVAL);
> +	ret = kstrtou16(name + 5, 10, &tpgt);
> +	if (ret)
> +		return ERR_PTR(ret);
>
>   	tpg = kzalloc(sizeof(struct scsiback_tpg), GFP_KERNEL);
>   	if (!tpg)
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>


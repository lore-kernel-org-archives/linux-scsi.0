From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] tcm_qla2xxx: checking for NULL instead of IS_ERR()
Date: Thu, 15 Mar 2012 16:13:05 -0700
Message-ID: <1331853185.10203.129.camel@haakon2.linux-iscsi.org>
References: <20120313172119.GE31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43074 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031229Ab2COXNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 19:13:08 -0400
In-Reply-To: <20120313172119.GE31808@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, 2012-03-13 at 20:21 +0300, Dan Carpenter wrote:
> target_fabric_configfs_init() never returns NULLs, only ERR_PTRs.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index dcbcedc..08cf507 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1885,9 +1885,9 @@ static int tcm_qla2xxx_register_configfs(void)
>  	 * Register the top level struct config_item_type for NPIV with TCM core
>  	 */
>  	npiv_fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npiv");
> -	if (!npiv_fabric) {
> +	if (IS_ERR(npiv_fabric)) {
>  		pr_err("target_fabric_configfs_init() failed\n");
> -		ret = -ENOMEM;
> +		ret = PTR_ERR(npiv_fabric);
>  		goto out_fabric;
>  	}
>  	/*

Doh, missed this fix for the qla2xxx_npiv fabric_ops allocation..
Applied to lio-core and will get fixed up for-next-merge.

Thanks Dan!

--nab


From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] iscsi-target: NULL dereference on allocation failure
Date: Wed, 27 Jul 2011 12:35:14 -0700
Message-ID: <1311795314.6931.7.camel@haakon2.linux-iscsi.org>
References: <20110727095817.GM3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36974 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab1G0Too (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 15:44:44 -0400
In-Reply-To: <20110727095817.GM3824@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Wed, 2011-07-27 at 12:58 +0300, Dan Carpenter wrote:
> The "goto out" path dereferences "login" which is NULL.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 713a4d2..4d087ac 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -978,7 +978,7 @@ struct iscsi_login *iscsi_target_init_negotiation(
>  		pr_err("Unable to allocate memory for struct iscsi_login.\n");
>  		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
>  				ISCSI_LOGIN_STATUS_NO_RESOURCES);
> -		goto out;
> +		return NULL;
>  	}
>  
>  	login->req = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);

Thanks for catching this Dan!  Committed as b5bddbe9e6

--nab


From: scameron@beardog.cce.hp.com
Subject: Re: [RFC PATCH] hpsa: Change memset using sizeof(ptr) to sizeof(*ptr)
Date: Mon, 9 May 2011 08:52:51 -0500
Message-ID: <20110509135251.GE5997@beardog.cce.hp.com>
References: <1304922760.19586.30.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:44158 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1EINwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2011 09:52:53 -0400
Content-Disposition: inline
In-Reply-To: <1304922760.19586.30.camel@Joe-Laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 11:32:40PM -0700, Joe Perches wrote:
> Not at all sure this is correct or appropriate to change,
> but this seems odd.
> 
> Found via coccinelle script

Ack.

-- steve

> 
> @@
> type T;
> T* ptr;
> expression E1;
> @@
> 
> * memset(E1, 0, sizeof(ptr));
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/hpsa.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 415ad4f..c8d97b4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1308,7 +1308,7 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
>  	int retry_count = 0;
>  
>  	do {
> -		memset(c->err_info, 0, sizeof(c->err_info));
> +		memset(c->err_info, 0, sizeof(*c->err_info));
>  		hpsa_scsi_do_simple_cmd_core(h, c);
>  		retry_count++;
>  	} while (check_for_unit_attention(h, c) && retry_count <= 3);
> 

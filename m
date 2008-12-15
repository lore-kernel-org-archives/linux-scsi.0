From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)
Date: Mon, 15 Dec 2008 10:44:20 -0600
Message-ID: <49468964.605@cs.wisc.edu>
References: <Pine.LNX.4.64.0811191525290.15796@fi-hi32-dhcp068123.emea.nsn-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36683 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbYLOQo3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 11:44:29 -0500
In-Reply-To: <Pine.LNX.4.64.0811191525290.15796@fi-hi32-dhcp068123.emea.nsn-net.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

Koskinen Aaro (NSN - FI/Helsinki) wrote:
> Fix for the sym53c8xx_2 driver to initialize lun's to_clear flag after
> a bus reset (a failed clear can trigger a bus reset and it should not
> be attemped again after that).
> 
> Signed-off-by: aaro.koskinen@nsn.com
> 

I think you just want to fix up your signed off line to be: 
Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>

James might to that for you when he merges it so you do not have to resend.


> ---
> 
> diff -uprN -X linux-2.6.27.5-orig/Documentation/dontdiff linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.c linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.c
> --- linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-11-07 19:55:34.000000000 +0200
> +++ linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-11-19 12:20:27.000000000 +0200
> @@ -1897,6 +1897,15 @@ void sym_start_up(struct Scsi_Host *shos
>  		tp->head.sval = 0;
>  		tp->head.wval = np->rv_scntl3;
>  		tp->head.uval = 0;
> +		if (tp->lun0p)
> +			tp->lun0p->to_clear = 0;
> +		if (tp->lunmp) {
> +			int ln;
> +
> +			for (ln = 1; ln < SYM_CONF_MAX_LUN; ln++)
> +				if (tp->lunmp[ln])
> +					tp->lunmp[ln]->to_clear = 0;
> +		}
>  	}
>  
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


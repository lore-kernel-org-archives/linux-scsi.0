From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 23/30] iscsi: fix crypto_alloc_hash() error check
Date: Mon, 04 Dec 2006 18:20:51 -0600
Message-ID: <4574BB63.2070104@cs.wisc.edu>
References: <200612042319.kB4NJnvj008801@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52027 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967877AbWLEAVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 19:21:05 -0500
In-Reply-To: <200612042319.kB4NJnvj008801@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akinobu.mita@gmail.com, dmitry_yus@yahoo.com, itn780@yahoo.com

akpm@osdl.org wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> The return value of crypto_alloc_hash() should be checked by
> IS_ERR().

Looks good to me.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Either James can merge it or Andrew can forward it or if when I send my
update it is not merged by someone I will resend it.


> 
> Cc: Dmitry Yusupov <dmitry_yus@yahoo.com>
> Cc: Alex Aizman <itn780@yahoo.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/iscsi_tcp.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/iscsi_tcp.c~iscsi-fix-crypto_alloc_hash-error-check drivers/scsi/iscsi_tcp.c
> --- a/drivers/scsi/iscsi_tcp.c~iscsi-fix-crypto_alloc_hash-error-check
> +++ a/drivers/scsi/iscsi_tcp.c
> @@ -1777,13 +1777,13 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
>  	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
>  						  CRYPTO_ALG_ASYNC);
>  	tcp_conn->tx_hash.flags = 0;
> -	if (!tcp_conn->tx_hash.tfm)
> +	if (IS_ERR(tcp_conn->tx_hash.tfm))
>  		goto free_tcp_conn;
>  
>  	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
>  						  CRYPTO_ALG_ASYNC);
>  	tcp_conn->rx_hash.flags = 0;
> -	if (!tcp_conn->rx_hash.tfm)
> +	if (IS_ERR(tcp_conn->rx_hash.tfm))
>  		goto free_tx_tfm;
>  
>  	return cls_conn;
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


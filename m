Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D30CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AA261056
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbhJONjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 09:39:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56098 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239730AbhJONjJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 09:39:09 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mbNOH-0002be-4b; Fri, 15 Oct 2021 21:36:53 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mbNNz-0006se-3m; Fri, 15 Oct 2021 21:36:35 +0800
Date:   Fri, 15 Oct 2021 21:36:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi: select CRYPTO_HASH for ISCSI_TCP
Message-ID: <20211015133635.GA26418@gondor.apana.org.au>
References: <20211015131115.12720-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015131115.12720-1-vegard.nossum@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 15, 2021 at 03:11:15PM +0200, Vegard Nossum wrote:
> Fix the following build/link error by adding a dependency on CRYPTO_HASH:
> 
>   ld: drivers/scsi/libiscsi_tcp.o: in function `iscsi_tcp_dgst_header':
>   libiscsi_tcp.c:(.text+0x237): undefined reference to `crypto_ahash_digest'
>   ld: drivers/scsi/libiscsi_tcp.o: in function `iscsi_tcp_segment_done':
>   libiscsi_tcp.c:(.text+0x1325): undefined reference to `crypto_ahash_final'
> 
> Fixes: 5d6ac29b9ebf2 ("iscsi_tcp: Use ahash")
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  drivers/scsi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 6e3a04107bb65..09764f3c42447 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -290,6 +290,7 @@ config ISCSI_TCP
>  	tristate "iSCSI Initiator over TCP/IP"
>  	depends on SCSI && INET
>  	select CRYPTO
> +	select CRYPTO_HASH
>  	select CRYPTO_MD5
>  	select CRYPTO_CRC32C
>  	select SCSI_ISCSI_ATTRS

CRYPTO_MD5 already selects CRYPTO_HASH so this shouldn't be needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

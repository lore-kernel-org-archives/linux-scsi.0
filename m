Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E17C432BE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AC2611CC
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbhHFOb7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 10:31:59 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:59312 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232085AbhHFOb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 10:31:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D2F4F1281006;
        Fri,  6 Aug 2021 07:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628260302;
        bh=fgmN48V906EE49Jbtzro8T5ElSxfgoQuL3j6K6G3/2w=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=MuZ8ld8RDF4lb4kCN5RuvmW+BunUfwTrYzPcoi91xTjk5ZPE/NDBWvoHu4llQzuU/
         1c2ggOHWK1/JJJlxQdntOKobc+UJChKZ+QQ+ikHd1os2OsFDMSPdBSmtXnQT7qX16n
         18799WjMWmfKI762vLMYCzHhs80x/13kCDkaa1Y0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SDwkYHd5iatn; Fri,  6 Aug 2021 07:31:42 -0700 (PDT)
Received: from [IPv6:2601:600:8280:66d1::c447] (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 530031281004;
        Fri,  6 Aug 2021 07:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628260302;
        bh=fgmN48V906EE49Jbtzro8T5ElSxfgoQuL3j6K6G3/2w=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=MuZ8ld8RDF4lb4kCN5RuvmW+BunUfwTrYzPcoi91xTjk5ZPE/NDBWvoHu4llQzuU/
         1c2ggOHWK1/JJJlxQdntOKobc+UJChKZ+QQ+ikHd1os2OsFDMSPdBSmtXnQT7qX16n
         18799WjMWmfKI762vLMYCzHhs80x/13kCDkaa1Y0=
Message-ID: <1dca71ad49be897f9544d0de59204e42a5b56a50.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 2/9] libata: fix ata_host_start()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Date:   Fri, 06 Aug 2021 07:31:41 -0700
In-Reply-To: <20210806074252.398482-3-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
         <20210806074252.398482-3-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-08-06 at 16:42 +0900, Damien Le Moal wrote:
> The loop on entry of ata_host_start() may not initialize host->ops to
> a non NULL value. The test on the host_stop field of host->ops must
> then be preceded by a check that host->ops is not NULL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/ata/libata-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ea8b91297f12..fe49197caf99 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5573,7 +5573,7 @@ int ata_host_start(struct ata_host *host)
>  			have_stop = 1;
>  	}
>  
> -	if (host->ops->host_stop)
> +	if (host->ops && host->ops->host_stop)

since have_stop was already set by the port ops, surely this entire if
is redundant?

James



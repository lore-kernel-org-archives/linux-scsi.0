Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2D8C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA8861184
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbhHFOZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 10:25:27 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:58440 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238173AbhHFOZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 10:25:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 767C71280FF3;
        Fri,  6 Aug 2021 07:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628259909;
        bh=s5+B4QRewIbzQPdXyLAv3VXyjmXcsQqeb/7Sh6rTCZg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=HMNtluiaXPdn/jITwwT+zK4BZ3CNG37HdJzelgGhwK1iJyrOOWJQzX4Vx9+qXePFM
         lwuKWR70NtWFSOQ/22c+UVyzN10i9Pe6+xZA8Rgq3sFVBZgoXxsd79KORzaS5vucZZ
         k/+t+O3KmuvUth067zUUJtNpADkVfZWBHTMfCi38=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s6r71DMOlSMJ; Fri,  6 Aug 2021 07:25:09 -0700 (PDT)
Received: from [IPv6:2601:600:8280:66d1::c447] (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DF5AE1280FF2;
        Fri,  6 Aug 2021 07:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628259909;
        bh=s5+B4QRewIbzQPdXyLAv3VXyjmXcsQqeb/7Sh6rTCZg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=HMNtluiaXPdn/jITwwT+zK4BZ3CNG37HdJzelgGhwK1iJyrOOWJQzX4Vx9+qXePFM
         lwuKWR70NtWFSOQ/22c+UVyzN10i9Pe6+xZA8Rgq3sFVBZgoXxsd79KORzaS5vucZZ
         k/+t+O3KmuvUth067zUUJtNpADkVfZWBHTMfCi38=
Message-ID: <1647f71e4ef539ff17538223c944d9ec58806bdb.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 1/9] libata: fix ata_host_alloc_pinfo()
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
Date:   Fri, 06 Aug 2021 07:25:07 -0700
In-Reply-To: <20210806074252.398482-2-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
         <20210806074252.398482-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-08-06 at 16:42 +0900, Damien Le Moal wrote:
> Avoid a potential NULL pointer dereference by testing that the ATA
> port
> info variable "pi".
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/ata/libata-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 61c762961ca8..ea8b91297f12 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5458,7 +5458,7 @@ struct ata_host *ata_host_alloc_pinfo(struct
> device *dev,
>  		ap->link.flags |= pi->link_flags;
>  		ap->ops = pi->port_ops;

Hey, pi is used here

>  
> -		if (!host->ops && (pi->port_ops !=
> &ata_dummy_port_ops))
> +		if (!host->ops && pi && pi->port_ops !=
> &ata_dummy_port_ops)

So checking it here is just going to get us a load of static checker
reports.

James



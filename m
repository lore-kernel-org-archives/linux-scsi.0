Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113CCC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA6E64E31
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhBBLRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhBBLRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B531264E06;
        Tue,  2 Feb 2021 11:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612264598;
        bh=TItLPzW1Vft/5u++zB1kQ2ye3inPmcj2u+pb4ObaO4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HfqVr9zIfdAus82HRSRTCtKcSMvKZuFuleeeeQ0miAFdwYknPESGDBqsCGDT9S1Ij
         IYJD8PjMEf+qgYsZoovkwNe32DNFSaZ3p81Vtm74gljqSPf2wJ67rBDw2sp97Fgl//
         YodTqe7Vrae3hNA6JhP8bLFfw2PGA7cVCr2CGrh8=
Date:   Tue, 2 Feb 2021 12:16:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Message-ID: <YBk0kaymYOrrBr8h@kroah.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-4-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202083007.104050-4-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 10:30:01AM +0200, Avri Altman wrote:
> In host control mode, reads are the major source of activation trials.
> Keep track of those reads counters, for both active as well inactive
> regions.
> 
> We reset the read counter upon write - we are only interested in "clean"
> reads.  less intuitive however, is that we also reset it upon region's
> deactivation.  Region deactivation is often due to the fact that
> eviction took place: a region become active on the expense of another.
> This is happening when the max-active-regions limit has crossed. If we
> don’t reset the counter, we will trigger a lot of trashing of the HPB
> database, since few reads (or even one) to the region that was
> deactivated, will trigger a re-activation trial.
> 
> Keep those counters normalized, as we are using those reads as a
> comparative score, to make various decisions.
> If during consecutive normalizations an active region has exhaust its
> reads - inactivate it.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 109 ++++++++++++++++++++++++++++++++------
>  drivers/scsi/ufs/ufshpb.h |   6 +++
>  2 files changed, 100 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 61de80a778a7..de4866d42df0 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -16,6 +16,9 @@
>  #include "ufshpb.h"
>  #include "../sd.h"
>  
> +#define WORK_PENDING 0

This should be next to the variable you define that uses this, right?
Otherwise we would think this is a valid value, when in reality it is
the bit number, correct?

> +#define ACTIVATION_THRSHLD 4 /* 4 IOs */

You can spell things out "ACTIVATION_THRESHOLD" :)

thanks,

greg k-h

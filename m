Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21554C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 17:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF20064FEC
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 17:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCKRRl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 12:17:41 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:42557 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhCKRRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 12:17:32 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id BFFBB2EA2D9;
        Thu, 11 Mar 2021 12:17:31 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 7dcAuVDwxokd; Thu, 11 Mar 2021 12:00:29 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2C5382EA2E9;
        Thu, 11 Mar 2021 12:17:31 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH][next] scsi: sg: Fix use of pointer sfp after it has been
 kfree'd
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210311103717.7523-1-colin.king@canonical.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <a1e80cea-a1b3-9471-8022-2e25eb6c635c@interlog.com>
Date:   Thu, 11 Mar 2021 12:17:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210311103717.7523-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-11 5:37 a.m., Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently SG_LOG is referencing sfp after it has been kfree'd which
> is probably a bad thing to do. Fix this by kfree'ing sfp after
> SG_LOG.
> 
> Addresses-Coverity: ("Use after free")
> Fixes: af1fc95db445 ("scsi: sg: Replace rq array with xarray")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 2d4bbc1a1727..79f05afa4407 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -3799,10 +3799,10 @@ sg_add_sfp(struct sg_device *sdp)
>   	if (rbuf_len > 0) {
>   		srp = sg_build_reserve(sfp, rbuf_len);
>   		if (IS_ERR(srp)) {
> -			kfree(sfp);
>   			err = PTR_ERR(srp);
>   			SG_LOG(1, sfp, "%s: build reserve err=%ld\n", __func__,
>   			       -err);
> +			kfree(sfp);
>   			return ERR_PTR(err);
>   		}
>   		if (srp->sgat_h.buflen < rbuf_len) {
> 


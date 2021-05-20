Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A11C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 04:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A743A611AE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 04:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhETE7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 00:59:08 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:26240 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhETE7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 00:59:08 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d84 with ME
        id 6sxl2500321Fzsu03sxml6; Thu, 20 May 2021 06:57:46 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 20 May 2021 06:57:46 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH] scsi: sni_53c710: Fix a resource leak in an error
 handling path
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        James.Bottomley@SteelEye.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <c1948555-41fe-fc8e-ac27-68d314a05c81@wanadoo.fr>
Date:   Thu, 20 May 2021 06:57:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 20/05/2021 à 06:44, Christophe JAILLET a écrit :
> After a successful 'NCR_700_detect()' call, 'NCR_700_release()' must be
> called to release some DMA related resources, as already done in the
> remove function.
> 
> Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/scsi/sni_53c710.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
> index 678651b9b4dd..f6d60d542207 100644
> --- a/drivers/scsi/sni_53c710.c
> +++ b/drivers/scsi/sni_53c710.c
> @@ -98,6 +98,7 @@ static int snirm710_probe(struct platform_device *dev)
>   
>    out_put_host:
>   	scsi_host_put(host);
> +	NCR_700_release(host);
>    out_kfree:
>   	iounmap(hostdata->base);
>   	kfree(hostdata);
> 
Hi,

please note that this patch is speculative
All the drivers I've look at don't call NCR_700_release in the error 
handling path of the probe. They only do in the remove function.
So it is likely that this patch is wrong and that the truth is elsewhere.

'scsi_host_put()' is used in the probe and 'scsi_remove_host()' in the 
remove function. That maybe is the trick, but I've not been able to see 
how NCR_700_release (or equivalent) was called in this case.

So review with care!

CJ

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E880C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Dec 2020 00:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2012D221E9
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Dec 2020 00:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgL0ArY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Dec 2020 19:47:24 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:60078 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgL0ArY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Dec 2020 19:47:24 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 0CE4F2EA07B;
        Sat, 26 Dec 2020 19:46:43 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id l43aPXFgTGuZ; Sat, 26 Dec 2020 19:34:37 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A7FB52EA02F;
        Sat, 26 Dec 2020 19:46:39 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] [v2] scsi: scsi_debug: Fix memleak in scsi_debug_init
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201226061503.20050-1-dinghao.liu@zju.edu.cn>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <fc129fb4-a255-68cd-92e1-3206ac2b085f@interlog.com>
Date:   Sat, 26 Dec 2020 19:46:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201226061503.20050-1-dinghao.liu@zju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-26 1:15 a.m., Dinghao Liu wrote:
> When sdeb_zbc_model does not match BLK_ZONED_NONE,
> BLK_ZONED_HA or BLK_ZONED_HM, we should free sdebug_q_arr
> to prevent memleak. Also there is no need to execute
> sdebug_erase_store() on failure of sdeb_zbc_model_str().
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
> 
> Changelog:
> 
> v2: - Add missed assignment statement for ret.
> ---
>   drivers/scsi/scsi_debug.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 24c0f7ec0351..4a08c450b756 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6740,7 +6740,7 @@ static int __init scsi_debug_init(void)
>   		k = sdeb_zbc_model_str(sdeb_zbc_model_s);
>   		if (k < 0) {
>   			ret = k;
> -			goto free_vm;
> +			goto free_q_arr;
>   		}
>   		sdeb_zbc_model = k;
>   		switch (sdeb_zbc_model) {
> @@ -6753,7 +6753,8 @@ static int __init scsi_debug_init(void)
>   			break;
>   		default:
>   			pr_err("Invalid ZBC model\n");
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto free_q_arr;
>   		}
>   	}
>   	if (sdeb_zbc_model != BLK_ZONED_NONE) {
> 


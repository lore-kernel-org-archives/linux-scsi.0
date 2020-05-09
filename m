Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617E4C28CBC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 14:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4DD20735
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 14:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgEIOpU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 10:45:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:51126 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgEIOpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 May 2020 10:45:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id EB35220418E;
        Sat,  9 May 2020 16:45:16 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M1NS0c49Laat; Sat,  9 May 2020 16:45:11 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 4386B204150;
        Sat,  9 May 2020 16:45:09 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: scsi_debug: fix an error handling bug in
 sdeb_zbc_model_str()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200509100408.GA5555@mwanda>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <0398fb52-dd1e-bb02-5160-69f2537132b7@interlog.com>
Date:   Sat, 9 May 2020 10:45:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200509100408.GA5555@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-09 6:04 a.m., Dan Carpenter wrote:
> This test is checking the wrong variable.  It should be testing "ret".
> The "sdeb_zbc_model" variable is an enum (unsigned in this situation)
> and we never assign negative values to it.
> 
> Fixes: 9267e0eb41fe ("scsi: scsi_debug: Add ZBC module parameter")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

s/ret/res/ at the end of the first line above.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 105e563d87b4e..73847366dc495 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6460,7 +6460,7 @@ static int sdeb_zbc_model_str(const char *cp)
>   		res = sysfs_match_string(zbc_model_strs_b, cp);
>   		if (res < 0) {
>   			res = sysfs_match_string(zbc_model_strs_c, cp);
> -			if (sdeb_zbc_model < 0)
> +			if (res < 0)
>   				return -EINVAL;
>   		}
>   	}
> 


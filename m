Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B37C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Apr 2022 06:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381407AbiD3GdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Apr 2022 02:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350247AbiD3GdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Apr 2022 02:33:22 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC7939172
        for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2022 23:29:57 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id kgc0nZiwSuIQVkgc0nTrzn; Sat, 30 Apr 2022 08:29:55 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 30 Apr 2022 08:29:55 +0200
X-ME-IP: 86.243.180.246
Message-ID: <794191df-e745-c591-bf1d-37945f96e73a@wanadoo.fr>
Date:   Sat, 30 Apr 2022 08:29:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] scsi: elx: efct: remove unnecessary memset in efct_io
Content-Language: en-US
To:     Wan Jiabing <wanjiabing@vivo.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Newsgroups: gmane.linux.scsi,gmane.linux.scsi.target.devel,gmane.linux.kernel
References: <20220318145230.1031-1-wanjiabing@vivo.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220318145230.1031-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20220430062946.BcgJLY22fHMuM4gMoYMVViUnS6xfeSP2xriIfX8HEg8@z>

Le 18/03/2022 à 15:52, Wan Jiabing a écrit :
> io->sgl is allocated by kzalloc(). The memory is set to zero.
> It is unnecessary to call memset again.
> 

Hi,

Nitpick: this kzalloc() should be a kcalloc() to avoid an open-coded 
multiplication when computing the size to allocate.

CJ


> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>   drivers/scsi/elx/efct/efct_io.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
> index c3247b951a76..c612f0a48839 100644
> --- a/drivers/scsi/elx/efct/efct_io.c
> +++ b/drivers/scsi/elx/efct/efct_io.c
> @@ -62,7 +62,6 @@ efct_io_pool_create(struct efct *efct, u32 num_sgl)
>   			return NULL;
>   		}
>   
> -		memset(io->sgl, 0, sizeof(*io->sgl) * num_sgl);
>   		io->sgl_allocated = num_sgl;
>   		io->sgl_count = 0;
>   


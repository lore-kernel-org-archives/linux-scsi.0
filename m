Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A92C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 10:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68AC361267
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 10:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhKKKVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 05:21:01 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:58672 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKKU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 05:20:58 -0500
Received: from [192.168.1.18] ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id l79imowztS9NTl79im0QLJ; Thu, 11 Nov 2021 11:18:08 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 11 Nov 2021 11:18:08 +0100
X-ME-IP: 86.243.171.122
Subject: Re: [PATCH] scsi: qla2xxx: Fix memory leaks in the error handling
 path of 'qla2x00_mem_alloc()'
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gmalavali@marvell.com, hmadhani@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <cc2fe0148944cfac5e58339bf98e76fd5c3a54b8.1636578573.git.christophe.jaillet@wanadoo.fr>
 <20211111091711.GO2001@kadam>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <3ebffac9-3be4-d9d0-1cb0-f2517c0f78c5@wanadoo.fr>
Date:   Thu, 11 Nov 2021 11:18:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111091711.GO2001@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 11/11/2021 à 10:17, Dan Carpenter a écrit :
> On Wed, Nov 10, 2021 at 10:11:34PM +0100, Christophe JAILLET wrote:
>> In case of memory allocation failure, we should release many things and
>> should not return directly.
>>
>> The tricky part here, is that some (kzalloc + dma_pool_alloc) resources
>> are allocated and stored in 'unusable' and a 'good' list.
>> The 'good' list is then freed and only the 'unusable' list remains
>> allocated.
>> So, only this 'unusable' list is then freed in the error handling path of
>> the function.
>>
>> So, instead of adding even more code in this already huge function, just
>> 'continue' (as already done if dma_pool_alloc() fails) instead of
>> returning directly.
>>
>> After the 'for' loop, we will then branch to the correct place of the
>> error handling path when another memory allocation will (likely) fail
>> afterward.
>>
>> Fixes: 50b812755e97 ("scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> Certainly not the best solution, but look 'safe' to me.
> 
> Your analysis seems correct, but this is deeply weird.
I agree, deeply weird :)

>  It sort of looks
> like this was debug code that was committed accidentally.  Neither
> the "good" list nor the "unusable" are used except to print some debug
> info:
> 
>                         ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0024,
>                             "%s: dif dma pool (good=%u unusable=%u)\n",
>                             __func__, ha->pool.good.count,
>                             ha->pool.unusable.count);
> 
> The good list is freed immediately, and then there is a no-op free in
> qla2x00_mem_free().
I agree.

> The unusable list is preserved until qla2x00_mem_free()
> but not used anywhere.
I agree.

The logic in commit '50b812755e97' puzzled me a lot.
I wonder why the 128 magic number in the for loop.

My understanding is:
    - try to allocate things at start-up
    - check if this allocation crosses the 4G limit (see commit log)
    - keep the "unusable" allocation allocated, so that this memory is 
reserved (i.e. wasted) and won't be allocated later (see usage of the 
dif_bundl_pool dma pool in [1])
    - hope that tying 128 allocations is enough and that no "unusable 
allocation" will be done at run-time.

In other words, I tried to convinced myself that there was a real logic, 
even if unperfect.


Even if the above description is correct and if it works as expected in 
RL, it real looks like an overkill!


Now that I reread code around 'dif_local_dma_alloc' usage, I'm tempt to 
agree with your feeling about debug code.

CJ

[1]: 
https://elixir.bootlin.com/linux/v5.15.1/source/drivers/scsi/qla2xxx/qla_iocb.c#L1138

> 
> regards,
> dan carpenter
> 
> 


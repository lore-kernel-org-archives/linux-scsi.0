Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CACC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 17:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4CA613E4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 17:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbhETRva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 13:51:30 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:55744 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbhETRva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 13:51:30 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d10 with ME
        id 75q52500B21Fzsu035q6DT; Thu, 20 May 2021 19:50:07 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 20 May 2021 19:50:07 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH] scsi: sni_53c710: Fix a resource leak in an error
 handling path
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
 <20210520150641.GA22843@alpha.franken.de>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <37ec6fe9-170f-c282-465e-6ae7d69e623e@wanadoo.fr>
Date:   Thu, 20 May 2021 19:50:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210520150641.GA22843@alpha.franken.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 20/05/2021 à 17:06, Thomas Bogendoerfer a écrit :
> On Thu, May 20, 2021 at 06:44:25AM +0200, Christophe JAILLET wrote:
>> After a successful 'NCR_700_detect()' call, 'NCR_700_release()' must be
>> called to release some DMA related resources, as already done in the
>> remove function.
>>
>> Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/scsi/sni_53c710.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
>> index 678651b9b4dd..f6d60d542207 100644
>> --- a/drivers/scsi/sni_53c710.c
>> +++ b/drivers/scsi/sni_53c710.c
>> @@ -98,6 +98,7 @@ static int snirm710_probe(struct platform_device *dev)
>>   
>>    out_put_host:
>>   	scsi_host_put(host);
>> +	NCR_700_release(host);
> 
> shouldn't this done before the scsi_host_put() to avoid a use after free ?

I did it this way because remove function are:
    scsi_remove_host
    NCR_700_release

The other reason was to free resources in the reverse order than allocation.
But this logic does'nt work in all cases.

> lasi700.c has the same problem.

and a400t.c and bvme6000_scsi.c and mvme16x_scsi.c and sim710.c and 
zorro7xx.c.
That is to say all drivers that use NCR_700_detect().

That is why I'm unsure with my patch. It is unusual to have ALL users 
wrong. It is more likely that I missed something and that the code is 
correct.

I also don't fully understand why we use 'scsi_host_put' in some place 
and 'scsi_remove_host' in remove functions.
Referenced managed resources sometimes have the needed mechanism to 
automagically release some resource.

> And it looks like NCR_700_detect() will leak
> dma memory, if scsi_host_alloc() failed.

Agreed. And same if scsi_add_host fails at the end of the function.

> 
> Thomas.
> 


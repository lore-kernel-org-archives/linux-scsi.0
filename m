Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9EDC4741F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 18:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B052076D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 18:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgKDS0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:26:48 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:38606 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKDS0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 13:26:48 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 4C6572EA024;
        Wed,  4 Nov 2020 13:26:46 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id SS5bke63PJDu; Wed,  4 Nov 2020 13:18:12 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 88B352EA043;
        Wed,  4 Nov 2020 13:26:45 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free()
 warning
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201019191928.77845-1-dgilbert@interlog.com>
 <20201019191928.77845-2-dgilbert@interlog.com>
 <2e94f118-1216-b926-a275-2fb325874b04@gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <b64de9eb-408f-f618-0db9-731f8823525a@interlog.com>
Date:   Wed, 4 Nov 2020 13:26:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2e94f118-1216-b926-a275-2fb325874b04@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-03 7:54 a.m., Bodo Stroesser wrote:
> Am 19.10.20 um 21:19 schrieb Douglas Gilbert:
>> This patch removes a check done by sgl_alloc_order() before it starts
>> any allocations. The comment before the removed code says: "Check for
>> integer overflow" arguably gives a false sense of security. The right
>> hand side of the expression in the condition is resolved as u32 so
>> cannot exceed UINT32_MAX (4 GiB) which means 'length' cannot exceed
>> that amount. If that was the intention then the comment above it
>> could be dropped and the condition rewritten more clearly as:
>>        if (length > UINT32_MAX) <<failure path >>;
> 
> I think the intention of the check is to reject calls, where length is so high, that calculation of nent overflows unsigned int nent/nalloc.
> Consistently a similar check is done few lines later before incrementing nalloc due to chainable = true.
> So I think the code tries to allow length values up to 4G << (PAGE_SHIFT + order).
> 
> That said I think instead of removing the check it better should be fixed, e.g. by adding an unsigned long long cast before nent
> 
> BTW: I don't know why there are two checks. I think one check after conditionally incrementing nalloc would be enough.

Okay, I'm working on a "v4" patchset. Apart from the above, my plan is
to extend sgl_compare_sgl() with a helper that additionally yields
the byte index of the first miscompare.

Doug Gilbert

>> The author's intention is to use sgl_alloc_order() to replace
>> vmalloc(unsigned long) for a large allocation (debug ramdisk).
>> vmalloc has no limit at 4 GiB so its seems unreasonable that:
>>       sgl_alloc_order(unsigned long long length, ....)
>> does. sgl_s made with sgl_alloc_order(chainable=false) have equally
>> sized segments placed in a scatter gather array. That allows O(1)
>> navigation around a big sgl using some simple integer maths.
>>
>> Having previously sent a patch to fix a memory leak in
>> sg_alloc_order() take the opportunity to put a one line comment above
>> sgl_free()'s declaration that it is not suitable when order > 0 . The
>> mis-use of sgl_free() when order > 0 was the reason for the memory
>> leak. The other users of sgl_alloc_order() in the kernel where
>> checked and found to handle free-ing properly.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>    include/linux/scatterlist.h | 1 +
>>    lib/scatterlist.c           | 3 ---
>>    2 files changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>> index 45cf7b69d852..80178afc2a4a 100644
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -302,6 +302,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
>>    			      unsigned int *nent_p);
>>    void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
>>    void sgl_free_order(struct scatterlist *sgl, int order);
>> +/* Only use sgl_free() when order is 0 */
>>    void sgl_free(struct scatterlist *sgl);
>>    #endif /* CONFIG_SGL_ALLOC */
>>    
>> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>> index c448642e0f78..d5770e7f1030 100644
>> --- a/lib/scatterlist.c
>> +++ b/lib/scatterlist.c
>> @@ -493,9 +493,6 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
>>    	u32 elem_len;
>>    
>>    	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
>> -	/* Check for integer overflow */
>> -	if (length > (nent << (PAGE_SHIFT + order)))
>> -		return NULL;
>>    	nalloc = nent;
>>    	if (chainable) {
>>    		/* Check for integer overflow */
>>


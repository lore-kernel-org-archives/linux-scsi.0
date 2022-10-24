Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C83C67871
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 22:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiJXWzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiJXWyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 18:54:47 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883BD43320
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 14:16:31 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 09B4970ECA;
        Mon, 24 Oct 2022 19:58:24 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id E399061626;
        Mon, 24 Oct 2022 19:58:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id 7kBclUx6USSz; Mon, 24 Oct 2022 19:58:23 +0000 (UTC)
Received: from [192.168.48.17] (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id D40CC61542;
        Mon, 24 Oct 2022 19:58:22 +0000 (UTC)
Message-ID: <9b5f5e2b-bf37-f986-469f-107eb463924b@interlog.com>
Date:   Mon, 24 Oct 2022 15:58:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Content-Language: en-CA
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com> <Y1aDQznakNaWD8kd@ziepe.ca>
 <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com> <Y1bMKU5nq5DXYdbw@ziepe.ca>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <Y1bMKU5nq5DXYdbw@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-10-24 13:32, Jason Gunthorpe wrote:
> On Mon, Oct 24, 2022 at 04:32:30PM +0200, Bodo Stroesser wrote:
>>> +struct scatterlist *sgl_alloc_order(size_t length, unsigned int order,
>>> +				    bool chainable, gfp_t gfp, size_t *nent_p)
>>>    {
>>>    	struct scatterlist *sgl, *sg;
>>>    	struct page *page;
>>> -	unsigned int nent, nalloc;
>>> +	size_t nent, nalloc;
>>>    	u32 elem_len;
>>> -	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
>>> -	/* Check for integer overflow */
>>> -	if (length > (nent << (PAGE_SHIFT + order)))
>>> -		return NULL;
>>> +	nent = length >> (PAGE_SHIFT + order);
>>> +	if (length % (1 << (PAGE_SHIFT + order)))
>>
>> This might end up doing a modulo operation for divisor 0, if caller
>> specifies a too high order parameter, right?
> 
> If that happens then the first >> will be busted too and this is all
> broken..
> 
> We assume the caller will pass a valid order paramter it seems, it is
> not userspace controlled.

Hi,
I have been trying to remove the unstated 4 GB limit on this existing
function, _not_ change its interface. In practice, I don't believe limiting
'nent' to 2^32-1 (i.e. 'unsigned int') is an unreasonable restriction and
that is checked at runtime in my patch. Since each 'entity' is at least
PAGE_SIZE bytes, that is at least 16 TB (with order==0).

The order_too_large issue I have tried to address with a pre-condition
(i.e. words in the description of the 'order' argument). That said, I did
notice:

include/linux/mmzone.h :
   #ifndef CONFIG_ARCH_FORCE_MAX_ORDER
   #define MAX_ORDER 11
   #else
   #define MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
   #endif


Changing the interface of sgl_alloc_order() will break these callers:
    drivers/scsi/ipr.c
    drivers/target/target_core_transport.c

due to change the type (and size on 64 bit machines) of the fifth argument
(i.e. 'size_t *nent_p').

If you want to change sgl_alloc_order()'s interface, shouldn't that be done
in a separate patch that also fixes the breakages it would otherwise cause?

Doug Gilbert


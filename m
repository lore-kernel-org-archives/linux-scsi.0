Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37228C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 00:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiKPAUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKPAUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 19:20:18 -0500
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B076029354
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 16:20:16 -0800 (PST)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 3B78771356;
        Wed, 16 Nov 2022 00:20:15 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 256586051A;
        Wed, 16 Nov 2022 00:20:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id YF9I2MAN77us; Wed, 16 Nov 2022 00:20:14 +0000 (UTC)
Received: from [192.168.48.17] (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id DBCDC604FF;
        Wed, 16 Nov 2022 00:20:13 +0000 (UTC)
Message-ID: <844d8e7e-614f-105b-3b33-e471a1bb24d1@interlog.com>
Date:   Tue, 15 Nov 2022 19:20:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 1/5] sgl_alloc_order: remove 4 GiB limit
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        bostroesser@gmail.com
References: <20221112194939.4823-1-dgilbert@interlog.com>
 <20221112194939.4823-2-dgilbert@interlog.com> <Y3P3p1XqxisASnQt@ziepe.ca>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <Y3P3p1XqxisASnQt@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-11-15 15:33, Jason Gunthorpe wrote:
> On Sat, Nov 12, 2022 at 02:49:35PM -0500, Douglas Gilbert wrote:
>> This patch fixes a check done by sgl_alloc_order() before it starts
>> any allocations. The comment in the original said: "Check for integer
>> overflow" but the right hand side of the expression in the condition
>> is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
>> means 'length' can not exceed that value.
>>
>> This function may be used to replace vmalloc(unsigned long) for a
>> large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
>> it seems unreasonable that sgl_alloc_order() whose length type is
>> unsigned long long should be limited to 4 GB.
>>
>> Solutions to this issue were discussed by Jason Gunthorpe
>> <jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com>. This
>> version is base on a linux-scsi post by Jason titled: "Re:
>> [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit" dated 20220201.
>>
>> An earlier patch fixed a memory leak in sg_alloc_order() due to the
>> misuse of sgl_free(). Take the opportunity to put a one line comment
>> above sgl_free()'s declaration warning that it is not suitable when
>> order > 0 .
>>
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Bodo Stroesser <bostroesser@gmail.com>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   include/linux/scatterlist.h |  1 +
>>   lib/scatterlist.c           | 23 ++++++++++++++---------
>>   2 files changed, 15 insertions(+), 9 deletions(-)
> 
> I still prefer the version I posted here:
> 
> https://lore.kernel.org/linux-scsi/Y1aDQznakNaWD8kd@ziepe.ca/

Three reasons that I don't:
   1) making the first argument of type size_t may constrict the size
      that can be allocated on a 32 bit machine (faint recollection of
      extended/expanded memory on 8086). uint64_t would be better
      than unsigned long long but see point 3)
   2) making the last (fifth) argument of type size_t is overkill on a
      64 bit machine. IMO 32 bits is sufficient. The maximum unsigned int
      is 2^32 - 1 and with a typical PAGE_SIZE of 4096 bytes and order 0,
      that is roughly 2^44 bytes or about 16 TB. If part of the kernel
      did want 16 TB in a single allocation, I hope it would choose a
      larger value for order. So then the maximum single allocation
      would be 2^(44+MAX_ORDER-1) bytes. Can I stop now?
   3) it changes the signature of an existing exported kernel function
      requiring changes in several call sites. Changing an output pointer
      type may require more than a one line change at the existing call
      sites. Due to the fact that this patch is removing an existing
      4 GB limit, those call sites have zero need for this. If I was
      maintaining the driver containing those call sites, I would be
      a bit peeved. [That said, maintaining out-of-tree patchsets, while
      trying to get them accepted in the mainline, is a considerable
      pain due to the constant changes in the block layer API.]

Doug Gilbert

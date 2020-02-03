Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B69DC33CAC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 12:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A9ED2082E
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 12:20:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPRH1NIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBCMUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 07:20:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28062 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726268AbgBCMUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 07:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580732411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMiwcjdWwKYY2iBTL+7SSYuwnhzwvGB0EHKGhnMTfGA=;
        b=VPRH1NIqIqLM86dixSQ51NfawDdWTkb5Gk5P1ucQwCXEE4M4hx+JL6DwgHuhyex2SHdVWt
        aoGa2WalR2TAp/xzv+Rh7phezHH1nJ9pYU5IzDro4UaS+jN/NguqjDkjwYYqgdWeh16Hoz
        9yJqNRPXi/ly+bNEnoZczbo6bKZCbnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-Z2swCJ7yOXqQnw7SjtiaYg-1; Mon, 03 Feb 2020 07:20:07 -0500
X-MC-Unique: Z2swCJ7yOXqQnw7SjtiaYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D578D800D41;
        Mon,  3 Feb 2020 12:20:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.43.2.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 065B75DDAA;
        Mon,  3 Feb 2020 12:20:04 +0000 (UTC)
Subject: Re: [PATCH] megaraid_sas: silence a warning
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Lee Duncan <lduncan@suse.com>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
References: <20200131132350.31840-1-thenzl@redhat.com>
 <ff50f95a-1885-9fce-946c-f31861c06486@suse.com>
 <CAL2rwxqDTRmmk_RUEHQpf6MUu5CBaKKBu8W0D3o=y0Yygo6unw@mail.gmail.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <4fac061b-a026-4b5d-b420-787733b961b5@redhat.com>
Date:   Mon, 3 Feb 2020 13:20:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAL2rwxqDTRmmk_RUEHQpf6MUu5CBaKKBu8W0D3o=y0Yygo6unw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/20 10:16 AM, Sumit Saxena wrote:
> On Sat, Feb 1, 2020 at 10:57 PM Lee Duncan <lduncan@suse.com> wrote:
>>
>> On 1/31/20 5:23 AM, Tomas Henzl wrote:
>>> Add a flag to dma mem allocation to silence a warning.
>>>
>>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> index 0f5399b3e..1fa2d1449 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> @@ -606,7 +606,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
>>>
>>>       fusion->io_request_frames =
>>>                       dma_pool_alloc(fusion->io_request_frames_pool,
>>> -                             GFP_KERNEL, &fusion->io_request_frames_phys);
>>> +                             GFP_KERNEL | __GFP_NOWARN,
>>> +                             &fusion->io_request_frames_phys);
>>>       if (!fusion->io_request_frames) {
>>>               if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
>>>                       instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
>>> @@ -644,7 +645,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
>>>  open-isns-updates.diff.bz2
>>>               fusion->io_request_frames =
>>>                       dma_pool_alloc(fusion->io_request_frames_pool,
>>> -                                    GFP_KERNEL,
>>> +                                    GFP_KERNEL | __GFP_NOWARN,
>>>                                      &fusion->io_request_frames_phys);
>>>
>>>               if (!fusion->io_request_frames) {
>>>
>>
>> I'm fairly sure this is a good fix, but I'd appreciate more information
>> in the comment, such as what warning was silenced, and why it's okay to
>> silence it rather than "fix" it. I know from experience that, when
>> choosing which commits to backport, more information is better than less.
> This code allocates DMA memory for driver's IO frames which may exceed
> MAX_ORDER pages for few
> megaraid_sas controllers(controllers with High Queue Depth). So there
> is logic to keep on reducing controller
> Queue Depth until DMA memory required for IO frames fits within
> MAX_ORDER. So or impacted megaraid_sas controllers,
> there would be multiple DMA allocation failure until driver settles
> down to Controller Queue Depth which has memory requirement
> within MAX_ORDER. These failed DMA allocation requests causes stack
> traces in system logs which is not harmful and this patch
> would silence those warnings/stack traces.
> 
> With CMA (Contiguous Memory Allocator) enabled, it's possible  to
> allocate DMA memory exceeding MAX_ORDER.
> And that is the reason of keeping this retry logic with less
> controller Queue Depth instead of calculating controller Queue depth
> at first hand which has memory requirement less than MAX_ORDER.

Thank you Sumit for writing it down.
An over-sized allocation failure is sanitized in a proper way. The
warning may hide other allocation warnings in other parts of kernel as
it is printed only once.

I could have written more vecasue I've underestimated it and I'm sorry
for that.

Tomas


> Thanks,
> Sumit
>>
>> --
>> Lee Duncan
> 


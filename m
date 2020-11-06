Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B64C2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 07:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37A420704
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 07:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgKFHJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:09:23 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:40163 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKFHJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 02:09:23 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id B3FA92EAAD6;
        Fri,  6 Nov 2020 02:09:21 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id ZI6kBCgrALlm; Fri,  6 Nov 2020 02:00:42 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2361E2EAAC0;
        Fri,  6 Nov 2020 02:09:21 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi_debug: change store from vmalloc to sgl
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        bostroesser@gmail.com, ddiss@suse.de, hare@suse.de
References: <20201106003852.24113-1-dgilbert@interlog.com>
 <be8196e5-0eab-f40b-1985-c04c3c3a1682@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d6f39134-9f9a-9cd7-14ed-15a1943317c0@interlog.com>
Date:   Fri, 6 Nov 2020 02:09:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <be8196e5-0eab-f40b-1985-c04c3c3a1682@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-05 11:06 p.m., Bart Van Assche wrote:
> On 11/5/20 4:38 PM, Douglas Gilbert wrote:
>> A long time ago this driver's store was allocated by kmalloc() or
>> alloc_pages(). When this was switched to vmalloc() the author
>> noticed slower ramdisk access times and more variability in repeated
>> tests. So try going back with sgl_alloc_order() to get uniformly
>> sized allocations in a sometimes large scatter gather _array_. That
>> array is the basis of keeping O(1) access to the store.
>>
>> Using sgl_alloc_order() and friends requires CONFIG_SGL_ALLOC
>> so add a 'select' to the Kconfig file.
>>
>> Remove kcalloc() in resp_verify() as sgl_s can now be compared
>> directly without forming an intermediate buffer. This is a
>> performance win for the SCSI VERIFY command implementation.
>>
>> Make the SCSI COMPARE AND WRITE command yield the offset of the
>> first miscompared byte when the compare fails (as required by
>> T10).
>>
>> This patch depends on: "[PATCH v4 0/4] scatterlist: add new
>> capabilities".
> 
> Hi Doug,
> 
> Although I'm fine with this patch: has it been considered to use huge
> pages instead of allocating a scatterlist? Would that have the same or
> even better performance advantages?

The scsi_debug driver having its store as a scatterlist has the
distinct advantage that the data-in and data-out buffers coming through
from the block layer and the scsi mid-level are also in the form of
scatterlists. Hence most of the media access SCSI commands that the
driver simulates boil down to just a handful of sgl to sgl operations.
The very ones that I am trying to add to the scatterlist API.

If there is some advantage of using huge pages for a store, then I
would prefer that to be done in the scatterlist API. Say a new
allocator like sgl_alloc_huge() that forms a scatter gather array
of huge pages.

I did have a quick look at huge pages and the existing kernel
infrastructure seemed to be aimed at user space usage rather than
driver usage.

Doug Gilbert






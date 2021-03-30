Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE60C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA10E619CF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhC3RP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 13:15:57 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:39838 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhC3RPe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 13:15:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 3967425F46;
        Tue, 30 Mar 2021 17:15:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo06-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo06-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id C5lNTJyh4u5R; Tue, 30 Mar 2021 17:15:33 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 8239B25F43;
        Tue, 30 Mar 2021 17:15:23 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 3CD593EE35;
        Tue, 30 Mar 2021 11:15:22 -0600 (MDT)
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210326055822.1437471-1-hch@lst.de>
 <20210326055822.1437471-3-hch@lst.de>
 <90427abe-f0a3-c6fc-a674-7a3967e20882@gonehiking.org>
 <20210330170320.GC13829@lst.de>
From:   Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 2/8] Buslogic: remove ISA support
Message-ID: <45e94e2d-e359-732b-f704-a789774ed901@gonehiking.org>
Date:   Tue, 30 Mar 2021 11:15:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210330170320.GC13829@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/21 11:03 AM, Christoph Hellwig wrote:
> On Mon, Mar 29, 2021 at 02:29:21PM -0600, Khalid Aziz wrote:
>> On 3/25/21 11:58 PM, Christoph Hellwig wrote:
>>> The ISA support in Buslogic has been broken for a long time, as all
>>> the I/O path expects a struct device for DMA mapping that is derived from
>>> the PCI device, which would simply crash for ISA adapters.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>>  drivers/scsi/BusLogic.c | 156 ++--------------------------------------
>>>  drivers/scsi/BusLogic.h |   3 -
>>>  drivers/scsi/Kconfig    |   2 +-
>>>  3 files changed, 6 insertions(+), 155 deletions(-)
>>>
>>
>> Hi Chris,
>>
>> This looks good. There is more code that can be removed, for instance
>> all of the code that supports "IO:" driver option to specify ISA port
>> addresses. enum blogic_adapter_bus_type can shrink. "limited_isa" and
>> "probe*" members of struct blogic_probe_options can go away. You could
>> add those to this patch, or if you would like, I can create a follow-on
>> patch to remove that code.
> 
> I've added the above suggestions.  If there is anything more you
> can easily think of let me know.
> 

Awesome! Thanks. Updates to Documentation/scsi/BusLogic.rst to match
these changes would be great. Doc currently lists "IO:" and "NoProbeISA"
which can go away. "Supported Host Adapters: section lists ISA and EISA
adapters that can go away as well. There is reference to ISA in
"QueueDepth:<integer>" - "For Host Adapters that require ISA Bounce
Buffers, the Queue Depth is automatically set by default to
BusLogic_TaggedQueueDepthBB or BusLogic_UntaggedQueueDepthBB to avoid
excessive preallocation of DMA Bounce Buffer memory." which is
irrelevant now.

Thanks,
Khalid

Return-Path: <SRS0=zgrd=W5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275B9C3A59B
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Sep 2019 08:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00BEE21881
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Sep 2019 08:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfIBIrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Sep 2019 04:47:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729534AbfIBIrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Sep 2019 04:47:14 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 16338281DB2CFA4E2403;
        Mon,  2 Sep 2019 16:47:13 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Sep 2019
 16:47:11 +0800
Subject: Re: [PATCH RFC 00/24] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20190529132901.27645-1-hare@suse.de>
 <e5c2b01a-71d9-ef94-3bf6-0830d866e4cf@huawei.com>
 <3a92946e-e967-bc68-e995-2c28ae455566@suse.de>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, "Ming Lei" <ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <64d4b289-555d-8854-ca2b-ec26d397061e@huawei.com>
Date:   Mon, 2 Sep 2019 09:47:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <3a92946e-e967-bc68-e995-2c28ae455566@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/08/2019 16:27, Hannes Reinecke wrote:
> On 8/23/19 3:26 PM, John Garry wrote:
>> On 29/05/2019 14:28, Hannes Reinecke wrote:
>>> Hi all,
>>>
>>> quite some drivers use internal commands for various purposes, most
>>> commonly sending TMFs or querying the HBA status.
>>> While these commands use the same submission mechanism than normal
>>> I/O commands, they will not be counted as outstanding commands,
>>> requiring those drivers to implement their own mechanism to figure
>>> out outstanding commands.
>>> This patchset enables the use of reserved tags for the SCSI midlayer,
>>> enabling LLDDs to rely on the block layer for tracking outstanding
>>> commands.
>>> More importantly, it allows LLDD to request a valid tag from the block
>>> layer without having to implement some tracking mechanism within the
>>> driver. This removes quite some hacks which were required for some
>>> drivers (eg. fnic or snic).
>>>
>>> As usual, comments and reviews are welcome.
>>>
>>
>> Hi Hannes,
>>
>> I was wondering if you have any plans to progress this series?
>>
>> I don't mind helping out...
>>
> Thanks for the reminder.

Hi Hannes,

> I'll need to re-evaluate this where we stand now with shared tags;

As Ming Lei mentioned in 
https://www.spinics.net/lists/linux-block/msg43779.html, the future for 
hostwide shared tags doesn't look bright. I would tend to agree.

> this patchset partially relies on them.

In which way? I didn't think/hope it did.

> Will be sending an updated patchset.

For me, the way I see forward is to upstream this series, in addition to 
Ming's, linked above.

As for LLDDs and the unique tag problem, I suggest that they use sbitmap 
to generate the tag internally if they want to expose multiple queues. 
 From our testing, using managed interrupts + sbitmap still far 
outperforms non-managed interrupts.

This approach would mean that we can still revisit hostwide shared tags 
or other some other approach in future.

Thanks,
John

>
> Cheers,
>
> Hannes
>



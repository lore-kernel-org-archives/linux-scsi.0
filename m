Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608BDEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 11:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjF2LGL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 07:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjF2LGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 07:06:10 -0400
Received: from gw.rozsnyo.com (gw.rozsnyo.com [77.240.102.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF331719
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2023 04:06:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by gw.rozsnyo.com (Postfix) with ESMTP id AD13710372C9;
        Thu, 29 Jun 2023 13:06:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at rozsnyo.com
Received: from gw.rozsnyo.com ([127.0.0.1])
        by localhost (hosting.rozsnyo.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PpvC9clL_hRg; Thu, 29 Jun 2023 13:06:05 +0200 (CEST)
Received: from [192.168.68.7] (gw.rozsnyo.com [77.240.102.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by gw.rozsnyo.com (Postfix) with ESMTPSA id BC84D10372B9;
        Thu, 29 Jun 2023 13:06:04 +0200 (CEST)
Message-ID: <2a953b57-52b5-d75a-3b6e-9ef5a10b2093@rozsnyo.com>
Date:   Thu, 29 Jun 2023 13:06:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC] Support for Write-and-Verify only drives
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
 <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
 <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
 <f6e5e9d2-3446-ef52-a090-4eef1bd2daa3@kernel.org>
From:   =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>
In-Reply-To: <f6e5e9d2-3446-ef52-a090-4eef1bd2daa3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Lets get back to the original request/question then. What is the proper
>> approach to handle such command variation?
> When scanning the drive, you need to poke it using scsi_report_opcode() to
> determine which write operation is supported. Then sd.c need to be modified to
> generate the proper write command if the regular WRITE 10/16/32 are not
> supported. You will also need to make sure that this does not break ATA drives
> managed with libata, so check libata-scsi translation.
>
> Not saying this can all be accepted though. But that is what is needed.


Thanks Damien.

I went to check the opcode support and it says that Write is supported.

The actual Write execution then fails with "Aborted Command".

It is not making my life easier and the correct way is not going to work.

Then I had a very long and unhelpful discussion on Seagate support chat where
they failed to recognize this combination as a potential bug and a broken
firmware.

I just can not understand they wont accept a bug-report on a custom firmware,
having done all the discoveries for them. Looks like they did not put much of
effort into this and the firmware is a quick hack to get the job done for OEM.

Given the current state of things and thanks to Martin's opinion to not bring
this mess and edge case code into mainline as of now, I will consider getting
these drives to work as a private challenge. If somebody else runs into this,
they will find at least this thread, where the code may appear after I find it
stable enough.

Daniel


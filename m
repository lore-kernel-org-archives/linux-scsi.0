Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9749C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7663611F0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhDTCRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:17:02 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:49378 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhDTCRC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:17:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 0967E21018;
        Tue, 20 Apr 2021 02:16:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo06-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo06-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EpoJT5jIQmuC; Tue, 20 Apr 2021 02:16:30 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id A521E20D9B;
        Tue, 20 Apr 2021 02:16:22 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 2B1393EF41;
        Mon, 19 Apr 2021 20:16:21 -0600 (MDT)
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Ondrej Zary <linux@zary.sk>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
 <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org>
 <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk>
 <202104182221.21533.linux@zary.sk>
 <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
 <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk>
From:   Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
Message-ID: <d7dc08a6-92be-e524-1f11-cd9f7326a0fd@gonehiking.org>
Date:   Mon, 19 Apr 2021 20:16:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 10:01 AM, Maciej W. Rozycki wrote:
> On Mon, 19 Apr 2021, Khalid Aziz wrote:
> 
>> On 4/18/21 2:21 PM, Ondrej Zary wrote:
>>>
>>> Found the 3000763 document here:
>>> https://doc.lagout.org/science/0_Computer Science/0_Computer History/old-hardware/buslogic/3000763_PCI_EISA_Wide_SCSI_Tech_Ref_Dec94.pdf
>>>
>>> There's also 3002593 there:
>>> https://doc.lagout.org/science/0_Computer Science/0_Computer History/old-hardware/buslogic/
>>>
>>
>> Thanks!!!
> 
>  Ondrej: Thanks a lot indeed!  These documents seem to have the essential 
> interface details all covered, except for Fast-20 SCSI adapters, which I 
> guess are a minor modification from the software's point of view.
> 
>  Khalid: I have skimmed over these documents and I infer 24-bit addressing 
> can be verified with any MultiMaster adapter, including ones that do have 
> 32-bit addressing implemented, by using the legacy Initialize Mailbox HBA 
> command.  That could be used to stop Christoph's recent changes for older 
> adapter support removal and replace them with proper fixes for whatever 
> has become broken.  Is that something you'd be willing as the driver's 
> maintainer to look into, or shall I?
> 

Hi Maciej,

Do you mean use OpCode 01 (INITIALIZE MAILBOX) to set a 24-bit address
for mailbox in place of OpCode 81? Verifying the change would be a
challenge. Do you have an old adapter to test it with? If you do, go
ahead and make the changes. I will be happy to review. I have only a
BT-757 adapter.

Thanks,
Khalid

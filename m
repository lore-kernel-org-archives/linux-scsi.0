Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B397C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 18:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD3E7613F6
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 18:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhDVSHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 14:07:54 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:55984 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVSHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 14:07:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 351A3A3D0D;
        Thu, 22 Apr 2021 18:07:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X_r-WUZfsmQL; Thu, 22 Apr 2021 18:07:17 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id DDC6E9FF33;
        Thu, 22 Apr 2021 18:07:08 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 9ACAB3EE3E;
        Thu, 22 Apr 2021 12:07:07 -0600 (MDT)
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Ondrej Zary <linux@zary.sk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
 <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org>
 <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk>
 <202104182221.21533.linux@zary.sk>
 <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
 <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk>
 <d7dc08a6-92be-e524-1f11-cd9f7326a0fd@gonehiking.org>
 <alpine.DEB.2.21.2104200456100.44318@angie.orcam.me.uk>
 <b23c0a0e-d95b-b941-1cc2-1a8bcf44401a@gonehiking.org>
 <alpine.DEB.2.21.2104221808170.44318@angie.orcam.me.uk>
From:   Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
Message-ID: <0a4d979b-e3f8-959d-fb9a-3a0fcea42141@gonehiking.org>
Date:   Thu, 22 Apr 2021 12:07:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2104221808170.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 10:27 AM, Maciej W. Rozycki wrote:
> On Wed, 21 Apr 2021, Khalid Aziz wrote:
> 
>>>  Verifying actual ISA operations (third-party DMA, etc.) cannot be made 
>>> this way, but as I understand the issue there is merely with passing data 
>>> structures around and that may not require too much attention beyond 
>>> getting things syntactically correct, which I gather someone forgot to do 
>>> with a change made a while ago.  So that should be doable as well.
>>
>> In theory this sounds reasonable, but without being able to test with a
>> real hardware I would be concerned about making this change.
> 
>  Sometimes you have little choice really and that would be less disruptive 
> than dropping support altogether.  Even if there's a small issue somewhere 
> it's easier to fix by a competent developer who actually gets the hands on 
> a piece of hardware than bringing back old code that has been removed and 
> consequently not updated according to internal API evolution, etc.

We are talking about removing support for BT-445S with firmware version
older than 3.37. That is a very specific case. To continue support for
this very specific case, we have to add new code to use local bounce
buffer and we have no hardware to verify this new code. This will be new
code whether we add it now or later after we find someone even has this
very old card with old firmware. I would prefer to remove support for
now and add new code to add support for firmware version older than 3.37
back only if there is a need later. For now anyone who is using a
BT-445S and has updated firmware on their card will not see a change.

--
Khalid

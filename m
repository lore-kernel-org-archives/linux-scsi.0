Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB4EC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A1C661450
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhDVChW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:37:22 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:53574 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhDVChV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 22:37:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 11DED9FEE6;
        Thu, 22 Apr 2021 02:36:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jwBa7HQajX4Z; Thu, 22 Apr 2021 02:36:46 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 976309FE94;
        Thu, 22 Apr 2021 02:36:38 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 679133EE45;
        Wed, 21 Apr 2021 20:36:37 -0600 (MDT)
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
From:   Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
Message-ID: <b23c0a0e-d95b-b941-1cc2-1a8bcf44401a@gonehiking.org>
Date:   Wed, 21 Apr 2021 20:36:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2104200456100.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 12:02 PM, Maciej W. Rozycki wrote:
> On Mon, 19 Apr 2021, Khalid Aziz wrote:
> 
>>>  Khalid: I have skimmed over these documents and I infer 24-bit addressing 
>>> can be verified with any MultiMaster adapter, including ones that do have 
>>> 32-bit addressing implemented, by using the legacy Initialize Mailbox HBA 
>>> command.  That could be used to stop Christoph's recent changes for older 
>>> adapter support removal and replace them with proper fixes for whatever 
>>> has become broken.  Is that something you'd be willing as the driver's 
>>> maintainer to look into, or shall I?
>>
>> Do you mean use OpCode 01 (INITIALIZE MAILBOX) to set a 24-bit address
>> for mailbox in place of OpCode 81? Verifying the change would be a
>> challenge. Do you have an old adapter to test it with? If you do, go
>> ahead and make the changes. I will be happy to review. I have only a
>> BT-757 adapter.
> 
>  Yes, but upon inspection it looks like our driver doesn't use that opcode 
> and relies solely on 32-bit Mode Initialize Mailbox (0x81) even with ISA 
> devices.  That makes sense as documentation indicates the firmware has 
> been designed to be unified so that the same binary microcontroller code 
> runs across all BusLogic MultiMaster devices.
> 
>  Anyway given the unified API it should be straightforward to simulate an 
> older adapter with a newer one, except for host bus protocol differences.  
> So verifying the workaround for broken BT-445S adapters continues to work 
> once modernised is not going to be a problem as it can be unconditionally 
> activated in a debug environment.  That would verify correct DMA bounce 
> buffer operation under the new scheme.
> 
>  Verifying actual ISA operations (third-party DMA, etc.) cannot be made 
> this way, but as I understand the issue there is merely with passing data 
> structures around and that may not require too much attention beyond 
> getting things syntactically correct, which I gather someone forgot to do 
> with a change made a while ago.  So that should be doable as well.

In theory this sounds reasonable, but without being able to test with a
real hardware I would be concerned about making this change.

> 
>  NB as noted before I only have a BT-958 readily wired for operation.  I 
> don't expect I have any other BusLogic hardware, but I may yet have to 
> double-check a stash of hardware I have accumulated over the years.  But 
> that is overseas, so I won't be able to get at it before we're at least 
> somewhat closer to normality.  If all else fails I could possibly buy one.
> 
>  I have respun the series now as promised.  Does your BT-757 adapter avoid 
> the issue with trailing allocation somehow?
> 

Well, my only test machine with a legacy PCI slot died some time back. I
have been working on putting together a replacement and have now been
able to get a working machine with a BT-950 adapter. I have not seen
issue with trailing allocation upto 5.12-rc8. I am going to try the top
of tree as well to make sure I do not run into this issue.

--
Khalid


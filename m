Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BB8C678D4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 09:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCCJjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 04:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCJjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 04:39:40 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA8315CB4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 01:39:38 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pY1t0-0006Uw-VZ; Fri, 03 Mar 2023 10:39:35 +0100
Message-ID: <754b030c-ba14-167c-e2d0-2f4f5bf55e99@leemhuis.info>
Date:   Fri, 3 Mar 2023 10:39:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, regressions@lists.linux.dev
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
 <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
 <Y15lk+CPsjJ801iY@infradead.org>
 <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
 <yq1tu192iur.fsf@ca-mkp.ca.oracle.com> <Y8+m0w4Og2CLFImY@lorien.valinor.li>
 <Y/ZGe8c1XyqSuCSk@eldamar.lan>
 <9aa5e89f-6579-15e5-cc51-d226b5d4bea3@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <9aa5e89f-6579-15e5-cc51-d226b5d4bea3@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677836378;4540a0d1;
X-HE-SMSGID: 1pY1t0-0006Uw-VZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27.02.23 15:07, Thorsten Leemhuis wrote:
> On 22.02.23 17:44, Salvatore Bonaccorso wrote:
>> On Tue, Jan 24, 2023 at 10:37:23AM +0100, Salvatore Bonaccorso wrote:
>>> On Mon, Jan 02, 2023 at 08:06:41AM -0500, Martin K. Petersen wrote:
>>>>> is anything blocking mainline inclusion of this patch?
>>>> I app

[removing a footer from the quoting here, that accidentally was added
here in my previous mail; sorry!]

>>>> lied these to 6.2/scsi-fixes last week. The patches have been
>>>> sitting in a topic branch for a bit due to the three-way conflict
>>>> between fixes, queue, and upstream.
>>>
>>> It landed in 6.2-rc4 recently in fact. Thank you!
>>>
>>> Would it be posssible to backport the fix as well back to the stable
>>> series affected? 
>>>
>>> In Debian we have the reports as per https://bugs.debian.org/1022126
>>> where the issue was introduced back in 5.10.y. Context in
>>> https://lore.kernel.org/linux-scsi/CAK=zhgr=MYn=-mrz3gKUFoXG_+EQ796bHEWSdK88o1Aqamby7g@mail.gmail.com/
>>
>> Friendly ping on this, can this change be backported as well to the
>> relevant stable series? It would apply already cleanly to 6.1.y, but
>> due to 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
>> reallocating pools") it might need some additional review for the
>> older stable series (in particular of interest due to the above for
>> 5.10.y).
> 
> This afaics is a reasonable request for 6.1, as this seems to be
> (Salvatore, please correct me if I'm wrong) a regression caused by
> 0e0747de0ea3 ("scsi: mpt3sas: Fix return value check of
> dma_get_required_mask()"), which was merged for 6.0-rc7. Hence allow me
> to ask:
> 
> Sreekanth and Martin, is there a reason why this request (and the
> earlier one a month ago) was apparently met with silence? Or was
> progress made in between and I just missed it?

Salvatore, seems my inquiry didn't help. I'd suggest you ask the stable
maintainers yourself to pick this up for 6.1.y. See "Option 2" in


https://docs.kernel.org/process/stable-kernel-rules.html

> Salvatore, for 5.10 things are a bit more complicated, as someone would
> need to do the work. Sometimes that work is done by the driver
> developers and maintainers as well, but strictly speaking it's the duty
> of those that backported the change to 5.10.y. Didn't check who did that
> this case (the stable team?); but well, maybe let's sort this out for
> 6.1.y first.

Option 3 mentioned on above page might work for you here.

>> Thanks already! If the change for older series needs some additional
>> testing we might ask the affected users from the Debian bug 1022126 to
>> test on 5.10.y as well.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

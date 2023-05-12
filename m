Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8B7C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 May 2023 02:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbjELC6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 22:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjELC6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 22:58:21 -0400
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB91F10CE
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 19:58:18 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 2C1F9E19FB;
        Fri, 12 May 2023 02:58:18 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 17618609F5;
        Fri, 12 May 2023 02:58:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id 7H3GxO9oAgWa; Fri, 12 May 2023 02:58:17 +0000 (UTC)
Received: from [192.168.48.17] (host-192.252-165-26.dyn.295.ca [192.252.165.26])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 4671D60506;
        Fri, 12 May 2023 02:58:16 +0000 (UTC)
Message-ID: <368d06ff-889c-ed05-8ecc-e25e99817465@interlog.com>
Date:   Thu, 11 May 2023 22:58:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
Content-Language: en-CA
To:     Benjamin Block <lkml@mageta.org>,
        Brian Bunker <brian@purestorage.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
References: <20230505204950.21645-1-brian@purestorage.com>
 <20230508100930.GA9720@t480-pf1aa2c2.fritz.box>
 <7C02DE30-DBA7-45E5-A16C-02C75C670E9F@purestorage.com>
 <ZF0bgrAXJnWPJR/U@chlorum.ategam.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <ZF0bgrAXJnWPJR/U@chlorum.ategam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-05-11 12:44, Benjamin Block wrote:
> On Mon, May 08, 2023 at 09:34:15AM -0700, Brian Bunker wrote:
>>> On May 8, 2023, at 3:09 AM, Benjamin Block <bblock@linux.ibm.com> wrote:
>>> On Fri, May 05, 2023 at 01:49:50PM -0700, Brian Bunker wrote:
>>>
>>>> + int ret = -EINVAL;
>>>
>>> Been wondering, whether it would make sense to have two different error
>>> levels here. One for the case where the page is not found in the loop
>>> that searches within page 0, and one for when page 0 is not present when
>>> we try to dereference the RCU protected pointer.
>>>
>>> That way we could have a safe fallback. If the page is there, we use its
>>> data, if it is not, we blindly send the INQUIRY like we do today.
>>>
>>> Not sure whether this is a bit too paranoid.. VPD page 0 is mandatory
>>> after all.
>>
>> That could be done, but the problem would still exist for the PURE target.
>> We don’t support the page 0xb9, and we don’t advertise we do in the response
>> to VPD 0. This approach would still lead to the INQUIRY being sent to devices
> 
> I wasn't meaning to send the INQUIRY regardless to what the page says,
> if it is present. I was just thinking to having fall-back for when the
> page 0 is not there at all (initially, when you call
> `rcu_dereference()`). That would support your storage, as you have page
> 0, and it would be present for the check I assume.
> 
> But anyway, it seems this is a no-go regardless. I didn't expect targets
> sending a valid page 0, but still supporting pages that are not listed in it.

SCSI standards did contain words that implied vendors would report all
VPD/log/mode pages and operation codes using the mechanisms added to
those standards over the years. I guess users pressured vendors to do
this. Then recently, in T10 approved proposal 21-063r2, the weasel
words "may or may not" were added to all those mechanisms. IMO that
was a pretty disgraceful move by the storage vendors that control T10.

Doug Gilbert


P.S. I have a new option appearing in some of my utilities: --examine
The idea is that it uses an iota function to check for unreported
VPD/log/mode pages as the "report supported" device server responses
"may or may not" be trustworthy :-)

>> who don’t support it, don’t expect it, and report an unexpected error. What I am
>> trying to avoid is the INQUIRY being sent to devices who don’t invite it.
> 


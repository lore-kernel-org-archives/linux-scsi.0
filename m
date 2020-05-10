Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1723C38A2A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A794020801
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgEJVu6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:50:58 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55382 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgEJVu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 17:50:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1C89120423B;
        Sun, 10 May 2020 23:50:56 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M2Bp6mboodUj; Sun, 10 May 2020 23:50:49 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 63333204165;
        Sun, 10 May 2020 23:50:49 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: scsi_alloc_target: parent of the target (need not be a scsi host)
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        SCSI development list <linux-scsi@vger.kernel.org>
References: <59d462c4-ceab-041a-bbb5-5b509f13a123@interlog.com>
 <1589136759.9701.25.camel@HansenPartnership.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <5425d3ef-1cf8-fee0-58a5-fbf702d30562@interlog.com>
Date:   Sun, 10 May 2020 17:50:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589136759.9701.25.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-10 2:52 p.m., James Bottomley wrote:
> On Sun, 2020-05-10 at 14:32 -0400, Douglas Gilbert wrote:
>> This gem is in scsi_scan.c in the documentation of that function's
>> first argument. "need not be a scsi host" should read "it damn well
>> better be a scsi host" otherwise that function will crash and burn!
> 
> It shouldn't: several transport classes, like SAS and FC have
> intermediate devices between the host and the target and they all work
> just fine using the non-host parent.  Since you don't give the error
> this is just guesswork, but the host has to be somewhere in the parent
> chain otherwise dev_to_shost(parent) will return NULL ... is that your
> problem?

May be that "need not be a scsi host" should be expanded to something
that suggests dev_to_shost(first_arg) can resolve to a non-NULL pointer.

Are there restrictions on those intermediate object(s)? Can there be more
than one? If so, can those intermediate objects only form a linear chain
or could it be more complex, an object subtree for example?

>> I'm trying to work out why the function: starget_for_each_device() in
>> scsi.c does _not_ use that collection right in front of it (i.e.
>> scsi_target::devices). Instead, it step up to the host level, and
>> iterates over all devices (LUs) on that host and only calls the given
>> function for those devices that match the channel and target numbers.
>> That is bizarrely wasteful if scsi_target::devices could be iterated
>> over instead.
>>
>> Anyone know why this is?
> 
> Best guess would be it wasn't converted over when the target list was
> introduced.

Okay, I'll change it and see what breaks.


If you are not familiar with "mark"s in xarrays, they are binary flags
hidden inside the pointers that xarray holds to form a container. With
these flags (two available per xarray) one can make iterations much more
efficient with xa_for_each_marked() { }. The win is that there is no
need to dereference the pointers of collection members that are _not_
marked. After playing with these in my rework of the sg driver, I
concluded that the best thing to mark was object states. Unfortunately
there are only 2 marks *** per xarray but scsi_device, for example, has
9 states in scsi_device_state. Would you like to hazard a guess of
which two (or two groups), if any, are iterated over often enough to
make marking worthwhile?

Those two marks could be stretched to four, sort of, as scsi_device
objects are members of two xarrays in my xarray rework: all sdev objects
in a starget, and all sdev objects in a shost.

Doug Gilbert


*** two flags is only _two_ sub-list possibilities per xarray. So, for
     example, you can't iterate like this (directly):
         xa_for_each_marked(mark1_set && mark2_clear) { }.





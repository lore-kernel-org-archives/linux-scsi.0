Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD70CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbjIOWui (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbjIOWuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:50:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A74335A6
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:46:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50314C433C8;
        Fri, 15 Sep 2023 22:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694817965;
        bh=IzjPPKoebKVnCje0Q1YLIdmbdDI/kBVFrSTloxETtbQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Mpx2Aj9KC2MY8qKkgf1htUPYC/fSd3ILKnnZG/4V0KYut6avLeD27p0QWzTw35gXD
         wuf0571b1xg8fsy1ECU5PaR9BLd+l8+3ETWTagE8cHEUFa3H5rpUWn+lTAz4FmFl+k
         N12eyIwnCEX/pn8jDIC9W/q0M/WPzFRS64YLgo6TZehUag67ny4lHWiCGLGd4KGhk+
         Q/JC9CFhLgb6YZM2j8tuHQxaF7CWy6F4opD4YOdwlPZ0n9U5/PBIKffQqdo8t7rM+T
         N8fF790xRKyN9YIshewtVUKVUsPUtN8pIsfMbhpSvTaanoJOvZgtTyLqCyiCmIgXMK
         fvxyD4zHcZz3Q==
Message-ID: <0080de55-6ca1-3b6d-027c-bd3a36e9577a@kernel.org>
Date:   Sat, 16 Sep 2023 07:46:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Bug 217914] New: scsi_eh_1 process high cpu after upgrading to
 6.5
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
 <41689a20-af9d-420f-af4f-72e299a765b7@acm.org> <ZQTUQGG0Q5k+CMSV@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZQTUQGG0Q5k+CMSV@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/23 07:01, Niklas Cassel wrote:
> On Fri, Sep 15, 2023 at 01:42:18PM -0700, Bart Van Assche wrote:
>> On 9/15/23 12:33, bugzilla-daemon@kernel.org wrote:
>>> The users loqs and leonshaw helped to narrow it down to this commit:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=624885209f31eb9985bf51abe204ecbffe2fdeea
>>
>> Damien, can you please take a look?
>>
> 
> Hello Bart,
> 
> It seems like:
> https://lore.kernel.org/linux-scsi/20230915022034.678121-1-dlemoal@kernel.org/
> 
> Solves the problem.
> 
> From a quick look at the logs with extra log leves enabled:
> https://pastebin.com/f2LQ8kQD
> it appears that the MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
> command with a non-zero service action issued by scsi_cdl_check() fails,
> and will be added to SCSI EH over and over.

Looks like the vmware emulated scsi cdrom (sr) does not like this command...
While SPC would allow cdroms to support CDL, I do not think we will ever see
that. So we could restrict CDL probe to block devices only. That still does not
explain why the constant retry. The MAINTENANCE_IN /
MI_REPORT_SUPPORTED_OPERATION_CODES failing is expected in most cases so it
should silently move on with cdl probe returning false. My patch is still needed
as some drives seem to hang on that command.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research


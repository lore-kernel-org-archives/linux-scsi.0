Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70726C46CA1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbjIOWKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbjIOWKO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:10:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4501FB7
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:10:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CD0C433C8;
        Fri, 15 Sep 2023 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694815808;
        bh=MZu6Vd1Fx4jZH6IDY2ztpoz2ZWXP1rAglY1XMkZ52R4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JW55ggklvoHKxqyhF1v7adxkbCb8a0WzD3a2PSz/qvpAgFwG8Ru2AHmGmKLrv60vZ
         Pr9i7lyCf8a/+JbldRAroPo+wg0HanSmslALTxwYjDpUJGDwQE+uBLgptu5KHWzYz6
         dlS/m4bNaVr2Vpip1TMh9iq8TnT7BNHZHFbl9GfSPOP+6r9brKjbxkeH67b8XgaCQO
         Tr2kO1DGbV+I2Z5cRv3SxewaWXQ9hISW8JTqhvc2X918PGeKm8wHdzSOOO0A3Hh14m
         XPFYgTv/VWpGQVmEiE/JsEJvFcJq/PO5GYFICQRXzcXPVZWFlCfJm4tSHZyCanh/Z0
         /mWQlNIhLbUVg==
Message-ID: <68be8de6-bc7d-2580-edc7-9a36051473af@kernel.org>
Date:   Sat, 16 Sep 2023 07:10:06 +0900
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

The failure is due to the drive not liking this command. My patch avoids sending
that command, thus solves the issue with drives that choke on it. However, the
constant retry sound to me like a different bug... We should not retry that
command at all I think. Or maybe limit it to 3 retries.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research


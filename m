Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81747C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 12:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbjEKMeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 08:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbjEKMeP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 08:34:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C7849E9;
        Thu, 11 May 2023 05:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E9361A38;
        Thu, 11 May 2023 12:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C553C4339B;
        Thu, 11 May 2023 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683808450;
        bh=6KhR1hPx2f/Fcyq67MSKwaOSDtVRKC2BG9kN+AOxVlc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tgNNG7riRwoxFQFHXrvrdTSMCKNypQU6igsB4tU9fz5Yyvfa6B1JnlQf3k3U/FK6E
         0gE6W2AcYIsMtJG1usRZF865B0uvlm+h2RMjTdLZdC/PTgb88sztYVEsYqqmTYSL17
         kN7WMQ1USNafLe2EW4YUB2G+1fEy2jO7BAthEd7jbcPscXKdbCY8PMqI9zAclcE9bS
         M8S4ls4ryD5HPzrOrjz7/HTqaD1BTL2oRaipUBvbYxVd2Ef5gILRn7rt1mDjYu6h3v
         6nKeNy+4XaKhL7CsaX6bpithAZgGWTDkA+smaqEh43vYwiOqEN01xpxKcvEztP77PT
         8XPwoN6cANETQ==
Message-ID: <54c1ccf6-2b27-2bc0-f142-995cd8aecf21@kernel.org>
Date:   Thu, 11 May 2023 21:34:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
To:     dgilbert@interlog.com, Niklas Cassel <nks@flawful.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <b8bd194d-7140-b924-059f-e67636d029a5@interlog.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b8bd194d-7140-b924-059f-e67636d029a5@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/05/11 13:22, Douglas Gilbert wrote:
> On 2023-05-10 21:13, Niklas Cassel wrote:
>> From: Niklas Cassel <niklas.cassel@wdc.com>
>>
>> Hello,
>>
>> This series adds support for Command Duration Limits.
>> The series is based on linux tag: v6.4-rc1
>> The series can also be found in git:
>> https://github.com/floatious/linux/commits/cdl-v7
>>
>>
>> =================
>> CDL in ATA / SCSI
>> =================
>> Command Duration Limits is defined in:
>> T13 ATA Command Set - 5 (ACS-5) and
>> T10 SCSI Primary Commands - 6 (SPC-6) respectively
>> (a simpler version of CDL is defined in T10 SPC-5).
>>
>> CDL defines Duration Limits Descriptors (DLD).
>> 7 DLDs for read commands and 7 DLDs for write commands.
>> Simply put, a DLD contains a limit and a policy.
>>
>> A command can specify that a certain limit should be applied by setting
>> the DLD index field (3 bits, so 0-7) in the command itself.
>>
>> The DLD index points to one of the 7 DLDs.
>> DLD index 0 means no descriptor, so no limit.
>> DLD index 1-7 means DLD 1-7.
>>
>> A DLD can have a few different policies, but the two major ones are:
>> -Policy 0xF (abort), command will be completed with command aborted error
>> (ATA) or status CHECK CONDITION (SCSI), with sense data indicating that
>> the command timed out.
>> -Policy 0xD (complete-unavailable), command will be completed without
>> error (ATA) or status GOOD (SCSI), with sense data indicating that the
>> command timed out. Note that the command will not have transferred any
>> data to/from the device when the command timed out, even though the
>> command returned success.
>>
>> Regardless of the CDL policy, in case of a CDL timeout, the I/O will
>> result in a -ETIME error to user-space.
>>
>> The DLDs are defined in the CDL log page(s) and are readable and writable.
> 
> The above sentence may be correct for ATA disks, but for SCSI disks the CDL log
> page is for statistics. Those statistics counters can be reset (to zero) but
> are not writable in the normal sense. To "define" (or change from the default
> values) CDL settings in SCSI, the CDL _mode_ pages are provided. Confusingly

Yes, indeed, for SCSI, CDL descriptors are defined in mode pages.

> there are four such mode pages (A, B, T2A and T2B). Which one(s) do you
> support/use?

All of them (see patch 8). For the ATA devices, the mode sense translation can
only report support for T2A/T2B (see patch 17).

Note that the kernel does not handle directly the CDL descriptor mode pages.
These need to be set by the user using passthrough tools such as sg3utils or
cdl-tools.

-- 
Damien Le Moal
Western Digital Research


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D21EC54E76
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 09:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjKTJAQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 04:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjKTJAO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 04:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102D6A4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 01:00:11 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC57DC433C8;
        Mon, 20 Nov 2023 09:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700470810;
        bh=Mx5Y79L5QcR1k5/A/ihZN1xv6Z1ScPaP1y96PUl/7Do=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XDqpwHp0UG9CGLc5FiJAdKSBptKXlMg8aOATpJPtgKeiU/NL5e/Mm8GySZj8AJwVG
         Mcjxn78ZlmQzmEH3gxlp/VcRxOKKYGy1lZw1rtfe8ss0oMK6qVmRFaip+QAqq3Gop4
         k5qu+a/HjUcSxKGcD8j51LaiEck+59UOVxPSlUF6WfPaByhsXKMmtfDmnzq6iVvZ8z
         khpWedDxtMW+IgDsP57SqyoxgziNrADFOJCdRKCyS9lNhjoYBtQ/W01vtcx8m5+EPg
         sKGCE2nz4eMMq6t2EoMHISFZWj1CvOA7c2hg4iMzSlp4zwoLEXOM+GprUT+6fykb/c
         VhmR3jSq580DA==
Message-ID: <27500ebc-1ba5-4171-b93a-227f1391d63e@kernel.org>
Date:   Mon, 20 Nov 2023 18:00:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: sd: fix system start for ATA devices
Content-Language: en-US
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Phillip Susi <phill@thesusis.net>
References: <20231120073522.34180-1-dlemoal@kernel.org>
 <20231120073522.34180-3-dlemoal@kernel.org>
 <a3008d49-32db-51cc-f9aa-ca9ec91ec14d@omp.ru>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a3008d49-32db-51cc-f9aa-ca9ec91ec14d@omp.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/23 17:50, Sergey Shtylyov wrote:
> On 11/20/23 10:35 AM, Damien Le Moal wrote:
> 
>> Ti is not always possible to keep a device in the runtime suspended
> 
>    s/Ti/It? :-)

Arg. Yes.

> 
>> state when a system level suspend/resume cycle is executed. E.g. for ATA
>> devices connected to AHCI  adapters, system resume resets the ATA ports,
>> which causes connected devices to spin up. In such case, a runtime
>> suspended disk will incorrectly be seen with a suspended runtime state
>> because the device is not resumed by sd_resume_system(). The power state
>> seen by the user is different than the actual device physical power
>> state.
>>
>> Fix this issue by introducing the struct scsi_device flag
>> force_runtime_start_on_system_start. When set, this flag causes
>> sd_resume_system() to request a runtime resume operation for runtime
>> suspended devices. This results in the user seeing the device
>> runtime_state as active after a system resume, thus correctly reflecting
>> the device physical power state.
>>
>> Fixes: 9131bff6a9f1 ("scsi: core: pm: Only runtime resume if necessary")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> [...]
> 
> MBR, Sergey

-- 
Damien Le Moal
Western Digital Research


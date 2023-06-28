Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6780AEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 23:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbjF1X4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbjF1X4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 19:56:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EE810D7
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 16:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 287E06146C
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 23:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F118C433C8;
        Wed, 28 Jun 2023 23:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687996603;
        bh=9kjpY0jknGDXlU+YaQ2INd9z2/6rXggCy7RLeoOyuOg=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=KvU8R+QNm5UTF6ZHQqQiZBDaTQnLqJlUGzQpXmBvyJs0MFCQ6kTFfraA2buVl4cvW
         04xjqveUO4kEn1EfjEZJkbHKX5QFRdmUFnvw+zDOa4dbaPMKnQReYyKT2llFJj++HY
         tBfo0NzL/XF+GDuPGdlmiUGuNr2kthW3ibzjiz1tcio7OS6ssyqYEQWHtfxli3aOGd
         m8PVF3flMFZhAc7awvJTDkhQ3B8rf1sDGcNcO3yOOyvI8dIfzQYMa1hHt9d6ZjJTdA
         pU/Bl+DNWTREJcQHaaJapmtTUz4kxoHlBTuz7+Vth32gFQQ0RZI/cZ/TC5PPQ0xjvZ
         cz11S5Hq3Q5pQ==
Message-ID: <7f811b26-564e-6e19-7385-b61978dd4757@kernel.org>
Date:   Thu, 29 Jun 2023 08:56:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC] Support for Write-and-Verify only drives
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
 <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/23 07:54, Bart Van Assche wrote:
> On 6/26/23 13:35, Daniel Rozsnyó wrote:
>>     There are some drives, or more precisely - normal drives with a 
>> custom firmware, that simply reject a regular Write - likely as not 
>> being good enough for the intended high-rel application - which I can 
>> understand, but even after reformatting the drive to no-PI and going to 
>> "poor" 512B sector size, they still refuse to do an easy Write 
>> operation. I had verified that by using the sg_write_verify (that uses 
>> an ioctl) I can really write data to these drives. The reading path is 
>> working okay and both dd and hdparm works at expected speeds.
> 
> To me the above sounds like the drive firmware is broken. Please fix the 
> drive firmware and make sure that WRITE commands are accepted.

All write commands are optional in SBC. So having a drive supporting write
verify and not supporting regular write 10/16/32 is actually acceptable per
specs. I agree that this is odd, but it is not a spec violation. So the question
is: do we want to detect and support that ?

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research


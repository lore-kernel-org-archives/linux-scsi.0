Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A4FE92FCF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 01:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjJFBMj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 21:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjJFBMi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 21:12:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6BBE7
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 18:12:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC64FC433C8;
        Fri,  6 Oct 2023 01:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696554756;
        bh=NPzJ3ETPNnfF/546JJBnrqTQrYfy1Govi5S5Ek1vnvE=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=A5nSB9oe/tAGPgnz4BP+gZI/BAjSJLIIb+t98FOVutEcictDv9GdbZAMgaJCM9Dt8
         MHFDgDjlruVfYNog7dg0fVDO/atwt6xX027XU31htNA3ciiUiRb+FPr3SKmZjjakNB
         TeMW5QgbPqwVvVdLMzH/6Pi221MtOKbofwKVpKxIM/faFPU+wlWwsBt41hWHks23+t
         xt8aXQxeM4hkSA4QBCnqgNHJ3Msnpd2DwqVvosVHmtUP1/zP3ST8v8bvvaSfr06ijR
         xXXPh76HBJNLHnlyZoFaMX/S707/tsupWEN/PCTgVizOoH3DktmXCi1H/afltaPKBf
         W2XEQ6KL73sOg==
Message-ID: <83ac5491-f73d-c446-e3e2-68641ce6347c@kernel.org>
Date:   Fri, 6 Oct 2023 10:12:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20231004210013.5601-1-michael.christie@oracle.com>
 <20231004210013.5601-9-michael.christie@oracle.com>
 <3e87f523-5e5e-dd67-26f3-8187b44b23b0@kernel.org>
 <c630ca48-7747-40a2-8c12-d1b212f07c07@oracle.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c630ca48-7747-40a2-8c12-d1b212f07c07@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/23 09:36, Mike Christie wrote:
> On 10/4/23 5:37 PM, Damien Le Moal wrote:
>> On 10/5/23 06:00, Mike Christie wrote:
>>> The sshdr passed into scsi_execute_cmd is only initialized if
>>> scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
>>> good statuses like check conditions to -EIO. This has scsi_mode_sense
>>> callers that were possibly accessing an uninitialized sshdrs to only
>>> access it if we got -EIO.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Martin Wilck <mwilck@suse.com>
>>> ---
>>>  drivers/scsi/sd.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index 6d4787ff6e96..538ebdf42c69 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -2942,7 +2942,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>>>  	}
>>>  
>>>  bad_sense:
>>> -	if (scsi_sense_valid(&sshdr) &&
>>> +	if (res == -EIO && scsi_sense_valid(&sshdr) &&
>>
>> 	if (ret < 0 && ...
>>
>> would be safer and avoid any issue if we ever change scsi_execute_cmd() to
>> return other error codes than -EIO, no ?
> 
> If we do that, then we will have the same problem we have today
> where we can access the sshdr when it's not setup.
> 
> If scsi_execute_cmd returns < 0, then the sshdr is not setup, so
> we shouldn't access it. The res value above is from scsi_mode_sense
> which actually does the scsi_execute_cmd call, but it doesn't always
> pass the return vale from scsi_execute_cmd directly to its callers.
> 
> If there is valid sense then scsi_mode_sense returns -EIO so above
> that's why we check for that return code.
> 
> As far as future safety goes, this patch is not great. Right now
> we assume scsi_execute_cmd and the functions it calls does not
> return -EIO. To make it safer we could change scsi_mode_sense to
> return 1 for the case there is sense or add another arg which
> gets set when there is sense.

Indeed, that would be better because scsi does not prevent a device from
returning sense data for successfull commands as well (see device statistics or
CDL as examples). So that would be a better solution than relying on -EIO for
sense data validity.

> 
> 
> 

-- 
Damien Le Moal
Western Digital Research


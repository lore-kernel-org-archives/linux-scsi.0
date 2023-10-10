Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2A6CD68F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 07:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442530AbjJJHqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442419AbjJJHqc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 03:46:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C414792
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 00:46:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC682C433C8;
        Tue, 10 Oct 2023 07:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696923990;
        bh=aO2dpYnHthxUYLsWMVrb97x0PPqCczk/ax8qHUvYyUk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=b4jGhLEYYNz9mnw3MBEI0SEEDFpKTm2G1TQ78v3Fv24r+2ohinCbpxRE5MbAvBMg1
         IzsgEN7Ybjsy2wJAwQrDqbzCy0BoIjPKPXMlhsOuCCcpHRUStKJFVK2Wzop5gGq9ZP
         Rk0TxN7FvDGFgHddOxp2rWIWV1nMpm7f6S2Simu2/w8IP6WMIyacwUgGYRd4vkf4hL
         8g2i4mR7SJR2Yx/EJIO1WbTOBPHu6Q+VfNg5xyYnf2lw5hwLMa3aZIColgKxajCENb
         +55n5my8+y3zPslbUaZew7cGcaWMDV01sSXMZgkVSOgbHCxcP5u2JrQdV0xqkC1r9f
         mMNJ0RdfU+Abw==
Message-ID: <7ac12bf0-7668-4387-94c4-67ff71b30c37@kernel.org>
Date:   Tue, 10 Oct 2023 16:46:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, charlesfdotz@tutanota.com,
        Dm Devel <dm-devel@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
 <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
 <a06b762d-32b9-448b-96cf-a2957ab1a425@suse.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a06b762d-32b9-448b-96cf-a2957ab1a425@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/23 16:15, Hannes Reinecke wrote:
> On 10/10/23 08:48, Damien Le Moal wrote:
>> On 10/9/23 15:15, Hannes Reinecke wrote:
>>> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
>>>> Hello,
>>>>
>>>> I would like to request a new device manager layer be added that accepts
>>>> trim requests for sectors and instead writes zeros to those sectors.
>>>>
>>>> This would be useful to deal with SMR (shingled magnetic recording) drives
>>>> that do not support trim. Currently after an SMR drive has had enough data
>>>> written to it the performance drops dramatically because the disk must
>>>> shuffle around data as if it were full and without trim support there is no
>>>> way to inform the disk which sectors are no longer used. Currently there's
>>>> no way to "fix" or reset this without doing an ATA secure erase despite
>>>> many of these disk being sold without informing customers that they were
>>>> SMR drives (western digital was sued for selling SMR drives as NAS
>>>> drives).
>>>>
>>> Gosh, no, please don't. SMR drives have a write pointer, and if the zone
>>> needs to be reset you just reset the write pointer. Writing zeroes will
>>> result in the opposite; the zone continues to be full, and no writes can
>>> happen there.
>>
>> Yes. And zone reset *is* a trim also since after a zone reset, the sectors in
>> the zone cannot be read.
>>
> On the same vein: why didn't we hook up 'wp reset' to trim/unmap?
> The code says:
> 
>          if (sd_is_zoned(sdkp)) {
>                  sd_config_discard(sdkp, SD_LBP_DISABLE);
>                  return count;
>          }
> 
> I distinctly remember to enable discards via 'wp reset' in the
> original code; what happened to it?

Hmmm... I do not recall exactly. I think it was all about being clear and to not
overload trim/discard, or scsi unmap, which at the time was not the prettiest
thing in scsi code (it got better though).

But I do prefer having zone reset separate from trim/discard, to be clear about
the fact that things are zone aligned. From the code perspective, there are only
few places were overloading trim with zone reset would simplify a little the
code. F2fs is probably the main one that comes to mind, but simplification would
be minor. So not worth the confusion I think.

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5910EC7113B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 23:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbjHWXXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 19:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbjHWXXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 19:23:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E99DE66;
        Wed, 23 Aug 2023 16:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B5461D47;
        Wed, 23 Aug 2023 23:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA407C433C8;
        Wed, 23 Aug 2023 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692832982;
        bh=bCKAdgkFJDINHyl0Gzt4wi0NHoiY8QaSFceO99ADbeY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Dj/oo5yBMWyFS7JF5FzMvR4LkFGpXJ8IRZSAQlrZpKTloYhkPIgZ3DutJvVQ1WDV2
         V9REN946QnVSdksRs9tbkrg0smAeHdCYnymkpMvjlXI8BW26fVn277hX7FFwkb93+C
         3KhKBvejGSChIlqEmAkSUiyKIRXTEz7y+DXncoc8jy3FCmhABuk43CeQtP+n8PdVp0
         oc9wReAE+Svo2XyNm5rK0KpJv8ShrN0QYHIkawt0LlmurK4iFtB3oO0MlyJDaJSQfB
         a5z2LLBPw9if8kAqtZD9oSxgpRQQV1dMoExWTnGn4mIX6DsDIGSy1KaIZE/nMqEF8D
         TH/tgwzapWiWA==
Message-ID: <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
Date:   Thu, 24 Aug 2023 08:22:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
 <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/24/23 00:15, Bart Van Assche wrote:
> On 8/22/23 23:26, Hannes Reinecke wrote:
>> On 8/22/23 21:16, Bart Van Assche wrote:
>>> +/*
>>> + * Comparison function that allows to sort SCSI commands by ULD driver.
>>> + */
>>> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
>>> +            const struct list_head *_b)
>>> +{
>>> +    struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
>>> +    struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
>>> +
>>> +    /* See also the comment above the list_sort() definition. */
>>> +    return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
>>
>> I have to agree with Christoph here.
>> Comparing LBA numbers at the SCSI level is really the wrong place.
>> SCSI commands might be anything, and quite some of these commands don't
>> even have LBA numbers. So trying to order them will be pointless.
>>
>> The reordering mechanism really has to go into the block layer, with
>> the driver failing the request and the block layer resubmitting in-order.
> 
> Hi Hannes,
> 
> Please take another look at patches 04/16 and 05/16. As one can see no
> LBA numbers are being compared in the SCSI core - comparing LBA numbers
> happens in the sd (SCSI disk) driver. The code that you replied to
> compares ULD pointers, a well-defined concept in the SCSI core.
> 
> Your request to move the functionality from patches 04/16 and 05/16 into
> the block layer would involve the following:
> * Report the unaligned write errors (because a write did not happen at the
>    write pointer) to the block layer (BLK_STS_WP_MISMATCH?).
> * Introduce a mechanism in the block layer for postponing error handling
>    until all outstanding commands have failed. The approach from the SCSI
>    core (tracking the number of failed and the number of busy commands
>    and only waking up the error handler after these counters are equal)
>    would be unacceptable because of the runtime overhead this mechanism
>    would introduce in the block layer hot path. Additionally, I strongly
>    doubt that it is possible to introduce any mechanism for postponing
>    error handling in the block layer without introducing additional
>    overhead in the hot path.
> * Christoph's opinion is that NVMe software should use zone append
>    (REQ_OP_ZONE_APPEND) instead of regular writes (REQ_OP_WRITE) when
>    writing to a zoned namespace. So the SCSI subsystem would be the only
>    user of the new mechanism introduced in the block layer. The reason we
>    chose REQ_OP_WRITE for zoned UFS devices is because the SCSI standard
>    does not support a zone append command and introducing a zone append
>    command in the SCSI standards is not something that can be realized in
>    time for the first generation of zoned UFS devices.

The sd driver does have zone append emulation using regular writes. The
emulation relies on zone write locking to avoid issues with adapters that do not
have strong ordering guarantees, but that could be adapted to be removed for UFS
devices with write ordering guarantees. This solution would greatly simplify
your series since zone append requests are not subject to zone write locking at
the block layer. So no changes would be needed at that layer.

However, that implies that your preferred use case (f2fs) must be adapted to use
zone append instead of regular writes. That in itself may be a bigger-ish
change, but in the long run, likely a better one I think as that would be
compatible with NVMe ZNS and also future UFS standards defining a zone append
command.

> 
> Because I assume that both Jens and Christoph disagree strongly with your
> request: I have no plans to move the code for sorting zoned writes into
> the block layer core.
> 
> Jens and Christoph, please correct me if I misunderstood something.
> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research


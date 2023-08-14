Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4454CC04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 04:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjHNES5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 00:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjHNESc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 00:18:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FC2AD;
        Sun, 13 Aug 2023 21:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1EA761735;
        Mon, 14 Aug 2023 04:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2270C433C7;
        Mon, 14 Aug 2023 04:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691986708;
        bh=sdCfbwOrNrhHX8FDcR9lXmBqbKqdYnF0NA1vNvBZblY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JBrSLtIZyE7zg2HN4loSGX9LSMxSSG7S9UdIGKDmIBkPmKYB+63ZAhFOv+2efgWNM
         it+vAbFZD68GQMyHt+fX1pt6g92KGtOsY3vTp+w7I4gPDkYyyR7bzsUe8RkT+aAWlC
         4ZyVz4zPB0f1AO8GmhuTbuYrV3mXj018cLs1EhXKcT+jyckOfZzhgHXfhEjCrozbpj
         9Sp4aFbXi0ETw2YcC7CIriYumMTyuQD04jYR9U1xbazqNyYyr13GTbHn8CHaVRZdH4
         BNHLOZiFAnIKphRKLHwiyasz5NMP40MSe9RY8eGFrkRCMbjMpvx30rv9I+MbhTeKMn
         /r4fG2T+brfFQ==
Message-ID: <5b6f882b-82ab-6a00-4a2d-4e93b8c1d973@kernel.org>
Date:   Mon, 14 Aug 2023 13:18:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 3/9] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-4-bvanassche@acm.org>
 <29cca660-4e66-002c-7378-2d2df5c79a08@kernel.org>
 <057e08f2-7349-bcad-c21d-11586c059fac@acm.org>
 <02d18d6a-ece5-f8f6-0c6c-4468c86c9ea1@kernel.org>
 <ee3e2f36-1089-f95c-8145-ea91d5912fde@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ee3e2f36-1089-f95c-8145-ea91d5912fde@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 12:23, Bart Van Assche wrote:
> On 8/13/23 19:41, Damien Le Moal wrote:
>> But at the very least, may be mention in the commit message that you also add
>> the unit tests associated with the change ?
> 
> Hi Damien,
> 
> I will mention this in the patch description when I repost this patch.
> 
>> Another remark: we'll need this sorting only for devices that are zoned and do
>> not need zone write locking. For other cases (most cases in fact), we don't and
>> this could have some performance impact (e.g. fast RAID systems). Is there a way
>> to have this eh_prepare_resubmit to do nothing for regular devices to avoid that ?
> 
> The common case is that all commands passed to the SCSI error handler
> are associated with the same ULD. For this case list_sort() iterates
> once over the list with commands that have to be resubmitted because
> all eh_prepare_resubmit pointers are identical. The code introduced
> in the next patch requires O(n^2) time with n the number of commands
> passed to the error handler. I expect this time to be smaller than the
> time needed to wake up the error handler if n < 100. Waking up the
> error handler involves expediting the grace period (call_rcu_hurry())
> and a context switch. I expect that these two mechanisms combined will
> take more time than the list_sort() call if the number of commands that
> failed is below 100. In other words, I don't think that
> scsi_call_prepare_resubmit() will slow down error handling measurably
> for the cases we care about.
> 
> Do you perhaps want me to change the code in the next patch such that
> it takes O(n) time instead of O(n^2) time in case no zoned devices are
> involved?

I was more thinking of a mean to not call scsi_call_prepare_resubmit() at all if
no zoned devices with use_zone_write_lock == true are involved.

-- 
Damien Le Moal
Western Digital Research


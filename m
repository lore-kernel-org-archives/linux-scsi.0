Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C5BC00A98
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 22:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbjJSW5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 18:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjJSW5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 18:57:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C71115;
        Thu, 19 Oct 2023 15:57:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6CDC433C7;
        Thu, 19 Oct 2023 22:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697755760;
        bh=5AReMds8l8zHuxc4ErUvmJuFm/a+ZoOlubwAHBtiYfM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QGwZouwyX6lckF4dG/QlfJ9vk3ND/DGzyCfciLUk0g7qxwp52Q3a7TRTd2UQm3kxN
         J+yUODqAeO/AsBpRW7bouQIy/59MYeaMGRaPu/wAqOI5n1RZSS4sX8bLx2nhQ/1fUZ
         3JhSnoQb+s/VLc7iHVza4KNH4Md+BdLWihmmhpRoGYlzFsa3BxTiTLVbqZeH4VX3Hc
         FqeFysYGksfOsQHW8G/YtVpkOISb4E2FC7O3p8YtrxOhL8YUD0Ls/wqkIOSW1BU0Cl
         GqwvF8IuifwJulyLR8WjA94pgrQbrMT6o6cn4SJ+OUs7YT09pnOmFkRHhu03YeLLP3
         T0zk6gEGzAuxw==
Message-ID: <04539d40-7e48-4067-b9bd-0496bcc7cfa9@kernel.org>
Date:   Fri, 20 Oct 2023 07:49:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/18] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-6-bvanassche@acm.org>
 <9ee7edc0-5edb-4e17-abae-bb7ffcf0f147@kernel.org>
 <47a5508c-cb80-4398-aa9c-e905be06ad1d@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <47a5508c-cb80-4398-aa9c-e905be06ad1d@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/23 02:53, Bart Van Assche wrote:
> 
> On 10/18/23 17:24, Damien Le Moal wrote:
>> On 10/19/23 02:54, Bart Van Assche wrote:
>>> +void scsi_call_prepare_resubmit(struct list_head *done_q)
>>> +{
>>> +	struct scsi_cmnd *scmd, *next;
>>> +
>>> +	if (!scsi_needs_preparation(done_q))
>>> +		return;
>>
>> This function will always go through the list of commands in done_q. That could
>> hurt performance for scsi hosts that do not need this prepare resubmit, which I
>> think is UFS only for now. So can't we just add a flag or something to avoid that ?
> 
> Hi Damien,
> 
> The SCSI error handler is only invoked after an RCU grace period has 
> expired. The time spent in scsi_needs_preparation() is negligible
> compared to an RCU grace period, especially if the
> .eh_needs_prepare_resubmit pointers are NULL.

I was thinking in the context of the scsi disk driver, which is the most widely
used scsi driver and does have eh_needs_prepare_resubmit set.

And I now recall that we have already discussed this when I suggested passing
the scsi_host as argument here to avoid that loop for hosts that do not need to
do that reordering (that is, everything but ufs hosts). You did mention that
this is not easily feasible if I remember correctly.

That is really too bad. It would be nice to avoid this loop when it is not
needed. But given that this is the error path, may be that is OK. I'll stay
neutral on this one for now. I need to run some performance tests. FYI, libata
triggers scsi_eh to process the completion of commands with CDL set and sense
data available, to determine if the commands were aborted or not. This loop may
be costly for that case, not sure. Will check.

-- 
Damien Le Moal
Western Digital Research


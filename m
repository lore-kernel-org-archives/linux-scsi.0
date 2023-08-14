Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46348C001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 02:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjHNClg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Aug 2023 22:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjHNClS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Aug 2023 22:41:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9EDE5C;
        Sun, 13 Aug 2023 19:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00255629A2;
        Mon, 14 Aug 2023 02:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A788C433C8;
        Mon, 14 Aug 2023 02:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691980876;
        bh=Q8BNqR4Dww3YgeiQ9HJA695g1hECskRRwwOCdvnVg5U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d7w2+lVYyDfv5m4Crb8Ot0M+S4mMcyfLTzQ/RvQil5Q69jenuFCH9uhEElRasv9Z/
         /8fwuRnH4k/Z7udLQyzOWi6uKeqolMOaDdcXDR5XpEhR6TJCctE17St9/Ogsk2qRcb
         swaWOWbK4OA+HQtiloO+Ct6+kDli6b+1S9A7XdjZTkoJ68tMy3j7r1t0teHcuepr7W
         B61Emqh2uYgNmCCeOeWbDjhOLdtE2l2xVUqZS25rEDQMlTcKePyschAY3eQC1uz2yu
         PySNCCxZpeF8y4SXOeH/s0lY2kdgruO0kjBLcEYSDLUY3NHVBLBTY1FJO3sZwXzw4P
         Fx4A7+ixkwiYg==
Message-ID: <02d18d6a-ece5-f8f6-0c6c-4468c86c9ea1@kernel.org>
Date:   Mon, 14 Aug 2023 11:41:14 +0900
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
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <057e08f2-7349-bcad-c21d-11586c059fac@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 11:18, Bart Van Assche wrote:
> On 8/13/23 18:19, Damien Le Moal wrote:
>> On 8/12/23 06:35, Bart Van Assche wrote:
>>> Make the error handler call .eh_prepare_resubmit() before resubmitting
>>
>> This reads like the eh_prepare_resubmit callback already exists. But you are
>> adding it. So you should state that.
> 
> Hi Damien,
> 
> I will rephrase the patch description.
> 
>>> +++ b/drivers/scsi/Makefile.kunit
>>> @@ -0,0 +1 @@
>>> +obj-$(CONFIG_SCSI_ERROR_TEST) += scsi_error_test.o
>>
>> All the above kunit changes (and the test changes below) seem unrelated to what
>> the commit message describes. Should these be split into a different patch ?
> 
> Some people insist on including unit tests in the same patch as
> the patch that introduces the code that is being tested. I can
> move the unit test into a separate patch if that is preferred.

OK. I will let Martin decide that :)
But at the very least, may be mention in the commit message that you also add
the unit tests associated with the change ?

> 
>>> +	/*
>>> +	 * Call .eh_prepare_resubmit for each range of commands with identical
>>> +	 * ULD driver pointer.
>>> +	 */
>>> +	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>>> +		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
>>> +		struct list_head *prev, uld_cmd_list;
>>> +
>>> +		while (&next->eh_entry != done_q &&
>>> +		       scsi_cmd_to_driver(next) == uld)
>>> +			next = list_next_entry(next, eh_entry);
>>> +		if (!uld->eh_prepare_resubmit)
>>> +			continue;
>>> +		prev = scmd->eh_entry.prev;
>>> +		list_cut_position(&uld_cmd_list, prev, next->eh_entry.prev);
>>> +		uld->eh_prepare_resubmit(&uld_cmd_list);
>>
>> Is it guaranteed that all uld implement eh_prepare_resubmit ?
> 
> That is not guaranteed. Hence the if (!uld->eh_prepare_resubmit)
> test in the above loop.

Oops. Missed that one !

Another remark: we'll need this sorting only for devices that are zoned and do
not need zone write locking. For other cases (most cases in fact), we don't and
this could have some performance impact (e.g. fast RAID systems). Is there a way
to have this eh_prepare_resubmit to do nothing for regular devices to avoid that ?

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B32C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 06:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8634061158
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 06:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhDZG7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 02:59:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:34648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231879AbhDZG7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 02:59:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFC91AAC2;
        Mon, 26 Apr 2021 06:58:49 +0000 (UTC)
Subject: Re: [PATCH 07/39] scsi: introduce scsi_status_is_check_condition()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-8-hare@suse.de>
 <9be002bc-f306-d56c-a8e0-5ed9663d81cb@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <f1f64606-8ba2-8a26-a057-d639e6faf79c@suse.de>
Date:   Mon, 26 Apr 2021 08:58:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <9be002bc-f306-d56c-a8e0-5ed9663d81cb@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:34 AM, Bart Van Assche wrote:
> On 4/23/21 4:39 AM, Hannes Reinecke wrote:
>> Add a helper function scsi_status_is_check_condtion() to
>                                              ^^^^^^^^ typo
>> encapsulate the frequent checks for SAM_STAT_CHECK_CONDITION.
> 
> [ ... ]
> 
>> +/** scsi_status_is_check_condition - check the status return.
>> + *
>> + * @status: the status passed up from the driver (including host and
>> + *          driver components)
>> + *
>> + * This returns true if the status code is SAM_STAT_CHECK_CONDITION.
>> + */
> 
> Shouldn't the function name and the description appear on the second
> line of the kernel-doc header?
> 
Yeah, you're right. I used copy&paste from the function above, looked
kinda fishy even then ...

Will be fixing it up.

>> +static inline int scsi_status_is_check_condition(int status)
>> +{
>> +	if (status < 0)
>> +		return false;
>> +	status &= 0xfe;
>> +	return (status == SAM_STAT_CHECK_CONDITION);
>> +}
> 
> No parentheses around the expression in a return statement please.
> 
Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)

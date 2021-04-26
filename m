Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEF0C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 08:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750EF610E6
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 08:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhDZIbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 04:31:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:46660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhDZIbE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 04:31:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0E756AEA6;
        Mon, 26 Apr 2021 08:30:12 +0000 (UTC)
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-16-hare@suse.de>
 <75df2cf5-ea29-ea54-f8d3-0f44a845409f@acm.org>
 <d0be206b-6666-d1cd-e0fd-bf2a1b491196@suse.de>
 <35e82f21-1480-fc88-3575-d21601678167@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 15/42] NCR5380: use SCSI result accessors
Message-ID: <5aa68ccd-5095-b03c-6207-00644b4175c9@suse.de>
Date:   Mon, 26 Apr 2021 10:30:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <35e82f21-1480-fc88-3575-d21601678167@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 6:10 PM, Bart Van Assche wrote:
> On 4/21/21 11:37 PM, Hannes Reinecke wrote:
>> On 4/21/21 11:11 PM, Bart Van Assche wrote:
>>> Do all SCSI devices from the nineties report SCSI status values with
>>> the lower bit set to 0? If so, can the status_byte() macro be removed
>>> entirely?
>>>
>> As indicated in the previous reply, yes, that is the plan (removing the
>> status_byte() macro). And the drivers will have to report SCSI status
>> values with the lower bit cleared, otherwise the linux SCSI status codes
>> would never have worked in the first place.
> 
> Please elaborate the above further. My understanding is that SCSI-2
> defines bits 0, 6 and 7 of the status byte as reserved while SAM-2
> specifies that these bits must be zero for the status codes that also
> have been defined in SCSI-2. Is it safe to assume that all SCSI-2
> devices set the reserved bits to zero?
> 
Yes. At least we haven't encountered any devices which do.
And are quite unlikely to find any new or unknown SCSI-2 devices, as the
market for SCSI parallel drives is _quite_ small :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)

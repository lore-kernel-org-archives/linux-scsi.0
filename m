Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47712C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266E261435
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238565AbhDVRei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:34:38 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:59950 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbhDVRef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:34:35 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 283A02EA421;
        Thu, 22 Apr 2021 13:34:00 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 9DLONJYOnYVF; Thu, 22 Apr 2021 13:14:10 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id AC3EC2EA279;
        Thu, 22 Apr 2021 13:33:59 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 14/42] scsi: add scsi_result_is_good()
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-15-hare@suse.de>
 <b510135a-3dca-e6e4-bdbb-f1ff3817cc29@acm.org>
 <51b16b13-d4e3-f0e4-718e-357d04ed958f@interlog.com>
 <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
 <db827915-84e0-1aea-7b30-a01a22059817@interlog.com>
 <62237423-f4f9-a426-43b5-3ff56a5dca1a@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <b00aab9c-9cb9-06a9-94b9-57e164777b26@interlog.com>
Date:   Thu, 22 Apr 2021 13:33:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <62237423-f4f9-a426-43b5-3ff56a5dca1a@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-22 12:52 p.m., Bart Van Assche wrote:
> On 4/22/21 8:56 AM, Douglas Gilbert wrote:
>> In driver manuals Seagate often list the PRE-FETCH command as optional. As
>> in: pay us some extra money and we will put it in. That suggests to me some
>> big OEM likes PRE-FETCH. Where I found it supported in WDC manuals, they
>> didn't support the IMMED bit which sort of defeats the purpose of it IMO.
> 
> Since the sd driver does not submit the PRE-FETCH command, how about
> moving support for CONDITION MET into the sg code and treating CONDITION
> MET as an error inside the sd, sr and st drivers? I think that would
> allow to simplify scsi_status_is_good(). The current definition of that
> function is as follows:
> 
> static inline int scsi_status_is_good(int status)
> {
> 	/*
> 	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
> 	 * significant in SCSI-3.  For now, we follow the SCSI-2
> 	 * behaviour and ignore reserved bits.
> 	 */
> 	status &= 0xfe;
> 	return ((status == SAM_STAT_GOOD) ||
> 		(status == SAM_STAT_CONDITION_MET) ||
> 		/* Next two "intermediate" statuses are obsolete in*/
> 		/* SAM-4 */
> 		(status == SAM_STAT_INTERMEDIATE) ||
> 		(status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
> 		/* FIXME: this is obsolete in SAM-3 */
> 		(status == SAM_STAT_COMMAND_TERMINATED));
> }

The whole stack needs to treat SAM_STAT_CONDITION_MET as a non-error.
However the complex multi-layer return values are represented,
reducing them to a comparison with zero, spread all over the
stack just seems bad software engineering. IMO a predicate function
(i.e. returning bool) is needed.

I would argue that in the right circumstances, the sd driver should
indeed by using PRE-FETCH. It would need help from the upper layers.
It is essentially "read-ahead" in the case where the next LBA
does not follow the last read LBA. A smarter read-ahead ...

Doug Gilbert

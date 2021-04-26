Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D09C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE6F60FE5
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhDZPS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:18:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:49402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZPS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:18:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F6A0AB87;
        Mon, 26 Apr 2021 15:17:45 +0000 (UTC)
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-4-hare@suse.de> <20210426145401.GD22120@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 03/39] scsi_dh_alua: do not interpret DRIVER_ERROR
Message-ID: <afb1b536-c6f4-7dc3-285a-8ef2fc637da9@suse.de>
Date:   Mon, 26 Apr 2021 17:17:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426145401.GD22120@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 4:54 PM, Christoph Hellwig wrote:
> On Fri, Apr 23, 2021 at 01:39:08PM +0200, Hannes Reinecke wrote:
>> Remove the special handling for DRIVER_ERROR; if there is an error
>> we should just fail the command and don't try anything clever.
> 
> So this code comes from your commit 40bb61a77347
> "scsi_dh_alua: switch to scsi_execute_req_flags()"
> 
> but that only switches from DRIVER_BUSY to DRIVER_ERROR, which in
> retrospective looks rather fishy.  Some kind of is busy handling here
> actually does make sense to me, so maybe we should check for that
> more sensibly?
> 
Well, as this patchset nicely demonstrated, no device ever set
DRIVER_BUSY, so that particular code was a bit of optimistic coding.

But you are correct; we should check for negative errors, as those will
be set prior to submission and most likely indicate a temporary error.
(I'd rather _not_ latch on distinct errnos here; there's a deep
call-chain involved and errors along the way might vary.)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)

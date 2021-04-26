Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA0AC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E1761103
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhDZPi7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:38:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:60656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233674AbhDZPi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:38:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 135B4AC2C;
        Mon, 26 Apr 2021 15:38:17 +0000 (UTC)
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-11-hare@suse.de> <20210426152156.GC25615@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 10/39] scsi_error: use DID_TIME_OUT instead of
 DRIVER_TIMEOUT
Message-ID: <39be939a-785a-8c34-7611-7e1aba2eb695@suse.de>
Date:   Mon, 26 Apr 2021 17:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426152156.GC25615@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:21 PM, Christoph Hellwig wrote:
> On Fri, Apr 23, 2021 at 01:39:15PM +0200, Hannes Reinecke wrote:
>> Set DID_TIME_OUT instead of DRIVER_TIMEOUT when a command
>> is finally marked as failed after error recovery.
> 
> This seems like something that we need to propagating to userspace
> through the various sg interfaces as applications could rely on the
> bit.
> 
That would be highly surprising. That particular bit is only ever set if
a timeout has triggered, but the driver did not set any other status.
Which again does _strongly_ depend on the driver; there is not consensus
what the status should be for a timed out command.
So if userspace ever saw this value it would be strongly driver
depended, and there was never any intention that any particular driver
_would_ set this flag.
In short: if it ever was set, it was by accident.
Hence userspace shouldn't check for it.

So I don't think we need to worry about that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)

Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D2DC3F2CF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66A0246A2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgB1JO6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:14:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgB1JO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:14:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC1FEB146;
        Fri, 28 Feb 2020 09:14:56 +0000 (UTC)
Subject: Re: [PATCH v7 28/38] sg: rework debug info
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-29-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f0ce95f2-42f4-8185-ecd9-69a73c3c6bef@suse.de>
Date:   Fri, 28 Feb 2020 10:14:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-29-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:58 PM, Douglas Gilbert wrote:
> Since the version 2 driver, the state of the driver can be found
> with 'cat /proc/scsi/sg/debug'. As the driver becomes more
> threaded and IO faster (e.g. scsi_debug with a command timer
> of 5 microseconds), the existing state dump can become
> misleading as the state can change during the "snapshot". The
> new approach in this patch is to allocate a buffer of
> SG_PROC_DEBUG_SZ bytes and use scnprintf() to populate it. Only
> when the whole state is captured (or the buffer fills) is the
> output to the caller's terminal performed. The previous
> approach was line based: assemble a line of information and
> then output it.
> 
> Locks are taken as required for short periods and should not
> interfere with a disk IO intensive program. Operations
> such as closing a sg file descriptor or removing a sg device
> may be held up for a short while (microseconds).
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 256 ++++++++++++++++++++++++++++++++--------------
>   1 file changed, 177 insertions(+), 79 deletions(-)
> 
Personally, I'm not a big fan of using procfs to display driver status.
I would rather move this interface to debugfs and declare the existing 
interface as deprecated.
We probably would need to observe the usual rules etc (compat functions, 
compile-time config etc), but I really would like to deprecate using 
procfs in SCSI...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

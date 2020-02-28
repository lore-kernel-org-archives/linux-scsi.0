Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465BDC3F2CF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C3A246A2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgB1JTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:19:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:50958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgB1JTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:19:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1280AC4A;
        Fri, 28 Feb 2020 09:19:00 +0000 (UTC)
Subject: Re: [PATCH v7 35/38] sg: first debugfs support
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-36-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <63c82665-b5dc-2ef7-4a06-921606b0621b@suse.de>
Date:   Fri, 28 Feb 2020 10:18:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-36-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:58 PM, Douglas Gilbert wrote:
> Duplicate the semantics of 'cat /proc/scsi/sg/debug' on
> 'cat /sys/kernel/debug/scsi_generic/snapshot'. Make code
> that generates the snapshot conditional on either
> CONFIG_SCSI_PROC_FS or CONFIG_DEBUG_FS being defined.
> 
> Also add snapshot_devs which can be written with a list of
> comma separated integers corresponding to sg (minor) device
> numbers. That file can also be read showing that list. Minus
> one (or any negative number) means accept all when in the
> first position (the default) or means the end of the list
> in a later position. When a subsequent
> cat /sys/kernel/debug/scsi_generic/snapshot
> is performed, only sg device numbers matching an element
> in that list are output.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 414 +++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 333 insertions(+), 81 deletions(-)
> 
Ah, here it is. Very good.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

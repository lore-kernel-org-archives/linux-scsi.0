Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D6CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 07:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7C02395C
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 07:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbhANHNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 02:13:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:35824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbhANHNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 02:13:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E5019ABD6;
        Thu, 14 Jan 2021 07:12:27 +0000 (UTC)
Subject: Re: [PATCH v13 28/45] sg: rework debug info
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-29-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d9337b54-6d27-b109-9667-5a913f82797f@suse.de>
Date:   Thu, 14 Jan 2021 08:12:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210113224526.861000-29-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/21 11:45 PM, Douglas Gilbert wrote:
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
Hmm. The whole '/proc' business is considered deprecated, and new
(or updated) drivers should be moving to debugfs.
Wouldn't it be better to do that, and deprecate /proc/sg, seeing that
you are rewriting the entire driver anyway?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

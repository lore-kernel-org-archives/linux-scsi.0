Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56333C43462
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F6761165
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhDHIxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:53:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:54128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhDHIxy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Apr 2021 04:53:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B816B10B;
        Thu,  8 Apr 2021 08:53:42 +0000 (UTC)
Subject: Re: [PATCH v9 09/13] lpfc: vmid: Implements CT commands for appid.
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-10-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2bc65444-c26f-1c03-53e7-70e943ffb4a8@suse.de>
Date:   Thu, 8 Apr 2021 10:37:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1617750397-26466-10-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 1:06 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> The patch implements CT commands for registering and deregistering the
> appid for the application. Also, a small change in decrementing the ndlp
> ref counter has been added.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v9:
> Added Changes related to locking and new hashtable implementation
> 
> v8:
> modified log messages and fixed the refcount
> 
> v7:
> No Change
> 
> v6:
> Added Forward declarations and functions to static
> 
> v5:
> No change
> 
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> Removed redundant code due to changes since last submit
> ---
>   drivers/scsi/lpfc/lpfc_ct.c | 257 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 256 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A815EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E4A64E6C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbhCDM05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:26:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:49158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240453AbhCDM0h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 07:26:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6D175AFB4;
        Thu,  4 Mar 2021 12:25:56 +0000 (UTC)
Subject: Re: [PATCH v8 02/16] blkcg: Added a app identifier support for blkcg
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
 <1614835646-16217-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <21d35185-705f-4baa-0f43-f9d71103c7b7@suse.de>
Date:   Thu, 4 Mar 2021 13:25:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614835646-16217-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:27 AM, Muneendra wrote:
> This Patch added a unique application identifier i.e
> fc_app_id  member in blkcg which allows identification of traffic
> sources at an individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.
> 
> Added a new function blkcg_get_fc_appid to
> grab the app identifier associated with a bio.
> 
> Added a new function blkcg_set_fc_appid to
> set the app identifier in a blkcgrp associated with cgroup id
> 
> Added a new config BLK_CGROUP_FC_APPID and moved the changes
> under this config
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v8:
> No change
> 
> v7:
> Modified the Kconfig file
> 
> v6:
> Modified the Kconfig file as per standard specified
> in Documentation/process/coding-style.rst
> 
> v5:
> Renamed the arguments appropriatley
> Renamed APPID_LEN  to FC_APPID_LEN
> Moved the input validation at the begining of the function
> Modified the comments
> 
> v4:
> No change
> 
> v3:
> Renamed the functions and app_id to more specific
> 
> Addressed the reference leaks in blkcg_set_app_identifier
> 
> Added a new config BLK_CGROUP_FC_APPID and moved the changes
> under this config
> 
> Added blkcg_get_fc_appid,blkcg_set_fc_appid as inline functions
> 
> v2:
> renamed app_identifier to app_id
> removed the  sysfs interface blkio.app_identifie under
> ---
>   block/Kconfig              |  9 ++++++
>   include/linux/blk-cgroup.h | 56 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 65 insertions(+)
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

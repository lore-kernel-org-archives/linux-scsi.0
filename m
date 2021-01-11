Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D0BC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 07:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B9E229C6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 07:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbhAKHbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 02:31:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:49882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbhAKHbE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 02:31:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B448CAD62;
        Mon, 11 Jan 2021 07:30:22 +0000 (UTC)
Subject: Re: [PATCH v7 02/16] blkcg: Added a app identifier support for blkcg
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
 <1609970430-19084-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d2f7a39d-203a-c542-3d50-997acaded6ff@suse.de>
Date:   Mon, 11 Jan 2021 08:30:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1609970430-19084-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/6/21 11:00 PM, Muneendra wrote:
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

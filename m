Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB451C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B6964F3E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbhCDMyK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:54:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:48138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239419AbhCDMxt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 07:53:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B92DFADDB;
        Thu,  4 Mar 2021 12:53:07 +0000 (UTC)
Subject: Re: [PATCH v8 16/16] scsi: Made changes in Kconfig to select
 BLK_CGROUP_FC_APPID
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
 <1614835646-16217-17-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9e01bb33-f8b0-3770-40f2-06adf5d9a917@suse.de>
Date:   Thu, 4 Mar 2021 13:53:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614835646-16217-17-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:27 AM, Muneendra wrote:
> Added a new config FC_APPID to select BLK_CGROUP_FC_APPID
> which Enable support to track FC io Traffic.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v8:
> No change
> 
> v7:
> Modified the Kconfig comments
> 
> v6:
> Modified the Kconfig comments
> 
> v5:
> No change
> 
> v4:
> Addressed the error reported by kernel test robot
> 
> v3:
> New patch
> ---
>   drivers/scsi/Kconfig | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 06b87c7f6bab..20aa1536a3ba 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -235,6 +235,19 @@ config SCSI_FC_ATTRS
>   	  each attached FiberChannel device to sysfs, say Y.
>   	  Otherwise, say N.
>   
> +config FC_APPID
> +	bool "Enable support to track FC I/O Traffic"
> +	depends on BLOCK && BLK_CGROUP
> +	depends on SCSI
> +	select BLK_CGROUP_FC_APPID
> +	default y
> +	help
> +	  If you say Y here, it enables the support to track
> +	  FC I/O traffic over fabric. It enables the Fabric and the
> +	  storage targets to identify, monitor, and handle FC traffic
> +	  based on VM tags by inserting application specific
> +	  identification into the FC frame.
> +
>   config SCSI_ISCSI_ATTRS
>   	tristate "iSCSI Transport Attributes"
>   	depends on SCSI && NET
> 
Should be merged with the patch using the Kconfig settings.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

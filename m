Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF21EC4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247672071E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKPIP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:15:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:36846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKPIP0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:15:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4348AAFAB;
        Mon, 16 Nov 2020 08:15:25 +0000 (UTC)
Subject: Re: [PATCH v4 19/19] scsi: Made changes in Kconfig to select
 BLK_CGROUP_FC_APPID
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-20-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <43145656-b258-be6b-070e-0947dc639042@suse.de>
Date:   Mon, 16 Nov 2020 09:15:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-20-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:24 AM, Muneendra wrote:
> Added a new config FC_APPID to select BLK_CGROUP_FC_APPID
> which Enable support to track FC io Traffic.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> Reported-by: kernel test robot <lkp@intel.com>
> 
> ---
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
> index 701b61ec76ee..1c73c60e398f 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -235,6 +235,19 @@ config SCSI_FC_ATTRS
>   	  each attached FiberChannel device to sysfs, say Y.
>   	  Otherwise, say N.
>   
> +config FC_APPID
> +	bool "Enable support to track FC io Traffic"
> +	depends on BLOCK && BLK_CGROUP
> +	depends on SCSI
> +	select BLK_CGROUP_FC_APPID
> +	default y
> +	help
> +	  If you say Y here, it enables the support to track
> +	  FC IO traffic over fabric.It enables the Fabric and the
> +	  storage targets to identify, monitor, and handle FC traffic
> +	  based on vm tags by inserting application specific
> +	  identification into the FC frame
> +
>   config SCSI_ISCSI_ATTRS
>   	tristate "iSCSI Transport Attributes"
>   	depends on SCSI && NET
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

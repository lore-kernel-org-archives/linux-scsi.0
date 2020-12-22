Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470B4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 17:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1633123133
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 17:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgLVRI0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 12:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgLVRIZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 12:08:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71012C0613D3;
        Tue, 22 Dec 2020 09:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=riOEXc9ElbQjYJ+LSbG5l4r+6AdwaK+XcQBz+FJDKIo=; b=MCRXC4+lzd3YiNC58MTAaMWs8a
        x2Gmwr4q8Cm6Kzif2VsAiMAGzcSPKA8zIW6qWnyQNZcxF1CcvAGLVXjYc7CG9oz6cQLaRqbZUD21O
        sb6WYilCWa9Zsk6Vu87EnVFOPZDdQF/0moukjcTYHLPZMN6+rNSFUW9Sof3B6LUWpixs57LOQbXL9
        eiPn8SLi0iuWv1GVnAYuW1DU5u8psL+g1UNgaHV4CeK2sqZl3CpF3QvptPs3ZXeSNAb5TRTi/Bit9
        C39ylmoGFLJNq/dB7KQtL4BaC2sIvdO6PThRojaoDZy+C6Ubdsw7BmMDm9kLBiFzQRck8auc07s8A
        q+KiFAFw==;
Received: from [2601:1c0:6280:3f0::64ea]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krl8L-00084C-RV; Tue, 22 Dec 2020 17:07:38 +0000
Subject: Re: [PATCH v6 16/16] scsi: Made changes in Kconfig to select
 BLK_CGROUP_FC_APPID
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
 <1608595918-21954-17-git-send-email-muneendra.kumar@broadcom.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d1a1abdc-0bb7-d074-2e65-fd9655bf9c3c@infradead.org>
Date:   Tue, 22 Dec 2020 09:07:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1608595918-21954-17-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/21/20 4:11 PM, Muneendra wrote:

> ---
>  drivers/scsi/Kconfig | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 701b61ec76ee..7b41fc3cb7f0 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -235,6 +235,19 @@ config SCSI_FC_ATTRS
>  	  each attached FiberChannel device to sysfs, say Y.
>  	  Otherwise, say N.
>  
> +config FC_APPID
> +	bool "Enable support to track FC io Traffic"

	                                 IO  {or I/O}

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
>  config SCSI_ISCSI_ATTRS
>  	tristate "iSCSI Transport Attributes"
>  	depends on SCSI && NET
> 


-- 
~Randy


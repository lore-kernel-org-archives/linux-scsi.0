Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15583C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 17:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEFCB23137
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 17:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgLVRHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 12:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgLVRHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 12:07:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDD3C0613D3;
        Tue, 22 Dec 2020 09:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=28dBPJLT+UeFhB76QkjVxwba0elN7ioWbZEoNuAnC98=; b=hiuWrGsAEgxIiypyZOih+2UOn1
        0caGea3w+uR6dT/kLxnD1jPVV9+J1pUS+nj1KDJWZ7WStyPloKua7r17l/1UaNAHuuwtHidaWLo5T
        jb2tBCyPNxkCeyB+ILbNZJkM5tngWsdSPPxiYLzpjGsMPOZHSRH8wXX3QiD8gELFYDzqIKfHBm3Dq
        10HbgqHH0yJC/qtVObVVcEG44W1WQIb4lYzIUHFjIljXU2BccKuVMC+CBvU7tu0k4qk+NDfVaFUsS
        IvU4w58jjC41/UomW7WKc6ldhc5205jwCvpRPN++u98EOYfmkVlJ+PVGIAgNX3F/FWO+nJHYq9tPs
        9vNm62jw==;
Received: from [2601:1c0:6280:3f0::64ea]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krl7Z-00081h-Nu; Tue, 22 Dec 2020 17:06:49 +0000
Subject: Re: [PATCH v6 02/16] blkcg: Added a app identifier support for blkcg
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
 <1608595918-21954-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <17bda03c-4eb4-2803-2274-1b7a8f122c32@infradead.org>
Date:   Tue, 22 Dec 2020 09:06:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1608595918-21954-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/21/20 4:11 PM, Muneendra wrote:
> ---
>  block/Kconfig              |  9 ++++++
>  include/linux/blk-cgroup.h | 56 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index a2297edfdde8..2ba6c27880e6 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -144,6 +144,15 @@ config BLK_CGROUP_IOLATENCY
>  
>  	Note, this is an experimental interface and could be changed someday.
>  
> +config BLK_CGROUP_FC_APPID
> +	bool "Enable support to track FC io Traffic across cgroup applications"

	                                 IO  {or I/O}

> +	depends on BLK_CGROUP=y
> +	help
> +	  Enabling this option enables the support to track FC io traffic across

	                                                       I/O

> +	  cgroup applications. It enables the Fabric and the storage targets to
> +	  identify, monitor, and handle FC traffic based on vm tags by inserting

	                                                    VM

> +	  application specific identification into the FC frame.
> +
>  config BLK_CGROUP_IOCOST
>  	bool "Enable support for cost model based cgroup IO controller"
>  	depends on BLK_CGROUP=y


-- 
~Randy


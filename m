Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F40C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 17:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BE023A9F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 17:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgLSRNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 12:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgLSRNM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 12:13:12 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC4AC0613CF;
        Sat, 19 Dec 2020 09:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=YAVgilegxxpd5e/S8jD6eE44Y8dwHm2eEWRqartQsr0=; b=RL2rdCE+YwHBqOX5FALqdlErOd
        ui0QYt53V8rm8dv1q9J9gJxD/yYfh5pb/ubpIDiKC2zClIT5GGCKiZVIn9j8vILdNtXG/spmUOIIu
        UwTyKD/V8/BHHIPU9g48aWnl+UAmIRuoIwve90/2SEfkkpO6OjfTZfWKn5KKxH/hsxBmcK2/eyeeJ
        ynl5f3qooSeXHI5WYLAsu0DcDFUh7963XFYuy5tgOMWyP3kyvt02+fIZET/KHaptGoYhyNTII8iDI
        IhaMJ81k848MMG6Dd1PxnNs7yH+D3UGWt/Wk+eS466Cg9hHy2/8rXxvS1lb/F0HG8pbAgWVFr6eha
        DYWgr4qA==;
Received: from [2601:1c0:6280:3f0::64ea]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqfmJ-0005Zq-Ch; Sat, 19 Dec 2020 17:12:23 +0000
Subject: Re: [PATCH v5 02/16] blkcg: Added a app identifier support for blkcg
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1608096586-21656-1-git-send-email-muneendra.kumar@broadcom.com>
 <1608096586-21656-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b765fa4e-87ba-a9a4-6c8c-68f3b410129b@infradead.org>
Date:   Sat, 19 Dec 2020 09:12:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1608096586-21656-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/15/20 9:29 PM, Muneendra wrote:

Hi--

> ---
>  block/Kconfig              |  9 ++++++
>  include/linux/blk-cgroup.h | 56 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index a2297edfdde8..1920388fb0e9 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -144,6 +144,15 @@ config BLK_CGROUP_IOLATENCY
>  
>  	Note, this is an experimental interface and could be changed someday.
>  
> +config BLK_CGROUP_FC_APPID
> +	bool "Enable support to track FC io Traffic across cgroup applications"
> +	depends on BLK_CGROUP=y
> +	help
> +	Enabling this option enables the support to track FC io traffic across
> +	cgroup applications.It enables the Fabric and the storage targets to
> +	identify, monitor, and handle FC traffic based on vm tags by inserting
> +	application specific identification into the FC frame.

Please follow coding-style for Kconfig files:

from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


thanks.
-- 
~Randy


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D31C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 17:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0CD323A00
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 17:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgLSRPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 12:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgLSRPx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 12:15:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDE0C0613CF;
        Sat, 19 Dec 2020 09:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=HMct31g3F+qy+03x3wwwa2njxDu7P7jcJ5Ew9+9wrRc=; b=xS6SexkGIHLQLdxaVFKONKwXYK
        RgFiR32+uQY/IK5Z6aMAdCqm60UQwK1unpdcNL968aLHphS8ZKM19DqT2WZXSR2aZw1eyC7QodZNj
        4zAE1Vs5g+wY0P6YdQwM+8mMOMiHqU7IGOau1232MunM5Pf8zcLJ5dRMxf49v4kJ0+tUrRUaBxSN8
        0zzKsGfbYlMAsIOkF1XTRlYsFxAPxuxGNwYVPrrWiFpUEpRs0U21yTZGhh+OfuUDKHEE4vge2PYTA
        Yfh/Q8ZKq+i5vJm6dVgtkNcY27HStE4hM491psVSRRz8oD2onwYKJ+0E7RyN4VjZ76w33wvZ/XdmT
        AEvCZZJQ==;
Received: from [2601:1c0:6280:3f0::64ea]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqfow-0005gC-8H; Sat, 19 Dec 2020 17:15:06 +0000
Subject: Re: [PATCH v5 16/16] scsi: Made changes in Kconfig to select
 BLK_CGROUP_FC_APPID
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1608096586-21656-1-git-send-email-muneendra.kumar@broadcom.com>
 <1608096586-21656-17-git-send-email-muneendra.kumar@broadcom.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e60169fc-c973-da16-31c4-96b497aa6291@infradead.org>
Date:   Sat, 19 Dec 2020 09:15:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1608096586-21656-17-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 12/15/20 9:29 PM, Muneendra wrote:
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 701b61ec76ee..1c73c60e398f 100644
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
> +	  FC IO traffic over fabric.It enables the Fabric and the

	                over fabric. It

> +	  storage targets to identify, monitor, and handle FC traffic
> +	  based on vm tags by inserting application specific

	           VM

> +	  identification into the FC frame

	                             frame.



-- 
~Randy


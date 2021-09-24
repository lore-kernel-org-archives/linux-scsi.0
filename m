Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8657C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 17:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924FE60F24
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 17:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343503AbhIXRJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 13:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347551AbhIXRJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 13:09:11 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BDEC061768;
        Fri, 24 Sep 2021 10:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=pcrBpOrnyOQh3GLAcvxhWh8c6kurCGLz+Z8a4kSID3w=; b=WE+2bxtHPhHAgGZ5bGn9mapDm4
        SrqPmL4mnFa6nKG6lFWtcg0IrP6TIKnzkor3YK/MZI4oZRT9hyUlPV7Z2ijFlWMh8OyLQoAJpO+pG
        TIPMbEwL+yDuA84jgkg97Utt4Etc63JGbpg0vCUq+Tqlg8WxFpAxHAxMbC0bRkxdkqTB5fAqiBCNP
        k31nzpaCmC25j5VhKEn+nQwzC3r6Pr1xyfRVWE+IIL9sZMjdshaZt/d5taHeYSTm/7a+2hbX7qOWn
        M0t9Xw7y+rFyzUVNDTrthERPIffIzSmh5TMOJpnNOvXplgspa+JSkJq5R9TiyamsVV5hFNENTJMUG
        vU0vmbrA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTofY-00FAXQ-Km; Fri, 24 Sep 2021 17:07:28 +0000
Subject: Re: [PATCH] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
To:     Anders Roxell <anders.roxell@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jdelvare@suse.com, linux@roeck-us.net
Cc:     avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hwmon@vger.kernel.org
References: <20210924164530.1754128-1-anders.roxell@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c3bdc145-70e7-b504-0437-f451a3e1c5a8@infradead.org>
Date:   Fri, 24 Sep 2021 10:07:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924164530.1754128-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/21 9:45 AM, Anders Roxell wrote:
> When building an allmodconfig kernel, the following build error shows
> up:
> 
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_probe':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:177: undefined reference to `hwmon_device_register_with_info'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:177:(.text+0x510): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_device_register_with_info'
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_remove':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:195: undefined reference to `hwmon_device_unregister'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:195:(.text+0x5c8): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_device_unregister'
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_notify_event':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:206: undefined reference to `hwmon_notify_event'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:206:(.text+0x64c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_notify_event'
> aarch64-linux-gnu-ld: /home/anders/src/kernel/next/drivers/scsi/ufs/ufs-hwmon.c:209: undefined reference to `hwmon_notify_event'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:209:(.text+0x66c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_notify_event'
> 
> Since fragment 'SCSI_UFS_HWMON' can't be build as a module,
> 'SCSI_UFS_HWMON' has to depend on 'HWMON=y'.
> 
> Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>   drivers/scsi/ufs/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 565e8aa6319d..30c6edb53be9 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -202,7 +202,7 @@ config SCSI_UFS_FAULT_INJECTION
>   
>   config SCSI_UFS_HWMON
>   	bool "UFS  Temperature Notification"
> -	depends on SCSI_UFSHCD && HWMON
> +	depends on SCSI_UFSHCD && HWMON=y
>   	help
>   	  This provides support for UFS hardware monitoring. If enabled,
>   	  a hardware monitoring device will be created for the UFS device.
> 

Also-Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

-- 
~Randy

Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C8EEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 23:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjF1XyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 19:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjF1Xx4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 19:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503CF26B7;
        Wed, 28 Jun 2023 16:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3054C614A3;
        Wed, 28 Jun 2023 23:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1585C433C8;
        Wed, 28 Jun 2023 23:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687996434;
        bh=F6vzXPCW6Woeq9Ou3mqYh6g7Dx1xrVdicCI0ov5Kx/k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uKigdqY91w/tOLpSPGtAvr1bKQNqQqiEQbKjcQQVpMYu0k17Es7skS5uVjhwnGxdt
         1RRAIqyaXyyAO8PZr53kKNYWBK498BLPy00hnI4L3+9/8PHm/tA0COPMn/T5xpHMiv
         TYvmi7X1mwVMKdoQVZbamE/u7pskmaipcT2UOCCvSHLgOTeupN+EoicGUl5uwjvV1X
         Ms+X2skOBYCo5P8n1oB+03fiBJEZi9eJtrtkIO4HEXMwfuhLdz87BIDiJoICMs/HmS
         td0VPo9NehDeLO3nuDsyVxhDXjE5otU3MrkzVI9vP0PLu+Ti91n97vXqvBU9G9JaMQ
         +MYL0/Gourb9A==
Message-ID: <f170e2ae-a416-7a0b-ff52-f446eaf78ab9@kernel.org>
Date:   Thu, 29 Jun 2023 08:53:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/2] mpt3sas: Perform additional retries if Doorbell read
 returns 0
Content-Language: en-US
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        stable@vger.kernel.org
References: <20230628070511.27774-1-ranjan.kumar@broadcom.com>
 <20230628070511.27774-2-ranjan.kumar@broadcom.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230628070511.27774-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/23 16:05, Ranjan Kumar wrote:
> Doorbell and Host diagnostic registers could return 0 even
> after 3 retries and that leads to occasional resets of the
> controllers, hence increased the retry count to thirty.

The magic value "3" for retry count was already that, magic. Why would things
work better with 30 ? What is the reasoning ? Isn't a udelay needed to avoid
that many retries ?

> 
> Fixes: b899202901a8 ("mpt3sas: Add separate function for aero doorbell reads ")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[..]

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 05364aa15ecd..3b8ec4fd2d21 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -160,6 +160,8 @@
>  
>  #define IOC_OPERATIONAL_WAIT_COUNT	10
>  
> +#define READL_RETRY_COUNT_OF_THIRTY	30
> +#define READL_RETRY_COUNT_OF_THREE	3

Less than ideal naming I think. If the values need to be changed again, a lot of
code will need to change. What about soemthing like:

#define READL_RETRY_COUNT	30
#define READL_RETRY_SHORT_COUNT	3

>  /*
>   * NVMe defines
>   */
> @@ -994,7 +996,7 @@ typedef void (*NVME_BUILD_PRP)(struct MPT3SAS_ADAPTER *ioc, u16 smid,
>  typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
>  	u16 funcdep);
>  typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16 smid);
> -typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr);
> +typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr, u8 retry_count);
>  /*
>   * To get high iops reply queue's msix index when high iops mode is enabled
>   * else get the msix index of general reply queues.

-- 
Damien Le Moal
Western Digital Research


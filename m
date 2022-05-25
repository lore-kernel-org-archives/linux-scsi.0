Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2030AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 20:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242682AbiEYUst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 16:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344003AbiEYUsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 16:48:47 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BC4B41ED
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 13:48:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 137so19844792pgb.5
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 13:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+rJFsrpWf96IBFapZZS/u5IzR56LOV7xtfRzSAaw63E=;
        b=cwldpChSAF8BUp4EP7wlKNwGkW9sbHhNM8bfhLsTzATGycffaiO9uW5o4jrQV7XWpU
         wJRdCyaC+j04x5rBylg2pXkEQRWHeT4Jk3Dk4Fv5AoBQ1LNne8ddTiiZ3BUZzL7gI4Kc
         FvuhRuUwk3iEzq9A1vpjezYdi44cAoRAwluPvIUmoyULM9JG04OC8+tf8CsJ4Az4ZEpv
         vCcc4UWjRf9b9pyGwkH3BBwW/HMZ817juKHDQxitMxtuX/eryBIpTHhRr7GHlchmL01p
         uFbvnQGWYVeR0ZJQOtfXzIW5INcgfp+/7IB7yIprXG0ALrDFhHSo5MR0JMUq/jGVQgl6
         m2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+rJFsrpWf96IBFapZZS/u5IzR56LOV7xtfRzSAaw63E=;
        b=DEwC6H+vftKlTI/dLMHWdWl6u55ALrvR65vLvDiw9dgS7y9PdAsCOwYOWeibF8HL0l
         i9N+ZVdQ66SbT9WROWOI88OGklLoyPEDx2WIxwgZdLMkX/3k8smp4rd+vPx2UjHXBQ4S
         qZf53j5v7ataYqH/NS5mufRwvYnxuIsqnyGrdx9i9N5gUYIf5VwTni8tR0Q5RBZh/TpR
         0tZPTrrPKjDPURuxqSoWji4G1f3aQZbg26WJkQpjqjWFQovm4HlgcV71JDkyJDOn1pBD
         Q8sDACZnmu9SHaklDKjbBSKMsWxiydB7odw/7oYlCORibFOpTRphWbX7PpfcW3AIVKCv
         JA+g==
X-Gm-Message-State: AOAM531imBgB3MyDUqEdIJEXHpVA/EzMYk2K+vk67Y0J8yYgGJI8HH1K
        K/L3Adk1TwQkKXp6KhiBroY=
X-Google-Smtp-Source: ABdhPJwXlwsrhBjM6vucZqtALauAaNvDDOl8GWsUklDg4MTjZodBQpJfcmr25swO79BO7DzVfpWiuA==
X-Received: by 2002:a65:62d0:0:b0:3fa:c6aa:6901 with SMTP id m16-20020a6562d0000000b003fac6aa6901mr6250634pgv.314.1653511725978;
        Wed, 25 May 2022 13:48:45 -0700 (PDT)
Received: from [10.69.47.244] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x21-20020a62fb15000000b0050dc76281b8sm12053092pfm.146.2022.05.25.13.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 13:48:45 -0700 (PDT)
Message-ID: <28131480-245f-55ce-f515-103d9d096c37@gmail.com>
Date:   Wed, 25 May 2022 13:48:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH REPOST] scsi: lpfc: Add support for ATTO Fibre Channel
 devices
Content-Language: en-US
To:     Bradley Grove <bradley.grove@gmail.com>, linux-scsi@vger.kernel.org
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Bradley Grove <bgrove@attotech.com>,
        Jason Seba <jseba@attotech.com>
References: <20220524125621.47102-1-bgrove@attotech.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20220524125621.47102-1-bgrove@attotech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/2022 5:56 AM, Bradley Grove wrote:
> Update pci_device_id table and generate reporting strings for ATTO
> Celerity and ThunderLink Fibre Channel devices.
> 
> Co-developed-by: Jason Seba <jseba@attotech.com>
> Signed-off-by: Jason Seba <jseba@attotech.com>
> Signed-off-by: Bradley Grove <bgrove@attotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_hw.h   | 22 +++++++++
>   drivers/scsi/lpfc/lpfc_ids.h  | 30 ++++++++++++
>   drivers/scsi/lpfc/lpfc_init.c | 89 +++++++++++++++++++++++++++++++++++
>   3 files changed, 141 insertions(+)
> 

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

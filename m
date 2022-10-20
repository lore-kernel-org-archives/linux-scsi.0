Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F78C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 18:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJTSXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 14:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiJTSXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 14:23:09 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413131F5243
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 11:23:08 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id 3so339033pfw.4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 11:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4NwgHJJbmZqcjtZaEOdN6loom2Ho6CVt39t2YhLpiA=;
        b=SzpTiSBDeKeb+dllKLlQir/N4nWMp7QXbYh7HaKV1UoBX7E3BqLq23sxipcclx0d0G
         eTasVmsgmc1W6p+6JcIsTI4mOKfyqx0Ymzo4kXMc8+ENoTwZ6svjZ/xL08eN1ZOZEG9j
         MGgaGbzW0ZXYE2It4zUyqdFYaCQL8ut2BHDPKuoPT0yFifiLOy8KyY7+XtXXtdssMNVW
         npALrz33XVvspBfedNrNQ8R04gKF4vaBoQVCUW66bVVo/rHUG6SPJhGhNfqo7585lSy6
         FYn+5pj4c2UE8kpSMJKf0hideoRBg6lD7J2hMhfi5JrdveoWarX+5aMNDLZoZp9JjVzI
         m99A==
X-Gm-Message-State: ACrzQf2Xp+qoPJ8Z1HnoCbvSEjiUeG/K0/AUPKk8PVVXcY9yeKp8lyMD
        hgG7hhEkaVlUAFFYBEZv5FgMtvBy5yU=
X-Google-Smtp-Source: AMsMyM6HO4Fm+hPxbBvi6BP4n4zLKJ0rjzyRynCiVCVG3sNXtS8REMYWQrMRTdM7M2iZ/5qmzbaicg==
X-Received: by 2002:a63:6e81:0:b0:46e:9fda:21a8 with SMTP id j123-20020a636e81000000b0046e9fda21a8mr3287715pgc.30.1666290187601;
        Thu, 20 Oct 2022 11:23:07 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e10c:786f:1f97:68bc? ([2620:15c:211:201:e10c:786f:1f97:68bc])
        by smtp.gmail.com with ESMTPSA id i2-20020aa796e2000000b00560e5da42d5sm13471521pfq.201.2022.10.20.11.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 11:23:06 -0700 (PDT)
Message-ID: <9d5b6884-ab70-fcf1-6c72-fde8724298ff@acm.org>
Date:   Thu, 20 Oct 2022 11:23:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 23/36] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-24-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221016195946.7613-24-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/22 12:59, Mike Christie wrote:
> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
> we retried specifically on a UA and also if scsi_status_is_good returned
> failed which could happen for all check conditions, so in this patch we
> don't check for only UAs.
> 
> We do not handle the outside loop's retries because we want to sleep
> between tried and we don't support that yet.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

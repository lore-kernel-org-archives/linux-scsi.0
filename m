Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300C7C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 17:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiI3RPc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 13:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3RPa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 13:15:30 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C2C52DFF
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 10:15:28 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so4791093pjr.5
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 10:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xR4oWCXP/1A4sed8uTbE7zi6ZXvy/1vu+w5Pg0KPjDI=;
        b=cs6b/jquTrtvit0WZO2Qs9IoEqu2W5y2hfo5MYsGP2oT12hGS+umjoJ9Aw2tAGiSCt
         9UPrpqHx9AAUjQBHmnlLo4zdvIwJ6hoDDS+FCmHeuxTHceAfMar4QLYmoezYqZvY4UZK
         2PZAknchpOM/lLea1Q5JE+KA/B4SBPogu4gHl8NAM6qilWRI7yrJj+P8pGmLN3g8vdLx
         lLy9WUqH6KxVonrCAR7ByKe14YuNm8Dmp8k04urR0czsiwSlzw8bIcQqs3b1gRw1fYrh
         +Ki6RDfJakeHDcdJsyiQtsBsWeACV/tSjjhBTBEpFlVzc3vxD6xXq/OxCQMvmtsCQezo
         9xGw==
X-Gm-Message-State: ACrzQf1WW0lOLKmflEG9AKxxLlfwTwHBDxfm8pxE0GpTyXpPKNJIHXa9
        quk6DGE546wsU5CaBTd+lsw=
X-Google-Smtp-Source: AMsMyM57wUCQ9zvosmPHy8Riwfwy+u7UV/Hk7RMMuUtHWX8lyM9TZyeFFh0NwIA6NBu4aTRT2pgAng==
X-Received: by 2002:a17:90b:4f86:b0:203:bbe8:137c with SMTP id qe6-20020a17090b4f8600b00203bbe8137cmr10998712pjb.47.1664558127977;
        Fri, 30 Sep 2022 10:15:27 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id k19-20020a63d853000000b0043be496f3f3sm1927882pgj.57.2022.09.30.10.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 10:15:27 -0700 (PDT)
Message-ID: <af357394-7329-b218-ccf9-65944a35fc6e@acm.org>
Date:   Fri, 30 Sep 2022 10:15:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-9-bvanassche@acm.org>
 <67bfe4a2175da74b686a4990a6ebe0b91017599f.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <67bfe4a2175da74b686a4990a6ebe0b91017599f.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/22 08:03, Bean Huo wrote:
> On Thu, 2022-09-29 at 15:00 -0700, Bart Van Assche wrote:
>> +       ufshcd_link_recovery(hba);
>> +       dev_info(hba->dev, "%s() finished; outstanding_tasks =
>> %#lx.\n",
>> +                __func__, hba->outstanding_tasks);
>> +
>> +       return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER :
>> SCSI_EH_DONE;
> 
> Bart,
> 
> you have reset the device and host,  in the case, there are pending
> TMs, Should be cleared locally, just like ufshcd_err_handler() does?

Hi Bean,

Do you agree with the following?
* SCSI task management functions are only submitted by the SCSI error
   handler.
* The ufshcd_link_recovery() call added by this patch can only be
   invoked during system suspend.
* System suspend only happens after processes and kernel threads have
   been frozen and after sync() finished. Hence, no I/O should be in
   progress when ufshcd_wl_suspend() is called and the SCSI error handler
   should not be running either.
* Hence, no SCSI commands other than START STOP UNIT should be in
   progress when the ufshcd_link_recovery() call added by this
   patch is invoked. No TMFs should be in progress either.

Thanks,

Bart.

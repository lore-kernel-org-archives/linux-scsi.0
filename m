Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D514C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 16:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64AC560EBD
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 16:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhG3QFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 12:05:15 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:37608 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhG3QFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2021 12:05:14 -0400
Received: by mail-pj1-f52.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso21506834pjq.2;
        Fri, 30 Jul 2021 09:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mb1gO+6STzLWuQhCsk6+1XZIXPWL26jkAcu9s9eX/WM=;
        b=LOtV3XNjZJohMmWgMYVuJTC7qRGR7Bmo2BFoyfuyY8/8WpDTTJDibU4S88ng2z0TwQ
         j7q9YBy6RQBkYihYVQI+Le+hLa5snX7YUhtZK5KjWE4dC7kLo01htdu/ZOEaJSihI5I1
         7B+f2JjFtSi9wQ35DnkExeAcZVtKMbQ/GBjii3l2NXSlS+8mDcfDW713To2fWmAMQZ50
         WEr/HPfxU7ii0vYMHbmTyqVlax3zS9p3IswT0krHqHX/pBynvf3b8m+XvOf2Ls2zm3zf
         S/yvK6e5eCu4SYx0AbX6+hbRlm/KxrNOLTmFy4c98Aa3cTEdSDVF8nCZ2O8GWZTEjZ/g
         x5BQ==
X-Gm-Message-State: AOAM533jWpYEU2JWyAGfWPdPsQFXdIaJQCQ3X96dwvaUPmTGzdboaDHS
        t/Xejicxqw8SxeVDnRAYNAU=
X-Google-Smtp-Source: ABdhPJwy2js4U4Iak2ex7sFLzTif9lZyITB6DErOQjLoUeAcFMkysbqnCLlnlpw94AUCOgqEqlpJxw==
X-Received: by 2002:aa7:9546:0:b029:32e:5fdf:9576 with SMTP id w6-20020aa795460000b029032e5fdf9576mr3353456pfq.5.1627661107884;
        Fri, 30 Jul 2021 09:05:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:684a:6173:abee:6f13])
        by smtp.gmail.com with ESMTPSA id r128sm2997972pfc.155.2021.07.30.09.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 09:05:07 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
To:     Avri Altman <Avri.Altman@wdc.com>,
        Vincent Palomares <paillon@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210728012743.1063928-1-paillon@google.com>
 <DM6PR04MB6575579560F7CB1B71103F28FCEB9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1630ebc3-b40e-31e3-1efa-67717e186b0a@acm.org>
Date:   Fri, 30 Jul 2021 09:05:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575579560F7CB1B71103F28FCEB9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/28/21 11:48 PM, Avri Altman wrote:
> Vincent wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b87ff68aa9aa..9ec5c308a0ea 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9625,6 +9625,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
>> *mmio_base, unsigned int irq)
>>          async_schedule(ufshcd_async_scan, hba);
>>          ufs_sysfs_add_nodes(hba->dev);
>>
>> +       device_enable_async_suspend(dev);
>>          return 0;
> Isn't device_enable_async_suspend is being called for each lun in scsi_sysfs_add_sdev Anyway?

Hi Avri,

Our measurements have shown that resume takes longer than it should with 
encryption enabled. While suspending we change the power mode of the UFS 
device to a mode in which it loses crypto keys. Restoring crypto keys 
during resume (blk_ksm_reprogram_all_keys()) takes about 31 ms. This is 
the long pole and takes much more time than resuming LUNs. This patch 
makes UFS resume happen concurrently with resuming other devices in the 
system instead of serializing it. Measurements have shown that this 
patch significantly improves the time needed to resume an Android device.

Bart.

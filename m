Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4ED2C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 20:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A128360F4B
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 20:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhIAUrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 16:47:22 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:51149 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhIAUrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 16:47:21 -0400
Received: by mail-pj1-f49.google.com with SMTP id fz10so489961pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Sep 2021 13:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rCUazr29hnacfBiQLmDFPin1HuH4xfapDIBTe+WGbEE=;
        b=WsT5H1Otf0Hj5+9M1lJqHoqa480o9z4656cDUDia3kNfy7ObP2rdoHZ8Cz/MP6DwBC
         CT9etMyZzjPpe2Ps9E/Kie4FgN+cisk3L1qcxO9Swu2P9kg5uRDtkjNKMJRkqI57iyOz
         ocryIe55g1yozguvYGaApJWkCqDB+VpBRKUlgVUEnrbPd57WFfgcq6CnX/2yp6zl36PX
         CfPJW+tdkKLnHGU5xa36CVVIg26ilBLVJVeyEmr+jWUJqqSPlK33krLPP2hsasuqiXwo
         VeiHBuzTc5NXtjLUJwFxhIcfFB7vUEANpycE5QgIRH3dVH+j9piqGms/RjIjDFIF/dp7
         lLYA==
X-Gm-Message-State: AOAM5323TUQn4w9DxSlhjsbwKJ2pZSlJXUkamCb+oMowyA7qtTK6a9At
        uKZnO0X8H6tPd6Ymicy4lck=
X-Google-Smtp-Source: ABdhPJzc0In3b8DNFj8Zff3Gx3/GY8SWpmuZibCN1lQMas8WKCi7D5ktMX2/qzIL6nfDdpv6YsyGLw==
X-Received: by 2002:a17:90a:514b:: with SMTP id k11mr1300644pjm.152.1630529183706;
        Wed, 01 Sep 2021 13:46:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8a3b:44ab:b62:3ce2])
        by smtp.gmail.com with ESMTPSA id 73sm351135pfu.92.2021.09.01.13.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 13:46:22 -0700 (PDT)
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
 <020bd6be-0944-8e25-c9fd-972cab5e6746@acm.org>
 <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
 <2719c43f-d56b-b2bb-0e34-53bcec74e0d9@acm.org>
 <77088200-5fab-78e9-777b-ceb259f44f03@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c34be6af-6ba2-2ad5-bc51-69b2258dfd5b@acm.org>
Date:   Wed, 1 Sep 2021 13:46:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <77088200-5fab-78e9-777b-ceb259f44f03@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/21 12:42 AM, Adrian Hunter wrote:
> No it doesn't use host_sem.  The problem is with issuing requests to a blocked queue.
> If the UFS device is in SLEEP state, runtime resume will try to do a
> SCSI request to change to ACTIVE state.  That will block while the error
> handler is running.  So if the error handler is waiting on runtime resume,
> deadlock.

Please define "UFS device". Does this refer to the physical device or to 
a LUN?

I agree that suspending or resuming a LUN involves executing a SCSI 
command. See also __ufshcd_wl_suspend() and __ufshcd_wl_resume(). These 
functions are used to suspend or resume a LUN and not to suspend or 
resume the UFS device.

However, I don't see how the above scenario would lead to a deadlock? 
The UFS error handler (ufshcd_err_handler()) works at the link level and 
may resume the SCSI host and/or UFS device (hba->host and hba->dev). The 
UFS error handler must not try to resume any of the LUNs since that 
involves executing SCSI commands.

Bart.



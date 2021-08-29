Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4580BC432BE
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 21:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1668460F36
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 21:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhH2Vem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Aug 2021 17:34:42 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35532 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhH2Vem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2021 17:34:42 -0400
Received: by mail-pf1-f175.google.com with SMTP id x16so10634850pfh.2
        for <linux-scsi@vger.kernel.org>; Sun, 29 Aug 2021 14:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=N54X4t4SFFkekc0QrQp/rLphDNw2U0JyF2INc4UrItw=;
        b=U6W+aVrurDCw2GqRcDjVc4JfsU1CYfYKUf8Hxba8QY0g+zQ4DiPayXtA/qCW6R8V1a
         r+cw3sOS+fVyTB0+Z3K60S6hejxv7yODWt/rwzVKy8T8GD6kiI1E/fZRzChUwuy3zV3o
         +1zYbaeZmn8jXanSWV4zlIxvOZU2EXAEDji4DCphYzMgY7b+xIYri9NPjx0kfnDl86aW
         YMgEeYtgqKbNrAviMQsLawawsbhTAEMLRA9SHXgFjkzRHyzc65UzXfkN/JpeieZfAviy
         4a9V64JtjUe27ol8vCYd2gZg8TZE304QxRse97f1dZ7PMLsrH6JtJF/4mJkf4AjDEl/z
         fURQ==
X-Gm-Message-State: AOAM532QhfhLaEf9yfUDQ1G3yWgyIOo8D7Yt2iqulV4Fg1uZRpOe/3QN
        ZPbK8Z+shwDuRBTm1Vz54aWugUb963I=
X-Google-Smtp-Source: ABdhPJwMw9HeSj79u4jWu45XtptCspfmuUaze6YJaau7S4REmk0v4FgJIam6/uLfZyAe23kwWX1c1g==
X-Received: by 2002:a63:ef57:: with SMTP id c23mr18452907pgk.60.1630272829438;
        Sun, 29 Aug 2021 14:33:49 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:3a42:154:b70e:7868? ([2601:647:4000:d7:3a42:154:b70e:7868])
        by smtp.gmail.com with UTF8SMTPSA id 17sm18895844pjd.3.2021.08.29.14.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 14:33:48 -0700 (PDT)
Message-ID: <d3c4d5e8-12fd-57ca-6835-a370cadea809@acm.org>
Date:   Sun, 29 Aug 2021 14:33:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
To:     Avri Altman <Avri.Altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
 <DM6PR04MB6575F35FE07904EB50ECDB4FFCCA9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <DM6PR04MB6575F35FE07904EB50ECDB4FFCCA9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/29/21 00:17, Avri Altman wrote:
> Shouldn't a transport template ops be used only for scsi_transport modules?

If a transport template is used by multiple SCSI LLD drivers then the 
transport implementation should be implemented as a kernel module of its 
own. Since the transport template introduced by this patch is not used 
by any other kernel module I think it's fine to define this transport 
template in the UFS driver.

Bart.

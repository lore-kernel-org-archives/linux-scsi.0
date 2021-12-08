Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6324C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Dec 2021 17:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhLHR52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Dec 2021 12:57:28 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:34346 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbhLHR5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2021 12:57:25 -0500
Received: by mail-pg1-f169.google.com with SMTP id g16so2723069pgi.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Dec 2021 09:53:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJrU9tj/s1VhJVvAVHqJfVeKU2o0QaneAW+R3pwDGqs=;
        b=cvK0GPKiqt6csWH7CyQ6GBm37y9XwyiHK6HYcs43jALiB3kJPH3Xm+hvTcoaY9enyo
         2NPwSWM7/Xmn2nXBcyziR7laMnlRD/kBcUSOaL9qahtnCSu2Sw6jYlCmtAf0AfNwIrOE
         NYwfoP2ARzAu5uZLiIRreGCH4vNLv+SWP/P6JPXH/9C7bWJv7yawvYKseVbiTDRCa0DZ
         algQPsH1xtPXY6rNvatdWkc0MfXCsAbOpVJQaxov+/3nVaTrrE+e145nxrDGZCGG1QoK
         gfCl+tyuvJslc/QIeL9vAcpyyjKcVuGwsnb9GuZR5sqzaAhe6Qzu461/S5GtJds3avAS
         7Pwg==
X-Gm-Message-State: AOAM5332qXa+YgZhYjFApWhiPwhwSaqGs/tWoRCKnkbUc1QZYAfbluP6
        meN7Oz3cFTPMba4hWikUSu6EAoKywuY=
X-Google-Smtp-Source: ABdhPJyTZB/mfxgjEB97How4/I5oLzyff528pRExcYG9Va1MKHNiPEOfeIZt1YwpQxIKFCHhzru9vw==
X-Received: by 2002:a65:5c85:: with SMTP id a5mr30183501pgt.419.1638986033034;
        Wed, 08 Dec 2021 09:53:53 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:18af:8865:db7e:6769])
        by smtp.gmail.com with ESMTPSA id d17sm4037354pfj.215.2021.12.08.09.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 09:53:51 -0800 (PST)
Subject: Re: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <20211203231950.193369-17-bvanassche@acm.org>
 <0ba5c50f-3e79-2cae-c502-59f70812cca3@codeaurora.org>
 <e58839a4-7dea-b549-740a-c7b8c9028aa1@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fec24396-d890-2e06-755e-20a4a97cb03e@acm.org>
Date:   Wed, 8 Dec 2021 09:53:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e58839a4-7dea-b549-740a-c7b8c9028aa1@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/21 9:28 AM, Asutosh Das (asd) wrote:
> On 12/6/2021 2:41 PM, Asutosh Das (asd) wrote:
>>> +static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
>>> +{
>>> +    struct scsi_device *sdev;
>>> +    u32 pending = 0;
>>> +
>>> +    shost_for_each_device(sdev, hba->host)
>>> +        pending += sbitmap_weight(&sdev->budget_map);
>>> +
> I was porting this change to my downstream code and it occurred to me that in a high IO rate scenario it's possible that bits in the budget_map may be set even when that particular IO may not be issued to driver. So there would unnecessary waiting for that to be cleared.
> Do you think it's possible?
> I think we should wait only for requests which are already started.
> e.g. blk_mq_tagset_busy_iter() ?

Hi Asutosh,

Using blk_mq_tagset_busy_iter() would be racy since the "busy" state is set
after host_self_blocked has been checked.

Checking the budget_map should work fine since a bit in that bitmap is set
just before scsi_queue_rq() is called and since the corresponding bit is
cleared from that bitmap if scsi_queue_rq() fails or if a command is completed.

See also the output of the following command:

git grep -nHE 'blk_mq_(get|put)_dispatch_budget\('

See also the blk_mq_release_budgets() call in blk_mq_dispatch_rq_list().

Thanks,

Bart.

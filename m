Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF34C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C666263460
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbhKOSfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:35:53 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35585 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbhKOScL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 13:32:11 -0500
Received: by mail-pl1-f173.google.com with SMTP id b13so15242432plg.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 10:29:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MhvQUnaFuDMYVOAr6dOenqvyh4WGh9dHAmZFXKypU7g=;
        b=vBSS3CalLmxvbjjF3thzrGCjxEVT4suy+k4nKdSkqdfYwypykqG6bTGwflrn9Twr8s
         SKzCwDtGBULgJ46aEvzVlgTwH03v3vrkOJchMFtJOW2Tk5zKfBTpOuSZ1d5OGVBjqweE
         cENGbdP2aoK3wIuz9ZvSkWnlLy/b815UgtSg4BAp9/VQXIa9QwoaEXA6+nIdw25/EZ/T
         QrdJcaikqupK1b9yv2MyF8x3wtU7/u63ABnO8m4b5YPmjo5c6ujaY61NlfhLtND83VAj
         O9+zvva0bhJSHpt1TNyzocwJhDBfHRtjHXpJQhAdSBsZc8HwnRC6jlSkwNU7MuAL8lqB
         G3qw==
X-Gm-Message-State: AOAM531YZwKtue6CNNx24zn5OBzeJvwzHZ3ErkPB5wDZDayhi3RxdmpY
        NaiRO/xFupDTnvN2WESZn9WEsJ6A68Oh6w==
X-Google-Smtp-Source: ABdhPJxHZBGfw/zOYbOE+4W8VetPrZUqP+4OPMprBB9bEsn/9QWFFj8CwwHRNjVI6J51BMSbhTrbWw==
X-Received: by 2002:a17:90b:3b44:: with SMTP id ot4mr765558pjb.202.1637000954749;
        Mon, 15 Nov 2021 10:29:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id a10sm12184349pgw.25.2021.11.15.10.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:29:14 -0800 (PST)
Subject: Re: [PATCH 07/11] scsi: ufs: Fix a deadlock in the error handler
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-8-bvanassche@acm.org>
 <DM6PR04MB6575281355B3E4F18204131DFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <97736952-4f77-2b2f-afe6-e36e749d83a2@acm.org>
Date:   Mon, 15 Nov 2021 10:29:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575281355B3E4F18204131DFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 11:33 PM, Avri Altman wrote:
>> @@ -8152,7 +8147,8 @@ static struct scsi_host_template
>> ufshcd_driver_template = {
>>          .this_id                = -1,
>>          .sg_tablesize           = SG_ALL,
>>          .cmd_per_lun            = UFSHCD_CMD_PER_LUN,
 >
> UFSHCD_CMD_PER_LUN needs to be < 32 as well?

I will make that change although that change should not affect the 
behavior of the UFS driver since the SCSI core limits cmd_per_lun to 
host->can_queue.

Thanks,

Bart.

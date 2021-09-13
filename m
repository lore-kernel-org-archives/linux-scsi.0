Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AE4C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 03:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A2A26108E
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 03:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhIMDS3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 23:18:29 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:38431 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbhIMDS2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 23:18:28 -0400
Received: by mail-pj1-f48.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so5545920pjc.3
        for <linux-scsi@vger.kernel.org>; Sun, 12 Sep 2021 20:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c1ikd4edlpq2QwCDJTRRbeN3HGkVl/2mT+PegDQRok4=;
        b=wu6hJxilz4DomQ6ojxX57GmswRTP8GEF0wwE4mUdVZEqTflk8uooFNhJfHRCf6CE6a
         OUSzDvkLXhp6c7K2eij3qSrE/QbZXvZXqDx0UBF5r4ayaj1uQWPQO3fYPb6ug9nMXQvK
         rM1JfCEwhJKOlPaai6c5VWtIPPN7M6wzrQ3muUJVgq2rzheuXNAOuyTvinL5q55ArJHe
         Lwv1ycJDEN2FfyqRdGBePFB4BOCaBmwwHJMwA9yB/c4eI7AqOHEEoNZ0FCm03Q+7bIC6
         OukLBDkMVV/tvBTRllKVzoo5U63kEQrjqbKAMcwqas9IPS+ZoufhjNMiJMx6IHp98ahQ
         6+7g==
X-Gm-Message-State: AOAM531OJn/gd5S1j4td0eHGVKNa4U5VNQTnqZKZykPArfzF54FLHJUJ
        hu/M7VUyOYB/faVkB3DwHok=
X-Google-Smtp-Source: ABdhPJzsCuDe37pEPhkbP0CC764mij9sIFAfOmqYGw5HZ7bDFOURHmaeywr5SxJofN0pis/wDOaLXg==
X-Received: by 2002:a17:90a:c58b:: with SMTP id l11mr10339252pjt.134.1631503033438;
        Sun, 12 Sep 2021 20:17:13 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:559e:5ce1:19a:4ed6? ([2601:647:4000:d7:559e:5ce1:19a:4ed6])
        by smtp.gmail.com with UTF8SMTPSA id fr17sm4823221pjb.17.2021.09.12.20.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 20:17:12 -0700 (PDT)
Message-ID: <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
Date:   Sun, 12 Sep 2021 20:17:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
 <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
 <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/21 09:47, Adrian Hunter wrote:
> On 8/09/21 1:36 am, Bart Van Assche wrote:
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2707,6 +2707,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>>           }
>>           fallthrough;
>>       case UFSHCD_STATE_RESET:
>> +        /*
>> +         * The SCSI error handler only starts after all pending commands
>> +         * have failed or timed out. Complete commands with
>> +         * DID_IMM_RETRY to allow the error handler to start
>> +         * if it has been scheduled.
>> +         */
>> +        set_host_byte(cmd, DID_IMM_RETRY);
>> +        cmd->scsi_done(cmd);
> 
> Setting non-zero return value, in this case "err = SCSI_MLQUEUE_HOST_BUSY"
> will anyway cause scsi_dec_host_busy(), so does this make any difference?

The return value should be changed into 0 since returning 
SCSI_MLQUEUE_HOST_BUSY is only allowed if cmd->scsi_done(cmd) has not 
yet been called.

I expect that setting the host byte to DID_IMM_RETRY and calling 
scsi_done will make a difference, otherwise I wouldn't have suggested 
this. As explained in my previous email doing that triggers the SCSI 
command completion and resubmission paths. Resubmission only happens if 
the SCSI error handler has not yet been scheduled. The SCSI error 
handler is scheduled after for all pending commands scsi_done() has been 
called or a timeout occurred. In other words, setting the host byte to 
DID_IMM_RETRY and calling scsi_done() makes it possible for the error 
handler to be scheduled, something that won't happen if 
ufshcd_queuecommand() systematically returns SCSI_MLQUEUE_HOST_BUSY. In 
the latter case the block layer timer is reset over and over again. See 
also the blk_mq_start_request() in scsi_queue_rq(). One could wonder 
whether this is really what the SCSI core should do if a SCSI LLD keeps 
returning the SCSI_MLQUEUE_HOST_BUSY status code ...

Bart.

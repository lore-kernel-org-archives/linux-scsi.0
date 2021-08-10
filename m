Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B36C4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 16:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF9A610A3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 16:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhHJQSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 12:18:31 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:33410 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbhHJQQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 12:16:49 -0400
Received: by mail-pj1-f54.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so2349209pje.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2021 09:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lQiVVZVqexvoY5IZCEeQzbOGBB0DNfeA0UNCE7uXAWw=;
        b=TlYgBak2QqrZRdlg8Vo8Z+gW1qMkBI/8mWtgP/bZ/Seqd2hy4nHd6pgFqgH0EarDoV
         I+202/zWFpzZ3E0jMX33zKoQB0kjQ/mrskNIRJC0V7dd4+brTf/zFRLrcfvjO7ln6PJ5
         j5ooU5GUJ3XuULcnCSlvVyU8N10CwUcfEvy4epCR4pFE8SALR+y+IzUDPpij/f2aaEjQ
         T/Vv8u20i+EzdVdRye2l7Tl57Sxw2Sc6o+lhKj4Kdyy2s+TCzH3iLTt6B2GelhagFFcJ
         4p+wXXI1Xi6ayju0ItNXto6+y0THh6bPAbugChnMEggfkAeSsWOAOXrUR/hbtPUcEYk5
         1few==
X-Gm-Message-State: AOAM5328OStc2QYSTzYJG9WdgHtP2/u5nmXANAPPom85e6Y2fd7SfWoc
        9xnAI9njYROE/s3FP4ZccDU=
X-Google-Smtp-Source: ABdhPJwBRF6eofWeXvbchESsiETEYdAxknD1NiobydqKq3Wc3Lm9A0bU6j5Daeslgcplbd6YTXSe8g==
X-Received: by 2002:a62:7d84:0:b029:3b8:49bb:4c3f with SMTP id y126-20020a627d840000b02903b849bb4c3fmr24231405pfc.49.1628612186738;
        Tue, 10 Aug 2021 09:16:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:c4:6dc5:1d3:61fa])
        by smtp.gmail.com with ESMTPSA id 143sm19909461pfx.1.2021.08.10.09.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 09:16:26 -0700 (PDT)
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
 <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
Date:   Tue, 10 Aug 2021 09:16:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/21 11:25 PM, Hannes Reinecke wrote:
> On 8/10/21 1:03 AM, Bart Van Assche wrote:
>> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
>> instead. This patch does not change any functionality.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/advansys.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
>> index f3377e2ef5fb..ffb391967573 100644
>> --- a/drivers/scsi/advansys.c
>> +++ b/drivers/scsi/advansys.c
>> @@ -7423,7 +7423,7 @@ static int asc_build_req(struct asc_board 
>> *boardp, struct scsi_cmnd *scp,
>>        * Set the srb_tag to the command tag + 1, as
>>        * srb_tag '0' is used internally by the chip.
>>        */
>> -    srb_tag = scp->request->tag + 1;
>> +    srb_tag = scsi_cmd_to_rq(scp)->tag + 1;
>>       asc_scsi_q->q2.srb_tag = srb_tag;
>>       /*
>> @@ -7637,7 +7637,7 @@ static int
>>   adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>>             adv_req_t **adv_reqpp)
>>   {
>> -    u32 srb_tag = scp->request->tag;
>> +    u32 srb_tag = scsi_cmd_to_rq(scp)->tag;
>>       adv_req_t *reqp;
>>       ADV_SCSI_REQ_Q *scsiqp;
>>       int ret;
>>
> Cf the previous patch; we really should introduce a helper to get the 
> tag from a SCSI command.

Hi Hannes,

Is this something that you plan to work on or do you perhaps expect me 
to introduce such a helper?

Thanks,

Bart.

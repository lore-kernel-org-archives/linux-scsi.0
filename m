Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0D3C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 16:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F7260FA0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 16:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhITQaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:30:03 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46765 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbhITQaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 12:30:03 -0400
Received: by mail-pf1-f175.google.com with SMTP id 203so8878885pfy.13
        for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2021 09:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQSnoR5n1Tc0MWGmZrzsZpf1vMLJzLUdexYBEO+FVmM=;
        b=l4FgdqDZ8SKiuUNSeu6V6Z+akZvl2/bPTn5RN6zfjaPLhwTLSV3uD1hN2INX4jYERM
         l2da3ZJcM8oMTNsQOZbBISk0d9eTp4h/2sL5QNFkz0JnzllPGrFNS0RTmIRZ5Y8dedTp
         hJSsYm7RUicnKh4dZeXcv1hSGorCp8v/AC5r8WOrQK6HxQzPSt7GNCBVIpJXGejL5ZWu
         oLRUdJ6zXsD4OC/mYbOJOotq3rpFOzakLqirZJ/QVuKpHAjaE1GDtzi2EPFdZK5E1kgu
         inK3gR+JvR8yumZhsHuNu4l15CMet4DKiG8CvBIGPkjvmi2Z/EHfqT/olmPFNETLYTc3
         eaLw==
X-Gm-Message-State: AOAM531qZZCEA0jfVay2DggiI8N0Cixz0dOuoKLCvSLjva/ssF2+EX8V
        2dOenQrRnb9Bl71PIz45PUk=
X-Google-Smtp-Source: ABdhPJxpOHRYLqteN+ijGl4PGKcKOdMdNDue0zM21NY6Xp5LyKaD3dh8HNXtcZ3q3p62He83LjOThQ==
X-Received: by 2002:a65:428b:: with SMTP id j11mr23977863pgp.301.1632155315860;
        Mon, 20 Sep 2021 09:28:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6e2a:d64:7d9d:bd4a])
        by smtp.gmail.com with ESMTPSA id b129sm13227539pfg.157.2021.09.20.09.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 09:28:34 -0700 (PDT)
Subject: Re: [PATCH 02/84] scsi: core: Rename scsi_mq_done() into scsi_done()
 and export it
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-3-bvanassche@acm.org>
 <ee1a1197-1fd1-e9d9-6b45-79108d56830b@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <36171806-8c85-654d-1f7d-3d19fc7227c9@acm.org>
Date:   Mon, 20 Sep 2021 09:28:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ee1a1197-1fd1-e9d9-6b45-79108d56830b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/21 2:42 AM, John Garry wrote:
> On 18/09/2021 01:04, Bart Van Assche wrote:
>> @@ -1692,7 +1693,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>       scsi_set_resid(cmd, 0);
>>       memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>> -    cmd->scsi_done = scsi_mq_done;
>> +    cmd->scsi_done = scsi_done;
> 
> I have gone to the end of the series, and we still set scsi_cmnd.scsi_done. So some drivers still rely on it. I thought that the idea was that we don't need this callback pointer any longer.

It seems like the email service I used to send out the patches (gmail)
dropped patches 79/84..84/84. The entire patch series is available here:
https://github.com/bvanassche/linux/tree/scsi-remove-done-callback

Patch 84/84 includes the following change:

  @@ -1693,7 +1693,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,

  	scsi_set_resid(cmd, 0);
  	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->scsi_done = scsi_done;

  	blk_mq_start_request(req);
  	reason = scsi_dispatch_cmd(cmd);

> As an aside, this is the current declaration of scsi_cmnd.scsi_done:
> 
> /* Low-level done function - can be used by low-level driver to point
> *        to completion function.  Not used by mid/upper level code. */
>      void (*scsi_done) (struct scsi_cmnd *);
> 
> That does not sound right, as scsi_done is set by the mid-layer.

"Not used" probably should have been "not called". Anyway, patch 84/84
removes that function pointer and also the comment above that function
pointer.

Thanks,

Bart.

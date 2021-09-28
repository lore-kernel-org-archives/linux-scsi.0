Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1361AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E085761246
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbhI1SxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:53:15 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:46885 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhI1SxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:53:14 -0400
Received: by mail-pj1-f52.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so3558830pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 11:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siNfurnTNAlCwvRcSVK6NzBOEYgu5Pe/Sy06w8LVtdw=;
        b=nO5La+2Q6nVH45V8yVv/urTmzgKBhxKjuP3ICv7Hq9WA68a79wX+9YxoAc3eyTTNkP
         7fwPxNJWJ6KcWl1NckHdaZkPjLvMhUCj3O3o0qPUIsvIESTxaCVUny+zE4m8VdgOGpQW
         tOI2/ifjWCZ34upVeoVSjFK3YcOLDkGFZHAPiuQNI2PRnEjRy+mD+EvG+UJ7ZRzb3Fzj
         Hf1OFVg5Va+Pj8FG+p5pmDeujLT62vt58EXNa8y8ZP0B6eu/IoN06yC81Ly50L+nuq0U
         YfTvebfTSFSWeLCk3edSf39AhXEsn+PRKrBWbl4+kDRnfhV1DTcyAhHMXjFRaE4w2tYm
         FjwA==
X-Gm-Message-State: AOAM532JmhaJOpX+oH2iXfKRPypUI/jq58wmRvZdu5qstljRisXfqS6U
        lLGDpKjRUqMje+Ck2joaIAha9AFdgso=
X-Google-Smtp-Source: ABdhPJykRaeK6KzLexfNfb/9vGjl3XnjGxdASwqrSDbZU2zLm+oalsbmdwPRs6mIrtFkhrp+Lmy9Qw==
X-Received: by 2002:a17:902:c1c5:b0:13e:2e1e:aaa4 with SMTP id c5-20020a170902c1c500b0013e2e1eaaa4mr6467574plc.32.1632855094250;
        Tue, 28 Sep 2021 11:51:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3e98:6842:383d:b5b2])
        by smtp.gmail.com with ESMTPSA id k3sm3280177pjg.43.2021.09.28.11.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 11:51:33 -0700 (PDT)
Subject: Re: [PATCH 01/84] scsi: core: Use a member variable to track the SCSI
 command submitter
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-2-bvanassche@acm.org>
 <YVNIsDkFIL1xV8o9@t480-pf1aa2c2.linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7c0ac137-169c-08d7-1e55-3ea5174186c1@acm.org>
Date:   Tue, 28 Sep 2021 11:51:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YVNIsDkFIL1xV8o9@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 9:54 AM, Benjamin Block wrote:
> On Fri, Sep 17, 2021 at 05:04:44PM -0700, Bart Van Assche wrote:
>> +enum scsi_cmnd_submitter {
>> +	BLOCK_LAYER = 0,
>> +	SCSI_ERROR_HANDLER = 1,
>> +	SCSI_RESET_IOCTL = 2,
>> +} __packed;
>> +
> 
> Might be prudent to not make them as generic, especially `BLOCK_LAYER`
> might easily clash without namespace. `SUBMITTED_BY_...`?

Hi Benjamin,

I will insert the prefix SUBMITTED_BY_.

> 
>>   struct scsi_cmnd {
>>   	struct scsi_request req;
>>   	struct scsi_device *device;
>> @@ -90,6 +96,7 @@ struct scsi_cmnd {
>>   	unsigned char prot_op;
>>   	unsigned char prot_type;
>>   	unsigned char prot_flags;
>> +	enum scsi_cmnd_submitter submitter;
> 
> Do you think it'd make much of a difference, if you initialized this in
> scsi_init_command(), or somewhere around there, explicitly to
> `BLOCK_LAYER`? Makes it easier to maintain, and to not forget, that it
> needs to be done, if the memset() to 0 ever changes... after the
> memset() the memory should be hot.
> 
> I just had to search a bit where this gets set to 0, as I didn't
> remember exactly where it was.

Performance-wise this probably won't make much difference. I'd like to add
that assignment in scsi_queue_rq() where the "cmd->scsi_done = scsi_done"
code was. That should be the approach that has the lowest probability of
introducing functional changes in the SCSI core.

Thanks,

Bart.

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3795FC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 03:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0817961029
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 03:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhIYDkT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 23:40:19 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:38483 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhIYDkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 23:40:19 -0400
Received: by mail-pj1-f46.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so11078561pjc.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 20:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A4Si9HU0kr80JnSxGN1ZCbKADjCQ0SrSZSvjCswyRgs=;
        b=ZEr+cRmi8V56eJRupOlsRFtN8iiO0tqyH+xiKdQMrwqg7h+jMPCAVGRMSm2dEBtjGd
         HczEkvOoGMuFXGOmKl/Is+8yZOJGkYdvqbufX/WuebALyVhRSw3Tlej4/XQyWvU+KCH7
         FYdqOqi8yBPDt7I+37EK2eg/5cDS3YQgZId8ZraKyr0f5LCfpwL2AsbQKHai3H1hTjrh
         DBb0lyU7N0bgDNg18NdBfdj65jXPhaxZDKgAQDUQvdAJECT0M/pOdfl+oNZr3FKVLcF8
         5cgSpAJwIZ9iTPv6yhhu7AHgOijSUdqJubTXrMSM/LpLYrisHIUEYxaz7kFpuwmj+6Zt
         wOSA==
X-Gm-Message-State: AOAM532G5Qf1m/NcVah1clODN6sfDWXox093Fb8yTL4EA426POrZDnUD
        RnswLNRZdIBr9qxhHNmmkCc=
X-Google-Smtp-Source: ABdhPJyiAFV1S7jyE2h9ujqgkz435GTFWx+gqgvUbrEQq9myoFG4eKBFdc80jb47DHFeGmm4j25zGQ==
X-Received: by 2002:a17:90b:8ca:: with SMTP id ds10mr6240901pjb.68.1632541124699;
        Fri, 24 Sep 2021 20:38:44 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:92db:e1f6:6924:bfce? ([2601:647:4000:d7:92db:e1f6:6924:bfce])
        by smtp.gmail.com with ESMTPSA id g22sm10032786pfb.191.2021.09.24.20.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 20:38:44 -0700 (PDT)
Message-ID: <4bc6bf9c-a6bd-13c7-988b-9756bb5dd480@acm.org>
Date:   Fri, 24 Sep 2021 20:38:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 01/84] scsi: core: Use a member variable to track the SCSI
 command submitter
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-2-bvanassche@acm.org>
 <YU2cN5H7CqVFOzTQ@t480-pf1aa2c2.linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YU2cN5H7CqVFOzTQ@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/21 02:36, Benjamin Block wrote:
> On Fri, Sep 17, 2021 at 05:04:44PM -0700, Bart Van Assche wrote:
>> Conditional statements are faster than indirect calls. Use a member variable
>> to track the SCSI command submitter such that later patches can call
>> scsi_done(scmd) instead of scmd->scsi_done(scmd).
>>
>> The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
>> context to the SCSI error handler and that it does not restore the
>> submission context to the SCSI core is retained.
>>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/scsi_error.c | 18 +++++++-----------
>>   drivers/scsi/scsi_lib.c   |  9 +++++++++
>>   drivers/scsi/scsi_priv.h  |  1 +
>>   include/scsi/scsi_cmnd.h  |  7 +++++++
>>   4 files changed, 24 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 572673873ddf..ba6d748a0246 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1577,6 +1577,15 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>>   
>>   static void scsi_mq_done(struct scsi_cmnd *cmd)
>>   {
>> +	switch (cmd->submitter) {
>> +	case BLOCK_LAYER:
>> +		break;
>> +	case SCSI_ERROR_HANDLER:
>> +		return scsi_eh_done(cmd);
>> +	case SCSI_RESET_IOCTL:
>> +		return;
>> +	}
>> +
> 
> Hmm, I'm confused, you replace one kind of branch with different one. Why
> would that increase IOPS by 5%?
> 
> Maybe its because the new `submitter` field in `struct scsi_cmnd` is now
> on a hot cache line, whereas `*scsi_done` is not?

Hi Benjamin,

To be honest, the 5% improvement is more than I had expected. This is what I
know about indirect function calls vs. branches:
- The target of an indirect branch is predicted by the indirect branch
   predictor. For direct branches the Branch Target Buffer (BTB) is used.
- The performance of indirect calls is negatively affected by security
   mitigations (CONFIG_RETPOLINE) but not the performance of direct branches
   My measurement was run with CONFIG_RETPOLINE off. I expect a larger
   difference with CONFIG_RETPOLINE enabled.

Maybe I triggered inefficient behavior of the indirect branch predictor with
the workload I ran.

Bart.

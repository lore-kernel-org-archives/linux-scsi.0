Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9210C05027
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 16:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjBJQOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 11:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjBJQOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 11:14:31 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B27677B8C
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 08:14:23 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id mi9so5629122pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 08:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OlwwTBl/x5OdbJZFVO9FI5nf53tibmSzVxWMLzVU/14=;
        b=3S47HH9+yvPmAZqBoWZoFDF8oejmzyesqUlpxzCsL2WOpnNbRpE0rdchjEa0PQeym6
         OuL3IXGgz3aJgMhhrFSodz07DaO1UVky6GDTYJF8wsWFTXqigOKl6z2wHvYlWg//S8zp
         OR4kQ9dktAdEE5dRLUwjZGTUSTFmIfygI42JJEP65CwmR5mIDTOUB26KN/8ecsqopA8M
         sJwGh20CGt1YF2FV2oEpfZXl6b9eW8uF32NtmoYEqbNkQvYsqDo7pSSl8DaWdycGKpZO
         fTjtucjl2GT9QKV3LbwHmp+jU73fYFEzDEUVxUVcSjc+VfRVRdVsEjdxcXUmiAI6xZAB
         Iw4A==
X-Gm-Message-State: AO0yUKUZXgnrMVZ6c9HFwlVNSDEBNz3KLI81/Dd2XnQEw5h1iT4a2iEj
        Q4g87ZN/mA/7/EW8eiGA0Nxwy3QOaR8=
X-Google-Smtp-Source: AK7set+reeQfKzneDoImqed3YwIpLJ1FAaKPQeLg1YQJ1RD/2DqGSfhSOEARk0ZQqFsbPR/gljqdYA==
X-Received: by 2002:a17:902:cf48:b0:194:81c9:b8da with SMTP id e8-20020a170902cf4800b0019481c9b8damr13387982plg.3.1676045662851;
        Fri, 10 Feb 2023 08:14:22 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b0019a7d6a9a76sm286930plb.111.2023.02.10.08.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 08:14:22 -0800 (PST)
Message-ID: <b8f0d08a-4086-c4a9-e5a1-e8cae638f403@acm.org>
Date:   Fri, 10 Feb 2023 08:14:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 1/3] scsi: core: Extend struct scsi_exec_args
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230209185328.2762796-1-bvanassche@acm.org>
 <20230209185328.2762796-2-bvanassche@acm.org>
 <8c9fcd15-09d9-337a-d999-3441f74ffce5@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8c9fcd15-09d9-337a-d999-3441f74ffce5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/23 01:40, John Garry wrote:
> On 09/02/2023 18:53, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index abe93ec8b7d0..b7c569a42aa4 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -229,6 +229,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, 
>> const unsigned char *cmd,
>>       scmd->cmd_len = COMMAND_SIZE(cmd[0]);
>>       memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>>       scmd->allowed = retries;
>> +    scmd->flags |= args->scmd_flags;
> 
> nit: we zero the scsi_cmnd payload in scsi_alloc_request() -> 
> scsi_initialize_rq(), so don't really need the bitwise OR. However it 
> may be better to keep for change of scsi_initialize_rq() changing in 
> terms of init.

Hi John,

Thanks for the review.

If scmd->flags would be initialized to a non-zero value in the future 
then it would be non-trivial to remember that the above assignment would 
have to be changed into a logical or. So I'd like to keep the logical or.

>>       req->timeout = timeout;
>>       req->rq_flags |= RQF_QUIET;
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 7e95ec45138f..c7bfb1f5a8e7 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -462,6 +462,7 @@ struct scsi_exec_args {
>>       unsigned int sense_len;        /* sense buffer len */
>>       struct scsi_sense_hdr *sshdr;    /* decoded sense header */
>>       blk_mq_req_flags_t req_flags;    /* BLK_MQ_REQ flags */
>> +    unsigned int scmd_flags;    /* SCMD flags */
> 
> nit: scsi_cmnd.flags is an int, so prob should keep the same type

How about changing the type of scsi_cmnd.flags from 'int' into 'unsigned 
int'? I can't think of any reason to make a flags variable signed 
instead of unsigned.

Thanks,

Bart.


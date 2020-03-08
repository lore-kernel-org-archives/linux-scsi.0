Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E07C10F27
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B4F2073D
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6dQE91b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCHCJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 21:09:04 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41363 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgCHCJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 21:09:04 -0500
Received: by mail-pl1-f194.google.com with SMTP id t14so2541405plr.8;
        Sat, 07 Mar 2020 18:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Du4MsZg/glfLsACkWt4Gh7Tp3tFJWcmPYFYVoz1w/hs=;
        b=B6dQE91bKbKlZhGOPw9vlSlAZyeiGmZasnsILT0swiDP3/Km+t/6dSCpvGIiXeJZg9
         36wWaizaEfXHPQsVq69R0LaUpMbd6bkIPf7pm0zPjZOO+AUbkp6efHmJSRKlqxuLte4l
         GdxB2VxeV4YjCZWibVsJLu71lNNOrLOdo1ee1Qj0nMaW2zAMQwmbNwjQAtNMX3DDZQBE
         +mO3LCczCv+gRcwaX5empU7CB8uNAGauY3MdFjuPEA7YZ8WZLCgRkwBpecWW86cCKpw1
         Niev6KjFAleBOqKZkgNZuwmfCB7unxnNkC8VdByWYoOfhnmAg1yeHGgwXTH90+d1dnA/
         46ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Du4MsZg/glfLsACkWt4Gh7Tp3tFJWcmPYFYVoz1w/hs=;
        b=ORzs4Yk/r5XLncCJCx8NNhnZluKNunxvZgmU92HAp3mQES5aemZ0L5x7YdcoI8ZQYH
         P3lgZaswNNDxszPbq2f0ryf4aOHCciExotSJrWlOSHjAE1kyYbXaW6O+cioMClbS58i2
         Ut93wlYD3pVIAfUqqFJjTvVDT56tvVQCG79WfbDkhHsqHGJMYHqihOAGsvM4DSf/6ayu
         73dtAODmshTtBJcJNtYcL1Y2nZLP1Rt/fAaC9MAk7zQ/lKglNnYqNg7KPO9568Cr7eCb
         +iZDOwh9lNCkBQq27Y1tPD8kczErrfStaaF7YCdp2YRMwklqGW22MkeHVf7dwOl/GrhR
         yGxA==
X-Gm-Message-State: ANhLgQ36D8Qh5AYdh+AuM23LVo4PfUHqBoq4ujD4izrOIvmvcIXIBQ8d
        JDoMZJ8vVCieXSu4ZootCuI=
X-Google-Smtp-Source: ADFU+vsGybtB3VCKVjgGJmwtMpOcn/OsITK4GOT/yeLoDO5tZy1bKq114GxfE5XWtc3AYFGcXLlt5A==
X-Received: by 2002:a17:902:7687:: with SMTP id m7mr9719029pll.136.1583633343358;
        Sat, 07 Mar 2020 18:09:03 -0800 (PST)
Received: from ?IPv6:2405:4800:58f7:4735:1319:cf26:e1d9:fc7c? ([2405:4800:58f7:4735:1319:cf26:e1d9:fc7c])
        by smtp.gmail.com with ESMTPSA id b2sm13510065pjc.40.2020.03.07.18.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 18:09:02 -0800 (PST)
Cc:     tranmanphong@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH] scsi: aacraid: fix -Wcast-function-type
To:     Bart Van Assche <bvanassche@acm.org>, aacraid@microsemi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20200307132103.4687-1-tranmanphong@gmail.com>
 <26713759-34ff-5c47-95bf-83723e8eac39@acm.org>
From:   Phong Tran <tranmanphong@gmail.com>
Message-ID: <6e78c52e-c02b-dea2-c5a5-7acf4c9b9fb1@gmail.com>
Date:   Sun, 8 Mar 2020 09:08:58 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <26713759-34ff-5c47-95bf-83723e8eac39@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 3/7/20 11:35 PM, Bart Van Assche wrote:
> On 2020-03-07 05:21, Phong Tran wrote:
>> correct usage prototype of callback scsi_cmnd.scsi_done()
>> Report by: https://github.com/KSPP/linux/issues/20
>>
>> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
>> ---
>>   drivers/scsi/aacraid/aachba.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
>> index 33dbc051bff9..92a1058df3f5 100644
>> --- a/drivers/scsi/aacraid/aachba.c
>> +++ b/drivers/scsi/aacraid/aachba.c
>> @@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
>>   	return 0;
>>   }
>>   
>> +static void  aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
>> +{
>> +	aac_probe_container_callback1(scsi_cmnd);
>> +}
>> +
>>   int aac_probe_container(struct aac_dev *dev, int cid)
>>   {
>>   	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
>> @@ -810,7 +815,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
>>   		return -ENOMEM;
>>   	}
>>   	scsicmd->list.next = NULL;
>> -	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))aac_probe_container_callback1;
>> +	scsicmd->scsi_done = (void (*)(struct scsi_cmnd *))aac_probe_container_scsi_done;
>>   
>>   	scsicmd->device = scsidev;
>>   	scsidev->sdev_state = 0;
>>
> 
> Since the above cast is not necessary, please remove it.
> 

yes, sent v2.

Regards,

Phong.

> Thanks,
> 
> Bart.
> 

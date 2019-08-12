Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26715C31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 23:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E923D20684
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 23:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfHLXWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 19:22:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33812 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHLXWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 19:22:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so44022175pgc.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2019 16:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1A5XMhHLUL0DKY/WcB4K8SgpSGe3JkrWJwWDpOrUkyc=;
        b=rQztwPH70kzE/w3RcDNKPwLugLNkA4kBbo2J4YTIFneA9KQCStxI9Otk55o2A8FcKj
         AJsIkmJz5+l+bdZnR9tg3gUzEHtQi9hYWltASvgvqZq2/zfhZyOjAjkzbNAA5bRhP9ft
         lhBJe/TImGrqK+Zf7PkxHFtcZmApksfxAYiEMDN886lXg4mf97km6gw2kLD3ZMXBiMrV
         kk00XT8lbIYILHoqeJ7FsIofbwMxYoTiEDvgTRNldUPGEDSzxsUxf/n0kj+rCFRpdOQn
         hrHL/bOcKe+eGb2rmBHx6DMFzMBtJk7nvetvI+sfnM+oHCQYbewNeXob45IW0YS/OiBU
         2E/g==
X-Gm-Message-State: APjAAAUNIMZVrozUs4urcFxtTELHUq9uTdl97PLIhZyNIb9Lk9WckcS4
        XA0CwZZ15ajt3rWO6cUIunc=
X-Google-Smtp-Source: APXvYqwVGz8nopRVyDMX5SkXMQYj5ZzZ9Z/Jz31k2jHEemSodKqueF2C+ExC+IJbwbESAFhO6tGNQA==
X-Received: by 2002:a63:4a0d:: with SMTP id x13mr31400601pga.75.1565652131690;
        Mon, 12 Aug 2019 16:22:11 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 14sm105558893pfy.40.2019.08.12.16.22.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 16:22:10 -0700 (PDT)
Subject: Re: [PATCH v2 46/58] qla2xxx: Make qlt_handle_abts_completion() more
 robust
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>
References: <20190809030219.11296-1-bvanassche@acm.org>
 <20190809030219.11296-47-bvanassche@acm.org>
 <20190812205222.qmse275ofl3g52bk@SPB-NB-133.local>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4808483f-4d35-ab41-d642-547f690ce3bd@acm.org>
Date:   Mon, 12 Aug 2019 16:22:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812205222.qmse275ofl3g52bk@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/19 1:52 PM, Roman Bolshakov wrote:
> On Thu, Aug 08, 2019 at 08:02:07PM -0700, Bart Van Assche wrote:
>> Avoid that this function crashes if mcmd == NULL.
>>
>> Cc: Himanshu Madhani <hmadhani@marvell.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/qla2xxx/qla_target.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
>> index d25c3fa43601..cc0c99b5f3fb 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -5731,7 +5731,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
>>   			    entry->error_subcode2);
>>   			ha->tgt.tgt_ops->free_mcmd(mcmd);
>>   		}
>> -	} else {
>> +	} else if (mcmd) {
>>   		ha->tgt.tgt_ops->free_mcmd(mcmd);
>>   	}
>>   }
>> -- 
>> 2.22.0
>>
> 
> Thanks for working on the fix, the crash can be observed sometimes on
> target shutdown.
> 
> I've been inspecting the piece of code multiple times and still don't
> understand if we get mcmd == NULL only when ABTS completes successfully
> or there is ABTS failure together with inability to find mcmd in the
> request queue? In that case, there're two more paths that could crash.
> 
> And the second question is whether the NULL received from
> qlt_ctio_to_cmd is a sign of another sporadic issue somewhere else in
> the driver?

Hi Roman,

If I interpret qlt_handle_abts_completion() mcmd can only be NULL at 
line 5734 if h == QLA_TGT_SKIP_HANDLE. I'm not sure what causes the 
firmware to report that handle value upon ABTS completion.

Bart.

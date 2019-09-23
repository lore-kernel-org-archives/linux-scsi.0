Return-Path: <SRS0=msWv=XS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F68BC32755
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 13:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69EEC20882
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 13:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407567AbfIWNYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 09:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405137AbfIWNYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Sep 2019 09:24:14 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 517A8C04D293
        for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2019 13:24:13 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id m25so10053650pfa.23
        for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2019 06:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3PwMn2YEjlUJRkfotbTy+c3Hn5hUOXwAI3NJinXbsks=;
        b=a+xk67wUgA+jZkKJc7Q1XZrAaNrYfiWJ+t1JF3nyBzXIlPwiEuVt2SGM02lDnrwU1O
         Iz19NgSeWWqJfaQoZhLEsg+SqChtTgL/3X9tSb6CZnb2zfDYqSvZsKiosTR2kFW40nmI
         KdgZtWlhsqt9JD4Cbxh1pPN9+8BNkaRJAJx5UYH8l/jiMTgJyO+8x23chunNDnzUKBGP
         3mEAjUjexBzeYbQNxUT17GigYMlBOX76gpWfAc+IGHqJEc9oMjnZ6DtKoolQg448YwQ0
         PvZI0qsWREpD3jyhD2G3pE7iI/hyRvnXQgn6UFDL0kOjKBarMy964UDya7w7+2yEFqJ5
         U9Kg==
X-Gm-Message-State: APjAAAWugk3TVsqUN3cqWZYL18s/PSlVDxEX5WbhKmLIzddrTbejE7gQ
        zKMAAAhyjxkHzfZJ3oiIl4+TImle1RqCanXE04bWwTqqczl9blqDn9cZksXHfhf9/4JFCldL38Y
        5NAARZ8JJb60PHo1J1HZwNw==
X-Received: by 2002:aa7:9aaa:: with SMTP id x10mr32448752pfi.173.1569245052736;
        Mon, 23 Sep 2019 06:24:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8ly0CDUEalS2u9sGaTJiVzvhnyzUXej5FU8McrQPI5IULCpDndZo5HMmjYfGs1EFg/la17w==
X-Received: by 2002:aa7:9aaa:: with SMTP id x10mr32448727pfi.173.1569245052477;
        Mon, 23 Sep 2019 06:24:12 -0700 (PDT)
Received: from [10.76.0.39] ([125.16.200.50])
        by smtp.gmail.com with ESMTPSA id g202sm15824616pfb.155.2019.09.23.06.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 06:24:11 -0700 (PDT)
Reply-To: mgandhi@redhat.com
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
To:     Laurence Oberman <loberman@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20190923060122.GA9603@machine1>
 <8e9c537b7eaabd611968d22ec31f7cfb90e72efe.camel@redhat.com>
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
Organization: Red Hat
Message-ID: <a1fadc48-b6b2-784a-d1ff-3d4dbe6df7eb@redhat.com>
Date:   Mon, 23 Sep 2019 18:54:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8e9c537b7eaabd611968d22ec31f7cfb90e72efe.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/19 6:32 PM, Laurence Oberman wrote:
> On Mon, 2019-09-23 at 11:31 +0530, Milan P. Gandhi wrote:
>> Couple of users had requested to print the SCSI command age along 
>> with command failure errors. This is a small change, but allows 
>> users to get more important information about the command that was 
>> failed, it would help the users in debugging the command failures:
>>
>> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
>> ---
>> diff --git a/drivers/scsi/scsi_logging.c
>> b/drivers/scsi/scsi_logging.c
>> index ecc5918e372a..ca2182bc53c6 100644
>> --- a/drivers/scsi/scsi_logging.c
>> +++ b/drivers/scsi/scsi_logging.c
>> @@ -437,6 +437,7 @@ void scsi_print_result(const struct scsi_cmnd
>> *cmd, const char *msg,
>>  	const char *mlret_string = scsi_mlreturn_string(disposition);
>>  	const char *hb_string = scsi_hostbyte_string(cmd->result);
>>  	const char *db_string = scsi_driverbyte_string(cmd->result);
>> +	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
>>  
>>  	logbuf = scsi_log_reserve_buffer(&logbuf_len);
>>  	if (!logbuf)
>> @@ -478,10 +479,15 @@ void scsi_print_result(const struct scsi_cmnd
>> *cmd, const char *msg,
>>  
>>  	if (db_string)
>>  		off += scnprintf(logbuf + off, logbuf_len - off,
>> -				 "driverbyte=%s", db_string);
>> +				 "driverbyte=%s ", db_string);
>>  	else
>>  		off += scnprintf(logbuf + off, logbuf_len - off,
>> -				 "driverbyte=0x%02x", driver_byte(cmd-
>>> result));
>> +				 "driverbyte=0x%02x ",
>> +				 driver_byte(cmd->result));
>> +
>> +	off += scnprintf(logbuf + off, logbuf_len - off,
>> +			 "cmd-age=%lus", cmd_age);
>> +
>>  out_printk:
>>  	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
>>  	scsi_log_release_buffer(logbuf);
>>
> 
> This looks to be a useful debug addition to me, and the code looks
> correct.
> I believe this has also been tested by Milan in our lab.
> 
> Reviewed-by: Laurence Oberman <loberman@redhat.com> 
> 
Yes, the patch was tested locally using scsi_debug as well as in real 
storage issues caused by bad disks in customer environment.

Thanks,
Milan.

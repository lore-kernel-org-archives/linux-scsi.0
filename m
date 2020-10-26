Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F3BC4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 17:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870C22225C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 17:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tNzgcegt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780073AbgJZReB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 13:34:01 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38517 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780048AbgJZReB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 13:34:01 -0400
Received: by mail-ed1-f65.google.com with SMTP id bc23so10283368edb.5;
        Mon, 26 Oct 2020 10:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f2dNymh7E0GHijfuDgIGRacM0bd+z9HBydO5b0EstHg=;
        b=tNzgcegt+lBXWeNeyObc8UURknxITQbdYcb7umJtzynw8A5uoHMY6IGQdFVrTACrMR
         +GHdr6PgkRXPn+q69e31+LLeCrfnGuB7Nw1KvfvIkbM8uWpR9mGU7b/xZ2G0i2Xu3MyF
         pT6oqa06XA+hvgiljmKIP77l4yp1+3gSO4MJGRR56A1dAU7LBEvr7NRVCSZZYKFZUPTc
         DZAZVqifpYtNboH9uHrQGemsg2NGMZOVWTOLxpoBwdg6PqItrkkUNvLbMbsJYvRoGljc
         0Gxi7B8uijl3vYuArkpJnvXl/Ah2HIQb2FOX8CLGB/yN38gWgmMovjYs1yHDlk6RTd7H
         NwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f2dNymh7E0GHijfuDgIGRacM0bd+z9HBydO5b0EstHg=;
        b=Nj0gtqkEuz60Ufy8P6ctNNd4fXzT22x2DInUyt2BBZIqjtWkUqFC9XpfWG3kVumx2s
         gMoiCwjpctpSpv7yPyjvad3rGcEVsptkbaIZE+RTeVe7jwjQB6aQT+9VI6SJR9K5YIZo
         bHzim0SHLUD+cVvX5cgfKlQ10dOs4dHbcxj09fCZdtqxi0h1KMSQrJD43Rzl9baAzxxT
         335YPSMhsAKm3JxzPxUgfdimZC8mHmT0kRWgZrSa2kseq4rt9SrO5z9M8Bf9h5zcwMJX
         CAfv+CP09XKYJfJU3yu5kkU7MhAVT72an9f0J+4F4M9spOQ1/yCN4nIiBi4kTO9xB8U+
         a56Q==
X-Gm-Message-State: AOAM530RembncAKK8O4li5uaM4ET/qronsmm/pcFlyg5nOoIfCg67uyZ
        7DhlgDHMUvnsttvGHcITKmrwdE/U2j6qGA==
X-Google-Smtp-Source: ABdhPJy+HKpVfamiWvsdbFte1QkzY7ApLFhO7nU1JAg9rTL8dsIHcpRTAGq6gQk4pkWSk8hsTRGX6A==
X-Received: by 2002:aa7:c792:: with SMTP id n18mr16854816eds.209.1603733639412;
        Mon, 26 Oct 2020 10:33:59 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc08ad4.dynamic.kabel-deutschland.de. [188.192.138.212])
        by smtp.gmail.com with ESMTPSA id g9sm5544700edv.81.2020.10.26.10.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 10:33:58 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
To:     Bart Van Assche <bvanassche@acm.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <6cc811a4-65ca-529a-4578-c0eba0bdd102@gmail.com>
Date:   Mon, 26 Oct 2020 18:33:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 25.10.20 um 02:25 schrieb Bart Van Assche:
> On 10/24/20 5:13 AM, Roman Bolshakov wrote:
>> iSCSI doesn't specify a specific code but mentions a possibility of CHECK
>> CONDITION for residuals (11.4.5.1.  Field Semantics):
>>
>>    Targets may set the residual count, and initiators may use it when the
>>    response code is Command Completed at Target (even if the status
>>    returned is not GOOD).
> 
> My interpretation of the above text is that it neither allows nor
> requires to change the status GOOD into something else if there is a
> residue.
> 
>>> Additionally, what benefits does it provide to report a CHECK CONDITION
>>> upon residual overflow?
>>
>> Typical use case for CHECK CONDITION in case of Underflow/Overflow is
>> extra robustness against buggy initiators [1][2]. Failing both READ and
>> WRITE is the most solid approach in that sense [3][4][5] as it prevents
>> data corruption at all costs.
>>
>> Suppose an initiator wants to WRITE 8 LBA. For 512-byte formatted LUN,
>> 8 LBAs need a buffer of 4K bytes. For 4096-byte formatted LUN the
>> command would need 32K data buffer.
>>
>> An Overflow happens if initiator treats 4Kn device like 512n one but
>> provides a buffer of 4K. i.e. to complete the WRITE target needs to
>> consume 28K more data, otherwise only 1 LBA would be written and the
>> rest 7 LBAs would have indeterminate content.
>>
>> An Underflow happens if initiator confuses 512n device with 4Kn one and
>> provides a buffer of 32K, i.e. target doesn't utilize all buffer for the
>> command.
> 
> Thanks for the additional background information, this really helps. How
> about only rejecting SCSI commands for which the data buffer size is not
> a multiple of the block size? I'm concerned that flagging all SCSI
> commands that have a residue as invalid will break SCSI tape software.

AFAICS, there is no risk to break tape handling. target_cmd_size_check() is mainly used by sbc_parse_cdb(),
while passthrough_parse_cdb() optionally calls it for PERSISTENT_RESERVFE_IN/_OUT and RESERVE(_10)/RELEASE(_10) only.

sbc_parse_cdb is not usable for tape devices anyway, since CDB 'length' field in READ/WRITE for SSC devices needs special processing.
Depending on current state of the device, length 1 can have the meaning 1 byte or 1 times the optionally set fixed block size.
So the only way to set up a tape target LUN is to use tcmu or pscsi.

> 
> Thanks,
> 
> Bart.
> 

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D945C64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 16:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A066E206DF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 16:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hpo2FyIC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgK3QSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 11:18:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728696AbgK3QSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 11:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606753025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=buWVhHxgASs9AgCyEpqieZvu3CWe/BCx2B4/1qlbtuE=;
        b=Hpo2FyICUW08KIRYI8pBtzmESVgPpp4arGIejRQ57sMs3VLbtaFjZYwT7TsFo+k1mv1a58
        AVAkwEmQxxqPPb0Sv0lcN7NMv1FF938L63b7fTE2EqKmWfbBq6m4WUVHZgZ/AO0/YUpecV
        Accr6SHP4gmKahx0uY7ZZsglbB1RkPE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-DR46AJB-NvORkCn5i47OhQ-1; Mon, 30 Nov 2020 11:17:02 -0500
X-MC-Unique: DR46AJB-NvORkCn5i47OhQ-1
Received: by mail-qv1-f69.google.com with SMTP id v8so7849687qvq.12
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 08:17:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=buWVhHxgASs9AgCyEpqieZvu3CWe/BCx2B4/1qlbtuE=;
        b=o7Kq2KZslWZHgIeCpGfak5/mh9G75va0V9o0X9oRIHkYdruaw+HeudjpwsWvUDPM/Z
         0EAw8/y42aSbn+BaYodblBOng1gsyEd3GCs0szVI/34xYhEKiTVeEV9eeVXk8/zxhMi7
         ilUdwXSTG56rvgVCA3CRtRwGkqbXa3MeP7i5RF/jbOlrJW/o1phf+wzVXjZAYXDkiqCf
         InUNYUC5pG5gp9xsBtSDVg7hBek/ynhOClvGmmwjWwfbMQSqTWjJvcnhm3MQZDG2OX5k
         8QYPgO5MB2ccMIo5eI6jFm9NmA+fEi+mbI0+EH7tyT46pp1eSNCJ/W3Agronxu27pJN1
         Xlvw==
X-Gm-Message-State: AOAM533KXXzcffyDbhXq/hX1jANPIBMwL0hfKtd4BxvEKXLYBKGq5Y5d
        pCkvDVFeUFP0lnqO1eSSqGxi/G2gA5wiBpx4U7tFjzLWWXrIraOKV2zVhqIr1kGQjBGbErisagA
        rndmSOOUFj91ZGLjsSf7jfw==
X-Received: by 2002:ac8:5304:: with SMTP id t4mr22843560qtn.77.1606753021967;
        Mon, 30 Nov 2020 08:17:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyj8FaPNbr09u+LpUyDT1y+WdRpGt8gF1fOEVd+1u8AkOkqUaiO5Ly2PC+Sp/MuoZclSgNO8Q==
X-Received: by 2002:ac8:5304:: with SMTP id t4mr22843535qtn.77.1606753021809;
        Mon, 30 Nov 2020 08:17:01 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id k15sm15769338qke.75.2020.11.30.08.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 08:17:01 -0800 (PST)
Subject: Re: [PATCH] scsi: qla2xxx: remove trailing semicolon in macro
 definition
To:     Daniel Wagner <dwagner@suse.de>
Cc:     njavali@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201127182741.2801597-1-trix@redhat.com>
 <20201130091753.4wyrzlbrqszdzy6s@beryllium.lan>
From:   Tom Rix <trix@redhat.com>
Message-ID: <3baa674f-ce34-34a9-26ec-1d3e0e2ebdcd@redhat.com>
Date:   Mon, 30 Nov 2020 08:16:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201130091753.4wyrzlbrqszdzy6s@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 11/30/20 1:17 AM, Daniel Wagner wrote:
> Hi Tom,
>
> On Fri, Nov 27, 2020 at 10:27:41AM -0800, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> The macro use will already have a semicolon.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
>
>> ---
>>  drivers/scsi/qla2xxx/qla_def.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
>> index ed9b10f8537d..86d249551b2d 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -4970,7 +4970,7 @@ struct secure_flash_update_block_pk {
>>  } while (0)
>>  
>>  #define QLA_QPAIR_MARK_NOT_BUSY(__qpair)		\
>> -	atomic_dec(&__qpair->ref_count);		\
>> +	atomic_dec(&__qpair->ref_count)		\
> Nitpick, please insert an additional tab after the remove so that the
> backlashes align again.

How about removing the last escaped newline and the next empty line ?

Tom

>
> Thanks,
> Daniel
>


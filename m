Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6BDC761A6
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 21:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjCaVEp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 17:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCaVEo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 17:04:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59121D2DD
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 14:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680296636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bUtpTfIhZLUJQRzvjQdCDBe9iqr/rmYVzQ4AMz2vCfE=;
        b=J4uh3W02asn8suAf+SujfVohG5j8CyZCgeaJ6VkTHhV4Ts/EjwuDn7bYwRzGFq50GClFmk
        nhrumIsR1WSpgLhZcPKHAH7gVa6K4zn4JZvzZZrhbxEWO8MxWCFF3bYyeFCIx8hg4QMF00
        0gkAdXNiJaqBOJ8pA7QHsvWy03zIg/U=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-mRelFJ5ENnum_ndkl5vY6A-1; Fri, 31 Mar 2023 17:03:54 -0400
X-MC-Unique: mRelFJ5ENnum_ndkl5vY6A-1
Received: by mail-qt1-f199.google.com with SMTP id h6-20020ac85846000000b003e3c23d562aso15411157qth.1
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 14:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680296634;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bUtpTfIhZLUJQRzvjQdCDBe9iqr/rmYVzQ4AMz2vCfE=;
        b=AAFFo/PSOJmCBNsDjXkBTLbRAxL3CFAl5GcQKN6GofrVJp3mDNKTkZz4t+e7JC/Dnn
         eP46cromDm808YWiUIBWc8ihHFMkdpx+o96WRxAjXfoLLhybR9v8cMlKdkyKOX80fgqf
         cwo+DeIi3JdpXj/s9pRWGMCF5bigOVE8O9ugfc3eQUjw9ATvG4g2x/8tCBxf4Ic8aQta
         bfAAfEV9gbR2CsM85iZAUtYs/gFEVPcWdyZ8YAsgdoHgo8VVbq3GmimsHTvhUnQyOdAR
         PC5zsgSz2d8o59cstKEwMELGQlmyfDP9AMSROq8IWfCQa9fbJIq1wUZe557w6n4ZzPtE
         Zm4g==
X-Gm-Message-State: AAQBX9fOaydSJT+fRLO2dBC36yKxj/2J0ZOSWTEDDK4/yKmbYKmUNfpW
        JleE4FGn2GnPR+U/RWv3Q5j85B/qzFBOOAk/qs1foId/HB0DZEhF9w3NCTxPPxwu7uaa5Td9sfm
        cLFh6xM4kibfCvwh3PreBTw==
X-Received: by 2002:a05:6214:23c8:b0:5c6:ab93:6112 with SMTP id hr8-20020a05621423c800b005c6ab936112mr41644749qvb.30.1680296634183;
        Fri, 31 Mar 2023 14:03:54 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZJNrNr28ojgFbGTSKPoyvzjJNzlkeUYYlq7VX0czWlVa+idoT5bjB8pmq4W/nFI4r3SgHHsw==
X-Received: by 2002:a05:6214:23c8:b0:5c6:ab93:6112 with SMTP id hr8-20020a05621423c800b005c6ab936112mr41644711qvb.30.1680296633897;
        Fri, 31 Mar 2023 14:03:53 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id nd13-20020a056214420d00b005dd8b9345absm847628qvb.67.2023.03.31.14.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 14:03:53 -0700 (PDT)
Subject: Re: [PATCH] scsi: message: fusion: remove unused timeleft variable
To:     Bill Wendling <morbo@google.com>
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, nathan@kernel.org,
        ndesaulniers@google.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230331162617.1858394-1-trix@redhat.com>
 <CAGG=3QUYibiR2FLkLWBzr-j9X9nXLJVvmi5WqF=WmRZfgW3tRw@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <0afb4c99-63d9-0d53-8dfc-1a07cc562764@redhat.com>
Date:   Fri, 31 Mar 2023 14:03:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAGG=3QUYibiR2FLkLWBzr-j9X9nXLJVvmi5WqF=WmRZfgW3tRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 3/31/23 12:40 PM, Bill Wendling wrote:
> On Fri, Mar 31, 2023 at 9:26 AM Tom Rix <trix@redhat.com> wrote:
>> clang with W=1 reports
>> drivers/message/fusion/mptsas.c:4796:17: error: variable
>>    'timeleft' set but not used [-Werror,-Wunused-but-set-variable]
>>          unsigned long    timeleft;
>>                           ^
>> This variable is not used so remove it.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>   drivers/message/fusion/mptsas.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
>> index 86f16f3ea478..d458665e2fc9 100644
>> --- a/drivers/message/fusion/mptsas.c
>> +++ b/drivers/message/fusion/mptsas.c
>> @@ -4793,7 +4793,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
>>          MPT_FRAME_HDR   *mf;
>>          SCSITaskMgmt_t  *pScsiTm;
>>          int              retval;
>> -       unsigned long    timeleft;
>>
>>          *issue_reset = 0;
>>          mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
>> @@ -4829,8 +4828,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
>>          mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
>>
>>          /* Now wait for the command to complete */
>> -       timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
>> -           timeout*HZ);
> It looks bad to remove the call to wait_for_completion_timeout(). Is
> it truly not needed? If it's needed, the "timeleft" should be checked
> or a comment left to explain why it's not checked.

Yeah. this is a screw up on my part, sorry.

T

>
> -bw
>
>>          if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
>>                  retval = -1; /* return failure */
>>                  dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
>> --
>> 2.27.0
>>
>>


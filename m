Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41810C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jul 2022 14:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiGPOEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 10:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGPOEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 10:04:32 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395291AF0D
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 07:04:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bh13so6796332pgb.4
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 07:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=GefjgL1xjnBVKkxo9WQII6b9WfvMZLuTwobFYnDvilc=;
        b=RzOcwvQL91fkzfnxUwiceuONzBrqj7oV6mVb8/F9qyNhbIMvulp7fx8lOZIPUR3V6T
         tdJOQfQgO2SrQFmO+VvylXRpBRwr0MPuq8g+ghG20vrd8WPWNQy3USVoRwMaTK6S5XDa
         8Z2d3++YeABS4euZwl7wuxO2Cq5fpViJtbW5JzVZsaNzdjGg2otmXKBRKkBMkTp8Gu+C
         dQMje/qmT16jqj7nfmG1/EsUyDDwwn2dSHQ9aofbRXUBLpxQuQKqUD2JBZSWg+hthhaL
         56/sUAG6+rLkOgqUQ6xndRwg0idID6xwcIorzXtkIJ7MzBkqHj4uxI7B3ZUa+AcLcGa9
         OApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=GefjgL1xjnBVKkxo9WQII6b9WfvMZLuTwobFYnDvilc=;
        b=Pgw9hEl0KM3whiO7RW6wNL0mYg/ai35ckor6xkDOVCvT0XP87UxsYPuN3GG9hYDLFo
         mOJ9S/0AOvC2VyT2QfRvmbKm3MxDQ0waK5MJReSpVbi5Hx502rqcf4+vOv2N4E5p8vzo
         Iduvg6JYPdG6BI1oWYKVNnk02J2X36NMEC6+zODyGrSdVFsnjA1TS22fGbqNI8RE2Xuz
         XVEAyjY1zNUz3C5zxJY09kyIKCFjXLGRGmwcYYN15BoxIz2q+5cPp6cZid9ZuEym31Ww
         +BYPiB4uv8K//3S9bSPW3YcBMmZ50fbj6rGCx0/plyVtAGnDrZHr/WR08tq59hppJMgs
         q5xg==
X-Gm-Message-State: AJIora/3D9v0WIpswMQSv0AeC0NFvfAqb8xoeLTDfpAnqXume0GV9d1+
        AAiOPDf/0u9oOgutmx552QZ1FDpefIfvJw==
X-Google-Smtp-Source: AGRyM1um4EGzG0ruwyQcV2n7eN04peyB3u7mtP+yGbpjW8k+x3FU+yW4FOTt7RufzmBvQaM9PgsOeg==
X-Received: by 2002:a05:6a00:2446:b0:528:5da9:cc7 with SMTP id d6-20020a056a00244600b005285da90cc7mr19606047pfj.51.1657980270652;
        Sat, 16 Jul 2022 07:04:30 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g14-20020a62520e000000b00528d3d7194dsm5893186pfb.4.2022.07.16.07.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jul 2022 07:04:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0cd50038-4988-0a6e-1bae-a82edde962b9@roeck-us.net>
Date:   Sat, 16 Jul 2022 07:03:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220715150219.16875-1-sreekanth.reddy@broadcom.com>
 <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
 <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
 <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
In-Reply-To: <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/22 06:35, Sreekanth Reddy wrote:
> Hi Guenter,
> 
> Please check the changes below. I hope this change will work with
> 32-bit pointers as well.  If it looks good then I will post this
> change as a patch.
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 0901bc932d5c..0bba19c0f984 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct
> mpi3mr_ioc *mrioc,
>                  ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>                  return;
>          }
> -       *(__le64 *)fwevt->event_data = (__le64)tg;
> +       memcpy(fwevt->event_data, (char *)&tg, sizeof(void *)); >          fwevt->mrioc = mrioc;
>          fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>          fwevt->send_ack = 0;
> @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>          {
>                  struct mpi3mr_throttle_group_info *tg;
> 
> -               tg = (struct mpi3mr_throttle_group_info *)
> -                   (*(__le64 *)fwevt->event_data);
> +               memcpy((char *)&tg, fwevt->event_data, sizeof(void *));
>                  dprint_event_bh(mrioc,
>                      "qd reduction event processed for tg_id(%d)
> reduction_needed(%d)\n",
>                      tg->id, tg->need_qd_reduction);
> 

If I understand correctly, you want to pass the pointer to tg along. If so,
the following seems cleaner and less confusing to me.

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6a47f8c77256..f581c07c2665 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
                 ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
                 return;
         }
-       *(__le64 *)fwevt->event_data = (__le64)tg;
+       *(struct mpi3mr_throttle_group_info **)fwevt->event_data = tg;
         fwevt->mrioc = mrioc;
         fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
         fwevt->send_ack = 0;
@@ -1652,8 +1652,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
         {
                 struct mpi3mr_throttle_group_info *tg;

-               tg = (struct mpi3mr_throttle_group_info *)
-                   (*(__le64 *)fwevt->event_data);
+               tg = *(struct mpi3mr_throttle_group_info **)fwevt->event_data;
                 dprint_event_bh(mrioc,
                     "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
                     tg->id, tg->need_qd_reduction);

or simply

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6a47f8c77256..cc93b41dd428 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
                 ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
                 return;
         }
-       *(__le64 *)fwevt->event_data = (__le64)tg;
+       *(void **)fwevt->event_data = tg;
         fwevt->mrioc = mrioc;
         fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
         fwevt->send_ack = 0;
@@ -1652,8 +1652,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
         {
                 struct mpi3mr_throttle_group_info *tg;

-               tg = (struct mpi3mr_throttle_group_info *)
-                   (*(__le64 *)fwevt->event_data);
+               tg = *(void **)fwevt->event_data;
                 dprint_event_bh(mrioc,
                     "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
                     tg->id, tg->need_qd_reduction);

Thanks,
Guenter

> Thanks,
> Sreekanth
> 
> On Fri, Jul 15, 2022 at 10:19 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 7/15/22 08:02, Sreekanth Reddy wrote:
>>> Fix below compilation errors observed on i386 ARCH,
>>>
>>> cast from pointer to integer of different size
>>> [-Werror=pointer-to-int-cast]
>>>
>>> Fixes: c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling")
>>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>>> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>>> ---
>>>    drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++---
>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
>>> index 0901bc932d5c..d8013576d863 100644
>>> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
>>> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
>>> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
>>>                ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>>>                return;
>>>        }
>>> -     *(__le64 *)fwevt->event_data = (__le64)tg;
>>> +     memcpy(fwevt->event_data, (char *)&tg, sizeof(u64));
>>>        fwevt->mrioc = mrioc;
>>>        fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>>>        fwevt->send_ack = 0;
>>> @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>>>        {
>>>                struct mpi3mr_throttle_group_info *tg;
>>>
>>> -             tg = (struct mpi3mr_throttle_group_info *)
>>> -                 (*(__le64 *)fwevt->event_data);
>>> +             memcpy((char *)&tg, fwevt->event_data, sizeof(u64));
>>
>> How is this expected to work on a system with 32-bit pointers ?
>>
>> Guenter
>>
>>>                dprint_event_bh(mrioc,
>>>                    "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
>>>                    tg->id, tg->need_qd_reduction);
>>


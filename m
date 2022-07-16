Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73785C43334
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jul 2022 14:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiGPOL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 10:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiGPOLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 10:11:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F142A140FC
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 07:11:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id v7so6994998pfb.0
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 07:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ku59jUk6jnb0AjqqbgTnPA0ePs3Rw2x16Fl8W1aRTaQ=;
        b=R59V0jF7a7LGXcuTqwZV4/kPirXjGybvQ0jKsGJgznfIIk1nMgrUHbg3Q1tOnmZAUx
         yhKngTAc8b+KWl2zpnt/6ysuOZwxXB3OF+wxC6c5kd5J3JVSI0urzC/MMjkrIsYR/r6K
         lixchwY+F0FeBGJSr9pRjPszCeFzzl8OVjtokOaH8Gw9T1bEc899VvfrPcI0q46rUOlN
         isAO8iEJBE694w85xl/AV55i+/NNXQcPenUS0rnRKubcdwMt65r3EXgULjuWgp1zP46K
         RhpWdbsQ285E16zxefSZxtmSKtNbdr6yPbypJLrztSdDf57HxZK18NBCEqJWTDCTfzaV
         5RFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ku59jUk6jnb0AjqqbgTnPA0ePs3Rw2x16Fl8W1aRTaQ=;
        b=tqJQbaUB++poEzrCfIBqpx4S+cN9NBTtyANNOWDqxdZT4o7a+CrQ57scIQgUZ/40VP
         HJkVJw7wUoBJZsjcZaJTXz/mz6iRyotPIJyg4VhUQpMH/5FVwMM2Eto47wc2QOEkAe8I
         8hfzrYzd+BVf/347+zVlERVj+FLU5urjzlBJx+iwZzvdgUGrmHCubHuY3HzwEPs5/J3b
         7qnh/Frp8Jvt1Hio27/3KUW59mP8oZNmGkyulkb87P2lDxQsLh3GsTVnkqRgEHL6+9Fi
         qcJwF9jHA40h73cfWSwVmw3IbLdYJGmH1hQD1QvLXTD8nbotskuFgYCllkcyntyUXCf6
         /drQ==
X-Gm-Message-State: AJIora/RTreScq0kjLivjN/7lz9fWmYaJte26f8+/8p5tYuDrRIMcJA4
        opv6g8x8Ep5U5aPNIU11+6I=
X-Google-Smtp-Source: AGRyM1uVlxNjuuRh/5f8lyWU3HklK9tHADoQlvZmJ+icv2xZsUlh7eXRev3s0vAkKbpk2Tl3fNscWA==
X-Received: by 2002:aa7:88c3:0:b0:52a:d6ee:eb5d with SMTP id k3-20020aa788c3000000b0052ad6eeeb5dmr19257282pff.63.1657980684479;
        Sat, 16 Jul 2022 07:11:24 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c2c400b0015e9f45c1f4sm5607164pla.186.2022.07.16.07.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jul 2022 07:11:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ba73e66b-6b08-b824-aa5d-56840a4fdbb3@roeck-us.net>
Date:   Sat, 16 Jul 2022 07:10:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220715150219.16875-1-sreekanth.reddy@broadcom.com>
 <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
 <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
 <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com>
 <3917db0c-efe4-e233-5242-50e234c635e3@acm.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <3917db0c-efe4-e233-5242-50e234c635e3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/22 06:45, Bart Van Assche wrote:
> On 7/16/22 06:35, Sreekanth Reddy wrote:
>> Please check the changes below. I hope this change will work with
>> 32-bit pointers as well.  If it looks good then I will post this
>> change as a patch.
>>
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
>> index 0901bc932d5c..0bba19c0f984 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
>> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct
>> mpi3mr_ioc *mrioc,
>>                  ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>>                  return;
>>          }
>> -       *(__le64 *)fwevt->event_data = (__le64)tg;
>> +       memcpy(fwevt->event_data, (char *)&tg, sizeof(void *));
>>          fwevt->mrioc = mrioc;
>>          fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>>          fwevt->send_ack = 0;
>> @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>>          {
>>                  struct mpi3mr_throttle_group_info *tg;
>>
>> -               tg = (struct mpi3mr_throttle_group_info *)
>> -                   (*(__le64 *)fwevt->event_data);
>> +               memcpy((char *)&tg, fwevt->event_data, sizeof(void *));
>>                  dprint_event_bh(mrioc,
>>                      "qd reduction event processed for tg_id(%d)
>> reduction_needed(%d)\n",
>>                      tg->id, tg->need_qd_reduction);
> 
> How about reverting c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling") to remove the time pressure for coming up with a fix for that commit?
> 

Fortunately this is only seen in linux-next, so there would still be a week
or two to do that. Really, I am happy that this is looked at - we still have
build regressions from the last merge window in v5.19-rc6, and it sometimes
takes Linus to intervene to get things fixed there.

Thanks,
Guenter

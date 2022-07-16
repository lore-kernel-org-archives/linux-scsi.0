Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531B5C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jul 2022 13:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiGPNph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 09:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGPNpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 09:45:36 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E191C11E
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 06:45:35 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so14002064pjo.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 06:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HGrVmCnatWOhy8OI919HbExylQdR5stVvmD5EyUgDA0=;
        b=VfxT26AmXaMBKuYlnd79zMR2M2Dc5TdpY6Bfriel7T/jrff3MabTB1HpZJa9HDu8JY
         44hramuN3PruSnpPKYfrTUKVfEZIyk/WhpWqKkOIADUyCoxMDjnfQ0Lm6zglU9fhqop4
         yBK1henj3iKOYr/WW65KC+QkRWFhs+rzRBuKheWLTliflzPdPWFFDnhTS/VPH4hEh0d4
         GG/bdrwVuPAzeQqi6s2pJ4xnkuBCaGch+LPXEG/LtNr8QwuzGi4ZBDeA1NMMtLdc97vU
         GuxRGUzydPe4o47XLJVSJFvk8oNXU36W9IHTJC8aiHqjfu2NebqyJV4EaED81Q62XgPd
         Ie0A==
X-Gm-Message-State: AJIora+j/GRPTsGj/f8FehU02aCBxk3S9akky6tfq9dNxdqmS3w8/PqD
        f47tlF2c9AN/OI15Li1lgw5JY4x4MZw=
X-Google-Smtp-Source: AGRyM1vtAK0guSBrJkyNMo8Izd28KgF8YUeN3bFj4QP+b46HO1o+ibmFN3AhUqrVXztTIGaI3hem4w==
X-Received: by 2002:a17:903:22cc:b0:16c:1bdf:e733 with SMTP id y12-20020a17090322cc00b0016c1bdfe733mr18649187plg.28.1657979135060;
        Sat, 16 Jul 2022 06:45:35 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902c2cc00b0016bff65d5cbsm5547932pla.194.2022.07.16.06.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jul 2022 06:45:34 -0700 (PDT)
Message-ID: <3917db0c-efe4-e233-5242-50e234c635e3@acm.org>
Date:   Sat, 16 Jul 2022 06:45:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220715150219.16875-1-sreekanth.reddy@broadcom.com>
 <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
 <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
 <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/22 06:35, Sreekanth Reddy wrote:
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
> +       memcpy(fwevt->event_data, (char *)&tg, sizeof(void *));
>          fwevt->mrioc = mrioc;
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

How about reverting c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on 
detecting throttling") to remove the time pressure for coming up with a 
fix for that commit?

Thanks,

Bart.

Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25A1CE79DD
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 14:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbjITOmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbjITOl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 10:41:56 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55DF3C07
        for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2023 07:40:58 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-68fb85afef4so6386997b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2023 07:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695220849; x=1695825649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crY1v2p6D4oidDZAJ6fzLdUw+RSmtpfKiKa6Pomm+IQ=;
        b=K7t7JuEMyY4LVOfJFoBoIlmkVVcgM6E6ZZZ15RC5coqNvO0QPRygN1i3+hRnMcdTfm
         PiSP9v0D5+uSbExvgfmJljc5YcBLrq5afzNrlnvxstEnlvOO/ZB563JB1Go2KZUyqcU+
         +61rwv3xHJl2xWUNIKzZsIputF0/R12jBYqg1zNQCvIcAL2L5Y9e5pYejgHlavhJEo69
         SmzKV0QukJHywhmtelHDaNrBJkpbHKplVndSpCvS+biRI7wkVmo3z05IVu5tny4u+vj+
         o9Uwx/Hc1fSvY9ORtZ+ldEPCnupVQOtEyn/GDGZszOe0XgRE5NLkQpbm6MMt7zC9oMsS
         9Hsw==
X-Gm-Message-State: AOJu0YwpaALM3THK6LxpFdYR0TFkDDhK+98kakZs1Bmh3cnUTeVZq0x0
        kxxipI8F6j6MdBgNqphGOT4=
X-Google-Smtp-Source: AGHT+IFaY7MTNk0QCGXyHr/PQlq3XeLSvV3JbK1pZK0zTWZ21o147upF3eEiuPEgE5ixAf8mjkhvkg==
X-Received: by 2002:a05:6a21:8185:b0:14b:7d8b:cbaf with SMTP id pd5-20020a056a21818500b0014b7d8bcbafmr2456648pzb.57.1695220848837;
        Wed, 20 Sep 2023 07:40:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b0c6:e5b6:49ef:e0bd? ([2620:15c:211:201:b0c6:e5b6:49ef:e0bd])
        by smtp.gmail.com with ESMTPSA id m12-20020a637d4c000000b00565cc03f150sm1038913pgn.45.2023.09.20.07.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 07:40:48 -0700 (PDT)
Message-ID: <3ecd7f79-4138-4b77-827f-595f81b31580@acm.org>
Date:   Wed, 20 Sep 2023 07:40:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: ufs: Return in case of an invalid tag
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, daejun7.park@samsung.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230918162058.1562033-2-bvanassche@acm.org>
 <20230918162058.1562033-1-bvanassche@acm.org>
 <CGME20230918162757epcas2p24a62d5f284e643a4f9e4da50ce0bd605@epcms2p4>
 <1461149300.81695164283129.JavaMail.epsvc@epcpadp4>
 <9a382188-14d2-4142-831d-223c6823f316@acm.org>
 <dd2ccd9e-a255-51dd-068b-ebc28811c237@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dd2ccd9e-a255-51dd-068b-ebc28811c237@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/23 00:13, John Garry wrote:
> On 20/09/2023 00:29, Bart Van Assche wrote:
>>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>>> index dc1285351336..5fccec3c1091 100644
>>> --- a/drivers/ufs/core/ufshcd.c
>>> +++ b/drivers/ufs/core/ufshcd.c
>>> @@ -2822,7 +2822,8 @@ static int ufshcd_queuecommand(struct Scsi_Host 
>>> *host, struct scsi_cmnd *cmd)
>>>           int err = 0;
>>>           struct ufs_hw_queue *hwq = NULL;
>>> -        WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", 
>>> tag);
> 
> How is tag < 0 even possible? Indeed, I doubt the tag >= hba->nutrs 
> check also, since shost->can_queue is set to hba->nutrs - 
> UFSHCD_NUM_RESERVED AFAICS

Hi John,

In my opinion neither tag < 0 nor tag >= hba->nutrs can happen. Hence, 
another possibility is to remove the above warning statement.

Thanks,

Bart.

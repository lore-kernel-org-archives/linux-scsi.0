Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4ADCE79A9
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 23:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbjISX3a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 19:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjISX33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 19:29:29 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43642C0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 16:29:24 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5789de5c677so1665888a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 16:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695166163; x=1695770963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PdpmgL/ZXwswG2bu+Z8y1jKggQ/sXwO5QZkHtKKFimo=;
        b=nY5SI4sp39Vy3tqflDB1i4Mo5Y71HrCOG96EaQ3vD6DGek9lT/fq3P0dCWAWoPRKNP
         8bCcLEXysYI5NY56NXfIHrTWZ6kowFCiG2dRXLNWDdh3d0kAM3GRd1H49ZQHlIrr8ME5
         Bnr3/+rDG4IET0Guw0br0qcULOlRF1u0ZINg9KXpK3/bLbyj9m1G2jnbFhEqfbHeeUtf
         585jLbD8TEsS/cyXaev/yyW0KJLsHS1mt1qfH7ktnTFgz1QheKwtfA3NCzzKzJXE0inV
         l6vCeb1iQQM0P+xkD8pWd1NrRPub61ifRV4fnmmNWtLjiBRY1nUZFkvy/wv25iH7E5WD
         g4DA==
X-Gm-Message-State: AOJu0YwBw14TX3x0lFn1fJkgb40wwJWFoU3+3MagmJwk2wu4MILykZPA
        i7Ai/VlIDY0itTkTI5YSx5w=
X-Google-Smtp-Source: AGHT+IHL4cboqOjC0h31ROQDf6wOtOYtfLMmvgmq8NpbkHozWCfg5/NusChf1FyfudUFVGLUvQ84Ng==
X-Received: by 2002:a05:6a21:a5a7:b0:14c:ad99:22a9 with SMTP id gd39-20020a056a21a5a700b0014cad9922a9mr1158656pzc.32.1695166163525;
        Tue, 19 Sep 2023 16:29:23 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id r9-20020a17090a690900b0026801e06ac1sm116781pjj.30.2023.09.19.16.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 16:29:23 -0700 (PDT)
Message-ID: <9a382188-14d2-4142-831d-223c6823f316@acm.org>
Date:   Tue, 19 Sep 2023 16:29:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: ufs: Return in case of an invalid tag
Content-Language: en-US
To:     daejun7.park@samsung.com,
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1461149300.81695164283129.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/23 15:47, Daejun Park wrote:
 > Bart Van Assche wrote:
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index dc1285351336..5fccec3c1091 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -2822,7 +2822,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>>           int err = 0;
>>           struct ufs_hw_queue *hwq = NULL;
>>   
>> -        WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
>> +        if (WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag))
>> +                return 0;
> 
> As far as I know, a return 0 from a queuecommand means that the request was accepted by LLD.

This is on purpose. I think that it is better to issue a warning and to 
cause command processing to hang rather than to return a code that 
causes the SCSI core to resubmit a command with an invalid tag and to 
cause an infinite loop.

Thanks,

Bart.


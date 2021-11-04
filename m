Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73CEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 23:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7373560E93
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 23:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhKDX5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 19:57:22 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:36381 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKDX5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 19:57:22 -0400
Received: by mail-pg1-f171.google.com with SMTP id 75so6825813pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 16:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HqQMIJWqjlWWKdA5UZDTt3ryYCursmS0wbm6nsJNKvQ=;
        b=zHD91AbUrnYs6eReDX5yhQviTBO8qCTJV5Gpb//RHojGhWEFvYwiqwONoTHX50Y5rn
         iC0ydPCn+0Fvr6Qjfyw+RJgWVIYwav6Hpvm1kmmYgfG9krppODFfwCexZFHRE3Ryq9uI
         bAFPJ1QQLPTFFHzyKzxS6YwMhQ171gMD3iss0DiIjLRrAUpCFzI/Pz3uPr/nhd41aOl8
         mB/K93+F5FpJPNHz1QqJuTM80b7sMksC3MiepFDPIgbQJTO0+Cfr4mKYWKxkZFt6PzUh
         04VDUnzoW00iGMeR1pN1Zv69JkN0J4M5d7gThG9io4+pXCTNPvpoE9gXZpiLbszpjil9
         WQHw==
X-Gm-Message-State: AOAM533FAgg6lKEpFuNXKClzk+dXp5goVsy3SGfGZewPX9QgeOu/Vqw6
        pyDAV3pubzLCnc+kpKYfQhY=
X-Google-Smtp-Source: ABdhPJxBcw5+ej4o7OxJxfPBoMpx+AHkzbuYN/LSFel027eZP5IRPTN6Gh6pN741x96ks+4qRAKI/g==
X-Received: by 2002:a63:cf48:: with SMTP id b8mr20763844pgj.434.1636070079597;
        Thu, 04 Nov 2021 16:54:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6f63:8570:36af:9b56])
        by smtp.gmail.com with ESMTPSA id h1sm6162649pfi.168.2021.11.04.16.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 16:54:39 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
To:     daejun7.park@samsung.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        VISHAK G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        "huobean@gmail.com" <huobean@gmail.com>
References: <087fe1fe-173d-50dd-a52e-d794c97648da@acm.org>
 <20211104181059.4129537-1-bvanassche@acm.org>
 <1891546521.01636066202065.JavaMail.epsvc@epcpadp3>
 <CGME20211104181111epcas2p2965ba25c905be783c39f098210cc4c61@epcms2p1>
 <1891546521.01636069381755.JavaMail.epsvc@epcpadp4>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cb0982d2-1124-a8ee-d129-e2e4975ef1c4@acm.org>
Date:   Thu, 4 Nov 2021 16:54:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1891546521.01636069381755.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/21 4:39 PM, Daejun Park wrote:
>> On 11/4/21 3:39 PM, Daejun Park wrote:
>>> I found similar code in the ufshcd_err_handler(). I think the following
>>> patch will required to fix another warning.
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index f5ba8f953b87..cce9abc6b879 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -6190,6 +6190,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>>>                   }
>>>                   dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
>>>                           hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
>>> +               hba->lrb[tag].cmd = NULL;
>>>           }
>>>
>>>           /* Clear pending task management requests */
>>
>> Hmm ... since the error handler calls ufshcd_complete_requests(),
>> shouldn't the completion function clear the 'cmd' member? I'm concerned
>> that the above change would break the completion handler.
> 
> I missed that the error handler calls ufshcd_complete_requests(). Please
> ignore my suggestion.
> 
> By the way, I give my reviewed-by tag.
> 
> Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks Daejun! However, your question made me wonder whether ufshcd_abort()
should clear the 'tag' bit from hba->outstanding_reqs. Although the SCSI
standard requires that a command that is aborted is not completed, the UFSHCI
specification requires that writing into the UTRLCLR register clears the
corresponding bit(s) in the UTRLDBR register. I think bit 'tag' will have to
be cleared from hba->outstanding_reqs to prevent that the aborted request is
completed while the SCSI core is resubmitting it.

Thanks,

Bart.


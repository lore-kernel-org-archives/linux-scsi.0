Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F83C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 23:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B583B61220
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 23:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhKDXRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 19:17:23 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:38643 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKDXRX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 19:17:23 -0400
Received: by mail-pl1-f169.google.com with SMTP id o14so9833700plg.5
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 16:14:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JITQyjQ1sH5EN7pP76yv6awJQ4nVYxcWrH+PqJaCLZo=;
        b=JVm6WoHKC7TMhpKGXEeC55PiFPAJAzahDNwXmvJlvPerInkhohEli210EXSyIa6SD9
         te4KxNJtVtvsoDOYJBA5kSOg0vUs0L+Hgm1VI+ZLxG2FRUhucIGTRBx9gRHu9CpkU2S1
         ZFoeJ850yvoeLnnalpl3xUWbXNoOiuRN1ATTIoqd6SdEi0y8B/gHW5PCXidejVrCIErv
         0W4if8w0YckJE2BDd8Ew4Uz4LNrTccVAStoxoXEcmsJE3QBOc6jIIeVG5OJ5qImvNfAa
         qTC2p6MYtJMXEEBbolG6Akg3ihqSmYqdWAAjayHbfNe+sHDTVD6rS/ATEtbvJ7hB6ZWC
         XUXQ==
X-Gm-Message-State: AOAM530DHqt1pPWThtiPmLZen0K2vU5Dz8CCdAdKAaxNs3HZLetfhz84
        onftqRGhXn3DFi+eu5pYGkU=
X-Google-Smtp-Source: ABdhPJzezd89NCIh8OZ0eaHxtwC/0fsVMxbduv6ppwL8mFsYJhTGd8mOlfN+YCGM2ztSq896JfWf4g==
X-Received: by 2002:a17:90a:7e82:: with SMTP id j2mr25926707pjl.165.1636067684167;
        Thu, 04 Nov 2021 16:14:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6f63:8570:36af:9b56])
        by smtp.gmail.com with ESMTPSA id u2sm6219083pfk.142.2021.11.04.16.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 16:14:43 -0700 (PDT)
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
References: <20211104181059.4129537-1-bvanassche@acm.org>
 <CGME20211104181111epcas2p2965ba25c905be783c39f098210cc4c61@epcms2p2>
 <1891546521.01636066202065.JavaMail.epsvc@epcpadp3>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <087fe1fe-173d-50dd-a52e-d794c97648da@acm.org>
Date:   Thu, 4 Nov 2021 16:14:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1891546521.01636066202065.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/21 3:39 PM, Daejun Park wrote:
> I found similar code in the ufshcd_err_handler(). I think the following
> patch will required to fix another warning.
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f5ba8f953b87..cce9abc6b879 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6190,6 +6190,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>                  }
>                  dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
>                          hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
> +               hba->lrb[tag].cmd = NULL;
>          }
> 
>          /* Clear pending task management requests */

Hmm ... since the error handler calls ufshcd_complete_requests(), 
shouldn't the completion function clear the 'cmd' member? I'm concerned 
that the above change would break the completion handler.

Thanks,

Bart.

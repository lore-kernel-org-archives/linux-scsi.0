Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6E0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 21:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129276126A
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 21:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhKPV4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 16:56:45 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:39886 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhKPV4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 16:56:44 -0500
Received: by mail-pj1-f51.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so3417895pjc.4
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 13:53:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qex20DJ7uASzOcz8szkqctaJkB1+evtTXdhVViB59is=;
        b=y6eRaNNGvxe8gGMPy45MR2Lzgij/OHjlID3IZeV64ajl08ZaubXoBqOdHrCJwSzrbB
         jKgZYwSdMum+cq7KlSlJ5fxoeRFhmxDfqZtiDxqbnR+UGm7wurHijMCXYG1SgO49ddHt
         Tth1WG8lZASpANRQxKqCVbLG8ULZ3EysXnCU16TTMQKlizXgEdQJtcx6VFlcWRdJrhet
         /VkTLlY7c/z70fMeilKJY12gjL9bH0GVVESdaa5kEe4REN1Ew/dm8JqZScGzqQ1+mvyZ
         Y3Ug1X9A2yivuysQ048oqvp1AGXtuwXte4lrM9SuEPOXkn//dctNmu8q6C5n6fV7n3s4
         cqKw==
X-Gm-Message-State: AOAM533k9Mrn4xcYTSFZMzWBdRc5pwzTv92nFvAG5wXMVkDPdiYD5/YI
        COgUTFVgOxk4MAAt5as1/qg=
X-Google-Smtp-Source: ABdhPJyYI5XIeT1T+rFnTU8xlbtQuHqG5a2uOM7ne1NLKBKRxwrXxRzmyzX/a9+LqYb4As4D/pMq5g==
X-Received: by 2002:a17:902:ea11:b0:141:c6c8:823a with SMTP id s17-20020a170902ea1100b00141c6c8823amr48488312plg.29.1637099626841;
        Tue, 16 Nov 2021 13:53:46 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h3sm22121744pfi.207.2021.11.16.13.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 13:53:46 -0800 (PST)
Message-ID: <03036140-a7c6-fe0c-13e3-def8fcf2ecb3@acm.org>
Date:   Tue, 16 Nov 2021 13:53:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <b728d150-3271-c6b0-25dc-881141ef3630@mediatek.com>
 <1a196e1b-1412-90f3-e511-3f669572a619@mediatek.com>
 <87d8a036-087d-f1fa-19f4-f50c7279170a@acm.org>
 <59620452-e5a2-74e1-5971-a5535de3d536@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <59620452-e5a2-74e1-5971-a5535de3d536@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 12:16, Adrian Hunter wrote:
> On 16/11/2021 18:08, Bart Van Assche wrote:
>> On 11/16/21 1:07 AM, Peter Wang wrote:
>>> Should we add unmap?
>>
>> Hi Peter,
>>
>> I will add DMA unmapping code in the abort handler.
> 
> I would note that __ufshcd_transfer_req_compl() does that, as well as providing
> a matching ufshcd_release() for the ufshcd_hold() in ufshcd_queuecommand(), so
> do consider __ufshcd_transfer_req_compl().
> 
> Using __ufshcd_transfer_req_compl() seems consistent with the error handler which
> uses __ufshcd_transfer_req_compl() via ufshcd_complete_requests(), which will pick
> up all the requests that the error handler has just aborted via
> ufshcd_try_to_abort_task().  Also ufshcd_host_reset_and_restore() uses
> __ufshcd_transfer_req_compl() via ufshcd_complete_requests(), which will pick
> up anything still in outstanding_reqs because the doorbell has become zero at
> that point.

Hi Adrian,

Although I agree with minimizing code duplication, I'm not sure that 
__ufshcd_transfer_req_compl() should be called from inside 
ufshcd_abort(). __ufshcd_transfer_req_compl() also calls 
ufshcd_update_monitor() and ufshcd_add_command_trace(hba, index, 
UFS_CMD_COMP). Neither function should be called when aborting a command.

Thanks,

Bart.



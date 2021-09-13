Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46648C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 20:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7036108B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbhIMUM5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 16:12:57 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:44867 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbhIMUM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 16:12:56 -0400
Received: by mail-pg1-f172.google.com with SMTP id s11so10484074pgr.11
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 13:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a/tDI3p0kw7mfaWCLDqmsc+iw42KOmO2CcWEJs4JPpo=;
        b=1B12bHhotadqOaizrcigW6PSBOE+FA/rJ/HFU4mVJmBwEiT6h5abjGhPGXl139dYRY
         7jX7lhqa6FUtg1QwWdboCyk0XaJPvuwYCTaqpaWY4ZUgqWWM3Mq5xij5ubqXMPnZrOed
         A0w8wZYLw53Ny7df2MIfI1Uaa+IiBJgyU/8oGfwk/zdAKuFoyguyWQHYZDPmfTY1FjRH
         dgx7juSWWLfHkhWOES1imMHfRo39O1EAoqkSbLEDJEPxhDGFR28hG87guyDZW63gP2hC
         5XaGCmzEvPzsmuaVnxWsVblcA4l/8UR9r8K8XwshwL086YP+eQjz5v8vn+QFMHwMo4eW
         JsHg==
X-Gm-Message-State: AOAM532OQW8Lm47WnUYZ41uo5WkudZCYWdx7UuKigzdqizJIdXmY7/K+
        Fhln9LBOHGuyP2qow1Jw1oVB9NNwgPU=
X-Google-Smtp-Source: ABdhPJz1Y/2mSla3J07pjf6blcS9E/4dqu1+t65VBeYd9mqOW2c+eW7rDfZfQdhGWioBZXnbZtxJjw==
X-Received: by 2002:a63:b218:: with SMTP id x24mr12498053pge.335.1631563899737;
        Mon, 13 Sep 2021 13:11:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6765:113f:d2d7:def9])
        by smtp.gmail.com with ESMTPSA id j5sm7582598pjv.56.2021.09.13.13.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 13:11:39 -0700 (PDT)
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
 <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
 <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
 <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
 <fae15188-2c1d-b953-f6e4-6e5ac1902b24@intel.com>
 <2997f7f9-d136-4bad-6490-5e19abccba00@acm.org>
 <cad73161-f124-e764-964f-3c205aaca2d9@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2a43c750-ec15-2ac9-b899-00ed911addd8@acm.org>
Date:   Mon, 13 Sep 2021 13:11:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <cad73161-f124-e764-964f-3c205aaca2d9@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 10:13 AM, Adrian Hunter wrote:
> SCSI_MLQUEUE_HOST_BUSY causes scsi_host_busy() to decrement by calling
> scsi_dec_host_busy() as described above, so the request is not being
> counted in that condition anymore.

Let's take a step back. My understanding is that the deadlock is caused by
the combination of:
* SCSI command processing being blocked because of the state
   UFSHCD_STATE_EH_SCHEDULED_FATAL.
* The sdev_ufs_device and/or sdev_rpmb request queues are frozen
   (blk_mq_freeze_queue() has started).
* A REQUEST SENSE command being scheduled from inside the error handler
   (ufshcd_clear_ua_wlun()).

Is this a theoretical concern or something that has been observed on a test
setup?

If this has been observed on a test setup, was the error handler scheduled
(ufshcd_err_handler())?

I don't see how SCSI command processing could get stuck indefinitely since
it is guaranteed that the UFS error handler will get scheduled and also that
the UFS error handler will change ufshcd_state from
UFSHCD_STATE_EH_SCHEDULED_FATAL into another state?

What am I missing?

Thanks,

Bart.

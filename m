Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A67C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 22:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B92960F23
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 22:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhIOWm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 18:42:57 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:43963 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhIOWmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 18:42:35 -0400
Received: by mail-pf1-f171.google.com with SMTP id c1so1164699pfp.10
        for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2021 15:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWWZQAKmuqWhTS9nTXLEopZQnO6deMVZ/0GGv4hfFNs=;
        b=EJD/ZlUnwXkAKDUhrqJrBOAsUeGvdTrV05/Ye2N2nXRavYE+UH9wG4mzZt0nrzcNhj
         xYxeLlEDjM66fBB407NXAR6LfIY0LKdHWsUmUbkSx1gRLOA98fSWywTs+xlidJ8MMaQy
         ZczlmJwWRPm/b9XHcpSVztcXrXqJ/kM8x+z89nUfUvod/+FINjD7IRb+hqEkTQa/Tb3I
         vrw1fCJ9svsiRcvjjQ+TP4uym7u29Spzw3QvWLMGpMk8POEJea8idmwC4uiJSRaLvKbi
         7nIlxIlv60NC4bksrjG/WEoDdx6ZbRTXMlSS0d9xp/ggTnf7+gHjTWoDmprmbMoQaXki
         iPgQ==
X-Gm-Message-State: AOAM532OS7gxD+AibQi0rQI8bkz1nm5oXsbKxxfhg4K1aRRQGwOER4l+
        gyJQGDJSXQgfn0dkOIYW0Xr4zCsZY4g=
X-Google-Smtp-Source: ABdhPJwJnrdSPL7UyHKKriaRLLK2w0DBc9CNTbKFlxfh5aUZNd2Ycmzo3RjYgabcxlgVAkthpFLc3A==
X-Received: by 2002:a63:1656:: with SMTP id 22mr1979649pgw.20.1631745674450;
        Wed, 15 Sep 2021 15:41:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:913a:44b:dd59:c30])
        by smtp.gmail.com with ESMTPSA id a26sm891447pgm.87.2021.09.15.15.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 15:41:13 -0700 (PDT)
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
 <2a43c750-ec15-2ac9-b899-00ed911addd8@acm.org>
 <8b3f4f40-4959-17ee-577e-ab9473e4882b@intel.com>
 <75bf671f-6dad-906f-3e32-ceeaf3a6a1bd@acm.org>
 <1072b4e3-8e18-bb6f-f63e-ec07b1404b50@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c33f0d4f-d7d4-3a8b-1999-d6bc2d9a5c07@acm.org>
Date:   Wed, 15 Sep 2021 15:41:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1072b4e3-8e18-bb6f-f63e-ec07b1404b50@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/21 8:35 AM, Adrian Hunter wrote:
> Thanks for the idea.  Unfortunately it does not work for pass-through
> requests, refer scsi_noretry_cmd().  sdev_ufs_device and sdev_rpmb are
> used with pass-through requests.

How about allocating and submitting the REQUEST SENSE command from the context
of a workqueue, or in other words, switching back to scsi_execute()? Although
that approach doesn't guarantee that the unit attention condition is cleared
before the first SCSI command is received from outside the UFS driver, I don't
see any other solution since my understanding is that the deadlock between
blk_mq_freeze_queue() and blk_get_request() from inside ufshcd_err_handler()
can also happen without "ufs: Synchronize SCSI and UFS error handling".

The only code I know of that relies on the UFS driver clearing unit attentions
is this code:
https://android.googlesource.com/platform/system/core/+/master/trusty/storage/proxy/rpmb.c
The code that submits a REQUEST SENSE was added in the UFS driver as the result
of a request from the team that maintains the Trusty code. Earlier today I have
been promised that unit attention handling support will be added in Trusty but I
do not when this will be realized.

Bart.



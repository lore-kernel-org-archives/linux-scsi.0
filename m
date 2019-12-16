Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB401C3F68F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 17:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB128206EC
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 17:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfLPRoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 12:44:54 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39909 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLPRoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 12:44:54 -0500
Received: by mail-pl1-f196.google.com with SMTP id z3so3248943plk.6;
        Mon, 16 Dec 2019 09:44:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUF4b98F+9fGHitur94ofvbcuGgyA1DOCtJmpa5SVnQ=;
        b=bwC98udUt+DBw5risHFIJWJGvP1CxNFl8K+iqQu5y+dU7roG/VK1BsUnQMHEartbzR
         dfmDc6CmRl3ZADcCgOkFCwopfeaQaMLq1xK3yQ5Wv5p4bJHhEYp4IAG78UNlktrKA1lr
         RZsqxjIRA6MqKvKFrdqTiLMXoINvpsrYxAg5kQBvSPifadzQl19/oxexStVZDGWh9Hei
         vQriL5HoZIiIkMaxVoO+rzgunWvqkCLAyjSMOwV3GTOLML9jeZBUV7OAyqaNa575mYS/
         NPuRi6jhLcsSgOOXihJ/WdSzg+EdT6ndMEQP1Y2ReeSM9ftPe9QekraWnffF/rtAwcjP
         9Fhg==
X-Gm-Message-State: APjAAAWGo1AVwApGOjqlC3yOAvdh1B3twYN42/0LK93zGDMb7NdDRJUS
        xAldfONMBT3bCZjyB1zRuiZkXEb+HPQ=
X-Google-Smtp-Source: APXvYqwBiDAi86nHCvpeNyjgbN7uuyaZYWq/sf/IbLX0CDNmMesN9uldITDrLwKvFN2VIsoEaGXQ8g==
X-Received: by 2002:a17:90a:250a:: with SMTP id j10mr304468pje.134.1576518293512;
        Mon, 16 Dec 2019 09:44:53 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id k1sm1529365pgk.90.2019.12.16.09.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 09:44:52 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
To:     cang@codeaurora.org
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
 <2956b9c7-b019-e2b3-7a1b-7b796b724add@acm.org>
 <3afbe71cc9f0626edf66f7bc13b331f4@codeaurora.org>
 <5b77c25f-3cc7-f90b-fcd7-dd4c1e2f46d2@acm.org>
 <0419d33a1ea98a2da9263131aba2ca71@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <15afb253-1726-d26a-5e1d-5902d3c88f5d@acm.org>
Date:   Mon, 16 Dec 2019 09:44:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0419d33a1ea98a2da9263131aba2ca71@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/15/19 7:12 PM, cang@codeaurora.org wrote:
> Sure, I will add the Fixes tag and rebase my changes. How about the logic
> part of this change? Does it look good to you?

Hi Can,

You may want to ask someone who is more familiar with the UFS driver 
than I to have a look. I'm not a UFS expert ...

> Sorry I was not aware of that your changes have been applied to 
> 5.6/scsi-queue.
> I am still trying to get it tested on my setups...
> Anyways, aside of hba->cmd_queue, tearing down hba->tmf_queue before
> scsi_remove_host() may be problem too. Requests can still be
> sent before and during scsi_remove_host(). If a request timed out,
> task abort will be invoked to abort the request, during which
> hba->tmf_queue is expected to be present. Please correct me if I am wrong.

I agree that the code I added in ufshcd_remove() probably needs to be 
moved somewhere below the scsi_remove_host() call.

Thanks,

Bart.

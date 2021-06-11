Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0183CC48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D576561285
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFKVEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:04:54 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:34700 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFKVEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 17:04:53 -0400
Received: by mail-pg1-f181.google.com with SMTP id l1so3434114pgm.1;
        Fri, 11 Jun 2021 14:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1KOpqPZxmqkSPFhFJZvOpzzDva7Ir6+8HFVjBuyL20c=;
        b=ubSX/4ojDP/3+JoKJ8QBt2zisNGrQ9KURcVnN2BtIEdEZ0YunXk7wPsdL8Ejl0b9hU
         X6KMqu3NJ210bCsRCceVQRcfgtiBIZ/EAAjaKwqE28NWQlCTzWWdShLZsIx0bqtTfriv
         Ms/PKiiQ2S7+8dEIPZrbaJTAJcC9PqnThdPaPxgNKQWN1NgqDojmuqlg/L04cUWDwUUd
         dEz/xrbJtRGVn+hMeLxeLtAaWcetwby4OJ6eEPBBeAN9oa3OVm5Kw4RN64jpKDUId5hZ
         l96SJ3K/Hf9iII4dWZDpqPma8SdIxdNMeaBOEqzonBifpmG064V7TFwY7HGSNXZ5W6gh
         hIIw==
X-Gm-Message-State: AOAM532YuucLpHHqHnf2wzhakH0bPbgTqtVCrt4CUOvZph4gnbEjbBMj
        bVmFGnU8Fcsu2GYjKh774ceZ7ecPmbc=
X-Google-Smtp-Source: ABdhPJzI4e6IT4aqtn/PYdO0fM/tkXXFbHpnfxSvqHSq9l3r82kHUZ+JQ/8onKxWJ52hh1dLA/8ogQ==
X-Received: by 2002:a63:2114:: with SMTP id h20mr5509641pgh.16.1623445363063;
        Fri, 11 Jun 2021 14:02:43 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v7sm6259593pfi.187.2021.06.11.14.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 14:02:42 -0700 (PDT)
Subject: Re: [PATCH v3 8/9] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
Date:   Fri, 11 Jun 2021 14:02:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-9-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 9:43 PM, Can Guo wrote:
> If PM requests fail during runtime suspend/resume, RPM framework saves the
> error to dev->power.runtime_error. Before the runtime_error gets cleared,
> runtime PM on this specific device won't work again, leaving the device
> either runtime active or runtime suspended permanently.
> 
> When task abort happens to a PM request sent during runtime suspend/resume,
> even if it can be successfully aborted, RPM framework anyways saves the
> (TIMEOUT) error. In this situation, we can leverage error handling to
> recover and clear the runtime_error. So, let PM requests take the fast
> abort path in ufshcd_abort().

How can a PM request fail during runtime suspend/resume? Does such a
failure perhaps indicate an UFS controller bug? I appreciate your work
but I'm wondering whether it's worth to complicate the UFS driver for
issues that should be fixed in the controller instead of in software.

Thanks,

Bart.

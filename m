Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C15DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 20:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D2B61056
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 20:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350542AbhICUaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:30:35 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:46751 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350396AbhICUad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 16:30:33 -0400
Received: by mail-pl1-f174.google.com with SMTP id bg1so209178plb.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Sep 2021 13:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WHVe5QKRn8e72gL5q0fia930zEjwUOodz5r80hSn+M4=;
        b=o3dM6C6j8rgP87aUwKkP0g0od7xWPT7uDmhU86er943E5Q6zXXkXvWHFaAC8csVW+U
         1fJUTO26w33caFxFU60yrCxiGJKIq6Mqypa62n65Emz2Sa6ZyeXIeJ/7qi7mzS0li5Y1
         wAHJWAO/neD1QcJgRUIJt09XZr24vPwSNimQjuIW8ZAQS4XFQYkEGVlIDtQgzLuZTLfa
         4mF29mMyDfwtw3ZrhMsdy5fHXsStV3b047oUE/+q2HtZU/sPXI8cq07FaaJckGFMD6Qd
         PWdrf8wHpH0prh3F4ljVsmlcZqs5sLR5nI3g+w/tCAilYnKTjfi02l+LqlJP6MXtlMzk
         0feA==
X-Gm-Message-State: AOAM531cn94hM6/F65bKtWgqjOijYwyh6ifX15BlcgMbNbf16eFCgDMq
        8z49eLdiAog6Y5RM5K3oxKhL+xRQ3AY=
X-Google-Smtp-Source: ABdhPJxmMtrvjfVExSInOdTp9QiD2xN0uQTra00SZV66Nt68x8xLz6OtCH7IZdNjBcJdiIyx61ThWw==
X-Received: by 2002:a17:902:7b98:b0:138:c171:c1af with SMTP id w24-20020a1709027b9800b00138c171c1afmr529097pll.70.1630700972389;
        Fri, 03 Sep 2021 13:29:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f54:6487:f0e0:810e])
        by smtp.gmail.com with ESMTPSA id i7sm131346pjm.55.2021.09.03.13.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:29:31 -0700 (PDT)
Subject: Re: [PATCH V2 1/3] scsi: ufs: Fix error handler clear ua deadlock
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
References: <20210903095609.16201-1-adrian.hunter@intel.com>
 <20210903095609.16201-2-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <56b1a7b3-90b7-e208-2486-20421d32d2e7@acm.org>
Date:   Fri, 3 Sep 2021 13:29:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210903095609.16201-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/21 2:56 AM, Adrian Hunter wrote:
> There is no guarantee to be able to enter the queue if requests are
> blocked. That is because freezing the queue will block entry to the
> queue, but freezing also waits for outstanding requests which can make
> no progress while the queue is blocked.
> 
> That situation can happen when the error handler issues requests to
> clear unit attention condition. The deadlock is very unlikely, so the
> error handler can be expected to clear ua at some point anyway, so the
> simple solution is not to wait to enter the queue.
> 
> Additionally, note that the RPMB queue might be not be entered because
> it is runtime suspended, but in that case ua will be cleared at RPMB
> runtime resume.

The only ufshcd_clear_ua_wluns() call that I am aware of and that is 
related to error handling is the call in 
ufshcd_err_handling_unprepare(). That call happens after 
ufshcd_scsi_unblock_requests() has been called so how can it be involved 
in a deadlock?

Additionally, the ufshcd_scsi_block_requests() and 
ufshcd_scsi_unblock_requests() calls can be removed from 
ufshcd_err_handling_prepare() and ufshcd_err_handling_unprepare(). These 
calls are no longer necessary since patch "scsi: ufs: Synchronize SCSI 
and UFS error handling".

Thanks,

Bart.

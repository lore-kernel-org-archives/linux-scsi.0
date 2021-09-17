Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50105C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 273C860F21
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343813AbhIQR2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 13:28:53 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46897 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbhIQR2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 13:28:52 -0400
Received: by mail-pf1-f175.google.com with SMTP id 203so1975454pfy.13;
        Fri, 17 Sep 2021 10:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZuvAu+FzGmydWNHlU3zYaItV7zmXiqpK74jzvaLSh14=;
        b=IIxl29Rmb2tXN7R1dWP/XyCLRFEXmi+Fswf71RNIUFFUKDIb2K21rQyZeWx6TZ4odx
         S/vYUBUKNIrdW+Ssr2piAQpTCIes7dv612oxGF+XyWOBs//2/fNr4UQ4rZS85gAAXW8A
         Ik/YP+ld8fyDUIGKvYG60/HE4ghh5j/axj9QExEaGYtiu13RQ4+j2ycYjtvEeT0BlgPJ
         koTliDFq7ZwejcHh+0LnWmZBYPiOcHc/tnMnNNbmXdk4/1D2JOwdqerPgOdK9x3QITgy
         4gr2LdaRK7wQ+h90cUxFFOvdz9/VwnDWJo6xNlszLHrydQrKOvZLnafplLg5pn3E1WIu
         a2UA==
X-Gm-Message-State: AOAM532i9V6FzM/YwafpHGV7GHC8M4/LQvlNM6sc0WgmJJj3L6InniE5
        p5pe4psn47Xwbd+Bo5tb6geRzk3qeCg=
X-Google-Smtp-Source: ABdhPJzzUBDvNqV18d0bYDVokxUqC5xPvgR89wuHgSWBDQaCVKT4AgIAVVsFFPqh3J6CVkcXgbr06g==
X-Received: by 2002:a62:ae13:0:b0:440:385c:2ee9 with SMTP id q19-20020a62ae13000000b00440385c2ee9mr12153114pff.39.1631899649799;
        Fri, 17 Sep 2021 10:27:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id i10sm6775587pfk.151.2021.09.17.10.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 10:27:28 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix a possible dead lock in clock scaling
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1631843521-2863-1-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cc9cb9e7-68bd-3bfa-9310-5fbf99a86544@acm.org>
Date:   Fri, 17 Sep 2021 10:27:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1631843521-2863-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/21 6:51 PM, Can Guo wrote:
> Assume a scenario where task A and B call ufshcd_devfreq_scale()
> simultaneously. After task B calls downgrade_write() [1], but before it
> calls down_read() [3], if task A calls down_write() [2], when task B calls
> down_read() [3], it will lead to dead lock.

Something is wrong with the above description. The downgrade_write() call is
not followed by down_read() but by up_read(). Additionally, I don't see how
concurrent calls of ufshcd_devfreq_scale() could lead to a deadlock. If one
thread calls downgrade_write() and another thread calls down_write() immediately,
that down_write() call will block until the other thread has called up_read()
without triggering a deadlock.

Thanks,

Bart.

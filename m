Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43814C2B9F7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 16:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 238F46140A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 16:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhEXQ5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 12:57:48 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:45881 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhEXQ5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 12:57:47 -0400
Received: by mail-pj1-f51.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so10308078pjb.4;
        Mon, 24 May 2021 09:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=19TIfgdbq72p4i232l0hKg6re5NjXUcN0qnK0ejAszk=;
        b=Wx0JtsgGZU9IK0Pj44Zb9l4wqMIJ37qzmSL6SaPpl2Ndiz7ltPtYVu4YgJ1CVvMAOM
         +20kRfa7i3a/BNzgnKFZ1J5GlPa+olYzs0sl2Uv33Sh0Ezcs2o3Kwoy2HuByjTCn6WA9
         PpokQWjrTiwsq27NO5f1d9vBGnc/l1I8RiLpLjctjewtoWiF4BlXhC5e7RF1iJsLGpTQ
         3ZwVpEVxg9gqNajq2YTCe73QpM0LbTBOb8YUS8Kc00SYGrnDXJjnhWfW0edrMuKxM4N5
         gkD10bADouDlzC4d83Ka6hCNqhqSOwdTtJ3n38lQ33NUEfo338cC/49hPwnP8dewcSiR
         uomw==
X-Gm-Message-State: AOAM532CTsolfnezAaCoyliaKAuLBsBEj631BxEJBo1THRebs3wXeWY+
        +v7oMbrx+Fbbod0YUl4kUFwnMl+v13ozqA==
X-Google-Smtp-Source: ABdhPJxJwKY6lsrLTaLZz9vqWk90jo/oZFO4LHuA47iAMrUmnALEWv6HoUcJzcMwbdEk7mq3qLHdcQ==
X-Received: by 2002:a17:902:d305:b029:f0:d3db:26db with SMTP id b5-20020a170902d305b02900f0d3db26dbmr26400149plc.36.1621875377840;
        Mon, 24 May 2021 09:56:17 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c128sm11759276pfa.189.2021.05.24.09.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 09:56:17 -0700 (PDT)
Subject: Re: [PATCH v2 5/6] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
 <1621846046-22204-6-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <19b44731-1a4f-c88c-58fd-05eca5df2c2e@acm.org>
Date:   Mon, 24 May 2021 09:56:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1621846046-22204-6-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 1:47 AM, Can Guo wrote:
> UFS error handling now is doing more than just re-probing, but also sending
> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, which
> may change runtime status of scsi devices. To protect system suspend/resume
> from being disturbed by error handling, move the host_sem from wl pm ops
> to ufshcd_suspend_prepare() and ufshcd_resume_complete().

Other SCSI LLDs can perform error handling while system suspend/resume
is in progress. Why can't the UFS driver do this?

Additionally, please document what the purpose of host_sem is before
making any changes to how host_sem is used. The only documentation I
have found of host_sem is the following: "* @host_sem: semaphore used to
serialize concurrent contexts". To me that text is less than useful
since semaphores are almost always used to serialize concurrent code.

Thanks,

Bart.

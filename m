Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE30C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEAA20715
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343640AbhA0EUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:20:55 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:39454 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbhAZFGn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 00:06:43 -0500
Received: by mail-pg1-f178.google.com with SMTP id 30so10789834pgr.6;
        Mon, 25 Jan 2021 21:06:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bgzzPIxi+KA87nRql5hoz0FJKMHnwNhrjowfvx/anRo=;
        b=Mrd+fO1+wdD6azplzyH1pO4aYQd8zfhSbWBFZYfQBh+l0DtmrtMP9fl4DYhZQg5iij
         S6Pt1+sZ3zuHhXxtxbZFXpZzRuopmtZCSg0fhf9aX93HI+3AQDbLiqKxWa4p/Mq/jSBw
         kvFrTqtWFiEw6ZIzeHwO4H5Lk5BE7yKSOWaSe0nDlFiQp008mX2nrwt2/a43e5FFtbnB
         CaxH2GfMlFHmlHpLK1Ukpj0s8zu+G+dQgQENy1XQ++BO7tm4tH0QYjsTnBGzFY5+wrgM
         FSWwRal6l2l4KgY9yTmj4TvslMUNyfR0H/YzrnZPrcWvG5bz9xDv8x789aD/aaUkVYIc
         sF5Q==
X-Gm-Message-State: AOAM531rAkVypSetvcSM69h8Q3C5GvdsU0Ea7rh13JOW4FbjEywyR5Vp
        3NPr5yEGDKFuyeRhnOVgsSTPKFEs3Tc=
X-Google-Smtp-Source: ABdhPJzBlxZpwBE04PRvEGVLh2DHIk1KCmjkcdXTsHNFHKTOhYUbVWc8rvzRSgzvjIFpXhDkgaoATQ==
X-Received: by 2002:a05:6a00:2286:b029:1ae:6c7f:31ce with SMTP id f6-20020a056a002286b02901ae6c7f31cemr3598169pfe.6.1611637562900;
        Mon, 25 Jan 2021 21:06:02 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:f18a:1f6a:44e7:7404? ([2601:647:4000:d7:f18a:1f6a:44e7:7404])
        by smtp.gmail.com with ESMTPSA id t2sm19751143pga.45.2021.01.25.21.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 21:06:01 -0800 (PST)
Subject: Re: [PATCH v2] scsi: ufs: Fix some problems in task management
 request implementation
To:     Can Guo <cang@codeaurora.org>, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1611199388-24668-1-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7570d6b0-631b-a043-92da-21384b55219b@acm.org>
Date:   Mon, 25 Jan 2021 21:05:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611199388-24668-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/20/21 7:23 PM, Can Guo wrote:
> Current task management request send/compl implementation is broken, the
> problems and fixes are listed as below:
> 
> Problem: TMR completion timeout. ufshcd_tmc_handler() calls
>          blk_mq_tagset_busy_iter(fn == ufshcd_compl_tm()), but since
>          blk_mq_tagset_busy_iter() only iterates over all reserved tags and
>          started requests, so ufshcd_compl_tm() never gets a chance to run.
> Fix:     Call blk_mq_start_request() in __ufshcd_issue_tm_cmd().
> 
> Problem: Race condition in send/compl paths. ufshcd_compl_tm() looks for
>          all 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL and call complete()
>          for each req who has the req->end_io_data set. There can be a race
>          condition btw tmc send/compl, because req->end_io_data is set, in
>          __ufshcd_issue_tm_cmd(), without host lock protection, so it is
>          possible that when ufshcd_compl_tm() checks the req->end_io_data,
>          req->end_io_data is set but the corresponding tag has not been set
>          in the REG_UTP_TASK_REQ_DOOR_BELL. Thus, ufshcd_tmc_handler() may
>          wrongly complete TMRs which have not been sent.
> Fix:     Protect req->end_io_data with host lock. And let ufshcd_compl_tm()
>          only handle those tm cmds which have been completed instead of
>          looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.
> 
> Problem: In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs +
>          req->tag as the Task Tag in one TMR UPIU.
> Fix:     Directly use req->tag as Task Tag.

Please split this patch into three separate patches - one patch per
problem that has been described above.

Thanks,

Bart.

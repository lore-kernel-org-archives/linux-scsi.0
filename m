Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5DCC4332D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 20:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A11C221F8
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 20:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbhADUFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbhADUFx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 15:05:53 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C5FC061574;
        Mon,  4 Jan 2021 12:05:12 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cw27so28668782edb.5;
        Mon, 04 Jan 2021 12:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Fym+8Yrz3wgIVJ4tX49yza4nzu5JRS/0kOq0s2T9ww=;
        b=sVwwA/psgjK2oKfq6w+HL5wZKPUsfrIi1G3tuQFVIXa01z+idVTZoHGr28B7NUrmxv
         ARBiew7r06GPoZ3l3mWi4WQokLmV73mIwxoZCWlg4a8dSha9apN/iQXR2Y08OGlXjdjv
         N4MuO1rf5tWw4vlQIoTtuEJRGmGTe+7K+06CksCjGOUESROSBw6ZX9fCvD/67v7yZu3l
         N0FYgVbvRXx+jvSBeDWki0kGb47j6VBCQ+yD5+0bKq3R50P1kEcbsDV/jhPd+UM/eghr
         AX1yKdWIsomjWSd1sde9tiF7RFJ6kifij3sPQZjI/UedHYytoA72SAWyKsD0nA3wkklF
         1z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Fym+8Yrz3wgIVJ4tX49yza4nzu5JRS/0kOq0s2T9ww=;
        b=owe4tsEr34CODv16oZX0ka7SPGacEKnDqnyaogr4anvn4KeVmNxPR/Fu/LhAiKvP0X
         0erMo2Mnioru7UTVMFvqb8IH+aadHLULEKBfWaRoEfY9PQWCBhEVkcHXn2G1VWN5FN9z
         MMjYsvDnzUUnYID3v3Xg+ZQj7+36L6xa9HS4m8XKjvMXJbaEjoDKtDEzhN0uQiwTXrBa
         NCea+wPTXRGehZTwxTSHUOlhSFW4KWgF5xapYR18kv3yFMMTvr2x/MjazMv82+Xy0HbD
         FH6+xQ5rWlXDbA1Wx7IiREo3OKTs1PTOxTg2c0OycVp9ffLHZ+/Dbmpbh0LCmDoJbFjW
         dlSA==
X-Gm-Message-State: AOAM532PQLx74yutz1U7NR5YsrWPrhYaGCcP65WIa59k35owAXUH5/y8
        hcjqDnFzFruHUCUlbfbUGiM=
X-Google-Smtp-Source: ABdhPJyMA8PEzEiHw5aSKUa+yUT2eR2wm2rcZnUE2bUh/JxPvFbkbLpYTS2SbK7TGu7RUuzZdCceaA==
X-Received: by 2002:a50:8741:: with SMTP id 1mr73464309edv.349.1609790711296;
        Mon, 04 Jan 2021 12:05:11 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id p24sm40943234edr.65.2021.01.04.12.05.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Jan 2021 12:05:10 -0800 (PST)
Message-ID: <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 04 Jan 2021 21:05:09 +0100
In-Reply-To: <1609595975-12219-3-git-send-email-cang@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
> + * @shutting_down: flag to check if shutdown has been invoked

I am not much sure if this flag is need, since once PM going in
shutdown path, what will be returnded by pm_runtime_get_sync()? 

If pm_runtime_get_sync() will fail, just check its return.

Hi Rafael
would you please help us confirm this?

thanks,
Bean


> + * @host_sem: semaphore used to serialize concurrent contexts
>   * @eh_wq: Workqueue that eh_work works on
>   * @eh_work: Worker to handle UFS errors that require s/w attention
>   * @eeh_work: Worker to handle exception events
> @@ -751,7 +753,8 @@ struct ufs_hba {
>         u32 intr_mask;
>         u16 ee_ctrl_mask;
>         bool is_powered;
> -       struct semaphore eh_sem;
> +       bool shutting_down;
> +       struct semaphore host_sem;


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635F9C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3561D6143E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhENEG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 00:06:59 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:44696 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhENEG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 00:06:58 -0400
Received: by mail-pj1-f50.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so1004036pjb.3;
        Thu, 13 May 2021 21:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h43Pdi9RV6SUWb4LkocJ+mvTm3hFUW7mF7EJTMuXFqI=;
        b=LmyXf0DhTaQYOWm5bPXTUM4mq5RZUYGRMP2AVMcyOwVhBnOs9NNrSYI4ZqA0Em2mAY
         Y0gZfuiCBQ7j4c92xgK/n/OIWuo8ckkqZ8IYYCimHxkpkdBQuWPaOph3Lggj/u8gGJLk
         YwBqS6VDRHHFQmGFjfGAt2SaC5uPmG2R2qA8GlW9211CPeAfjcQbdOw+Gh/ZAWyHBilE
         1QIFTAjfv17DwCMMeN5qNXBVDwRTdgWh9Zcv7FVLZASUi2dElQPjS/HLbS0FV1UHQ8aW
         OgFkSV6JLxyykhd6AQLrfeBrZHr1SII8BiJufjjQ7a1/qurciwJB0KNXv0h9BioVcJEU
         VZBA==
X-Gm-Message-State: AOAM5328SRGxMkt0IxSQzEIeukrQJ96dKAE7VlUF91mpHONqt6Z0kAf7
        D33LFZSxZzB598icwv9iSBVjbOdHV5H/xw==
X-Google-Smtp-Source: ABdhPJxOJxLH0k+NYgL/gZZay3TD8usN0M3v38xulQG6vrzDfVbMLeJqSD5vM9SYupv5OVjwrtmE2Q==
X-Received: by 2002:a17:90a:6347:: with SMTP id v7mr19240246pjs.209.1620965146039;
        Thu, 13 May 2021 21:05:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:53a7:2faa:e07b:6134? ([2601:647:4000:d7:53a7:2faa:e07b:6134])
        by smtp.gmail.com with ESMTPSA id f13sm3129849pfa.207.2021.05.13.21.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 21:05:45 -0700 (PDT)
Subject: Re: [PATCH v1 6/6] scsi: ufs: Update the fast abort path in
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
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
 <1620885319-15151-8-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a124700a-e507-e593-d6f5-2da452f3ae7e@acm.org>
Date:   Thu, 13 May 2021 21:05:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1620885319-15151-8-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 10:55 PM, Can Guo wrote:
> If PM requests fail during runtime suspend/resume, RPM framework saves the
> error to dev->power.runtime_error. Before the runtime_error gets cleared,
> runtime PM on this specific device won't work again, leaving the device
> in either suspended or active state permanently.
> 
> When task abort happens to a PM request sent during runtime suspend/resume,
> even if it can be successfully aborted, RPM framework anyways saves the
> (TIMEOUT) error. But we want more and we can do better - let error handling
> recover and clear the runtime_error. So, let PM requests take the fast
> abort path in ufshcd_abort().

The only RQF_PM requests I know of are START STOP UNIT and SYNCHRONIZE
CACHE. Are there devices for which these commands can time out or do
these commands perhaps only time out as the result of error injection?

> -	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
> +	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN ||
> +	    (cmd->request->rq_flags & RQF_PM)) {

Which are the RQF_PM commands that are not sent to a WLUN? Are these
START STOP UNIT and SYNCHRONIZE CACHE only?

Thanks,

Bart.

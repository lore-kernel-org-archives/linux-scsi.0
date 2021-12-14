Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BD2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 04:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhLNE5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 23:57:35 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:38635 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhLNE5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 23:57:34 -0500
Received: by mail-pj1-f47.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so16255629pju.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2021 20:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kkIWdnahLKDzpJwevwHjndA2Aq1tRoyLTG9GfY2DuMI=;
        b=VrBb5HWVkDmeupUp7/M74PMoUgCooY4YZqAlDoVBidsTJpx4hjMbmfVpUIA8lfbKFU
         37fKIeeiTxLnlbPdADECkeFpclOM/fY50x2gAbEm3sQgQxbOgwUX82L7H77cOQqyls+R
         iHFTPoGpJXwLV3SMMKunFsOga1rjL6E524a59mrYzJ6wuQnQVEYyG0TjPrd9mrp2fh4u
         A5Yhg/NX4U62X1WTMOTpqDI1XwUSPUy58COtW6cJFN78pkMbZSw3y2GBZevQtgVJ/YjN
         FWu2k72cvn7nFJ8+f7mhRYlPxJbXXM2X+XW4v1aD2yPQkndOCt31NaAktOUtcvCgX+Oo
         qUew==
X-Gm-Message-State: AOAM531RDvmrH/ZySOhVZPDbv61pY7srcdOPAUgkww8wPUPYYqowrPlW
        SygqIwUlG5KYSSmPCV02Li4=
X-Google-Smtp-Source: ABdhPJxHzBVxMI0oEbn1lfPUSxxgSFxYNk4nS4oWAUrn3N5pN0j15VOyJaQe1JEaITvkVz5BqahzHg==
X-Received: by 2002:a17:90b:4f86:: with SMTP id qe6mr3195350pjb.224.1639457854167;
        Mon, 13 Dec 2021 20:57:34 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id gk13sm431168pjb.43.2021.12.13.20.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 20:57:33 -0800 (PST)
Message-ID: <701e993f-0b74-204a-1b07-306c13820fa9@acm.org>
Date:   Mon, 13 Dec 2021 20:57:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
Content-Language: en-US
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <20211203231950.193369-17-bvanassche@acm.org> <YbgX5qZ4VFXPqnnr@ripper>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YbgX5qZ4VFXPqnnr@ripper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/21 20:04, Bjorn Andersson wrote:
> Can you please help me understand what I'm missing? Or how you tested
> this?

Hi Bjorn,

Unfortunately I don't have access to a test setup with a Qualcomm 
chipset. Please help verifying whether this patch is sufficient as a fix 
(see also 
https://lore.kernel.org/linux-scsi/101fa5ba-6d74-6c51-aaa2-e6c6d98f6bc7@acm.org/):

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6d692aae67ce..244eddf0caf8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1084,7 +1084,9 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
   	struct scsi_device *sdev;
   	u32 pending = 0;

-	shost_for_each_device(sdev, hba->host)
+	lockdep_assert_held(hba->host->host_lock);
+
+	__shost_for_each_device(sdev, hba->host)
   		pending += sbitmap_weight(&sdev->budget_map);

   	return pending;

Thanks,

Bart.

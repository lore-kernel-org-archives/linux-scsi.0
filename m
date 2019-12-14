Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F481C43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 18:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31A75207FD
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 18:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLNScd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 13:32:33 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34351 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNScd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Dec 2019 13:32:33 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so1230823pgf.1;
        Sat, 14 Dec 2019 10:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZcSU5PLQVwBUi4dUWpFu/eGboJk4k9Zub31FQhbfA8=;
        b=Y7BbXHXQPsDFQRqOBcZx5ijc+QyG1r+lpPL3YgWREMt4vPKU+hKsbrI1Iq0xdu27xr
         UyykTklxefjbe53VAEsXsCiWMBvrncYBRpyTwDBYER5xvOI1bZEE67FAZLgBWPM1gFVq
         etDIgUqaJ8JVYnORqHUHqagMCZ9U5U11wxrlXDmuFigC54pHCS5IBmTIoB5XHrK5NpsN
         5Ofp+zbCRTV4iFf20tSOgBQK37WV8g8FySLzD5yxq7Z9j3OiEqhUyNvjymNMtCKyG999
         yfhJK/qbCuByMuVuV2I34ENlwgp6oPY0bTIlQPqsa8RHph5GIsqjU5HIAFugnqyis+Vs
         ezHg==
X-Gm-Message-State: APjAAAXswRCC3W4y5aro2+AiV/M+G5ucUSNX0jNAUGt+BXw0WOmOXteQ
        JNZAgIFFx66drDQg5/F53REgeKoah7E=
X-Google-Smtp-Source: APXvYqxBqQLywmZ1VKTYBYJucMFNEsiqxTyeM+bEDCOBIWuq3o6OEtZmn6tzAUFSpeuzeUCMaZfgxQ==
X-Received: by 2002:a65:6815:: with SMTP id l21mr6696564pgt.283.1576348352324;
        Sat, 14 Dec 2019 10:32:32 -0800 (PST)
Received: from [10.234.191.77] ([73.93.155.125])
        by smtp.gmail.com with ESMTPSA id u18sm16198958pgn.9.2019.12.14.10.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 10:32:31 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
Date:   Sat, 14 Dec 2019 10:32:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1576328616-30404-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/19 8:03 AM, Can Guo wrote:
> In ufshcd_remove(), after SCSI host is removed, put it once so that its
> resources can be released.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b5966fa..a86b0fd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>   	ufs_bsg_remove(hba);
>   	ufs_sysfs_remove_nodes(hba->dev);
>   	scsi_remove_host(hba->host);
> +	scsi_host_put(hba->host);
>   	/* disable interrupts */
>   	ufshcd_disable_intr(hba, hba->intr_mask);
>   	ufshcd_hba_stop(hba, true);

Hi Can,

The UFS driver may queue work asynchronously and that asynchronous work 
may refer to the SCSI host, e.g. ufshcd_err_handler(). Is it guaranteed 
that all that asynchronous work has finished before scsi_host_put() is 
called?

Thanks,

Bart.

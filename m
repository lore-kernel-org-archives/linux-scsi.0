Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8FACA9ECB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 14:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F4BF2086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 14:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="QhveXalE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfJaOoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:44:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44635 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfJaOoc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 10:44:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id e10so4179926pgd.11
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2019 07:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=1cvzT62rXtl7s6MS3zw7YxenpIrJIg2/+FrUbg3dqsY=;
        b=QhveXalEOr4KorjfyrZ+vci5ycjHVDwoYkdT5N6M8Iwq3+j0+PNd5XU1Nhd1vmFUCO
         rW4RmDWlX9FHbKVght0taZibXxkFaWaeiM3/YrmED6SnWhJloLnNXTq5wUr/4uKiFmlm
         hEsSxFrz+bHzAt58UXwOBAnOxKDu9QERukDMBEFWEyaj9JXdZwZETfoJU8gQ8a7uD4Ug
         qZNyAHvXZ0O3jrlMvGml0r6kti8sCEA+1UMbnsIIbQnJ8wCxVHFz1bRTZp2WLlZ2ttb3
         TdYiF8iGg9EiMHZEiP51qIYDB1Yl4+G4eVCN0VHB1RHcwuvnmSPlyH5t18d2dP0kFrp4
         ReLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1cvzT62rXtl7s6MS3zw7YxenpIrJIg2/+FrUbg3dqsY=;
        b=gTLJpL5UmeclXqplqN8hwU+pqYDdzHuOLDYZ9LGuTqrEcUMRp4wPmmhDqZKBF8zaFT
         Tvk8GI1iW6FTs/pY6PtXXKXX+LqlmkG4TH3hJduw8IzUQkJtUdCW2F5n8Mj9sMjN1Azl
         STpU2GiefsGAhEIf9P3ZdyF7miOkeNOd+1F5x2MrJ3URn5nsslzkUsO0j8DruU3vezS8
         cgjQ7cFAUONXb32QL3iOA3JKYtClJT9QRu3cwvIo4xijjWdHpDesviOUeByhm548IU3s
         RXgHv08f8JQe4G8nrnHmuPN0QPFgirO0oUtVwl809y08Zd1s+uCiNfIB/PGDk2vjdyeB
         iaDw==
X-Gm-Message-State: APjAAAU+E2UD71QBtseo8YYZ727Maj+1w/mRbGuKcYXG9nTjVPL66KU7
        aGZPoEZVarKQibut6j7YJWqUYA==
X-Google-Smtp-Source: APXvYqwhC//2V2zHsxlYey9aR2Up5MT6+Pr7SpTTM5kOUqKfXagw9qnRzuuqHWTWoPfTuFf752NjnQ==
X-Received: by 2002:a63:7b5c:: with SMTP id k28mr3249911pgn.442.1572533071743;
        Thu, 31 Oct 2019 07:44:31 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id f189sm7236743pgc.94.2019.10.31.07.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 07:44:31 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting host
 controller
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <61b83149-e89b-bb4c-d747-a4c596c8eede@android.com>
Date:   Thu, 31 Oct 2019 07:44:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571804009-29787-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/19 9:13 PM, Can Guo wrote:
> Some UFS host controllers need their specific implementations of resetting
> to get them into a good state. Provide a new vops to allow the platform
> driver to implement this own reset operation.
>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
>   drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>   2 files changed, 26 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c28c144..161e3c4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3859,6 +3859,14 @@ static int ufshcd_link_recovery(struct ufs_hba *hba)
>   	ufshcd_set_eh_in_progress(hba);
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> +	ret = ufshcd_vops_full_reset(hba);
> +	if (ret)
> +		dev_warn(hba->dev, "%s: full reset returned %d\n",
> +				  __func__, ret);
> +
> +	/* Reset the attached device */
> +	ufshcd_vops_device_reset(hba);
> +
>   	ret = ufshcd_host_reset_and_restore(hba);
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);

In all your cases, especially after this adjustment, 
ufshcd_vops_full_reset is called blindly (+error checking message) 
before ufshcd_vops_device_reset. What about dropping the .full_reset 
(should really have been called .hw_reset or .host_reset) addition to 
the vops, just adding ufshcd_vops_device_reset call here before 
ufshcd_host_reset_and_restore, and in the driver folding the 
ufshcd_vops_full_reset code into the .device_reset handler?

Would that be workable? It would be simpler if so.

I can see a desire for the heads up 
(ufshcd_vops_full_reset+)ufshcd_vops_device_reset calls before 
ufshcd_host_reset_and_restore because that function will spin 10 seconds 
waiting for a response from a standardized register, that itself could 
be hardware locked up requiring product specific reset procedures. But 
if that is the case, then what about all the other calls to 
ufshcd_host_reset_and_restore in this file that are not provided the 
heads up? My guess is that the host device only demonstrated issues in 
the ufshcd_link_recovery handling path? Are you sure this is the only 
path that tickles the controller into a hardware lockup state?

Sincerely -- Mark Salyzyn


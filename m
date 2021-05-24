Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339B9C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 16:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07CF560FDA
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 16:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhEXQpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 12:45:07 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:51779 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhEXQpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 12:45:06 -0400
Received: by mail-pj1-f42.google.com with SMTP id k5so15162003pjj.1;
        Mon, 24 May 2021 09:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18LZXFfoeDIVMuTxHOTE3u1Zu0pBl9ruKcbI+eZVKgw=;
        b=LiDMQh+3pFWRhf6l8O2/n0NzO6ShOoL/V2FEHRyMrcEt2DB6k93WjVuGw/QYDx9uxh
         OUP/Z1qz5Oa9/QWwc8ScqXm+UFRIkYKhCT3V/6hE0G2FC7l4m6VKRE3kgE+p9EC+FOAU
         uzd5Tpz2w8vpFHqvzwqE7AGy/6m6qG3wJu79wICNdok6/xXbty9mEaaoIbzZ1hiCS5OH
         fI5NE2CMxYMsPoujlDwo1I4fJy0DFeAkirrAnDVBtRxKLu1h9hE/Q6Qe+8Iy2H0T6STE
         xbpJ2B3BfJvu+SFdTEUTmKKvx/kuNsNyzYkIjrixVyRTm3iIcFCFvjMo59m5vP4jucFf
         4zOw==
X-Gm-Message-State: AOAM5326cmKqU3qzogpcIY/2JrFeu1VMZh16cH+wpnu2xiRPT/4Sa1J1
        FBm1T3OWB0VwrjB+QaerDhABto9c226QLw==
X-Google-Smtp-Source: ABdhPJzbuEt7mw5dQ2nu47tOpado4CKVsUmeMgDk3KNpOe/15B5KWczr7Y90zL+1H7OckSHPOWWq6A==
X-Received: by 2002:a17:90b:4d11:: with SMTP id mw17mr25705564pjb.229.1621874617779;
        Mon, 24 May 2021 09:43:37 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u10sm12417795pfl.123.2021.05.24.09.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 09:43:37 -0700 (PDT)
Subject: Re: [PATCH v1 1/3] scsi: ufs: Remove a redundant command completion
 logic in error handler
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
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5e1ba70b-7cdd-a677-28b2-f0a441773969@acm.org>
Date:   Mon, 24 May 2021 09:43:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1621845419-14194-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 1:36 AM, Can Guo wrote:
> ufshcd_host_reset_and_restore() anyways completes all pending requests
> before starts re-probing, so there is no need to complete the command on
> the highest bit in tr_doorbell in advance.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d543864..c4b37d2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6123,19 +6123,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>  do_reset:
>  	/* Fatal errors need reset */
>  	if (needs_reset) {
> -		unsigned long max_doorbells = (1UL << hba->nutrs) - 1;
> -
> -		/*
> -		 * ufshcd_reset_and_restore() does the link reinitialization
> -		 * which will need atleast one empty doorbell slot to send the
> -		 * device management commands (NOP and query commands).
> -		 * If there is no slot empty at this moment then free up last
> -		 * slot forcefully.
> -		 */
> -		if (hba->outstanding_reqs == max_doorbells)
> -			__ufshcd_transfer_req_compl(hba,
> -						    (1UL << (hba->nutrs - 1)));
> -
>  		hba->force_reset = false;
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  		err = ufshcd_reset_and_restore(hba);
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

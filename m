Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D531CA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 18:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7478F20663
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 18:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cFmQQmfl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436810AbfJXSPg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 14:15:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46964 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408089AbfJXSPf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 14:15:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id n15so16349788wrw.13
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 11:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=J2ir4XLA19BNjmSyUtsG7BoFC3h+5yshsn0Pcu0yv9s=;
        b=cFmQQmflpmhWqyGTh8Xwv4h3dqDANp/ERbzTV8iFVRmpZnjl2ZfcmBXbDFpSEKLcuj
         7Kao2lLXFHNA/kztMlJghYNUCGzKUwW0AqH/BCf1aWkFxJOhSa/tRMwGjYS7ydpgm70R
         23CAgIZgW7kH4aZR00iqNWeD9ICZ7uXD5IeWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=J2ir4XLA19BNjmSyUtsG7BoFC3h+5yshsn0Pcu0yv9s=;
        b=EuO7K8372Tad2+YT2IWiiWsA+jYAxg10VI0EuUkDeB6FI9qbsue5c4S1f+QTnn2tMo
         PAB6aFbMzxHk1ztbEC/1dSC7JziBDcC9DYDWn0FdpU3ngPY6bLHP+6mr7Jt/Dn0dIMbk
         WMd6wluwY5CrofqaPXgfYbTxROc5VBYGNZRw3/6U3VR7XHLFsKjoJldQ2Zlk6yRs6Xnc
         vnLzJsifjuIMb828Vh4dHm/29E8zR04cSSM60GYrR/KH7hyMv2JA7yJ8eHj82TSYEQsp
         y0SOPfyzZat2noLx4ctnaMEPYOGUx0r1yPSiKB0gY0L5V+WLa9UysgsgmRPc/lDgjqCG
         9MlA==
X-Gm-Message-State: APjAAAUO8MvznLXKEVfFJtUL4xB1Bm5Kg2XRIDVmV4U4Iao5tCMv4l3X
        8jTu53NDAka9KvfOPhKHbxTO/A==
X-Google-Smtp-Source: APXvYqxbtmW8aM8LOaqQPAafbInsxvQYZGbhtuk5G4fyhXOLOuM665cIJOMPyoQgbh/yOLZBwxOwnw==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr4255462wrp.182.1571940933431;
        Thu, 24 Oct 2019 11:15:33 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d199sm3602260wmd.35.2019.10.24.11.15.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 11:15:32 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: lpfc_nvmet.c: Fix Use plain integer as NULL
 pointer
To:     Saurav Girepunje <saurav.girepunje@gmail.com>,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
References: <20191024030857.GA12097@saurav>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <c08db818-8c35-e4a0-2ff3-53820075d859@broadcom.com>
Date:   Thu, 24 Oct 2019 11:15:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024030857.GA12097@saurav>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 10/23/2019 8:09 PM, Saurav Girepunje wrote:
> Replace assignment of 0 to pointer with NULL assignment.
>
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index faa596f9e861..f6ebfe05224c 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -3364,7 +3364,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
>   	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
>   	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
>   	abts_wqeq->wqe_cmpl = lpfc_nvmet_sol_fcp_abort_cmp;
> -	abts_wqeq->iocb_cmpl = 0;
> +	abts_wqeq->iocb_cmpl = NULL;
>   	abts_wqeq->iocb_flag |= LPFC_IO_NVME;
>   	abts_wqeq->context2 = ctxp;
>   	abts_wqeq->vport = phba->pport;
> @@ -3499,7 +3499,7 @@ lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *phba,
>   
>   	spin_lock_irqsave(&phba->hbalock, flags);
>   	abts_wqeq->wqe_cmpl = lpfc_nvmet_xmt_ls_abort_cmp;
> -	abts_wqeq->iocb_cmpl = 0;
> +	abts_wqeq->iocb_cmpl = NULL;
>   	abts_wqeq->iocb_flag |=  LPFC_IO_NVME_LS;
>   	rc = lpfc_sli4_issue_wqe(phba, ctxp->hdwq, abts_wqeq);
>   	spin_unlock_irqrestore(&phba->hbalock, flags);

Thanks

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james


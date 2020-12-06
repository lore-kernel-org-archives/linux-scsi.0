Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F3DC433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 18:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A33522D07
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 18:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgLFSwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 13:52:41 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54126 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgLFSwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 13:52:41 -0500
Received: by mail-pj1-f67.google.com with SMTP id iq13so6065300pjb.3;
        Sun, 06 Dec 2020 10:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d5RbZx996zoMrju4ehznqsHu4HANttELOatNZACZBLQ=;
        b=LyRZm48bx/3ig2nqi8jJb2MHQRD01vrZwRFf17XEVxF61LI6V1BDpFOPwmONtIB65B
         syXhMMIj73Lt1An/UunpPlrEN+ieZNnTaDTyO4aUh1oQOqEKSK1Usm1fnHf5fhDKuP70
         ol0jZQ39AT9xwgHjQsb5MSoV/VQNaFqlUCooEhfFh5/8iqO0yN7yzs3spx7oIJXKhM80
         xTW0ZMQ5veWmwdMgZEDUbAlG1mSpcGLAZCgW2SHYoxtBINRRvLmjo0Tfk3Min5Vh3ep2
         T9DATIia9uJbkODErJ6tTx2CW1viEPhmB1IRE3kOoJMXu+auSoH8BhC1Nxr+1KWYT7bc
         t6Gg==
X-Gm-Message-State: AOAM530l6CqpLNNPc+hjzYT0vdmvNEKGQINg9LcRG6inVFvzK1O7XJRg
        2ZQifCSO53+voGNg9umCO18=
X-Google-Smtp-Source: ABdhPJxehsfXKPDCEMm5tscYXZI0YTdt51xjFmaPCas5BLRz6LhvfTvaHRVG/DaKlVRtVAmi/XFtlg==
X-Received: by 2002:a17:90a:f992:: with SMTP id cq18mr13603043pjb.216.1607280714006;
        Sun, 06 Dec 2020 10:51:54 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c14sm3344914pfp.167.2020.12.06.10.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 10:51:52 -0800 (PST)
Subject: Re: [PATCH v1 1/3] scsi: ufs: Distinguish between query REQ and query
 RSP in query trace
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
References: <20201206164226.6595-1-huobean@gmail.com>
 <20201206164226.6595-2-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <043235b9-e99a-8f7e-69fa-599b94ac2b12@acm.org>
Date:   Sun, 6 Dec 2020 10:51:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201206164226.6595-2-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 8:42 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Currently, in the query completion trace print,  since we use
> hba->lrb[tag].ucd_req_ptr and didn't differentiate UPIU between
> request and response, thus header and transaction-specific field
> in UPIU printed by query trace are identical. This is not very
> practical. As below:
> 
> query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
> query_complete: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> For the failure analysis, we want to understand the real response
> reported by the UFS device, however, the current query trace tells
> us nothing. After this patch, the query trace on the query_send, and
> the above a pair of query_send and query_complete will be:
> 
> query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
> ufshcd_upiu: HDR:36 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 01 00 00 00 00
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ceb562accc39..e10de94adb3f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -321,9 +321,15 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  		const char *str)
>  {
> -	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
> +	struct utp_upiu_req *rq_rsp;
> +
> +	if (!strcmp("query_send", str))
> +		rq_rsp = hba->lrb[tag].ucd_req_ptr;
> +	else
> +		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
>  
> -	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
> +	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
> +			  &rq_rsp->qr);
>  }

Please change the 'str' argument into an enum and let
ufshcd_add_query_upiu_trace() do the enum-to-string conversion. That
will allow to convert the strcmp() call into an integer comparison.

Thanks,

Bart.

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CDFC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 16:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A3D6198E
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 16:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhF1Q7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 12:59:07 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34545 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhF1Q7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 12:59:07 -0400
Received: by mail-pf1-f172.google.com with SMTP id i6so14659194pfq.1;
        Mon, 28 Jun 2021 09:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GfRxaMN2eKFBKbZywqJEXzXKupkpoSlsw/XGm2NWMos=;
        b=LKVS8Y4UxRk5fJw3NrxPbTrou5PiWzuRUKPJ7axBi++RFbfqTCwtSovrhkJVoBoYec
         wrokS6wqFtaKR+PhJxEJwcEQJ13lDtnTjWhZpavCrtX3JTFne7KPcOmMfhsazQ18/16d
         fkV5fZItKRcYz3QJOjmz2XCuBYO1vvuIHWXXT+howzWqScxLAl3nJlYdfVlj1K5Bn+aQ
         KkUZHkrx+T/jFKXK1do5567b6zP8dZYXSqYCDlOt4AbTQtdVpWQo+cCnkC2oje2uJ4cc
         H2fW55Xl9Xo9df5MjV11aJQn8QY20JaAuVtWxbuYreRmSWxTTCi5CzLxe4zp8mi5yL17
         yhxw==
X-Gm-Message-State: AOAM5311TcUvKiY10J5nFWu9KL+AXeWFciw9hG/i7+rsGHroFszEqCW3
        EtlXYZszCCMRXLbgAavPo3Y=
X-Google-Smtp-Source: ABdhPJx+NIiZC8vfphqQWo/3IsSq3kj2SWJcemD4jCoJnQFDKz8DfKJlhhgHAcDjPTW2/aTgBNVlPQ==
X-Received: by 2002:a65:5aca:: with SMTP id d10mr10991753pgt.422.1624899400726;
        Mon, 28 Jun 2021 09:56:40 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u7sm16197677pjd.55.2021.06.28.09.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 09:56:40 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpinto@synopsys.com" <jpinto@synopsys.com>,
        "joe@perches.com" <joe@perches.com>
References: <CGME20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79@epcms2p4>
 <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <41f85bd8-f159-0518-eeb8-05ac814dea9f@acm.org>
Date:   Mon, 28 Jun 2021 09:56:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/27/21 10:58 PM, Keoseong Park wrote:
> Simplify if else statement to return statement,
> and remove code related to CONFIG_SCSI_UFS_DWC that is not in use.
> 
> v1 -> v2
> Remove code related to CONFIG_SCSI_UFS_DWC that is not in use.
> 
> Cc: Joao Pinto <jpinto@synopsys.com>
> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.h | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c98d540ac044..c9faca237290 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -893,16 +893,8 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
>  
>  static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>  {
> -/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
> -#ifndef CONFIG_SCSI_UFS_DWC
> -	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
> -	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
> -		return true;
> -	else
> -		return false;
> -#else
> -return true;
> -#endif
> +	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
> +		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
>  }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

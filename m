Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5467C4332D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D8564F25
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245312AbhCBSwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446121AbhCBNQl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:16:41 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8235BC061221;
        Tue,  2 Mar 2021 05:02:33 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hs11so35089278ejc.1;
        Tue, 02 Mar 2021 05:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=03fMenL1JcVf3REoLCDjJM5wD7/kclW1skBkKJBLspM=;
        b=qyQ8NZko5e0fbSww/SDJz7zYoihVR2YZ+NQ0eET1ITBoQ2gDtVgbSTlwxTR4co/1mM
         rC/nNLykdjjbNcQdwqexR8M8GaZV5bcB5E7yuW3gMmGBoMqFvUMgqswWjt12MJNmog4L
         2+oeC5yXbdnN5P6ttJLvs1zZZrR393kIDwoejSfcS6v+jFL930nP+30Ib8J3UIe2ZJGs
         HWSJl1T/H5c+t7QiBbMPqZ0tgVDmf7kMwtm5Hlibd5qe1SJgZZzHvqKA8IQL910/NsFw
         gPU7FNnVthipk5mGshnygFQ+dj28yCjhUsIW5Bm5pr+eE1m9Gfp9Cr7up60f5nT/j67F
         NCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03fMenL1JcVf3REoLCDjJM5wD7/kclW1skBkKJBLspM=;
        b=jK8iOGkSVgAA14+ozisOSoR3qTDYtowA6rpoQU7StXnE+v1S48sSHipIIvprmPVues
         A3RAFrOsJ7uduq+IvE7sx4J1VXU4G6jgL6Dm0lQkyzPIG843wh6CRdyMdVrVPwEtuWgL
         gCDEUGhhnLkLBfFxOurlnZVhDuHjwM7AGl6HVqNtx+jREaZAzmCYQzJEZHVE7yunjCD9
         FVuoRZ3GJcnu81/Lh+HyaoakUrqMUSJWsmw0yu+lxkSevhXMcS4kBSVRb/9Y+racMYOH
         gwcKmiageO0f2CwoNGl75GS2TWg1tEUBrH8EwcAylCj0Ou+3FytF+WOavWoG8svfkkPP
         4uVg==
X-Gm-Message-State: AOAM532wIHuNmFakz2JB86UVVvox+zXvb/+Xgj/BRM/Cbdqf3YbZfBiO
        RRBV1X9pdEnS+X1ssdkTjr0=
X-Google-Smtp-Source: ABdhPJz9gdq9wuFle+WX2DcfIqDowLQm8M9JTLewXzkqXffSR3xEchGQoJyEK8JD36+iUD+rTm2/2w==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr20782239ejc.408.1614690152275;
        Tue, 02 Mar 2021 05:02:32 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id l18sm9486088ejk.86.2021.03.02.05.02.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Mar 2021 05:02:32 -0800 (PST)
Message-ID: <f5cb5a04dd25984c4ddf7713ce0ffbbbbb969ea4.camel@gmail.com>
Subject: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Tue, 02 Mar 2021 14:02:29 +0100
In-Reply-To: <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
References: <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
         <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p5>
         <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-26 at 16:35 +0900, Daejun Park wrote:
> 
> 
>  static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
>  				  struct ufshpb_region *rgn)
>  {
> @@ -1209,6 +1579,16 @@ static void ufshpb_lu_parameter_init(struct
> ufs_hba *hba,
>  	u32 entries_per_rgn;
>  	u64 rgn_mem_size, tmp;
>  
> +	/* for pre_req */
> +	if (hpb_dev_info->max_hpb_single_cmd)
> +		hpb->pre_req_min_tr_len = hpb_dev_info-
> >max_hpb_single_cmd;
> +	else
> +		hpb->pre_req_min_tr_len = HPB_MULTI_CHUNK_LOW;


Here is not correct. according to Spec:

The size is calculated as ( bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD +1 )*4KB.
00h: 4KB
01h: 8KB
02h: 12KB
03h: 16KB
...
FEh: 1020KB
FFh: 1024KB

so, here if hpb_dev_info->max_hpb_single_cmd is 0x00, means 4KB, not
36KB.



> +	hpb->pre_req_max_tr_len = max(HPB_MULTI_CHUNK_HIGH,
> +				      hpb->pre_req_min_tr_len);
> +
> 
>  out:
>  	/* All LUs are initialized */
>  	if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
> @@ -1812,8 +2307,9 @@ void ufshpb_get_geo_info(struct ufs_hba *hba,
> u8 *geo_buf)
>  void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
>  {
>  	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
> -	int version;
> +	int version, ret;
>  	u8 hpb_mode;
> +	u32 max_hpb_sigle_cmd = 0;
>  
>  	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
>  	if (hpb_mode == HPB_HOST_CONTROL) {
> @@ -1824,13 +2320,27 @@ void ufshpb_get_dev_info(struct ufs_hba *hba,
> u8 *desc_buf)
>  	}
>  
>  	version = get_unaligned_be16(desc_buf +
> DEVICE_DESC_PARAM_HPB_VER);
> -	if (version != HPB_SUPPORT_VERSION) {
> +	if ((version != HPB_SUPPORT_VERSION) &&
> +	    (version != HPB_SUPPORT_LEGACY_VERSION)) {
>  		dev_err(hba->dev, "%s: HPB %x version is not
> supported.\n",
>  			__func__, version);
>  		hpb_dev_info->hpb_disabled = true;
>  		return;
>  	}
>  
> +	if (version == HPB_SUPPORT_LEGACY_VERSION)
> +		hpb_dev_info->is_legacy = true;
> +
> +	pm_runtime_get_sync(hba->dev);
> +	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0,
> &max_hpb_sigle_cmd);
> +	pm_runtime_put_sync(hba->dev);
> +
> +	if (ret)
> +		dev_err(hba->dev, "%s: idn: read max size of single hpb
> cmd query request failed",
> +			__func__);
> +	hpb_dev_info->max_hpb_single_cmd = max_hpb_sigle_cmd;
> +

Here you didn't add 1, if you read out the
QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD == 7, means device can support
maximum HPB Data size for using single HPB command is 7+1
((7+1)*4=32KB), not 7.


Bean





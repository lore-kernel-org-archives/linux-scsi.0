Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050C5C001DF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 09:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjHAJFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 05:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjHAJFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 05:05:13 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A92230F7
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 02:03:38 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-686efb9ee3cso5113532b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 02:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690880616; x=1691485416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dl31qmpoVvkSjyLSpZPfwkWIRx8GhdUOBKx/4n/3L7U=;
        b=aV+1dhYFoQbThS/XG6H4CkBcRwxAYBFxA8B3Q+sVquHfgQ5/TDAjK6as3P7Y/6eedr
         dHTCVOlHqZL44kpDUtW2Hq0lmQVvKSe7GTxFwxalpwFrRu+gTUM7mArtdckgfAu6s3L4
         Cgr4edYOU1UYHd3bVI8eNB4vAzAS9/eE3pFEGbDJrCnamnLFC807pss2LyoN9DQLuDaf
         P2ceYyYr89Vy6nwgELd2tGgt7O8VYmSBPUriTwWp5XEeKMWOtfh989r87GMEJY9FDZnD
         +OtnozrChpUhdiWa44+0CuEo9+j/SsfEmER4y3u/II6LpjFikdLNj8qI54P63YmcykCi
         W6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690880616; x=1691485416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dl31qmpoVvkSjyLSpZPfwkWIRx8GhdUOBKx/4n/3L7U=;
        b=iF8Y50zZ+AqDllfh4TYRqGS8hX44kTv+NAFrzHNuZpgdhSX2p8B5gTZ6i0XhgPKLnM
         LQ1va6fZZ7G3vuL8bbdwWrqodbH1Mwsuo1tQlxiTYvi2CTHMWzjmujOHuCp5LV6UdY2e
         mbe4jddxII7qpkHn02xDFWhV0eFMjNyNJy0OKjdcZy85Swi2oacsfiF5yl6E+EQzpItG
         zHfGvLdrPPDDPtEhc324jUIFCuA7IZa4QuO4PmjE2FGedSeOEw1bw3/Q+I2EL4YIDrVo
         Ed5FTcXnTh7tnOYPLHhbxgCfiqDKIeOMFGYFs4qcUEdIFAkPm4W3f8u8tvi9eE+nF9ES
         xmkA==
X-Gm-Message-State: ABy/qLZBha94it13S0/SD4sGCmUZIVNl8ae31hhylmvHUNsH1CVU31d0
        4ALQ7+KL4MAi0U+rAcc1jfcQMw==
X-Google-Smtp-Source: APBJJlH6oCr2tZeWpewSHACfnDCdQHNervXhutIyQgatxkDxrpBPXL7suSS9iuOmjWItMEsVtIbYsg==
X-Received: by 2002:a05:6a20:a11d:b0:13d:3b4d:e4b4 with SMTP id q29-20020a056a20a11d00b0013d3b4de4b4mr11186875pzk.9.1690880616089;
        Tue, 01 Aug 2023 02:03:36 -0700 (PDT)
Received: from localhost ([122.172.87.195])
        by smtp.gmail.com with ESMTPSA id m8-20020aa78a08000000b00686bbf5c573sm5719659pfa.119.2023.08.01.02.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 02:03:35 -0700 (PDT)
Date:   Tue, 1 Aug 2023 14:33:33 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] scsi: ufs: host: Add support for parsing OPP
Message-ID: <20230801090333.pqqugj4tcarwdl2o@vireshk-i7>
References: <20230731163357.49045-1-manivannan.sadhasivam@linaro.org>
 <20230731163357.49045-5-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731163357.49045-5-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31-07-23, 22:03, Manivannan Sadhasivam wrote:
> +int ufshcd_opp_config_clks(struct device *dev, struct opp_table *opp_table,
> +			   struct dev_pm_opp *opp, void *data,
> +			   bool scaling_down)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct list_head *head = &hba->clk_list_head;
> +	struct ufs_clk_info *clki;
> +	unsigned long freq;
> +	u8 idx = 0;
> +	int ret;
> +
> +	list_for_each_entry(clki, head, list) {
> +		if (!IS_ERR_OR_NULL(clki->clk)) {

NULL is considered as a valid clock AFAIR, so you must only be doing
IS_ERR() here I guess.

-- 
viresh

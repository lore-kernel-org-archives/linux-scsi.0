Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8425C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 13:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbiDYNEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbiDYNEV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 09:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0737F140B0
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 06:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650891674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dg4uWbHMC2p+lHpBaAPXkFLszBBt4tnvhfrbLJtxikU=;
        b=LAL4zz//70aH3rmj+pb6LhPIKPzBPPBJVuaECwxeSR4MShonIY3mRBPvA/PrWaMYbGaNJ2
        urhh8+S54Xyu3HK7kXf/yHSXjQogM7N5njgl8SrUW9U97TziiS5bC3b5kkOaiTrS8nRWfa
        XjjSfMWocaslxf6pvsR6oFaJWNLYIYY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-yLoUudt0OOeG0jNoZWkt6w-1; Mon, 25 Apr 2022 09:01:13 -0400
X-MC-Unique: yLoUudt0OOeG0jNoZWkt6w-1
Received: by mail-qt1-f197.google.com with SMTP id m11-20020ac807cb000000b002f33f7f7d69so7846619qth.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 06:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dg4uWbHMC2p+lHpBaAPXkFLszBBt4tnvhfrbLJtxikU=;
        b=1GLKbV8ekkq/WtXRyAR96Ewvxtx9D1xon3nYBqdk5cw0gviM0sBBxuyRGiGReFwK7J
         hHaTn7SJn7QJsjL49v5bgK1bmOOoPiWgVNsUzu/xktVAQgDTLP0v0H/eTjesSnTb55VO
         t40HAMGMsf33SDEw6DORB/SDbWcgUXHY7JSUZNn7/eb2QdSZl6CTKbmt5H/zfkx+wBBT
         vp57IlCCpxmRnTNlq1m8QtB9nMf5ynFsgZe28p77oAcNg1Nh/4JBYnBE0xKa8MFm7jc+
         D9/FCzf+iXtwiNim8EqiQGqK+MQ/h6TYRntVjOys4Fyoaw6I0uJZVTbPlqZD+Fek6cF3
         154g==
X-Gm-Message-State: AOAM533/QKFpuvsxKAwmkNC+MWWLLRSWeRTEzpxAuKcloZa0VJoDcwZU
        QjyAURS+37godVvLYjSqY+v7mY4QrVYyFtu90BnD92WzyzMWcR1matNTR/CrONNzn5ZhLKHLiZz
        208F1ZDfCIbZdYCrvnW7NUg==
X-Received: by 2002:a37:5c9:0:b0:69f:7096:32df with SMTP id 192-20020a3705c9000000b0069f709632dfmr346354qkf.257.1650891672268;
        Mon, 25 Apr 2022 06:01:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhhv1dQrHygC+XLF+bCT3LS4/h1WyYfCFjZw5aPBiYsYZ4XKDz/S5yo4PgcO9Bem9oTXMezA==
X-Received: by 2002:a37:5c9:0:b0:69f:7096:32df with SMTP id 192-20020a3705c9000000b0069f709632dfmr346287qkf.257.1650891671643;
        Mon, 25 Apr 2022 06:01:11 -0700 (PDT)
Received: from halaneylaptop (068-184-200-203.res.spectrum.com. [68.184.200.203])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87d04000000b002e06b4674a1sm6588357qtb.61.2022.04.25.06.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 06:01:11 -0700 (PDT)
Date:   Mon, 25 Apr 2022 08:01:08 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        linux-arm-msm@vger.kernel.org, quic_asutoshd@quicinc.com,
        quic_cang@quicinc.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org
Subject: Re: [PATCH v2 2/5] scsi: ufs: qcom: Simplify handling of
 devm_phy_get()
Message-ID: <20220425130108.2noffk7p6lyakcec@halaneylaptop>
References: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
 <20220423140245.394092-3-manivannan.sadhasivam@linaro.org>
 <YmQYZ8l+QOsz11ld@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmQYZ8l+QOsz11ld@ripper>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 23, 2022 at 08:16:55AM -0700, Bjorn Andersson wrote:
> On Sat 23 Apr 07:02 PDT 2022, Manivannan Sadhasivam wrote:
> 
> > There is no need to call devm_phy_get() if ACPI is used, so skip it.
> > The "host->generic_phy" pointer should already be NULL due to the kzalloc,
> > so no need to set it NULL again.
> > 
> > Also, don't print the error message in case of -EPROBE_DEFER and return
> > the error code directly.
> > 
> > While at it, also remove the comment that has no relationship with
> > devm_phy_get().
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  drivers/scsi/ufs/ufs-qcom.c | 26 +++++---------------------
> >  1 file changed, 5 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> > index bee81b45299e..6ee33cc0ad09 100644
> > --- a/drivers/scsi/ufs/ufs-qcom.c
> > +++ b/drivers/scsi/ufs/ufs-qcom.c
> > @@ -1022,28 +1022,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
> >  		err = 0;
> >  	}
> >  
> > -	/*
> > -	 * voting/devoting device ref_clk source is time consuming hence
> > -	 * skip devoting it during aggressive clock gating. This clock
> > -	 * will still be gated off during runtime suspend.
> > -	 */
> > -	host->generic_phy = devm_phy_get(dev, "ufsphy");
> > -
> > -	if (host->generic_phy == ERR_PTR(-EPROBE_DEFER)) {
> > -		/*
> > -		 * UFS driver might be probed before the phy driver does.
> > -		 * In that case we would like to return EPROBE_DEFER code.
> > -		 */
> > -		err = -EPROBE_DEFER;
> > -		dev_warn(dev, "%s: required phy device. hasn't probed yet. err = %d\n",
> > -			__func__, err);
> > -		goto out_variant_clear;
> > -	} else if (IS_ERR(host->generic_phy)) {
> > -		if (has_acpi_companion(dev)) {
> > -			host->generic_phy = NULL;
> > -		} else {
> > +	if (!has_acpi_companion(dev)) {
> > +		host->generic_phy = devm_phy_get(dev, "ufsphy");
> > +		if (IS_ERR(host->generic_phy)) {
> >  			err = PTR_ERR(host->generic_phy);
> > -			dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
> > +			if (err != -EPROBE_DEFER)
> > +				dev_err_probe(dev, err, "Failed to get PHY\n");
> 
> I believe the idiomatic form is:
> 			err = dev_err_probe(dev, PTR_ERR(host->generic_phy), "Failed to get PHY\n");
> 
> 
> But as with the previous patch, please remove the condition and you have
> my:
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Regards,
> Bjorn

With the Bjorn's suggested change applied:
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

Thanks,
Andrew

> 
> >  			goto out_variant_clear;
> >  		}
> >  	}
> > -- 
> > 2.25.1
> > 
> 


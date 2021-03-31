Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19309C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 18:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C509B60FF3
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 18:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhCaSUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 14:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbhCaSUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 14:20:03 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6F6C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 11:20:03 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id a8so20866990oic.11
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 11:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eAYTQaJdrmG3cmFWcS3gzQG6ElBG/4MajNjtha7zzDA=;
        b=HmHxGkKMJJmT48PANcI7vkvEJKgi4NyjZN4w3sws11oYxnJf0YVTtgZop08SOhbEIR
         DPJyiK1G6YfLRzn2qhCt8yUUa2dqdGM/BlBASW2XoQUfzcKkbXGrVw9I7HOyCAacoss7
         eMKeljq0jzXnMpK0rPkFzoqZu269qTyUOTrZnZwmWY32Lnn2gylPznHVa/zQID76N3Lp
         48HLfAx/N6v/6kHzAfttzrPfo27hMKmGeSxmB9qdDJJOec/d6unL2h2M9AwsbUbEjds3
         PKb3XXxJGjRzILATvItMlF+qcqiVVtilzbqBfWWnkQ2DeghrwX3vqdflccj2ZpIjxKth
         4u4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eAYTQaJdrmG3cmFWcS3gzQG6ElBG/4MajNjtha7zzDA=;
        b=pSlWC1/OgXG9LhGAQ7CA+ung2k1A1ZtIenZle9Zy9h8Q1l70/tahY9vxfQbs7sSH4N
         Jad24yluV/P6wkOxOIydneN+1nxUoEy8KJi4G8ib8F2oQnSrmlKYRfVcRX8GHJbPnv8y
         F8uZV6MIOx/1Q5Y1tQb6uXCi9n1uyLM/nhf7P0IyF3FXBUxeFpSQUNHvFzhAqQIiVjqW
         J5e8ktqHtOCdHEr5DVFLD4j5MwhoJWyMn6A/6Zhmae5B/RbykWaLEme+rPi/0GGyKA+m
         a5uS4fJMn7WLu1JbjuoVYIM3Er5DTXGoZtRHjz7M5OhXFG6pleADbxprkLs9Ij0lnFVC
         z/bA==
X-Gm-Message-State: AOAM532GlaoswmqilI3bg7Mq7lDeC7AisJFNCdBQYykZMDr9HioOHnu9
        XdYz24tzh6vqNObZIq+1KvPkIg==
X-Google-Smtp-Source: ABdhPJzuRXYiLp8WlYMnlkAlBYIo5JGi/vQ06dRDY7thYOTvYKO/6szX6nOgwusWsQ3B7SbV2E0IhQ==
X-Received: by 2002:aca:ea06:: with SMTP id i6mr3191034oih.82.1617214802531;
        Wed, 31 Mar 2021 11:20:02 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a13sm574760ooj.14.2021.03.31.11.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 11:20:02 -0700 (PDT)
Date:   Wed, 31 Mar 2021 13:19:59 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     nitirawa@codeaurora.org
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, adrian.hunter@intel.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] scsi: ufs-qcom: configure VCC voltage level in
 vendor file
Message-ID: <20210331181959.GL904837@yoga>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
 <1616363857-26760-4-git-send-email-nitirawa@codeaurora.org>
 <20210323152834.GH5254@yoga>
 <f27b4fde8092088ec5dc6232cc4b2318@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27b4fde8092088ec5dc6232cc4b2318@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 24 Mar 16:55 CDT 2021, nitirawa@codeaurora.org wrote:

> On 2021-03-23 20:58, Bjorn Andersson wrote:
> > On Sun 21 Mar 16:57 CDT 2021, Nitin Rawat wrote:
> > 
> > > As a part of vops handler, VCC voltage is updated
> > > as per the ufs device probed after reading the device
> > > descriptor. We follow below steps to configure voltage
> > > level.
> > > 
> > > 1. Set the device to SLEEP state.
> > > 2. Disable the Vcc Regulator.
> > > 3. Set the vcc voltage according to the device type and reenable
> > >    the regulator.
> > > 4. Set the device mode back to ACTIVE.
> > > 
> > 
> > When we discussed this a while back this was described as a requirement
> > from the device specification, you only operate on objects "owned" by
> > ufshcd and you invoke ufshcd operations to perform the actions.
> > 
> > So why is this a ufs-qcom patch and not something in ufshcd?
> > 
> > Regards,
> > Bjorn
> > 
> > > Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
> > > Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
> > > ---
> > >  drivers/scsi/ufs/ufs-qcom.c | 51
> > > +++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 51 insertions(+)
> > > 
> > > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> > > index f97d7b0..ca35f5c 100644
> > > --- a/drivers/scsi/ufs/ufs-qcom.c
> > > +++ b/drivers/scsi/ufs/ufs-qcom.c
> > > @@ -21,6 +21,17 @@
> > >  #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
> > >  	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> > > 
> > > +#define	ANDROID_BOOT_DEV_MAX	30
> > > +static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> > > +
> > > +/* Min and Max VCC voltage values for ufs 2.x and
> > > + * ufs 3.x devices
> > > + */
> > > +#define UFS_3X_VREG_VCC_MIN_UV	2540000 /* uV */
> > > +#define UFS_3X_VREG_VCC_MAX_UV	2700000 /* uV */
> > > +#define UFS_2X_VREG_VCC_MIN_UV	2950000 /* uV */
> > > +#define UFS_2X_VREG_VCC_MAX_UV	2960000 /* uV */
> > > +
> > >  enum {
> > >  	TSTBUS_UAWM,
> > >  	TSTBUS_UARM,
> > > @@ -1293,6 +1304,45 @@ static void
> > > ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
> > >  	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
> > >  }
> > > 
> > > +  /**
> > > +   * ufs_qcom_setup_vcc_regulators - Update VCC voltage
> > > +   * @hba: host controller instance
> > > +   * Update VCC voltage based on UFS device(ufs 2.x or
> > > +   * ufs 3.x probed)
> > > +   */
> > > +static int ufs_qcom_setup_vcc_regulators(struct ufs_hba *hba)
> > > +{
> > > +	struct ufs_dev_info *dev_info = &hba->dev_info;
> > > +	struct ufs_vreg *vreg = hba->vreg_info.vcc;
> > > +	int ret;
> > > +
> > > +	/* Put the device in sleep before lowering VCC level */
> > > +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_SLEEP_PWR_MODE);
> > > +
> > > +	/* Switch off VCC before switching it ON at 2.5v or 2.96v */
> > > +	ret = ufshcd_disable_vreg(hba->dev, vreg);
> > > +
> > > +	/* add ~2ms delay before renabling VCC at lower voltage */
> > > +	usleep_range(2000, 2100);
> > > +
> > > +	/* set VCC min and max voltage according to ufs device type */
> > > +	if (dev_info->wspecversion >= 0x300) {
> > > +		vreg->min_uV = UFS_3X_VREG_VCC_MIN_UV;
> > > +		vreg->max_uV = UFS_3X_VREG_VCC_MAX_UV;
> > > +	}
> > > +
> > > +	else {
> > > +		vreg->min_uV = UFS_2X_VREG_VCC_MIN_UV;
> > > +		vreg->max_uV = UFS_2X_VREG_VCC_MAX_UV;
> > > +	}
> > > +
> > > +	ret = ufshcd_enable_vreg(hba->dev, vreg);
> > > +
> > > +	/* Bring the device in active now */
> > > +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> > > +	return ret;
> > > +}
> > > +
> > >  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
> > >  {
> > >  	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
> > > @@ -1490,6 +1540,7 @@ static const struct ufs_hba_variant_ops
> > > ufs_hba_qcom_vops = {
> > >  	.device_reset		= ufs_qcom_device_reset,
> > >  	.config_scaling_param = ufs_qcom_config_scaling_param,
> > >  	.program_key		= ufs_qcom_ice_program_key,
> > > +	.setup_vcc_regulators	= ufs_qcom_setup_vcc_regulators,
> > >  };
> > > 
> > >  /**
> > > --
> > > 2.7.4
> > > 
> 
> Hi Bjorn,
> Thanks for your review.
> But As per the earlier discussion regarding handling of vcc voltage
> for platform supporting both ufs 2.x and ufs 3.x , it was finally concluded
> to
> use "vops and let vendors handle it, until specs or someone
> has a better suggestion". Please correct me in case i am wrong.
> 

I was under the impression that this would result in something custom
per platform, but what I'm objecting to now that I see the code is that
this is completely generic.

And the concerns we discussed regarding these regulators being shared
with other devices is not considered in this implementation. But in
practice I don't see how you could support 2.x, 3.x and rail sharing at
the same time.

Regards,
Bjorn

> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2399116.html
> 
> Regards,
> Nitin

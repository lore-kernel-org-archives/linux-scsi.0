Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8FAC4706E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE2B61165
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhDARpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbhDARmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 13:42:43 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B94C00F7F0
        for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2021 08:12:37 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id c24-20020a9d6c980000b02902662e210895so1903886otr.9
        for <linux-scsi@vger.kernel.org>; Thu, 01 Apr 2021 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tTqE/Ky1fv1LrXz3ESekIhjrImO3lS/9eDpjSCLV/dA=;
        b=mkD39DIBsHo55o2F+OMgcNeGzO1SocdX0efVdLUhsmO/H7f7DvVZT4fevmeDXaGfxx
         wfVADYNspNFNjDWj/3kPl81dfmJ0ft2710v408/acG6s2GyPFmk3mY5uw0beiWIfnh1O
         s00QIQOJTX6eK+vwRlpOr1bq3lHpIEkfLh2BrhD5f2Oon/ummCloMdzaYh/Drhtc6CCj
         AmlOabVry5mY0aQxit3q+ExLTRQ+SOqmw1vKS10w1of5yUjlJ4LColNC5v7oX+F370v5
         R8ez4vS5uQ2plC6G3dauS3yUPMgAk8c9D/MFdF398FB0KMOAeaSnoh1LOzSWDgTQVI5y
         03rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tTqE/Ky1fv1LrXz3ESekIhjrImO3lS/9eDpjSCLV/dA=;
        b=Vo62eawzn85DVpuBriJ+IB7tq4LHgmZfibYhHj9pSeRiBumxZbdgBhBu7XogbyXFr7
         hP8g3aujUHtzIszcXaZz4gz3+SsM/tWNZE3dViu7ojyKoDwd4NV4HnU7oeORwr0s5otH
         CDCylcUuFbxCKwYqvI1ixJTGOqsjwFlNKrMR2jKawvj+q202EW4pdMWSWDjyVJ9kk7+D
         3a4quLaJ2gF9nbdmD44VYTe2aIUiv1bIorI3JJDCCPdx5nZY9+rz65WiR7VXK3x3Bsbi
         gNFXkow3hPdSt+OxDz0M/RdU1eHhkg3zwFzCKBkSGGCeP7bxlVRACRsXeRKmyxUyKYON
         Dl1A==
X-Gm-Message-State: AOAM530DemIoZeR0pR4L3fYCUSTv4w04/LCpdKksdYKzQZiyyEj620B3
        +j2tvDScAoaQ/2gqLNL2jM+ibA==
X-Google-Smtp-Source: ABdhPJzZ92r+oustT9ea2xEnOJETO5WzvjglrudhBJeBGatZI0w5tCU8L3w+OGWI0EVpeoxbDWgBBQ==
X-Received: by 2002:a05:6830:4121:: with SMTP id w33mr7104656ott.153.1617289957105;
        Thu, 01 Apr 2021 08:12:37 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id c26sm1230830otm.51.2021.04.01.08.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:12:36 -0700 (PDT)
Date:   Thu, 1 Apr 2021 10:12:34 -0500
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
Message-ID: <20210401151234.GO904837@yoga>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
 <1616363857-26760-4-git-send-email-nitirawa@codeaurora.org>
 <20210323152834.GH5254@yoga>
 <f27b4fde8092088ec5dc6232cc4b2318@codeaurora.org>
 <20210331181959.GL904837@yoga>
 <d9d7d6fb9241bbe48b3f8df5d2c0bc4e@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9d7d6fb9241bbe48b3f8df5d2c0bc4e@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 01 Apr 09:58 CDT 2021, nitirawa@codeaurora.org wrote:

> On 2021-03-31 23:49, Bjorn Andersson wrote:
> > On Wed 24 Mar 16:55 CDT 2021, nitirawa@codeaurora.org wrote:
> > 
> > > On 2021-03-23 20:58, Bjorn Andersson wrote:
> > > > On Sun 21 Mar 16:57 CDT 2021, Nitin Rawat wrote:
> > > >
> > > > > As a part of vops handler, VCC voltage is updated
> > > > > as per the ufs device probed after reading the device
> > > > > descriptor. We follow below steps to configure voltage
> > > > > level.
> > > > >
> > > > > 1. Set the device to SLEEP state.
> > > > > 2. Disable the Vcc Regulator.
> > > > > 3. Set the vcc voltage according to the device type and reenable
> > > > >    the regulator.
> > > > > 4. Set the device mode back to ACTIVE.
> > > > >
> > > >
> > > > When we discussed this a while back this was described as a requirement
> > > > from the device specification, you only operate on objects "owned" by
> > > > ufshcd and you invoke ufshcd operations to perform the actions.
> > > >
> > > > So why is this a ufs-qcom patch and not something in ufshcd?
> > > >
> > > > Regards,
> > > > Bjorn
> > > >
> > > > > Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
> > > > > Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
> > > > > ---
> > > > >  drivers/scsi/ufs/ufs-qcom.c | 51
> > > > > +++++++++++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 51 insertions(+)
> > > > >
> > > > > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> > > > > index f97d7b0..ca35f5c 100644
> > > > > --- a/drivers/scsi/ufs/ufs-qcom.c
> > > > > +++ b/drivers/scsi/ufs/ufs-qcom.c
> > > > > @@ -21,6 +21,17 @@
> > > > >  #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
> > > > >  	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> > > > >
> > > > > +#define	ANDROID_BOOT_DEV_MAX	30
> > > > > +static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> > > > > +
> > > > > +/* Min and Max VCC voltage values for ufs 2.x and
> > > > > + * ufs 3.x devices
> > > > > + */
> > > > > +#define UFS_3X_VREG_VCC_MIN_UV	2540000 /* uV */
> > > > > +#define UFS_3X_VREG_VCC_MAX_UV	2700000 /* uV */
> > > > > +#define UFS_2X_VREG_VCC_MIN_UV	2950000 /* uV */
> > > > > +#define UFS_2X_VREG_VCC_MAX_UV	2960000 /* uV */
> > > > > +
> > > > >  enum {
> > > > >  	TSTBUS_UAWM,
> > > > >  	TSTBUS_UARM,
> > > > > @@ -1293,6 +1304,45 @@ static void
> > > > > ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
> > > > >  	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
> > > > >  }
> > > > >
> > > > > +  /**
> > > > > +   * ufs_qcom_setup_vcc_regulators - Update VCC voltage
> > > > > +   * @hba: host controller instance
> > > > > +   * Update VCC voltage based on UFS device(ufs 2.x or
> > > > > +   * ufs 3.x probed)
> > > > > +   */
> > > > > +static int ufs_qcom_setup_vcc_regulators(struct ufs_hba *hba)
> > > > > +{
> > > > > +	struct ufs_dev_info *dev_info = &hba->dev_info;
> > > > > +	struct ufs_vreg *vreg = hba->vreg_info.vcc;
> > > > > +	int ret;
> > > > > +
> > > > > +	/* Put the device in sleep before lowering VCC level */
> > > > > +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_SLEEP_PWR_MODE);
> > > > > +
> > > > > +	/* Switch off VCC before switching it ON at 2.5v or 2.96v */
> > > > > +	ret = ufshcd_disable_vreg(hba->dev, vreg);
> > > > > +
> > > > > +	/* add ~2ms delay before renabling VCC at lower voltage */
> > > > > +	usleep_range(2000, 2100);
> > > > > +
> > > > > +	/* set VCC min and max voltage according to ufs device type */
> > > > > +	if (dev_info->wspecversion >= 0x300) {
> > > > > +		vreg->min_uV = UFS_3X_VREG_VCC_MIN_UV;
> > > > > +		vreg->max_uV = UFS_3X_VREG_VCC_MAX_UV;
> > > > > +	}
> > > > > +
> > > > > +	else {
> > > > > +		vreg->min_uV = UFS_2X_VREG_VCC_MIN_UV;
> > > > > +		vreg->max_uV = UFS_2X_VREG_VCC_MAX_UV;
> > > > > +	}
> > > > > +
> > > > > +	ret = ufshcd_enable_vreg(hba->dev, vreg);
> > > > > +
> > > > > +	/* Bring the device in active now */
> > > > > +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > >  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
> > > > >  {
> > > > >  	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
> > > > > @@ -1490,6 +1540,7 @@ static const struct ufs_hba_variant_ops
> > > > > ufs_hba_qcom_vops = {
> > > > >  	.device_reset		= ufs_qcom_device_reset,
> > > > >  	.config_scaling_param = ufs_qcom_config_scaling_param,
> > > > >  	.program_key		= ufs_qcom_ice_program_key,
> > > > > +	.setup_vcc_regulators	= ufs_qcom_setup_vcc_regulators,
> > > > >  };
> > > > >
> > > > >  /**
> > > > > --
> > > > > 2.7.4
> > > > >
> > > 
> > > Hi Bjorn,
> > > Thanks for your review.
> > > But As per the earlier discussion regarding handling of vcc voltage
> > > for platform supporting both ufs 2.x and ufs 3.x , it was finally
> > > concluded
> > > to
> > > use "vops and let vendors handle it, until specs or someone
> > > has a better suggestion". Please correct me in case i am wrong.
> > > 
> > 
> > I was under the impression that this would result in something custom
> > per platform, but what I'm objecting to now that I see the code is that
> > this is completely generic.
> > 
> > And the concerns we discussed regarding these regulators being shared
> > with other devices is not considered in this implementation. But in
> > practice I don't see how you could support 2.x, 3.x and rail sharing at
> > the same time.
> > 
> > Regards,
> > Bjorn
> > 
> > > https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2399116.html
> > > 
> > > Regards,
> > > Nitin
> 
> Hi Bjorn,
> Thanks for your feedback.
> Regarding your query for regulator being shared with other device,
> Imho, the soc/pmic designer should share only those device
> with ufs regulator which has the same voltage range (2.4-3.6v).
> If that is not considered by the pmic designer,
> wouldn't that would be a board design issue ???
> 

It's not only that the rail needs to stay within 2.4-3.6V, depending on
operating mode of this device it either need to be at 2.54-2.7V or
2.95-2.96V depending on wspecversion for this instance.

So either that other device need to be completely flexible in that range
and support the voltage jumping between them without notice, or such
design isn't possible.

And as you say, that would be something that the hardware designers
would need to handle for us.

> And I agree with you that - the code looks generic but
> since the below steps is not part of the specs,
> I had to keep it in vendor specific file for which I
> had to export few api from ufshcd.c to use in vendor
> specific files.
> 
> 1. Set the device to SLEEP state.
> 2. Disable the Vcc Regulator.
> 3. Set the vcc voltage according to the device type and reenable
>    the regulator.
> 4. Set the device mode back to ACTIVE.
> 
> Please correct me if my understanding is not correct.
> 

Are you saying that steps 1 to 4 here are not defined in the
specification and therefor Qualcomm specific? Do we expect other vendors
to not follow this sequence, or do they simply not have these voltage
constraints?

And again, isn't this the voltage for the attached UFS device? (Rather
than a Qualcomm thing)

Regards,
Bjorn

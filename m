Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8991CC43611
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A0C6115C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhDARvl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:51:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:54345 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235918AbhDARp6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Apr 2021 13:45:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617299158; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=h4rZg3loUeGrmbFwxfTS2JVTeQDuJOSIq3TF+e6Bitg=;
 b=mzBkgQ2dp5VvvBObYKAcC+WW99ZpMWc11gThslaVPcNRJKDqOzKEYZ3U7wZ8I9/8z5X/ZhB/
 EdV2MeR/RBFLLKUcgHnvRFFKGiLer7THhQy/t5WkQj7Q73X8BE0DjYfOcpkkDb8kRGoEpPGr
 GRlMn5X9G4eZPYLFIxewMNSe5+E=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6065dfb38807bcde1d6d50a2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Apr 2021 14:58:59
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6F000C433ED; Thu,  1 Apr 2021 14:58:59 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ED74DC433C6;
        Thu,  1 Apr 2021 14:58:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 01 Apr 2021 20:28:57 +0530
From:   nitirawa@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, adrian.hunter@intel.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] scsi: ufs-qcom: configure VCC voltage level in
 vendor file
In-Reply-To: <20210331181959.GL904837@yoga>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
 <1616363857-26760-4-git-send-email-nitirawa@codeaurora.org>
 <20210323152834.GH5254@yoga>
 <f27b4fde8092088ec5dc6232cc4b2318@codeaurora.org>
 <20210331181959.GL904837@yoga>
Message-ID: <d9d7d6fb9241bbe48b3f8df5d2c0bc4e@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 23:49, Bjorn Andersson wrote:
> On Wed 24 Mar 16:55 CDT 2021, nitirawa@codeaurora.org wrote:
> 
>> On 2021-03-23 20:58, Bjorn Andersson wrote:
>> > On Sun 21 Mar 16:57 CDT 2021, Nitin Rawat wrote:
>> >
>> > > As a part of vops handler, VCC voltage is updated
>> > > as per the ufs device probed after reading the device
>> > > descriptor. We follow below steps to configure voltage
>> > > level.
>> > >
>> > > 1. Set the device to SLEEP state.
>> > > 2. Disable the Vcc Regulator.
>> > > 3. Set the vcc voltage according to the device type and reenable
>> > >    the regulator.
>> > > 4. Set the device mode back to ACTIVE.
>> > >
>> >
>> > When we discussed this a while back this was described as a requirement
>> > from the device specification, you only operate on objects "owned" by
>> > ufshcd and you invoke ufshcd operations to perform the actions.
>> >
>> > So why is this a ufs-qcom patch and not something in ufshcd?
>> >
>> > Regards,
>> > Bjorn
>> >
>> > > Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
>> > > Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
>> > > ---
>> > >  drivers/scsi/ufs/ufs-qcom.c | 51
>> > > +++++++++++++++++++++++++++++++++++++++++++++
>> > >  1 file changed, 51 insertions(+)
>> > >
>> > > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> > > index f97d7b0..ca35f5c 100644
>> > > --- a/drivers/scsi/ufs/ufs-qcom.c
>> > > +++ b/drivers/scsi/ufs/ufs-qcom.c
>> > > @@ -21,6 +21,17 @@
>> > >  #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
>> > >  	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
>> > >
>> > > +#define	ANDROID_BOOT_DEV_MAX	30
>> > > +static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
>> > > +
>> > > +/* Min and Max VCC voltage values for ufs 2.x and
>> > > + * ufs 3.x devices
>> > > + */
>> > > +#define UFS_3X_VREG_VCC_MIN_UV	2540000 /* uV */
>> > > +#define UFS_3X_VREG_VCC_MAX_UV	2700000 /* uV */
>> > > +#define UFS_2X_VREG_VCC_MIN_UV	2950000 /* uV */
>> > > +#define UFS_2X_VREG_VCC_MAX_UV	2960000 /* uV */
>> > > +
>> > >  enum {
>> > >  	TSTBUS_UAWM,
>> > >  	TSTBUS_UARM,
>> > > @@ -1293,6 +1304,45 @@ static void
>> > > ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
>> > >  	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
>> > >  }
>> > >
>> > > +  /**
>> > > +   * ufs_qcom_setup_vcc_regulators - Update VCC voltage
>> > > +   * @hba: host controller instance
>> > > +   * Update VCC voltage based on UFS device(ufs 2.x or
>> > > +   * ufs 3.x probed)
>> > > +   */
>> > > +static int ufs_qcom_setup_vcc_regulators(struct ufs_hba *hba)
>> > > +{
>> > > +	struct ufs_dev_info *dev_info = &hba->dev_info;
>> > > +	struct ufs_vreg *vreg = hba->vreg_info.vcc;
>> > > +	int ret;
>> > > +
>> > > +	/* Put the device in sleep before lowering VCC level */
>> > > +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_SLEEP_PWR_MODE);
>> > > +
>> > > +	/* Switch off VCC before switching it ON at 2.5v or 2.96v */
>> > > +	ret = ufshcd_disable_vreg(hba->dev, vreg);
>> > > +
>> > > +	/* add ~2ms delay before renabling VCC at lower voltage */
>> > > +	usleep_range(2000, 2100);
>> > > +
>> > > +	/* set VCC min and max voltage according to ufs device type */
>> > > +	if (dev_info->wspecversion >= 0x300) {
>> > > +		vreg->min_uV = UFS_3X_VREG_VCC_MIN_UV;
>> > > +		vreg->max_uV = UFS_3X_VREG_VCC_MAX_UV;
>> > > +	}
>> > > +
>> > > +	else {
>> > > +		vreg->min_uV = UFS_2X_VREG_VCC_MIN_UV;
>> > > +		vreg->max_uV = UFS_2X_VREG_VCC_MAX_UV;
>> > > +	}
>> > > +
>> > > +	ret = ufshcd_enable_vreg(hba->dev, vreg);
>> > > +
>> > > +	/* Bring the device in active now */
>> > > +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
>> > > +	return ret;
>> > > +}
>> > > +
>> > >  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
>> > >  {
>> > >  	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
>> > > @@ -1490,6 +1540,7 @@ static const struct ufs_hba_variant_ops
>> > > ufs_hba_qcom_vops = {
>> > >  	.device_reset		= ufs_qcom_device_reset,
>> > >  	.config_scaling_param = ufs_qcom_config_scaling_param,
>> > >  	.program_key		= ufs_qcom_ice_program_key,
>> > > +	.setup_vcc_regulators	= ufs_qcom_setup_vcc_regulators,
>> > >  };
>> > >
>> > >  /**
>> > > --
>> > > 2.7.4
>> > >
>> 
>> Hi Bjorn,
>> Thanks for your review.
>> But As per the earlier discussion regarding handling of vcc voltage
>> for platform supporting both ufs 2.x and ufs 3.x , it was finally 
>> concluded
>> to
>> use "vops and let vendors handle it, until specs or someone
>> has a better suggestion". Please correct me in case i am wrong.
>> 
> 
> I was under the impression that this would result in something custom
> per platform, but what I'm objecting to now that I see the code is that
> this is completely generic.
> 
> And the concerns we discussed regarding these regulators being shared
> with other devices is not considered in this implementation. But in
> practice I don't see how you could support 2.x, 3.x and rail sharing at
> the same time.
> 
> Regards,
> Bjorn
> 
>> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2399116.html
>> 
>> Regards,
>> Nitin

Hi Bjorn,
Thanks for your feedback.
Regarding your query for regulator being shared with other device,
Imho, the soc/pmic designer should share only those device
with ufs regulator which has the same voltage range (2.4-3.6v).
If that is not considered by the pmic designer,
wouldn't that would be a board design issue ???

And I agree with you that - the code looks generic but
since the below steps is not part of the specs,
I had to keep it in vendor specific file for which I
had to export few api from ufshcd.c to use in vendor
specific files.

1. Set the device to SLEEP state.
2. Disable the Vcc Regulator.
3. Set the vcc voltage according to the device type and reenable
    the regulator.
4. Set the device mode back to ACTIVE.

Please correct me if my understanding is not correct.

Regards,
Nitin

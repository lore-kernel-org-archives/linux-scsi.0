Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD32C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 16:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7282064EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 16:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhBIQQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbhBIQQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 11:16:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76010C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  9 Feb 2021 08:15:43 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id cl8so1844937pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Feb 2021 08:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MhXA89n1bxUyXeNRJNMGftQdsPaGvYx11C+sBGzQQD8=;
        b=qhiU1dhna2OD2E5pRw/PYB451RLcY2RJTBgafbP1Am/WB28MUKGWvazY2cKc/Iiju3
         zPrKSqx9P15nuzmsTYDJpYjzetB+OwaB/peSh2lDKwQI/BOWeKwTEpDjFCYCpkJ8jEsr
         IbaDsfepEMGQ8oqnuaXLupt04B/0WSUKdPxkqpzkfW3O08mXmkDqwh24DWac7HGzEys4
         BQIyXpferU1XSQh50yrqpxddAx8dJkFzA2uxXPj+PVUldg60znj/YsC/ZEmfprZnIJK/
         kHLCBUX9LpxE/tfuZhaB6A+nn7ZYF3x8PUW9KgyFqPMcr2eYC8oWuYm4fwcXKAqBgLfB
         30Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MhXA89n1bxUyXeNRJNMGftQdsPaGvYx11C+sBGzQQD8=;
        b=UhIkwW0qX6qqMLTVXPLarwo4TEOKW8c1cZWrXgz2byeQtSl1l/te2qcxuT8wRjFAtm
         g5GVTt/M5UjDHVYXGyYovowbLxKKVDxkdi3iqCh6wA9tYC6aHoQRejhCBmuoU7ow4eE1
         d2oFEQdT95RFYHIaJpyLfD4kIGsMu7dcgh/8Iq9nyh6BRG7xocDkNUkNPH/t4256Q5kZ
         llHG9pUmCOy9TpOZvuPAmipK3tdCz2gq879xFGwYFGd8u6abJnXSYYpHIkw0B4mRKFdP
         9yKyeBkchZCgHzW+dBkadzIjkrnRp447QZcJ/kcwAuXuKDfdNxNn3gk6DVpK22I2fTyh
         ytCQ==
X-Gm-Message-State: AOAM533PWhakPV/AJpavdp5aOfjXG+1Xe40poWp4unJTb61SajykydkI
        zaN8AAr33f9Yo8JGODphzHJfsA==
X-Google-Smtp-Source: ABdhPJyj+l7zQdy1VX6ypzcwe5uCFJaEtPBprZrGhr7s3Oopdckhkzvn2l+bE1Mo1eFjazDiPoh8Tg==
X-Received: by 2002:a17:90b:358f:: with SMTP id mm15mr4752586pjb.13.1612887342631;
        Tue, 09 Feb 2021 08:15:42 -0800 (PST)
Received: from google.com ([2401:fa00:fc:202:3418:6a0e:6bbd:7f00])
        by smtp.gmail.com with ESMTPSA id p2sm23516264pgl.19.2021.02.09.08.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 08:15:41 -0800 (PST)
Date:   Wed, 10 Feb 2021 00:15:32 +0800
From:   Leo Liou <leoliou@google.com>
To:     Bean Huo <huobean@gmail.com>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com,
        essuuj@gmail.com, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: create a hook for unipro dme control
Message-ID: <YCK1JMsC3D1BqU6Q@google.com>
References: <20210208125628.2758665-1-leoliou@google.com>
 <4cea12c5c2a1c42ab6c1b96b82489cc59da39517.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cea12c5c2a1c42ab6c1b96b82489cc59da39517.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 08, 2021 at 09:42:05PM +0100, Bean Huo wrote:
> On Mon, 2021-02-08 at 20:56 +0800, Leo Liou wrote:
> > Based on ufshci spec, it defines that "Offset C0h to FFh" belong
> > to vendor specific. If cpu vendor doesn't support these commands, it
> > makes the dme errors:
> > 
> > ufs: dme-set: attr-id 0xd041 val 0x1fff failed 0 retries
> > ufs: dme-set: attr-id 0xd042 val 0xffff failed 0 retries
> > ufs: dme-set: attr-id 0xd043 val 0x7fff failed 0 retries
> > 
> 
> Hi Leo
> "Offset C0h to FFh" registers belong to the UFSHCI, but the attribtes
> you moved belong to "DME Attributes for DME_SET-based High Level Power
> Mode Control" defined in Unipro and doesen't say they are vendor-
> defined attributes. How these two are associated?
> 
> Kind regards,
> Bean
> 
Hi Bean,

Thanks for your remind:)
I thought the vendor means cpu-related, and it's incorrect.
Actually it doesn't make sense.
I'll check the error with unipro layer.

Best Regards,
Leo

> > Create a hook for unipro vendor-specific commands.
> > 
> > Signed-off-by: Leo Liou <leoliou@google.com>
> > ---
> >  drivers/scsi/ufs/ufs-qcom.c | 11 +++++++++++
> >  drivers/scsi/ufs/ufs-qcom.h |  5 +++++
> >  drivers/scsi/ufs/ufshcd.c   |  7 +------
> >  drivers/scsi/ufs/ufshcd.h   |  8 ++++++++
> >  drivers/scsi/ufs/unipro.h   |  4 ----
> >  5 files changed, 25 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-
> > qcom.c
> > index 2206b1e4b774..f2a925587029 100644
> > --- a/drivers/scsi/ufs/ufs-qcom.c
> > +++ b/drivers/scsi/ufs/ufs-qcom.c
> > @@ -759,6 +759,16 @@ static int ufs_qcom_pwr_change_notify(struct
> > ufs_hba *hba,
> >  	return ret;
> >  }
> >  
> > +static void ufs_qcom_unipro_dme_set(struct ufs_hba *hba)
> > +{
> > +	ufshcd_dme_set(hba,
> > UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
> > +		       DL_FC0ProtectionTimeOutVal_Default);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
> > +		       DL_TC0ReplayTimeOutVal_Default);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
> > +		       DL_AFC0ReqTimeOutVal_Default);
> > +}
> > +
> >  static int ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba
> > *hba)
> >  {
> >  	int err;
> > @@ -1469,6 +1479,7 @@ static const struct ufs_hba_variant_ops
> > ufs_hba_qcom_vops = {
> >  	.hce_enable_notify      = ufs_qcom_hce_enable_notify,
> >  	.link_startup_notify    = ufs_qcom_link_startup_notify,
> >  	.pwr_change_notify	= ufs_qcom_pwr_change_notify,
> > +	.unipro_dme_set		= ufs_qcom_unipro_dme_set,
> >  	.apply_dev_quirks	= ufs_qcom_apply_dev_quirks,
> >  	.suspend		= ufs_qcom_suspend,
> >  	.resume			= ufs_qcom_resume,
> > diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-
> > qcom.h
> > index 8208e3a3ef59..83db97caaa1b 100644
> > --- a/drivers/scsi/ufs/ufs-qcom.h
> > +++ b/drivers/scsi/ufs/ufs-qcom.h
> > @@ -124,6 +124,11 @@ enum {
> >  /* QUniPro Vendor specific attributes */
> >  #define PA_VS_CONFIG_REG1	0x9000
> >  #define DME_VS_CORE_CLK_CTRL	0xD002
> > +
> > +#define DME_LocalFC0ProtectionTimeOutVal	0xD041
> > +#define DME_LocalTC0ReplayTimeOutVal		0xD042
> > +#define DME_LocalAFC0ReqTimeOutVal		0xD043
> > +
> >  /* bit and mask definitions for DME_VS_CORE_CLK_CTRL attribute */
> >  #define DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT		BIT(8)
> >  #define DME_VS_CORE_CLK_CTRL_MAX_CORE_CLK_1US_CYCLES_MASK	0xFF
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index fb32d122f2e3..8ba2ce8c5d0c 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -4231,12 +4231,7 @@ static int ufshcd_change_power_mode(struct
> > ufs_hba *hba,
> >  	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
> >  			DL_AFC1ReqTimeOutVal_Default);
> >  
> > -	ufshcd_dme_set(hba,
> > UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
> > -			DL_FC0ProtectionTimeOutVal_Default);
> > -	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
> > -			DL_TC0ReplayTimeOutVal_Default);
> > -	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
> > -			DL_AFC0ReqTimeOutVal_Default);
> > +	ufshcd_vops_unipro_dme_set(hba);
> >  
> >  	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
> >  			| pwr_mode->pwr_tx);
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index aa9ea3552323..b8c90bee7503 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -311,6 +311,7 @@ struct ufs_pwr_mode_info {
> >   * @pwr_change_notify: called before and after a power mode change
> >   *			is carried out to allow vendor spesific
> > capabilities
> >   *			to be set.
> > + * @unipro_dme_set: called when vendor speicific control is needed
> >   * @setup_xfer_req: called before any transfer request is issued
> >   *                  to set some things
> >   * @setup_task_mgmt: called before any task management request is
> > issued
> > @@ -342,6 +343,7 @@ struct ufs_hba_variant_ops {
> >  					enum ufs_notify_change_status
> > status,
> >  					struct ufs_pa_layer_attr *,
> >  					struct ufs_pa_layer_attr *);
> > +	void    (*unipro_dme_set)(struct ufs_hba *hba);
> >  	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
> >  	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
> >  	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
> > @@ -1161,6 +1163,12 @@ static inline int
> > ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
> >  	return -ENOTSUPP;
> >  }
> >  
> > +static inline void ufshcd_vops_unipro_dme_set(struct ufs_hba *hba)
> > +{
> > +	if (hba->vops && hba->vops->unipro_dme_set)
> > +		return hba->vops->unipro_dme_set(hba);
> > +}
> > +
> >  static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba,
> > int tag,
> >  					bool is_scsi_cmd)
> >  {
> > diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> > index 8e9e486a4f7b..224162e5afd8 100644
> > --- a/drivers/scsi/ufs/unipro.h
> > +++ b/drivers/scsi/ufs/unipro.h
> > @@ -192,10 +192,6 @@
> >  #define DL_TC1ReplayTimeOutVal_Default		65535
> >  #define DL_AFC1ReqTimeOutVal_Default		32767
> >  
> > -#define DME_LocalFC0ProtectionTimeOutVal	0xD041
> > -#define DME_LocalTC0ReplayTimeOutVal		0xD042
> > -#define DME_LocalAFC0ReqTimeOutVal		0xD043
> > -
> >  /* PA power modes */
> >  enum {
> >  	FAST_MODE	= 1,
> 

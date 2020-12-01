Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498ADC64E90
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 03:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8F820725
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 03:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CC+1DKp5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgLADeP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbgLADeP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 22:34:15 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AEAC0613D2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 19:33:29 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id i7so85139oot.8
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 19:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zbGZDw8W0Yk78H+DHPLlM669ACPRLsB5AJaN9EhyYqE=;
        b=CC+1DKp5n085S6zVrdwoMatT6OvtGAbS5SNElzSMEQkBJJI00Z7fJU5q+WmVvTMb4f
         rEgewZg7TMjuZJFeqP8AdfPXJbhLkBs1u8aMJrrC2gUVIpriIEpRNIaS3VGb/N8E5d7r
         uvFa4F1iTbOPi43DMkNv4pOX/YS0d/3+B7pCYJAfpKhUDWRQvXPHmiL03IbnT+Q5y49m
         0ZTxtpcdXIYIzEAGQv6eLPQOqCnT4FD+H1Irb+8LczVkDXMPr80K5cJZfMEiSN9SDB9c
         GsJu+wK3IQIQJS2FNHNpv0qz79RKMDoxPt4JdNLzuuEdDzRTycx9bGy7VI7Ecy/85vuF
         UaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zbGZDw8W0Yk78H+DHPLlM669ACPRLsB5AJaN9EhyYqE=;
        b=pOF3dfqb6pkJzwTJ104rUsbEs75hLUnNLr9p3Wt+2vwumjWSkg9EiYFMxknH1zl5IY
         k9FXQ5C39Mvo0qDzdNz5pSnNb9xMst9rWdFMBnSN91FKMMAZEz8QpayuGA+mTKJ5UyRp
         NcjdUDARRjVddWTfueTA4L1+5ioUokvqGJRR0NcrqcPgXKXmJ6w/H/vovP+JpQ/YZCCo
         XqCPM8v7itgkpXErt5a0l2p2Xu4d6efBvRYI/Ij2H2Qfq+1Gk34RmYo5UNddiLplMQfP
         4UTzLH4aKN1j1kpea59x9/3w7QYU6YeZZK5i5Xy1kJswxjOlNb+0lerMCdzZc2GzOigS
         PBEw==
X-Gm-Message-State: AOAM5337R1tQFUm8Kd2lPB69aBE3nG0Ej99Z/EmpaRHGk6/W9Au2oqWR
        OnWqrP22genXR/atoLEfLnTdWBsCIHfh9A==
X-Google-Smtp-Source: ABdhPJxNssokUuLVtjUfT9m8TbTNvdyLwVWLyfORPuxGE9i928NM72s7PiS2rzNzQqpWeBukYw0ZbA==
X-Received: by 2002:a4a:d495:: with SMTP id o21mr683262oos.12.1606793608837;
        Mon, 30 Nov 2020 19:33:28 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id h8sm126858oom.41.2020.11.30.19.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 19:33:28 -0800 (PST)
Date:   Mon, 30 Nov 2020 21:33:26 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, beanhuo@micron.com,
        cang@codeaurora.org, matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, chaotian.jing@mediatek.com,
        cc.chou@mediatek.com, jiajie.hao@mediatek.com,
        alice.chao@mediatek.com
Subject: Re: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC voltage
 values
Message-ID: <X8W5hiEqBydoU1xO@builder.lan>
References: <20201130091610.2752-1-stanley.chu@mediatek.com>
 <568660cd-80e6-1b8f-d426-4614c9159ff4@codeaurora.org>
 <X8V83T+Tx6teNLOR@builder.lan>
 <4335d590-0506-d920-8e7f-f0f0372780f9@codeaurora.org>
 <X8WwPs1MPg64FEp8@builder.lan>
 <bf6e03ee-95ab-4768-7ce5-7f196ab6db60@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf6e03ee-95ab-4768-7ce5-7f196ab6db60@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon 30 Nov 21:19 CST 2020, Asutosh Das (asd) wrote:

> On 11/30/2020 6:53 PM, Bjorn Andersson wrote:
> > On Mon 30 Nov 17:54 CST 2020, Asutosh Das (asd) wrote:
> > 
> > > On 11/30/2020 3:14 PM, Bjorn Andersson wrote:
> > > > On Mon 30 Nov 16:51 CST 2020, Asutosh Das (asd) wrote:
> > > > 
> > > > > On 11/30/2020 1:16 AM, Stanley Chu wrote:
> > > > > > UFS specficication allows different VCC configurations for UFS devices,
> > > > > > for example,
> > > > > > 	(1). 2.70V - 3.60V (By default)
> > > > > > 	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
> > > > > >                              device tree)
> > > > > > 	(3). 2.40V - 2.70V (Supported since UFS 3.x)
> > > > > > 
> > > > > > With the introduction of UFS 3.x products, an issue is happening that
> > > > > > UFS driver will use wrong "min_uV/max_uV" configuration to toggle VCC
> > > > > > regulator on UFU 3.x products with VCC configuration (3) used.
> > > > > > 
> > > > > > To solve this issue, we simply remove pre-defined initial VCC voltage
> > > > > > values in UFS driver with below reasons,
> > > > > > 
> > > > > > 1. UFS specifications do not define how to detect the VCC configuration
> > > > > >       supported by attached device.
> > > > > > 
> > > > > > 2. Device tree already supports standard regulator properties.
> > > > > > 
> > > > > > Therefore VCC voltage shall be defined correctly in device tree, and
> > > > > > shall not be changed by UFS driver. What UFS driver needs to do is simply
> > > > > > enabling or disabling the VCC regulator only.
> > > > > > 
> > > > > > This is a RFC conceptional patch. Please help review this and feel
> > > > > > free to feedback any ideas. Once this concept is accepted, and then
> > > > > > I would post a more completed patch series to fix this issue.
> > > > > > 
> > > > > > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> > > > > > ---
> > > > > >     drivers/scsi/ufs/ufshcd-pltfrm.c | 10 +---------
> > > > > >     1 file changed, 1 insertion(+), 9 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> > > > > > index a6f76399b3ae..3965be03c136 100644
> > > > > > --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> > > > > > +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> > > > > > @@ -133,15 +133,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
> > > > > >     		vreg->max_uA = 0;
> > > > > >     	}
> > > > > > -	if (!strcmp(name, "vcc")) {
> > > > > > -		if (of_property_read_bool(np, "vcc-supply-1p8")) {
> > > > > > -			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
> > > > > > -			vreg->max_uV = UFS_VREG_VCC_1P8_MAX_UV;
> > > > > > -		} else {
> > > > > > -			vreg->min_uV = UFS_VREG_VCC_MIN_UV;
> > > > > > -			vreg->max_uV = UFS_VREG_VCC_MAX_UV;
> > > > > > -		}
> > > > > > -	} else if (!strcmp(name, "vccq")) {
> > > > > > +	if (!strcmp(name, "vccq")) {
> > > > > >     		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
> > > > > >     		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
> > > > > >     	} else if (!strcmp(name, "vccq2")) {
> > > > > > 
> > > > > 
> > > > > Hi Stanley
> > > > > 
> > > > > Thanks for the patch. Bao (nguyenb) was also working towards something
> > > > > similar.
> > > > > Would it be possible for you to take into account the scenario in which the
> > > > > same platform supports both 2.x and 3.x UFS devices?
> > > > > 
> > > > > These've different voltage requirements, 2.4v-3.6v.
> > > > > I'm not sure if standard dts regulator properties can support this.
> > > > > 
> > > > 
> > > > What is the actual voltage requirement for these devices and how does
> > > > the software know what voltage to pick in this range?
> > > > 
> > > > Regards,
> > > > Bjorn
> > > > 
> > > > > -asd
> > > > > 
> > > > > 
> > > > > -- 
> > > > > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> > > > > Linux Foundation Collaborative Project
> > > 
> > > For platforms that support both 2.x (2.7v-3.6v) and 3.x (2.4v-2.7v), the
> > > voltage requirements (Vcc) are 2.4v-3.6v. The software initializes the ufs
> > > device at 2.95v & reads the version and if the device is 3.x, it may do the
> > > following:
> > > - Set the device power mode to SLEEP
> > > - Disable the Vcc
> > > - Enable the Vcc and set it to 2.5v
> > > - Set the device power mode to ACTIVE
> > > 
> > > All of the above may be done at HS-G1 & moved to max supported gear based on
> > > the device version, perhaps?
> > > 
> > > Am open to other ideas though.
> > > 
> > 
> > But that means that for a board where we don't know (don't want to know)
> > if we have a 2.x or 3.x device we need to set:
> > 
> >    regulator-min-microvolt = <2.4V>
> >    regulator-max-microvolt = <3.6V>
> > 
> > And the 2.5V and the two ranges should be hard coded into the ufshcd (in
> > particular if they come from the specification).
> > 
> > For devices with only 2.x or 3.x devices, regulator-{min,max}-microvolt
> > should be adjusted accordingly.
> > 
> > Note that driving the regulators outside these ranges will either damage
> > the hardware or cause it to misbehave, so these values should be defined
> > in the board.dts anyways.
> > 
> > Also note that regulator_set_voltage(2.4V, 3.6V) won't give you "a
> > voltage between 2.4V and 3.6V, it will most likely give either 2.4V or
> > any more specific voltage that we've specified in the board file because
> > the regulator happens to be shared with some other consumer and changing
> > it in runtime would be bad.
> > 
> > Regards,
> > Bjorn
> > 
> 
> Understood.
> I also understand that assumptions on the regulator limits in the driver is
> a bad idea. I'm not sure how it's designed, but I should think the
> power-grid design should take care of regulator sharing; if it's being
> shared and the platform supports both 2.x and 3.x. Perhaps, such platforms
> be identified using a dts flag - not sure if that's such a good idea though.
> 

Presumably you can't share vcc with other peripherals, given that the
voltage levels might just change while the device is in use then. As you
say the only way to avoid this is to think these problems through when
designing the power grid.

> I like Stanley's proposal of a vops and let vendors handle it, until specs
> or someone has a better suggestion.
> 

I too think it sounds quite reasonable.

Regards,
Bjorn

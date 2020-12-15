Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6036FC2BB9A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 19:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3269F22B40
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 19:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgLOT5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 14:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLOT5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 14:57:08 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A4DC0617B0;
        Tue, 15 Dec 2020 11:56:27 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw4so29419681ejb.12;
        Tue, 15 Dec 2020 11:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7llLjIqukhexaM6P3uzsRtzcHeGFXmJ3btWwPtFpC8=;
        b=NMfK9jPX/CUL9vuin1R4cgxj2dLIkSRTiBCLGH2+sVxD+YGKTh7sn4LV/THdDqQMPw
         i2DwBc4GZPoht1a8mVkmNRn4zeOCiTQyfB3WUHnNqIg0Uq6hlGvNsSu4UmFKFqFSCIvg
         CQCSJ3lkJLmW6FYRX+iANcSOCI9JPIANnmCqnrg+XyaJrLY2oWh4EsSBZDkfduhMADAt
         JG9QWWRrIDAuiXNcUOmtB9c3p9AdBcsrGCwIXqI8lta/Lmw08IWNghAwSTTl2NWKI7Av
         LnwPTLucZ7c5KmdllFWcIdE/HPJXFrOr6938z5B2DYBDjOIKSXC3a2RpBHsGfReNXKpv
         VN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h7llLjIqukhexaM6P3uzsRtzcHeGFXmJ3btWwPtFpC8=;
        b=GAK44uzn0Oy9y7iuIwSaagLYFWz+QN/BIL7egfOY62fRARkAVddUMAw0E+PUbjL3Vy
         Bz36N/sdZdTC3e3nPCE5t5Hqz5P57lb4arxneuK/xBlLRb7dnw8hkejKJ9MHTNzes/CJ
         32wwGFo6qOTRZdG3NWR8xw9VlSOtBcHba4VULHZjjwpc5DWlhgbBwUEs2bjZXnCD4OSt
         yk1WJLIlF+0D7+sCyIrfTyis2uU6J8sXTFxbPfJtcVg5ehlBnJwB0KovOxd2hvvAAytC
         1r40UBbR9yotFELXr8Xzwz9cI6SEprhV+hK/6erJSlD2BBpYut5FgRWoYusGDFj5DeQu
         pFWw==
X-Gm-Message-State: AOAM533xSZLfrlzX5sYETn5tmT+JJNvwTRyrEdnADngcpEvOJBmbuX5p
        ooKBhxQtYYzdYgx1FQddRKo=
X-Google-Smtp-Source: ABdhPJyasmOMsF35ZElg1o5hLIdXcmFKi48nidSeARBcBqRjoZhApccNBJrUWuy9iPFKyTNiLVzUmQ==
X-Received: by 2002:a17:906:94d4:: with SMTP id d20mr8313357ejy.475.1608062186101;
        Tue, 15 Dec 2020 11:56:26 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id z24sm19204048edr.9.2020.12.15.11.56.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 11:56:25 -0800 (PST)
Message-ID: <f5c930c3e30f3279f5920d673f6d5bc169e6cfa3.camel@gmail.com>
Subject: Re: [PATCH v4 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Dec 2020 20:56:24 +0100
In-Reply-To: <X9iQoIpL48yQyr7D@kroah.com>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-2-huobean@gmail.com> <X9iQoIpL48yQyr7D@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Greg k-h,

> >  
> > +static ssize_t wb_on_show(struct device *dev, struct
> > device_attribute *attr,
> > +			  char *buf)
> > +{
> > +	struct ufs_hba *hba = dev_get_drvdata(dev);
> > +
> > +	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->wb_enabled);
> 
> Please just use sysfs_emit().

thanks, will be changed in next version.
> 
> > +}
> > +
> > +static ssize_t wb_on_store(struct device *dev, struct
> > device_attribute *attr,
> > +			   const char *buf, size_t count)
> > +{
> > +	struct ufs_hba *hba = dev_get_drvdata(dev);
> > +	unsigned int wb_enable;
> > +	ssize_t res;
> > +
> > +	if (ufshcd_is_clkscaling_supported(hba)) {
> > +		/*
> > +		 * If the platform supports
> > UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
> > +		 * turn WB on/off will be done while clock scaling
> > up/down.
> > +		 */
> > +		dev_warn(dev, "To control WB through wb_on is not
> > allowed!\n");
> > +		return -EOPNOTSUPP;
> > +	}
> > +	if (!ufshcd_is_wb_allowed(hba))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (kstrtouint(buf, 0, &wb_enable))
> > +		return -EINVAL;
> > +
> > +	if (wb_enable != 0 && wb_enable != 1)
> > +		return -EINVAL;
> > +
> > +	pm_runtime_get_sync(hba->dev);
> > +	res = ufshcd_wb_ctrl(hba, wb_enable);
> > +	pm_runtime_put_sync(hba->dev);
> > +
> > +	return res < 0 ? res : count;
> > +}
> 
> Where is the new Documentation/ABI/ update for this new sysfs file
> you
> are adding?
> 

It is missing, and will add it.

thanks.
Bean



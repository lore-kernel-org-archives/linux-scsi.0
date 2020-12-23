Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FF9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B14222247F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgLWVwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 16:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLWVwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 16:52:50 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B65C06179C;
        Wed, 23 Dec 2020 13:52:10 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p22so520883edu.11;
        Wed, 23 Dec 2020 13:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5iLfKkBg3fOu7QXEPh0AZUTyrdm0RzyifElTy/WSKU=;
        b=LjuAQqiNqfCq7YVehPzNBgTMUKQT5mb4oGBW/comqK5jipzCQo6VXlY0ynG/ritRLo
         lG25NJ2FhB4rBowKADLZdMFXEBQaUjfEDupixz1neYsJZ+uXWl3GF8AaFcvW1cVvgYe4
         fDF7D5g+tTWmsu+TWvgXzZ49IsUxcoROXfMjTrEr62aUpJmj2yw/v+x/lMeGDGvUiBz9
         uQQe1bptU33xpOSuT3fV/QDsQTM9GjNiXjebPZA93TR+i7ZvZlrxRvjwfjQ1dGgKWqim
         9Wn7wKkeelmZ+SkFlj3cURcnzK8YDXXaHzksm53jDlhqN/7o0Teyo1fU42Szaogy081M
         Ho6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5iLfKkBg3fOu7QXEPh0AZUTyrdm0RzyifElTy/WSKU=;
        b=WG/LZyczK7kB4B07/lKV5kJ4aCQIgUPbeqrFVK8c1jAkqaLlKDY4XoFgvZCJYTd/+K
         WBGDztLh50OC3djWP8o8WZZIIb+J6XyL4hToW9Q6YjpTkhhoU+2ZF8HKipnppeNQNnDt
         +xvJ6GtK4d56rDAdASVW6tCT021uh6TNK7Vu95k2+E9P2f66qQJ0RL1lkVt+7fuOYifO
         UAwwYgeC9Z00Y/SEcK5jbthRMjWMjMcmRPECBSfly2Fjrs2XhvqdI0LutYoiTFkGD56d
         f7xxDz6vvEs1g26iWajDNyJelisYMdp/qc2ExM4ysjJZ4q+culTi3LfETtltU51v8SYm
         VlGw==
X-Gm-Message-State: AOAM532BgfnqD+wfRFpZ5qtkeaPw/sqQniO7N8lnYKz5jpFClZYdcaXE
        EcJ4gHxhzh8qt8v0H/DR2IY=
X-Google-Smtp-Source: ABdhPJwnehi9G/EDEJRwD0+iawl6Zbk4blCcSfZIHiYOOrzSlIULvG0FWBDWmzuYR9LAYERFW3cPfg==
X-Received: by 2002:a50:ccdb:: with SMTP id b27mr27329078edj.20.1608760329175;
        Wed, 23 Dec 2020 13:52:09 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id i18sm17684002edt.68.2020.12.23.13.52.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Dec 2020 13:52:08 -0800 (PST)
Message-ID: <1fa9d66079d34768f16fb0ef8d8c46ceead7bff6.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Dec 2020 22:52:07 +0100
In-Reply-To: <1608617307.14045.3.camel@mtkswgap22>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-22 at 14:08 +0800, Stanley Chu wrote:
> Hi Bean,
> 
> On Wed, 2020-12-16 at 00:05 +0100, Bean Huo wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Currently UFS WriteBooster driver uses clock scaling up/down to set
> > WB on/off, for the platform which doesn't support
> > UFSHCD_CAP_CLK_SCALING,
> > WB will be always on. Provide a sysfs attribute to enable/disable
> > WB
> > during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable
> > UFS WB.
> > 
> > Reviewed-by: Avri Altman <avri.altman@wdc.com>
> > Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > ---
> >  drivers/scsi/ufs/ufs-sysfs.c | 41
> > ++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufshcd.c    |  3 +--
> >  drivers/scsi/ufs/ufshcd.h    |  2 ++
> >  3 files changed, 44 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-
> > sysfs.c
> > index 08e72b7eef6a..f3ca3d6b82c4 100644
> > --- a/drivers/scsi/ufs/ufs-sysfs.c
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -189,6 +189,45 @@ static ssize_t auto_hibern8_store(struct
> > device *dev,
> >  	return count;
> >  }
> >  
> > +static ssize_t wb_on_show(struct device *dev, struct
> > device_attribute *attr,
> > +			  char *buf)
> > +{
> > +	struct ufs_hba *hba = dev_get_drvdata(dev);
> > +
> > +	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
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
> > +		 * If the platform supports UFSHCD_CAP_CLK_SCALING,
> > turn WB
> > +		 * on/off will be done while clock scaling up/down.
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
> 
> May this operation race with UFS shutdown flow?
> 
> To be more clear, ufshcd_wb_ctrl() here may be executed after host
> clock
> is disabled by shutdown flow?
> 
> If yes, we need to avoid it.
> 
> Thanks,
> Stanley Chu
> 



Hi Stanley and Can

I just sent a new patch to address this issue, let's discusss in that
patch set, I added PM maintainer in the mail as well to help us address
concern about pm_runtime_get_sync and shutdown flow. If that way can
fix this issue, then I will update this patch again.

one note:

I didn't add "if (!ufshcd_is_ufs_dev_active(hba) ||
!ufshcd_is_link_active(hba))" checkup, since sysfs node access is a
normal request as well, UFS driver should give correct response as
possbile as it can, even if device/link is lower power mode.

Thanks,
Bean




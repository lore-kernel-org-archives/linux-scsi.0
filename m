From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V3 10/16] scsi: ufs: add UFS power management support
Date: Tue, 16 Sep 2014 22:44:21 +0900
Message-ID: <CAC5umyjK_JN9rZS6zGfKQm5Drs2LqH3c559ZmXZpQAWzJecH1g@mail.gmail.com>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
	<1410350063-23267-11-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56982 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaIPNoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Sep 2014 09:44:24 -0400
In-Reply-To: <1410350063-23267-11-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>

2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
> +static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
> +                                  int ua)
> +{
> +       int ret = 0;
> +       struct regulator *reg = vreg->reg;
> +       const char *name = vreg->name;
> +
> +       BUG_ON(!vreg);
> +
> +       ret = regulator_set_optimum_mode(reg, ua);
> +       if (ret >= 0) {
> +               /*
> +                * regulator_set_optimum_mode() returns new regulator
> +                * mode upon success.
> +                */
> +               ret = 0;
> +       } else {
> +               dev_err(dev, "%s: %s set optimum mode(ua=%d) failed, err=%d\n",
> +                               __func__, name, ua, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
> +                                        struct ufs_vreg *vreg)
> +{
> +       return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
> +}

If hba->vreg_info.vcc* is NULL as no applicable regulator driver exists,
this function can be called with vreg == NULL through ufshcd_suspend()
-> ufshcd_vreg_set_lpm() -> ufshcd_config_vreg_lpm().  Then this causes
null pointer dereference or hits BUG_ON in ufshcd_config_vreg_load().

> +static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
> +                                        struct ufs_vreg *vreg)
> +{
> +       return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
> +}

Similar issue as above will happen through ufshcd_resume() ->
ufshcd_vreg_set_hpm() -> ufshcd_config_vreg_hpm().  Then this causes
null pointer dereference of vreg->max_uA.

So should these functions be noop when vreg == NULL is passed?

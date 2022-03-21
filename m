Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282B5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 12:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347228AbiCUMPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347105AbiCUMPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 08:15:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157A470930
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 05:13:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id pv16so29490565ejb.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 05:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair;
        h=mime-version:content-transfer-encoding:date:message-id:cc:subject
         :from:to:references:in-reply-to;
        bh=GV9VS8/cK/1/iW9YwiyL0XBgA3aSl8hWOkl7GPVanBI=;
        b=oeeLLGNl+r00f+caIK1YerzgsZi2O6Q8Uy2jH+Lwvodzm/uQ35vn5qgQMf/Cv/Y9uY
         9WsRgsBT0RWbJQQ/RvzwPzMmmET8xQjjSO3su7t4qJYzHQt3PUIsvEqfPxEFpYEXSX2Z
         Iu2iStywN8Kbl8QHmo7hDsFxdjGFlHSZlchAqGIafE07vsa3MiVeTSQzBjHlY4nUGcRy
         Q5+MqIJBySRDEwgiqztxIqc7BVb61MRmlwhIAjbJgGM4mvp8sXZA2CpKvYXOhca9o52k
         hFU+z0JA9op8VQOwt6z5ARTuRooAdTr6lvq50hK7JNUWFDAoHxKsiatP/eIkg/FKNYWt
         IwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date
         :message-id:cc:subject:from:to:references:in-reply-to;
        bh=GV9VS8/cK/1/iW9YwiyL0XBgA3aSl8hWOkl7GPVanBI=;
        b=SjarL7FJEU1XbWY/nXE2Re7lMH+h1swvI6/CQNJKovOgMLwx0KMsTuDe9mLxRrSjEp
         lQYyXROX3207YAIPzHDKbz0sTvV5uKtNsvnkGFM2891qUFPrxGtC8xmJfqaEFCJ0oTg7
         eHKHIVIyv5tmem4WtMkuKYr50vXSgK83rDPaiz1Jyn1z3Vke8dD8hOurgCW+QLXdColG
         tAbkrK5Did0t4nzjHZu/OJEsiRLuUNv8CpfWu09rbHDrcLTyjnhCX29DQ3ZMY5nmb8cN
         MGqu4ScVXY3Yx1UFQjzNcgile/ezG2TQaRF88WoythqB+fi8EVAu/XXIKTWCFJQm7OFJ
         VZyg==
X-Gm-Message-State: AOAM530cMoj4fbsR3bX2lJDMs2BCUMW4TX72ywyd5jlqSah2VJp5Pakf
        yOJS8lixsiwNX8j7yi+EXcoglg==
X-Google-Smtp-Source: ABdhPJzk0Uo89eWPVkk1mZyIW81aW02eGMZ3uIYZYeJU3QCXjfMCisnD4hgsFfd/spI4KZhqel5v5w==
X-Received: by 2002:a17:906:3cb1:b0:6ce:2a97:5ade with SMTP id b17-20020a1709063cb100b006ce2a975ademr20035718ejh.728.1647864837621;
        Mon, 21 Mar 2022 05:13:57 -0700 (PDT)
Received: from localhost (a246182.upc-a.chello.nl. [62.163.246.182])
        by smtp.gmail.com with ESMTPSA id a4-20020a170906274400b006da9456e802sm6941623ejd.102.2022.03.21.05.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 05:13:57 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 21 Mar 2022 13:13:56 +0100
Message-Id: <CIPJBZ36YCV6.2J3QWEURX2EEQ@otso>
Subject: Re: [RFT] ufs: qcom: drop custom Android boot parameters
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Luca Weiss" <luca.weiss@fairphone.com>,
        "Krzysztof Kozlowski" <krzk@kernel.org>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <bjorn.andersson@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220320110616.18355-1-krzk@kernel.org>
 <CIPJ0CT6EQI9.2C0T9KAHDODH2@otso>
In-Reply-To: <CIPJ0CT6EQI9.2C0T9KAHDODH2@otso>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all again,

On Mon Mar 21, 2022 at 12:58 PM CET, Luca Weiss wrote:
> Hi Krzysztof,
>
> On Sun Mar 20, 2022 at 12:06 PM CET, Krzysztof Kozlowski wrote:
> > The QCOM UFS driver requires an androidboot.bootdevice command line
> > argument matching the UFS device name.  If the name is different, it
> > refuses to probe.  Thise androidboot.bootdevice is provided by
> > stock/vendor (from an Android-based device) bootloader.
> >
> > This does not make sense from Linux point of view.  Driver should be
> > able to boot regardless of bootloader.  Driver should not depend on som=
e
> > Android custom environment data.
> >
> > Cc: Luca Weiss <luca.weiss@fairphone.com>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> As expected this makes UFS probe even if the node is named ufs@1d84000
> on my device.
>
> While I don't know why the code existed in the first place, it was added
> back in 2015 with the introduction of the driver, so probably it's just
> some remains from downstream that weren't cleaned up back then.

I went digging a bit and found the original commit from downstream:
https://source.codeaurora.org/quic/la/kernel/msm-3.18/commit/?id=3D15e2c78d=
6a7ec73be941e058671942fd9f72b128

<quote>
Boot device can be either UFS or eMMC which means if eMMC is the boot
device, probing UFS device is not desirable as it's not going to be
used after probing. Kernel command line parameter "android.bootdevice"
tells the kernel about the boot device so look at this boot device
parameter to know whether to probe UFS device or not.
</quote>

Should be safe to remove.

Regards
Luca


>
> With this commit also 6b9afd8f96c6 ("arm64: dts: qcom: sm8250: change
> ufs node name to ufshc") could be reverted (but it would probably make
> more sense to rename all ufshc@ to ufs@ in a new commit).
>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com>
>
> Regards
> Luca
>
> >
> > ---
> >
> > Not tested, please kindly provide tests.
> >
> > See also:
> > https://lore.kernel.org/linux-devicetree/f61abc2b-3ce8-7b1f-3d28-8a4a03=
ec58eb@kernel.org/T/#u
> > ---
> >  drivers/scsi/ufs/ufs-qcom.c | 15 ---------------
> >  1 file changed, 15 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> > index 0d2e950d0865..586c0e567ff9 100644
> > --- a/drivers/scsi/ufs/ufs-qcom.c
> > +++ b/drivers/scsi/ufs/ufs-qcom.c
> > @@ -957,18 +957,6 @@ static const struct reset_control_ops ufs_qcom_res=
et_ops =3D {
> >  	.deassert =3D ufs_qcom_reset_deassert,
> >  };
> > =20
> > -#define	ANDROID_BOOT_DEV_MAX	30
> > -static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> > -
> > -#ifndef MODULE
> > -static int __init get_android_boot_dev(char *str)
> > -{
> > -	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
> > -	return 1;
> > -}
> > -__setup("androidboot.bootdevice=3D", get_android_boot_dev);
> > -#endif
> > -
> >  /**
> >   * ufs_qcom_init - bind phy with controller
> >   * @hba: host controller instance
> > @@ -988,9 +976,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
> >  	struct resource *res;
> >  	struct ufs_clk_info *clki;
> > =20
> > -	if (strlen(android_boot_dev) && strcmp(android_boot_dev, dev_name(dev=
)))
> > -		return -ENODEV;
> > -
> >  	host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> >  	if (!host) {
> >  		err =3D -ENOMEM;
> > --=20
> > 2.32.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63089C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 21:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357430AbiDSVDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 17:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355145AbiDSVDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 17:03:40 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A4531510
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 14:00:57 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s25so22384672edi.13
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 14:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=M1Z3C7Mn2ih5eptkm3dAN35GXuhwncvW7HWj5pAFevk=;
        b=TLmvnaI+O7zO0MysDM/BqwGz6MQ3eUIRRxuepbG31YApWdSE5v9+qtwan83KFH8s+A
         5V+AxsODas8JNeVil7ifIkpJIx9U8+dlvE0h62jZ+9p7JeH35xmvjkngD0gfvOdNuyyW
         rY+llO+gNGobxJlYWbYHgTHYhaxe/7Y4Hgtn4Nf/AbgxpN/8GxtznRJUFdoaJhLvbRui
         2j88yMIwO/Gd88RXrl4hBeGJv/62P6+Iu9UmbDkwOu7NiqJ1l7NtXrtAjpdaFhWkOqc/
         O2N+zkui9efIh1ka1BxeNhIQsUEWcFYh0lmY46Tyt2WFq6ghxlK3EFGIHg3o9Fc1qEhs
         YkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=M1Z3C7Mn2ih5eptkm3dAN35GXuhwncvW7HWj5pAFevk=;
        b=ayHTaqFlg7S8esKHOk5x9+eBg3oHZzvnYmxlC8S4gaqZQCPh2+/PURiNMYI5D6T+do
         3GAESbfVL9HOEynce1GErkoSJsQBkim7ZYTLrV52N1prKOgnAAtO16VvuEM6Ptn7uQEY
         oVUsEczel4mmEbyT9TZdVS+YExaS7fngboL0mYEXuSpeS4gIH74X6ND5hdwv15mAd/vz
         JRWZsXxLyVSaw78THmmmLwMuXuByG+JH5ozZhQbk0Q5kZ5cBXOBIoigAygVGfnH3PUz4
         Y7oSvCcjlqKqGNN0woFG/HTU7Y6aoh2ngkjPwCLiT+K2MY4MVyPVt0P6PDbFw6PN5xkZ
         LvTQ==
X-Gm-Message-State: AOAM5300TeSmwBvgKGoOlTKTh3Qqp3lffn0IXUTqqDbTdu9fmxPwZTZQ
        OLHAOIUef8WiYkkz3qAtzhwF2TRIBoZMRw==
X-Google-Smtp-Source: ABdhPJy43ib+UgGzYCUFp8hsgHRPNswhcU+foHDXoLiU0IXWznJiEk1IDIZF1AryV33tLbl964gNZA==
X-Received: by 2002:a05:6402:845:b0:421:fcb5:55de with SMTP id b5-20020a056402084500b00421fcb555demr19752373edz.124.1650402055576;
        Tue, 19 Apr 2022 14:00:55 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id dn7-20020a17090794c700b006e8b176143bsm5998057ejc.155.2022.04.19.14.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 14:00:55 -0700 (PDT)
Message-ID: <332ee72936e1353439d0daaa55a70e218da913b3.camel@gmail.com>
Subject: Re: [PATCH v2 28/29] scsi: ufs: Move the
 ufs_is_valid_unit_desc_lun() definition
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Date:   Tue, 19 Apr 2022 23:00:54 +0200
In-Reply-To: <20220412181853.3715080-29-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
         <20220412181853.3715080-29-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-04-12 at 11:18 -0700, Bart Van Assche wrote:
> diff --git a/drivers/scsi/ufs/ufshcd-priv.h
> b/drivers/scsi/ufs/ufshcd-priv.h
> index 3fa8ab94e4e1..38bc77d3dbbd 100644
> --- a/drivers/scsi/ufs/ufshcd-priv.h
> +++ b/drivers/scsi/ufs/ufshcd-priv.h
> @@ -276,4 +276,23 @@ static inline int ufshcd_rpm_put(struct ufs_hba
> *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return pm_runtime_put(&hb=
a->ufs_device_wlun->sdev_gendev);
> =C2=A0}
> =C2=A0
> +/**
> + * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit
> descriptor
> + * @dev_info: pointer of instance of struct ufs_dev_info
> + * @lun: LU number to check
> + * @return: true if the lun has a matching unit descriptor, false
> otherwise
> + */
> +static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info
> *dev_info,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0u8 lun, u8 param_offset)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!dev_info || !dev_info->ma=
x_lu_supported) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0pr_err("Max General LU supported by UFS isn't
> initialized\n");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return false;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* WB is available only for th=
e logical unit from 0 to 7 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (param_offset =3D=3D UNIT_D=
ESC_PARAM_WB_BUF_ALLOC_UNITS)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return lun < UFS_UPIU_MAX_WB_LUN_ID;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return lun =3D=3D UFS_UPIU_RPM=
B_WLUN || (lun < dev_info-
> >max_lu_supported);
> +}
> +
> =C2=A0#endif /* _UFSHCD_PRIV_H_ */


You didn't move this function to drivers/ufs/core/ufshcd-priv.h,
It is used by the drivers/ufs/core/ufs-sysfs.c. Otherwise, there is no
problem in compiling.


Kind regards,
Bean




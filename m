Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87107C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 02:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 533622468C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 02:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i35U7Xnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgASCLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 21:11:25 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40217 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgASCLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 21:11:25 -0500
Received: by mail-vs1-f67.google.com with SMTP id g23so17087734vsr.7;
        Sat, 18 Jan 2020 18:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5jFZek4YmlK/Tonf5hyyKNhUMbuRn2M2YPUgwRM9ec=;
        b=i35U7Xnwu3OoIXOaEPbvz0khPSVMrzWyR/5c1MkHDN68RMeckIGN0NrDqzIM7M0rpn
         0AGUsE9ErseOaWgGgzqmI5jM9RBPo9Yyy+t9hxCiEXl09QsFPNwBqTgvUe9PlOTPgnen
         1X+jBZtQYmrQ/4fIKpO+OAlcZdpWdWDFbRCM0fEeOyRPzthfmfG5VqIdn4eCPIxyePwn
         Lk4UGyi/BM2zJ/MBf+LPz2iAGe3HPGI3GVGyEABQuUfucBx0bRgr37Mx8hw0BagzPuIq
         CKwNf9yAesPxUiLsQViQ5dSRwF10LYvYNRcYq1Qrwp9neknpqeMwvnA0bYruZ6wZPkuy
         wIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5jFZek4YmlK/Tonf5hyyKNhUMbuRn2M2YPUgwRM9ec=;
        b=rYJHNMy8aQUuZCuYPWzaMFOqj5ilgrs0D1qmLbOzl+yagX06kr56i9UbtIGgaxJ/fI
         Gtun1u+CxUGvcZeXVgyhr25z03D1DmECxR1/4rBNh/mnMDnZb7vZuDK2chES2QISzBjd
         X0w/HO2uNcKLdKDU0D5x6ARx1BcLyjImNkBlX99A0SxXLopfparx5KBmoaiC4miR6TUK
         +DEVlGTfa5g2UrS9MypJ1zyM/ncgoFpc9RRUwZKaPHcXN9A7pjzHyANlXhHgC8ijXtli
         mzUOOnf8BGm8oXrF3HMZ2TwXCiYGYtCt1ZBoNT5mZmZFZYM6Kh78ZaLHDNJe/ckkIU11
         Whow==
X-Gm-Message-State: APjAAAV28wVBFG6t61LTyqibpXuvjMO9Y2QRP6GRcCeFNDVfmwbIFVDn
        t3+6WE73jheJ+ni7mjvZhZAwcMiM3VvzDMTJkJA=
X-Google-Smtp-Source: APXvYqzO4H83SrNXG/08MHKFDigUokN497fVtN8zHTfA0icJkLIqw4AXDrZmHsEqTm/0mthWQ3FRw5ZM/bys0LJOSFc=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr9211618vsr.136.1579399883734;
 Sat, 18 Jan 2020 18:11:23 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-9-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-9-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:40:47 +0530
Message-ID: <CAGOxZ53rxMZRXU7tFF2yuAHmgXDp4Ho21y5_+BgV55D=Y-SzkA@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] scsi: ufs: Use UFS device indicated maximum LU number
To:     Bean Huo <huobean@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, asutoshd@codeaurora.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 19, 2020 at 5:45 AM Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> According to Jedec standard UFS 3.0 and UFS 2.1 Spec, Maximum number
> of logical units supported by the UFS device is indicated by parameter
> bMaxNumberLU in Geometry Descriptor. This patch is to delete current
> hard code macro definition of UFS_UPIU_MAX_GENERAL_LUN, and switch to
> use device indicated number instead.
>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufs.h       | 12 +++++++++---
>  drivers/scsi/ufs/ufshcd.c    |  4 ++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 720be3f64be7..dbdf8b01abed 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -713,7 +713,7 @@ static ssize_t _pname##_show(struct device *dev,                    \
>         struct scsi_device *sdev = to_scsi_device(dev);                 \
>         struct ufs_hba *hba = shost_priv(sdev->host);                   \
>         u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);                    \
> -       if (!ufs_is_valid_unit_desc_lun(lun))                           \
> +       if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))           \
>                 return -EINVAL;                                         \
>         return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname, \
>                 lun, _duname##_DESC_PARAM##_puname, buf, _size);        \
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index c982bcc94662..dde2eb02f76f 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -63,7 +63,6 @@
>  #define UFS_UPIU_MAX_UNIT_NUM_ID       0x7F
>  #define UFS_MAX_LUNS           (SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
>  #define UFS_UPIU_WLUN_ID       (1 << 7)
> -#define UFS_UPIU_MAX_GENERAL_LUN       8
>
>  /* Well known logical unit id in LUN field of UPIU */
>  enum {
> @@ -539,12 +538,19 @@ struct ufs_dev_info {
>
>  /**
>   * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
> + * @dev_info: pointer of instance of struct ufs_dev_info
>   * @lun: LU number to check
>   * @return: true if the lun has a matching unit descriptor, false otherwise
>   */
> -static inline bool ufs_is_valid_unit_desc_lun(u8 lun)
> +static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
> +               u8 lun)
>  {
> -       return lun == UFS_UPIU_RPMB_WLUN || (lun < UFS_UPIU_MAX_GENERAL_LUN);
> +       if (!dev_info || !dev_info->max_lu_supported) {
> +               pr_err("Max General LU supported by UFS isn't initilized\n");
> +               return false;
> +       }
> +
> +       return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
>  }
>
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dd10558f4d01..bf714221455e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3270,7 +3270,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>          * Unit descriptors are only available for general purpose LUs (LUN id
>          * from 0 to 7) and RPMB Well known LU.
>          */
> -       if (!ufs_is_valid_unit_desc_lun(lun))
> +       if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))
>                 return -EOPNOTSUPP;
>
>         return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
> @@ -4525,7 +4525,7 @@ static int ufshcd_get_lu_wp(struct ufs_hba *hba,
>          * protected so skip reading bLUWriteProtect parameter for
>          * it. For other W-LUs, UNIT DESCRIPTOR is not available.
>          */
> -       else if (lun >= UFS_UPIU_MAX_GENERAL_LUN)
> +       else if (lun >= hba->dev_info.max_lu_supported)
>                 ret = -ENOTSUPP;
>         else
>                 ret = ufshcd_read_unit_desc_param(hba,
> --
> 2.17.1
>


-- 
Regards,
Alim

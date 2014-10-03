From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V6 10/18] scsi: ufs: manually add well known logical units
Date: Sat, 4 Oct 2014 01:16:16 +0900
Message-ID: <CAC5umyhYko5woZhkroi3zm4ow8qp=DeCX62hcr0n3oxw4w8fjw@mail.gmail.com>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
	<1411648356-3883-11-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411648356-3883-11-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

2014-09-25 21:32 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:

> +static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
> +{
> +       int ret = 0;
> +
> +       hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
> +               ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
> +       if (IS_ERR(hba->sdev_ufs_device)) {
> +               ret = PTR_ERR(hba->sdev_ufs_device);
> +               hba->sdev_ufs_device = NULL;
> +               goto out;
> +       }
> +
> +       hba->sdev_boot = __scsi_add_device(hba->host, 0, 0,
> +               ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
> +       if (IS_ERR(hba->sdev_boot)) {
> +               ret = PTR_ERR(hba->sdev_boot);
> +               hba->sdev_boot = NULL;
> +               goto remove_sdev_ufs_device;
> +       }
> +
> +       hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
> +               ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);

These __scsi_add_device() calls for W-LUs increase the module reference
count of ufshcd.ko by three.  But no one calls scsi_device_put() for
these W-LUs, so it is impossible to unload ufshcd.ko.

There are scsi_remove_device() calls for W-LUs in ufshcd_scsi_remove_wlus(),
But these calls do nothing (please see a comment below).

I could fix this issue by putting scsi_device_put() just after each
__scsi_add_device() call.  I'll prepare a patch if I haven't missed
something.

> +       if (IS_ERR(hba->sdev_rpmb)) {
> +               ret = PTR_ERR(hba->sdev_rpmb);
> +               hba->sdev_rpmb = NULL;
> +               goto remove_sdev_boot;
> +       }
> +       goto out;
> +
> +remove_sdev_boot:
> +       scsi_remove_device(hba->sdev_boot);
> +remove_sdev_ufs_device:
> +       scsi_remove_device(hba->sdev_ufs_device);
> +out:
> +       return ret;
> +}
> +
> +/**
> + * ufshcd_scsi_remove_wlus - Removes the W-LUs which were added by
> + *                          ufshcd_scsi_add_wlus()
> + * @hba: per-adapter instance
> + *
> + */
> +static void ufshcd_scsi_remove_wlus(struct ufs_hba *hba)
> +{
> +       if (hba->sdev_ufs_device) {
> +               scsi_remove_device(hba->sdev_ufs_device);
> +               hba->sdev_ufs_device = NULL;
> +       }
> +
> +       if (hba->sdev_boot) {
> +               scsi_remove_device(hba->sdev_boot);
> +               hba->sdev_boot = NULL;
> +       }
> +
> +       if (hba->sdev_rpmb) {
> +               scsi_remove_device(hba->sdev_rpmb);
> +               hba->sdev_rpmb = NULL;
> +       }
> +}

When ufshcd_scsi_remove_wlus() is called in ufshcd_remove(), these
three W-LU devices have already been deleted by scsi_remove_host() which
is called just before ufshcd_scsi_remove_wlus().  The scsi
device state of these W-LU devices is SDEV_DEL at this time, and
scsi_remove_device() does nothing.

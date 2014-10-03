From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V6 10/18] scsi: ufs: manually add well known logical units
Date: Fri, 3 Oct 2014 09:35:30 -0700
Message-ID: <000e01cfdf28$0ca52870$25ef7950$@codeaurora.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>	<1411648356-3883-11-git-send-email-draviv@codeaurora.org> <CAC5umyhYko5woZhkroi3zm4ow8qp=DeCX62hcr0n3oxw4w8fjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyhYko5woZhkroi3zm4ow8qp=DeCX62hcr0n3oxw4w8fjw@mail.gmail.com>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Akinobu Mita' <akinobu.mita@gmail.com>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: 'Jej B' <James.Bottomley@hansenpartnership.com>, 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, 'Santosh Y' <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> I could fix this issue by putting scsi_device_put() just after each __scsi_add_device() call.  I'll prepare a patch if I haven't missed something.

Thanks Akinobu for fixing it. We were always compiling the driver statically in kernel so didn't notice this. Yes, I would be happy to ACK your change. BTW, these patches are already merged into I could fix this issue by putting git://git.infradead.org/users/hch/scsi-queue.git -b drivers-for-3.18, so you may  to base your fix on it.

-----Original Message-----
From: Akinobu Mita [mailto:akinobu.mita@gmail.com] 
Sent: Friday, October 03, 2014 9:16 AM
To: Dolev Raviv
Cc: Jej B; Christoph Hellwig; linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org; linux-arm-msm@vger.kernel.org; Santosh Y; Subhash Jadavani
Subject: Re: [PATCH V6 10/18] scsi: ufs: manually add well known logical units

2014-09-25 21:32 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:

> +static int ufshcd_scsi_add_wlus(struct ufs_hba *hba) {
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
> +               ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), 
> + NULL);

These __scsi_add_device() calls for W-LUs increase the module reference count of ufshcd.ko by three.  But no one calls scsi_device_put() for these W-LUs, so it is impossible to unload ufshcd.ko.

There are scsi_remove_device() calls for W-LUs in ufshcd_scsi_remove_wlus(), But these calls do nothing (please see a comment below).

I could fix this issue by putting scsi_device_put() just after each
__scsi_add_device() call.  I'll prepare a patch if I haven't missed something.

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
> +static void ufshcd_scsi_remove_wlus(struct ufs_hba *hba) {
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

When ufshcd_scsi_remove_wlus() is called in ufshcd_remove(), these three W-LU devices have already been deleted by scsi_remove_host() which is called just before ufshcd_scsi_remove_wlus().  The scsi device state of these W-LU devices is SDEV_DEL at this time, and
scsi_remove_device() does nothing.

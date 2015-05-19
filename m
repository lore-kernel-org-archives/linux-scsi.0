From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: PROBLEM: there exists a wrong return value of function mptfc_probe()
Date: Tue, 19 May 2015 13:41:09 +0530
Message-ID: <CAK=zhgrh4XV-4Avzp9HMj==FqeMBgWTv83zDq8+uyAQ6hcLNTQ@mail.gmail.com>
References: <312bf817.1600c.14d6648959e.Coremail.zy900702@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32844 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbESILL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 04:11:11 -0400
Received: by wicmx19 with SMTP id mx19so107640602wic.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2015 01:11:09 -0700 (PDT)
In-Reply-To: <312bf817.1600c.14d6648959e.Coremail.zy900702@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?5byg54eV?= <zy900702@163.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

Thanks for identifying this bug. To fix this, we will set the error
variable to "-ENOMEM" value as shown below before jumping to the
out_mptfc_probe code section. And we will post these changes patch to
the Upstream ASAP.

ioc->fc_rescan_work_q =3D
                create_singlethread_workqueue(ioc->fc_rescan_work_q_nam=
e);
if (!ioc->fc_rescan_work_q) {
                error =3D -ENOMEM;
                goto out_mptfc_probe;
}

Thanks,
Sreekanth

On Mon, May 18, 2015 at 2:39 PM, =E5=BC=A0=E7=87=95 <zy900702@163.com> =
wrote:
> Summary:
>     there exists a wrong return value of function mptfc_probe().
> Bug Description:
>
> In function mptfc_probe() at drivers/message/fusion/mptfc.c:1177, the=
 call
> to create_singlethread_workqueue() in line 1327 may return a negative=
 error
> code, and thus function mptfc_probe() will return the value of variab=
le
> error. And, the function mptfc_probe() will return 0 at last when it =
runs
> well. However, when the call to create_singlethread_workqueuee() in l=
ine
> 1327 return a negative error code, the value of error is 0. So the fu=
nction
> mptfc_probe() will return 0 to its caller functions when it runs erro=
r
> because of the failing call to create_singlethread_workqueue(), leadi=
ng to a
> wrong return value of function mptfc_probe().
> The related code snippets in mptfc_probe() is as following.
> mptfc_probe @@ drivers/message/fusion/mptfc.c:1177
> 1177mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 1178{
>             ...
> 1315        error =3D scsi_add_host (sh, &ioc->pcidev->dev);
> 1316        if(error) {
> 1317                dprintk(ioc, printk(MYIOC_s_ERR_FMT
> 1318                  "scsi_add_host failed\n", ioc->name));
> 1319                goto out_mptfc_probe;
> 1320        }
> 1321
> 1322        /* initialize workqueue */
> 1323
> 1324         snprintf(ioc->fc_rescan_work_q_name,
>                       sizeof(ioc->fc_rescan_work_q_name),
> 1325                 "mptfc_wq_%d", sh->host_no);
> 1326        ioc->fc_rescan_work_q =3D
> 1327
> create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
> 1328        if (!ioc->fc_rescan_work_q)
> 1329                goto out_mptfc_probe;
>             ...
> 1350out_mptfc_probe:
> 1351
> 1352        mptscsih_remove(pdev);
> 1353        return error;
> 1354}
>
> Generally, when the call to create_singlethread_workqueue() fails, th=
e
> return value of caller functions should be different from another ret=
urn
> value set when the call to create_singlethread_workqueue() succeeds, =
like
> the following codes in another file.
> rds_threads_init @@ net/rds/threads.c:215
>  215int rds_threads_init(void)
>  216{
>  217        rds_wq =3D create_singlethread_workqueue("krdsd");
>  218        if (!rds_wq)
>  219                return -ENOMEM;
>  220
>  221        return 0;
>  222}
>
> Kernel version:
>     3.19.1
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

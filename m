From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] fusion-mptbase: handle failed allocation for workqueue
Date: Thu, 18 Feb 2016 10:00:43 +0100
Message-ID: <20160218090043.GQ18134@c203.arch.suse.de>
References: <1455770459-905-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455770459-905-1-git-send-email-wuninsu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>
Cc: nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 17, 2016 at 11:40:59PM -0500, Insu Yun wrote:
> the failure of ioc->reset_work_q is checked,
> but not ioc->fw_event_q.
>=20
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/message/fusion/mptbase.c | 44 ++++++++++++++++++++++++------=
----------
>  1 file changed, 27 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusio=
n/mptbase.c
> index 5dcc031..53a5015 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1871,9 +1871,8 @@ mpt_attach(struct pci_dev *pdev, const struct p=
ci_device_id *id)
>  	if (!ioc->reset_work_q) {
>  		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
>  		    ioc->name);
> -		pci_release_selected_regions(pdev, ioc->bars);
> -		kfree(ioc);
> -		return -ENOMEM;
> +		r =3D -ENOMEM;
> +		goto err3;
>  	}
> =20
>  	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %=
p\n",
> @@ -1996,24 +1995,16 @@ mpt_attach(struct pci_dev *pdev, const struct=
 pci_device_id *id)
>  	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id=
);
>  	ioc->fw_event_q =3D create_singlethread_workqueue(ioc->fw_event_q_n=
ame);
> =20
> +	if (!ioc->fw_event_q) {
> +		r =3D -ENOMEM;
> +		goto err2;
> +	}
> +
>  	if ((r =3D mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
>  	    CAN_SLEEP)) !=3D 0){
>  		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
>  		    ioc->name, r);
> -
> -		list_del(&ioc->list);
> -		if (ioc->alt_ioc)
> -			ioc->alt_ioc->alt_ioc =3D NULL;
> -		iounmap(ioc->memmap);
> -		if (r !=3D -5)
> -			pci_release_selected_regions(pdev, ioc->bars);
> -
> -		destroy_workqueue(ioc->reset_work_q);
> -		ioc->reset_work_q =3D NULL;
> -
> -		kfree(ioc);
> -		pci_set_drvdata(pdev, NULL);
> -		return r;
> +		goto err1;
>  	}
> =20
>  	/* call per device driver probe entry point */
> @@ -2040,6 +2031,25 @@ mpt_attach(struct pci_dev *pdev, const struct =
pci_device_id *id)
>  			msecs_to_jiffies(MPT_POLLING_INTERVAL));
> =20
>  	return 0;
> +
> +err1:
> +		destroy_workqueue(ioc->fw_event_q);
> +		ioc->fw_event_q =3D NULL;
> +err2::
> +		destroy_workqueue(ioc->reset_work_q);
> +		ioc->reset_work_q =3D NULL;
> +
> +		list_del(&ioc->list);
> +		if (ioc->alt_ioc)
> +			ioc->alt_ioc->alt_ioc =3D NULL;
> +		iounmap(ioc->memmap);
> +		pci_set_drvdata(pdev, NULL);
> +err3:
> +		if (r !=3D -5)
> +			pci_release_selected_regions(pdev, ioc->bars);
> +		kfree(ioc);
> +		return r;
> +
>  }

Please no. Not err1, err2 and err3.

err1 could be "goto destroy_fw_event_q", err2 "destroy_reset_workq", er=
r3
goto "free_ioc".

> =20
>  /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D*/
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] mpt2sas: prevent double free on error path
Date: Thu, 24 Jan 2013 08:51:20 +0100
Message-ID: <87k3r310jr.fsf@nemi.mork.no>
References: <20130123212033.GA15800@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:58886 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3AXHwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2013 02:52:32 -0500
In-Reply-To: <20130123212033.GA15800@logfs.org> (=?utf-8?Q?=22J=C3=B6rn?=
 Engel"'s message of
	"Wed, 23 Jan 2013 16:20:33 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

J=C3=B6rn Engel <joern@logfs.org> writes:

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2=
sas/mpt2sas_scsih.c
> index c6bdc92..43b3a98 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -570,6 +570,18 @@ _scsih_sas_device_find_by_handle(struct MPT2SAS_=
ADAPTER *ioc, u16 handle)
>  	return NULL;
>  }
> =20
> +static void free_sas_device(struct kref *kref)
> +{
> +	struct _sas_device *sas_device =3D container_of(kref, struct _sas_d=
evice,
> +			kref);
> +	kfree(sas_device);
> +}
> +
> +static void put_sas_device(struct _sas_device *sas_device)
> +{
> +	kref_put(&sas_device->kref, free_sas_device);
> +}
> +
>  /**
>   * _scsih_sas_device_remove - remove sas_device from list.
>   * @ioc: per adapter object
> @@ -583,14 +595,19 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER=
 *ioc,
>      struct _sas_device *sas_device)
>  {
>  	unsigned long flags;
> +	int was_on_list =3D 0;
> =20
>  	if (!sas_device)
>  		return;
> =20
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	list_del(&sas_device->list);
> -	kfree(sas_device);
> +	if (!list_empty(&sas_device->list)) {
> +		list_del_init(&sas_device->list);
> +		was_on_list =3D 1;
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	if (was_on_list)
> +		put_sas_device(sas_device);
>  }
> =20


How about the copy of this code in drivers/scsi/mpt3sas/mpt3sas_scsih.c=
?
Is that safe, or does it need fixing as well?


Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

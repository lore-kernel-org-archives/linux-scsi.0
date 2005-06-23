From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] - mptfusion - adding back the spin locks in eh handlers
Date: Thu, 23 Jun 2005 15:04:26 -0400
Message-ID: <42BB07BA.8000802@adaptec.com>
References: <200506231220.08036.Eric.Moore@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:25547 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262676AbVFWTEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 15:04:40 -0400
In-Reply-To: <200506231220.08036.Eric.Moore@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com
Cc: linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On 06/23/05 14:20, Moore, Eric Dean wrote:
> The eh handlers are called with host_lock acquired, and interrupts di=
sabled.
> However fusion waits for completion of task managment request.  With =
these spin locks=20
> removed, the driver is going to hang within the sleep calls.   Someon=
e recently posted=20
> a patch to remove them(don=B4t know who),  and can be found in James =
Bottomely scsi-misc branch. =20

That was Jeff, and I thought those patches made it in already.
They are needed and are a good thing.

	Luben


>=20
> Please apply.
>=20
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
>=20
>=20
> diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusi=
on/mptscsih.c
> --- b/drivers/message/fusion/mptscsih.c	2005-06-23 11:18:44.000000000=
 -0600
> +++ a/drivers/message/fusion/mptscsih.c	2005-05-10 14:27:13.000000000=
 -0600
> @@ -1707,6 +1707,7 @@
>  	MPT_FRAME_HDR	*mf;
>  	u32		 ctx2abort;
>  	int		 scpnt_idx;
> +	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;
> =20
>  	/* If we can't locate our host adapter structure, return FAILED sta=
tus.
>  	 */
> @@ -1754,6 +1755,7 @@
> =20
>  	hd->abortSCpnt =3D SCpnt;
> =20
> +	spin_unlock_irq(host_lock);
>  	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
>  		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
>  		ctx2abort, 2 /* 2 second timeout */)
> @@ -1770,6 +1772,8 @@
>  		hd->tmPending =3D 0;
>  		hd->tmState =3D TM_STATE_NONE;
> =20
> +		spin_lock_irq(host_lock);
> +
>  		/* Unmap the DMA buffers, if any. */
>  		if (SCpnt->use_sg) {
>  			pci_unmap_sg(ioc->pcidev, (struct scatterlist *) SCpnt->request_b=
uffer,
> @@ -1785,6 +1789,7 @@
>  		mpt_free_msg_frame(ioc, mf);
>  		return FAILED;
>  	}
> +	spin_lock_irq(host_lock);
>  	return SUCCESS;
>  }
> =20
> @@ -1801,6 +1806,7 @@
>  mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
>  {
>  	MPT_SCSI_HOST	*hd;
> +	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;
> =20
>  	/* If we can't locate our host adapter structure, return FAILED sta=
tus.
>  	 */
> @@ -1817,6 +1823,7 @@
>  	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! (sc=3D=
%p)\n",
>  	       hd->ioc->name, SCpnt);
> =20
> +	spin_unlock_irq(host_lock);
>  	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
>  		SCpnt->device->channel, SCpnt->device->id,
>  		0, 0, 5 /* 5 second timeout */)
> @@ -1828,10 +1835,12 @@
>  		 		hd->ioc->name, SCpnt);
>  		hd->tmPending =3D 0;
>  		hd->tmState =3D TM_STATE_NONE;
> +		spin_lock_irq(host_lock);
>  		return FAILED;
>  	}
> -
> +	spin_lock_irq(host_lock);
>  	return SUCCESS;
> +
>  }
> =20
>  /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D*/
> @@ -1865,6 +1874,7 @@
>  		hd->timeouts++;
> =20
>  	/* We are now ready to execute the task management request. */
> +	spin_unlock_irq(host_lock);
>  	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
>  		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */)
>  	    < 0){
> @@ -1880,7 +1890,7 @@
>  		spin_lock_irq(host_lock);
>  		return FAILED;
>  	}
> -
> +	spin_lock_irq(host_lock);
>  	return SUCCESS;
>  }
> =20
> @@ -1899,6 +1909,7 @@
>  {
>  	MPT_SCSI_HOST *  hd;
>  	int              status =3D SUCCESS;
> +	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;
> =20
>  	/*  If we can't locate the host to reset, then we failed. */
>  	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) =3D=3D=
 NULL){
> @@ -1914,6 +1925,7 @@
>  	/*  If our attempts to reset the host failed, then return a failed
>  	 *  status.  The host will be taken off line by the SCSI mid-layer.
>  	 */
> +	spin_unlock_irq(host_lock);
>  	if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0){
>  		status =3D FAILED;
>  	} else {
> @@ -1923,6 +1935,8 @@
>  		hd->tmPending =3D 0;
>  		hd->tmState =3D TM_STATE_NONE;
>  	}
> +	spin_lock_irq(host_lock);
> +
> =20
>  	dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
>  		     "Status =3D %s\n",
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 12/12] be2iscsi: Add lock to protect WRB alloc and free
Date: Mon, 1 Feb 2016 13:27:18 +0100
Message-ID: <20160201122718.GL27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-13-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188AbcBAM1V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:21 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-13-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:51PM +0530, Jitendra Bhivare wrote:
> FW got into UE after running IO stress test
>=20
> With kernel change to split session lock in frwd_lock and back_lock f=
or tx
> and rx path correspondingly, in the IO path, common resource used in =
driver
> such as WRB was left unprotected.
>=20
> Add wrb_lock spinlock to protect allocation and freeing of WRB.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 5 +++++
>  drivers/scsi/be2iscsi/be_main.h | 1 +
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index fa2b589..0892ee2 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -1190,12 +1190,14 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context=
 *pwrb_context,
>  {
>  	struct wrb_handle *pwrb_handle;
> =20
> +	spin_lock_bh(&pwrb_context->wrb_lock);
>  	pwrb_handle =3D pwrb_context->pwrb_handle_base[pwrb_context->alloc_=
index];
>  	pwrb_context->wrb_handles_available--;
>  	if (pwrb_context->alloc_index =3D=3D (wrbs_per_cxn - 1))
>  		pwrb_context->alloc_index =3D 0;
>  	else
>  		pwrb_context->alloc_index++;
> +	spin_unlock_bh(&pwrb_context->wrb_lock);
> =20
>  	return pwrb_handle;
>  }
> @@ -1227,12 +1229,14 @@ beiscsi_put_wrb_handle(struct hwi_wrb_context=
 *pwrb_context,
>  		       struct wrb_handle *pwrb_handle,
>  		       unsigned int wrbs_per_cxn)
>  {
> +	spin_lock_bh(&pwrb_context->wrb_lock);
>  	pwrb_context->pwrb_handle_base[pwrb_context->free_index] =3D pwrb_h=
andle;
>  	pwrb_context->wrb_handles_available++;
>  	if (pwrb_context->free_index =3D=3D (wrbs_per_cxn - 1))
>  		pwrb_context->free_index =3D 0;
>  	else
>  		pwrb_context->free_index++;
> +	spin_unlock_bh(&pwrb_context->wrb_lock);
>  }
> =20
>  /**
> @@ -2920,6 +2924,7 @@ static int beiscsi_init_wrb_handle(struct beisc=
si_hba *phba)
>  			}
>  			num_cxn_wrbh--;
>  		}
> +		spin_lock_init(&pwrb_context->wrb_lock);
>  	}
>  	idx =3D 0;
>  	for (index =3D 0; index < phba->params.cxns_per_ctrl; index++) {
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/=
be_main.h
> index 5ded3fa..30a4606 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -304,6 +304,7 @@ struct invalidate_command_table {
>  #define BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri) \
>  	(phwi_ctrlr->wrb_context[cri].ulp_num)
>  struct hwi_wrb_context {
> +	spinlock_t wrb_lock;
>  	struct list_head wrb_handle_list;
>  	struct list_head wrb_handle_drvr_list;
>  	struct wrb_handle **pwrb_handle_base;
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

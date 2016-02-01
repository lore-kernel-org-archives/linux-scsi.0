From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/12] be2iscsi: Remove unused mcc_cq_lock
Date: Mon, 1 Feb 2016 12:10:07 +0100
Message-ID: <20160201111006.GA27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-2-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbcBALKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:10:13 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-2-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:40PM +0530, Jitendra Bhivare wrote:
> mcc_cq_lock spin_lock is used only in beiscsi_process_mcc which is ca=
lled
> only when all interrupts are disabled from mgmt_epfw_cleanup during
> unloading of driver. There is no other context where there can be
> contention for the processing of CQ.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be.h      | 1 -
>  drivers/scsi/be2iscsi/be_cmds.c | 2 --
>  drivers/scsi/be2iscsi/be_main.c | 1 -
>  3 files changed, 4 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index 7d425af..1524fe4 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -132,7 +132,6 @@ struct be_ctrl_info {
>  	/* MCC Rings */
>  	struct be_mcc_obj mcc_obj;
>  	spinlock_t mcc_lock;	/* For serializing mcc cmds to BE card */
> -	spinlock_t mcc_cq_lock;
> =20
>  	wait_queue_head_t mcc_wait[MAX_MCC_CMD + 1];
>  	unsigned int mcc_tag[MAX_MCC_CMD];
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index 34c33d4..e8e9d22 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -532,7 +532,6 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
>  	int num =3D 0, status =3D 0;
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> =20
> -	spin_lock_bh(&phba->ctrl.mcc_cq_lock);
>  	while ((compl =3D be_mcc_compl_get(phba))) {
>  		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
>  			beiscsi_process_async_event(phba, compl);
> @@ -547,7 +546,6 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
>  	if (num)
>  		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1);
> =20
> -	spin_unlock_bh(&phba->ctrl.mcc_cq_lock);
>  	return status;
>  }
> =20
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 70179e1..314fd2c 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -730,7 +730,6 @@ static int be_ctrl_init(struct beiscsi_hba *phba,=
 struct pci_dev *pdev)
>  	memset(mbox_mem_align->va, 0, sizeof(struct be_mcc_mailbox));
>  	mutex_init(&ctrl->mbox_lock);
>  	spin_lock_init(&phba->ctrl.mcc_lock);
> -	spin_lock_init(&phba->ctrl.mcc_cq_lock);
> =20
>  	return status;
>  }
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

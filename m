From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi:libsas: fix oops caused by assigning a freed task to
 ->lldd_task
Date: Wed, 6 Jul 2016 10:24:47 +0200
Message-ID: <577CC04F.50508@suse.de>
References: <1467793724-21815-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbcGFIYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 04:24:50 -0400
In-Reply-To: <1467793724-21815-1-git-send-email-fangwei1@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 07/06/2016 10:28 AM, Wei Fang wrote:
> A freed task has been assigned to ->lldd_task when lldd_execute_task(=
)
> failed in sas_ata_qc_issue(), and access of ->lldd_task will cause
> an oops:
>=20
> Call trace:
> [<ffffffc000641f64>] sas_ata_post_internal+0x6c/0x150
> [<ffffffc0006c0d64>] ata_exec_internal_sg+0x32c/0x588
> [<ffffffc0006c1048>] ata_exec_internal+0x88/0xe8
> [<ffffffc0006c13b4>] ata_dev_read_id+0x204/0x5e0
> [<ffffffc0006c17f0>] ata_dev_reread_id+0x60/0xc8
> [<ffffffc0006c3098>] ata_dev_revalidate+0x88/0x1e0
> [<ffffffc0006cf828>] ata_eh_recover+0xcf8/0x13a8
> [<ffffffc0006d075c>] ata_do_eh+0x5c/0xe0
> [<ffffffc0006d0828>] ata_std_error_handler+0x48/0x98
> [<ffffffc0006d042c>] ata_scsi_port_error_handler+0x474/0x658
> [<ffffffc000641b78>] async_sas_ata_eh+0x50/0x80
> [<ffffffc0000ca664>] async_run_entry_fn+0x64/0x180
> [<ffffffc0000c085c>] process_one_work+0x164/0x438
> [<ffffffc0000c0c74>] worker_thread+0x144/0x4b0
> [<ffffffc0000c70fc>] kthread+0xfc/0x110
>=20
> Fix this by reassigning NULL to ->lldd_task in error path.
>=20
> Signed-off-by: Wei Fang <fangwei1@huawei.com>
> ---
>  drivers/scsi/libsas/sas_ata.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_=
ata.c
> index 935c430..33c7c66 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -253,6 +253,7 @@ static unsigned int sas_ata_qc_issue(struct ata_q=
ueued_cmd *qc)
>  		if (qc->scsicmd)
>  			ASSIGN_SAS_TASK(qc->scsicmd, NULL);
>  		sas_free_task(task);
> +		qc->lldd_task =3D task;
>  		ret =3D AC_ERR_SYSTEM;
>  	}
> =20
>=20
Errm.
This is most definitely wrong.
Sure you mean

qc->lldd_task =3D NULL;

in that line?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

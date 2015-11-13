From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] mpt3sas: Fix use sas_is_tlr_enabled API before enabling
 MPI2_SCSIIO_CONTROL_TLR_ON flag
Date: Fri, 13 Nov 2015 08:24:05 +0100
Message-ID: <56459015.7090305@suse.de>
References: <1447351837-31388-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447351837-31388-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 11/12/2015 07:10 PM, Sreekanth Reddy wrote:
> Before enabling MPI2_SCSIIO_CONTROL_TLR_ON flag in MPI SCSI IO
> request message, check whether TLR is enabled on the drive using
> 'sas_is_tlr_enabled' API.
>=20
> Actually in the driver code, driver is using below API's
>=20
> 1. sas_enable_tlr() - to enable the TLR
> 2. sas_disable_tlr() - to disable the TLR
> 3. sas_is_tlr_enabled() - to check whether TLR is enabled or not.
>=20
> but in scsih_qcmd() we have missed to use sas_is_tlr_enabled() API,
> instead we checking for TLR bit from flag field of driver's
> 'struct MPT3SAS_DEVIC' structure. which is corrected with this patch.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index d95206b..9ab77b0 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3905,8 +3905,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi=
_cmnd *scmd)
>  	 * We do not expose raid functionality to upper layer for warpdrive=
=2E
>  	 */
>  	if (!ioc->is_warpdrive && !scsih_is_raid(&scmd->device->sdev_gendev=
)
> -	    && (sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
> -	    scmd->cmd_len !=3D 32)
> +	    && sas_is_tlr_enabled(scmd->device) && scmd->cmd_len !=3D 32)
>  		mpi_control |=3D MPI2_SCSIIO_CONTROL_TLR_ON;
> =20
>  	smid =3D mpt3sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scm=
d);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

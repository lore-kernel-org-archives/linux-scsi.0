From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 09/25] mpt3sas: Don't send PHYDISK_HIDDEN Raid
 Action request on SAS2 HBA's
Date: Wed, 11 Nov 2015 13:56:50 +0100
Message-ID: <56433B12.4080405@suse.de>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com> <1447243241-10912-10-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-10-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 11/11/2015 01:00 PM, Sreekanth Reddy wrote:
> From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
>=20
> Don't send PHYDISK_HIDDEN Raid Action request for SAS2 HBA's.
> Since these HBA's doesn't support this Raid Action.
>=20
> Also enable fast_path only for SAS3 HBA's.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index a638920..80469d0 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1165,8 +1165,10 @@ scsih_target_alloc(struct scsi_target *starget=
)
>  		if (test_bit(sas_device->handle, ioc->pd_handles))
>  			sas_target_priv_data->flags |=3D
>  			    MPT_TARGET_FLAGS_RAID_COMPONENT;
> +#ifndef SCSI_MPT2SAS
>  		if (sas_device->fast_path)
>  			sas_target_priv_data->flags |=3D MPT_TARGET_FASTPATH_IO;
> +#endif
>  	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> =20
> @@ -3719,11 +3721,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct sc=
si_cmnd *scmd)
>  		ioc->build_zero_len_sge(ioc, &mpi_request->SGL);
> =20
>  	if (likely(mpi_request->Function =3D=3D MPI2_FUNCTION_SCSI_IO_REQUE=
ST)) {
> +#ifndef SCSI_MPT2SAS
>  		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
>  			mpi_request->IoFlags =3D cpu_to_le16(scmd->cmd_len |
>  			    MPI25_SCSIIO_IOFLAGS_FAST_PATH);
>  			mpt3sas_base_put_smid_fast_path(ioc, smid, handle);
>  		} else
> +#endif
>  			mpt3sas_base_put_smid_scsi_io(ioc, smid, handle);
>  	} else
>  		mpt3sas_base_put_smid_default(ioc, smid);
> @@ -5031,8 +5035,10 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc,=
 u16 handle, u8 phy_num,
>  	sas_device->device_info =3D device_info;
>  	sas_device->sas_address =3D sas_address;
>  	sas_device->phy =3D sas_device_pg0.PhyNum;
> +#ifndef SCSI_MPT2SAS
>  	sas_device->fast_path =3D (le16_to_cpu(sas_device_pg0.Flags) &
>  	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
> +#endif
> =20
>  	if (sas_device_pg0.Flags & MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID)=
 {
>  		sas_device->enclosure_level =3D
> @@ -5731,6 +5737,7 @@ _scsih_sas_discovery_event(struct MPT3SAS_ADAPT=
ER *ioc,
>  	}
>  }
> =20
> +#ifndef SCSI_MPT2SAS
>  /**
>   * _scsih_ir_fastpath - turn on fastpath for IR physdisk
>   * @ioc: per adapter object
> @@ -5750,7 +5757,6 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc,=
 u16 handle, u8 phys_disk_num)
>  	u16 ioc_status;
>  	u32 log_info;
> =20
> -
>  	mutex_lock(&ioc->scsih_cmds.mutex);
> =20
>  	if (ioc->scsih_cmds.status !=3D MPT3_CMD_NOT_USED) {
> @@ -5825,6 +5831,8 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc,=
 u16 handle, u8 phys_disk_num)
>  		    FORCE_BIG_HAMMER);
>  	return rc;
>  }
> +/* End of not defined SCSI_MPT2SAS */
> +#endif
> =20
>  /**
>   * _scsih_reprobe_lun - reprobing lun
> @@ -6017,8 +6025,10 @@ _scsih_sas_pd_hide(struct MPT3SAS_ADAPTER *ioc=
,
>  	if (!sas_device)
>  		return;
> =20
> +#ifndef SCSI_MPT2SAS
>  	/* hiding raid component */
>  	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
> +#endif
>  	if (starget)
>  		starget_for_each_device(starget, (void *)1, _scsih_reprobe_lun);
>  }
> @@ -6067,7 +6077,9 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
>  	sas_device =3D _scsih_sas_device_find_by_handle(ioc, handle);
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
>  	if (sas_device) {
> +#ifndef SCSI_MPT2SAS
>  		_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
> +#endif
>  		return;
>  	}
> =20
> @@ -6091,7 +6103,9 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
>  		mpt3sas_transport_update_links(ioc, sas_address, handle,
>  		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
> =20
> +#ifndef SCSI_MPT2SAS
>  	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
> +#endif
>  	_scsih_add_device(ioc, handle, 0, 1);
>  }
> =20
> @@ -6202,13 +6216,14 @@ _scsih_sas_ir_config_change_event(struct MPT3=
SAS_ADAPTER *ioc,
> =20
>  	element =3D (Mpi2EventIrConfigElement_t *)&event_data->ConfigElemen=
t[0];
>  	if (ioc->shost_recovery) {
> -
> +#ifndef SCSI_MPT2SAS
>  		for (i =3D 0; i < event_data->NumElements; i++, element++) {
>  			if (element->ReasonCode =3D=3D MPI2_EVENT_IR_CHANGE_RC_HIDE)
>  				_scsih_ir_fastpath(ioc,
>  					le16_to_cpu(element->PhysDiskDevHandle),
>  					element->PhysDiskNum);
>  		}
> +#endif
>  		return;
>  	}
>  	for (i =3D 0; i < event_data->NumElements; i++, element++) {
>=20
Why didn't you use 'hba_mpi_version_belonged' here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

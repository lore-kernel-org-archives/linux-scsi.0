From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 14/20 v1] [SCSI] mpt3sas: Complete the SCSI command with
 DID_RESET status for log_info value 0x0x32010081
Date: Thu, 18 Jun 2015 10:36:20 +0200
Message-ID: <20150618083620.GB12717@c203.arch.suse.de>
References: <1434432924-40632-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbbFRIg0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2015 04:36:26 -0400
Content-Disposition: inline
In-Reply-To: <1434432924-40632-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On Tue, Jun 16, 2015 at 11:05:24AM +0530, Sreekanth Reddy wrote:
> For any SCSI command, if the driver receives
> IOC status =3D SCSI_IOC_TERMINATED and log info =3D 0x32010081 then
> that command will be completed with DID_RESET host status.
>=20
> The definition of this log info value is
> "Virtual IO has failed and has to be retried".
>=20
> Firmware will provide this log info value with IOC Status
> "SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
> is pulled and pushed back within some minimal delay.
> With this log info value, firmware informs the driver to retry the
> failed IO command infinite times, so to provide some time for the
> firmware to discover the reinserted drive successfully instated of
> just retrying failed command for five times(doesn't giving enough
> time for firmware to complete the drive discovery) and failing the
> IO permanently even though drive came back successfully.
>=20
> Changes in v1:
>    Defined macro VIRTUAL_IO_FAILED_RETRY for magic a value 0x32010081
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h  | 2 ++
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
>  2 files changed, 5 insertions(+)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3s=
as/mpt3sas_base.h
> index 0ffe763..f3f79be 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -203,6 +203,8 @@
>  #define MFG10_GF0_SSD_DATA_SCRUB_DISABLE       (0x00000008)
>  #define MFG10_GF0_SINGLE_DRIVE_R0              (0x00000010)
> =20
> +#define VIRTUAL_IO_FAILED_RETRY			(0x32010081)
> +
>  /* OEM Specific Flags will come from OEM specific header files */
>  struct Mpi2ManufacturingPage10_t {
>  	MPI2_CONFIG_PAGE_HEADER	Header;		/* 00h */
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index 7060c8b..7587f77 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4302,6 +4302,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16=
 smid, u8 msix_index, u32 reply)
>  				scmd->device->expecting_cc_ua =3D 1;
>  			}
>  			break;
> +		} else if (log_info =3D=3D VIRTUAL_IO_FAILED_RETRY) {
> +			scmd->result =3D DID_RESET << 16;
> +			break;
>  		}
>  		scmd->result =3D DID_SOFT_ERROR << 16;
>  		break;
> --=20
> 2.0.2
>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

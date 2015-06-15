From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 14/20] [SCSI] mpt3sas: Complete the SCSI command with
  DID_RESET status for log_info value 0x0x32010081
Date: Mon, 15 Jun 2015 12:01:56 +0200
Message-ID: <20150615100156.GL5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-15-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-15-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:26PM +0530, Sreekanth Reddy wrote:
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
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index 64dd90b..837c22a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4241,6 +4241,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16=
 smid, u8 msix_index, u32 reply)
>  				scmd->device->expecting_cc_ua =3D 1;
>  			}
>  			break;
> +		} else if (log_info =3D=3D 0x32010081) {
> +			scmd->result =3D DID_RESET << 16;
> +			break;

Could you make that a #define instead of some magic vlaue, so everyone =
can see
what is happening when reading the source?

>  		}
>  		scmd->result =3D DID_SOFT_ERROR << 16;
>  		break;
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

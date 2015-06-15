From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 15/20] [SCSI] mpt3sas: Return host busy error status to
 SML when DMA mapping of scatter gather list fails for a SCSI command
Date: Mon, 15 Jun 2015 11:54:49 +0200
Message-ID: <20150615095449.GH5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-16-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-16-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:27PM +0530, Sreekanth Reddy wrote:
> scsi_dma_map API will return a negative value (i.e. -ENOMEM)
> if DMA mapping of sg lists fails and zero if the sg list in the
> SCSI cmd is NULL. But drivers doesn't handled sg list DMA mapping
> failure case properly.
>=20
> So, Updated the code to return host busy error status to SCSI MID Lay=
er(SML),
> when DMA mapping of scatter gather list fails for a SCSI command.
> So that SML will retry this SCSI cmd after some time.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> index 267e489..0b26c8d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1345,7 +1345,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER=
 *ioc,
> =20
>  	sg_scmd =3D scsi_sglist(scmd);
>  	sges_left =3D scsi_dma_map(scmd);
> -	if (!sges_left) {
> +	if (!sges_left < 0) {
>  		sdev_printk(KERN_ERR, scmd->device,
>  			"pci_map_sg failed: request for %d bytes!\n",
>  			scsi_bufflen(scmd));
> @@ -1414,7 +1414,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER=
 *ioc,
>   fill_in_last_segment:
> =20
>  	/* fill the last segment */
> -	while (sges_left) {
> +	while (sges_left > 0) {
>  		if (sges_left =3D=3D 1)
>  			_base_add_sg_single_ieee(sg_local,
>  			    simple_sgl_flags_last, 0, sg_dma_len(sg_scmd),
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

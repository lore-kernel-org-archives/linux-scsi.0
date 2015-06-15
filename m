From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 18/20] [SCSI] mpt3sas: Call dma_mapping_error() API after
 mapping an address with dma_map_single() API
Date: Mon, 15 Jun 2015 11:55:46 +0200
Message-ID: <20150615095546.GI5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-19-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-19-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:30PM +0530, Sreekanth Reddy wrote:
> Added dma_mapping_error() API after mapping an address with dma_map_s=
ingle() API.
> Otherwise when CONFIG_DMA_API_DEBUG is enabled in the kernel, then it=
 complains
> about mpt3sas driver not calling dma_mapping_error after mapping an a=
ddress with
> dma_map_single
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_transport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/=
mpt3sas/mpt3sas_transport.c
> index 7a7aa68..70fd019 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -1964,7 +1964,7 @@ _transport_smp_handler(struct Scsi_Host *shost,=
 struct sas_rphy *rphy,
>  	} else {
>  		dma_addr_out =3D pci_map_single(ioc->pdev, bio_data(req->bio),
>  		    blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
> -		if (!dma_addr_out) {
> +		if (pci_dma_mapping_error(ioc->pdev, dma_addr_out)) {
>  			pr_info(MPT3SAS_FMT "%s(): DMA Addr out =3D NULL\n",
>  			    ioc->name, __func__);
>  			rc =3D -ENOMEM;
> @@ -1986,7 +1986,7 @@ _transport_smp_handler(struct Scsi_Host *shost,=
 struct sas_rphy *rphy,
>  	} else {
>  		dma_addr_in =3D  pci_map_single(ioc->pdev, bio_data(rsp->bio),
>  		    blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
> -		if (!dma_addr_in) {
> +		if (pci_dma_mapping_error(ioc->pdev, dma_addr_in)) {
>  			pr_info(MPT3SAS_FMT "%s(): DMA Addr in =3D NULL\n",
>  			    ioc->name, __func__);
>  			rc =3D -ENOMEM;
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

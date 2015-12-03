From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] VMW_PVSCSI: Fix the issue of DMA-API related
 warnings.
Date: Thu, 03 Dec 2015 14:35:47 +0100
Message-ID: <1449149747.3311.13.camel@suse.de>
References: <20151203132758.GC19092@hansolo.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151203132758.GC19092@hansolo.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>, James.Bottomley@hansenpartnership.com, arvindkumar@vmware.com, Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-scsi@vger.kernel.org, pv-drivers@vmware.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 08:27 -0500, Josh Boyer wrote:
> The driver is missing calls to pci_dma_mapping_error() after
> performing the DMA mapping, which caused DMA-API warning to
> show up in dmesg's output. Though that happens only when
> DMA_API_DEBUG option is enabled. This change fixes the issue
> and makes pvscsi_map_buffers() function more robust.
>=20
> Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>=20
> =C2=A0v2: Use -ENOMEM instead of -1 for the error return code as sugg=
ested by
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Johannes Thumshirn
>=20
> =C2=A0drivers/scsi/vmw_pvscsi.c | 45 ++++++++++++++++++++++++++++++++=
+++++++------
> =C2=A0drivers/scsi/vmw_pvscsi.h |=C2=A0=C2=A02 +-
> =C2=A02 files changed, 40 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 0f133c1817de..6164634aff18 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -349,9 +349,9 @@ static void pvscsi_create_sg(struct pvscsi_ctx *c=
tx,
> =C2=A0 * Map all data buffers for a command into PCI space and
> =C2=A0 * setup the scatter/gather list if needed.
> =C2=A0 */
> -static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct pvscsi_ctx *ctx,=
 struct scsi_cmnd
> *cmd,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct PVSCSIRingReqDes=
c *e)
> +static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct pvscsi_ctx *ctx, struc=
t scsi_cmnd *cmd,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct PVSCSIRingReqDesc *e)
> =C2=A0{
> =C2=A0	unsigned count;
> =C2=A0	unsigned bufflen =3D scsi_bufflen(cmd);
> @@ -360,18 +360,30 @@ static void pvscsi_map_buffers(struct pvscsi_ad=
apter
> *adapter,
> =C2=A0	e->dataLen =3D bufflen;
> =C2=A0	e->dataAddr =3D 0;
> =C2=A0	if (bufflen =3D=3D 0)
> -		return;
> +		return 0;
> =C2=A0
> =C2=A0	sg =3D scsi_sglist(cmd);
> =C2=A0	count =3D scsi_sg_count(cmd);
> =C2=A0	if (count !=3D 0) {
> =C2=A0		int segs =3D scsi_dma_map(cmd);
> -		if (segs > 1) {
> +
> +		if (segs =3D=3D -ENOMEM) {
> +			scmd_printk(KERN_ERR, cmd,
> +				=C2=A0=C2=A0=C2=A0=C2=A0"vmw_pvscsi: Failed to map cmd sglist
> for DMA.\n");
> +			return -ENOMEM;
> +		} else if (segs > 1) {
> =C2=A0			pvscsi_create_sg(ctx, sg, segs);
> =C2=A0
> =C2=A0			e->flags |=3D PVSCSI_FLAG_CMD_WITH_SG_LIST;
> =C2=A0			ctx->sglPA =3D pci_map_single(adapter->dev, ctx->sgl,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0SGL_SIZE,
> PCI_DMA_TODEVICE);
> +			if (pci_dma_mapping_error(adapter->dev, ctx->sglPA))=20
> {
> +				scmd_printk(KERN_ERR, cmd,
> +					=C2=A0=C2=A0=C2=A0=C2=A0"vmw_pvscsi: Failed to map ctx
> sglist for DMA.\n");
> +				scsi_dma_unmap(cmd);
> +				ctx->sglPA =3D 0;
> +				return -ENOMEM;
> +			}
> =C2=A0			e->dataAddr =3D ctx->sglPA;
> =C2=A0		} else
> =C2=A0			e->dataAddr =3D sg_dma_address(sg);
> @@ -382,8 +394,15 @@ static void pvscsi_map_buffers(struct pvscsi_ada=
pter
> *adapter,
> =C2=A0		=C2=A0*/
> =C2=A0		ctx->dataPA =3D pci_map_single(adapter->dev, sg, bufflen,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cmd->sc_data_direction);
> +		if (pci_dma_mapping_error(adapter->dev, ctx->dataPA)) {
> +			scmd_printk(KERN_ERR, cmd,
> +				=C2=A0=C2=A0=C2=A0=C2=A0"vmw_pvscsi: Failed to map direct data
> buffer for DMA.\n");
> +			return -ENOMEM;
> +		}
> =C2=A0		e->dataAddr =3D ctx->dataPA;
> =C2=A0	}
> +
> +	return 0;
> =C2=A0}
> =C2=A0
> =C2=A0static void pvscsi_unmap_buffers(const struct pvscsi_adapter *a=
dapter,
> @@ -690,6 +709,12 @@ static int pvscsi_queue_ring(struct pvscsi_adapt=
er
> *adapter,
> =C2=A0		ctx->sensePA =3D pci_map_single(adapter->dev, cmd-
> >sense_buffer,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SCSI_SENSE_BUFFERSIZE,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0PCI_DMA_FROMDEVICE);
> +		if (pci_dma_mapping_error(adapter->dev, ctx->sensePA)) {
> +			scmd_printk(KERN_ERR, cmd,
> +				=C2=A0=C2=A0=C2=A0=C2=A0"vmw_pvscsi: Failed to map sense buffer
> for DMA.\n");
> +			ctx->sensePA =3D 0;
> +			return -ENOMEM;
> +		}
> =C2=A0		e->senseAddr =3D ctx->sensePA;
> =C2=A0		e->senseLen =3D SCSI_SENSE_BUFFERSIZE;
> =C2=A0	} else {
> @@ -711,7 +736,15 @@ static int pvscsi_queue_ring(struct pvscsi_adapt=
er
> *adapter,
> =C2=A0	else
> =C2=A0		e->flags =3D 0;
> =C2=A0
> -	pvscsi_map_buffers(adapter, ctx, cmd, e);
> +	if (pvscsi_map_buffers(adapter, ctx, cmd, e) !=3D 0) {
> +		if (cmd->sense_buffer) {
> +			pci_unmap_single(adapter->dev, ctx->sensePA,
> +					=C2=A0SCSI_SENSE_BUFFERSIZE,
> +					=C2=A0PCI_DMA_FROMDEVICE);
> +			ctx->sensePA =3D 0;
> +		}
> +		return -ENOMEM;
> +	}
> =C2=A0
> =C2=A0	e->context =3D pvscsi_map_context(adapter, ctx);
> =C2=A0
> diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
> index ee16f0c5c47d..12712c92f37a 100644
> --- a/drivers/scsi/vmw_pvscsi.h
> +++ b/drivers/scsi/vmw_pvscsi.h
> @@ -26,7 +26,7 @@
> =C2=A0
> =C2=A0#include <linux/types.h>
> =C2=A0
> -#define PVSCSI_DRIVER_VERSION_STRING=C2=A0=C2=A0=C2=A0"1.0.5.0-k"
> +#define PVSCSI_DRIVER_VERSION_STRING=C2=A0=C2=A0=C2=A0"1.0.6.0-k"
> =C2=A0
> =C2=A0#define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

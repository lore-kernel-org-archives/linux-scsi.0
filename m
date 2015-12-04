From: Arvind Kumar <arvindkumar@vmware.com>
Subject: Re: [PATCH v2] VMW_PVSCSI: Fix the issue of DMA-API related warnings.
Date: Fri, 4 Dec 2015 22:07:13 +0000
Message-ID: <1449266802382.21835@vmware.com>
References: <20151203132758.GC19092@hansolo.redhat.com>,<1449149747.3311.13.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449149747.3311.13.camel@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Josh Boyer <jwboyer@fedoraproject.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, Thomas Hellstrom <thellstrom@vmware.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Josh!

The patch looks good to me.

Thanks!
Arvind
________________________________________
=46rom: Johannes Thumshirn <jthumshirn@suse.de>
Sent: Thursday, December 3, 2015 5:35 AM
To: Josh Boyer; James.Bottomley@hansenpartnership.com; Arvind Kumar; Th=
omas Hellstrom
Cc: linux-scsi@vger.kernel.org; pv-drivers@vmware.com; linux-kernel@vge=
r.kernel.org
Subject: Re: [PATCH v2] VMW_PVSCSI: Fix the issue of DMA-API related wa=
rnings.

On Thu, 2015-12-03 at 08:27 -0500, Josh Boyer wrote:
> The driver is missing calls to pci_dma_mapping_error() after
> performing the DMA mapping, which caused DMA-API warning to
> show up in dmesg's output. Though that happens only when
> DMA_API_DEBUG option is enabled. This change fixes the issue
> and makes pvscsi_map_buffers() function more robust.
>
> Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>
>  v2: Use -ENOMEM instead of -1 for the error return code as suggested=
 by
>      Johannes Thumshirn
>
>  drivers/scsi/vmw_pvscsi.c | 45 +++++++++++++++++++++++++++++++++++++=
++------
>  drivers/scsi/vmw_pvscsi.h |=A0=A02 +-
>  2 files changed, 40 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 0f133c1817de..6164634aff18 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -349,9 +349,9 @@ static void pvscsi_create_sg(struct pvscsi_ctx *c=
tx,
>   * Map all data buffers for a command into PCI space and
>   * setup the scatter/gather list if needed.
>   */
> -static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
> -                            struct pvscsi_ctx *ctx, struct scsi_cmnd
> *cmd,
> -                            struct PVSCSIRingReqDesc *e)
> +static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
> +                           struct pvscsi_ctx *ctx, struct scsi_cmnd =
*cmd,
> +                           struct PVSCSIRingReqDesc *e)
>  {
>       unsigned count;
>       unsigned bufflen =3D scsi_bufflen(cmd);
> @@ -360,18 +360,30 @@ static void pvscsi_map_buffers(struct pvscsi_ad=
apter
> *adapter,
>       e->dataLen =3D bufflen;
>       e->dataAddr =3D 0;
>       if (bufflen =3D=3D 0)
> -             return;
> +             return 0;
>
>       sg =3D scsi_sglist(cmd);
>       count =3D scsi_sg_count(cmd);
>       if (count !=3D 0) {
>               int segs =3D scsi_dma_map(cmd);
> -             if (segs > 1) {
> +
> +             if (segs =3D=3D -ENOMEM) {
> +                     scmd_printk(KERN_ERR, cmd,
> +                                 "vmw_pvscsi: Failed to map cmd sgli=
st
> for DMA.\n");
> +                     return -ENOMEM;
> +             } else if (segs > 1) {
>                       pvscsi_create_sg(ctx, sg, segs);
>
>                       e->flags |=3D PVSCSI_FLAG_CMD_WITH_SG_LIST;
>                       ctx->sglPA =3D pci_map_single(adapter->dev, ctx=
->sgl,
>                                                   SGL_SIZE,
> PCI_DMA_TODEVICE);
> +                     if (pci_dma_mapping_error(adapter->dev, ctx->sg=
lPA))
> {
> +                             scmd_printk(KERN_ERR, cmd,
> +                                         "vmw_pvscsi: Failed to map =
ctx
> sglist for DMA.\n");
> +                             scsi_dma_unmap(cmd);
> +                             ctx->sglPA =3D 0;
> +                             return -ENOMEM;
> +                     }
>                       e->dataAddr =3D ctx->sglPA;
>               } else
>                       e->dataAddr =3D sg_dma_address(sg);
> @@ -382,8 +394,15 @@ static void pvscsi_map_buffers(struct pvscsi_ada=
pter
> *adapter,
>                */
>               ctx->dataPA =3D pci_map_single(adapter->dev, sg, buffle=
n,
>                                            cmd->sc_data_direction);
> +             if (pci_dma_mapping_error(adapter->dev, ctx->dataPA)) {
> +                     scmd_printk(KERN_ERR, cmd,
> +                                 "vmw_pvscsi: Failed to map direct d=
ata
> buffer for DMA.\n");
> +                     return -ENOMEM;
> +             }
>               e->dataAddr =3D ctx->dataPA;
>       }
> +
> +     return 0;
>  }
>
>  static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapte=
r,
> @@ -690,6 +709,12 @@ static int pvscsi_queue_ring(struct pvscsi_adapt=
er
> *adapter,
>               ctx->sensePA =3D pci_map_single(adapter->dev, cmd-
> >sense_buffer,
>                                             SCSI_SENSE_BUFFERSIZE,
>                                             PCI_DMA_FROMDEVICE);
> +             if (pci_dma_mapping_error(adapter->dev, ctx->sensePA)) =
{
> +                     scmd_printk(KERN_ERR, cmd,
> +                                 "vmw_pvscsi: Failed to map sense bu=
ffer
> for DMA.\n");
> +                     ctx->sensePA =3D 0;
> +                     return -ENOMEM;
> +             }
>               e->senseAddr =3D ctx->sensePA;
>               e->senseLen =3D SCSI_SENSE_BUFFERSIZE;
>       } else {
> @@ -711,7 +736,15 @@ static int pvscsi_queue_ring(struct pvscsi_adapt=
er
> *adapter,
>       else
>               e->flags =3D 0;
>
> -     pvscsi_map_buffers(adapter, ctx, cmd, e);
> +     if (pvscsi_map_buffers(adapter, ctx, cmd, e) !=3D 0) {
> +             if (cmd->sense_buffer) {
> +                     pci_unmap_single(adapter->dev, ctx->sensePA,
> +                                      SCSI_SENSE_BUFFERSIZE,
> +                                      PCI_DMA_FROMDEVICE);
> +                     ctx->sensePA =3D 0;
> +             }
> +             return -ENOMEM;
> +     }
>
>       e->context =3D pvscsi_map_context(adapter, ctx);
>
> diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
> index ee16f0c5c47d..12712c92f37a 100644
> --- a/drivers/scsi/vmw_pvscsi.h
> +++ b/drivers/scsi/vmw_pvscsi.h
> @@ -26,7 +26,7 @@
>
>  #include <linux/types.h>
>
> -#define PVSCSI_DRIVER_VERSION_STRING   "1.0.5.0-k"
> +#define PVSCSI_DRIVER_VERSION_STRING   "1.0.6.0-k"
>
>  #define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

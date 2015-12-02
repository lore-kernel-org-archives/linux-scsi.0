From: Arvind Kumar <arvindkumar@vmware.com>
Subject: Re: [PATCH Resend] VMW_PVSCSI: Fix the issue of DMA-API related
 warnings.
Date: Wed, 2 Dec 2015 20:04:05 +0000
Message-ID: <1449086615405.83952@vmware.com>
References: <20151201163410.GB19092@hansolo.redhat.com>
	<1449045763.3103.38.camel@suse.de>,<CA+5PVA6=7hJ5fYv8=B6gxRYoK05HFm5KZuTvtx-UM6ht4X5q5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+5PVA6=7hJ5fYv8=B6gxRYoK05HFm5KZuTvtx-UM6ht4X5q5w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Thomas Hellstrom <thellstrom@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, VMware PV-Drivers <pv-drivers@vmware.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The suggestions look reasonable to me too.

>Arvind, since I was originally just resending your patch, do you want
>to make the changes Johannes suggests, or should I proceed with that?
> josh

Hi Josh,

Feel free to send out the updated patch if you would like.

Thanks!
Arvind
________________________________________
From: jwboyer@gmail.com <jwboyer@gmail.com> on behalf of Josh Boyer <jwboyer@fedoraproject.org>
Sent: Wednesday, December 2, 2015 5:47 AM
To: Johannes Thumshirn
Cc: Jej B; Arvind Kumar; Thomas Hellstrom; linux-scsi@vger.kernel.org; VMware PV-Drivers; Linux-Kernel@Vger. Kernel. Org
Subject: Re: [PATCH Resend] VMW_PVSCSI: Fix the issue of DMA-API related warnings.

On Wed, Dec 2, 2015 at 3:42 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Hi Josh,
>
> On Tue, 2015-12-01 at 11:34 -0500, Josh Boyer wrote:
>> The driver is missing calls to pci_dma_mapping_error() after
>> performing the DMA mapping, which caused DMA-API warning to
>> show up in dmesg's output. Though that happens only when
>> DMA_API_DEBUG option is enabled. This change fixes the issue
>> and makes pvscsi_map_buffers() function more robust.
>>
>> Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
>> Cc: Josh Boyer <jwboyer@fedoraproject.org>
>> Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>> ---
>>
>>  - Resend of patch that was never committed for some reason
>>
>>  drivers/scsi/vmw_pvscsi.c | 45 +++++++++++++++++++++++++++++++++++++++------
>>  drivers/scsi/vmw_pvscsi.h |  2 +-
>>  2 files changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
>> index 0f133c1817de..19734494f9ec 100644
>> --- a/drivers/scsi/vmw_pvscsi.c
>> +++ b/drivers/scsi/vmw_pvscsi.c
>> @@ -349,9 +349,9 @@ static void pvscsi_create_sg(struct pvscsi_ctx *ctx,
>>   * Map all data buffers for a command into PCI space and
>>   * setup the scatter/gather list if needed.
>>   */
>> -static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
>> -                            struct pvscsi_ctx *ctx, struct scsi_cmnd
>> *cmd,
>> -                            struct PVSCSIRingReqDesc *e)
>> +static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
>> +                           struct pvscsi_ctx *ctx, struct scsi_cmnd *cmd,
>> +                           struct PVSCSIRingReqDesc *e)
>>  {
>>       unsigned count;
>>       unsigned bufflen = scsi_bufflen(cmd);
>> @@ -360,18 +360,30 @@ static void pvscsi_map_buffers(struct pvscsi_adapter
>> *adapter,
>>       e->dataLen = bufflen;
>>       e->dataAddr = 0;
>>       if (bufflen == 0)
>> -             return;
>> +             return 0;
>>
>>       sg = scsi_sglist(cmd);
>>       count = scsi_sg_count(cmd);
>>       if (count != 0) {
>>               int segs = scsi_dma_map(cmd);
>> -             if (segs > 1) {
>> +
>> +             if (segs == -ENOMEM) {
>> +                     scmd_printk(KERN_ERR, cmd,
>> +                                 "vmw_pvscsi: Failed to map cmd sglist
>> for DMA.\n");
>> +                     return -1;
>
> Please return -ENOMEM instead of -1
>
>> +             } else if (segs > 1) {
>>                       pvscsi_create_sg(ctx, sg, segs);
>>
>>                       e->flags |= PVSCSI_FLAG_CMD_WITH_SG_LIST;
>>                       ctx->sglPA = pci_map_single(adapter->dev, ctx->sgl,
>>                                                   SGL_SIZE,
>> PCI_DMA_TODEVICE);
>> +                     if (pci_dma_mapping_error(adapter->dev, ctx->sglPA))
>> {
>> +                             scmd_printk(KERN_ERR, cmd,
>> +                                         "vmw_pvscsi: Failed to map ctx
>> sglist for DMA.\n");
>> +                             scsi_dma_unmap(cmd);
>> +                             ctx->sglPA = 0;
>> +                             return -1;
>
> Same here.
>
>> +                     }
>>                       e->dataAddr = ctx->sglPA;
>>               } else
>>                       e->dataAddr = sg_dma_address(sg);
>> @@ -382,8 +394,15 @@ static void pvscsi_map_buffers(struct pvscsi_adapter
>> *adapter,
>>                */
>>               ctx->dataPA = pci_map_single(adapter->dev, sg, bufflen,
>>                                            cmd->sc_data_direction);
>> +             if (pci_dma_mapping_error(adapter->dev, ctx->dataPA)) {
>> +                     scmd_printk(KERN_ERR, cmd,
>> +                                 "vmw_pvscsi: Failed to map direct data
>> buffer for DMA.\n");
>> +                     return -1;
>
> And here.
>
>> +             }
>>               e->dataAddr = ctx->dataPA;
>>       }
>> +
>> +     return 0;
>>  }
>>
>>  static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
>> @@ -690,6 +709,12 @@ static int pvscsi_queue_ring(struct pvscsi_adapter
>> *adapter,
>>               ctx->sensePA = pci_map_single(adapter->dev, cmd-
>> >sense_buffer,
>>                                             SCSI_SENSE_BUFFERSIZE,
>>                                             PCI_DMA_FROMDEVICE);
>> +             if (pci_dma_mapping_error(adapter->dev, ctx->sensePA)) {
>> +                     scmd_printk(KERN_ERR, cmd,
>> +                                 "vmw_pvscsi: Failed to map sense buffer
>> for DMA.\n");
>> +                     ctx->sensePA = 0;
>> +                     return -1;
>
> And here.
>
>> +             }
>>               e->senseAddr = ctx->sensePA;
>>               e->senseLen = SCSI_SENSE_BUFFERSIZE;
>>       } else {
>> @@ -711,7 +736,15 @@ static int pvscsi_queue_ring(struct pvscsi_adapter
>> *adapter,
>>       else
>>               e->flags = 0;
>>
>> -     pvscsi_map_buffers(adapter, ctx, cmd, e);
>> +     if (pvscsi_map_buffers(adapter, ctx, cmd, e) != 0) {
>> +             if (cmd->sense_buffer) {
>> +                     pci_unmap_single(adapter->dev, ctx->sensePA,
>> +                                      SCSI_SENSE_BUFFERSIZE,
>> +                                      PCI_DMA_FROMDEVICE);
>> +                     ctx->sensePA = 0;
>> +             }
>> +             return -1;
>
> As pvscsi_map_buffers() only returns 0 or -ENOMEM please return -ENOMEM here as
> well, or do
>
>         int err;
>         [...]
>         err = pvscsi_map_buffers(adapter, ctx, cmd, e);
>         if (err) {
>                 [...]
>                 return err;
>         }
>

Thanks for the suggestions.  They all seem reasonable to me.

Arvind, since I was originally just resending your patch, do you want
to make the changes Johannes suggests, or should I proceed with that?

josh

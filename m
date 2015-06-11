From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [Pv-drivers] [PATCH] VMW_PVSCSI: Fix the issue of DMA-API related
 warnings.
Date: Thu, 11 Jun 2015 20:11:26 +0200
Message-ID: <5579CF4E.8040006@vmware.com>
References: <1395425313.8462.1254.camel@arvindkumar-dev1.eng.vmware.com> <CA+5PVA5tghb=ZhUHwt7A6+yK1hmcFzPbwYL1BN2wkd76p=o54Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:53776 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbbFKSL4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 14:11:56 -0400
In-Reply-To: <CA+5PVA5tghb=ZhUHwt7A6+yK1hmcFzPbwYL1BN2wkd76p=o54Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>, Arvind Kumar <arvindkumar@vmware.com>, James Bottomley <JBottomley@parallels.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/11/2015 02:32 PM, Josh Boyer wrote:
> On Fri, Mar 21, 2014 at 2:08 PM, Arvind Kumar <arvindkumar@vmware.com> wrote:
>> The driver is missing calls to pci_dma_mapping_error() after
>> performing the DMA mapping, which caused DMA-API warning to
>> show up in dmesg's output. Though that happens only when
>> DMA_API_DEBUG option is enabled. This change fixes the issue
>> and makes pvscsi_map_buffers() function more robust.
>>
>> Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
>> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> This patch has been sent and pinged for 3 months now.  It's gotten no
> comments at all.  Should we send it to Linus so it actually gets
> picked up?
>
> josh

Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

>
>> ---
>>  drivers/scsi/vmw_pvscsi.c |   45 +++++++++++++++++++++++++++++++++++++++------
>>  drivers/scsi/vmw_pvscsi.h |    2 +-
>>  2 files changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
>> index c88e146..9478a00 100644
>> --- a/drivers/scsi/vmw_pvscsi.c
>> +++ b/drivers/scsi/vmw_pvscsi.c
>> @@ -349,9 +349,9 @@ static void pvscsi_create_sg(struct pvscsi_ctx *ctx,
>>   * Map all data buffers for a command into PCI space and
>>   * setup the scatter/gather list if needed.
>>   */
>> -static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
>> -                              struct pvscsi_ctx *ctx, struct scsi_cmnd *cmd,
>> -                              struct PVSCSIRingReqDesc *e)
>> +static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
>> +                             struct pvscsi_ctx *ctx, struct scsi_cmnd *cmd,
>> +                             struct PVSCSIRingReqDesc *e)
>>  {
>>         unsigned count;
>>         unsigned bufflen = scsi_bufflen(cmd);
>> @@ -360,18 +360,30 @@ static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
>>         e->dataLen = bufflen;
>>         e->dataAddr = 0;
>>         if (bufflen == 0)
>> -               return;
>> +               return 0;
>>
>>         sg = scsi_sglist(cmd);
>>         count = scsi_sg_count(cmd);
>>         if (count != 0) {
>>                 int segs = scsi_dma_map(cmd);
>> -               if (segs > 1) {
>> +
>> +               if (segs == -ENOMEM) {
>> +                       scmd_printk(KERN_ERR, cmd,
>> +                                   "vmw_pvscsi: Failed to map cmd sglist for DMA.\n");
>> +                       return -1;
>> +               } else if (segs > 1) {
>>                         pvscsi_create_sg(ctx, sg, segs);
>>
>>                         e->flags |= PVSCSI_FLAG_CMD_WITH_SG_LIST;
>>                         ctx->sglPA = pci_map_single(adapter->dev, ctx->sgl,
>>                                                     SGL_SIZE, PCI_DMA_TODEVICE);
>> +                       if (pci_dma_mapping_error(adapter->dev, ctx->sglPA)) {
>> +                               scmd_printk(KERN_ERR, cmd,
>> +                                           "vmw_pvscsi: Failed to map ctx sglist for DMA.\n");
>> +                               scsi_dma_unmap(cmd);
>> +                               ctx->sglPA = 0;
>> +                               return -1;
>> +                       }
>>                         e->dataAddr = ctx->sglPA;
>>                 } else
>>                         e->dataAddr = sg_dma_address(sg);
>> @@ -382,8 +394,15 @@ static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
>>                  */
>>                 ctx->dataPA = pci_map_single(adapter->dev, sg, bufflen,
>>                                              cmd->sc_data_direction);
>> +               if (pci_dma_mapping_error(adapter->dev, ctx->dataPA)) {
>> +                       scmd_printk(KERN_ERR, cmd,
>> +                                   "vmw_pvscsi: Failed to map direct data buffer for DMA.\n");
>> +                       return -1;
>> +               }
>>                 e->dataAddr = ctx->dataPA;
>>         }
>> +
>> +       return 0;
>>  }
>>
>>  static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
>> @@ -712,6 +731,12 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
>>                 ctx->sensePA = pci_map_single(adapter->dev, cmd->sense_buffer,
>>                                               SCSI_SENSE_BUFFERSIZE,
>>                                               PCI_DMA_FROMDEVICE);
>> +               if (pci_dma_mapping_error(adapter->dev, ctx->sensePA)) {
>> +                       scmd_printk(KERN_ERR, cmd,
>> +                                   "vmw_pvscsi: Failed to map sense buffer for DMA.\n");
>> +                       ctx->sensePA = 0;
>> +                       return -1;
>> +               }
>>                 e->senseAddr = ctx->sensePA;
>>                 e->senseLen = SCSI_SENSE_BUFFERSIZE;
>>         } else {
>> @@ -737,7 +762,15 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
>>         else
>>                 e->flags = 0;
>>
>> -       pvscsi_map_buffers(adapter, ctx, cmd, e);
>> +       if (pvscsi_map_buffers(adapter, ctx, cmd, e) != 0) {
>> +               if (cmd->sense_buffer) {
>> +                       pci_unmap_single(adapter->dev, ctx->sensePA,
>> +                                        SCSI_SENSE_BUFFERSIZE,
>> +                                        PCI_DMA_FROMDEVICE);
>> +                       ctx->sensePA = 0;
>> +               }
>> +               return -1;
>> +       }
>>
>>         e->context = pvscsi_map_context(adapter, ctx);
>>
>> diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
>> index ce45888..fe3b759 100644
>> --- a/drivers/scsi/vmw_pvscsi.h
>> +++ b/drivers/scsi/vmw_pvscsi.h
>> @@ -26,7 +26,7 @@
>>
>>  #include <linux/types.h>
>>
>> -#define PVSCSI_DRIVER_VERSION_STRING   "1.0.5.0-k"
>> +#define PVSCSI_DRIVER_VERSION_STRING   "1.0.6.0-k"
>>
>>  #define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
>>
>> --
>> 1.7.9.5
>>
>>
>>
> _______________________________________________
> Pv-drivers mailing list
> Pv-drivers@vmware.com
> http://mailman2.vmware.com/mailman/listinfo/pv-drivers


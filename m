From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH] SCSI: buslogic: Added check for DMA mapping errors (was
 Re:[BusLogic] DMA-API: device driver failed to check map error)
Date: Fri, 13 Sep 2013 09:55:12 -0600
Message-ID: <52333560.50209@oracle.com>
References: <201309101503.ECC18788.SOOVOJLFtQHMFF@I-love.SAKURA.ne.jp> <1378816604.6973.53.camel@dabdike.int.hansenpartnership.com> <1379004807.10738.3.camel@concerto> <201309140042.GEI73439.QHSJtOFFVFOLOM@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201309140042.GEI73439.QHSJtOFFVFOLOM@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/13/2013 09:42 AM, Tetsuo Handa wrote:
> Khalid Aziz wrote:
>> Added check for DMA mapping errors for request sense data
>> buffer. Checking for mapping error can avoid potential wild
>> writes. This patch was prompted by the warning from
>> dma_unmap when kernel is compiled with CONFIG_DMA_API_DEBUG.
>
> This patch fixes CONFIG_DMA_API_DEBUG warning.
> But excuse me, is this error path correct?
>
>> @@ -309,16 +309,17 @@ static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)
>>     blogic_dealloc_ccb deallocates a CCB, returning it to the Host Adapter's
>>     free list.  The Host Adapter's Lock should already have been acquired by the
>>     caller.
>>   */
>>
>> -static void blogic_dealloc_ccb(struct blogic_ccb *ccb)
>> +static void blogic_dealloc_ccb(struct blogic_ccb *ccb, int dma_unmap)
>>   {
>>          struct blogic_adapter *adapter = ccb->adapter;
>>
>>          scsi_dma_unmap(ccb->command);
>
> blogic_dealloc_ccb() uses "ccb->command". But
>
>> -       pci_unmap_single(adapter->pci_device, ccb->sensedata,
>> +       if (dma_unmap)
>> +               pci_unmap_single(adapter->pci_device, ccb->sensedata,
>>                           ccb->sense_datalen, PCI_DMA_FROMDEVICE);
>>
>>          ccb->command = NULL;
>>          ccb->status = BLOGIC_CCB_FREE;
>>          ccb->next = adapter->free_ccbs;
>> @@ -3177,13 +3179,21 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
>>                          ccb->legacy_tag = queuetag;
>>                  }
>>          }
>>          memcpy(ccb->cdb, cdb, cdblen);
>>          ccb->sense_datalen = SCSI_SENSE_BUFFERSIZE;
>> -       ccb->sensedata = pci_map_single(adapter->pci_device,
>> +       sense_buf = pci_map_single(adapter->pci_device,
>>                                  command->sense_buffer, ccb->sense_datalen,
>>                                  PCI_DMA_FROMDEVICE);
>> +       if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
>> +               blogic_err("DMA mapping for sense data buffer failed\n",
>> +                               adapter);
>> +               scsi_dma_map(command);
>> +               blogic_dealloc_ccb(ccb, 0);
>
> when was "ccb->command = command;" called before calling blogic_dealloc_ccb()?
>
>> +               return SCSI_MLQUEUE_HOST_BUSY;
>> +       }
>> +       ccb->sensedata = sense_buf;
>>          ccb->command = command;
>>          command->scsi_done = comp_cb;
>>          if (blogic_multimaster_type(adapter)) {
>>                  /*
>>                     Place the CCB in an Outgoing Mailbox. The higher levels
>
> Also, what happens if "scsi_dma_map(command);" returned -ENOMEM ?
> If you are calling scsi_dma_map() because blogic_dealloc_ccb() calls
> scsi_dma_unmap(), why can't we do like
>
>    {
>            struct blogic_adapter *adapter = ccb->adapter;
>            ccb->command = NULL;
>            ccb->status = BLOGIC_CCB_FREE;
>            ccb->next = adapter->free_ccbs;
>            adapter->free_ccbs = ccb;
>    }
>
> instead of
>
>    scsi_dma_map(command);
>    blogic_dealloc_ccb(ccb);
>
> ?
>

That is a typo. I was going to call just scsi_dma_unmap(), had copied 
down the previous down the previous scsi_dma_map() line, read the code 
further and decided I needed to call blogic_dealloc_ccb() instead so we 
don't leak CCBs, added the call to blogic_dealloc_ccb() and forgot to 
delete the previously added and unfinished line. scsi_dma_map() had 
already been called earlier which is why scsi_dma_unmap() needs to be 
called which is taken care of by blogic_dealloc_ccb().

I need to delete the call to scsi_dma_map() which was not supposed to be 
there and move "ccb->command = command;" up before the call to 
dma_mapping_error(). I will send out an updated patch.

Good catch. Thanks!

--
Khalid

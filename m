From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 06/41] scsi: aic7xxx: mark expected switch fall-throughs
Date: Thu, 10 Jan 2019 14:14:37 -0600
Message-ID: <5f0bdfb2-da5d-c63b-cf52-9395b066eb04@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <b55c3f902d88871053983314cfa837e641db5db6.1543374820.git.gustavo@embeddedor.com>
 <76760259-100e-f149-bbbf-4c1044152ff7@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <76760259-100e-f149-bbbf-4c1044152ff7@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 9:37 AM, Gustavo A. R. Silva wrote:
> Hi,
> 
> Friendly ping:
> 
> Who can ack or review this patch, please?
> 
> Thanks
> -- 
> Gustavo
> 
> On 11/27/18 10:26 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Notice that, in some cases, I replaced "FALLTHROUGH" with a "fall through"
>> annotation and then placed it at the bottom of the corresponding switch
>> case, which is what GCC is expecting to find.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/aic7xxx/aic7xxx_core.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
>> index f3362f4ab16e..d4a7263e4b8f 100644
>> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
>> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
>> @@ -4920,24 +4920,30 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
>>           }
>>           ahc_dma_tag_destroy(ahc, scb_data->sg_dmat);
>>       }
>> +        /* fall through */
>>       case 6:
>>           ahc_dmamap_unload(ahc, scb_data->sense_dmat,
>>                     scb_data->sense_dmamap);
>> +        /* fall through */
>>       case 5:
>>           ahc_dmamem_free(ahc, scb_data->sense_dmat, scb_data->sense,
>>                   scb_data->sense_dmamap);
>>           ahc_dmamap_destroy(ahc, scb_data->sense_dmat,
>>                      scb_data->sense_dmamap);
>> +        /* fall through */
>>       case 4:
>>           ahc_dma_tag_destroy(ahc, scb_data->sense_dmat);
>> +        /* fall through */
>>       case 3:
>>           ahc_dmamap_unload(ahc, scb_data->hscb_dmat,
>>                     scb_data->hscb_dmamap);
>> +        /* fall through */
>>       case 2:
>>           ahc_dmamem_free(ahc, scb_data->hscb_dmat, scb_data->hscbs,
>>                   scb_data->hscb_dmamap);
>>           ahc_dmamap_destroy(ahc, scb_data->hscb_dmat,
>>                      scb_data->hscb_dmamap);
>> +        /* fall through */
>>       case 1:
>>           ahc_dma_tag_destroy(ahc, scb_data->hscb_dmat);
>>           break;
>> @@ -6002,8 +6008,8 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int target, char channel,
>>                   if ((scb->flags & SCB_ACTIVE) == 0)
>>                       printk("Inactive SCB in Waiting List\n");
>>                   ahc_done(ahc, scb);
>> -                /* FALLTHROUGH */
>>               }
>> +                /* fall through */
>>               case SEARCH_REMOVE:
>>                   next = ahc_rem_wscb(ahc, next, prev);
>>                   break;
>> @@ -7008,8 +7014,8 @@ ahc_download_instr(struct ahc_softc *ahc, u_int instrptr, uint8_t *dconsts)
>>           }
>>           address -= address_offset;
>>           fmt3_ins->address = address;
>> -        /* FALLTHROUGH */
>>       }
>> +        /* fall through */
>>       case AIC_OP_OR:
>>       case AIC_OP_AND:
>>       case AIC_OP_XOR:
>> @@ -7035,7 +7041,7 @@ ahc_download_instr(struct ahc_softc *ahc, u_int instrptr, uint8_t *dconsts)
>>               fmt1_ins->opcode = AIC_OP_AND;
>>               fmt1_ins->immediate = 0xff;
>>           }
>> -        /* FALLTHROUGH */
>> +        /* fall through */
>>       case AIC_OP_ROL:
>>           if ((ahc->features & AHC_ULTRA2) != 0) {
>>               int i, count;
>>

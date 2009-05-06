From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] 3ware scsi_dma_unmap fix
Date: Tue, 5 May 2009 17:25:40 -0700
Message-ID: <b1bc6a000905051725y167f6b67pa243807954eda78a@mail.gmail.com>
References: <b1bc6a000905051145s411cea22r7decd68bac687bb8@mail.gmail.com>
	 <20090506091238I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:36609 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZEFAZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 20:25:41 -0400
Received: by gxk10 with SMTP id 10so9906352gxk.13
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2009 17:25:41 -0700 (PDT)
In-Reply-To: <20090506091238I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Tue, May 5, 2009 at 5:12 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 5 May 2009 11:45:37 -0700
> adam radford <aradford@gmail.com> wrote:
>
>> This patch for the 3w-9xxx driver is for 2.6.30-rc5.
>>
>> This patch fixes the following regression the occurred during the
>> scsi_dma_map()/unmap() changes:
>
> Yeah, sorry about that.
>
>> 3w-9xxx 0001:45:00.0: DMA-API: device driver tries to free DMA memory
>> it has not allocated [device address=0x0000000000000000] [size=36
>> bytes]
>
> Might be better to put the pointer to report this bug?
>
> http://marc.info/?l=linux-kernel&m=124141488730478&w=2
>
>
>> James, could you please apply this?
>>
>> Thanks,
>>
>> -Adam
>>
>> Signed-off-by: Adam Radford <aradford@gmail.com>
>
> The patch looks correct. Let's add 'Cc: stable@kernel.org' here so
> that this patch will be sent to stable trees.
>
>
> btw, can we simplify the dma buffer handling by removing the usage of
> the generi_buffer_virt (always use scatter gather buffers)?
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 8b7983a..4c7e80e 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1847,29 +1847,19 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>                /* Map sglist from scsi layer to cmd packet */
>
>                if (scsi_sg_count(srb)) {
> -                       if ((scsi_sg_count(srb) == 1) &&
> -                           (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
> -                               if (srb->sc_data_direction == DMA_TO_DEVICE ||
> -                                   srb->sc_data_direction == DMA_BIDIRECTIONAL)
> -                                       scsi_sg_copy_to_buffer(srb,
> -                                                              tw_dev->generic_buffer_virt[request_id],
> -                                                              TW_SECTOR_SIZE);
> -                               command_packet->sg_list[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
> -                               command_packet->sg_list[0].length = cpu_to_le32(TW_MIN_SGL_LENGTH);
> -                       } else {
> -                               sg_count = twa_map_scsi_sg_data(tw_dev, request_id);
> -                               if (sg_count == 0)
> -                                       goto out;
> +                       sg_count = twa_map_scsi_sg_data(tw_dev, request_id);
> +                       if (sg_count == 0)
> +                               goto out;
>
> -                               scsi_for_each_sg(srb, sg, sg_count, i) {
> -                                       command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(sg));
> -                                       command_packet->sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
> -                                       if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
> -                                               TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2e, "Found unaligned sgl address during execute scsi");
> -                                               goto out;
> -                                       }
> +                       scsi_for_each_sg(srb, sg, sg_count, i) {
> +                               command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(sg));
> +                               command_packet->sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
> +                               if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
> +                                       TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2e, "Found unaligned sgl address during execute scsi");
> +                                       goto out;
>                                }
>                        }
> +
>                        command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4), scsi_sg_count(tw_dev->srb[request_id])));
>                }
>        } else {
>

I wouldn't do that.  The generic_buffer_virt stuff is there because
the hardware can't DMA < 512 bytes, so we sg_copy_to/from_buffer()
there, then dma from generic_buffer_virt.

-Adam

From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/10] esp: Use FIFO for command submission
Date: Fri, 21 Nov 2014 11:50:12 +0100
Message-ID: <546F18E4.40507@redhat.com>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-8-git-send-email-hare@suse.de> <546F0E2F.7090502@redhat.com> <546F1615.3030009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216AbaKUKuY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:50:24 -0500
In-Reply-To: <546F1615.3030009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org



On 21/11/2014 11:38, Hannes Reinecke wrote:
>>>  	esp->msg_out_len = 0;
>>>  
>>>  	*p++ = IDENTIFY(0, lun);
>>> @@ -648,12 +651,21 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
>>>  	esp_write_tgt_sync(esp, tgt);
>>>  	esp_write_tgt_config3(esp, tgt);
>>>  
>>> -	val = (p - esp->command_block);
>>> +	if (esp->flags & ESP_FLAG_USE_FIFO)
>>> +		val = (p - esp->fifo);
>>> +	else
>>> +		val = (p - esp->command_block);
>>>  
>>>  	if (esp->rev == FASHME)
>>>  		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>>
>> For consistency with what you do elsewhere, please move this in the "else".
>>
> No. The 'USE_FIFO' mechanism is a general feature which _should_
> work on all chips. The above 'if' condition is a chipset-specific
> feature which should be treated separately.

Yup, but USE_FIFO always sends a flush anyway.  Sending two is useless.

>>> -	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
>>> -			       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
>>> +	if (esp->flags & ESP_FLAG_USE_FIFO) {
>>> +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>>> +		for (i = 0; i < val; i++)
>>> +			esp_write8(esp->fifo[i], ESP_FDATA);
>>> +		scsi_esp_cmd(esp, ESP_CMD_SELA);
>>> +	} else
>>> +		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
>>> +				       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
>>>  }
>>
>> Hmm, what about a wrapper
>>
>>     __send_cmd(esp, data, esp_count, dma_count, cmd, force_flush,
>>                force_fifo)
>>     {
>>         use_fifo =
>>             force_fifo || (esp->flags & ESP_FLAG_USE_FIFO) ||
>>             esp_count == 1;
>>         if (force_flush || use_fifo || esp->rev == FASHME)
>>             scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>>         if (use_fifo) {
>>             for (i = 0; i < val; i++)
>>                 esp_write8(esp->fifo[i], ESP_FDATA);
>>             scsi_esp_cmd(esp, cmd);
>>         } else {
>>             if (data != esp->command_block)
>>                 memcpy(esp->command_block, data, length)
>>             esp->ops->send_dma_cmd(esp,
>>                                    esp->command_block_dma,
>>                                    esp_count, dma_count, 0,
>>                                    cmd | ESP_CMD_DMA);
>>         }
>>     }
>>
>>     send_cmd(esp, data, esp_count, dma_count, cmd)
>>     {
>>         __send_cmd(esp, data, esp_count, dma_count, cmd, false, false);
>>     }
>>
>> This would be:
>>
>>     send_cmd(esp, esp->command_block, val, 16, ESP_CMD_SELA);
>>
> Good point.

(Note this was also why I was suggesting just using esp->command_block
unconditionally).

Paolo

> Will be updating the patch.
> 
> Cheers,
> 
> Hannes
> 

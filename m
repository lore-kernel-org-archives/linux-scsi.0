From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 6/6] esp_scsi: Optimize PIO loops
Date: Sat, 13 Oct 2018 17:18:59 +1300
Message-ID: <5b95b717-d9e8-8c8c-aa42-47f847bec5be@gmail.com>
References: <cover.1539391876.git.fthain@telegraphics.com.au>
 <3a2534bff570653de6897afa081017e2a359747e.1539391876.git.fthain@telegraphics.com.au>
 <3ba0d49c-57ce-40df-b406-98afc183275e@gmail.com>
 <alpine.LNX.2.21.1810131505230.375@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1810131505230.375@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

Am 13.10.2018 um 17:09 schrieb Finn Thain:
> On Sat, 13 Oct 2018, Michael Schmitz wrote:
>
>> Hi Finn,
>>
>> Am 13.10.2018 um 13:51 schrieb Finn Thain:
>>> Avoid function calls in the inner PIO loops. On a Centris 660av this
>>> improves throughput for sequential read transfers by about 40% and
>>> sequential write by about 10%.
>>>
>>> Unfortunately it is not possible to have method calls like esp_write8()
>>> placed inline so this is always going to be slow (even with LTO).
>>>
>>> Tested-by: Stan Johnson <userm57@yahoo.com>
>>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>>> ---
>>>  drivers/scsi/esp_scsi.c | 14 +++++++-------
>>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
>>> index 646701fc22a4..9f0e68cd0e99 100644
>>> --- a/drivers/scsi/esp_scsi.c
>>> +++ b/drivers/scsi/esp_scsi.c
>>> @@ -2788,7 +2788,7 @@ static inline unsigned int esp_wait_for_fifo(struct
>>> esp *esp)
>>>  		if (fbytes)
>>>  			return fbytes;
>>>
>>> -		udelay(2);
>>> +		udelay(1);
>>>  	} while (--i);
>>>
>>>  	pr_err("FIFO is empty (sreg %02x)\n", esp_read8(ESP_STATUS));
>>> @@ -2804,7 +2804,7 @@ static inline int esp_wait_for_intr(struct esp *esp)
>>>  		if (esp->sreg & ESP_STAT_INTR)
>>>  			return 0;
>>>
>>> -		udelay(2);
>>> +		udelay(1);
>>>  	} while (--i);
>>>
>>>  	pr_err("IRQ timeout (sreg %02x)\n", esp->sreg);
>>> @@ -2831,7 +2831,7 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32
>>> esp_count,
>>>  			if (!esp_wait_for_fifo(esp))
>>>  				break;
>>>
>>> -			*dst++ = esp_read8(ESP_FDATA);
>>> +			*dst++ = readb(esp->fifo_reg);
>>>  			--esp_count;
>>>
>>>  			if (!esp_count)
>>> @@ -2852,15 +2852,15 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32
>>> esp_count,
>>>  			}
>>>
>>>  			if (phase == ESP_MIP)
>>> -				scsi_esp_cmd(esp, ESP_CMD_MOK);
>>> +				esp_write8(ESP_CMD_MOK, ESP_CMD);
>>
>> You're no longer logging this command with this patch. (That'll be the reason
>> for the speedup you saw ...)
>>
>>>
>>> -			scsi_esp_cmd(esp, ESP_CMD_TI);
>>> +			esp_write8(ESP_CMD_TI, ESP_CMD);
>>
>> Same here..
>>
>>>  		}
>>>  	} else {
>>>  		unsigned int n = ESP_FIFO_SIZE;
>>>  		u8 *src = (u8 *)addr;
>>>
>>> -		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>>> +		esp_write8(ESP_CMD_FLUSH, ESP_CMD);
>>
>> here..
>>
>>>
>>>  		if (n > esp_count)
>>>  			n = esp_count;
>>> @@ -2894,7 +2894,7 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32
>>> esp_count,
>>>  			src += n;
>>>  			esp_count -= n;
>>>
>>> -			scsi_esp_cmd(esp, ESP_CMD_TI);
>>> +			esp_write8(ESP_CMD_TI, ESP_CMD);
>>
>> and here.
>>
>
> Yes, it's deliberate.

I'm sure it was... and I wasn't objecting to that.

>> The burst of ESP_CMD_TI's in the log was quite useful to spot what went
>> wrong during PIO.
>
> I don't think it's as useful as you seem to think. Compare
> mac_esp_send_pdma_cmd().
>
>> Maybe mention in the changelog that commands during PIO are no longer
>> logged? Or introduce a new ESP_EVENT_PIO and log that at the start of
>> PIO?
>>
>
> Yes, and I did leave a scsi_esp_cmd(esp, cmd) call at the start of PIO.

Which I missed from just looking at the patch, sorry.

> That should be sufficient, right?

It would indeed. Thanks for clarifying.

Cheers,

	Michael

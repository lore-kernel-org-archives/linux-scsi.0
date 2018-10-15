From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Mon, 15 Oct 2018 12:58:42 +0200
Message-ID: <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
 <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de>
 <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/15/18 8:25 AM, Finn Thain wrote:
> On Mon, 15 Oct 2018, Hannes Reinecke wrote:
> 
>> On 10/14/18 8:12 AM, Finn Thain wrote:
>>> As a temporary measure, the code to implement PIO transfers was
>>> duplicated in zorro_esp and mac_esp. Now that it has stabilized
>>> move the common code into the core driver but don't build it unless
>>> needed.
>>>
>>> This replaces the inline assembler with more portable writesb() calls.
>>> Optimizing the m68k writesb() implementation is a separate patch.
>>>
>>> Tested-by: Stan Johnson <userm57@yahoo.com>
>>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>>> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
>>> ---
>>> Changed since v1:
>>>    - Use shost_printk() instead of pr_err().
>>>    - Add new symbol CONFIG_SCSI_ESP_PIO to Kconfig.
>>> ---
>>>    drivers/scsi/Kconfig     |   6 +
>>>    drivers/scsi/esp_scsi.c  | 128 +++++++++++++++++++++
>>>    drivers/scsi/esp_scsi.h  |   5 +
>>>    drivers/scsi/mac_esp.c   | 173 +----------------------------
>>>    drivers/scsi/zorro_esp.c | 232 ++++++---------------------------------
>>>    5 files changed, 179 insertions(+), 365 deletions(-)
>>>
[ .. ]
>>> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
>>> index d0c032803749..2590e5eda595 100644
>>> --- a/drivers/scsi/esp_scsi.h
>>> +++ b/drivers/scsi/esp_scsi.h
>>> @@ -431,6 +431,7 @@ struct esp_driver_ops {
>>>    struct esp {
>>>    	void __iomem		*regs;
>>>    	void __iomem		*dma_regs;
>>> +	u8 __iomem		*fifo_reg;
>>>      	const struct esp_driver_ops *ops;
>>>    @@ -540,6 +541,7 @@ struct esp {
>>>    	void			*dma;
>>>    	int			dmarev;
>>>    +	int			send_cmd_error;
>>>    	int			send_cmd_residual;
>>>    };
>>>    
>> These variables are only used within esp_send_pio_cmd(); consider making them
>> conditional based on the config option.
>>
> 
> In the case of send_cmd_residual, that would mean a second #ifdef added to
> esp_data_bytes_sent() where it gets used. I'm happy to comply but I fear
> that all these #ifdefs may harm readability...
> 
> There are already other variables in struct esp that may go unused, such
> as dma_regs, that don't have #ifdefs to elide them. Are these also
> problematic in some way?
> 
The unused fields in the struct are not so much an issue; in fact, it 
rather complicated things when having individual fields in the struct
surrounded by CONFIG_XXX, as then the order of the fields would change
depending on the configuration. Which makes it really hard to debug ..

However, the function declaration really is a worry, as the actual 
function body only exists when the config option is enabled.
So either add a dummy function or surround the function declaration by 
CONFIG_ESP_PIO.
Otherwise I think Dan Carpenter and the likes are guaranteed to send you 
a nice mail complaining about this ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

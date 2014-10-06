From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Mon, 06 Oct 2014 21:14:48 +1300
Message-ID: <54324F78.6090303@gmail.com>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au> <CAMuHMdWmxEUMabRrbQpjhWTE1W4WD4CDkmXZNem06C0ScnKkFw@mail.gmail.com> <alpine.LNX.2.00.1410032054150.12643@nippy.intranet> <54308629.6060800@gmail.com> <alpine.LNX.2.00.1410061754280.26699@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1410061754280.26699@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

>>>> Can these be handled through the platform_device's resources?
>>>>
>>>>     
>>>>         
>>> I don't know.
>>>   
>>>       
>> Should be possible - I've seen that used in the ISP116x HCD driver 
>> (arch-dependent post-register access delay function passed via platform 
>> data).
>>     
>
> Yes, possible, but is it desirable?
>   

Only long term, i.e. if we can find a way to fold all the separate 
*_NCR5380 drivers into a core one.


>
> If there's no third configuration then I see little to be gained from 
> completely parameterizing the driver using a bunch of resources.
>
> What am I missing? Why would it be desirable to have bits of driver code 
> in arch/m68k/ and other bits of the same driver kept elsewhere in the 
> tree (in drivers/)?
>
>   

Again, only makes sense if the goal is to reduce the driver to a core 
driver with implementation bits separate.

>>>> (and IRQ_NONE is wrong, you should use 0)
>>>>
>>>>     
>>>>         
>>>>> +       if (IS_A_TT()) {
>>>>>       
>>>>>           
>>>> Check for instance->irq instead?
>>>>     
>>>>         
>>> Yes, you'd think so, but a later patch (not in this set) would have to 
>>> change it back to IS_A_TT().
>>>
>>> Further patches align atari_NCR5380.c with NCR5380.c, such that the 
>>> core driver then checks host->irq to find out whether an IRQ is in 
>>> use. For Atari ST, request_irq() is not called even though the ST DMA 
>>> irq is in use.
>>>   
>>>       
>> That's why the IRQ is set to 0, I guess? Works for me.
>>     
>
> My patch tests for IS_A_TT not 0 because 0 has a different meaning 
> depending on which core driver you use. I don't want to support three 
> forks of NCR5380.c. One of the objectives of this patch series is to try 
> to move toward convergence on a common core driver.
>   

I wasn't talking about the use of IS_A_TT() here, rather about what 
host->irq = 0 achieves. Anyway, in the context of atari_scsi.c, 
host->irq == 0 is synonymous with !IS_A_TT(). If
host->irq == 0 is problematic with the long term goal of a singe 5380 
core driver, we'll just have to pick a value which means 'driver uses 
IRQ but you're not to fiddle with it'.
>> The old code states that setting instance->irq = 0 keeps the midlevel 
>> from tampering with the SCSI IRQ during queuecmd which would interfere 
>> with IDE and floppy.
>>     
>
> I don't know what you mean. AFAIK, the SCSI mid layer doesn't care about 
> instance->irq.
>   

You're right - that's another obsolete comment then. The midlevel uses 
spinlocks now for ages, this means we can set instance->irq to the 
actual IRQ used.

>> I guess this is still relevant - I would not have seen the ST-DMA locked 
>> by IDE during SCSI queuecmd otherwise.
>>     
>
> Lock-ups were due to disabling local IRQs. Please see,
>   

Absolutely right, but that's not what I meant. I assumed the midlevel 
disabled interrupts during queuecommand - it does not, so the point is 
moot. If using the actual IRQ for instance->irq helps at all, no 
objection to that.

SCSI commands can still be queued while IDE IO is in flight - that is 
what the 'ST-DMA locked by IDE' above refers to.

Cheers,

    Michael

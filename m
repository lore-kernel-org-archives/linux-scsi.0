From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Sun, 26 Oct 2014 20:37:05 +1300
Message-ID: <544CA4A1.6050802@gmail.com>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au> <5444BAB7.5000908@gmail.com> <alpine.LNX.2.00.1410202217270.18012@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1410202217270.18012@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Finn,
> On Mon, 20 Oct 2014, Michael Schmitz wrote:
>
>   
>> Hi Finn,
>>
>> not certain it is related to this exact patch - the driver crashes 
>> pretty much on the spot when selecting the first target on the bus.
>>     
>
> If it isn't that exact patch then it will probably be one of the other 
> atari_scsi patches. Most of the other relevant stuff was covered by my own 
> testing.
>
> Anyway, thanks for testing and for sending the backtrace. I'll figure out 
> what went wrong and fix it before I send a new patch set.
>
>   

Turns out I missed a reject in patch 29 of the series (hunk #4) which 
caused a local_irq_save(flags) to go AWOL. Both commenting out the 
resulting lone local_irq_restore(flags), as well as fixing the reject 
properly makes the driver behave as it should.

No locking races, and no more warnings about bytes stuck in the DMA 
fifo. We might be on to a winner here :-)

Cheers,

    Michael

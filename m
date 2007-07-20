From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: Re: ESP SCSI and QLGC,ISP SCSI drivers not finding attached devices
Date: Fri, 20 Jul 2007 21:27:42 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707202101270.8250@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
 <1184941136.3455.8.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
 <1184950646.3455.45.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
Sender: sparclinux-owner@vger.kernel.org
To: davem@davemloft.net
Cc: James.Bottomley@SteelEye.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi David,

I have found that on my sun4c, I need to increase the ESP_BUS_TIMEOUT from 
250ms to 275ms when I build the ESP driver into the kernel or the ESP 
does not find the disk.

If I build the driver as a module, this extra 25ms is not required. Any 
idears?

Given that the V1 EPS driver used 275ms and the 250ms is only recommended 
(SCSI II Std. ISO-IEC-9316-1995), should the ESP_BUS_TIMEOUT be changed 
back to 275ms?

Regards
 	Mark Fortescue.

On Fri, 20 Jul 2007, Mark Fortescue wrote:

>
> Ok.
>
> I have found a difference in the timeouts. V1 driver it is 275ms, V2 driver 
> it is 250ms. It looks like that extra 25ms is needed on the sun4c :).
>
> I will do a quick test with the existing setup as a modular ESP and then 
> re-build with a 275ms timeout and see if that fixes the problem.
>
> Regards
> 	Mark Fortescue.
>
> On Fri, 20 Jul 2007, James Bottomley wrote:
>
>> On Fri, 2007-07-20 at 16:22 +0100, Mark Fortescue wrote:
>>> Thansk for the info. I will try some experiments and see if I can work
>>> out where the scsi commands/responses are getting lost.
>> 
>> Actually, for ESP it looks like you can alter the timeout ... it's the
>> parameter ESP_BUS_TIMEOUT in drivers/scsi/esp_scsi.h
>> 
>> It could be that the register calculation is off here ... but someone
>> who knows the device would have to look at it (or you could time it, I
>> suppose).
>> 
>>> I do not beleave the issue with the ESP is a hardware problem. The PROM
>>> and SunOS-4.1.1 have no problem finding/accessing the disk on the ESP and
>>> I did not observe any issues prior to testing Linux v2.6.22. The V1 ESP
>>> SCSI driver never failed to find the ESP disk (on kernels that got that
>>> far) but I have not done as much testing with the V2 ESP driver as memory
>>> problems post v2.6.21 needed to be fixed to get things up and running.
>> 
>> James
>> 
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> -
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

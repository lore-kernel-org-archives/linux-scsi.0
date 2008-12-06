From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 02:19:03 +0300
Message-ID: <493B0867.5020700@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com>	<20081206222423.04aada70@lxorguk.ukuu.org.uk>	<493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Alan Cox wrote:

>>    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
>> for...
>>     
>
> Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).
>   

   ATAPI is SCSI transport (with maybe some quirks at SCSI command level 
tho, IIRC). ATA is neither thansport nor does it map to SCSI 1:1. The 
code for emulating SCSI on ATA only burdens the kernel (and causes user 
complaints about changing disk names from /dev/hdx to /dev/sda :-).

> I'm actually seeing two strands of requests (including from embedded)
>
> - CF only small "dumb as president" type driver that is written to be as
> compact as possible and preferably considers IRQs as optional
>   

   Yes, support for IRQ-less CF is what IDE core lacks. I must note 
however that IRQ-less mode looks inherently risky to me because of the 
raciness of tbothe the ATA spec and its implimentatin WRT the "interrupt 
pending" state. I may be mistaking but someone of T13 experts (Hale 
Landis I guess) told me that the devices require that state to be 
cleared to proceed with the command, and that's what the fast polling 
host is likely to fail at because it doesn't know if rthe device has 
actually entered this state when BSY is cleared... Oh well, that's an 
old story...

> - Full SATA and NCQ aware platform support.
>   

   I don't see how SATA/NCQ support is connected to SCSI.

> although the former is growing quieter and it seems the CF formfactor is
>   

   We're seeing the IRQ-less CF driver submitted for the Octeon SoC 
(which employs up to 16 MIPS cores) -- though it's probably needed only 
for the development boards... :-)

> just too clunky for embedded nowdays, especially with the horrendously
> complex and pricy connector - and is being eliminated by MMC/SD and
> friends.
>   

  Oh, don't tell me about that MMC crap. :-)
  For some reason they keep wring the card insert and write protect 
signals via GPIO, not directly into controller (and it's yet good if 
directly into SoC's own GPIO, not an expander) -- which requires the 
drivers to call the platform code hooks. :-(

> Alan
>   

MBR, Sergei



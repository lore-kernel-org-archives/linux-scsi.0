From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 10/71] atari_NCR5380: Remove RESET_BOOT, CONFIG_ATARI_SCSI_TOSHIBA_DELAY
 and CONFIG_ATARI_SCSI_RESET_BOOT
Date: Thu, 19 Nov 2015 17:43:57 +1300
Message-ID: <564D538D.2070905@gmail.com>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083457.891774987@telegraphics.com.au> <564D3C6C.7020600@gmail.com> <alpine.LNX.2.00.1511191505080.13423@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511191505080.13423@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

Am 19.11.2015 um 17:05 schrieb Finn Thain:
> w
> On Thu, 19 Nov 2015, Michael Schmitz wrote:
> 
>> Hi Finn,
>>
>> Am 18.11.2015 um 21:35 schrieb Finn Thain:
>>
>>> The bus reset may raise an interrupt. That would be new behaviour for 
>>> atari_scsi only when CONFIG_ATARI_SCSI_RESET_BOOT=n. The ST DMA 
>>> interrupt is not assigned to atari_scsi at this stage, so 
>>> CONFIG_ATARI_SCSI_RESET_BOOT=y may well be problematic already.
>>
>> I can confirm that the bus reset at boot has never been problematic in 
>> the past. It's been enabled in my kernels as long as I've used the 
>> driver (must be getting close to 20 years now).
> 
> That's good to know. I'm not sure why it was configurable in the first 
> place (long delays?). The new algorithm (the one I copied from NCR5380.c) 

The longer delays (and possibly a reset at boot) were only necessary for
certain CD-ROM drives. I don't think I have ever seen such a device, and
it's a bit unlikely any of these still survive. Reset at boot before
proper driver init can probably go away now.

> does not allow the user to prevent a possible scsi bus reset at driver 
> init time. The scsi bus reset only takes place if the driver discovers 
> that the bus was already wedged when it started. (It proved useful when I 
> was introducing faults for EH testing, BTW.)

Much saner approach, I'm sure. Don't forget the driver was written
before sophisticated error handling came along. Reset at boot and keep
your fingers crossed was the strategy in these days.

Cheers,

	Michael

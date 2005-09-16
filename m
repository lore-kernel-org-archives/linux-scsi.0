From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Fri, 16 Sep 2005 12:11:52 -0400
Message-ID: <432AEEC8.3030800@rtr.ca>
References: <355e5e5e05080103021a8239df@mail.gmail.com>	 <4789af9e050823124140eb924f@mail.gmail.com>	 <4789af9e050823154364c8e9eb@mail.gmail.com>	 <430BA990.9090807@mvista.com> <430BCB41.5070206@s5r6.in-berlin.de>	 <355e5e5e05082407031138120a@mail.gmail.com>	 <4789af9e05082408111c4a6294@mail.gmail.com>	 <4789af9e05082409121cc6870@mail.gmail.com>	 <4789af9e0508291223435f174@mail.gmail.com>	 <4789af9e05090612023fb8517c@mail.gmail.com> <355e5e5e050914214025feee82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <355e5e5e050914214025feee82@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: lkosewsk@gmail.com
Cc: jim.ramsay@gmail.com, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> On 9/6/05, Jim Ramsay <jim.ramsay@gmail.com> wrote:
> 
>>However, I have seen the occasion where a single IRQ is used to signal
>>both a DMA completion AND a hotplug event.  Of course in this case the
>>hotplug event itself would be ignored completely.
>>
>>So I would recommend getting rid of that check entirely.
> 
> 
> Hey Jim,
> 
> Not that I disbelieve you, but do you have an example of a controller
> where this happens?  I've done a lot of testing and never seen this...

I missed the beginning of this discussion,
but here's a data point:

The QStor SATA/RAID controller hardware fully supports hotplug
(and NCQ, TCQ, Host-Queuing, RAID 0/1/10, PM, etc..).

It uses a single interrupt for all onboard events from the four channels.
An internal "status FIFO" provides a readout for the interrupt handler
of recent happenings, in sequence, mixing together DMA-completions
with hotplug-events (insert, removal) and various fault-conditions.

All of this is supported in the out-of-tree qstor driver,
but only simple single-IO is supported by sata_qstor at present.

Dunno if that info is of any use to you in hotplug considerations.
Once the libata infrastructure for hotplug is in place,
I *may* experiment with adding that functionality to sata_qstor.

Cheers

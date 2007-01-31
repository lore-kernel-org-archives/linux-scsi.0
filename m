From: Ric Wheeler <ric@emc.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 11:35:14 -0500
Message-ID: <45C0C542.2090609@emc.com>
References: <200701301947.08478.liml@rtr.ca>	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>	<311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	<45BFF3D6.9050605@rtr.ca>	<45C00AEE.1090708@emc.com>	<45C0B0DC.8030501@rtr.ca> <20070131152301.19a8a5ac@localhost.localdomain>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070131152301.19a8a5ac@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Mark Lord <liml@rtr.ca>, "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org



Alan wrote:
>> When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
>> as the drive itself has already done internal retries (libata uses the
>> "with retry" ATA opcodes for this).
> 
> This depends on the firmware. Some of the "raid firmware" drives don't
> appear to do retries in firmware.

I think that even for these devices, the actual drives behind the controller 
will do retries. In any case, it would be reasonable to be able to set this 
retry/no-retry via /sys to handle exceptional cases...

> 
>> But meanwhile, we still have the original issue too, where a single stray
>> bad sector can blow a system out of the water, because the mid-layer
>> currently aborts everything after it from a large merged request.
>>
>> Thus the original patch from this thread.  :)
> 
> Agreed



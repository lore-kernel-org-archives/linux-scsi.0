From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 12:57:53 -0500
Message-ID: <45C0D8A1.2030506@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>	<311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	<45BFF3D6.9050605@rtr.ca>	<45C00AEE.1090708@emc.com>	<45C0B0DC.8030501@rtr.ca> <20070131152301.19a8a5ac@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070131152301.19a8a5ac@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

Alan wrote:
>> When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
>> as the drive itself has already done internal retries (libata uses the
>> "with retry" ATA opcodes for this).
> 
> This depends on the firmware. Some of the "raid firmware" drives don't
> appear to do retries in firmware.

One way to tell if this is true, is simply to time how long
the failed operation takes.  If the drive truly does not do retries,
then the media error should be reported more or less instantly
(assuming drive was already spun up).

If the failure takes more than a few hundred milliseconds to be reported,
or in this case 4-7 seconds typically, then we know the drive was doing
retries before it reported back.

I haven't seen any drive fail instantly yet.
Can anyone with those newfangled "RAID edition" drives try it
and report back?  Oh.. you'll need a way to create a bad sector.
I've got patches and a command-line utility for the job.

If your drive supports "WRITE UNCORRECTABLE" ("hdparm -I", w/latest hdparm),
then the patches aren't needed.

>> But meanwhile, we still have the original issue too, where a single stray
>> bad sector can blow a system out of the water, because the mid-layer
>> currently aborts everything after it from a large merged request.
>>
>> Thus the original patch from this thread.  :)
> 
> Agreed

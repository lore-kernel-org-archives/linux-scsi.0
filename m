From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Tue, 12 Dec 2006 09:02:32 -0500
Message-ID: <457EB678.6010507@pobox.com>
References: <20061208211236.GC29763@parisc-linux.org> <457D800E.5070908@pobox.com> <20061211160945.GC21070@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20061211160945.GC21070@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Dec 11, 2006 at 10:58:06AM -0500, Jeff Garzik wrote:
>> The time-consuming portion already takes place in a thread.  Do you mean 
>> multiple threads?  Or, ATA's scan is in one thread, while work continues 
>> in other threads?
>>
>> Patch seems sane, provided that I am educated a bit :)
> 
> Each host will be scanned in its own thread.  So boot-up and
> initialisation of other devices (eg, USB, networking, PS/2, etc) will
> continue.  Drive ordering and numbering is maintained, and the default
> configuration right now is to not enable this feature.
> 
> We have infrastructure in place to make sure that all discs are found
> before we try to start init or autorun RAID.  If there's anywhere we're
> missing a call to scsi_complete_async_scans(), it'll affect SCSI as much
> as it will IDE, and I'm extremely interested in fixing it.

oh, err, hum.

libata uses one scsihost per port, not one-per-controller, so it won't 
work like you think.

This will conflict with AHCI's staggered spin-up, at least.

	Jeff




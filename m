From: Steven Dake <sdake@mvista.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 16:48:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB886B9.3060304@mvista.com>
References: <Pine.LNX.4.33L2.0210241350230.20950-100000@dragon.pdx.osdl.net> <Pine.LNX.4.33.0210241839490.10937-100000@rancor.yyz.somanetworks.com> <20021024232258.GA26093@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Scott Murray <scottm@somanetworks.com>, "Randy.Dunlap" <rddunlap@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Montavista has discussed at length Compact PCI hotswap using surprise 
removal events.

The key feature of any hotswap operation that happens in a surprise 
fashion is that
the device driver might want a hint that the hardware is no longer 
present so it can
immediatly dump its buffers/io maps/etc and totally stop accessing the 
device.  An
expected removal, on the other hand, would give the device driver time 
to flush its
buffers (for example a scsi driver could dump its outstanding queued 
scsi messages).
Once the driver is done accessing the device, the blue led on the 
CompactPCI board
can be lit and it can be removed.

This is the main difference.  Since the driver model of Linux doesn't 
support a surprise
extract method call for drivers, I don't think its been implemented 
here.  Further the
drivers must be modified to actually use the hint instead of doing its 
normal shutdown
operation.

Surprise extraction is not a simple problem especially to ensure the 
device drivers exit
cleanly without dumping more data on the PCI bus to a PCI device that 
may not
exist.

Thanks!
-steve

Greg KH wrote:

>On Thu, Oct 24, 2002 at 07:00:23PM -0400, Scott Murray wrote:
>  
>
>>I've not implemented it yet, but I'm pretty sure I can detect surprise
>>extractions in my cPCI driver.  The only thing holding me back at the
>>moment is that there's no clear way to report this status change via
>>pcihpfs without doing something a bit funky like reporting "-1" in the
>>"adapter" node.
>>    
>>
>
>Why would you need to report anything other than if the card is present
>or not?  What would a "supprise" removal cause you to do differently?
>Hm, well I guess we should be extra careful in trying to shut down any
>driver bound to that card...
>
>thanks,
>
>greg k-h
>
>
>
>  
>


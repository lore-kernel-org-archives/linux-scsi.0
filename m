From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Sat, 16 Oct 2004 17:50:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C08670D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33964 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S268920AbUJPVua convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 17:50:30 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

We're completing our 8.0.13 release and need to address your comments on binary sysfs attributes

> I don't like many of the binary attributes at all.  As a 
> general rule of thumb never ever use a binary sysfs
> attribute unless it's passed through to the hardware.

There are 5 binary attributes:
- Statistics:
This is replaced by the proposed fc transport patch sent out this week. It will be replaced by the functions supporting the patch.

- slimreg, ctlrreg, and mbox: 
 > For slimreg and ctlreg that is true, but I wonder whether 
 > they're needed at all.  Check how recent X servers access mmio space.
As mentioned, these should meet your definition and be fine. You asked whether they are needed at all. Given that these are the heart of the adapter message passing interface, and used extensively by the driver - having the user space application use them without the coordination of the driver is asking for trouble. Minimally, the driver's lock over the registers/memory needs to be involved. In some cases, the driver remaps these areas away from pci memory and into driver-allocated dma-mapped memory. The application would have no clue where to locate these.  These should stay as is.  It is through these interfaces that diagnostics, firmware loading, and the like take place.

- sendrnid and ctpass:
 > The sendrnid and ctpass ones looks extremly fishy, it's 
 > certainly not a single value that's read/written, and it's
 > deeply magic (and btw, current->pid is not uniqueue in a
 > multithreaded enviroment)
These are used to have the application (usually a storage management suite) interact with FC fabrics - performing requests of nameservers, querying for additional node id information, etc. The use is typically to build topology maps of the FC fabric and the devices attached. Given the payload gets converted into a request to the firmware, it does get posted to the hardware. We do need to find a unique identifier to associate with the thread issuing the request - if for nothing else to associate the responses to the right request as this must be a multi-step function (minimally - write of request, read of response). We could single-thread this so that only one request is outstanding. In this case, the unique id could enforce the single outstanding request. Otherwise it's a voluntary function (e.g. only do the read if your write didn't get rejected). These will be pushed into the fc transp
 ort as host functions in a later patch - so it's function will be fully described/open. One thing we will need to work on is allowing >4k payloads.  Comments ? Issues ? If there is a better way to inject non-FCP FC traffic onto a link, please tell me.

-- James S



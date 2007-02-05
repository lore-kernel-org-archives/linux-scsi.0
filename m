From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_IO weirdness
Date: Mon, 05 Feb 2007 14:17:35 -0500
Message-ID: <45C782CF.9030207@torque.net>
References: <558F4D473FD7FE419B019232BF2D37B40B22F2@G3W0634.americas.hpqcorp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45985 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbXBETRp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 14:17:45 -0500
In-Reply-To: <558F4D473FD7FE419B019232BF2D37B40B22F2@G3W0634.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: linux-scsi@vger.kernel.org

Cameron, Steve wrote:
> I noticed that when I do two SG_IO ioctls to a target
> device (say, tape drive, disk drive, whatever) in which
> the first request is well formed (e.g. an inquiry) and the 
> second one has a malformed CDB, such that it gets check condition 
> with sense key == 5 (ILLEGAL REQUEST), the data buffer returned for 
> the second malformed SG_IO request is filled out with the same 
> data as was returned for the first successful command (e.g. the 
> same inquiry data again.)  I'm using separate data buffers for
> the two commands, and memsetting them to zero before calling
> ioctl().  I don't think this data is coming from the device,
> as it happens with every device I've tried.
> 
> Is that normal?  Seems like for a malformed request, the 
> data buffer should not be transferred at all, much less
> transferred with contents of a prior request's data buffer.
> 
> Kernel is 2.6.18 from kernel.org.

Steve,
Even though the SCSI status is CHECK CONDITION, the data-in
buffer may still be transferred. One obvious example
is a READ command when the sense key is RECOVERED ERROR.

The sg driver and I suspect the block layer SG_IO do
not check the SCSI status to determine whether or not
to transfer the data-in buffer (or where it would have
been DMA-ed to if the command worked) back to user space.
If it was _direct_ IO then the block layer SG_IO and the
sg driver would have no control over the data-in transfer
(apart from setting it up).

Both the sg driver and the block layer SG_IO could check
the resid field which a LLD should set after a DMA
(especially inbound). However LLDs are not compelled to
set resid properly.

So a few questions:
 - block layer SG_IO, the sg driver or both?
 - indirect IO (i.e. O_DIRECT not set)?
 - did the offending process have superuser permissions?
 - did the resid field indicate a short data-in transfer?

> The two requests were done from the same process, I haven't
> tried two separate processes to see if one process could
> by this method access another process's data.  I did try
> using two devices, so the first well formed command went 
> to one device, and the 2nd, malformed command went to another
> device.  In that case, I didn't get the same buffer back again,
> but garbage. (some recognizeable strings, "en_US" was in there...)
> 
> Is this a problem, or is this a matter of "just don't do that."?

As long as the SCSI status and sense buffer are conveyed
back properly _and_ this is only observed when the
process has superuser permissions, then I wouldn't
regard it as serious. Others may disagree.

Doug Gilbert

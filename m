From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Asynchronous scsi scanning
Date: Thu, 11 May 2006 13:49:26 -0500
Message-ID: <44638736.70708@cs.wisc.edu>
References: <20060511143352.GI12272@parisc-linux.org> <44637F4C.3070102@cs.wisc.edu> <20060511182119.GK12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:8833 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750962AbWEKSqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 14:46:05 -0400
In-Reply-To: <20060511182119.GK12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, May 11, 2006 at 01:15:40PM -0500, Mike Christie wrote:
>> Instead of all the scanning from work queue and kthreads, what about
>> just running something from the host addition hotplug event. When a host
>> or target or rport or whatever we want is added, userspace gets a
>> hotplug event today, I thought. From that event could you just do
>>
>> echo - - - > path-to-object/scan
> 
> 1) Assumes userspace exists.  People still use monolithic kernels and
> there's no requirement for initramfs yet.

Ok you are right, I thought you were going to handle the insmod
returning early problem in userspsace with some sort of wait like is
done for usb in I think fedora.

> 2) Unless it's serialised (in which case it still takes two hours to
> boot), you lose drive numbering.
> 

Drive numbering refers to the bus, target numbering right? Currently
when you scan a host you are serialized at the host level because of the
host->scan_mutex aren't we? So for each host addition hotplug event you
can scan that host with the command above, and then you can scan all
your hosts in parallel and the drive numbering is not affected is it? I
thought, your patch is basically creating a kernel thread and running
scan host selected, which grabs the scan_mutex, with all wild cards.
What I suggested ends up calling scan host selected with all wild cards
but from userspace.

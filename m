From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 10:27:46 -0500
Message-ID: <49130CF2.6010403@hp.com>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:8312 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYKFP1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 10:27:55 -0500
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

Ric Wheeler wrote:
> 
> After talking to some vendors, one issue that came up is that the arrays 
> all have a different size that is used internally to track the SCSI 
> equivalent of TRIM commands (POKE/unmap).
> 
> What they would like is for us to coalesce these commands into aligned 
> multiples of these chunks. If not, the target device will most likely 
> ignore the bits at the beginning and end (and all small requests).
> 
> I have been thinking about whether or not we can (and should) do 
> anything more than our current best effort to send down large chunks 
> (note that the "chunk" size can range from reasonable sizes like 8KB or 
> so up to close to 1MB!).

The rational way to do this is to admit TRIM is only a feature
for filesystems that can set their allocation block size to
aligned multiples of the device "trim chunk size".

And the vendors need to provide the device trim chunk size in
a standard way (like scsi geometry) to the filesystem.

Devices with a trim chunk size of 512 bytes would work with
all filesystems.  Devices with larger trim chunk sizes would
only receive trim commands from filesystems that can do large
allocation blocks (such as btrfs).

> One suggestion is that a modified defrag sweep could be used 
> periodically to update the device (a proposal I am not keen on).

I don't like it either.  But nothing prevents an array vendor
from building and shipping a tool to do this to fix their
big 1MB trim with small blocking filesystems.

jim

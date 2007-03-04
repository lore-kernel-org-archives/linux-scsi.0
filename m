From: Douglas Gilbert <dougg@torque.net>
Subject: Re: convert sg to block layer helpers - v5
Date: Sun, 04 Mar 2007 15:17:30 -0500
Message-ID: <45EB295A.30601@torque.net>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <45EB1EE9.20908@torque.net> <45EB2484.6030700@cs.wisc.edu>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53824 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXCDURx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 15:17:53 -0500
In-Reply-To: <45EB2484.6030700@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Mike Christie wrote:
> Douglas Gilbert wrote:
>> Mike,
>> I see you are removing the scatter_elem_sz parameter.
>> What decides the scatter gather element size? Can it
>> be greater than PAGE_SIZE?
> 
> Oh yeah, sorry I should have documented that.
> 
> I just made the code try to allocate as large a element as possible.
> So the code looks at q->max_segment_size and tries to allocate segments
> that large initially. If that is too large then it will drop down by
> half like what sg.c used to do when it could not allocate large segments.
> 
> I will add the param back if you want. I had thought it was a workaound
> due to the segment size of a device not being exported.
> 
>>
>> *** Generalizing the idea of a mmap-ed reserve buffer to
>> something the user had more control over could be very
>> powerful.
>> For example allowing two file descriptors (to different
>> devices) in the same process to share the same mmap-ed
>> area. This would allow a device to device copy to DMA into
>> and out of the same memory, potentially with large per command
>> transfers and with no per command scatter gather build and
>> tear down. Basically a zero copy copy with minimal CPU
>> overhead.
>>
> 
> I was thinking of something similar but not based on mmap. I have been
> trying to figure out a way to do sg io splice. I do not care what
> interface or method is used, I think it would be useful.
> 
> I know we talked about the mmap approach a little, but I do not remember
> if we talked about how to tell both fds that they are going to use the
> same buffer. Would we need a modification to the sg header or would we
> need to add in a new IOCTL which would tell sg.c to share the buffer
> between two fds?

Mike,
Currently there is a flag in sgv3:
#define SG_FLAG_MMAP_IO 4
and when it is active the dxferp field is ignored
as it is assumed the user previously did a mmap()
call to get the reserved buffer.

We could add a:
#define SG_FLAG_MMAP_IO_SHARED 8
and then the pointer in dxferp could taken as
the already mmap-ed buffer from another device.


Having more than one mmap-ed IO buffer per file
descriptor would be nice but opening multiple
file descriptors to the same device can give
the same effect (with perhaps a POSIX thread per
file descriptor).


Doug Gilbert


From: Douglas Gilbert <dougg@torque.net>
Subject: Re: convert sg to block layer helpers - v5
Date: Sun, 04 Mar 2007 14:32:57 -0500
Message-ID: <45EB1EE9.20908@torque.net>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48690 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXCDTd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 14:33:26 -0500
In-Reply-To: <1173033084706-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

michaelc@cs.wisc.edu wrote:
> There is no big changes between v4 and v5. I was able to fix
> things in scsi tgt, so I could remove the weird arguements
> the block helpers were taking for it. I also tried to break
> up the patchset for easier viewing. The final patch also
> takes care of the access_ok regression.
> 
> These patches were made against linus's tree since Tomo needed
> me to break part of it out for his scsi tgt bug fix patches.
> 
> 0001-rm-bio-hacks-in-scsi-tgt.txt - Drop scsi tgt's bio_map_user
> usage and convert it to blk_rq_map_user. Tomo is also sending
> this patch in his patchset since he needs it for his bug fixes.
> 
> 0002-rm-block-device-arg-from-bio-map-user.txt - The block_device
> argument is never used in the bio map user functions, so this
> patch drops it.
> 
> 0003-Support-large-sg-io-segments.txt - Modify the bio functions
> to allocate multiple pages at once instead of a single page.
> 
> 0004-Add-reserve-buffer-for-sg-io.txt - Add reserve buffer support
> to the block layer for sg and st indirect IO use.
> 
> 0005-Add-sg-io-mmap-helper.txt - Add some block layer helpers for
> sg mmap support.
> 
> 0006-Convert-sg-to-block-layer-helpers.txt - Convert sg to block
> layer helpers.
> 
> 0007-mv-user-buffer-copy-access_ok-test-to-block-helper.txt - 
> Move user data buffer access_ok tests to block layer helpers.
> 
> The goal of this patchset is to remove scsi_execute_async and
> reduce code duplication.
> 
> People want to discuss further merging sg and bsg/scsi_ioctl
> functionality, but I did not handle and any of that in this
> patchset since people still disagree on what should supported
> with future interfaces.
> 
> My only TODO is maybe make the bio reserve buffer mempoolable
> (make it work as mempool alloc and free functions). Since
> sg only supported one reserve buffer per fd I have not worked
> on it and it did not seem worth it if there are no users.
***

Mike,
I see you are removing the scatter_elem_sz parameter.
What decides the scatter gather element size? Can it
be greater than PAGE_SIZE?


*** Generalizing the idea of a mmap-ed reserve buffer to
something the user had more control over could be very
powerful.
For example allowing two file descriptors (to different
devices) in the same process to share the same mmap-ed
area. This would allow a device to device copy to DMA into
and out of the same memory, potentially with large per command
transfers and with no per command scatter gather build and
tear down. Basically a zero copy copy with minimal CPU
overhead.

Doug Gilbert




From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: RAW I/O
Date: Wed, 30 Jun 2004 17:26:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF7D953B6F.8F1EC5DA-ON88256EC4.000175B0-88256EC4.00026E5D@us.ibm.com>
References: <20040629053446.73235.qmail@web90102.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:39905 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263413AbUGAA1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 20:27:21 -0400
In-Reply-To: <20040629053446.73235.qmail@web90102.mail.scd.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Kernel The <erforschen_linux@yahoo.com>
Cc: linux-scsi@vger.kernel.org

>I want to do RAW I/O to a disk/partition from my ram
>disk driver. How I can achieve this?
>
>alloc_kiovec(..), map_user_kiobuf(...) and
>brw_kiovec(...) functions can be used for this? But
>these function map user space into kernel space
>memory, but in my driver I will be having only kernel
>space memory.

(Incidentally, this isn't a SCSI question -- it's a Linux block device 
question -- the answer below applies to any block device).

Yes, kiovecs are all about mapping user space memory; not useful in your 
case.

But if you follow the brw_kiovec() code, you'll eventually come to the 
basic block I/O submitting interface.  Essentially, 1) fill in the 
relevant fields of a buffer head: b_state, b_page, b_addr, b_size, b_rdev, 
b_rsector, b_endio, b_private.  2) find the block request queue that feeds 
your device, with blk_get_queue(devno).  3) submit the buffer head by 
calling the queue's make_request_fn function 
(blk_get_queue()->make_request_fn).

Some people prefer to call the higher level submit_bh() or 
generic_make_request(), but I find that they assume too much that they're 
being called for buffer cache I/O.  That's not what you're doing.

All of this information is specific to Linux 2.4, which I can tell you're 
using because only 2.4 has kiovecs.  The interface is cleaner in 2.6.


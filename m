From: Douglas Gilbert <dougg@torque.net>
Subject: Re: BUG() in 2.4: sg direct IO + exit()
Date: Sat, 27 Mar 2004 20:38:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406559A5.6080301@torque.net>
References: <04Mar23.100431est.332209@cyborg.cybernetics.com> <406185C6.6050705@torque.net> <20040324130208.GQ3377@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:25873 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262076AbUC1DNJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 22:13:09 -0500
In-Reply-To: <20040324130208.GQ3377@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: tonyb@cybernetics.com, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Mar 24 2004, Douglas Gilbert wrote:
> 
>>Tony Battersby wrote:
>>
>>>The following BUG() is triggered in 2.4.x when a program calls exit()
>>>immediately after sending a SCSI command that uses direct IO:
<snip>
>>>Call Trace:
>>>[<c0127cb0>] unmap_kiobuf+0x30/0x50 [kernel]
>>>[<d0885db6>] sg_unmap_and+0x26/0x50 [sg]
>>>[<d0885cc9>] sg_finish_rem_req+0x39/0x70 [sg]
>>>[<d0885451>] sg_cmd_done_bh+0x281/0x380 [sg]
>>>[<c01ab65a>] scsi_finish_command+0xda/0xe0 [kernel]
>>>[<c01ab380>] scsi_bottom_half_handler+0xc0/0x230 [kernel]
>>>[<c011dacb>] bh_action+0x4b/0x90 [kernel]
<snip>

>>Tony,
>>It is not causing an oops when I try with scsi_debug and lk 2.6.5-rc2.
>>Neither is there a problem with a Suse 9 stock SMP kernel
>>(2.4.21-99-smp4G) on an old dual celeron (A-bit mb) box with a
>>Sony SDT-7000 tape drive on /dev/sg0.
>>
>>I'll keep looking. The oops suggests that the memory is not being
>>locked down (as you are probably aware).
> 
> 
> Looks like an sg bug, you are doing direct io cleanup from interrupt
> context if the fd has been closed (SCSI -> sg_cmd_done_bh ->
> sg_finish_rem_req -> sg_unmap_and -> unmap_kiobuf).

It is my understanding the unmap_kiobuf() can be safely called
from an interrupt context. If that is not the case then the
user task needs to be held in the sg_release() until the
SCSI command finishes or a cleanup kernel thread is needed.
Neither option seems particularly pretty.

kiobufs are gone in lk 2.6 in which both the sg and st
drivers call page_cache_release() in the same context.

Doug Gilbert




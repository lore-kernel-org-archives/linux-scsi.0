From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SCSI TMF processing; tag allocation
Date: Mon, 15 Nov 2010 13:53:28 -0500
Message-ID: <4CE181A8.8050102@interlog.com>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <380694.87733.qm@web31812.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, jens.axboe@oracle.com, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org

On 10-11-06 02:02 AM, Luben Tuikov wrote:
> Here is the following scenario:
>
> Tags 2, 3, ..., X are pending in the device, NOT necessarily submitted in that order (this is the "task set").
>
> Tag 8 times out and is aborted via TMF ABORT TASK. Immediately the device returns okay and the driver says to SCSI core that all is well.
>
> SCSI Core sends TUR immediately, reusing the tag, tag 8.
>
> Then the rest of the commands that were pending in the task set complete with success (2, 3, ..., X, and 8), in the order they were submitted, since tasks 2 to X are I/O commands and 8 being TUR has no implicit HEAD OF QUEUE it completes last with success. Now the device task set is empty. Those commands are completed okay with the Linux device driver with SCSI Core (meaning done() were called, result is 0).

Just checked, the SCSI commands with a "implicit head of
queue" attribute are:
   - INQUIRY
   - REPORT LUNS
   - READ CAPACITY (10+16) [SBC]

On the subject of UAS, due to some USB-3 streaming protocol
requirements, three tag values cannot be used by SCSI. They
are 0h, FFFEh and FFFFh. So those available for SCSI tag
use are 1h to FFFDh inclusive.

Doug Gilbert


> SCSI Core though, continues to abort the rest of the task set, tags 2, ..., X. The device says okay, since they are not in its task set. So SCSI Core's error "handling" routine, sends ABORT TASK for TAG 3. *BUT* since tag 3 is free, immediately after the TMF, we see TUR with, guess what, tag 3, since as far as SCSI/Block layer are concerned, tag 3 is free
> (bitmap in the block layer).
>
> Sure enough, the device receives both, back to back: first the ABORT TASK
> TMF with tag of task to be managed (TTBM) of 3, and then it receives TUR
> with tag of 3. Sure enough the device aborts the TUR.
>
> TUR times out with SCSI Core/block layer and we see SCSI Core tries to
> abort it again, by sending another ABORT TASK TMF with TTBM of 3, that of
> the TUR.
>
> At the same time error handling goes on and sends ABORT TASK TMF for the rest of the commands in the task set and at the end sends LU RESET and I_T Nexus reset (well, the driver that is, but nevertheless).
>
> There are several issues here involving people at various layers (not in any/priority order):
>
> First, SCSI Core should probably send ABORT TASK SET. Sending ABORT TASK for each task at the device is also okay, but adds transport overhead.
>
> Second, SCSI Core should not send ABORT TASK for a completed task. Sure, the device will reply with FUNCTION COMPLETE either way, but in the
> aforementioned case the task server aborts a command which wasn't
> intended to be aborted (and since the tag was reused--see below). That is,
> if the command is in the "eh" queue, and is completed, don't send ABORT
> TASK for it.
>
> Third, and most importantly, tags should form an increasing sequence and should not be reused until all other tags after it and before it have been reused. This for example can be accomplished if one were to use
> find_next_zero_bit() with non-zero "offset", it being the last allocated
> tag in a modulo the number of tags manner. That is, find_next_zero_bit()
> could wrap as well as starting from an offset or the caller could implement
> that via two calls to this function, in blk_queue_start_tag().
>
> Forth, transport protocols need tags for other purposes than just sending
> I/O commands, for example sending task management functions. LLDDs should
> be given callbacks to allocate a free tag, only if #3 above is implemented.
>
> Fifth, all commands that enter queuecommand() should be tagged, regardless
> of whether the device supports tags and how many. At the moment, this
> isn't so, and transports are forced to reserve the first tag the
> transport supports for non-tagged commands and the rest for tagged
> commands. For example INQUIRY coming untagged (tag 0), and then
> READ coming with tag 0 (tagged). This adds additional work for LLDDs to
> check whether the "request" is tagged or not and assign it a tag if
> it is not, or offset the tag if it is tagged with the offset reserved
> for untagged tasks (normally just one).
>
>      Luben
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

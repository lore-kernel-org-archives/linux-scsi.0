From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset ver2 0/5] Refactoring scsi_error to facilitate in synchronous
 REQUEST_SENSE
Date: Mon, 10 Sep 2007 22:13:36 +0300
Message-ID: <46E59760.9020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22058 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821AbXIJTOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 15:14:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

Thank you Christoph, Randy, Alen for your comments.
Here is ver 2 incorporating all your suggestions.

On Mon, Sep 10 2007 at 18:12 +0300, Christoph Hellwig <hch@infradead.org> wrote:
> I think just struct "struct scsi_eh_save *save" is descriptive enough and
> almost fits on a line as well..  Also continuation of the prototype
> is indented by two tabs normally.
> I think you can kill the old prefixes in the struct, they're saved
> per defintion.
Done

On Mon, Sep 10 2007 at 18:58 +0300, Alan Stern <stern@rowland.harvard.edu> wrote:
> A trivial problem is that quilt complains about patch 3, which leaves 
> extra whitespace at the end of line 591 in transport.c.
> 
Thanks

> More seriously, why make the caller define a static generic_sense 
> array?  Why not put the array in scsi_eh_prep_cmnd(), where it can be 
> used whenever copy_sense is nonzero?
> 
I hope you like my solution

> The line initializing the sense buffer to zero should be inside the 
> copy_sense conditional block.
> 
Thanks 

> The code setting the LUN bits in scmd[1] is wrong.  It should be like 
> the code in scsi_dispatch_cmd(); i.e., those bits should not be set if 
> the scsi_level is SCSI_UNKNOWN.
> 
Thanks, good catch

> Finally, a really serious problem.  The code sets the buffer length for
> the REQUEST SENSE command to be the length of scmd->sense_buffer, which
> is 96.  But many USB devices won't work properly unless the requesed
> sense data length is 18.  The appropriate adjustment must be added to 
> transport.c in patch 3.
> 
I was afraid of that at the beginning. But testing both with a Seagate
USB sata hard-disk and Sandisk 2Gb usb-stick. They both returned a short
read of 56 but other wise were happy. So I thought it is leftovers from
The time the sense buffer was driver allocated. Also the standard 
recommends a short-read behavior. But I have taken your advise to hart
and changed the code accordingly. Please check me out.

----------------------------------------------------------------  

In motivation to abstract scsi_cmnd members and insulate
drivers/transports from scsi_cmnd internals. The last
place left was the REQUEST_SENSE sequence when done
synchronous, by drivers.

Also all these drivers would do a use_sg==0 command
invocation, preventing from doing cleanups on these
drivers/transports. So this patchset is left-overs
from Christoph's 2.6.18 cleanups.

In this patchset I have re-factored scsi_error to
make it possible for drivers to use an abstract
(easy to use, I hope) API for invoking a REQUEST_SENSE
command. The API is declared in scsi/scsi_eh.h

[patch 1/5] scsi_error: code cleanup before refactoring of scsi_send_eh_cmnd()
  Move some code around and add new fixtures here. So next patch is
  left a Mechanical breakup of code.

[patch 2/5] scsi_error: Refactoring scsi_error to facilitate in synchronous REQUEST_SENSE
  Here new API is introduced in scsi/scsi_eh.h and mechanical move of code
  to the new functions.

[PATCH 3/5] usb: transport.c use scsi_eh API in REQUEST_SENSE execution
  Use above API for drivers/usb/storage/transport.c. Now that last
  User of use_sg==0, we can do the USB storage cleanups.

[PATCH 4/5] NCR5380: Use scsi_eh API for REQUEST_SENSE invocation
  All NCR5380 family of drivers used to send a REQUEST_SENSE
  command.

[PATCH 5/5] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
	drivers/scsi/arm/fas216.c need change also.

Please Test as much as possible, and report any problems/differences.

Boaz Harrosh
 



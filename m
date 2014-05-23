From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Fri, 23 May 2014 01:28:01 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F3F758@G9W0745.americas.hpqcorp.net>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org>
 <537A2CB8.9060302@redhat.com> <537A34C6.7090905@acm.org>
 <loom.20140521T161608-391@post.gmane.org> <537D0DC9.5010900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:51451 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaEWBaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 21:30:07 -0400
In-Reply-To: <537D0DC9.5010900@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Mark Wu <wudx05@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Paolo Bonzini
> Sent: Wednesday, 21 May, 2014 3:34 PM
> To: Mark Wu; linux-scsi@vger.kernel.org
> Subject: Re: dangling pointers and/or reentrancy in
> scmd_eh_abort_handler?
> 
> Il 21/05/2014 16:16, Mark Wu ha scritto:
> > Is it possible that when scsi_done is invoked, the scsi command or the
> > request has been freed and then reallocated for a new I/O request?
> Because
> > of this the bit flag REQ_ATOM_COMPLETE becomes unreliable.  Thanks!
> 
> It is up to the driver to ensure that the interrupt handler will not
> process the Scsi_Cmnd* after returning from the eh_abort_handler.  If
> you do this, what you say cannot happen.  Otherwise you'll get a variety
> of failures, the most common of which for me are OOPSes and a BUG in
> blk_finish_request.
> 
> Paolo

Aborts don't always work; scsi_eh_abort_handler cannot promise that 
it aborted the command (unless it escalated to sending resets.)
When the abort fails, scmd_eh_abort_handler just leaves it
outstanding, and the error handler thread (scsi_error_handler
function) must deal with it.

If the abort succeeds, then scmd_eh_abort_handler calls
scsi_finish_command.

In SCSI terms, FUNCTION COMPLETE for ABORT TASK doesn't mean the 
command was present and aborted and won't be sending back status; 
if the device server already sent status for the command, the 
task manager also sends FUNCTION COMPLETE.

Depending on the transport, there may be a race condition between 
the command status and the ABORT TASK response; the ABORT TASK 
response might get back first.  I think that means 
scsi_eh_abort_handler's call to scsi_finish_command could
happen during or after scsi_softirq_done has called
scsi_finish_command.

---
Rob Elliott    HP Server Storage







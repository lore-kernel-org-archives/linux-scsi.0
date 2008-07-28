From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11117] New: aic94xx doesn't sustain the load when more
	than 2 SAS drives are connected and actively used
Date: Mon, 28 Jul 2008 09:44:29 -0500
Message-ID: <1217256269.3503.73.camel@localhost.localdomain>
References: <bug-11117-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45315 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbYG1Oo6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 10:44:58 -0400
In-Reply-To: <bug-11117-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-07-18 at 08:37 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11117
> 
>            Summary: aic94xx doesn't sustain the load when more than 2 SAS
>                     drives are connected and actively used
[...]
> aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
> sas: command 0xffff8101d39733c0, task 0xffff8105e9e51240, timed out:
> EH_NOT_HANDLED
> sas: command 0xffff8104db3d1e40, task 0xffff8105ed10a6c0, timed out:

This is more or less a known problem with aic94xx.  It's root cause is
that there are certain bus conditions the firmware requires help with.
REQ_TASK_ABORT is one of them (reason 0x6 means there was a protocol
error on the bus).  What the card would like is for us to abort and
retransmit that command immediately (running abort).  What we actually
do is to mark the command for abort by the error handler, halt all
in-progress commands and wake up the eh thread.  This causes a nasty
hiccough in the data flow and runs into a potential snowball effect in
that if we get another REQ_TASK_ABORT on the retry of all the halted
commands (and there are quite a number of them), we have to do
everything over again (do this too often and the command will time out).

The fix is to alter the aic94xx code to do a running abort (as in do it
itself on the single command instead of halting everything and waking
the error handler).  Unfortunately no-one's found the time to sit down
and code this up yet.

James



From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 13594] SMART responses for SATA disks on SAS get interpreted
 as errors
Date: Sun, 21 Jun 2009 16:53:29 -0400
Message-ID: <4A3E9DC9.3000007@interlog.com>
References: <bug-13594-11613@http.bugzilla.kernel.org/> <200906211907.n5LJ7D51030300@demeter.kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firefly.infotech.no ([82.134.31.146]:50381 "EHLO
	elrond.bb.infotech.no" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751694AbZFUUxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 16:53:35 -0400
In-Reply-To: <200906211907.n5LJ7D51030300@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13594
> 
> 
> 
> 
> 
> --- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-06-21 19:07:13 ---
> Reply-To: James.Bottomley@HansenPartnership.com
> 
> On Sun, 2009-06-21 at 18:58 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=13594
>>
>>
>>
>>
>>
>> --- Comment #3 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2009-06-21 18:58:28 ---
>> (In reply to comment #1)
>>> This is a message the kernel prints out on all recovered error returns
>>> (except those marked REQ_QUIET).  It's purely informational and doesn't
>>> affect return processing of the command at all, so the kernel is
>>> actually treating this as a successful completion not an error.
>> OK.
>>
>>> So this sounds like the bug ... however, for the LSI card, this bug will
>>> be in the SAT layer in the fusion firmware.  I can shut the kernel up by
>>> making the recovered error processing clause look for 01/00/1D as well
>>> as REQ_QUIET, but it won't affect this problem.
>> I tried reporting this to the Linux fusionmpt driver people a while ago, but
>> never received any response (thus this bug)... I guess I'm out of luck,
> 
> OK, cc'd LSI people, let's see if I get better luck
> 
>>  then,
>> if there's nothing that can be done for it in the kernel. It's a bit weird,
>> though; one would believe people ran smartd on their systems and discovered
>> this already.
> 
> I can guess that it's some type of firmware mode problem: either it runs
> for SMART or it runs for normal commands, hence the hiatus.  If that's
> true, you'd likely only see the problem in a large disk setup ... it
> might also be possible to work around by simply quiescing the card
> before sending down SMART commands (that would be grossly inefficient,
> but at least devices wouldn't get errored).

I have just replicated the "ATA pass through information
available" message report on a similar vintage LSI
controller and a SATA disk with a recent smartctl
version.

There is no need to report this in the kernel error log,
as the smartmontools ATA pass-through (SCSI) command asked
for the final state of the ATA registers and the sense
buffer is the conduit for that information. That ASC/ASCQ
pair basically means "you asked for them and here they
are". [reference: sat2r07b.pdf section 12.2.5 table 107
when CK_COND is 1]

As for the hiccup, I have noticed that with SAS (SCSI)
disks from Seagate there is a curious sound and a pause
before the response to LOG SENSE SCSI command (the
type the smartmontools uses on SCSI disks).

Another annoyance is that the disk must be ready (i.e.
spun up) before MODE SENSE and LOG SENSE work, haven't
Seagate heard of flash :-)
SCSI standards permit that (i.e. only
a small number of commands have to work when the disk
is not ready) but you would think accessing metadata
given the disk has spun up once since power up could
be accomplished from RAM or flash.

Doug Gilbert

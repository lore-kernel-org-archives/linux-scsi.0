From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: aacraid patch & driver version question
Date: Mon, 27 Sep 2004 22:39:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4158969E.30368.39E09981@localhost>
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.advantagecom.net ([65.103.151.155]:23496 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S267542AbUI1Fiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 01:38:54 -0400
Received: from SCSI-MONSTER (scsi-monster.advantagecom.net [207.109.186.200])
	by mail.advantagecom.net (8.11.6/8.11.6) with ESMTP id i8S5crf27683
	for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2004 22:38:53 -0700
Content-description: Mail message body
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm new to this list, so if I'm asking in the wrong place or this is 
answered in a FAQ somewhere, please kindly steer me in the right 
direction.

I'm actively working through the infamous "aacraid: Host adapter 
reset request. SCSI hang?" issue with two of our systems that have 
the PERC3/DI controller (2.8.0[6092] firmware and 1.1-4[2323] driver) 
and I found a post on the aacraid-devel list.  Since that list has 
been merged to this list, I have to ask the question here.

The symptoms of our issue stem from a single drive in our RAID 5 
array not responding to a device reset command issued by the 
controller after about 30 or so timed-out read/write scsi commands. 
The drive activity light for that drive stays on solid throughout the 
process, even long after all activity should have been completed.  
Apparently, the whole time the controller is waiting for the drive to 
respond and trying to reset the drive, the command queue of the 
controller fills up and the OS is unable to get any response out of 
the controller during this period.  This is compounded by the time it 
takes the controller to check for a hot spare (which we don't have) 
When the OS can't get a response out of the controller after a 
reasonable time (30 or 60 seconds - don't remember off hand - but our 
controller took more than 78 seconds to finish marking the drive dead 
according to the controller logs), it marks the controller dead and 
this makes the entire array unusable, thus causing a crash since this 
is our only controller and only container.  It could be a bad drive, 
but I don't think it is because we have a second identically 
configured system that has trouble with the exact same drive ID in 
its array and shows the same exact problem.  In both systems, the 
drive tests good after a reboot (hard reboot since the OS is 
unresponsive).

Regardless of what the root trigger of the problem is (bad disk, bad 
backplane, bad power supply, whatever - we're working with Dell on 
that aspect), taking a RAID 5 container offline due to one disk 
failing (and the 78 seconds it took the controller to determine that) 
is a horribly ungraceful and counterintuitive thing to do, especially 
for a system with only one controller and one container.  I used RAID 
5 so that a single drive failure doesn't crash the system.  That's 
what "degraded" mode and online rebuild is for. ;-)

At any rate, the email message below seems to describe our situation 
and suggests that changes to the driver were going to be made to fix 
the issue.  Were the changes mentioned below ever implemented in the 
aacraid driver?  If so, what is the earliest aacraid driver version 
that contains these changes?

Please reply to the list since I have that whitelisted in my server 
side spam filtering. Messages to me directly may or may not make it 
through the spam filters, though they usually do.

Thanks in advance.

Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net

On Wed, 27 Aug 2003, on aacraid-devel@dell.com Salyzyn, Mark wrote:

> I may have a root cause on this issue, even though I have not been able to
> duplicate it yet.
>
> There is code that does the following in the driver:
>
> 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> SAM_STAT_TASK_SET_FULL;
> 	aac_io_done(scsicmd);
> 	return -1;
>
> This is *wrong*, because the none zero return causes the system to hold the
> command in the queue due to the use of the new error handler, yet we have
> also completed the command as `BUSY' *and* as a result of the constraints of
> the aac_io_done call which relocks (on io_request_lock) the caller had to
> unlock leaving a hole that SMP machines fill. By dropping the result and
> done calls in these situations, and holding the locks in the caller of such
> routines, I believe we will close this hole.
>
> Thanks, in part, to Josef M?rs for pointing out this locking problem
> under SMP, serendipitously a day after I had noticed the other problem with
> the inaccurate busy return sequences in the code and started making the
> changes to investigate. Kill two birds with one stone.
>
> I will report back on my tests of these changes, but will need a volunteer
> with kernel compile experience to report on the success in resolving this
> issue in the field *please*.





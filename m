From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid patch & driver version question
Date: Tue, 28 Sep 2004 08:32:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B1AB0B4@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:31418 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267536AbUI1Mcz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 08:32:55 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: andykinney@advantagecom.net, linux-scsi@vger.kernel.org

In the later drivers (1.1-4[2323] included) I added an
AAC_EXTENDED_TIMEOUT definition (commented out in the aacraid.h file and
the accompanying code automagically ifdefs itself out as a result).
AAC_EXTENDED_TIMEOUT only affects I/O commands.

The problem is that any system reticence beyond 120 seconds causes
network connections to drop, and we are already taking the 60 seconds
timeout from the SCSI subsystem and then waiting an additional 60
seconds holdoff from recovery action in the reset hba handler waiting
for the adapter to come back. All in an effort to harden the driver over
this issue.

If you feel your system can take a longer time to wait for the adapter
with no undue secondary problems, I would recommend uncommenting the
AAC_EXTENDED_TIMEOUT line. I must warn you, though, that those that have
extended the timeout have not experienced the success we all would have
hoped in part because this problem has many layers as *any* cause of a
lockup in Drive, Cable, Protocol, H/W or F/W manifests itself this way.
As long as your problem is *just* an errant drive you probably will be
OK with this alteration.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Andrew Kinney
Sent: Tuesday, September 28, 2004 1:39 AM
To: linux-scsi@vger.kernel.org
Subject: aacraid patch & driver version question

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

> I may have a root cause on this issue, even though I have not been
able to
> duplicate it yet.
>
> There is code that does the following in the driver:
>
> 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> SAM_STAT_TASK_SET_FULL;
> 	aac_io_done(scsicmd);
> 	return -1;
>
> This is *wrong*, because the none zero return causes the system to
hold the
> command in the queue due to the use of the new error handler, yet we
have
> also completed the command as `BUSY' *and* as a result of the
constraints of
> the aac_io_done call which relocks (on io_request_lock) the caller had
to
> unlock leaving a hole that SMP machines fill. By dropping the result
and
> done calls in these situations, and holding the locks in the caller of
such
> routines, I believe we will close this hole.
>
> Thanks, in part, to Josef M?rs for pointing out this locking problem
> under SMP, serendipitously a day after I had noticed the other problem
with
> the inaccurate busy return sequences in the code and started making
the
> changes to investigate. Kill two birds with one stone.
>
> I will report back on my tests of these changes, but will need a
volunteer
> with kernel compile experience to report on the success in resolving
this
> issue in the field *please*.




-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

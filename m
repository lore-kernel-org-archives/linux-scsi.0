From: John Mason <john@mmspos.com>
Subject: Megaraid bug or hardware failure?  Please help!
Date: Wed, 25 Aug 2004 08:37:26 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6.1.0.6.1.20040825083549.044ade80@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [142.176.166.155] ([142.176.166.155]:35504 "EHLO mmspos.com")
	by vger.kernel.org with ESMTP id S266896AbUHYLlX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 07:41:23 -0400
Received: from john.mmspos.com (comp172.MMSLAN.mms [192.168.1.172])
	by mmspos.com (8.11.6/8.11.6) with ESMTP id i7PBfMI16835
	for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2004 08:41:22 -0300
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi all,

   Just joined the list and I'm hoping someone can shed some light on a 
problem I've been having.
This might be more of an issue for Dell hardware support, but I hoped 
someone here might recognize these symptoms.

We have a Dell Poweredge 2600 with the Perc 4di controller, dual 2.8 gig 
Xeons, and 1 GB of RAM.
It's running (unpatched) Redhat 8.0, with megaraid 1.18d.  On the Perc4 we 
have two drives in a raid1 configuration on channel A, and six drives 
including a hotspare on channel B.  There is a logical drive defined on 
each channel.

Originally the box locked up on us about a year ago.  All 8 hard drives 
seemed to be under heavy load, and there was no response at the console 
aside from being able to switch to different virtual terminals with alt-f2, 
etc.  We rebooted the box, and it recovered, but /var/log/messages was full 
of scsi timeout errors for one particular drive.

We were able to get Dell to replace the machine for us, and it ran 
perfectly for months, until a few weeks ago.  At this point, the box locked 
again, but it appeared to have suffered a drive failure and started a 
rebuild onto the hotspare.  From what we could get from the messages and 
megaraid log files, it was in the middle of a rebuild when it locked.
After rebooting, it seemed to complete the rebuild. I installed the 
Openmanage Server Assistant (which cleared the ESM logs, conveniently) and 
also ran Dellmgr to check the status of the 2nd container, where the 
failure had apparently occurred.  I was surprised to find that the drive 
that had supposedly caused the problems was showing as online.  We assigned 
it to be a hotspare, and hoped it was just a momentary glitch that had 
caused the issue.  I've been told a few times by Dell support that this 
sometimes happens without there being any real hardware fault.

About a week later, the box locked again.  No one was around for the 
initial failure, but it looks like it stopped responding around
midnight.  We first got word around noon the next day.  This time there was 
no drive activity, no indication of any hardware failure,
but a kernel panic on the screen, followed by a message appearing on the 
screen every second -- something along the lines of "Mailbox 
unavailable".  A check in the raid BIOS showed no problems at all.

On rebooting the box, fsck tried to repair errors on the 2nd 
container.  The fsck took hours and found thousands of errors, and finally 
wanted to reboot.  After rebooting, the same series of errors were 
reported, and again two more times after this.  I finally decided to
put a Knoppix CD into the box and see what was left of the drives.  When it 
finished booting, I could see ALL of my partitions, and all of the data 
appeared intact.  At this point I used NFS to get all the data I needed 
while I had the chance.
After I got the data I needed, I ran fsck from within Knoppix.  It found 2 
or 3 errors, fixed them, and when I rebooted, Red Hat booted up again with 
no errors at all!

So... after all that, does anyone have any thoughts on what the problem 
might be?  It seems like we might have a flaky backplane and/or raid 
controller.  I suspect the megaraid driver and/or fsck might be buggy after 
Knoppix was able to so easily fix the problems with the file system.  Also 
was looking through the megaraid.c source today looking at the revision 
history, and noticed that it uses the term "mailbox" a lot...  which would 
suggest the error I was seeing at the console was coming from megaraid (it 
didn't actually say "megaraid" at the beginning of the message).

Would that message from the megaraid driver necessarily indicate any 
particular type of failure?  I'd gladly just update to the newest megaraid, 
but what makes me suspicious is the fact that we have 4 or 5 other machines 
with similar setups and the same OS, one of which is more heavily loaded 
than this one, and none of them have ever had any raid issues like this.

Anyway,  any ideas or suggestions would be greatly appreciated, at this 
point I'm pretty much just grasping at straws.

Thanks in advance!


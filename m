From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid	PERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 17:00:39 -0800
Message-ID: <41A36CB7.16204.D3BCF639@localhost>
References: <20041028005302.753a2d52.akpm@osdl.org>
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.advantagecom.net ([65.103.151.155]:51082 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S261406AbUKXBAZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 20:00:25 -0500
In-reply-to: <1101246101.26294.76.camel@ryan2.internal.autoweb.net>
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>
Cc: linux-scsi@vger.kernel.org

I'll just add my two cents having gone through the exact same thing 
with a pair of PowerEdge 2500 systems with PERC 3/Di RAID 
controllers.  They both had the problem.

Our problem was also only able to be replicated with the machine in 
production with heavy RAM usage, moderate CPU usage, and many 
simultaneous small I/Os mixed with large file writes.  PostGres dumps 
seemed to be the most likely cause since it crashed on schedule for 
awhile and a cron job was running a PostGres dump at that time.  That 
wasn't able to cause the crash 100% of the time though.  It only 
caused it about 10% of the time, from what I could tell.  I was 
unable to reproduce the problem when it was out of production.  It 
took some hocus pocus mix of system activity that only the collective 
consciousness of our customers could seem to cause.  I spent weeks 
using various stress testing programs of all sorts to try to 
reproduce the issue, but I just couldn't replicate it.

First, what enabled us to locate the problem was the following 
command run in the boot immediately following a crash.  It needs to 
be run from afacli after opening the controller.

diagnostic show history /old

That will display the series of events leading up to the container 
going offline.  Pay particular attention to the beginning of the 
problem.  It would look similar to this:

[13]: ID(0:01:0) Timeout detected on cmd[0x28]
[14]: ID(0:01:0): Timeout detected on cmd[0x2a]
[15]: ID(0:01:0): Timeout detected on cmd[0x28]
[16]:  <...repeats 2 more times>
<snip>
[50]: ID(0:01:0) Cmd[0x28] Fail: Block Range 3424717 : 3424718 at
[51]:  509184 sec
<snip>
[78]: ID(0:01:0) Cmd[0x28] Fail: Block Range 0 : 0 at 509262 sec
[79]: 2 can't read mbr dev_t:1
[80]:  <...repeats 1 more times>
[81]: can't read config from slice #[1]

Note the timestamp on line 51 (continued from line 50).  Yours will 
have a different time stamp and a different line number, but you'll 
want to make note of the earliest time stamp visible during or just 
before the problem. Our was almost 6 days from boot.

Then note the latest time stamp near the end of the problem (line 78 
in our log).  In our case it was 78 elapsed seconds.  I'm pretty sure 
 it was coincidence that it was line 78 and 78 seconds elapsed.  This 
is, of course, longer than it should take for the firmware to offline 
a dead drive, but that's what happened.  This resulted in the linux 
SCSI layer timing out and hosing everything since we ran everything 
(including swap, boot, and root) from this container.

Our solution was UGLY.  We replaced everything in the entire disk 
subsystem in addition to getting the latest BIOS, firmware, and 
drivers.  Fortunately, both systems were under warranty, so Dell 
provided the parts and labor to replace the errant hard drive (ID 0:1 
in our case), the backplane, the cables, and the mainboard (since the 
controller is embedded).  The good news is that we've been up 47 days 
since implimenting this solution.  Previous uptimes were typically 
less than a week.

I've had many theories about what the root cause was (some better 
than others), but my latest iteration is that when the system was 
under normal load, a power component on the SCSI backplane couldn't 
supply the proper voltage to one drive for a short period. The drive 
became unresponsive upon executing a command that used the servo 
motor enough to cause the power fluctuation to affect the drive's 
command processor, causing the drive to lockup.

The problem was compounded by the firmware not marking the drive as 
bad in a reasonable time frame so it could continue processing 
commands in degraded mode before the upper layer wigged out.  The 
upper layer linux SCSI drivers can't do anything about this, 
unfortunately, and just blindly take down your only available disk 
storage before the controller comes back from marking the disk as 
bad.

Maybe our experience will benefit someone when they go to modify the 
controller firmware to properly mark a drive as bad in a reasonable 
time so the container can continue to operate in degraded mode rather 
than being taken offline entirely by the OS.  Hint. Hint.

Andrew

On 23 Nov 2004 at 16:41, Ryan Anderson wrote:

> On Thu, 2004-10-28 at 00:53 -0700, Andrew Morton wrote:
> > Subject: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid
> > PERC 3/Di Container goes offline
> > 
> > 
> > http://bugme.osdl.org/show_bug.cgi?id=3651
> > 
> >            Summary: dell poweredge 4600 aacraid PERC 3/Di Container
> >            goes
> >                     offline
> >     Kernel Version: 2.6.10-rc1, 2.6.9, 2.6.8, 2.6.7, 2.6.6
> >             Status: NEW
> >           Severity: high
> >              Owner: andmike@us.ibm.com
> >          Submitter: oliver.polterauer@ewave.at
> >                 CC: oliver.polterauer@ewave.at
> 
> Is there any update on this problem?
> To reiterate my particular hardware involved that can trigger this
> problem:
> 
> Dell 2650, Dual 2.4Ghz Xeon processors (hyperthreading no, though the
> problem occured in 2.4.20 without hyperthreading disabled via "noht")
> 
> 4 GB of ram
> Only load is PostgreSQL related (i.e, network queries, plus twice
> daily dumps of the database to a NFS store, and a rsync back to the
> server for a second copy)
> 
> Under load, I repeatedly saw containers go offline.
> 
> Dell's recommended hardware diagnostics do not turn up anything (at
> all!)
> 
> The harddrive are Fujitsu drives, so the Seagate Firmware issue should
> not affect them.
> 
> I have since taken this server out of production.  Unfortunately, this
> makes the error much harder to trigger (i.e, I have failed so far to
> trigger it, even with multiple bonnie++ runs)
> 
> Suggestions, diagnostics, etc, would be greatly appreciated.
> 
> 
> -- 
> 
> Ryan Anderson                
> AutoWeb Communications, Inc. 
> email: ryan@autoweb.net 
> 


Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net




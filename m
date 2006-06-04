From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: SCSI device not spinning up on rw
Date: Sun, 04 Jun 2006 00:12:15 -0400
Message-ID: <44825D9F.9070305@torque.net>
References: <20060603182302.7136831f.akpm@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:26511 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932074AbWFDEMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jun 2006 00:12:18 -0400
In-Reply-To: <20060603182302.7136831f.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Ruben Faelens <parasietje@gmail.com>

Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Sat, 03 Jun 2006 21:47:48 +0200
> From: Ruben Faelens <parasietje@gmail.com>
> To: LKML <linux-kernel@vger.kernel.org>
> Subject: SCSI device not spinning up on rw
> 
> 
> I have a SCSI disk, which I want to spin down when the system is not in
> use. I do this by using sdparm, scsi-spin or sg-utils. These tools all
> spin down the SCSI drive by using an IOCTL.
> 
> Problem is that the kernel doesn't spin the drive back up. When a
> process requests data from the disk (a simple ls), the kernel responds
> with an I/O error. After some of these errors, reiserfs marks the drive
> read-only.
> 
> This bug is also described here:
> http://bugzilla.kernel.org/show_bug.cgi?id=6627
> 
> This bug was solved by scsi-idle (http://lost-habit.com/scsi.html) in
> 2.4 kernels, but the patch hasn't been ported to 2.6. It's also a dirty
> hack, by someone who knows little of the internals of the SCSI system.
> 
> I read the LKML-archives, and they turned up some old posts in 09-2005
> about this subject, where somebody says implementing this in SCSI could
> get messy.
> 
> However, it seems to me that all it takes is a call to sd_spinup_disk()
> in sd.c. When I add this in sd_init_command, the kernel crashes when
> confronted with a SCSI disk. Then again, I'm no kernel hacker, this is
> the first time I even read the source...
> 
> Could someone more experienced than me look into this? IMHO this should
> be doable, because the spinup-on-read/write has been implemented in SATA
> and IDE I/O subsystems. Then again, I read SATA and IDE disks handle
> this for themselves.
> 
> So if someone would enlighten me, that would be great!
> 
> As a side note: maybe it's my disk that's having these problems? It's an
> old SCSI disk in a HP 712/80 from 1994. Manual spinup does work however...

Ruben,
IMO the sd driver should spin up drives if need be.
Perhaps the sd driver could have a parameter to
control this. Note that spinning up can take up to
30 seconds so some timeouts might go off upstream.

However this has been happening silently for a long
time in the ATA disk world. A timeout (e.g. using
'hdparm -S <n>') spins down the disk and the next
data transfer command to that disk spins it back
up again with an attendant delay for read commands.

The SCSI power management model uses the START STOP UNIT
SCSI command. Apart from the fact that the sd driver
actually has to do something when a "not ready,
initializing command required" error occurs, the
same thing would be happening as far as the higher layers
are concerned (i.e. reads are delayed).

To see how silly the current situation is consider a SATA
disk behind a SAT layer **. If I use the "front door" and
stop the disk with a START STOP UNIT SCSI command then
SAT will put the SATA disk into standby mode. Active intervention
is needed by the sd driver to spin it up but sd doesn't play.
Now if I use the "back door" and send a STANDBY ATA command
via the ATA PASS THROUGH SCSI command then the SATA disk
goes into standby mode (spins down). However the first
data transfer command will spin up the disk without the
sd driver doing anything.

I have a page summarizing power management in SCSI and
ATA: http://sg.torque.net/sg/power.html


** I'm using the sat-r08.pdf draft as a reference here,
   not what libata's SATL does today.

Doug Gilbert

From: nancy lin <nlin@newton.berkeley.edu>
Subject: perc 3/di problem or just disk failure?
Date: Fri, 27 Aug 2004 18:57:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408271831140.4030-100000@feldspar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.DECF.Berkeley.EDU ([169.229.204.214]:44501 "EHLO
	relay2.decf.berkeley.edu") by vger.kernel.org with ESMTP
	id S266117AbUH1B5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 21:57:07 -0400
Received: from relay2.decf.berkeley.edu (localhost.localdomain [127.0.0.1])
	by relay2.decf.berkeley.edu (8.12.8/8.12.8) with ESMTP id i7S1v62V016289
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2004 18:57:06 -0700
Received: from feldspar.decf.berkeley.edu (feldspar.DECF.Berkeley.EDU [169.229.204.146])
	by relay2.decf.berkeley.edu (8.12.8/8.12.8) with ESMTP id i7S1v69F016284
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2004 18:57:06 -0700
Received: from localhost (nlin@localhost)
	by feldspar.decf.berkeley.edu (8.12.8/8.12.8/Submit) with ESMTP id i7S1v6nV004127
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2004 18:57:06 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

Earlier this week, I had 3 disks out of 7 on my Dell Raid Array fail on
me.  The error messages are I got are included at the end of the email.  
It started with Parity errors, then I got the "SCSI hang ?" errors, then
just lots of I/O errors.  I've been looking through the archives on both
this mailing list and the old linux-aacraid-devel mailing list.  Noone
seems to have had the exact error message as me (The parity error).  From
what I've read, there are some problems w/ read/write cache, and too
much/fast disk I/O.  The solutions mentioned were to upgrade 
firmware/driver.  

Before I do so on a production system, I wanted to make sure that this is
the problem.  I'm wondering if this is just 3 disks that failed, or a
problem w/ the driver.  I'm not quite sure as lots of things happened to
the system over the last few days all at the same time:

First, I accidently deleted my containers while trying to add 7 new 73GB
disks to my existing 7 33GB disk array.  (They're now in two seperate
containers).  I finally got all 14 disks back online and had to restore
from backup and was in the process of reinstalling some programs.  One of
these program (really a script) has a bug and will go into an infinite
loop spawning and running processes.  But the server didn't crash while I
was running this.  I did kill the processes once I discover the problem.  
I'm a big hazy on the time, but this was in the afternoon on Tuesday.

Wed morning, the AC unit in my server room was shut off and the
temperature reached 80 degrees.  The 3 disks died and the errors included
at the end of this message showed up.  Could this have done it??  I move
all the data from container 1 (which had the 3 disk failure) to container
2.  I ran the scsi disk utility to see if there are bad blocks on 1 disk ,
but it says it's 100% okay. Though the amber light stays on.  So I leave
the bad disks in the storage unit to figure out later.  It's just not
active.  EVerything's back up Wed night.

Thursday night, I again am recompiling the program via another computer
(so through NFS).  Didn't kill the run away processes at all and it
crashed the remote server as well as the disk array server.  I come into
the server room and there are lots of bad I/O messages scrolling by.  But
there are no messages in the syslogs and the lights on all the disks are
green.  I reboot the machine, removing all 7 disks in the bad container,
and things are okay for now.  Could the crash have been because, for some
reason, the machine trying to access the bad container or was it because
of the bad compile?

So, lots of possible reasons.  But not sure whether or not it's 

1.  the heat that killed the disks.  Or

2.  that it's a bad driver that made the server think the disks are dead
now that there's actually high IO load, and the high temp thing didn't
cause any damage.  

Any insight is greatly appreciated!

thanks
nancy

------------------------
Aug 25 11:35:31 file kernel: aacraid:ID(1:03:0); 
Parity Error 
[command:0x28]
Aug 25 11:35:31 file kernel: aacraid:ID(1:04:0); Parity Error 
[command:0x28]
Aug 25 11:35:31 file kernel: aacraid:ID(1:03:0) - IO failed, Cmd[0x28]
Aug 25 11:35:31 file kernel: aacraid:ID(1:00:0); Parity Error 
[command:0x28]
Aug 25 11:35:31 file kernel: aacraid:ID(1:04:0) - IO failed, Cmd[0x28]
Aug 25 11:35:31 file kernel: aacraid:Container 1 Returned Error to Adapter 
Cache
Aug 25 11:35:31 file kernel: aacraid:ID(1:01:0); Parity Error 
[command:0x28]
Aug 25 11:35:31 file kernel: aacraid:ID(1:02:0); Parity Error 
[command:0x28]

Aug 25 11:36:19 file kernel: aacraid:Drive 1:0:0 returning error
Aug 25 11:36:56 file kernel: aacraid:Drive 1:1:0 returning error
Aug 25 11:37:33 file kernel: aacraid:Drive 1:3:0 returning error
Aug 25 11:39:12 file kernel: sk error : host 2 channel 0 id 1 lun 0 return 
code = 1
Aug 25 11:39:13 file kernel: ode_write: IO failure
Aug 25 11:44:56 file kernel: <s = 5
Aug 25 11:46:31 file kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Aug 25 11:46:41 file kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Aug 25 11:46:51 file kernel: scsi: device set offline - command error 
recover failed: host 2 channel 0
id 1 lun 0
Aug 25 11:47:07 file kernel:  I/O error: node block - inode=561957, 
block=1114270
Aug 25 11:47:07 file kernel:  I/O error: node block - inode=562175, 
block=1114276


-- 

---------------------------
Nancy Lin
DECF
1109-A Etcheverry Hall
Office Hours: 10AM-12PM M-F
(510) 642-7291
---------------------------




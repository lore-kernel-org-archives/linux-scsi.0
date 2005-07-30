From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Sat, 30 Jul 2005 23:52:34 +0200
Message-ID: <42EBF6A2.7040305@s5r6.in-berlin.de>
References: <42E29DF5.5090603@s5r6.in-berlin.de> <42E2A15A.2030609@s5r6.in-berlin.de> <20050726042640.GA17885@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46021 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261516AbVG3Vwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 17:52:55 -0400
In-Reply-To: <20050726042640.GA17885@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Ben Collins wrote on 2005-07-26:
> Sounds like it is probably hanging in sbp2 while it is trying to logout.

I don't think so. According to dmesg with SBP2_DEBUGs enabled,
scsi_remove_device() is entered but sbp2_logout_device() not.
IOW scsi_remove_device() is not completed. (I'm using sbp2 rev
1316 which calls scsi_remove_device() before logout. Also, I'm
on 2.6.13-rc4 now.)

> Perhaps you can turn on spinlock debug to see if there is a deadlock
> somewhere? Check wstat for the knodemgrd process aswell, see what it is
> waiting for.

I did not enable spinlock debugging yet.
Here is more process info for now:
# ps lx
F   UID   PID  PPID PRI  NI   VSZ  RSS WCHAN  STAT TTY        TIME COMMAND
1     0  1539     1  15   0     0    0 scsi_w D    ?          0:00 [knodemgrd_1]
# cat /proc/1539/wchan
scsi_wait_req

Patrick Mansfield wrote on 2005-07-27:
> Seeing sysrq-t stack traces might help debugging.

The knodemgrd is not traced by sysrq-t, and no userspace task is
hanging.

Thanks for the hints so far, I will hopefully be back with better
debug info later.
-- 
Stefan Richter
-=====-=-=-= -=== ====-
http://arcgraph.de/sr/

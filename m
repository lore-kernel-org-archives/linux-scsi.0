From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Fibre-Channel Access : interuptive access
Date: Tue, 26 Nov 2002 11:04:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE34745.D6AAC6EF@cri74.org>
References: <3DE261E5.3F61EBC4@cri74.org> <3DE27BE3.2090402@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc00.cri.cur-archamps.fr (pc00.cri.cur-archamps.fr [10.10.10.11])
	by aravis.cur-archamps.fr (8.9.3/8.9.3) with ESMTP id LAA30305
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 11:04:54 +0100
Received: from cri74.org (localhost [127.0.0.1])
	by pc00.cri.cur-archamps.fr (8.9.3/8.9.3) with ESMTP id LAA31464
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 11:04:53 +0100
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

Steven Dake wrote:
> 
> Fabien,
> 
> What you want is hotswap support.  The kernel has basic support for
> hotswap but only if a device is not in use.  Search the archives for
> hotswap.
> 
> I'm currently working on forced block device removal, even if the device
> is in use, properly shutting down files in VFS, RAID, and filesystem
> mount layers.  This is what you really need when hotswap happens, but it
> just isn't ready yet.
> 
> The correct way to configure your system so it will be alive during this
> type of failure is to have two HBAs, two switches, and have each hba go
> through a seperate switch.  This way, if your link/HBA/switch fails,
> there is automatic failover.
> 
> Then create a RAID 1 array across both HBAs.  In the case of a switch
> failure, the RAID subsystem will automatically correct any errors and
> rebuild arrays on disk reinsertions.  Or you could use the RAID
> multipathing personality to create a multipath across two hbas to the
> same device.
> 
> Hope this helps.

Yes, thanks !

Our CMD controllers normally support multi-path access but we haven't
tested it a lot and in good conditions for the moment...
But, I plan to test HA using a switch for active access and a hub for
passive access (used only in case of failure or maintenance of the
switch).

The CMD controllers normally support non-disruptive firmware upgrade, so
it shouldn't be a problem.

But, this is theory, if something hang, the only way is to reset it,
this is when the problem occur...
(yes, it should not :) )


What I thought about is a system to prevent use of a device during a few
seconds.
For example, I write 0 or 1 in the properties of a device (in
/proc/....) to prevent access on it and so prevent it from crashing.


Another thing, is there a way to do a "sync" only on a particular device
?
For example, I could flush filesystem buffers only in internal device
before hard reset so I only lost data on FC Raid but not on local SCSI
disks...

Thanks a lot for your help !

-- 
Fabien

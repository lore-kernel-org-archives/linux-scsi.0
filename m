From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: Re: PERC2/Si won't failover
Date: Mon, 31 Jan 2005 10:42:18 -0800
Message-ID: <41FE0B8A.10635.F25DCB4C@localhost>
References: <20050131134506.34A3AC4@frisbee.gerritsacc.nl>
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.advantagecom.net ([65.103.151.155]:12474 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S261304AbVAaSoC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 13:44:02 -0500
In-reply-to: <20050131134506.34A3AC4@frisbee.gerritsacc.nl>
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kit Gerrits <kit@gerritsacc.nl>
Cc: linux-scsi@vger.kernel.org

We had the same thing happen on a PE2500 with PERC3/DI, different 
drive configuration.

Text from my tech "diary" of sorts that I keep regarding unique 
problems I run into:

"The system would not boot after all the replacements were there, 
claiming "no boot device." For one reason or another, the RAID 
controller detected the new drive, but rather than just add the drive 
into the container and begin rebuilding, it simply offlined the 
container, which resulted in the "no boot device" message. I suspect 
this was because we did not properly inform the controller that were 
were taking a drive offline before we did so. We did it while the 
machine was turned off. We probably would have had better luck if we 
had booted the system, gone into afacli, prepare the enclosure slot 
to remove the drive, remove the drive, insert the new drive, and 
issue the proper commands to begin the rebuild if it doesn't start 
automatically. The OS afacli is much more robust than the RAID BIOS 
utilities.

The solution to get the drive into the RAID container and get it to 
begin rebuilding was to go into the RAID BIOS and assign the new 
drive as the failover drive. As soon as I did that, the container 
started rebuilding. I exited the utility (which automatically saves 
any settings) and rebooted. The system came back up just fine, like 
normal, and is now happily rebuilding the RAID array. No data was 
lost  and we now have as close to a completely new system as you can 
get short of replacing the entire thing."

It was just one part of a major system overhaul due to a "ghost" in 
the SCSI system that kept offlining our container in near-random non-
reproducable conditions, but I suspect a similar procedure may help 
in your instance.

Andrew

On 31 Jan 2005 at 14:49, Kit Gerrits wrote:

> Hey all!
> 
> I have a PowerEDGE 2400 with  PERC2/Si with 4x9GB Drives with RedHat
> EL 3.0 Container 0: plain 9GB drive (O/S) Container 1: 3x9GB in RAID5
> (data)
> 
> After getting I/O Errors (and gettinge a strange noise from drive
> 0:3:0), I did the unthinkable: I pulled the drive from the chassis
> without shutting it down. (oops) I have now verified the drive,
> cleaned off the partition and rescanned the bus. ...but the drive
> won't failover
> 
> I have set it to failover, but the PERC won't failover the drive, even
> after a (warm) reboot.
> 
> Did I forget anything?
> 
> Thanks in advance,
> 
> Kit Gerrits
> kit@gerritsaa.nl
> 
> 
> ---------------
> Debugging info:
> ---------------
> 
> AFA0> disk list
> Executing: disk list
> 
> B:ID:L  Device Type     Blocks    Bytes/Block Usage            Shared
> Rate ------  --------------  --------- ----------- ----------------
> ------ ---- 0:00:0   Disk            17783240  512         Initialized
>      NO     80 0:01:0   Disk            17783240  512        
> Initialized      NO     80 0:02:0   Disk            17783240  512     
>    Initialized      NO     80 0:03:0   Disk            17783240  512  
>       Initialized      NO     80
> 
> AFA0> container show failover
> Executing: container show failover
> 
> Container Scsi B:ID:L
> --------- ----------------------------------
>   0       --- No Devices Assigned ---
>   1       0:03:0
> 
> AFA0> container list
> Executing: container list
> Num          Total  Oth Chunk          Scsi   Partition
> Label Type   Size   Ctr Size   Usage   B:ID:L Offset:Size
> ----- ------ ------ --- ------ ------- ------ -------------
>  0    Volume 8.47GB            Open    0:00:0 64.0KB:8.47GB
>  /dev/sda             NT
> 
>  1    RAID-5 16.9GB       32KB Open    0:01:0 64.0KB:8.47GB
>  /dev/sdb             DATA             0:02:0 64.0KB:8.47GB
>                                    ?:??:?  - Missing -
> 
> AFA0> controller show au
> Executing: controller show automatic_failover
> Automatic failover ENABLED
> 
> AFA0> container scrub 1
> Executing: container scrub 1
> Command Error: <The controller was unable to perform a scrub
> (consistency check)
>  operation on the container because one or more of the container's
> partitions fa iled.  >
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> 


Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net




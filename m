From: "Kit Gerrits" <kit@gerritsacc.nl>
Subject: RE: PERC2/Si won't failover
Date: Mon, 31 Jan 2005 17:32:51 +0100
Message-ID: <20050131162835.93AB9C4@frisbee.gerritsacc.nl>
References: <20050131134506.34A3AC4@frisbee.gerritsacc.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.gerritsaa.nl ([82.168.101.83]:38217 "EHLO
	frisbee.gerritsacc.nl") by vger.kernel.org with ESMTP
	id S261259AbVAaQcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 11:32:31 -0500
Received: from localhost (localhost [127.0.0.1])
	by frisbee.gerritsacc.nl (Postfix) with ESMTP id A0C2386A
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 17:28:45 +0100 (CET)
Received: from frisbee.gerritsacc.nl ([127.0.0.1])
 by localhost (Frisbee [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 51614-05 for <linux-scsi@vger.kernel.org>;
 Mon, 31 Jan 2005 17:28:35 +0100 (CET)
Received: from kaglapxp (unknown [10.2.2.121])
	by frisbee.gerritsacc.nl (Postfix) with ESMTP id 93AB9C4
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 17:28:35 +0100 (CET)
In-Reply-To: <20050131134506.34A3AC4@frisbee.gerritsacc.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I found this in a diagnostic dump, maybe someone can make any sense of it?

[76]: CT_FindMissingEntry: dev = 3
[77]: CT_SwitchFillPrimary: recover missing entry, container Inde
[78]: x 1, dev 3, signature 0xf7b74944
[79]: CT_CONFIG_WARNING: at Line 8983 - CFG_MISSING_PARTITION: ar
[80]: g1 = 0x2 arg2 = 0x0

Kit

> -----Oorspronkelijk bericht-----
> Van: Kit Gerrits [mailto:kit@gerritsacc.nl] 
> Verzonden: maandag 31 januari 2005 14:49
> Aan: linux-scsi@vger.kernel.org
> Onderwerp: PERC2/Si won't failover
> 
> Hey all!
> 
> I have a PowerEDGE 2400 with  PERC2/Si with 4x9GB Drives with 
> RedHat EL 3.0 Container 0: plain 9GB drive (O/S) Container 1: 
> 3x9GB in RAID5 (data)
> 
> After getting I/O Errors (and gettinge a strange noise from 
> drive 0:3:0), I did the unthinkable: I pulled the drive from 
> the chassis without shutting it down. (oops) I have now 
> verified the drive, cleaned off the partition and rescanned the bus.
> ...but the drive won't failover
> 
> I have set it to failover, but the PERC won't failover the 
> drive, even after a (warm) reboot.
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
> B:ID:L  Device Type     Blocks    Bytes/Block Usage           
>  Shared Rate
> ------  --------------  --------- ----------- 
> ---------------- ------ ----
> 0:00:0   Disk            17783240  512         Initialized    
>   NO     80
> 0:01:0   Disk            17783240  512         Initialized    
>   NO     80
> 0:02:0   Disk            17783240  512         Initialized    
>   NO     80
> 0:03:0   Disk            17783240  512         Initialized    
>   NO     80
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
>                                        ?:??:?  - Missing -
> 
> AFA0> controller show au
> Executing: controller show automatic_failover Automatic 
> failover ENABLED
> 
> AFA0> container scrub 1
> Executing: container scrub 1
> Command Error: <The controller was unable to perform a scrub 
> (consistency
> check)
>  operation on the container because one or more of the 
> container's partitions fa iled.  >
> 
> 


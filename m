From: "Kit Gerrits" <kit@gerritsacc.nl>
Subject: Re: Disk Errors
Date: Tue, 1 Feb 2005 09:53:47 +0100
Message-ID: <20050201084926.21CC986F@frisbee.gerritsacc.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from www.gerritsaa.nl ([82.168.101.83]:23119 "EHLO
	frisbee.gerritsacc.nl") by vger.kernel.org with ESMTP
	id S261880AbVBAIx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2005 03:53:27 -0500
Received: from localhost (localhost [127.0.0.1])
	by frisbee.gerritsacc.nl (Postfix) with ESMTP id BE37086D
	for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2005 09:49:34 +0100 (CET)
Received: from frisbee.gerritsacc.nl ([127.0.0.1])
 by localhost (Frisbee [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 55669-07 for <linux-scsi@vger.kernel.org>;
 Tue,  1 Feb 2005 09:49:26 +0100 (CET)
Received: from kaglapxp (unknown [10.2.2.121])
	by frisbee.gerritsacc.nl (Postfix) with ESMTP id 21CC986F
	for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2005 09:49:26 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have found 08:05 to correspond to /dev/sda5, mounted as /usr(Thanks for
the pointer!).

Sda is the single-drive volume
(non-RAID, as it is only for the O/S,
which needs to be speedy and can be pulled from tape easily).

This explains several things:
A/ Why a single error can take an entire volume offline B/ Why the error is
not logged
	If it only took the partition offline, 
	it would still have been logged, 
	as / is mounted from sda3

And leaves one question:
What caused the error?

There are no GROWN defects on the drive in this volume


---------------
Reference logs:
---------------

Executing: disk show defects (ID=0)
Number of PRIMARY defects on drive: 1912 Number of GROWN defects on drive: 0

Executing: container list
Num          Total  Oth Chunk          Scsi   Partition    
Label Type   Size   Ctr Size   Usage   B:ID:L Offset:Size
----- ------ ------ --- ------ ------- ------ -------------
 0    Volume 8.47GB            Open    0:00:0 64.0KB:8.47GB
 /dev/sda             NT
 1    RAID-5 16.9GB       32KB Open    0:01:0 64.0KB:8.47GB
 /dev/sdb             DATA             0:02:0 64.0KB:8.47GB
                                       ?:??:?  - Missing - Mount points it
to:
# /dev/sda5             5.3G  1.5G  3.6G  30% /usr
 

> -----Oorspronkelijk bericht-----
> Van: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com]
> Verzonden: dinsdag 1 februari 2005 4:15
> Aan: Kit Gerrits
> Onderwerp: RE: Disk errors
> 
> The controller does not appear to be busted; you have a Volume and a 
> RAID-5. Are you missing an Array?
> 
> A two drive failure on a RAID-5 gives you an offline array.
> 
> A single drive failure in a Volume gives you an offline array.
> 
> You need to find who is 08:05, look through /dev for the major/minor 
> number and relate it to the 'device'. Look through /proc/scsi/scsi and 
> /var/messages to help correlate it.
> 
> Sincerely -- Mark Salyzyn
> 


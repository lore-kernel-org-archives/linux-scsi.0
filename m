From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Disk errors
Date: Mon, 31 Jan 2005 12:11:11 -0500
Message-ID: <74A9A71929931E40967CA9F27B1D7396DC00E3@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr14.intel.com ([192.55.52.68]:39371 "EHLO
	fmsfmr002.fm.intel.com") by vger.kernel.org with ESMTP
	id S261267AbVAaRLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2005 12:11:22 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org


I don't know much about agacli.

The mode pages do have bits to enable SMART, but that's not what I think
you are interested in.
However, SMART can generate info events that the OS may not be
recognizing.  

What you are interested is mode page 0x01 to see if AWRE and ARRE are
turned on (bits 7 & 6, 0xC0).
The default setting for these may be documented in the disk manual for
your drives also, which can be obtained from the vendor web site.  Or,
the PERC vendor may be able to help get this info.

Andy

-----Original Message-----
From: Kit Gerrits [mailto:kit@gerritsacc.nl] 
Sent: Monday, January 31, 2005 10:22 AM
To: Cress, Andrew R; linux-scsi@vger.kernel.org
Subject: RE: Disk errors


Andrew,

Thanks for explaining the initial vs grown error list.
 
Unfortunately, the tool itself monitors softwareRAID and SCSI devices.
This means that sgmode itself sees only the containers on the PERC.


Would you happen to know how to accomplish this in afacli?


AFA0> disk set ?
disk set default - Sets the various disk defaults for all subsequent CLI
commands.
disk set smart - Change a device's SMART configuration.

AFA0> disk show ?
disk show default - Shows the various defaults set for the CLI commands.
disk show defects - Shows the number of defects and/or defect list on a
particular disk drive.
disk show partition - Shows the partitions on the disks attached to this
controller.
disk show smart - Displays SMART values and settings for SMART enabled
devices.
disk show space - Shows space usage on the disks attached to the
controller.

AFA0> disk show default
Executing: disk show default
No Default

AFA0>disk show smart
Executing: disk show smart
        Smart    Method of         Enable
        Capable  Informational     Exception  Performance  Error
B:ID:L  Device   Exceptions(MRIE)  Control    Enabled      Count
------  -------  ----------------  ---------  -----------  ------
0:00:0     Y            6             Y           N             0
0:01:0     Y            6             Y           N             0
0:02:0     Y            6             Y           N             0
0:03:0     Y            6             Y           N             0
0:06:0     N


Thanks for the info

Kit


> -----Oorspronkelijk bericht-----
> Van: Cress, Andrew R [mailto:andrew.r.cress@intel.com] 
> Verzonden: maandag 31 januari 2005 15:46
> Aan: Kit Gerrits; linux-scsi@vger.kernel.org
> Onderwerp: RE: Disk errors
> 
> Kit,
> 
> With the growing size of disk drives, and a more sectors 
> allocated to reserve sectors, the number of defects alone is 
> not a big concern, expecially if they are PRIMARY defects 
> (found at manufacture-time).
> What would be of concern, is an increase in the number of 
> GROWN defects over a short period of time.  Unfortunately, it 
> is quite common for one defect to cause a disk to be 
> replaced, when it could be remapped without the expense and 
> trouble of a field replacement.
> 
> The automatic remapping of grown defects is a feature of SCSI 
> disks, but may not be configured in the disk's mode pages.  
> The mode pages can be changed without affecting the content 
> of the disk (with the exception of size & sector mapping 
> parameters).  There are several Linux tools to read/set mode 
> pages, among which is 'sgmode' from http://scsirastools.sf.net.
> 
> As a guess, it appears that you had a grown defect occur on 
> one of your disks, but the remapping was not set to occur 
> automatically on that disk, so a write never finished.
> 
> Andy
> 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Kit Gerrits
> Sent: Monday, January 31, 2005 9:28 AM
> To: linux-scsi@vger.kernel.org
> Subject: Disk errors
> 
> 
> Exactly how many errors is a SCSI disk allowed to have?
> 
> I have a PE2400 with a PERC2/Si with 4x9GB
> 
> My disks show:
> AFA0> disk show defects 0
> Executing: disk show defects (ID=0)
> Number of PRIMARY defects on drive: 1912 Number of GROWN 
> defects on drive: 0
> 
> AFA0> disk show defects 1
> Executing: disk show defects (ID=1)
> Number of PRIMARY defects on drive: 952
> Number of GROWN defects on drive: 1
> 
> AFA0> disk show defects 2
> Executing: disk show defects (ID=2)
> Number of PRIMARY defects on drive: 2457 Number of GROWN 
> defects on drive: 0
> 
> AFA0> disk show defects 3
> Executing: disk show defects (ID=3)
> Number of PRIMARY defects on drive: 2794 Number of GROWN 
> defects on drive: 0
> 
> The reason I ask is tha tmy O/S (RedHat Enterprise Linux 3.0) 
> has recently hung with the error:
> 
> I/O Error Dev 08:05 Sector 529712
> 
> I would assume that this error is generated by the harddrive, 
> but shouldn't the controller catch SCSI errors (and relocate 
> sectors automagically)?
> 
> Thanks in advance,
> 
> Kit Gerrits
> 
> kit@gerritsaa.nl
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html


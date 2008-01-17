From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Newer kernel not detecting devices?
Date: Thu, 17 Jan 2008 09:50:46 -0600
Message-ID: <1200585047.3255.11.camel@localhost.localdomain>
References: <20080117143750.tyw8i7497oso0c4w@secure.two-pebbles.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50502 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbYAQPux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 10:50:53 -0500
In-Reply-To: <20080117143750.tyw8i7497oso0c4w@secure.two-pebbles.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David <david@fuzzmail.co.uk>
Cc: linux-scsi@vger.kernel.org


On Thu, 2008-01-17 at 14:37 +0000, David wrote:
> I have here a server with an LSI SCSI card.  On one channel is a tape  
> changer, on the other an external RAID5 box with a number of disks in.  
>   All worked fine until a recent upgrade and now the disk array is not  
> recognised.
> 
> The disk array is still recognised on machine startup in the SCSI card  
> output on HBA 1, ID 0, LUN 0.  The tape changer is recognised in the  
> new install and has the correct devices assigned as before.
> 
> The SCSI card used for the tape changer and disk array is an LSI Logic  
> card.  The MegaRAID is seperate, a Dell PERC which has the system  
> disks attached.  However, another PERC was tested instead of the LSI  
> SCSI card which had the same problem.
> 
> lspci:
> 00:02.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express  
> Port A (rev 09)
> 00:04.0 PCI bridge: Intel Corporation E7525/E7520 PCI Express Port B (rev 09)
> )
> 02:0c.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030  
> PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
> 02:0c.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030  
> PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
> 02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller  
> 4 (rev 06)
> 
> On the old install, the following is seen:
> 
> /proc/scsi/sg/device_strs
> PE/PV   	1x2 SCSI BP     	1.0
> MegaRAID	LD 0 RAID1  286G	516A
> E1600SR 	                	0001 (the disk array)
> HL-DT-ST	RW/DVD GCC-4243N	A102

Where is the changer in this?

> uname -a:
> Linux ubuntu 2.6.20-15-generic #2 SMP Sun Apr 15 07:36:31 UTC 2007  
> i686 GNU/Linux
> 
> 
> On the new install:
> 
> /proc/scsi/sg/device_strs
> HL-DT-ST	RW/DVD GCC-4243N	A102
> PE/PV   	1x2 SCSI BP     	1.0
> MegaRAID	LD 0 RAID1  286G	516A
> 
> uname -a:
> Linux ubuntu 2.6.22-14-server #1 SMP Sun Oct 14 23:34:23 GMT 2007 i686  
> GNU/Linux
> 
> dmesg output from both builds is attached to this message.
> 
> A livecd of the old OS still recognises the disk array as sdb1 correctly.
> 
> Is this an issue with modules/options or a problem with the distro  
> (Ubuntu server)?

A good way to tell that would be to try booting with a vanilla linux
kernel.  2.6.24-rc8 should do the trick.

James



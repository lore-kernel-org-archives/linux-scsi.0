From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] megaraid_sas: fix physical disk handling
Date: Fri, 10 Feb 2006 08:55:57 +1000
Message-ID: <43EBC87D.3040205@torque.net>
References: <20060206140519.GA2515@lst.de> <1139509820.4220.2.camel@dhcp80-31.lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-124-242.swiftdsl.com.au ([218.214.124.242]:62257 "EHLO
	gate.localnet") by vger.kernel.org with ESMTP id S1750787AbWBIW5H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 17:57:07 -0500
In-Reply-To: <1139509820.4220.2.camel@dhcp80-31.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, Sreenivas.Bagalkote@lsil.com, Chandra_Nelogal@Dell.com, linux-scsi@vger.kernel.org

Sumant Patro wrote:
> Hello Christoph,
> 
> 	Thank you for the patch.
> 
>         As you mentioned this patch allows scsi generic access to the
> physical disks. I see this as potential data integrity issue if someone
> does a write operation on a disk that belongs to a Logical RAID volume.
> I would rather prevent all access to the disks using slave_alloc(). I
> will be sending a patch shortly for review that implements
> megasas_slave_alloc to block all direct access to the physical disks.

Sumant,
Typically a non-root user would not have write (or read)
permissions on a sg device node. A root user (or perhaps
a user with CAP_SYS_RAWIO) could send a SCSI WRITE command
to a physical disk, but that is no different from the
current situation.

IMO The main reason to allow access to the physical "logical"
units is for tools like smartmontools and access for commands
like LOG SENSE and MODE SENSE (and perhaps the SELECT variants
of those commands used carefully). Add INQUIRY to that list ...


With FC and SAS dual ported disks one could also think about
taking a persistent reservation on one I_T nexus (e.g. the
active port) and only allow access to the physical disk via
the secondary port. That way the finer graded command
filtering of PERSISTENT RESERVATION could be used to guard
the integrity of the disk.

Doug Gilbert

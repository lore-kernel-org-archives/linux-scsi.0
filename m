From: bloch@verdurin.com
Subject: Re: Very slow writes with mptsas
Date: Tue, 12 Jun 2007 15:15:11 +0100
Message-ID: <20070612141511.GB4347@bloch.config>
References: <20070605161620.GB6519@bloch.config>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 87-194-8-112.bethere.co.uk ([87.194.8.112]:59726 "EHLO
	bloch.config" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751777AbXFLOPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jun 2007 10:15:20 -0400
Content-Disposition: inline
In-Reply-To: <20070605161620.GB6519@bloch.config>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-precision@dell.com

On Tue, 05 Jun 2007, bloch@verdurin.com wrote:

> Hello
> 
> I'm seeing very slow writes on a Dell Precision 690 with the Dell SAS5
> adapter, serving a RAID1 array of SATA-II disks.
> 
> It's very similar to the problem in FreeBSD, described here:
> 
> http://unix.derkeiler.com/Mailing-Lists/FreeBSD/stable/2007-03/msg00756.html
> 
> I'm running FC6 with the latest kernel.
> 
> Reads are quite fast, writes terribly slow.
> 

Thanks to all who replied to this query, especially the very detailed
response from Eric Moore at LSI.

The first important facet is that we need to operate on the two hidden
physical disks, not the RAID device.  lsscsi differentiates them:

# lsscsi
[0:0:0:0]    disk    ATA      WDC WD5000KS-75M 2E08  -       
[0:0:1:0]    disk    ATA      HDS725050KLA360  AB5A  -       
[0:1:0:0]    disk    Dell     VIRTUAL DISK     1028  /dev/sda

sg_map gives the generic device numbers:

# sg_map -i -x
/dev/sg0  0 0 0 0  0  ATA       WDC WD5000KS-75M  2E08
/dev/sg1  0 0 1 0  0  ATA       HDS725050KLA360   AB5A

The write cache can then be enabled using sdparm:

sdparm -s WCE=1 -S /dev/sg0

and the result checked with

# sdparm -g WCE /dev/sg1
/dev/sg1: ATA       HDS725050KLA360   AB5A
WCE         1  [cha: y]

This seems to make the write performance much better.

The question for Dell is why their version of the BIOS doesn't set the
write cache in the first place or allow it to be altered by the user.

Cheers,
Adam


From: James Pearson <james-p@moving-picture.com>
Subject: Re: Write Performance double Read Performance
Date: Tue, 23 Mar 2004 11:28:16 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40601F50.F7A85DF0@moving-picture.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:18305 "EHLO
	moving-picture.com") by vger.kernel.org with ESMTP id S262465AbUCWL2W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 06:28:22 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Terrence Martin <tmartin@physics.ucsd.edu>

Terrence Martin <tmartin@physics.ucsd.edu> wrote:
>
> I have the following system(s)
> 
> Dual 2.8 Ghz Xeon 2U Supermicro Server with 2GB RAM
> Qlogic QLA2310f Controller
> 
> attached to an...
> 
> Infortrend A16F with 16 300GB WD IDE PATA Drives
> The array as a RAID 5 Array with 3 partitions of 1.4TB each. I have 
> mounted one of the partitions to test.
> 
> The OS is....
> 
> Fedora Core 1 with the latest Fedora 2.4 Kernel (2.4.22-1.2174.nptlsmp)
> I have compiled the QLA drivers from the Qlogic site and am using v6.06.10.
> 
> The problem I am noticing is that while doing an IOZone performance test 
> I get nice write performance when the test gets to large files. However 
> my read performance seems to be a little over half my write.   I thought 
> the read should always be faster than the write?

Unfortunately I don't know why, but this is something I've been thinking
of asking as well.

I've seen similar behaviour on a 2.6.3 kernel machine (dual 2.4 Xeons,
2GB RAM) using an external U160 SCSI Chaparral hardware RAID 5 on a
aic79xx controller. I'm using XFS on the RAID.

I've just been using 'lmdd' to/from a 2Gb file - I also see writes about
twice the speed of reads (I'm using the fsync or sync option to lmdd
with the writes).

However, if I increase the readahead on the disk using blockdev from the
default of 256 to 4096, I can get read speeds to be about the same as
the writes.

However, increasing the readahead seems to help this simple streaming
case, but as yet I don't know if it will work in a general file serving
(NFS) situation.

> Before I went down the road of compiling various kernels etc I thought I 
> would post this to linux-scsi to see if it is just some configuration 
> setting to a driver or kernel parameter that needs to be tweaked.  Of 
> course I could be completely reading this wrong but bonnie++ also 
> appears to give similar results and vmstat is similarly low on the read 
> side.

I would also like to know of any optimizations that can be made.

Thanks

James Pearson

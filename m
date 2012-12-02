From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED
 OPERATION CODES
Date: Sun, 2 Dec 2012 19:16:54 +0100
Message-ID: <20121202191654.59117ac2@stein>
References: <20121125184525.0b7967c4@stein>
	<yq18v9nsz3q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50062 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2LBSRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 13:17:10 -0500
In-Reply-To: <yq18v9nsz3q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Nov 26 Martin K. Petersen wrote:
> >>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> Stefan> I did not try "sg_write_same" on any of the devices; but since
> Stefan> the two SPC-3 devices are correctly identified as "fully
> Stefan> provisioned", won't issue WRITE SAME to them either.
                       ^[the kernel]
> 
> What if you have an SSD behind one of them?

At the moment I only have a single old SSD available which does not
implement ATA TRIM as far as I recall.

And the two mentioned OXUF936QSE based SPC-3 devices are four-bay SATA disk
enclosures whose firmwares only support various RAID modes and require at
least two bays to be populated.  I.e. I can't test them with the SSD for
now.  But I suspect that they don't implement thin provisioning anyway,
particularly translation of WRITE SAME with UNMAP to ATA TRIM.

But now I found another SPC-3 compliant device in my stash; a dual SATA
bridge based on OXUF934DSB which supports JBOD with 1...2 disks
alternatively to striping/ spanning/ mirroring over 2 disks.  I attached
the old SSD to it, and its thin_provisioning sysfs attribute was shown as
0 as well.  "sg_write_same -U ..." on this device in the 10 and 16 byte
variants ended with Illegal Request/ Invalid command operation code, but
otherwise without discernible malfunction.

> Stefan> Hence let's remove the no_report_opcodes and no_write_same
> Stefan> blacklist flags so that these commands can be used on
> Stefan> respectively capable targets.  
> 
> I just erred on the side of caution. If you are happy without belt and
> suspenders that's perfectly ok with me :)

Blacklisting at first was definitely the right approach.  But now that I
looked at a variety of older and newer devices, I am confident that the
general Inquiry_Data.Version >= SPC-3 test keeps the wackier among the
SBP-2 devices safe enough.

Of course it remains to be seen what happens with ATA TRIM enabled SSDs
behind the newer SPC-3 compliant bridges, but at this time the risk with
those seems low.
-- 
Stefan Richter
-=====-===-- =-== ==-==
http://arcgraph.de/sr/

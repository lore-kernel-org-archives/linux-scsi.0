From: Rock Gordon <rockgordon@yahoo.com>
Subject: RE: WWN on FC LUN targets
Date: Wed, 28 Jul 2004 08:46:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040728154614.53413.qmail@web41406.mail.yahoo.com>
References: <82C736F456CA3E4EA3D0DC6CC31AA5CB011B05D3@esply09.cnt.ad.cnt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web41406.mail.yahoo.com ([66.218.93.72]:33198 "HELO
	web41406.mail.yahoo.com") by vger.kernel.org with SMTP
	id S267242AbUG1PqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 11:46:15 -0400
In-Reply-To: <82C736F456CA3E4EA3D0DC6CC31AA5CB011B05D3@esply09.cnt.ad.cnt.com>
List-Id: linux-scsi@vger.kernel.org
To: "David Peterson (Eng)" <david_peterson@cnt.com>, Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Hello everyone, thanks for your replies.

If I wasn't clear in my earlier posting - let me throw
in some additional clues. The need is to be able to
identifiy logical units (which I refer to as LUNs)
uniquely, no matter where they are and to whichever FC
network they might end up getting connected to at any
given point in time. Each of them will have a
filesystem on it - however this filesystem is served
to the outside world by NFSD (or any other we pick
later on). The issue is that the NFSD serves only
particular filesystems - and they need a unique and
portable way to identify them.

Hence anything that is not portable or not unique
world-wide is suspect. I feel the SCSI device ID falls
in this category.

My network layout is simple - RAID5 JBODs connected
directly to FC switches; and no sub-partitioning done
on the storage JBODs so there's only one LUN on each
of them.

So if a WWWN is indeed assigned to a single SCSI LUN,
can it be found out from any such SCSI LUN connected
to an FC network through any programming interface? I
was looking at drivers/scsi/cpqioctl.c (and got it to
compile after making some changes) - but it apparently
the ioctl does not work for some reason.

A brute force approach would be to write some unique
identifier in a file on the filesystem and to mount
all connected filesystems readonly to read off the
unique numbers from that file. However not only is
this approach not scalable; it also won't work in case
of an mkfs.

Yet another approach would be to record the
host/bus/target/lun of each logical unit. However this
might not work in case of a re-arrangement of the
network or even re-seating HBAs inside the servers
themselves; am I right?

>
> If supported by the device, use the Device
> Identification VPD page
> (0x83) to identify the Logical Unit. See SPC-3.
> The preferred identifier type is NAA (which is a
> Worldwide_Name). Annex
> D in FCP-2/FCP-3 may also be of assistance to you.
>

Thanks David, I guess more reading to be done on my
side :)

Regards,
Rocky


		
__________________________________
Do you Yahoo!?
Yahoo! Mail - 50x more storage than other providers!
http://promotions.yahoo.com/new_mail

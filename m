From: Craig Tierney <ctierney@hpti.com>
Subject: Question about Qlogic performance in 2.6 kernel
Date: Wed, 13 Oct 2004 18:28:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097713700.3213.159.camel@hpti9.fsl.noaa.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from system65-210-78-197.hpti.com ([65.210.78.197]:8606 "EHLO
	hptimail01.HPTI.COM") by vger.kernel.org with ESMTP id S269932AbUJNAbE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 20:31:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am seeing a large disparity in reads and writes from
my Raid box under the 2.6 kernel.  I have tried this from
an Itanium box runing RHEL 4 beta and an Opteron box running
SUSE 9.1 professional.  In both cases I am using 2 qlogic
QLA2200F HBAs.  Each HBA talks to one lun from the array, and
I use dm to create a filesystem.

Using lmdd to create a single stream of IO, I see 190 MB/s for
writes, but only 55 MB/s for reads.  The vendor says reads and
writes can be as much as 300 MB/s if I had the right HBAs, but
the write performance is good for 2 1 Gb/s HBAs.  

I tried this with a 2.4 kernel on a dual Xeon box.  Performance
was 150 MB/s for both reads and writes.  The read performance was
that high only after I changed /proc/sys/vm/max-readahead to 1023.

I tried changing the readahead size in 2.6 using blockdev.  The
readahead was much larger by default than the 2.4 kernel.  However,
no matter how large I set the readahead (as large as 1 MB), the
read performance did not change.

I read on the kernel list that in the linux-2.6.9-rc3, some changes
to the readahead code path had been merged that was supposed to
simplify the logic.  I tried the patch to see if affected performance.
It did not.

Does anyone have some suggestions on how to improve the read performance
under 2.6?

Thanks,
Craig


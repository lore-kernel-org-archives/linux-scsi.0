From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4 of 8] sd: Physical block size and alignment support
Date: Thu, 23 Apr 2009 14:25:54 -0400
Message-ID: <yq1ab67b51p.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	<fc4cc94aa1e2612b3489.1240464571@sermon.lab.mkp.net>
	<20090423163700.GB8350@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:19070 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZDWS1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 14:27:37 -0400
In-Reply-To: <20090423163700.GB8350@mars.virtualiron.com> (Konrad Rzeszutek's
	message of "Thu, 23 Apr 2009 12:37:00 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Konrad" == Konrad Rzeszutek <konrad@virtualiron.com> writes:

[Printing physical block size]

Konrad> With the changes in the read_capacity_16 (where you set the
Konrad> hw_sector_size) this won't be printed (at least on first probe).

Why not?

[root@10 ~]# modprobe scsi_debug dev_size_mb=1024 num_parts=4 physblk_exp=3
scsi 6:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
sd 6:0:0:0: Attached scsi generic sg3 type 0
sd 6:0:0:0: [sdc] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
sd 6:0:0:0: [sdc] 4096-byte physical blocks


Konrad> Another question - should the Documentation/*.txt have an entry
Konrad> about what a 'logical block', and 'physical block' is
Konrad> vs. 'hardware sector' ?

Well, another item on my todo list is to kill the notion of hardware
sector completely.  The protocols have been referring to logical blocks
for ages.

It hasn't been a big problem until now because logical block size has
been equal to the hardware sector size.  That's no longer a valid
assumption.

-- 
Martin K. Petersen	Oracle Linux Engineering

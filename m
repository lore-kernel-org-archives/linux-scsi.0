From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 07 Nov 2014 12:40:59 -0500
Message-ID: <yq1mw829adw.fsf@sermon.lab.mkp.net>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net>
	<94D0CD8314A33A4D9D801C0FE68B40295937AE5D@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49095 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKGRlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 12:41:09 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295937AE5D@G4W3202.americas.hpqcorp.net>
	(Robert Elliott's message of "Fri, 7 Nov 2014 17:10:34 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Friesen <chris.friesen@windriver.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>

>>>>> "Rob" == Elliott, Robert (Server Storage) <Elliott@hp.com> writes:

Rob,

Rob> * the block layer BIO_MAX_PAGES value of 256 limits IOs
Rob>   to a maximum of 1 MiB

We do support scatterlist chaining, though.

Rob> * SCSI LLDs report their maximum transfer size in
Rob>   /sys/block/sdNN/queue/max_hw_sectors_kb
Rob> * the SCSI midlayer maximum transfer size is set/reported
Rob>   in /sys/block/sdNN/queue/max_sectors_kb and the default is 512
Rob>   KiB
Rob> * the SCSI LLD maximum number of scatter gather entries
Rob>   reported in /sys/block/sdNN/queue/max_segments and
Rob>   /sys/block/sdNN/queue/max_segment_size creates a limit based on
Rob>   how fragmented the data buffer is in virtual memory
Rob> * the Block Limits VPD page MAXIMUM TRANSFER LENGTH field
Rob>   indicates the maximum transfer size for one command over the SCSI
Rob>   transport protocol supported by the drive itself

Yep. We're already capping the actual max I/O size based on all of the
above. However, the purpose of exposing io_opt was to be able to report
stripe size to partitioning tools and filesystems for alignment
purposes. And although they would ideally be the same it was always
anticipated that stripe size could be bigger than the max I/O size.

-- 
Martin K. Petersen	Oracle Linux Engineering

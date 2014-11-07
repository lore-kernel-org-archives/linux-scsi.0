From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 7 Nov 2014 17:10:34 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295937AE5D@G4W3202.americas.hpqcorp.net>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
 <yq1zjc3ai4h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zjc3ai4h.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Friesen <chris.friesen@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> commit 87c0103ea3f96615b8a9816b8aee8a7ccdf55d50
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Thu Nov 6 12:31:43 2014 -0500
> 
>     [SCSI] sd: Sanity check the optimal I/O size
> 
>     We have come across a couple of devices that report crackpot
> 	values in the optimal I/O size in the Block Limits VPD page. 
>	Since this is a 32-bit entity that gets multiplied by the
>	logical block size we can get
>     disproportionately large values reported to the block layer.
> 
>     Cap io_opt at 1 GB.

Another reasonable cap is the maximum transfer size.
There are lots of them:

* the block layer BIO_MAX_PAGES value of 256 limits IOs
  to a maximum of 1 MiB
* SCSI LLDs report their maximum transfer size in
  /sys/block/sdNN/queue/max_hw_sectors_kb
* the SCSI midlayer maximum transfer size is set/reported
  in /sys/block/sdNN/queue/max_sectors_kb
  and the default is 512 KiB
* the SCSI LLD maximum number of scatter gather entries
  reported in /sys/block/sdNN/queue/max_segments and
  /sys/block/sdNN/queue/max_segment_size creates a
  limit based on how fragmented the data buffer is
  in virtual memory
* the Block Limits VPD page MAXIMUM TRANSFER LENGTH field
  indicates the maximum transfer size for one command over
  the SCSI transport protocol supported by the drive itself

It is risky to use transfer sizes larger than linux and
Windows can generate, since drives are probably tested in
those environments.

---
Rob Elliott    HP Server Storage

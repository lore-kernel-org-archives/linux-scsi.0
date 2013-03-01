From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2 0/2] dm: Avoid use-after-free of a mapped device
Date: Fri, 01 Mar 2013 17:18:54 +0900
Message-ID: <5130646E.1010803@ce.jp.nec.com>
References: <512E1C06.2000903@acm.org> <512EA7F3.6010607@ce.jp.nec.com> <512F54D0.5030405@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:53516 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3CAITe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 03:19:34 -0500
In-Reply-To: <512F54D0.5030405@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

On 02/28/13 22:00, Bart Van Assche wrote:
> How about reposting these patches as a performance optimization ?

How and when do they improve performance?

> With these patches I see a slightly lower latency and slightly higher
> throughput. With a dm-linear mapping on top of a RAM disk (brd), a
> request size of 512 bytes and 100% reads fio reports 2063K IOPS without
> these patches and 2083K IOPS with these two patches applied. That's an
> improvement of about 1%. It's not much but that comes on top of the

dm-linear + brd is not appropriate for testing your patches.
They are both bio-based drivers while your patches change request
processing.  To test the patches, you have to use request-based drivers,
e.g. dm-multipath on top of scsi.

Also, IMO, the measurement should be done not only for IO performance
but also how other processes are interrupted by IO processing.
The use of blk_run_queue_async should have reduced the foot print of
softirq handling.

-- 
Jun'ichi Nomura, NEC Corporation

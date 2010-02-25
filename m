From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 12:28:03 -0500
Message-ID: <yq1vddlkyxo.fsf@sermon.lab.mkp.net>
References: <20100225165901.GZ30797@beardog.cce.hp.com>
	<20100225171826.GC30797@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:44912 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab0BYR3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 12:29:17 -0500
In-Reply-To: <20100225171826.GC30797@beardog.cce.hp.com>
	(scameron@beardog.cce.hp.com's message of "Thu, 25 Feb 2010 11:18:26
	-0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, axboe@kernel.dk

>>>>> "scameron" == scameron  <scameron@beardog.cce.hp.com> writes:

scameron> BLK_DEF_MAX_SECTORS seems to act as a cap, as a MAXIMUM
scameron> possible value for q->limits->max_sectors in blk_queue_max_sectors,
scameron> but as a MINIMUM for q->limits.max_hw_sectors in
scameron> blk_queue_max_hw_sectors.

Please read the entire thread.

blk_queue_max_hw_sectors() is dead, it was never used except briefly by
DM.  Device drivers should use blk_queue_max_sectors() to set their hard
limit.

max_sectors is a block layer soft limit that can be overridden on a
per-device basis in /sys/block/foo/queue/max_sectors_kb.

-- 
Martin K. Petersen	Oracle Linux Engineering

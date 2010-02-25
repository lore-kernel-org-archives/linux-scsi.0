From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 09:41:58 -0800
Message-ID: <4B86B666.2070806@panasas.com>
References: <20100225165901.GZ30797@beardog.cce.hp.com>	<20100225171826.GC30797@beardog.cce.hp.com> <yq1vddlkyxo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35314 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933050Ab0BYRmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 12:42:00 -0500
In-Reply-To: <yq1vddlkyxo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, axboe@kernel.dk

On 02/25/2010 09:28 AM, Martin K. Petersen wrote:
>>>>>> "scameron" == scameron  <scameron@beardog.cce.hp.com> writes:
> 
> scameron> BLK_DEF_MAX_SECTORS seems to act as a cap, as a MAXIMUM
> scameron> possible value for q->limits->max_sectors in blk_queue_max_sectors,
> scameron> but as a MINIMUM for q->limits.max_hw_sectors in
> scameron> blk_queue_max_hw_sectors.
> 
> Please read the entire thread.
> 
> blk_queue_max_hw_sectors() is dead, it was never used except briefly by
> DM.  Device drivers should use blk_queue_max_sectors() to set their hard
> limit.
> 
> max_sectors is a block layer soft limit that can be overridden on a
> per-device basis in /sys/block/foo/queue/max_sectors_kb.
> 

It seems like the confusion calls for a rename. We are made to believe
that the accessors naming convention is the same as the queue member it
changes. But here it is named as another very confusing member.

At least if the name is not changed, a big fat comment is do, that says
this is for drivers to change the *max_hw_sectors* though it is named
after that other - not for drivers - member.

Just my $0.017
Boaz

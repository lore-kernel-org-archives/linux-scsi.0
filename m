From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
Date: Mon, 23 Jan 2017 08:39:44 -0700
Message-ID: <ab371cbe-9abc-877e-b529-a7a3c39ff229@fb.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38818 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750828AbdAWPkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 10:40:06 -0500
In-Reply-To: <1485185361-29786-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/23/2017 08:29 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series splits the support for SCSI passthrough commands from the
> main struct request used all over the block layer into a separate
> scsi_request structure that drivers that want to support SCSI passthough
> need to embedded as the first thing into their request-private data,
> similar to how we handle NVMe passthrough commands.
> 
> To support this I've added support for that the private data after
> request structure to the legacy request path instead, so that it can
> be treated the same way as the blk-mq path.  Compare to the current
> scsi_cmnd allocator that actually is a major simplification.
> 
> Compared to the previous RFC version the major change is that dm-mpath
> works with this version.  To make it work I've switched the legacy
> request dm-rq to use the same clone and map method as the blk-mq version.

I'd like to get this in sooner rather than later, so I'll spend some
time reviewing and testing it start this week. I'm assuming you are
targeting 4.11 with this change, right?

-- 
Jens Axboe


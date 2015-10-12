From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH, RFC] blk-mq: use a delayed work item for timeouts
Date: Mon, 12 Oct 2015 13:34:20 -0600
Message-ID: <561C0B3C.70004@fb.com>
References: <1444678154-24766-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1226 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbbJLTet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 15:34:49 -0400
In-Reply-To: <1444678154-24766-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: hare@suse.de, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On 10/12/2015 01:29 PM, Christoph Hellwig wrote:
> For some pending NVMe work I'd really love to be able to get my timeouts
> from process context.  So far it seems only SCSI and NVMe use the blk-mq
> timeout handler, and both don't seem to be particularly excited about
> being called from time context.  Does anyone have an objection against
> the patch below that switches it to use a delayed work item?  I could
> make use of this quickly for NVMe, but for SCSI we still have to deal
> with the old request code which can't be switched to a delayed work
> as easily.

No that's definitely fine with me, imho most error handling callbacks 
should be in process context for ease of use in the driver.


-- 
Jens Axboe


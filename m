Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C90C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 08:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC046117A
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 08:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhKCIkL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 04:40:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:5345 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhKCIkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 04:40:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="218361762"
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="218361762"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 01:37:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="449707015"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga006.jf.intel.com with ESMTP; 03 Nov 2021 01:37:31 -0700
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
To:     Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <YYI9BLBhrFbgridf@infradead.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <19b8e555-d12f-9bf5-91c6-d3c5f849e72c@intel.com>
Date:   Wed, 3 Nov 2021 10:37:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYI9BLBhrFbgridf@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/11/2021 09:40, Christoph Hellwig wrote:
> On Tue, Nov 02, 2021 at 05:05:29PM -0700, Bart Van Assche wrote:
>> -	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>> +	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> 
> blk_get_request will be gone in 5.16-rc, so this won't apply.
> 
> But more importantly: SCSI LLDDs have absolutel no business calling
> blk_get_request or blk_mq_alloc_request directly, but as usual UFS is
> completely fucked up here.

The UFS driver does not issue device commands to the block layer.
blk_get_request() is used only to get a free slot.

> Please add a SCSI midlayer helper to allocate the reserved tags, and
> switch _all_ of this UFS we're sending our own commands crap to it
> so it doesn't mix with the actual SCSI requests.

It doesn't mix them.

> We might or might not
> want a separate request_queue for them as well as non-SCSI requests
> really should not show up in ->queuecommand.

Already has one (hba->cmd_queue), but as noted above, device commands
aren't issued to it at the moment - they are sent directly.

> Hannes and John have been
> looking into this for a while and we need to sort this out properly.

To avoid involving SCSI, since device commands aren't issued to the
block layer, the UFS driver could instead keep 1 slot for itself
(i.e. reduce the number of tags by one), and drop blk_get_request();
noting that currently only 1 device command is sent at a time due to
hba->dev_cmd.lock mutex.

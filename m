From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] blk-mq: Fix failed allocation path when mapping queues
Date: Thu, 01 Dec 2016 15:51:37 -0200
Message-ID: <8737i7sfkm.fsf@linux.vnet.ibm.com>
References: <1479837269-5742-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1479837269-5742-1-git-send-email-krisman@linux.vnet.ibm.com>
        (Gabriel Krisman Bertazi's message of "Tue, 22 Nov 2016 15:54:28
        -0200")
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:

> My one concern about this patch is if remapping an arbitrary queue to
> hctx_0 could result in outstanding requests getting submitted to the
> wrong hctx.  I couldn't observe this happening during tests, but I'm not
> entirely sure it'll never happen.  I believe the queue will be empty if
> we are trying to allocate tags for it, unless it was using another alive
> hctx queue and for some reason got reassigned to this new hctx.  is this
> possible at all?

I no longer believe this case to be an issue for accepting this patch,
since if a queue enters this path and get's remapped to hctx_0, it means
the ctx would already be getting remaped to a new queue anyway, and it
should use the requests that were just mapped for that queue.  So, for a
correctness standpoint it doesn't matter which queue we are remaping,
the failed hctx or hctx_0, no request would get redirected to the wrong
queue with this change.

Jens, do you think this set is good for merging in 4.10?  It fixes some
issues for us on low memory conditions.

-- 
Gabriel Krisman Bertazi


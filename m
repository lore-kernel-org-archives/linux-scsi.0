From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] blk-mq: Fix failed allocation path when mapping queues
Date: Wed, 14 Dec 2016 13:58:20 -0700
Message-ID: <ef5a4111-e52e-7d33-57bd-d3ef9f23e3f8@kernel.dk>
References: <1481748516-19982-1-git-send-email-gabriel@krisman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1481748516-19982-1-git-send-email-gabriel@krisman.be>
Sender: linux-block-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <gabriel@krisman.be>
Cc: linux-block@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/14/2016 01:48 PM, Gabriel Krisman Bertazi wrote:
> From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> 
> In blk_mq_map_swqueue, there is a memory optimization that frees the
> tags of a queue that has gone unmapped.  Later, if that hctx is remapped
> after another topology change, the tags need to be reallocated.
> 
> If this allocation fails, a simple WARN_ON triggers, but the block layer
> ends up with an active hctx without any corresponding set of tags.
> Then, any income IO to that hctx can trigger an Oops.
> 
> I can reproduce it consistently by running IO, flipping CPUs on and off
> and eventually injecting a memory allocation failure in that path.
> 
> In the fix below, if the system experiences a failed allocation of any
> hctx's tags, we remap all the ctxs of that queue to the hctx_0, which
> should always keep it's tags.  There is a minor performance hit, since
> our mapping just got worse after the error path, but this is
> the simplest solution to handle this error path.  The performance hit
> will disappear after another successful remap.
> 
> I considered dropping the memory optimization all together, but it
> seemed a bad trade-off to handle this very specific error case.

Thanks, this looks fine to me now. Both of your patches are queued
up for inclusion in 4.10.

-- 
Jens Axboe


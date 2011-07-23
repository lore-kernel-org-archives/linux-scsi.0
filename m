From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
Date: Sat, 23 Jul 2011 20:41:31 +0200
Message-ID: <4E2B15DB.4090302@fusionio.com>
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6> <20110722205938.17420.68621.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110722205938.17420.68621.stgit@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Roland Dreier <roland@purestorage.com>, Dave Jiang <dave.jiang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-07-22 22:59, Dan Williams wrote:
> Some storage controllers benefit from completions always being steered
> to the strict requester cpu rather than the looser "per-socket" steering
> that blk_cpu_to_group() attempts by default.
> 
> echo 2 > /sys/block/<bdev>/queue/rq_affinity

I have applied this one, with a modified patch description.

I like the adaptive solution, but it should be rewritten to not declare
and expose softirq internals. Essentially have an API from
kernel/softirq.c that can return whether a given (or perhaps just local)
softirq handler is busy or not.


-- 
Jens Axboe

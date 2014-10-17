From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] block: add function to issue compare and write
Date: Fri, 17 Oct 2014 02:55:55 -0700
Message-ID: <20141017095555.GA360@infradead.org>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
 <1413437835-13778-3-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413437835-13778-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 16, 2014 at 12:37:12AM -0500, michaelc@cs.wisc.edu wrote:
> @@ -160,7 +160,7 @@ enum rq_flag_bits {
>  	__REQ_DISCARD,		/* request to discard sectors */
>  	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
>  	__REQ_WRITE_SAME,	/* write same block many times */
> -
> +	__REQ_CMP_AND_WRITE,	/* compare data and write if matched */

I think it's time that we stop overloading the request flags with
request types.

We already have req->cmd_type which actually is a fairly good
description of what we get except for REQ_TYPE_FS, which is a horrible
overload using req->cmd_flags.

Given that you're just one of many currently ongoing patches to add
more flags here I think you need to byte the bullet and fix this up
by replacing REQ_TYPE_FS with:

REQ_TYPE_WRITE
REQ_TYPE_READ
REQ_TYPE_FLUSH
REQ_TYPE_DISCARD
REQ_TYPE_WRITE_SAME
REQ_TYPE_CMP_AND_WRITE

sd.c is a nice guide of what should be a flag and what a type since my
last refactoring of the command_init function.

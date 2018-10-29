From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 10/14] blk-mq: initial support for multiple queue maps
Date: Mon, 29 Oct 2018 13:25:30 -0700
Message-ID: <1540844730.196084.95.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-11-axboe@kernel.dk>
         <1540842034.196084.89.camel@acm.org>
         <ac755067-1432-54ce-6a4f-c7383f1ecc9d@kernel.dk>
         <1540843250.196084.93.camel@acm.org>
         <867d3e60-3edf-39e7-2bcb-02d7f1092f82@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <867d3e60-3edf-39e7-2bcb-02d7f1092f82@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 14:09 -0600, Jens Axboe wrote:
+AD4 hctx-+AD4-type will be set to the value of the first type. This is all driver
+AD4 private, blk-mq could not care less what the value of the type means.
+AD4 
+AD4 As to the other question, it works just fine since that is the queue
+AD4 that is being accessed. There's no confusion there. I think you're
+AD4 misunderstanding how it's seutp. To use nvme as the example, type 0
+AD4 would be reads, 1 writes, and 2 pollable queues. If reads and writes
+AD4 share the same set of hardware queues, then type 1 simply doesn't
+AD4 exist in terms of -+AD4-flags+AF8-to+AF8-type() return value. This is purely
+AD4 driven by the driver. That hook is the only decider of where something
+AD4 will go. If we share hctx sets, we share the same hardware queue as
+AD4 well. There is just the one set for that case.

How about adding a comment in blk-mq.h that explains that hardware queues can
be shared among different hardware queue types? I think this is nontrivial and
deserves a comment.

Thanks,

Bart.

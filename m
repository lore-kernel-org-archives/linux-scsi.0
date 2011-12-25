From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be allowed
 to create io_context
Date: Sun, 25 Dec 2011 14:29:34 +0100
Message-ID: <4EF7253E.3070606@kernel.dk>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au> <20111221151503.4d78f94f.akpm@linux-foundation.org> <20111222150836.af172886.akpm@linux-foundation.org> <20111222232036.GP17084@google.com> <20111222152427.c944c747.akpm@linux-foundation.org> <20111222233843.GR17084@google.com> <20111222154427.89b245c7.akpm@linux-foundation.org> <20111222234639.GS17084@google.com> <20111223004244.GU17084@google.com> <alpine.LSU.2.00.1112232058550.3225@eggly.anvils> <20111225010238.GA6013@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111225010238.GA6013@htj.dyndns.org>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hugh Dickins <hughd@google.com>, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2011-12-25 02:02, Tejun Heo wrote:
> While fixing io_context creation / task exit race condition,
> 6e736be7f2 "block: make ioc get/put interface more conventional and
> fix race on alloction" also prevented an exiting (%PF_EXITING) task
> from creating its own io_context.  This is incorrect as exit path may
> issue IOs, e.g. from exit_files(), and if those IOs are the first ones
> issued by the task, io_context needs to be created to process the IOs.
> 
> Combined with the existing problem of io_context / io_cq creation
> failure having the possibility of stalling IO, this problem results in
> deterministic full IO lockup with certain workloads.
> 
> Fix it by allowing io_context creation regardless of %PF_EXITING for
> %current.

Thanks, applied.

-- 
Jens Axboe

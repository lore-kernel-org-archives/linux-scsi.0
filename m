From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND PATCH v1 1/2] trace: events: scsi: Add tag in SCSI
 trace events
Date: Mon, 16 Apr 2018 18:06:01 -0400
Message-ID: <20180416180601.52119e2c@gandalf.local.home>
References: <4650cbf668fd4853ad98dba834141e08@SIWEX5A.sing.micron.com>
        <bee7c8b15b7cec3d4b1442f414e766539fac2491.camel@wdc.com>
        <20180416172447.5166f854@gandalf.local.home>
        <4cdc179e652f8e2b2d7a069029101224779522a5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4cdc179e652f8e2b2d7a069029101224779522a5.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "beanhuo@micron.com" <beanhuo@micron.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "rajatja@google.com" <rajatja@google.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Apr 2018 21:30:54 +0000
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> Hello Steve,
> 
> The tool I'm most concerned about is blktrace. I'm not sure though how this
> tool receives event data from the block layer core.

Yeah, blktrace is "special", it looks like it registers its callbacks
from the tracepoints, and writes the data to its own relay buffer. As
it's not relying on the output from the tracing directory, additional
fields being added shouldn't affect it.

Looking at the trace event "block_rq_requeue" we have in the blktrace
kernel code:

static void blk_register_tracepoints(void)
{
	int ret;

	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);


Where the callback blk_add_trace_rq_insert() gets called when the
trace event is hit.

static void blk_add_trace_rq_insert(void *ignore,
				    struct request_queue *q, struct request *rq)
{
	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT,
			 blk_trace_request_get_cgid(q, rq));
}

Where:

static void blk_add_trace_rq(struct request *rq, int error,
			     unsigned int nr_bytes, u32 what,
			     union kernfs_node_id *cgid)
{

calls

	__blk_add_trace(bt, blk_rq_trace_sector(rq), nr_bytes, req_op(rq),
			rq->cmd_flags, what, error, 0, NULL, cgid);

Which calls either the ftrace tracing file or its own relay buffer.

Looking at the code from
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git

It appears that it does not rely on the ftrace ring buffers.

So I'm guessing blktrace is not affected by this patch.

-- Steve

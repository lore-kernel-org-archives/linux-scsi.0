From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: QLA12160 ring buffer starvation? on 2.4.x
Date: Fri, 1 Nov 2002 11:42:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101114248.A4097@eng2.beaverton.ibm.com>
References: <20021101.205009.783396609.nomura@hpc.bs1.fc.nec.co.jp> <20021101090419.A635@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021101090419.A635@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Nov 01, 2002 at 09:04:19AM -0800
List-Id: linux-scsi@vger.kernel.org
To: j-nomura@ce.jp.nec.com
Cc: linux-scsi@vger.kernel.org, jes@trained-monkey.org

On Fri, Nov 01, 2002 at 09:04:19AM -0800, Patrick Mansfield wrote:
> On Fri, Nov 01, 2002 at 08:50:09PM +0900, j-nomura@ce.jp.nec.com wrote:
> > qla1280_next is executed either when the first command is queued by
> > qla1280_queuecommand or when issued command completes in qla1280_done.
> > qla1280_next works only for specified queue.

I didn't notice the per-queue aspect of the above, that implies
it can completely starve one LU.

You could try setting can_queue to a reasonable limit (rather than
0xfffff) like the size of the ring buffer, and perhaps also lower
the queue depth (similiar to lowering hiwat).

If you are running fine with hiwat lowered, that sounds like a decent
solution (and similiar to what other adapters do - don't allow the
queue depth * number of devices to execeed the capabilities of the
adapter).

-- Patrick Mansfield

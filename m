From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: QLA12160 ring buffer starvation? on 2.4.x
Date: Fri, 1 Nov 2002 09:04:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101090419.A635@eng2.beaverton.ibm.com>
References: <20021101.205009.783396609.nomura@hpc.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021101.205009.783396609.nomura@hpc.bs1.fc.nec.co.jp>; from j-nomura@ce.jp.nec.com on Fri, Nov 01, 2002 at 08:50:09PM +0900
List-Id: linux-scsi@vger.kernel.org
To: j-nomura@ce.jp.nec.com
Cc: linux-scsi@vger.kernel.org, jes@trained-monkey.org

On Fri, Nov 01, 2002 at 08:50:09PM +0900, j-nomura@ce.jp.nec.com wrote:
> Hello,
> 
> I'm using qla1280 driver 3.23 Beta with 2.4.19 kernel and have a trouble
> with it.
> 
> As the timed out command have stayed in qla1280 per-LUN queue more than
> 30 seconds while commands in other queues haven't, I suspect that current
> qla1280 driver has a structual problem which brings unfairness of command
> issuing. (as followings)
> 
> Do you have any idea?
> 
> I can workaround it by limitting ha->bus_settings[].hiwat to 16. 

> qla1280_next is executed either when the first command is queued by
> qla1280_queuecommand or when issued command completes in qla1280_done.
> qla1280_next works only for specified queue.
> 
> With these manner, if ha->bus_settings[].hiwat and ring size are similar
> value, the queue which has issued many commands has more chance to issue
> next commands than others do, doesn't it?
> 
> Best regards.
> --
> NOMURA, Jun'ichi <j-nomura@ce.jp.nec.com, nomura@hpc.bs1.fc.nec.co.jp>

Hi -

The mid-layer has a similiar algorithm, such that it should allow IO to
all devices, but not in a fair way.

But, there is a flaw in that it requeues IO for a finished command before
checking for the starved IO. This could explain your timeout.

I have not hit the problem or tried out this fix (other than compiling it).

Does this help any?

--- linux-2.4.19/drivers/scsi/scsi_lib.c-orig	Fri Aug  2 17:39:44 2002
+++ linux-2.4.19/drivers/scsi/scsi_lib.c	Fri Nov  1 07:59:44 2002
@@ -265,11 +265,6 @@
 		list_add(&SCpnt->request.queue, &q->queue_head);
 	}
 
-	/*
-	 * Just hit the requeue function for the queue.
-	 */
-	q->request_fn(q);
-
 	SDpnt = (Scsi_Device *) q->queuedata;
 	SHpnt = SDpnt->host;
 
@@ -328,6 +323,12 @@
 			SHpnt->some_device_starved = 0;
 		}
 	}
+
+	/*
+	 * Just hit the requeue function for the queue.
+	 */
+	q->request_fn(q);
+
 	spin_unlock_irqrestore(&io_request_lock, flags);
 }
 
-- Patrick Mansfield

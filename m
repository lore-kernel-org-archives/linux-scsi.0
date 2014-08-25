From: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Subject: Re: [RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter
 'unblock_io' to unblock IO's during disk addition
Date: Mon, 25 Aug 2014 13:35:46 -0600
Message-ID: <CAM+6EX3ZWkiPH-r7LB=TXN9LdOqXXbAX0GGPhqDqAuUNOwuWiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, martin.petersen@oracle.com
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, jejb@kernel.org, JBottomley@parallels.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Let me try to answer this as I had worked on this defect in the async release.

Martin> This really sounds like a scenario you should be able to handle in
Martin> general (without special "don't-be-broken" module parameters).

In the async release, we wanted this fix to be tried, tested and
vetted by customers, before making this as the default behaviour. We
wanted to make sure, this change doesn't cause any data corruption
inadvertently.

Martin> Also, shouldn't your internal task management be able to deal with this?
Martin> Why does the sdev's state during probe affect your ability to make
Martin> forward progress?

The FW informs the driver to add a new disk and we add that through
the SAS transport layer (through a workqueue). Before the SCSI mid
layer could finish the probe and add the disk at its layer, FW
identifies a link down and informs the driver (DELAY_NOT_RESPONDING).
As per the current design, the driver blocks any further I/O to that
disk. Now, the SCSI mid layer couldn't move forward with the addition
because it couldn't send down Report_Luns/TUR to the disk.

The FW in the meantime, would either sense the link up
(RC_PHY_CHANGED) or disk completely removed (TARGET_NOT_RESPONDING)
and send up the event to the driver. As per the current design, the
driver would push the processing of those events in the same workqueue
behind the new disk addition work (which is blocked). So, the disk
addition code waits for the unblock to happen, while the
RC_PHY_CHANGED work waits in the queue behind the disk addition for
its chance to unblock the disk. The fix is basically to perform the
unblock for RC_PHY_CHANGED in the interrupt context, so that the disk
addition work could proceed.

The FW has I/O missing delay timer & device missing delay timer. If we
don't block I/Os upon receiving DELAY_NOT_RESPONDING, there is
possibility of I/O missing delay timer expiring and SCSI mid layer
exhausting the no of retries leading to I/O failure which the
customers do not want to happen for the link down case.

Regards,
Praveen

From: j-nomura@ce.jp.nec.com
Subject: QLA12160 ring buffer starvation? on 2.4.x
Date: Fri, 01 Nov 2002 20:50:09 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101.205009.783396609.nomura@hpc.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jes@trained-monkey.org
Cc: j-nomura@ce.jp.nec.com

Hello,

I'm using qla1280 driver 3.23 Beta with 2.4.19 kernel and have a trouble
with it.

When I access multiple disks connected to a single SCSI card,
some of disks suffer QLA12160 ring buffer starvation.
It eventually cause SCSI timeout in middle layer (and panics).

As the timed out command have stayed in qla1280 per-LUN queue more than
30 seconds while commands in other queues haven't, I suspect that current
qla1280 driver has a structual problem which brings unfairness of command
issuing. (as followings)

Do you have any idea?

I can workaround it by limitting ha->bus_settings[].hiwat to 16. 


The command issuing process of qla1280 is:

1. scsi_dispatch_cmd puts commands into queue by qla1280_queuecommand().
2. Queued commands are issued to QLA12160 ring buffer by qla1280_next()
   until ring becomes full or outstanding command for the queue reaches
   maximum.
   The maximum number of outstanding commands per queue is determined
   by ha->bus_settings[].hiwat.
3. When ring buffer does not have enough room, commands are put again
   to the tail of queue by qla1280_putq_t().

qla1280_next is executed either when the first command is queued by
qla1280_queuecommand or when issued command completes in qla1280_done.
qla1280_next works only for specified queue.

With these manner, if ha->bus_settings[].hiwat and ring size are similar
value, the queue which has issued many commands has more chance to issue
next commands than others do, doesn't it?

Best regards.
--
NOMURA, Jun'ichi <j-nomura@ce.jp.nec.com, nomura@hpc.bs1.fc.nec.co.jp>
HPC Operating System Group, 1st Computers Software Division,
Computers Software Operations Unit, NEC Solutions.

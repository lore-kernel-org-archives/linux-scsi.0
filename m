From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Mon, 11 Nov 2013 17:31:14 -0800
Message-ID: <1384219874.12281.42.camel@haakon3.risingtidesystems.com>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>
	 <1384204653.12281.7.camel@haakon3.risingtidesystems.com>
	 <1384216960.12281.24.camel@haakon3.risingtidesystems.com>
	 <1384217317.12281.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384217317.12281.26.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Moussa Ba (moussaba)" <moussaba@micron.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-11-11 at 16:48 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2013-11-11 at 16:42 -0800, Nicholas A. Bellinger wrote:
> > On Mon, 2013-11-11 at 13:17 -0800, Nicholas A. Bellinger wrote:
> > > Hi Moussa & Co,
> > > 
> > > On Mon, 2013-11-11 at 19:05 +0000, Moussa Ba (moussaba) wrote:
> > > > My system setup is as follows:
> > > > 
> > > > Target: CentOS 6.4 - LIO Target running 3.12 kernel, 8 PCIe SSD in one volume group, 8 logical volumes, 8 targets, 1 LUN/target.
> > > > Initiator: CentOS 6.4 running 3.11 Kernel (Also ran 2.6.32-358), ISER based initiator over Mellanox 40Gbit ConnectX HCA
> > > > 
> > > > When running performance tests on the initiator, I am running into
> > > fio timeouts that lead to ABORT_TASK commands on the target.  In other
> > > words, fio fails to "reap" all the io threads almost as if it is
> > > waiting for lost IOs to complete. This is happening on random write IO
> > > operations.  Some context, we are generating about 576KIOPS 4KB block
> > > sizes using 8 LUNS.  The PCIe SSD have a write buffer that can absorb
> > > writes with an end to end latency on the initiator of 44us.  We are
> > > not currently seeing any errors on read IOs, which tend to have 2X+
> > > the latency of writes.  
> > > > 
> > > > See below for the dmesg on the target side.
> > > > Timeout Condition occurs at 154 which is the Protocol Error after fio is interrupted or runs to completion.  
> > > > [  154.453663] Received CmdSN: 0x000fcbb7 is greater than MaxCmdSN: 0x000fcbb6, protocol error.
> > > > [  154.453673] Received CmdSN: 0x000fcbb8 is greater than MaxCmdSN: 0x000fcbb6, protocol error.
> > > > 
> > > 
> > > (CC'ing Mike)
> > > 
> > > As mentioned off-list, this would tend to indicate some manner of
> > > open-iscsi bug, as it's never legal for an initiator to send a CmdSN
> > > greater than the MaxCmdSN that's currently being sent in target outgoing
> > > response PDUs.
> > > 
> > > Mike, any idea as to how this might be happening on the initiator
> > > side..?
> > > 
> > 

<SNIP>

Mmmmm, just noticed a bit of very suspicious logic in open-iscsi.
(CC'ing linux-scsi)

Namely, how drivers/scsi/libiscsi.c:iscsi_data_xmit() attempts to drain
conn->cmdqueue and hence call iscsi_prep_scsi_cmd_pdu() + increment
session->cmdsn, without ever checking to see if the CmdSN window may
have already closed..

The only CmdSN window check that I see in the I/O dispatch codepath is
in iscsi_queuecommand() -> iscsi_check_cmdsn_window_closed(), but once
iscsi_conn_queue_work() is invoked and process context in
iscsi_xmitworker() -> iscsi_data_xmit() starts to execute, there is
AFAICT no further CmdSN window open checks to ensure the initiator does
not overflow MaxCmdSN..

This would very much line up with the type of bug that is being
reported.  Before trying to determine what a possible fix might look
like, can you try the following libiscsi patch to see if your able to
hit either of the BUG's below..?

Thanks,

--nab

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..9106f63 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1483,6 +1483,12 @@ check_mgmt:
                        fail_scsi_task(conn->task, DID_IMM_RETRY);
                        continue;
                }
+
+               if (iscsi_check_cmdsn_window_closed(conn)) {
+                       printk("CmdSN window already closed in iscsi_data_xmit #1\n");
+                       BUG();
+               }
+
                rc = iscsi_prep_scsi_cmd_pdu(conn->task);
                if (rc) {
                        if (rc == -ENOMEM || rc == -EACCES) {
@@ -1518,6 +1524,11 @@ check_mgmt:
                if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
                        break;
 
+               if (iscsi_check_cmdsn_window_closed(conn)) {
+                       printk("CmdSN window already closed in iscsi_data_xmit #2\n");
+                       BUG();
+               }
+
                conn->task = task;
                list_del_init(&conn->task->running);
                conn->task->state = ISCSI_TASK_RUNNING;

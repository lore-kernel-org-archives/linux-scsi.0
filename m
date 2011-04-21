From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: deadlock during fc_remove_host
Date: Wed, 20 Apr 2011 17:24:36 -0700
Message-ID: <4DAF7944.6060909@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2236 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1DUAYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2011 20:24:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Joe Eykholt <jeykholt@cisco.com>

Hi,

We are seeing a similar issue to what Joe has observed a while back - 
http://www.mail-archive.com/devel@open-fcoe.org/msg02993.html.

This happens in a very corner case scenario by  creating and destroying 
fcoe interface in a tight loop. (fcoeadm -c followed by fcoeadm -d). The 
system had a simple configuration with  a single local port 2 remote ports.

Reason for the deadlock:

1. destroy (fcoeadm -d) thread hangs in fc_remove_host().
2. fc_remove_host() is trying to flush the shost->work_q, via 
scsi_flush_work(), but the operation never completes.
3. There are two works scheduled to be run in this work_q, one belonging 
to rport A, and other rport B.
4. The thread is currently executing rport_delete_work (fc_rport_final
_delete) for rport A.  It calls fc_terminate_rport_io() that unblocks 
the sdev->request_queue, so that __blk_run_queue() can be called. So, IO 
for rport A is ready to run, but stuck at the async layer.
5. Meanwhile, async layer is serializing all the IOs belonging to both 
rport A and rport B. At this point, it is waiting for IO belonging to 
rport B to complete.
6. However, the request_queue for rport B is stopped and 
fc_terminate_rport_io on rport B is not called yet to unblock the 
device, which will only be called after rport A completes. rport A does 
not complete as async layer is still stuck with IO belonging to rport B. 
Hence the deadlock.

The fact that async layer doesn't distinguish IOs belonging to different 
rports, it can process them in any order. If it happens to complete IOs 
belonging to rport A followed by rport B, then there is no problem. 
However, the other way causes the deadlock.

Experiment:

To verify the above, we tried to first call fc_terminate_rport_io for 
all the rports before actually queuing the rport_delete_work, so that 
the sdev->request_queue is unblocked for the all the rports, thus 
avoiding the deadlock.

One possible way of doing it is by having a separate work item that 
calls fc_terminate_rport_io:

diff --git a/drivers/scsi/scsi_transport_fc.c 
b/drivers/scsi/scsi_transport_fc.c
index 2941d2d..514fa2b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2405,6 +2405,9 @@ fc_remove_host(struct Scsi_Host *shost)
                 fc_queue_work(shost, &vport->vport_delete_work);

         /* Remove any remote ports */
+       list_for_each_entry_safe(rport, next_rport, &fc_host->rports, peers)
+               fc_queue_work(shost, &rport->rport_terminate_io_work);
+
         list_for_each_entry_safe(rport, next_rport,
                         &fc_host->rports, peers) {
                 list_del(&rport->peers);
@@ -2413,6 +2416,10 @@ fc_remove_host(struct Scsi_Host *shost)
         }

         list_for_each_entry_safe(rport, next_rport,
+                       &fc_host->rport_bindings, peers)
+               fc_queue_work(shost, &rport->rport_terminate_io_work);
+
+       list_for_each_entry_safe(rport, next_rport,
                         &fc_host->rport_bindings, peers) {
                 list_del(&rport->peers);
                 rport->port_state = FC_PORTSTATE_DELETED;
@@ -2457,6 +2464,16 @@ static void fc_terminate_rport_io(struct fc_rport 
*rport)
         scsi_target_unblock(&rport->dev);
  }

This may not be the ideal solution, but would like to discuss with folks 
here to converge to an appropriate solution.

Thanks,
Bhanu


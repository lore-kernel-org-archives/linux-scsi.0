From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: fc_remote_port_delete and returning SCSI commands from LLD
Date: Tue, 20 Oct 2009 16:40:27 +0200
Message-ID: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:63751 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZJTOkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2009 10:40:49 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n9KEecge778350
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 14:40:43 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9KEeSJL1708286
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 15:40:28 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9KEeR3f008431
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 15:40:28 +0100
Received: from schmichrtp.de.ibm.com (schmichrtp.mainz.de.ibm.com [9.155.42.186])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with SMTP id n9KEeRcZ008416
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 15:40:27 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am looking again at how and when a FC LLD should call
fc_remote_port_delete. Some help would be welcome to cover all
requirements and to plug the holes...

One scenario i am looking at: The connection to the HBA has been
temporarily lost and the LLD has to return all pending I/O requests to
the upper layers, so they can be retried later. Now with the SCSI
device being part of a multipath device, the first failed I/O request
triggers path failover:

multipath_end_io
do_end_io
fail_path
queue_work(kmultipathd, &pgpath->deactivate_path);

which then marks the following returned requests as timed out:

deactivate_path
blk_abort_queue
blk_abort_request
blk_rq_timed_out
scsi_times_out
fc_timed_out

If the remote_port status is not BLOCKED, this will trigger the SCSI
midlayer error handling which cannot do much during the interruption
to the hardware and will mark the SCSI devices 'offline'. In order to
prevent this, the rule would be: First call fc_remote_port_delete to
set the remote port (or in the case of an HBA interruption all remote
ports) to BLOCKED, and only after this step call scsi_done to pass the
SCSI commands back to the upper layers.

This means, if the HBA problem is detected in interrupt context,
fc_remote_port_delete has to be called before calling scsi_done.

But the description for fc_remote_port_delete states:

 * Called from normal process context only - cannot be called from
 * interrupt.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */

Looking at the functions called from fc_remote_port_delete, i don't
see a problem in calling fc_remote_port_delete from interrupt context
or with locks held. Does this mean the description should be fixed or
am i missing something?

fc_remote_port_add on the other hand can wait during flushes and has
to be called from process context. To summarize:
- A LLD has to call fc_remote_port_delete before returning SCSI
  commands from a failed port or failed HBA.
- fc_remote_port_delete can be called from interrupt context before
  calling scsi_done if necessary
- fc_remote_port_add has to be called from process context
- The LLD has to serialize the fc_remote_port_add and
  fc_remote_port_delete calls to guarantee the add->delete->...
  sequence.

--
Christof

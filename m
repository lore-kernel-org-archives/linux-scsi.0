From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Race in scsi_unjam_host in 2.4?
Date: Tue, 21 Dec 2004 14:01:51 +0100
Message-ID: <OF5918771E.E5771C1E-ONC1256F71.00473AEE-C1256F71.00478BAB@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59877 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S261745AbULUNBa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2004 08:01:30 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id iBLD1Tdt134204
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 13:01:29 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBLD2C4C153816
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 14:02:12 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id iBLD1Sp7018211
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 14:01:28 +0100
Received: from d12ml065.megacenter.de.ibm.com (d12ml065.megacenter.de.ibm.com [9.149.167.11])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id iBLD1Sdw018206
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 14:01:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org





During tests (heavy load and with error injection) with a 2.4 kernel
on s390x with a FAStT an I/O-stall occured.

In /var/log/messages we have:

Nov 27 09:18:22 boeblinlp11 kernel: Missing scsi error handler thread

In the memory dump of the system I found that there is one scsi
command with attributes:
      cmnd->request.rq_status = RQ_SCSI_DONE,
      cmnd->owner = SCSI_OWNER_ERROR_HANDLER,
      cmnd->state = SCSI_STATE_BHQUEUE,
      cmnd->eh_state = SCSI_STATE_TIMEOUT,
      cmnd->done_late = 1,
      cmnd->bh_next = NULL

Furthermore the host has following attributes:
      cmnd->host->host_busy = 6,
      cmnd->host_active = 6,
      cmnd->host->host_failed = 5,
      cmnd->host->in_recovery = 1

All other commands were timed out (they have
eh_state = FAILED, state = SCSI_STATE_TIMEOUT,
owner = SCSI_OWNER_ERROR_HANDLER).

This means the host does not accept new requests because it is
"in recovery".
And the scsi error handler (which is currently in down_interruptible)
is never triggered again.

AFAIK the whole situation must be caused by a race in scsi_unjam_host().

scsi_unjam_host() /* after "leave:" label */

      SCpnt->bh_next = NULL;
      ...
      scsi_add_timer(SCpnt, 100, scsi_eh_times_out);
      scsi_done(SCpnt);

scsi_done()
      if (!scsi_delete_timer(SCpnt)) {
            SCpnt->done_late = 1;
            return;
      }

I suggest to increase the timeout value for the timer to 6000:

      scsi_add_timer(SCpnt, 6000, scsi_eh_times_out);
      scsi_done(SCpnt);

This is not the real bug fix, it just makes the occurence of that
race more impropable.

Any suggestion for another fix of the problem?

BTW, am I right with the assumption, that the one command having
state=SCSI_STATE_BHQUEUE won't never be processed again in
scsi_unjam_host?


Regards,

Andreas


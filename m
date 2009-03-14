From: "Ying Chu" <jasonchu@marvell.com>
Subject: libsas error-handling completion issue.
Date: Fri, 13 Mar 2009 23:44:29 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0687BCA0@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:13363 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752119AbZCNGpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Mar 2009 02:45:30 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, jeff@garzik.org, Tejun Heo <tj@kernel.org>

  
   As sas_eh_finish_cmd() routine is used when a sas task is marked
succfully recovered(or the device is marked OFFLINE), then the
corresponding task_done will be invoked after SAS_TASK_STATE_ABORTED is
unmasked. Whatever sas_scsi_task_done() or sas_ata_task_done() got
invoked, it will translate task_status to scsi_cmnd->request, free the
sas_task structure and invoke task_done, the problem is, after
task_done(), scsi_eh_finish_cmd() will still add the cmd to
sas_ha->eh_done_q, and in the coming scsi_eh_flush_done_q(), it will
retry the command or invoke scsi_finish_command() to finish the request
again.  

   Take a timeout SSP request in the race condition for example, if the
request is returned prior to lldd_abort_task() and set
SAS_TASK_STATE_DONE, the lldd_abort_task() handler will do nothing but
return TASK_IS_DONE in sas_scsi_find_task(), later sas_eh_finished_cmd()
will get invoked and unset SAS_TASK_STATE_ABORTED mask to let
sas_scsi_task_done() in, since it's a good response and the request will
be finished succfully.But current strategy will
add the scsi_cmnd to sas_ha->eh_done_q after task_done() is performed.
Then if possibe, we may scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY)
in scsi_eh_flush_done_q(). I meet the condition and sometime the system
hangs.

   Did I miss something?
--
Regards,
Ying Chu

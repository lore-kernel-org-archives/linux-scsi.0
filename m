From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: libsas error-handling completion issue.
Date: Sat, 14 Mar 2009 12:19:05 -0500
Message-ID: <1237051145.3907.43.camel@localhost.localdomain>
References: <FE3F06125A99254E8D92161AA4569C6F0687BCA0@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49315 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbZCNRTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 13:19:11 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F0687BCA0@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, Tejun Heo <tj@kernel.org>

On Fri, 2009-03-13 at 23:44 -0700, Ying Chu wrote:
> As sas_eh_finish_cmd() routine is used when a sas task is marked
> succfully recovered(or the device is marked OFFLINE), then the
> corresponding task_done will be invoked after SAS_TASK_STATE_ABORTED is
> unmasked. Whatever sas_scsi_task_done() or sas_ata_task_done() got
> invoked, it will translate task_status to scsi_cmnd->request, free the
> sas_task structure and invoke task_done, the problem is, after
> task_done(), scsi_eh_finish_cmd() will still add the cmd to
> sas_ha->eh_done_q, and in the coming scsi_eh_flush_done_q(), it will
> retry the command or invoke scsi_finish_command() to finish the request
> again.  

OK, so the immediate answer is that the eh_done_q is processed in the
strategy handler, in this case by sas_eh_handle_sas_errors() which skips
over any commands without sas tasks in the list.

>    Take a timeout SSP request in the race condition for example, if the
> request is returned prior to lldd_abort_task() and set
> SAS_TASK_STATE_DONE, the lldd_abort_task() handler will do nothing but
> return TASK_IS_DONE in sas_scsi_find_task(), later sas_eh_finished_cmd()
> will get invoked and unset SAS_TASK_STATE_ABORTED mask to let
> sas_scsi_task_done() in, since it's a good response and the request will
> be finished succfully.But current strategy will
> add the scsi_cmnd to sas_ha->eh_done_q after task_done() is performed.
> Then if possibe, we may scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY)
> in scsi_eh_flush_done_q(). I meet the condition and sometime the system
> hangs.
> 
>    Did I miss something?

I'm not sure, since I didn't quite understand the problem.

So, let me explain how the SAS_TASK_STATE_ABORTED works.  It's actually
the mediating flag in how completions are handled.  There are two ways
through ->task_done() depending on the state of this flag.  If this flag
is set, it means that libsas owns the task and ->task_done() may not
free it.  Conversely if the timeout fires it checks the flags and if
SAS_TASK_STATE_DONE is set, it returns BLK_EH_HANDLED because presumably
the mid-layer will soon see it.

The apparent race between these flags is mediated using the
task_state_lock.  When looking to test and set these flags, you must be
holding this lock.

The first case is in sas_scsi_host.c:sas_scsi_timed_out() where it takes
the lock, checks for done and only sets STATE_ABORTED if STATE_DONE
wasn't set.

The other, nastily, is in the driver (which is responsible for setting
STATE_DONE).  I've never liked this bit because it's complex and easy to
get wrong.  However, if you look at
aic94xx_task.c:asd_task_tasklet_complete() you see the big chunk of code
where it takes the lock, sets STATE_DONE, checks STATE_ABORTED and
doesn't call ->task_done() if this is set.

As far as I can tell, the locking around all of this, while nasty to the
user, is raceproof as long as the LLD gets it right.

James



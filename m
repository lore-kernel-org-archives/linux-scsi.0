From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: libsas error-handling completion issue.
Date: Sun, 15 Mar 2009 09:14:31 -0500
Message-ID: <1237126471.4376.10.camel@localhost.localdomain>
References: <FE3F06125A99254E8D92161AA4569C6F0687BCA0@sc-exch02.marvell.com>
	 <1237051145.3907.43.camel@localhost.localdomain>
	 <FE3F06125A99254E8D92161AA4569C6F0687BD47@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44452 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZCOOOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Mar 2009 10:14:36 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F0687BD47@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, Tejun Heo <tj@kernel.org>

On Sat, 2009-03-14 at 21:02 -0700, Ying Chu wrote:
> >So, let me explain how the SAS_TASK_STATE_ABORTED works.  It's actually the mediating flag in how completions are handled.  There are two ways through ->task_done() depending on the state of this flag.  If this flag is set, it means
> > that libsas owns the task and ->task_done() may not free it.  Conversely if the timeout fires it checks the flags and if SAS_TASK_STATE_DONE is set, it returns BLK_EH_HANDLED because presumably the mid-layer will soon see it.
> 
> What I meant is the corner case where interrupt is fired and the
> sas_task returned back at the monment but before sas_scsi_find_task()
> got invoked and set SAS_TASK_STATE_DONE flag. As in
> asd_task_tasklet_complete() routine, it will check if the
> STATE_ABORTED is set, if so, it doesn't invoke task_done() routine.
> Still returned to the strategy handler, sas_scsi_find_task() will try
> to abort the task and find it has been finished with STATE_DONE set,
> so it return TASK_IS_DONE and call sas_eh_finish_cmd(), where it unset
> the TASK_ABORTED flag and call task_done(). Noticed that in
> sas_eh_finish_cmd(), we call scsi_eh_finish_cmd() which will add the
> cmd to sas_ha->eh_done(), and in the coming flush_done_q it will be
> retried or finished again.

I'm still not quite seeing what you think the problem is. Is it that
task_done() calls scsi_cmnd->scsi_done(), in which case you think
there's a double completion?  That's fixed in the block layer:
scsi_done() is blk_complete_request() which does nothing if the request
has a completion set and the block layer sets the completion when the
timeout fires.

James




James



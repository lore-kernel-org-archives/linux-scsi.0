From: "Ying Chu" <jasonchu@marvell.com>
Subject: RE: libsas error-handling completion issue.
Date: Sat, 14 Mar 2009 21:02:02 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0687BD47@sc-exch02.marvell.com>
References: <FE3F06125A99254E8D92161AA4569C6F0687BCA0@sc-exch02.marvell.com> <1237051145.3907.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:37016 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbZCOEJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2009 00:09:59 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1237051145.3907.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, Tejun Heo <tj@kernel.org>

>So, let me explain how the SAS_TASK_STATE_ABORTED works.  It's actuall=
y the mediating flag in how completions are handled.  There are two way=
s through ->task_done() depending on the state of this flag.  If this f=
lag is set, it means
> that libsas owns the task and ->task_done() may not free it.  Convers=
ely if the timeout fires it checks the flags and if SAS_TASK_STATE_DONE=
 is set, it returns BLK_EH_HANDLED because presumably the mid-layer wil=
l soon see it.

What I meant is the corner case where interrupt is fired and the sas_ta=
sk returned back at the monment but before sas_scsi_find_task() got inv=
oked and set SAS_TASK_STATE_DONE flag. As in asd_task_tasklet_complete(=
) routine, it will check if the STATE_ABORTED is set, if so, it doesn't=
 invoke task_done() routine. Still returned to the strategy handler, sa=
s_scsi_find_task() will try to abort the task and find it has been fini=
shed with STATE_DONE set, so it return TASK_IS_DONE and call sas_eh_fin=
ish_cmd(), where it unset the TASK_ABORTED flag and call task_done(). N=
oticed that in sas_eh_finish_cmd(), we call scsi_eh_finish_cmd() which =
will add the cmd to sas_ha->eh_done(), and in the coming flush_done_q i=
t will be retried or finished again.


-----Original Message-----
=46rom: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]=20
Sent: 2009=C4=EA3=D4=C215=C8=D5 1:19
To: Ying Chu
Cc: linux-scsi@vger.kernel.org; jeff@garzik.org; Tejun Heo
Subject: Re: libsas error-handling completion issue.

On Fri, 2009-03-13 at 23:44 -0700, Ying Chu wrote:
> As sas_eh_finish_cmd() routine is used when a sas task is marked=20
> succfully recovered(or the device is marked OFFLINE), then the=20
> corresponding task_done will be invoked after SAS_TASK_STATE_ABORTED=20
> is unmasked. Whatever sas_scsi_task_done() or sas_ata_task_done() got=
=20
> invoked, it will translate task_status to scsi_cmnd->result, free the=
=20
> sas_task structure and invoke task_done, the problem is, after=20
> task_done(), scsi_eh_finish_cmd() will still add the cmd to=20
> sas_ha->eh_done_q, and in the coming scsi_eh_flush_done_q(), it will=20
> retry the command or invoke scsi_finish_command() to finish the=20
> request again.

OK, so the immediate answer is that the eh_done_q is processed in the s=
trategy handler, in this case by sas_eh_handle_sas_errors() which skips=
 over any commands without sas tasks in the list.

>    Take a timeout SSP request in the race condition for example, if=20
> the request is returned prior to lldd_abort_task() and set=20
> SAS_TASK_STATE_DONE, the lldd_abort_task() handler will do nothing bu=
t=20
> return TASK_IS_DONE in sas_scsi_find_task(), later=20
> sas_eh_finished_cmd() will get invoked and unset=20
> SAS_TASK_STATE_ABORTED mask to let
> sas_scsi_task_done() in, since it's a good response and the request=20
> will be finished succfully.But current strategy will add the scsi_cmn=
d=20
> to sas_ha->eh_done_q after task_done() is performed.
> Then if possibe, we may scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY=
)=20
> in scsi_eh_flush_done_q(). I meet the condition and sometime the=20
> system hangs.
>=20
>    Did I miss something?

I'm not sure, since I didn't quite understand the problem.

So, let me explain how the SAS_TASK_STATE_ABORTED works.  It's actually=
 the mediating flag in how completions are handled.  There are two ways=
 through ->task_done() depending on the state of this flag.  If this fl=
ag is set, it means that libsas owns the task and ->task_done() may not=
 free it.  Conversely if the timeout fires it checks the flags and if S=
AS_TASK_STATE_DONE is set, it returns BLK_EH_HANDLED because presumably=
 the mid-layer will soon see it.

The apparent race between these flags is mediated using the task_state_=
lock.  When looking to test and set these flags, you must be holding th=
is lock.

The first case is in sas_scsi_host.c:sas_scsi_timed_out() where it take=
s the lock, checks for done and only sets STATE_ABORTED if STATE_DONE w=
asn't set.

The other, nastily, is in the driver (which is responsible for setting =
STATE_DONE).  I've never liked this bit because it's complex and easy t=
o get wrong.  However, if you look at
aic94xx_task.c:asd_task_tasklet_complete() you see the big chunk of cod=
e where it takes the lock, sets STATE_DONE, checks STATE_ABORTED and do=
esn't call ->task_done() if this is set.

As far as I can tell, the locking around all of this, while nasty to th=
e user, is raceproof as long as the LLD gets it right.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

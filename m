From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 10/12] scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
Date: Sun, 22 Apr 2012 08:24:43 -0700
Message-ID: <CABE8wwvJgS9iGchsOLzrJ7b5+coLoU9mof7m3oVSBM8Ae0-y=g@mail.gmail.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	<20120413233742.8025.99073.stgit@dwillia2-linux.jf.intel.com>
	<1335010949.3081.8.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1335010949.3081.8.camel@dabdike.lan>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Tom Jackson <thomas.p.jackson@intel.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Apr 21, 2012 at 5:22 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
>> Rapid ata hotplug on a libsas controller results in cases where libs=
as
>> is waiting indefinitely on eh to perform an ata probe.
>>
>> A race exists between scsi_schedule_eh() and scsi_restart_operations=
()
>> in the case when scsi_restart_operations() issues i/o to other devic=
es
>> in the sas domain. =A0When this happens the host state transitions f=
rom
>> SHOST_RECOVERY (set by scsi_schedule_eh) back to SHOST_RUNNING and
>> ->host_busy is non-zero so we put the eh thread to sleep even though
>> ->host_eh_scheduled is active.
>>
>> Before putting the error handler to sleep we need to check if the
>> host_state needs to return to SHOST_RECOVERY for another trip throug=
h
>> eh.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
>> Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0drivers/scsi/scsi_error.c | =A0 14 ++++++++++++++
>> =A01 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 2cfcbff..0945d47 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1687,6 +1687,20 @@ static void scsi_restart_operations(struct Sc=
si_Host *shost)
>> =A0 =A0 =A0 =A0* requests are started.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 scsi_run_host_queues(shost);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* if eh is active and host_eh_scheduled is pending we n=
eed to re-run
>> + =A0 =A0 =A0* recovery. =A0we do this check after scsi_run_host_que=
ues() to allow
>> + =A0 =A0 =A0* everything pent up since the last eh run a chance to =
make forward
>> + =A0 =A0 =A0* progress before we sync again. =A0Either we'll immedi=
ately re-run
>> + =A0 =A0 =A0* recovery or scsi_device_unbusy() will wake us again w=
hen these
>> + =A0 =A0 =A0* pending commands complete.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 spin_lock_irqsave(shost->host_lock, flags);
>> + =A0 =A0 if (shost->host_eh_scheduled)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (scsi_host_set_state(shost, SHOST_RECOV=
ERY))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(scsi_host_set_stat=
e(shost, SHOST_CANCEL_RECOVERY));
>> + =A0 =A0 spin_unlock_irqrestore(shost->host_lock, flags);
>
> This doesn't really look to be the way to fix the race, because we'll
> start up the host again before closing it down.

That's part of the intent.  Any command that has been waiting to be
restarted has been potentially waiting up to a minute for recovery to
complete, so the idea is that we trickle the blocked commands through
and then come back for another pass.  This is close to what "late"
callers sto csi_schedule_eh() experience anyways.

> Isn't the correct way to put
>
> if (shost->host_eh_scheduled)
> =A0 =A0 =A0 =A0continue;
>
> into the scsi_error_handler() loop just *before*
> scsi_restart_operations()?

I think that only narrows the window...  The hole is
scsi_schedule_eh() called anytime after the last run completes and
before the change of the host state, so host_eh_scheduled can go
active immediately after that check right?

We could move the check into scsi_restart_operations() under the lock
before we change the state back to running, but I figure if we got
that far just let the queue run again.

--
Dan

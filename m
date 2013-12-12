From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] iscsi_target: race condition on shutdown
Date: Thu, 12 Dec 2013 08:18:42 +0100
Message-ID: <52A96352.3050107@suse.de>
References: <1386251665-39173-1-git-send-email-hare@suse.de> <1386805475.20247.109.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386805475.20247.109.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/12/2013 12:44 AM, Nicholas A. Bellinger wrote:
> Hi Hannes,
>=20
> Btw, apologies for the delayed response on this..  Comments are below=
=2E
>=20
> On Thu, 2013-12-05 at 14:54 +0100, Hannes Reinecke wrote:
>> When shutting down a target there is a race condition between
>> iscsit_del_np() and __iscsi_target_login_thread().
>> The latter sets the thread pointer to NULL, and the former
>> tries to issue kthread_stop() on that pointer without any
>> synchronization.
>>
>> This patchs adds proper synchronization pointer between those
>> calls to ensure that a) the thread is correctly terminate and
>> b) kthread_stop() isn't called with a NULL pointer.
>>
>> In the long run iscsi_target_login_thread() should be converted
>> into a workqueue.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/iscsi/iscsi_target.c       | 12 +++++++++---
>>  drivers/target/iscsi/iscsi_target_login.c |  9 ++++++---
>>  2 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/is=
csi/iscsi_target.c
>> index bf76fc4..c7bf3c9 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -457,15 +457,21 @@ int iscsit_del_np(struct iscsi_np *np)
>>  	}
>>  	np->np_thread_state =3D ISCSI_NP_THREAD_SHUTDOWN;
>>  	spin_unlock_bh(&np->np_thread_lock);
>> -
>> -	if (np->np_thread) {
>> +	/* Give __iscsi_target_login_thread() a chance to run */
>> +	schedule();
>> +	spin_lock_bh(&np->np_thread_lock);
>> +	if ((np->np_thread_state =3D=3D ISCSI_NP_THREAD_SHUTDOWN)
>> +	    && np->np_thread) {
>> +		np->np_thread_state =3D ISCSI_NP_THREAD_EXIT;
>> +		spin_unlock_bh(&np->np_thread_lock);
>>  		/*
>>  		 * We need to send the signal to wakeup Linux/Net
>>  		 * which may be sleeping in sock_accept()..
>>  		 */
>>  		send_sig(SIGINT, np->np_thread, 1);
>>  		kthread_stop(np->np_thread);
>> -	}
>> +	} else
>> +		spin_unlock_bh(&np->np_thread_lock);
>> =20
>>  	np->np_transport->iscsit_free_np(np);
>> =20
>> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/tar=
get/iscsi/iscsi_target_login.c
>> index 4eb93b2..b375d26 100644
>> --- a/drivers/target/iscsi/iscsi_target_login.c
>> +++ b/drivers/target/iscsi/iscsi_target_login.c
>> @@ -1405,7 +1405,8 @@ out:
>>  	stop =3D kthread_should_stop();
>>  	if (!stop && signal_pending(current)) {
>>  		spin_lock_bh(&np->np_thread_lock);
>> -		stop =3D (np->np_thread_state =3D=3D ISCSI_NP_THREAD_SHUTDOWN);
>> +		stop =3D (np->np_thread_state =3D=3D ISCSI_NP_THREAD_SHUTDOWN ||
>> +			np->np_thread_state =3D=3D ISCSI_NP_THREAD_EXIT);
>>  		spin_unlock_bh(&np->np_thread_lock);
>>  	}
>>  	/* Wait for another socket.. */
>> @@ -1414,8 +1415,10 @@ out:
>>  exit:
>>  	iscsi_stop_login_thread_timer(np);
>>  	spin_lock_bh(&np->np_thread_lock);
>> -	np->np_thread_state =3D ISCSI_NP_THREAD_EXIT;
>> -	np->np_thread =3D NULL;
>> +	if (np->np_thread_state !=3D ISCSI_NP_THREAD_EXIT) {
>> +		np->np_thread_state =3D ISCSI_NP_THREAD_EXIT;
>> +		np->np_thread =3D NULL;
>> +	}
>>  	spin_unlock_bh(&np->np_thread_lock);
>> =20
>>  	return 0;
>=20
> I'm not sure this extra logic is necessary.  How about just clearing
> np->np_thread in iscsit_del_np instead..?
>=20
> Care to verify on your side with the following patch..?
>=20
> --nab
>=20
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/isc=
si/iscsi_target.c
> index 02182ab..0086719 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -465,6 +465,7 @@ int iscsit_del_np(struct iscsi_np *np)
>                  */
>                 send_sig(SIGINT, np->np_thread, 1);
>                 kthread_stop(np->np_thread);
> +               np->np_thread =3D NULL;
>         }
> =20
>         np->np_transport->iscsit_free_np(np);
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/targ=
et/iscsi/iscsi_target_login.c
> index 4eb93b2..6ab43b6 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1415,7 +1415,6 @@ exit:
>         iscsi_stop_login_thread_timer(np);
>         spin_lock_bh(&np->np_thread_lock);
>         np->np_thread_state =3D ISCSI_NP_THREAD_EXIT;
> -       np->np_thread =3D NULL;
>         spin_unlock_bh(&np->np_thread_lock);
> =20
>         return 0;
>=20
>=20
The problem here is that 'kthread_stop()' is supposed to be called
with a _valid_ task structure.

There is this race window:

	np->np_thread_state =3D ISCSI_NP_THREAD_SHUTDOWN;
	spin_unlock_bh(&np->np_thread_lock);
here ->
	if (np->np_thread) {
		/*

If the login thread exits before we evaluate 'np->np_thread'
the pointer is stale and kthread_stop will be called with
an invalid task structure.

So at the very least we need to check the thread_state before
evaluating 'np->np_thread' (which will evaluate to 'true' anyway if
we were to follow up with your patch).
But in doing so we would need to protect is by the thread_lock
to synchronize the state.
And we'll end up with quite the same patch as I've send originally.

In fact, it was an invalid call to kthread_stop() which triggered
the whole patch in the first place :-)

I would love to be proven wrong, as I'm not keen on the 'schedule()'
in there. But I fail to see another way out here, short of
converting the entire kthread into a workqueue item ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)

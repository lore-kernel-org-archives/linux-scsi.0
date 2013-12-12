From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] iscsi_target: race condition on shutdown
Date: Thu, 12 Dec 2013 09:05:35 +0100
Message-ID: <52A96E4F.2070406@suse.de>
References: <1386251665-39173-1-git-send-email-hare@suse.de>	 <1386805475.20247.109.camel@haakon3.risingtidesystems.com>	 <52A96352.3050107@suse.de> <1386834852.20247.121.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386834852.20247.121.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/12/2013 08:54 AM, Nicholas A. Bellinger wrote:
> On Thu, 2013-12-12 at 08:18 +0100, Hannes Reinecke wrote:
[ .. ]
>> The problem here is that 'kthread_stop()' is supposed to be called
>> with a _valid_ task structure.
>>
>> There is this race window:
>>
>> 	np->np_thread_state =3D ISCSI_NP_THREAD_SHUTDOWN;
>> 	spin_unlock_bh(&np->np_thread_lock);
>> here ->
>> 	if (np->np_thread) {
>> 		/*
>>
>> If the login thread exits before we evaluate 'np->np_thread'
>> the pointer is stale and kthread_stop will be called with
>> an invalid task structure.
>>
>> So at the very least we need to check the thread_state before
>> evaluating 'np->np_thread' (which will evaluate to 'true' anyway if
>> we were to follow up with your patch).
>> But in doing so we would need to protect is by the thread_lock
>> to synchronize the state.
>> And we'll end up with quite the same patch as I've send originally.
>>
>> In fact, it was an invalid call to kthread_stop() which triggered
>> the whole patch in the first place :-)
>>
>=20
> Mmmm, point taken..
>=20
>> I would love to be proven wrong, as I'm not keen on the 'schedule()'
>> in there. But I fail to see another way out here, short of
>> converting the entire kthread into a workqueue item ...
>=20
> Thinking about this a bit more, I think the pre-kthread API
> np_thead_state check to exit at the out: label in
> __iscsi_target_login_thread() is the culprit..
>=20
> How about following to only exit when iscsit_del_np() -> kthread_stop=
()
> has been called, and kthread_should_stop() is true..?
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
> index 4eb93b2..e29279e 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1403,11 +1403,6 @@ old_sess_out:
> =20
>  out:
>         stop =3D kthread_should_stop();
> -       if (!stop && signal_pending(current)) {
> -               spin_lock_bh(&np->np_thread_lock);
> -               stop =3D (np->np_thread_state =3D=3D ISCSI_NP_THREAD_=
SHUTDOWN);
> -               spin_unlock_bh(&np->np_thread_lock);
> -       }
>         /* Wait for another socket.. */
>         if (!stop)
>                 return 1;
> @@ -1415,7 +1410,6 @@ exit:
>         iscsi_stop_login_thread_timer(np);
>         spin_lock_bh(&np->np_thread_lock);
>         np->np_thread_state =3D ISCSI_NP_THREAD_EXIT;
> -       np->np_thread =3D NULL;
>         spin_unlock_bh(&np->np_thread_lock);
> =20
>         return 0;
>=20
>=20
Yes. Far better.

I'll give it a spin.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)

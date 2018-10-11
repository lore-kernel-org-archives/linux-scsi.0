From: "Ly, Bryant" <bly@catalogicsoftware.com>
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with
 active signals
Date: Thu, 11 Oct 2018 13:05:59 +0000
Message-ID: <F43269BA-4D7B-486C-87C6-0FB48FF890EA@catalogicsoftware.com>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
 <5BBE2FBF.7080804@redhat.com>
 <1539237365.6150.32.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539237365.6150.32.camel@haakon3.daterainc.com>
Content-Language: en-US
Content-ID: <7D799E9702521C439DB90D96510B7D4D@prod.exchangelabs.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org



> On Oct 11, 2018, at 12:56 AM, Nicholas A. Bellinger <nab@linux-iscsi.org>=
 wrote:
>=20
> Hello MNC & Co,
>=20
> On Wed, 2018-10-10 at 11:58 -0500, Mike Christie wrote:
>> On 10/09/2018 10:23 PM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>=20
>>> With the addition of commit 00d909a107 in v4.19-rc, it incorrectly assu=
mes no
>>> signals will be pending for task_struct executing the normal session sh=
utdown
>>> and I/O quiesce code-path.
>>>=20
>=20
> <SNIP>
>=20
>>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/ta=
rget_core_transport.c
>>> index 86c0156..fc3093d2 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -2754,7 +2754,7 @@ static void target_release_cmd_kref(struct kref *=
kref)
>>> =09if (se_sess) {
>>> =09=09spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>>> =09=09list_del_init(&se_cmd->se_cmd_list);
>>> -=09=09if (list_empty(&se_sess->sess_cmd_list))
>>> +=09=09if (se_sess->sess_tearing_down && list_empty(&se_sess->sess_cmd_=
list))
>>=20
>> I think there is another issue with 00d909a107 and ibmvscsi_tgt.
>>=20
>> The problem is that ibmvscsi_tgt never called
>> target_sess_cmd_list_set_waiting. It only called
>> target_wait_for_sess_cmds. So before 00d909a107 there was a bug in that
>> driver and target_wait_for_sess_cmds never did what was intended because
>> sess_wait_list would always be empty.
>>=20
>> With 00d909a107, we no longer need to call
>> target_sess_cmd_list_set_waiting to wait for outstanding commands, so
>> for ibmvscsi_tgt will now wait for commands like we wanted. However, the
>> commit added a WARN_ON that is hit if target_sess_cmd_list_set_waiting
>> is not called, so we could hit that.
>>=20
>> So I think we need to add a target_sess_cmd_list_set_waiting call in
>> ibmvscsi_tgt to go along with your patch chunk above and make sure we do
>> not trigger the WARN_ON.
>>=20
>=20
> Nice catch.  :)
>=20
> With target_wait_for_sess_cmd() usage pre 00d909a107 doing a list-splice
> in target_sess_cmd_list_set_waiting(), this particular usage in
> ibmvscsi_tgt has always been list_empty(&sess->sess_wait_list) =3D true
> (eg: no se_cmd I/O is quiesced, because no se_cmd in sess_wait_list)
> since commit 712db3eb in 4.9.y code.
>=20
> That said, ibmvscsi_tgt usage is very similar to vhost/scsi in the
> respect individual /sys/kernel/config/target/$FABRIC/$WWN/$TPGT/
> endpoints used by VMs do not remove their I_T nexus while the VM is
> active.
>=20
> So AFAICT, ibmvscsi_tgt doesn't strictly need target_sess_wait_for_cmd()
> at all if this is true.
>=20

VMs do not remove the I_T nexus while the VM is active, so we can remove
the target_wait_for_sess_cmd() call.=20

-Bryant

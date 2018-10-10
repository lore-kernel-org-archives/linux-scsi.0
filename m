From: "Ly, Bryant" <bly@catalogicsoftware.com>
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with
 active signals
Date: Wed, 10 Oct 2018 04:01:17 +0000
Message-ID: <A95B1AA1-D330-43E6-8F80-71582B9365D8@catalogicsoftware.com>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Content-ID: <16B5F183E7182944B5C30EBB0DEE26A6@prod.exchangelabs.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org



> On Oct 9, 2018, at 10:23 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> =
wrote:
>=20
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> With the addition of commit 00d909a107 in v4.19-rc, it incorrectly assume=
s no
> signals will be pending for task_struct executing the normal session shut=
down
> and I/O quiesce code-path.
>=20
> For example, iscsi-target and iser-target issue SIGINT to all kthreads as
> part of session shutdown.  This has been the behaviour since day one.
>=20
> As-is when signals are pending with se_cmds active in se_sess->sess_cmd_l=
ist,
> wait_event_interruptible_lock_irq_timeout() returns a negative number and
> immediately kills the machine because of the do while (ret <=3D 0) loop t=
hat
> was added in commit 00d909a107 to spin while backend I/O is taking any
> amount of extended time (say 30 seconds) to complete.
>=20
> Here's what it looks like in action with debug plus delayed backend I/O
> completion:
>=20
> [ 4951.909951] se_sess: 000000003e7e08fa before target_wait_for_sess_cmds
> [ 4951.914600] target_wait_for_sess_cmds: signal_pending: 1
> [ 4951.918015] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 0
> [ 4951.921639] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 1
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 2
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 3
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 4
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 5
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 6
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 7
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 8
> [ 4951.921944] wait_event_interruptible_lock_irq_timeout ret: -512 signal=
_pending: 1 loop count: 9
>=20
> ... followed by the usual RCU CPU stalls and deadlock.
>=20
> There was never a case pre commit 00d909a107 where wait_for_complete(&se_=
cmd->cmd_wait_comp)
> was able to be interruptted, so to address this for v4.19+ moving forward=
 go ahead and
> use wait_event_lock_irq_timeout() instead so new code works with all fabr=
ic drivers.
>=20
> Also for commit 00d909a107, fix a minor regression in target_release_cmd_=
kref()
> to only wake_up the new se_sess->cmd_list_wq only when shutdown has actua=
lly
> been triggered via se_sess->sess_tearing_down.
>=20
> Fixes: 00d909a107 ("scsi: target: Make the session shutdown code also wai=
t for commands that are being aborted")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Tested-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
> drivers/target/target_core_transport.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>

-Bryant

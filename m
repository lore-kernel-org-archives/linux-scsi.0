From: Alan Adamson <alan.adamson-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libiscsi: add lock around task lists to fix list
 corruption regression
Date: Tue, 18 Dec 2018 13:07:48 -0800
Message-ID: <c34da9f0-cb58-3c0b-3258-c909fcb10c91@oracle.com>
References: <20170221173536.32024-1-cleech@redhat.com>
 <250619225.63072551.1487888748696.JavaMail.zimbra@redhat.com>
 <CAKYn0tiyWNEjFZHaPDHNjam5=3WCR_V2svNiJmvWeYhpv3=8Ag@mail.gmail.com>
 <CAKYn0tjF46gxwj3MtjLL_ic+veXjTZ9n_BGKjz6-fW+Cse2w9w@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBAABBWUISHQQKGQERHR4AMA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CAKYn0tjF46gxwj3MtjLL_ic+veXjTZ9n_BGKjz6-fW+Cse2w9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Ilkka Sovanto <ilkka-/1wQRMveznE@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, martin petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, "Guilherme G. Piccoli" <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Was this issue ever resolved?=C2=A0 We are seeing this on 4.14.35.

Thanks,

Alan Adamson

On 5/9/18 3:27 PM, Ilkka Sovanto wrote:
> Hi again, Chris and others!
>
> We're hitting this again on 4.14.32.
>
> Looks like the path iscsi_queuecommand -> prepd_reject/prepd_fault
> results in iscsi_complete_task getting called with frwd_lock held
> instead of the requisite back_lock which might explain the task list
> corruption under heavy loads.
>
> An alternate possibly problematic situation seems to be
> fail_mgmt_tasks which calls iscsi_complete_task while holding
> frwd_lock from iscsi_start_session_recovery.
>
> See also: https://github.com/open-iscsi/open-iscsi/issues/56
>
> Attached an ugly attempt at ensuring back_lock is held instead.
>
>   - Ilkka
>
> On 5 March 2017 at 22:49, Ilkka Sovanto <ilkka-/1wQRMveznE@public.gmane.org> wrote:
>> Hi!
>>
>> Was running pretty nicely for a week or so, until we got this one:
>>
>> [534630.679965] BUG: unable to handle kernel at 0000000000000078
>> [534630.684035] IP: [<ffffffff8170efc9>] iscsi_xmit_task+0x29/0xc0
>> [534630.685724] PGD a1fcd3067
>> [534630.687346] Oops: 0002 [#1]
>> [534630.688846] Modules linked in:
>> [534630.690348] CPU: 17 PID: 7988 Comm: kworker/u56:6 Tainted: G        =
W
>> [534630.693327] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS 41113_115728-nilsson.home.kraxel.org 04/01/2014
>> [534630.696404] Workqueue: iscsi_q_8 iscsi_xmitworker
>> [534630.697948] task: ffff8800bab62f00 ti: ffff880c0d9d8000 task.ti:
>> ffff880c0d9d8000
>> [534630.700837] RIP: 0010:[<ffffffff8170efc9>] [<ffffffff8170efc9>]
>> iscsi_xmit_task+0x29/0xc0
>> [534630.703689] RSP: 0018:ffff880c0d9dbdb0  EFLAGS: 00010246
>> [534630.705209] RAX: 00000000ffffffc3 RBX: ffff880fe3dfda10 RCX:
>> dead000000000200
>> [534630.708062] RDX: 0000000000000000 RSI: 0000000000000200 RDI:
>> ffff880fe3dfda10
>> [534630.710773] RBP: ffff880c0d9dbdc8 R08: ffff880fe3881c80 R09:
>> 0000000000000000
>> [534630.713539] R10: ffff880fb799f710 R11: 0000000000000260 R12:
>> ffff880fe3dfda10
>> [534630.716344] R13: 0000000000000000 R14: ffff880fe3881c80 R15:
>> ffff880fe3dfdae0
>> [534630.719143] FS:  0000000000000000(0000) GS:ffff880fff420000(0000)
>> [534630.722001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [534630.723492] CR2: 0000000000000078 CR3: 0000000aa8e44000 CR4:
>> 00000000000406e0
>> [534630.726163] Stack:
>> [534630.727622]  ffff880fe3dfdaa8 ffff880fe3dfda10 ffff880fe3dfdac0
>> ffff880c0d9dbe18
>> [534630.730906]  ffffffff8171226d ffff880fe3dfdad0 ffff880fe3881c00
>> ffff880fe3dfdab0
>> [534630.767489]  ffff880ff7d98780 ffff880fe3dfdae0 ffff880ffec99400
>> ffff880fe3dfdae8
>>
>> [534630.770543] Call Trace:
>> [534630.771967]  [<ffffffff8171226d>] iscsi_xmitworker+0x1dd/0x310
>> [534630.773523]  [<ffffffff810a7e29>] process_one_work+0x149/0x3e0
>> [534630.775084]  [<ffffffff810a8129>] worker_thread+0x69/0x470
>> [534630.776585]  [<ffffffff810a80c0>] ? process_one_work+0x3e0/0x3e0
>> [534630.778131]  [<ffffffff810a80c0>] ? process_one_work+0x3e0/0x3e0
>> [534630.779682]  [<ffffffff810ad72a>] kthread+0xea/0x100
>> [534630.781300]  [<ffffffff810ad640>] ? kthread_create_on_node+0x1a0/0x1=
a0
>> [534630.782872]  [<ffffffff81c3cc4f>] ret_from_fork+0x3f/0x70
>> [534630.784340]  [<ffffffff810ad640>] ? kthread_create_on_node+0x1a0/0x1=
a0
>> [534630.785885] Code:
>> [534630.792699] RIP [<ffffffff8170efc9>] iscsi_xmit_task+0x29/0xc0
>> [534630.794266]  RSP <ffff880c0d9dbdb0>
>> [534630.795617] CR2: 0000000000000078
>> [534630.798051] ---[ end trace 9d963f95212dfbe2 ]---
>> [534630.799788] Kernel panic - not syncing: Fatal exception in interrupt
>> [534630.802712] Kernel Offset: disabled
>> [534630.804304] ---[ end Kernel panic - not syncing: Fatal exception
>> in interrupt
>>
>> And here's the disassembly for iscsi_xmit_task:
>>
>> ffffffff8170efa0 <iscsi_xmit_task>:
>> ffffffff8170efa0:       e8 0b fd 52 00          call
>> ffffffff81c3ecb0 <__fentry__>
>> ffffffff8170efa5:       55                      push   rbp
>> ffffffff8170efa6:       b8 c3 ff ff ff          mov    eax,0xffffffc3
>> ffffffff8170efab:       48 89 e5                mov    rbp,rsp
>> ffffffff8170efae:       41 55                   push   r13
>> ffffffff8170efb0:       41 54                   push   r12
>> ffffffff8170efb2:       53                      push   rbx
>> ffffffff8170efb3:       48 8b 97 f0 00 00 00    mov    rdx,QWORD PTR [rd=
i+0xf0]
>> ffffffff8170efba:       4c 8b af 90 00 00 00    mov    r13,QWORD PTR [rd=
i+0x90]
>> ffffffff8170efc1:       83 e2 02                and    edx,0x2
>> ffffffff8170efc4:       75 71                   jne
>> ffffffff8170f037 <iscsi_xmit_task+0x97>
>> ffffffff8170efc6:       48 89 fb                mov    rbx,rdi
>> ***
>> ffffffff8170efc9:       f0 41 ff 45 78          lock inc DWORD PTR [r13+=
0x78]
>> ***
>> ffffffff8170efce:       48 8b 47 10             mov    rax,QWORD PTR [rd=
i+0x10]
>> ffffffff8170efd2:       48 8d b8 18 01 00 00    lea    rdi,[rax+0x118]
>> ffffffff8170efd9:       e8 b2 d3 52 00          call
>> ffffffff81c3c390 <_raw_spin_unlock_bh>
>> ffffffff8170efde:       48 8b 43 10             mov    rax,QWORD PTR [rb=
x+0x10]
>> ffffffff8170efe2:       4c 89 ef                mov    rdi,r13
>> ffffffff8170efe5:       48 8b 80 00 01 00 00    mov    rax,QWORD PTR [ra=
x+0x100]
>> ffffffff8170efec:       ff 90 98 00 00 00       call   QWORD PTR [rax+0x=
98]
>> ffffffff8170eff2:       41 89 c4                mov    r12d,eax
>> ffffffff8170eff5:       48 8b 43 10             mov    rax,QWORD PTR [rb=
x+0x10]
>> ffffffff8170eff9:       48 8d b8 18 01 00 00    lea    rdi,[rax+0x118]
>> ffffffff8170f000:       e8 9b d4 52 00          call
>> ffffffff81c3c4a0 <_raw_spin_lock_bh>
>> ffffffff8170f005:       45 85 e4                test   r12d,r12d
>> ffffffff8170f008:       74 34                   je
>> ffffffff8170f03e <iscsi_xmit_task+0x9e>
>> ffffffff8170f00a:       48 8b 43 10             mov    rax,QWORD PTR [rb=
x+0x10]
>> ffffffff8170f00e:       48 8d b8 1c 01 00 00    lea    rdi,[rax+0x11c]
>> ffffffff8170f015:       e8 e6 d3 52 00          call
>> ffffffff81c3c400 <_raw_spin_lock>
>> ffffffff8170f01a:       4c 89 ef                mov    rdi,r13
>> ffffffff8170f01d:       e8 ce f5 ff ff          call
>> ffffffff8170e5f0 <__iscsi_put_task>
>> ffffffff8170f022:       48 8b 7b 10             mov    rdi,QWORD PTR [rb=
x+0x10]
>> ffffffff8170f026:       48 81 c7 1c 01 00 00    add    rdi,0x11c
>> ffffffff8170f02d:       ff 14 25 88 1c 24 82    call   QWORD PTR
>> ds:0xffffffff82241c88
>> ffffffff8170f034:       44 89 e0                mov    eax,r12d
>> ffffffff8170f037:       5b                      pop    rbx
>> ffffffff8170f038:       41 5c                   pop    r12
>> ffffffff8170f03a:       41 5d                   pop    r13
>> ffffffff8170f03c:       5d                      pop    rbp
>> ffffffff8170f03d:       c3                      ret
>> ffffffff8170f03e:       48 8b 05 bb 0f b1 00    mov    rax,QWORD PTR
>> [rip+0xb10fbb]        # ffffffff82220000 <jiffies>
>> ffffffff8170f045:       49 89 45 60             mov    QWORD PTR [r13+0x=
60],rax
>> ffffffff8170f049:       48 c7 83 90 00 00 00    mov    QWORD PTR [rbx+0x=
90],0x0
>> ffffffff8170f050:       00 00 00 00
>> ffffffff8170f054:       eb b4                   jmp
>> ffffffff8170f00a <iscsi_xmit_task+0x6a>
>> ffffffff8170f056:       66 2e 0f 1f 84 00 00    nop    WORD PTR
>> cs:[rax+rax*1+0x0]
>>
>>
>>
>> The instruction
>> ffffffff8170efc9:       f0 41 ff 45 78          lock inc DWORD PTR [r13+=
0x78]
>> seems to correspond to
>> 1445         __iscsi_get_task(task);
>>
>> in iscsi_xmit_task() suggesting that conn->task was null.
>>
>> Perhaps we're still missing something?
>>
>>   - Ilkka
>>
>>
>> On Fri, Feb 24, 2017 at 12:25 AM, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Yikes, my git-send-email settings suppressed the important CCs.  Sorry!
>>>
>>> Guilherme and Ilkka, can you comment about your testing results or revi=
ew please?
>>>
>>> - Chris Leech
>>>
>>> ----- Original Message -----
>>>> There's a rather long standing regression from commit
>>>> 659743b [SCSI] libiscsi: Reduce locking contention in fast path
>>>>
>>>> Depending on iSCSI target behavior, it's possible to hit the case in
>>>> iscsi_complete_task where the task is still on a pending list
>>>> (!list_empty(&task->running)).  When that happens the task is removed
>>>> from the list while holding the session back_lock, but other task list
>>>> modification occur under the frwd_lock.  That leads to linked list
>>>> corruption and eventually a panicked system.
>>>>
>>>> Rather than back out the session lock split entirely, in order to try
>>>> and keep some of the performance gains this patch adds another lock to
>>>> maintain the task lists integrity.
>>>>
>>>> Major enterprise supported kernels have been backing out the lock spli=
t
>>>> for while now, thanks to the efforts at IBM where a lab setup has the
>>>> most reliable reproducer I've seen on this issue.  This patch has been
>>>> tested there successfully.
>>>>
>>>> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>   drivers/scsi/libiscsi.c | 26 +++++++++++++++++++++++++-
>>>>   include/scsi/libiscsi.h |  1 +
>>>>   2 files changed, 26 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>>> index 834d121..acb5ef3 100644
>>>> --- a/drivers/scsi/libiscsi.c
>>>> +++ b/drivers/scsi/libiscsi.c
>>>> @@ -560,8 +560,12 @@ static void iscsi_complete_task(struct iscsi_task=
 *task,
>>>> int state)
>>>>        WARN_ON_ONCE(task->state =3D=3D ISCSI_TASK_FREE);
>>>>        task->state =3D state;
>>>>
>>>> -     if (!list_empty(&task->running))
>>>> +     spin_lock_bh(&conn->taskqueuelock);
>>>> +     if (!list_empty(&task->running)) {
>>>> +             WARN_ONCE(1, "iscsi_complete_task while task on list");
>>>>                list_del_init(&task->running);
>>>> +     }
>>>> +     spin_unlock_bh(&conn->taskqueuelock);
>>>>
>>>>        if (conn->task =3D=3D task)
>>>>                conn->task =3D NULL;
>>>> @@ -783,7 +787,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, str=
uct
>>>> iscsi_hdr *hdr,
>>>>                if (session->tt->xmit_task(task))
>>>>                        goto free_task;
>>>>        } else {
>>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>>                list_add_tail(&task->running, &conn->mgmtqueue);
>>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>>                iscsi_conn_queue_work(conn);
>>>>        }
>>>>
>>>> @@ -1474,8 +1480,10 @@ void iscsi_requeue_task(struct iscsi_task *task=
)
>>>>         * this may be on the requeue list already if the xmit_task cal=
lout
>>>>         * is handling the r2ts while we are adding new ones
>>>>         */
>>>> +     spin_lock_bh(&conn->taskqueuelock);
>>>>        if (list_empty(&task->running))
>>>>                list_add_tail(&task->running, &conn->requeue);
>>>> +     spin_unlock_bh(&conn->taskqueuelock);
>>>>        iscsi_conn_queue_work(conn);
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(iscsi_requeue_task);
>>>> @@ -1512,22 +1520,26 @@ static int iscsi_data_xmit(struct iscsi_conn *=
conn)
>>>>         * only have one nop-out as a ping from us and targets should n=
ot
>>>>         * overflow us with nop-ins
>>>>         */
>>>> +     spin_lock_bh(&conn->taskqueuelock);
>>>>   check_mgmt:
>>>>        while (!list_empty(&conn->mgmtqueue)) {
>>>>                conn->task =3D list_entry(conn->mgmtqueue.next,
>>>>                                         struct iscsi_task, running);
>>>>                list_del_init(&conn->task->running);
>>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>>                if (iscsi_prep_mgmt_task(conn, conn->task)) {
>>>>                        /* regular RX path uses back_lock */
>>>>                        spin_lock_bh(&conn->session->back_lock);
>>>>                        __iscsi_put_task(conn->task);
>>>>                        spin_unlock_bh(&conn->session->back_lock);
>>>>                        conn->task =3D NULL;
>>>> +                     spin_lock_bh(&conn->taskqueuelock);
>>>>                        continue;
>>>>                }
>>>>                rc =3D iscsi_xmit_task(conn);
>>>>                if (rc)
>>>>                        goto done;
>>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>>        }
>>>>
>>>>        /* process pending command queue */
>>>> @@ -1535,19 +1547,24 @@ static int iscsi_data_xmit(struct iscsi_conn *=
conn)
>>>>                conn->task =3D list_entry(conn->cmdqueue.next, struct i=
scsi_task,
>>>>                                        running);
>>>>                list_del_init(&conn->task->running);
>>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>>                if (conn->session->state =3D=3D ISCSI_STATE_LOGGING_OUT=
) {
>>>>                        fail_scsi_task(conn->task, DID_IMM_RETRY);
>>>> +                     spin_lock_bh(&conn->taskqueuelock);
>>>>                        continue;
>>>>                }
>>>>                rc =3D iscsi_prep_scsi_cmd_pdu(conn->task);
>>>>                if (rc) {
>>>>                        if (rc =3D=3D -ENOMEM || rc =3D=3D -EACCES) {
>>>> +                             spin_lock_bh(&conn->taskqueuelock);
>>>>                                list_add_tail(&conn->task->running,
>>>>                                              &conn->cmdqueue);
>>>>                                conn->task =3D NULL;
>>>> +                             spin_unlock_bh(&conn->taskqueuelock);
>>>>                                goto done;
>>>>                        } else
>>>>                                fail_scsi_task(conn->task, DID_ABORT);
>>>> +                     spin_lock_bh(&conn->taskqueuelock);
>>>>                        continue;
>>>>                }
>>>>                rc =3D iscsi_xmit_task(conn);
>>>> @@ -1558,6 +1575,7 @@ static int iscsi_data_xmit(struct iscsi_conn *co=
nn)
>>>>                 * we need to check the mgmt queue for nops that need t=
o
>>>>                 * be sent to aviod starvation
>>>>                 */
>>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>>                if (!list_empty(&conn->mgmtqueue))
>>>>                        goto check_mgmt;
>>>>        }
>>>> @@ -1577,12 +1595,15 @@ static int iscsi_data_xmit(struct iscsi_conn *=
conn)
>>>>                conn->task =3D task;
>>>>                list_del_init(&conn->task->running);
>>>>                conn->task->state =3D ISCSI_TASK_RUNNING;
>>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>>                rc =3D iscsi_xmit_task(conn);
>>>>                if (rc)
>>>>                        goto done;
>>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>>                if (!list_empty(&conn->mgmtqueue))
>>>>                        goto check_mgmt;
>>>>        }
>>>> +     spin_unlock_bh(&conn->taskqueuelock);
>>>>        spin_unlock_bh(&conn->session->frwd_lock);
>>>>        return -ENODATA;
>>>>
>>>> @@ -1738,7 +1759,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, s=
truct
>>>> scsi_cmnd *sc)
>>>>                        goto prepd_reject;
>>>>                }
>>>>        } else {
>>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>>                list_add_tail(&task->running, &conn->cmdqueue);
>>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>>                iscsi_conn_queue_work(conn);
>>>>        }
>>>>
>>>> @@ -2896,6 +2919,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_s=
ession,
>>>> int dd_size,
>>>>        INIT_LIST_HEAD(&conn->mgmtqueue);
>>>>        INIT_LIST_HEAD(&conn->cmdqueue);
>>>>        INIT_LIST_HEAD(&conn->requeue);
>>>> +     spin_lock_init(&conn->taskqueuelock);
>>>>        INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
>>>>
>>>>        /* allocate login_task used for the login/text sequences */
>>>> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
>>>> index b0e275d..583875e 100644
>>>> --- a/include/scsi/libiscsi.h
>>>> +++ b/include/scsi/libiscsi.h
>>>> @@ -196,6 +196,7 @@ struct iscsi_conn {
>>>>        struct iscsi_task       *task;          /* xmit task in progres=
s */
>>>>
>>>>        /* xmit */
>>>> +     spinlock_t              taskqueuelock;  /* protects the next thr=
ee lists */
>>>>        struct list_head        mgmtqueue;      /* mgmt (control) xmit =
queue */
>>>>        struct list_head        cmdqueue;       /* data-path cmd queue =
*/
>>>>        struct list_head        requeue;        /* tasks needing anothe=
r run */
>>>> --
>>>> 2.9.3
>>>>
>>>>

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

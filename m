From: Ilkka Sovanto <ilkka-/1wQRMveznE@public.gmane.org>
Subject: Re: [PATCH] libiscsi: add lock around task lists to fix list
 corruption regression
Date: Thu, 10 May 2018 01:27:52 +0300
Message-ID: <CAKYn0tjF46gxwj3MtjLL_ic+veXjTZ9n_BGKjz6-fW+Cse2w9w@mail.gmail.com>
References: <20170221173536.32024-1-cleech@redhat.com> <250619225.63072551.1487888748696.JavaMail.zimbra@redhat.com>
 <CAKYn0tiyWNEjFZHaPDHNjam5=3WCR_V2svNiJmvWeYhpv3=8Ag@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="089e082e09a0efb1d8056bcd69eb"
Return-path: <open-iscsi+bncBD2IVTMGVIKBB3HLZXLQKGQEEFPIJDQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CAKYn0tiyWNEjFZHaPDHNjam5=3WCR_V2svNiJmvWeYhpv3=8Ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, martin petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, "Guilherme G. Piccoli" <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--089e082e09a0efb1d8056bcd69eb
Content-Type: text/plain; charset="UTF-8"

Hi again, Chris and others!

We're hitting this again on 4.14.32.

Looks like the path iscsi_queuecommand -> prepd_reject/prepd_fault
results in iscsi_complete_task getting called with frwd_lock held
instead of the requisite back_lock which might explain the task list
corruption under heavy loads.

An alternate possibly problematic situation seems to be
fail_mgmt_tasks which calls iscsi_complete_task while holding
frwd_lock from iscsi_start_session_recovery.

See also: https://github.com/open-iscsi/open-iscsi/issues/56

Attached an ugly attempt at ensuring back_lock is held instead.

 - Ilkka

On 5 March 2017 at 22:49, Ilkka Sovanto <ilkka-/1wQRMveznE@public.gmane.org> wrote:
> Hi!
>
> Was running pretty nicely for a week or so, until we got this one:
>
> [534630.679965] BUG: unable to handle kernel at 0000000000000078
> [534630.684035] IP: [<ffffffff8170efc9>] iscsi_xmit_task+0x29/0xc0
> [534630.685724] PGD a1fcd3067
> [534630.687346] Oops: 0002 [#1]
> [534630.688846] Modules linked in:
> [534630.690348] CPU: 17 PID: 7988 Comm: kworker/u56:6 Tainted: G        W
> [534630.693327] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 41113_115728-nilsson.home.kraxel.org 04/01/2014
> [534630.696404] Workqueue: iscsi_q_8 iscsi_xmitworker
> [534630.697948] task: ffff8800bab62f00 ti: ffff880c0d9d8000 task.ti:
> ffff880c0d9d8000
> [534630.700837] RIP: 0010:[<ffffffff8170efc9>] [<ffffffff8170efc9>]
> iscsi_xmit_task+0x29/0xc0
> [534630.703689] RSP: 0018:ffff880c0d9dbdb0  EFLAGS: 00010246
> [534630.705209] RAX: 00000000ffffffc3 RBX: ffff880fe3dfda10 RCX:
> dead000000000200
> [534630.708062] RDX: 0000000000000000 RSI: 0000000000000200 RDI:
> ffff880fe3dfda10
> [534630.710773] RBP: ffff880c0d9dbdc8 R08: ffff880fe3881c80 R09:
> 0000000000000000
> [534630.713539] R10: ffff880fb799f710 R11: 0000000000000260 R12:
> ffff880fe3dfda10
> [534630.716344] R13: 0000000000000000 R14: ffff880fe3881c80 R15:
> ffff880fe3dfdae0
> [534630.719143] FS:  0000000000000000(0000) GS:ffff880fff420000(0000)
> [534630.722001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [534630.723492] CR2: 0000000000000078 CR3: 0000000aa8e44000 CR4:
> 00000000000406e0
> [534630.726163] Stack:
> [534630.727622]  ffff880fe3dfdaa8 ffff880fe3dfda10 ffff880fe3dfdac0
> ffff880c0d9dbe18
> [534630.730906]  ffffffff8171226d ffff880fe3dfdad0 ffff880fe3881c00
> ffff880fe3dfdab0
> [534630.767489]  ffff880ff7d98780 ffff880fe3dfdae0 ffff880ffec99400
> ffff880fe3dfdae8
>
> [534630.770543] Call Trace:
> [534630.771967]  [<ffffffff8171226d>] iscsi_xmitworker+0x1dd/0x310
> [534630.773523]  [<ffffffff810a7e29>] process_one_work+0x149/0x3e0
> [534630.775084]  [<ffffffff810a8129>] worker_thread+0x69/0x470
> [534630.776585]  [<ffffffff810a80c0>] ? process_one_work+0x3e0/0x3e0
> [534630.778131]  [<ffffffff810a80c0>] ? process_one_work+0x3e0/0x3e0
> [534630.779682]  [<ffffffff810ad72a>] kthread+0xea/0x100
> [534630.781300]  [<ffffffff810ad640>] ? kthread_create_on_node+0x1a0/0x1a0
> [534630.782872]  [<ffffffff81c3cc4f>] ret_from_fork+0x3f/0x70
> [534630.784340]  [<ffffffff810ad640>] ? kthread_create_on_node+0x1a0/0x1a0
> [534630.785885] Code:
> [534630.792699] RIP [<ffffffff8170efc9>] iscsi_xmit_task+0x29/0xc0
> [534630.794266]  RSP <ffff880c0d9dbdb0>
> [534630.795617] CR2: 0000000000000078
> [534630.798051] ---[ end trace 9d963f95212dfbe2 ]---
> [534630.799788] Kernel panic - not syncing: Fatal exception in interrupt
> [534630.802712] Kernel Offset: disabled
> [534630.804304] ---[ end Kernel panic - not syncing: Fatal exception
> in interrupt
>
> And here's the disassembly for iscsi_xmit_task:
>
> ffffffff8170efa0 <iscsi_xmit_task>:
> ffffffff8170efa0:       e8 0b fd 52 00          call
> ffffffff81c3ecb0 <__fentry__>
> ffffffff8170efa5:       55                      push   rbp
> ffffffff8170efa6:       b8 c3 ff ff ff          mov    eax,0xffffffc3
> ffffffff8170efab:       48 89 e5                mov    rbp,rsp
> ffffffff8170efae:       41 55                   push   r13
> ffffffff8170efb0:       41 54                   push   r12
> ffffffff8170efb2:       53                      push   rbx
> ffffffff8170efb3:       48 8b 97 f0 00 00 00    mov    rdx,QWORD PTR [rdi+0xf0]
> ffffffff8170efba:       4c 8b af 90 00 00 00    mov    r13,QWORD PTR [rdi+0x90]
> ffffffff8170efc1:       83 e2 02                and    edx,0x2
> ffffffff8170efc4:       75 71                   jne
> ffffffff8170f037 <iscsi_xmit_task+0x97>
> ffffffff8170efc6:       48 89 fb                mov    rbx,rdi
> ***
> ffffffff8170efc9:       f0 41 ff 45 78          lock inc DWORD PTR [r13+0x78]
> ***
> ffffffff8170efce:       48 8b 47 10             mov    rax,QWORD PTR [rdi+0x10]
> ffffffff8170efd2:       48 8d b8 18 01 00 00    lea    rdi,[rax+0x118]
> ffffffff8170efd9:       e8 b2 d3 52 00          call
> ffffffff81c3c390 <_raw_spin_unlock_bh>
> ffffffff8170efde:       48 8b 43 10             mov    rax,QWORD PTR [rbx+0x10]
> ffffffff8170efe2:       4c 89 ef                mov    rdi,r13
> ffffffff8170efe5:       48 8b 80 00 01 00 00    mov    rax,QWORD PTR [rax+0x100]
> ffffffff8170efec:       ff 90 98 00 00 00       call   QWORD PTR [rax+0x98]
> ffffffff8170eff2:       41 89 c4                mov    r12d,eax
> ffffffff8170eff5:       48 8b 43 10             mov    rax,QWORD PTR [rbx+0x10]
> ffffffff8170eff9:       48 8d b8 18 01 00 00    lea    rdi,[rax+0x118]
> ffffffff8170f000:       e8 9b d4 52 00          call
> ffffffff81c3c4a0 <_raw_spin_lock_bh>
> ffffffff8170f005:       45 85 e4                test   r12d,r12d
> ffffffff8170f008:       74 34                   je
> ffffffff8170f03e <iscsi_xmit_task+0x9e>
> ffffffff8170f00a:       48 8b 43 10             mov    rax,QWORD PTR [rbx+0x10]
> ffffffff8170f00e:       48 8d b8 1c 01 00 00    lea    rdi,[rax+0x11c]
> ffffffff8170f015:       e8 e6 d3 52 00          call
> ffffffff81c3c400 <_raw_spin_lock>
> ffffffff8170f01a:       4c 89 ef                mov    rdi,r13
> ffffffff8170f01d:       e8 ce f5 ff ff          call
> ffffffff8170e5f0 <__iscsi_put_task>
> ffffffff8170f022:       48 8b 7b 10             mov    rdi,QWORD PTR [rbx+0x10]
> ffffffff8170f026:       48 81 c7 1c 01 00 00    add    rdi,0x11c
> ffffffff8170f02d:       ff 14 25 88 1c 24 82    call   QWORD PTR
> ds:0xffffffff82241c88
> ffffffff8170f034:       44 89 e0                mov    eax,r12d
> ffffffff8170f037:       5b                      pop    rbx
> ffffffff8170f038:       41 5c                   pop    r12
> ffffffff8170f03a:       41 5d                   pop    r13
> ffffffff8170f03c:       5d                      pop    rbp
> ffffffff8170f03d:       c3                      ret
> ffffffff8170f03e:       48 8b 05 bb 0f b1 00    mov    rax,QWORD PTR
> [rip+0xb10fbb]        # ffffffff82220000 <jiffies>
> ffffffff8170f045:       49 89 45 60             mov    QWORD PTR [r13+0x60],rax
> ffffffff8170f049:       48 c7 83 90 00 00 00    mov    QWORD PTR [rbx+0x90],0x0
> ffffffff8170f050:       00 00 00 00
> ffffffff8170f054:       eb b4                   jmp
> ffffffff8170f00a <iscsi_xmit_task+0x6a>
> ffffffff8170f056:       66 2e 0f 1f 84 00 00    nop    WORD PTR
> cs:[rax+rax*1+0x0]
>
>
>
> The instruction
> ffffffff8170efc9:       f0 41 ff 45 78          lock inc DWORD PTR [r13+0x78]
> seems to correspond to
> 1445         __iscsi_get_task(task);
>
> in iscsi_xmit_task() suggesting that conn->task was null.
>
> Perhaps we're still missing something?
>
>  - Ilkka
>
>
> On Fri, Feb 24, 2017 at 12:25 AM, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Yikes, my git-send-email settings suppressed the important CCs.  Sorry!
>>
>> Guilherme and Ilkka, can you comment about your testing results or review please?
>>
>> - Chris Leech
>>
>> ----- Original Message -----
>>> There's a rather long standing regression from commit
>>> 659743b [SCSI] libiscsi: Reduce locking contention in fast path
>>>
>>> Depending on iSCSI target behavior, it's possible to hit the case in
>>> iscsi_complete_task where the task is still on a pending list
>>> (!list_empty(&task->running)).  When that happens the task is removed
>>> from the list while holding the session back_lock, but other task list
>>> modification occur under the frwd_lock.  That leads to linked list
>>> corruption and eventually a panicked system.
>>>
>>> Rather than back out the session lock split entirely, in order to try
>>> and keep some of the performance gains this patch adds another lock to
>>> maintain the task lists integrity.
>>>
>>> Major enterprise supported kernels have been backing out the lock split
>>> for while now, thanks to the efforts at IBM where a lab setup has the
>>> most reliable reproducer I've seen on this issue.  This patch has been
>>> tested there successfully.
>>>
>>> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  drivers/scsi/libiscsi.c | 26 +++++++++++++++++++++++++-
>>>  include/scsi/libiscsi.h |  1 +
>>>  2 files changed, 26 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>> index 834d121..acb5ef3 100644
>>> --- a/drivers/scsi/libiscsi.c
>>> +++ b/drivers/scsi/libiscsi.c
>>> @@ -560,8 +560,12 @@ static void iscsi_complete_task(struct iscsi_task *task,
>>> int state)
>>>       WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
>>>       task->state = state;
>>>
>>> -     if (!list_empty(&task->running))
>>> +     spin_lock_bh(&conn->taskqueuelock);
>>> +     if (!list_empty(&task->running)) {
>>> +             WARN_ONCE(1, "iscsi_complete_task while task on list");
>>>               list_del_init(&task->running);
>>> +     }
>>> +     spin_unlock_bh(&conn->taskqueuelock);
>>>
>>>       if (conn->task == task)
>>>               conn->task = NULL;
>>> @@ -783,7 +787,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct
>>> iscsi_hdr *hdr,
>>>               if (session->tt->xmit_task(task))
>>>                       goto free_task;
>>>       } else {
>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>               list_add_tail(&task->running, &conn->mgmtqueue);
>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>               iscsi_conn_queue_work(conn);
>>>       }
>>>
>>> @@ -1474,8 +1480,10 @@ void iscsi_requeue_task(struct iscsi_task *task)
>>>        * this may be on the requeue list already if the xmit_task callout
>>>        * is handling the r2ts while we are adding new ones
>>>        */
>>> +     spin_lock_bh(&conn->taskqueuelock);
>>>       if (list_empty(&task->running))
>>>               list_add_tail(&task->running, &conn->requeue);
>>> +     spin_unlock_bh(&conn->taskqueuelock);
>>>       iscsi_conn_queue_work(conn);
>>>  }
>>>  EXPORT_SYMBOL_GPL(iscsi_requeue_task);
>>> @@ -1512,22 +1520,26 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>        * only have one nop-out as a ping from us and targets should not
>>>        * overflow us with nop-ins
>>>        */
>>> +     spin_lock_bh(&conn->taskqueuelock);
>>>  check_mgmt:
>>>       while (!list_empty(&conn->mgmtqueue)) {
>>>               conn->task = list_entry(conn->mgmtqueue.next,
>>>                                        struct iscsi_task, running);
>>>               list_del_init(&conn->task->running);
>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>               if (iscsi_prep_mgmt_task(conn, conn->task)) {
>>>                       /* regular RX path uses back_lock */
>>>                       spin_lock_bh(&conn->session->back_lock);
>>>                       __iscsi_put_task(conn->task);
>>>                       spin_unlock_bh(&conn->session->back_lock);
>>>                       conn->task = NULL;
>>> +                     spin_lock_bh(&conn->taskqueuelock);
>>>                       continue;
>>>               }
>>>               rc = iscsi_xmit_task(conn);
>>>               if (rc)
>>>                       goto done;
>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>       }
>>>
>>>       /* process pending command queue */
>>> @@ -1535,19 +1547,24 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>               conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>>>                                       running);
>>>               list_del_init(&conn->task->running);
>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>               if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
>>>                       fail_scsi_task(conn->task, DID_IMM_RETRY);
>>> +                     spin_lock_bh(&conn->taskqueuelock);
>>>                       continue;
>>>               }
>>>               rc = iscsi_prep_scsi_cmd_pdu(conn->task);
>>>               if (rc) {
>>>                       if (rc == -ENOMEM || rc == -EACCES) {
>>> +                             spin_lock_bh(&conn->taskqueuelock);
>>>                               list_add_tail(&conn->task->running,
>>>                                             &conn->cmdqueue);
>>>                               conn->task = NULL;
>>> +                             spin_unlock_bh(&conn->taskqueuelock);
>>>                               goto done;
>>>                       } else
>>>                               fail_scsi_task(conn->task, DID_ABORT);
>>> +                     spin_lock_bh(&conn->taskqueuelock);
>>>                       continue;
>>>               }
>>>               rc = iscsi_xmit_task(conn);
>>> @@ -1558,6 +1575,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>                * we need to check the mgmt queue for nops that need to
>>>                * be sent to aviod starvation
>>>                */
>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>               if (!list_empty(&conn->mgmtqueue))
>>>                       goto check_mgmt;
>>>       }
>>> @@ -1577,12 +1595,15 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>               conn->task = task;
>>>               list_del_init(&conn->task->running);
>>>               conn->task->state = ISCSI_TASK_RUNNING;
>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>               rc = iscsi_xmit_task(conn);
>>>               if (rc)
>>>                       goto done;
>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>               if (!list_empty(&conn->mgmtqueue))
>>>                       goto check_mgmt;
>>>       }
>>> +     spin_unlock_bh(&conn->taskqueuelock);
>>>       spin_unlock_bh(&conn->session->frwd_lock);
>>>       return -ENODATA;
>>>
>>> @@ -1738,7 +1759,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct
>>> scsi_cmnd *sc)
>>>                       goto prepd_reject;
>>>               }
>>>       } else {
>>> +             spin_lock_bh(&conn->taskqueuelock);
>>>               list_add_tail(&task->running, &conn->cmdqueue);
>>> +             spin_unlock_bh(&conn->taskqueuelock);
>>>               iscsi_conn_queue_work(conn);
>>>       }
>>>
>>> @@ -2896,6 +2919,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session,
>>> int dd_size,
>>>       INIT_LIST_HEAD(&conn->mgmtqueue);
>>>       INIT_LIST_HEAD(&conn->cmdqueue);
>>>       INIT_LIST_HEAD(&conn->requeue);
>>> +     spin_lock_init(&conn->taskqueuelock);
>>>       INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
>>>
>>>       /* allocate login_task used for the login/text sequences */
>>> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
>>> index b0e275d..583875e 100644
>>> --- a/include/scsi/libiscsi.h
>>> +++ b/include/scsi/libiscsi.h
>>> @@ -196,6 +196,7 @@ struct iscsi_conn {
>>>       struct iscsi_task       *task;          /* xmit task in progress */
>>>
>>>       /* xmit */
>>> +     spinlock_t              taskqueuelock;  /* protects the next three lists */
>>>       struct list_head        mgmtqueue;      /* mgmt (control) xmit queue */
>>>       struct list_head        cmdqueue;       /* data-path cmd queue */
>>>       struct list_head        requeue;        /* tasks needing another run */
>>> --
>>> 2.9.3
>>>
>>>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

--089e082e09a0efb1d8056bcd69eb
Content-Type: application/octet-stream;
	name="iscsi_complete_task-back_lock.patch"
Content-Disposition: attachment;
	filename="iscsi_complete_task-back_lock.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jgzntmbt0

LS0tIGxpYmlzY3NpLmMgICAgMjAxOC0wMy0zMSAxOToxMDo0My4wMDAwMDAwMDAgKzAzMDAKKysr
IC90bXAvbGliaXNjc2kuYyAgICAyMDE4LTA1LTEwIDAwOjU3OjQ5LjIxNjg1MTAzNSArMDMwMApA
QCAtMTY4NCw2ICsxNjg0LDcgQEAgaW50IGlzY3NpX3F1ZXVlY29tbWFuZChzdHJ1Y3QgU2NzaV9I
b3N0CiAgICAgcmVhc29uID0gaXNjc2lfc2Vzc2lvbl9jaGtyZWFkeShjbHNfc2Vzc2lvbik7CiAg
ICAgaWYgKHJlYXNvbikgewogICAgICAgICBzYy0+cmVzdWx0ID0gcmVhc29uOworICAgICAgICBz
cGluX3VubG9ja19iaCgmc2Vzc2lvbi0+ZnJ3ZF9sb2NrKTsKICAgICAgICAgZ290byBmYXVsdDsK
ICAgICB9CgpAQCAtMTcxNiw2ICsxNzE3LDcgQEAgaW50IGlzY3NpX3F1ZXVlY29tbWFuZChzdHJ1
Y3QgU2NzaV9Ib3N0CiAgICAgICAgICAgICByZWFzb24gPSBGQUlMVVJFX1NFU1NJT05fRlJFRUQ7
CiAgICAgICAgICAgICBzYy0+cmVzdWx0ID0gRElEX05PX0NPTk5FQ1QgPDwgMTY7CiAgICAgICAg
IH0KKyAgICAgICAgc3Bpbl91bmxvY2tfYmgoJnNlc3Npb24tPmZyd2RfbG9jayk7CiAgICAgICAg
IGdvdG8gZmF1bHQ7CiAgICAgfQoKQEAgLTE3MjMsMjMgKzE3MjUsMjcgQEAgaW50IGlzY3NpX3F1
ZXVlY29tbWFuZChzdHJ1Y3QgU2NzaV9Ib3N0CiAgICAgaWYgKCFjb25uKSB7CiAgICAgICAgIHJl
YXNvbiA9IEZBSUxVUkVfU0VTU0lPTl9GUkVFRDsKICAgICAgICAgc2MtPnJlc3VsdCA9IERJRF9O
T19DT05ORUNUIDw8IDE2OworICAgICAgICBzcGluX3VubG9ja19iaCgmc2Vzc2lvbi0+ZnJ3ZF9s
b2NrKTsKICAgICAgICAgZ290byBmYXVsdDsKICAgICB9CgogICAgIGlmICh0ZXN0X2JpdChJU0NT
SV9TVVNQRU5EX0JJVCwgJmNvbm4tPnN1c3BlbmRfdHgpKSB7CiAgICAgICAgIHJlYXNvbiA9IEZB
SUxVUkVfU0VTU0lPTl9JTl9SRUNPVkVSWTsKICAgICAgICAgc2MtPnJlc3VsdCA9IERJRF9SRVFV
RVVFIDw8IDE2OworICAgICAgICBzcGluX3VubG9ja19iaCgmc2Vzc2lvbi0+ZnJ3ZF9sb2NrKTsK
ICAgICAgICAgZ290byBmYXVsdDsKICAgICB9CgogICAgIGlmIChpc2NzaV9jaGVja19jbWRzbl93
aW5kb3dfY2xvc2VkKGNvbm4pKSB7CiAgICAgICAgIHJlYXNvbiA9IEZBSUxVUkVfV0lORE9XX0NM
T1NFRDsKKyAgICAgICAgc3Bpbl91bmxvY2tfYmgoJnNlc3Npb24tPmZyd2RfbG9jayk7CiAgICAg
ICAgIGdvdG8gcmVqZWN0OwogICAgIH0KCiAgICAgdGFzayA9IGlzY3NpX2FsbG9jX3Rhc2soY29u
biwgc2MpOwogICAgIGlmICghdGFzaykgewogICAgICAgICByZWFzb24gPSBGQUlMVVJFX09PTTsK
KyAgICAgICAgc3Bpbl91bmxvY2tfYmgoJnNlc3Npb24tPmZyd2RfbG9jayk7CiAgICAgICAgIGdv
dG8gcmVqZWN0OwogICAgIH0KCkBAIC0xNzQ4LDE1ICsxNzU0LDE4IEBAIGludCBpc2NzaV9xdWV1
ZWNvbW1hbmQoc3RydWN0IFNjc2lfSG9zdAogICAgICAgICBpZiAocmVhc29uKSB7CiAgICAgICAg
ICAgICBpZiAocmVhc29uID09IC1FTk9NRU0gfHwgIHJlYXNvbiA9PSAtRUFDQ0VTKSB7CiAgICAg
ICAgICAgICAgICAgcmVhc29uID0gRkFJTFVSRV9PT007CisgICAgICAgICAgICAgICAgc3Bpbl91
bmxvY2tfYmgoJnNlc3Npb24tPmZyd2RfbG9jayk7CiAgICAgICAgICAgICAgICAgZ290byBwcmVw
ZF9yZWplY3Q7CiAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgIHNjLT5yZXN1
bHQgPSBESURfQUJPUlQgPDwgMTY7CisgICAgICAgICAgICAgICAgc3Bpbl91bmxvY2tfYmgoJnNl
c3Npb24tPmZyd2RfbG9jayk7CiAgICAgICAgICAgICAgICAgZ290byBwcmVwZF9mYXVsdDsKICAg
ICAgICAgICAgIH0KICAgICAgICAgfQogICAgICAgICBpZiAoc2Vzc2lvbi0+dHQtPnhtaXRfdGFz
ayh0YXNrKSkgewogICAgICAgICAgICAgc2Vzc2lvbi0+Y21kc24tLTsKICAgICAgICAgICAgIHJl
YXNvbiA9IEZBSUxVUkVfU0VTU0lPTl9OT1RfUkVBRFk7CisgICAgICAgICAgICBzcGluX3VubG9j
a19iaCgmc2Vzc2lvbi0+ZnJ3ZF9sb2NrKTsKICAgICAgICAgICAgIGdvdG8gcHJlcGRfcmVqZWN0
OwogICAgICAgICB9CiAgICAgfSBlbHNlIHsKQEAgLTE3NzEsMTcgKzE3ODAsMTkgQEAgaW50IGlz
Y3NpX3F1ZXVlY29tbWFuZChzdHJ1Y3QgU2NzaV9Ib3N0CiAgICAgcmV0dXJuIDA7CgogcHJlcGRf
cmVqZWN0OgorICAgIHNwaW5fbG9ja19iaCgmc2Vzc2lvbi0+YmFja19sb2NrKTsKICAgICBpc2Nz
aV9jb21wbGV0ZV90YXNrKHRhc2ssIElTQ1NJX1RBU0tfUkVRVUVVRV9TQ1NJUSk7CisgICAgc3Bp
bl91bmxvY2tfYmgoJnNlc3Npb24tPmJhY2tfbG9jayk7CiByZWplY3Q6Ci0gICAgc3Bpbl91bmxv
Y2tfYmgoJnNlc3Npb24tPmZyd2RfbG9jayk7CiAgICAgSVNDU0lfREJHX1NFU1NJT04oc2Vzc2lv
biwgImNtZCAweCV4IHJlamVjdGVkICglZClcbiIsCiAgICAgICAgICAgICAgIHNjLT5jbW5kWzBd
LCByZWFzb24pOwogICAgIHJldHVybiBTQ1NJX01MUVVFVUVfVEFSR0VUX0JVU1k7CgogcHJlcGRf
ZmF1bHQ6CisgICAgc3Bpbl9sb2NrX2JoKCZzZXNzaW9uLT5iYWNrX2xvY2spOwogICAgIGlzY3Np
X2NvbXBsZXRlX3Rhc2sodGFzaywgSVNDU0lfVEFTS19SRVFVRVVFX1NDU0lRKTsKKyAgICBzcGlu
X3VubG9ja19iaCgmc2Vzc2lvbi0+YmFja19sb2NrKTsKIGZhdWx0OgotICAgIHNwaW5fdW5sb2Nr
X2JoKCZzZXNzaW9uLT5mcndkX2xvY2spOwogICAgIElTQ1NJX0RCR19TRVNTSU9OKHNlc3Npb24s
ICJpc2NzaTogY21kIDB4JXggaXMgbm90IHF1ZXVlZCAoJWQpXG4iLAogICAgICAgICAgICAgICBz
Yy0+Y21uZFswXSwgcmVhc29uKTsKICAgICBpZiAoIXNjc2lfYmlkaV9jbW5kKHNjKSkKQEAgLTMx
NDksNyArMzE2MCwxMSBAQCBzdGF0aWMgdm9pZCBpc2NzaV9zdGFydF9zZXNzaW9uX3JlY292ZXJ5
CiAgICAgICovCiAgICAgc3Bpbl9sb2NrX2JoKCZzZXNzaW9uLT5mcndkX2xvY2spOwogICAgIGZh
aWxfc2NzaV90YXNrcyhjb25uLCAtMSwgRElEX1RSQU5TUE9SVF9ESVNSVVBURUQpOworICAgIHNw
aW5fdW5sb2NrX2JoKCZzZXNzaW9uLT5mcndkX2xvY2spOworICAgIHNwaW5fbG9ja19iaCgmc2Vz
c2lvbi0+YmFja19sb2NrKTsKICAgICBmYWlsX21nbXRfdGFza3Moc2Vzc2lvbiwgY29ubik7Cisg
ICAgc3Bpbl91bmxvY2tfYmgoJnNlc3Npb24tPmJhY2tfbG9jayk7CisgICAgc3Bpbl9sb2NrX2Jo
KCZzZXNzaW9uLT5mcndkX2xvY2spOwogICAgIG1lbXNldCgmY29ubi0+dG1oZHIsIDAsIHNpemVv
Zihjb25uLT50bWhkcikpOwogICAgIHNwaW5fdW5sb2NrX2JoKCZzZXNzaW9uLT5mcndkX2xvY2sp
OwogICAgIG11dGV4X3VubG9jaygmc2Vzc2lvbi0+ZWhfbXV0ZXgpOwo=
--089e082e09a0efb1d8056bcd69eb--

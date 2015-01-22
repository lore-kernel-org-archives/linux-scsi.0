From: Gavin Guo <gavin.guo@canonical.com>
Subject: Re: General protection fault in iscsi_rx_thread_pre_handler
Date: Thu, 22 Jan 2015 23:56:17 +0800
Message-ID: <CA+eFSM3H2zO7+bQBd7jO2sjB-MWjGNfGTeqDZDY_8_ruzj_Q_Q@mail.gmail.com>
References: <CA+eFSM1iir5QYsUALigzwcCPiqDGaNKBVq22unydN+-uTxZD2Q@mail.gmail.com>
	<1421920228.7061.48.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421920228.7061.48.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Nicolas,

On Thu, Jan 22, 2015 at 5:50 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Hi Gavin,
>
> On Thu, 2015-01-22 at 06:38 +0800, Gavin Guo wrote:
>> Hi all,
>>
>> The general protection fault screenshot is attached.
>>
>> Summary:
>> The kernel is Ubuntu-3.13.0-39.66. I've done basic analysis and foun=
d
>> the fault is in list_del of iscsi_del_ts_from_active_list. And it
>> looks like deleting the iscsi_thread_set *ts two times. The point to
>> delete including iscsi_get_ts_from_inactive_list, was also checked b=
ut
>> still can't find the clue. Really appreciate if anyone can provide a=
ny
>> idea on the bug.
>>
>> static void iscsi_del_ts_from_active_list(struct iscsi_thread_set *t=
s)
>> {
>> <...>
>> list_del(&ts->ts_list);
>> <...>
>> }
>> static inline void list_del(struct list_head *entry)
>> {
>> __list_del(entry->prev, entry->next);
>> entry->next =3D LIST_POISON1;
>> entry->prev =3D LIST_POISON2;
>> }
>>
>>
>> static inline void __list_del(struct list_head * prev, struct list_h=
ead * next)
>> {
>> next->prev =3D prev;
>> prev->next =3D next;
>> }
>>
>> According coredump is trace3.png. The %rdx is ts->ts_list->next
>> (0xdead000000100100, LIST_POISON1), %rax is ts->ts_list->prev
>> (0xdead000000200200, LIST_POISON2). When the =E2=80=9Cnext->prev =3D=
 prev;=E2=80=9D
>> executes, it=E2=80=99s the instruction:
>>
>> 48 89 42 08 mov %rax,0x8(%rdx)
>>
>> The %rdx is the value (0xdead000000100100, LIST_POISON1). So, genera=
l
>> protection fault happened. List_del() is the one of the only three
>> points to set LIST_POISON1/2. The other two are hlist_bl_del() and
>> hlist_del(). The root cause has high possibility related to calling
>> __list_del() twice for deleting the ts->ts_list.
>>
>> Detailed analysis:
>>
>> 00000000000057a0 <iscsi_del_ts_from_active_list>:
>> __list_del():
>> /build/buildd/linux-3.13.0/drivers/target/iscsi/iscsi_target_tq.c:50
>> 57a0: e8 00 00 00 00 callq 57a5 <iscsi_del_ts_from_active_list+0
>> x5>
>> list_del():
>> 57a5: 55 push %rbp
>> 57a6: 48 89 e5 mov %rsp,%rbp
>> 57a9: 53 push %rbx
>> 57aa: 48 89 fb mov %rdi,%rbx <--iscsi_thread_set *ts
>> /build/buildd/linux-3.13.0/include/linux/spinlock.h:293
>> 57ad: 48 c7 c7 00 00 00 00 mov $0x0,%rdi
>> 57b4: e8 00 00 00 00 callq 57b9 <iscsi_del_ts_from_active_list+0
>> x19>
>>
>> __list_del(entry->prev, entry->next);
>>
>> /build/buildd/linux-3.13.0/include/linux/list.h:106
>> 57b9: 48 8b 83 c8 00 00 00 mov 0xc8(%rbx),%rax <--ts->ts_list->prev
>> 57c0: 48 8b 93 c0 00 00 00 mov 0xc0(%rbx),%rdx <--ts->ts_list->next
>> iscsi_del_ts_from_active_list():
>> /build/buildd/linux-3.13.0/include/linux/spinlock.h:333
>> 57c7: 48 c7 c7 00 00 00 00 mov $0x0,%rdi
>> /build/buildd/linux-3.13.0/include/linux/list.h:88
>> 57ce: 48 89 42 08 mov %rax,0x8(%rdx) ts->ts_list->next->prev =3D ts-=
>ts_list->prev
>> spin_unlock():
>> /build/buildd/linux-3.13.0/include/linux/list.h:89
>> 57d2: 48 89 10 mov %rdx,(%rax) ts->ts_list->prev->next =3D ts->ts_li=
st->next
>>
>> entry->next =3D LIST_POISON1;
>>
>> /build/buildd/linux-3.13.0/include/linux/list.h:107
>> 57d5: 48 b8 00 01 10 00 00 movabs $0xdead000000100100,%rax
>> 57dc: 00 ad de
>> iscsi_del_ts_from_active_list():
>> 57df: 48 89 83 c0 00 00 00 mov %rax,0xc0(%rbx)
>>
>> entry->prev =3D LIST_POISON2;
>>
>> iscsi_deallocate_thread_one():
>> /build/buildd/linux-3.13.0/include/linux/list.h:108
>> 57e6: 48 b8 00 02 20 00 00 movabs $0xdead000000200200,%rax
>> 57ed: 00 ad de
>> 57f0: 48 89 83 c8 00 00 00 mov %rax,0xc8(%rbx)
>>
>
> Thanks for your detailed analysis.
>
> A similar bug was reported off-list some months back by a person usin=
g
> iser-target + RoCE export on v3.12.y code.  Just to confirm, your
> environment is using traditional iscsi-target + TCP export, right..?

I am sorry that I'm not an expert of the field and already google RoCE
on the internet but still don't really know what RoCE is. However, I
can provide the informations.  We used iscsiadm on the initiator side
and lio_node and tcm_node commands to create the targets for
connection. I think it should be normal  iscsi-target using TCP
export.

>
> At the time, a different set of iser-target related changes ended up
> avoiding this issue on his particular setup, so we thought it was lik=
ely
> a race triggered by login failures specific to iser-target code.
>
> There was a untested patch (included inline below) to drop the legacy
> active_ts_list usage all-together, but IIRC he was not able to reprod=
uce
> further so the patch didn't get picked up for mainline.
>
> If your able to reliability reproduce, please try with the following
> patch and let us know your progress.

Thanks for your time reading the mail. I'll let you know the result.

>
> Thank you,
>
> --nab
>
> From 33f211fcf0f4149b13de826dcbe204241f71b2e8 Mon Sep 17 00:00:00 200=
1
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Thu, 22 Jan 2015 00:56:53 -0800
> Subject: [PATCH] iscsi-target: Drop problematic active_ts_list usage
>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/iscsi/iscsi_target_tq.c | 28 +++++-------------------=
----
>  1 file changed, 5 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_tq.c b/drivers/target/=
iscsi/iscsi_target_tq.c
> index 601e9cc..bb2890e 100644
> --- a/drivers/target/iscsi/iscsi_target_tq.c
> +++ b/drivers/target/iscsi/iscsi_target_tq.c
> @@ -24,36 +24,22 @@
>  #include "iscsi_target_tq.h"
>  #include "iscsi_target.h"
>
> -static LIST_HEAD(active_ts_list);
>  static LIST_HEAD(inactive_ts_list);
> -static DEFINE_SPINLOCK(active_ts_lock);
>  static DEFINE_SPINLOCK(inactive_ts_lock);
>  static DEFINE_SPINLOCK(ts_bitmap_lock);
>
> -static void iscsi_add_ts_to_active_list(struct iscsi_thread_set *ts)
> -{
> -       spin_lock(&active_ts_lock);
> -       list_add_tail(&ts->ts_list, &active_ts_list);
> -       iscsit_global->active_ts++;
> -       spin_unlock(&active_ts_lock);
> -}
> -
>  static void iscsi_add_ts_to_inactive_list(struct iscsi_thread_set *t=
s)
>  {
> +       if (!list_empty(&ts->ts_list)) {
> +               WARN_ON(1);
> +               return;
> +       }
>         spin_lock(&inactive_ts_lock);
>         list_add_tail(&ts->ts_list, &inactive_ts_list);
>         iscsit_global->inactive_ts++;
>         spin_unlock(&inactive_ts_lock);
>  }
>
> -static void iscsi_del_ts_from_active_list(struct iscsi_thread_set *t=
s)
> -{
> -       spin_lock(&active_ts_lock);
> -       list_del(&ts->ts_list);
> -       iscsit_global->active_ts--;
> -       spin_unlock(&active_ts_lock);
> -}
> -
>  static struct iscsi_thread_set *iscsi_get_ts_from_inactive_list(void=
)
>  {
>         struct iscsi_thread_set *ts;
> @@ -66,7 +52,7 @@ static struct iscsi_thread_set *iscsi_get_ts_from_i=
nactive_list(void)
>
>         ts =3D list_first_entry(&inactive_ts_list, struct iscsi_threa=
d_set, ts_list);
>
> -       list_del(&ts->ts_list);
> +       list_del_init(&ts->ts_list);
>         iscsit_global->inactive_ts--;
>         spin_unlock(&inactive_ts_lock);
>
> @@ -204,8 +190,6 @@ static void iscsi_deallocate_extra_thread_sets(vo=
id)
>
>  void iscsi_activate_thread_set(struct iscsi_conn *conn, struct iscsi=
_thread_set *ts)
>  {
> -       iscsi_add_ts_to_active_list(ts);
> -
>         spin_lock_bh(&ts->ts_state_lock);
>         conn->thread_set =3D ts;
>         ts->conn =3D conn;
> @@ -397,7 +381,6 @@ struct iscsi_conn *iscsi_rx_thread_pre_handler(st=
ruct iscsi_thread_set *ts)
>
>         if (ts->delay_inactive && (--ts->thread_count =3D=3D 0)) {
>                 spin_unlock_bh(&ts->ts_state_lock);
> -               iscsi_del_ts_from_active_list(ts);
>
>                 if (!iscsit_global->in_shutdown)
>                         iscsi_deallocate_extra_thread_sets();
> @@ -452,7 +435,6 @@ struct iscsi_conn *iscsi_tx_thread_pre_handler(st=
ruct iscsi_thread_set *ts)
>
>         if (ts->delay_inactive && (--ts->thread_count =3D=3D 0)) {
>                 spin_unlock_bh(&ts->ts_state_lock);
> -               iscsi_del_ts_from_active_list(ts);
>
>                 if (!iscsit_global->in_shutdown)
>                         iscsi_deallocate_extra_thread_sets();
> --
> 1.9.1
>

From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Fri, 9 Mar 2012 02:18:41 +0530
Message-ID: <CAOD=uF5Ngu+0mBUc63aHRNCyL254a19pXpwymHYdemmUTKK7Ng@mail.gmail.com>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>
	<528D7E8A-B2F6-4EDB-A7C0-E0BF494038D0@xyratex.com>
	<CAOD=uF4+F7MYO0cqd7ogmc=K9jtE5DX3wDoMv1eTxFq48JCX2g@mail.gmail.com>
	<FA58CA70-02BE-4CCD-855C-4C5CE28EA1B2@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FA58CA70-02BE-4CCD-855C-4C5CE28EA1B2@xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: Jack Wang <jack_wang@usish.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

I did changes as per Mark's  suggestion.

The following patch is only for review not a formal one.
After getting reviewed, I will send a formal patch


diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8=
001_hwi.c
index 3619f6e..9d82ee5 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2093,6 +2093,7 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
        struct ata_task_resp *resp ;
        u32 *sata_resp;
        struct pm8001_device *pm8001_dev;
+       unsigned long flags;

        psataPayload =3D (struct sata_completion_resp *)(piomb + 4);
        status =3D le32_to_cpu(psataPayload->status);
@@ -2382,26 +2383,26 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
                ts->stat =3D SAS_DEV_NO_RESPONSE;
                break;
        }
-       spin_lock_irq(&t->task_state_lock);
+       spin_lock_irqsave(&t->task_state_lock, flags);
        t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;
        t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;
        t->task_state_flags |=3D SAS_TASK_STATE_DONE;
        if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-               spin_unlock_irq(&t->task_state_lock);
+               spin_unlock_irqrestore(&t->task_state_lock, flags);
                PM8001_FAIL_DBG(pm8001_ha,
                        pm8001_printk("task 0x%p done with io_status 0x=
%x"
                        " resp 0x%x stat 0x%x but aborted by upper laye=
r!\n",
                        t, status, ts->resp, ts->stat));
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
        } else if (t->uldd_task) {
-               spin_unlock_irq(&t->task_state_lock);
+               spin_unlock_irqrestore(&t->task_state_lock, flags);
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                mb();/* ditto */
                spin_unlock_irq(&pm8001_ha->lock);
                t->task_done(t);
                spin_lock_irq(&pm8001_ha->lock);
        } else if (!t->uldd_task) {
-               spin_unlock_irq(&t->task_state_lock);
+               spin_unlock_irqrestore(&t->task_state_lock, flags);
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                mb();/*ditto*/
                spin_unlock_irq(&pm8001_ha->lock);
@@ -2423,6 +2424,7 @@ static void mpi_sata_event(struct
pm8001_hba_info *pm8001_ha , void *piomb)
        u32 tag =3D le32_to_cpu(psataPayload->tag);
        u32 port_id =3D le32_to_cpu(psataPayload->port_id);
        u32 dev_id =3D le32_to_cpu(psataPayload->device_id);
+       unsigned long flags;

        ccb =3D &pm8001_ha->ccb_info[tag];
        t =3D ccb->task;
@@ -2593,26 +2595,26 @@ static void mpi_sata_event(struct
pm8001_hba_info *pm8001_ha , void *piomb)
                ts->stat =3D SAS_OPEN_TO;
                break;
        }
-       spin_lock_irq(&t->task_state_lock);
+       spin_lock_irqsave(&t->task_state_lock, flags);
        t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;
        t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;
        t->task_state_flags |=3D SAS_TASK_STATE_DONE;
        if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-               spin_unlock_irq(&t->task_state_lock);
+               spin_unlock_irqrestore(&t->task_state_lock, flags);
                PM8001_FAIL_DBG(pm8001_ha,
                        pm8001_printk("task 0x%p done with io_status 0x=
%x"
                        " resp 0x%x stat 0x%x but aborted by upper laye=
r!\n",
                        t, event, ts->resp, ts->stat));
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
        } else if (t->uldd_task) {
-               spin_unlock_irq(&t->task_state_lock);
+               spin_unlock_irqrestore(&t->task_state_lock, flags);
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                mb();/* ditto */
                spin_unlock_irq(&pm8001_ha->lock);
                t->task_done(t);
                spin_lock_irq(&pm8001_ha->lock);
        } else if (!t->uldd_task) {
-               spin_unlock_irq(&t->task_state_lock);
+               spin_unlock_irqrestore(&t->task_state_lock, flags);
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                mb();/*ditto*/
                spin_unlock_irq(&pm8001_ha->lock);



Regards
Santosh

On Thu, Mar 8, 2012 at 10:41 PM, Mark Salyzyn <mark_salyzyn@xyratex.com=
> wrote:
> Comments embedded
>
> On Mar 8, 2012, at 11:50 AM, santosh prasad nayak wrote:
>
>> Hi Mark,
>>
>> Thanks for your review.
>>
>> Few queries:
>>
>> 1. Similar changes have been made in mpi_sata_completion() surroundi=
ng
>> spin_*lock_irq*(&t->task->state_lock)
>> =A0 =A0Should those changes also need to revert back ?
>
> I was talking generically, yes, in both set of functions, everything =
associated with the task_state_lock. The change as described needs to b=
e applied to both sets of functions.
>
>>> The change you did was not inert, and result in the IRQ being disab=
led upon exit should a
>>> SAS_TASK_STATE_ABORTED task state condition occur then following bl=
ock will enable IRQ.
>>
>> 2. =A0I could not get this point.
>> =A0 =A0 If "SAS_TASK_STATE_ABORTED" task state condition occurs then=
 following
>> =A0 =A0 block will enable IRQ.
>>
>> =A0 =A0 =A0 =A0 =A0if (unlikely((t->task_state_flags & SAS_TASK_STAT=
E_ABORTED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irq(&t->task_state_lock);
>> =A0 =A0 =A0 =A0 =A0 // =A0 HERE IRQ will be enabled.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.......
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pm8001_ccb_task_free(pm8001_ha, t, cc=
b, tag);
>> =A0 =A0 =A0 =A0 =A0}
>
> Exactly, the IRQ is enabled, then the routine exits. All other paths =
leave the IRQ disabled (with a spin_lock_irq()).
>
>> 3. =A0How bad =A0will be "spin_lock_irq / spin_unlock_irq" in this c=
ase compared to
>> =A0 =A0 "spin_lock_irqsave / spin_unlock_irqrestore "
>
> Efficiency is not so much the requirement, but correctness. Yes, a sp=
in_unlock(&t->task_state_lock) will do, but the 'world' likes to see th=
e balance of flag save/restore, one should NOT make the assumption the =
interrupt is enabled or disabled upon entry, and should preserve such u=
pon exit.
>
> Given this statement, perhaps for the case of the hacks surrounding t=
he completion handler calls and host locks, one would do a save of the =
irq, unlock with irq enabled, lock, and then restore it back to the val=
ue upon entry. This is balanced. Your changes make the (correct) assump=
tion that the irq is disabled upon entry. But pedantically incorrect, I=
'd take the extra steps, but I do not view that as a critical deficienc=
y in your patch.
>
>> Regards
>> Santosh
>>
>>>
>>> I propose (annotated below) you leave the flags automatic variable,=
 but uninitialized. The changes surrounding spin_*lock_irq*(&pm8001_ha-=
>lock, flags) are OK, but revert back the changes surrounding the spin_=
*lock_irq*(&t->task->state_lock,flags) so that lock would be properly n=
ested.
>>>
>>> To be pedantic, and to be more correct, this code should have spawn=
ed a work queue task to perform the t->task_done(t) operation in a sepa=
rate thread rather than inline and precariously unlocked; but that woul=
d be beyond the scope of these changes and should be left for future wo=
rk to decide if it is even necessary. Not sure how such a change would =
affect performance (using the work queue) ... so I am 'afraid' of pushi=
ng such a change in any case given the relatively reliable operation of=
 this driver (and the dynamic nature of the changes Dan is making to th=
e SATA side of things for instance ;-} ).
>>>
>>> I am sorry for taking so long to get to the task of reviewing this =
(and the previous) code. I look forward to your comments.
>>>
>>> Sincerely -- Mark Salyzyn
>>>
>>> On Feb 26, 2012, at 8:33 AM, santosh nayak wrote:
>>>
>>>> @@ -2207,7 +2206,6 @@ mpi_sata_completion(struct pm8001_hba_info *=
pm8001_ha, void *piomb)
>>>> static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , voi=
d *piomb)
>>>> {
>>>> =A0 =A0 =A0 struct sas_task *t;
>>>> - =A0 =A0 unsigned long flags =3D 0;
>>> MGS> =A0 =A0unsigned long flags;
>>>> =A0 =A0 =A0 struct task_status_struct *ts;
>>>> =A0 =A0 =A0 struct pm8001_ccb_info *ccb;
>>>> =A0 =A0 =A0 struct pm8001_device *pm8001_dev;
>>>> @@ -2287,9 +2285,9 @@ static void mpi_sata_event(struct pm8001_hba=
_info *pm8001_ha , void *piomb)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ts->stat =3D SAS_QUEUE=
_FULL;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_ccb_task_free(p=
m8001_ha, t, ccb, tag);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb();/*ditto*/
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&=
pm8001_ha->lock, flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&pm8001_=
ha->lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&pm800=
1_ha->lock, flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irq(&pm8001_ha=
->lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>>>> @@ -2387,31 +2385,31 @@ static void mpi_sata_event(struct pm8001_h=
ba_info *pm8001_ha , void *piomb)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ts->stat =3D SAS_OPEN_TO;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>>>> =A0 =A0 =A0 }
>>>> - =A0 =A0 spin_lock_irqsave(&t->task_state_lock, flags);
>>>> + =A0 =A0 spin_lock_irq(&t->task_state_lock);
>>> MGS> =A0 =A0spin_lock_irqsave(&t->task_state_lock, flags);
>>>> =A0 =A0 =A0 t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;
>>>> =A0 =A0 =A0 t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;
>>>> =A0 =A0 =A0 t->task_state_flags |=3D SAS_TASK_STATE_DONE;
>>>> =A0 =A0 =A0 if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABO=
RTED))) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&t->task_state_lo=
ck, flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&t->task_state_lock);
>>> MGS> =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&t->task_state_l=
ock, flags);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 PM8001_FAIL_DBG(pm8001_ha,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_printk("task 0x=
%p done with io_status 0x%x"
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " resp 0x%x stat 0x%x =
but aborted by upper layer!\n",
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t, event, ts->resp, ts=
->stat));
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_ccb_task_free(pm8001_ha, t, ccb=
, tag);
>>>> =A0 =A0 =A0 } else if (t->uldd_task) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&t->task_state_lo=
ck, flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&t->task_state_lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_ccb_task_free(pm8001_ha, t, ccb=
, tag);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb();/* ditto */
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&pm8001_ha->lock,=
 flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&pm8001_ha->lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&pm8001_ha->lock, flag=
s);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irq(&pm8001_ha->lock);
>>>> =A0 =A0 =A0 } else if (!t->uldd_task) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&t->task_state_lo=
ck, flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&t->task_state_lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_ccb_task_free(pm8001_ha, t, ccb=
, tag);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb();/*ditto*/
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&pm8001_ha->lock,=
 flags);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&pm8001_ha->lock);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&pm8001_ha->lock, flag=
s);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irq(&pm8001_ha->lock);
>>>> =A0 =A0 =A0 }
>>>> }
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-jani=
tors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 10/24] aacraid: Reworked aac_command_thread
Date: Mon, 30 Jan 2017 20:11:54 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6D7B@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-11-RaghavaAditya.Renukunta@microsemi.com>
 <20170130101128.GG3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0061.outbound.protection.outlook.com ([104.47.36.61]:57546
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752925AbdA3UL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:11:57 -0500
In-Reply-To: <20170130101128.GG3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 2:11 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 10/24] aacraid: Reworked aac_command_thread
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:39AM -0800, Raghava Aditya Renukunta wrote:
> > Reworked aac_command_thread into aac_process_events
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> Wow, thanks for factoring this out.
>=20
> > +static void aac_process_events(struct aac_dev *dev)
> > +{
> > +     struct hw_fib *hw_fib, *hw_newfib;
> > +     struct fib *fib, *newfib;
> > +     struct aac_fib_context *fibctx;
> > +     unsigned long flags;
> > +     spinlock_t *t_lock;
> > +
>=20
>         t_lock =3D dev->queues->queue[HostNormCmdQueue].lock;
>         spin_lock_irqsave(t_lock, flags);

Yes, let me change this peace of code.

> > +     spin_lock_irqsave(dev->queues->queue[HostNormCmdQueue].lock,
> flags);
> > +     while (!list_empty(&(dev->queues-
> >queue[HostNormCmdQueue].cmdq))) {
> > +             struct list_head *entry;
> > +             struct aac_aifcmd *aifcmd;
> > +             u32 time_now, time_last;
> > +             unsigned long flagv;
> > +             unsigned int  num;
> > +             struct hw_fib **hw_fib_pool, **hw_fib_p;
> > +             struct fib **fib_pool, **fib_p;
> > +
> > +             set_current_state(TASK_RUNNING);
> > +
> > +             entry =3D dev->queues->queue[HostNormCmdQueue].cmdq.next;
> > +             list_del(entry);
> > +
> > +
> > +             t_lock =3D dev->queues->queue[HostNormCmdQueue].lock;
> > +             spin_unlock_irqrestore(t_lock, flags);
> > +
> > +             fib =3D list_entry(entry, struct fib, fiblink);
> > +             hw_fib =3D fib->hw_fib_va;
> > +             /*
> > +              *      We will process the FIB here or pass it to a
> > +              *      worker thread that is TBD. We Really can't
> > +              *      do anything at this point since we don't have
> > +              *      anything defined for this thread to do.
> > +              */
> > +             memset(fib, 0, sizeof(struct fib));
> > +             fib->type =3D FSAFS_NTC_FIB_CONTEXT;
> > +             fib->size =3D sizeof(struct fib);
> > +             fib->hw_fib_va =3D hw_fib;
> > +             fib->data =3D hw_fib->data;
> > +             fib->dev =3D dev;
> > +             /*
> > +              *      We only handle AifRequest fibs from the adapter.
> > +              */
> > +
> > +             aifcmd =3D (struct aac_aifcmd *) hw_fib->data;
> > +             if (aifcmd->command =3D=3D cpu_to_le32(AifCmdDriverNotify=
)) {
> > +                     /* Handle Driver Notify Events */
> > +                     aac_handle_aif(dev, fib);
> > +                     *(__le32 *)hw_fib->data =3D cpu_to_le32(ST_OK);
> > +                     aac_fib_adapter_complete(fib, (u16)sizeof(u32));
> > +                     continue;
> > +             }
> > +             /*
> > +              * The u32 here is important and intended. We are using
> > +              * 32bit wrapping time to fit the adapter field
> > +              */
> > +
> > +
> > +             /* Sniff events */
> > +             if ((aifcmd->command =3D=3D cpu_to_le32(AifCmdEventNotify=
)) ||
> > +                             (aifcmd->command =3D=3D
> > +                             cpu_to_le32(AifCmdJobProgress))) {
>=20
> Parenthesis and indentation.

Yes I will make the  changes.

>=20
> > +                     aac_handle_aif(dev, fib);
> > +             }
> > +
> > +             time_now =3D jiffies/HZ;
> > +
> > +             /*
> > +              * Warning: no sleep allowed while
> > +              * holding spinlock. We take the estimate
> > +              * and pre-allocate a set of fibs outside the
> > +              * lock.
> > +              */
> > +             num =3D le32_to_cpu(dev->init->r7.adapter_fibs_size)
> > +                             / sizeof(struct hw_fib); /* some extra */
> > +             spin_lock_irqsave(&dev->fib_lock, flagv);
> > +             entry =3D dev->fib_list.next;
> > +             while (entry !=3D &dev->fib_list) {
> > +                     entry =3D entry->next;
> > +                     ++num;
> > +             }
> > +             spin_unlock_irqrestore(&dev->fib_lock, flagv);
>=20
> Bonus points for getting the estimation of the fibs into an own function.
> From
> the start of the comment till the spin_unlock().
Ok , let me do that.
>=20
> > +             hw_fib_pool =3D kmalloc_array(num, sizeof(struct hw_fib *=
),
> > +                                             GFP_KERNEL);
> > +             fib_pool =3D kmalloc_array(num, sizeof(struct fib *),
> > +                                             GFP_KERNEL);
> > +             if (num && fib_pool && hw_fib_pool) {
>=20
> Ditto for the following block (this would have the benefit of describing =
what
> the block does).
Acknowledged=20
>=20
> > +                     hw_fib_p =3D hw_fib_pool;
> > +                     fib_p =3D fib_pool;
> > +                     while (hw_fib_p < &hw_fib_pool[num]) {
> > +                             *(hw_fib_p) =3D kmalloc(sizeof(struct hw_=
fib),
> > +                                             GFP_KERNEL);
> > +                             if (!(*(hw_fib_p++))) {
> > +                                     --hw_fib_p;
> > +                                     break;
> > +                             }
> > +                             *(fib_p) =3D kmalloc(sizeof(struct fib),
> > +                                             GFP_KERNEL);
> > +                             if (!(*(fib_p++))) {
> > +                                     kfree(*(--hw_fib_p));
> > +                                     break;
> > +                             }
> > +                     }
> > +                     num =3D hw_fib_p - hw_fib_pool;
> > +                     if (!num) {
> > +                             kfree(fib_pool);
> > +                             fib_pool =3D NULL;
> > +                             kfree(hw_fib_pool);
> > +                             hw_fib_pool =3D NULL;
> > +                             continue;
> > +                     }
> > +             } else {
> > +                     kfree(hw_fib_pool);
> > +                     hw_fib_pool =3D NULL;
> > +                     kfree(fib_pool);
> > +                     fib_pool =3D NULL;
> > +             }
>=20
> And for either everything under the fib_lock or the while loop.

Acknowledged.=20

> > +             spin_lock_irqsave(&dev->fib_lock, flagv);
> > +             entry =3D dev->fib_list.next;
> > +             /*
> > +              * For each Context that is on the
> > +              * fibctxList, make a copy of the
> > +              * fib, and then set the event to wake up the
> > +              * thread that is waiting for it.
> > +              */
> > +             hw_fib_p =3D hw_fib_pool;
> > +             fib_p =3D fib_pool;
> > +             while (entry !=3D &dev->fib_list) {
> > +                     /*
> > +                      * Extract the fibctx
> > +                      */
> > +                     fibctx =3D list_entry(entry, struct aac_fib_conte=
xt,
> > +                                     next);
> > +                     /*
> > +                      * Check if the queue is getting
> > +                      * backlogged
> > +                      */
> > +                     if (fibctx->count > 20) {
> > +                             /*
> > +                              * It's *not* jiffies folks,
> > +                              * but jiffies / HZ so do not
> > +                              * panic ...
> > +                              */
> > +                             time_last =3D fibctx->jiffies;
> > +                             /*
> > +                              * Has it been > 2 minutes
> > +                              * since the last read off
> > +                              * the queue?
> > +                              */
> > +                             if ((time_now - time_last) > aif_timeout)=
 {
> > +                                     entry =3D entry->next;
> > +                                     aac_close_fib_context(dev, fibctx=
);
> > +                                     continue;
> > +                             }
> > +                     }
> > +                     /*
> > +                      * Warning: no sleep allowed while
> > +                      * holding spinlock
> > +                      */
> > +                     if (hw_fib_p < &hw_fib_pool[num]) {
> > +                             hw_newfib =3D *hw_fib_p;
> > +                             *(hw_fib_p++) =3D NULL;
> > +                             newfib =3D *fib_p;
> > +                             *(fib_p++) =3D NULL;
> > +                             /*
> > +                              * Make the copy of the FIB
> > +                              */
> > +                             memcpy(hw_newfib, hw_fib,
> > +                                     sizeof(struct hw_fib));
> > +                             memcpy(newfib, fib, sizeof(struct fib));
> > +                             newfib->hw_fib_va =3D hw_newfib;
> > +                             /*
> > +                              * Put the FIB onto the
> > +                              * fibctx's fibs
> > +                              */
> > +                             list_add_tail(&newfib->fiblink,
> > +                                     &fibctx->fib_list);
> > +                             fibctx->count++;
> > +                             /*
> > +                              * Set the event to wake up the
> > +                              * thread that is waiting.
> > +                              */
> > +                             up(&fibctx->wait_sem);
> > +                     } else {
> > +                             pr_warn("aifd: didn't allocate NewFib.\n"=
);
> > +                     }
> > +                     entry =3D entry->next;
> > +             }
> > +             /*
> > +              *      Set the status of this FIB
> > +              */
> > +             *(__le32 *)hw_fib->data =3D cpu_to_le32(ST_OK);
> > +             aac_fib_adapter_complete(fib, sizeof(u32));
> > +             spin_unlock_irqrestore(&dev->fib_lock, flagv);
> > +             /* Free up the remaining resources */
> > +             hw_fib_p =3D hw_fib_pool;
> > +             fib_p =3D fib_pool;
> > +             while (hw_fib_p < &hw_fib_pool[num]) {
> > +                     kfree(*hw_fib_p);
> > +                     kfree(*fib_p);
> > +                     ++fib_p;
> > +                     ++hw_fib_p;
> > +             }
> > +             kfree(hw_fib_pool);
> > +             kfree(fib_pool);
> > +             kfree(fib);
> > +             spin_lock_irqsave(dev->queues-
> >queue[HostNormCmdQueue].lock,
> > +                             flags);
> > +     }
> > +     /*
> > +      *      There are no more AIF's
> > +      */
> > +     spin_unlock_irqrestore(dev->queues-
> >queue[HostNormCmdQueue].lock,
> > +                     flags);
> > +}
>=20
> [...]
>=20
> Thanks,
> this change is highly appreciated by me
>=20
>         Johannes
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

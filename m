From: Martin Wilck <mwilck@suse.com>
Subject: Re: work queue of scsi fc transports should be serialized
Date: Mon, 22 May 2017 22:04:43 +0200
Message-ID: <1495483483.28992.25.camel@suse.com>
References: <23B7B563BA4E9446B962B142C86EF24A088AE2FB@CNMAILEX03.lenovo.com>
         <1495233163.2581.5.camel@sandisk.com>
         <23B7B563BA4E9446B962B142C86EF24A088AF8B0@CNMAILEX03.lenovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <23B7B563BA4E9446B962B142C86EF24A088AF8B0@CNMAILEX03.lenovo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dashi DS1 Cao <caods1@lenovo.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-05-20 at 08:25 +0000, Dashi DS1 Cao wrote:
> On Fri, 2017-05-19 at 09:36 +0000, Dashi DS1 Cao wrote:
> > It seems there is a race of multiple "fc_starget_delete" of the
> > same 
> > rport, thus of the same SCSI host. The race leads to the race of 
> > scsi_remove_target and it cannot be prevented by the code snippet 
> > alone, even of the most recent
> > version:
> >         spin_lock_irqsave(shost->host_lock, flags);
> >         list_for_each_entry(starget, &shost->__targets, siblings) {
> >                 if (starget->state == STARGET_DEL ||
> >                     starget->state == STARGET_REMOVE)
> >                         continue;
> > If there is a possibility that the starget is under deletion(state
> > == 
> > STARGET_DEL), it should be possible that list_next_entry(starget, 
> > siblings) could cause a read access violation.
> > Hello Dashi,
> > Something else must be going on. From scsi_remove_target():
> > restart:
> > 	spin_lock_irqsave(shost->host_lock, flags);
> > 	list_for_each_entry(starget, &shost->__targets, siblings) {
> > 		if (starget->state == STARGET_DEL ||
> > 		    starget->state == STARGET_REMOVE)
> > 			continue;
> > 		if (starget->dev.parent == dev || &starget->dev == dev)
> > {
> > 			kref_get(&starget->reap_ref);
> > 			starget->state = STARGET_REMOVE;
> > 			spin_unlock_irqrestore(shost->host_lock,
> > flags);
> > 			__scsi_remove_target(starget);
> > 			scsi_target_reap(starget);
> > 			goto restart;
> > 		}
> > 	}
> > 	spin_unlock_irqrestore(shost->host_lock, flags);
> > In other words, before scsi_remove_target() decides to call
> > __scsi_remove_target(), it changes the target state into
> > STARGET_REMOVE while holding the host lock. 
> > This means that scsi_remove_target() won't
> > call __scsi_remove_target() twice and also that it won't invoke
> > list_next_entry(starget, siblings) after starget has been 
> > freed.
> > Bart.
> 
> In the crashes of Suse 12 sp1, the root cause is the deletion of a
> list node without holding the lock:
>         spin_lock_irqsave(shost->host_lock, flags);
>         list_for_each_entry_safe(starget, tmp, &shost->__targets,
> siblings) {
>                 if (starget->state == STARGET_DEL)
>                         continue;
>                 if (starget->dev.parent == dev || &starget->dev ==
> dev) {
>                         /* assuming new targets arrive at the end */
>                         kref_get(&starget->reap_ref);
>                         spin_unlock_irqrestore(shost->host_lock,
> flags);
> 
>                         __scsi_remove_target(starget);
>                         list_move_tail(&starget->siblings,
> &reap_list);  --this deletion from shost->__targets list is done
> without the lock.
>                         spin_lock_irqsave(shost->host_lock, flags);
>                  }
>           }
>           spin_unlock_irqrestore(shost->host_lock, flags);

I believe this is fixed in SLES12-SP1 kernel 3.12.53-60.30.1, with the
following patch:

* Mon Jan 18 2016 jthumshirn@suse.de
- scsi: restart list search after unlock in scsi_remove_target
  (bsc#944749, bsc#959257).
- Delete
  patches.fixes/0001-SCSI-Fix-hard-lockup-in-scsi_remove_target.patch.
- commit 2490876

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

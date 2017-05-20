From: Dashi DS1 Cao <caods1@lenovo.com>
Subject: RE: work queue of scsi fc transports should be serialized
Date: Sat, 20 May 2017 08:25:09 +0000
Message-ID: <23B7B563BA4E9446B962B142C86EF24A088AF8B0@CNMAILEX03.lenovo.com>
References: <23B7B563BA4E9446B962B142C86EF24A088AE2FB@CNMAILEX03.lenovo.com>
 <1495233163.2581.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:56906 "EHLO
        mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754755AbdETI0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 May 2017 04:26:01 -0400
In-Reply-To: <1495233163.2581.5.camel@sandisk.com>
Content-Language: zh-CN
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, 2017-05-19 at 09:36 +0000, Dashi DS1 Cao wrote:
> It seems there is a race of multiple "fc_starget_delete" of the same 
> rport, thus of the same SCSI host. The race leads to the race of 
> scsi_remove_target and it cannot be prevented by the code snippet 
> alone, even of the most recent
> version:
>         spin_lock_irqsave(shost->host_lock, flags);
>         list_for_each_entry(starget, &shost->__targets, siblings) {
>                 if (starget->state == STARGET_DEL ||
>                     starget->state == STARGET_REMOVE)
>                         continue;
> If there is a possibility that the starget is under deletion(state == 
> STARGET_DEL), it should be possible that list_next_entry(starget, 
> siblings) could cause a read access violation.

>Hello Dashi,

>Something else must be going on. From scsi_remove_target():

>restart:
>	spin_lock_irqsave(shost->host_lock, flags);
>	list_for_each_entry(starget, &shost->__targets, siblings) {
>		if (starget->state == STARGET_DEL ||
>		    starget->state == STARGET_REMOVE)
>			continue;
>		if (starget->dev.parent == dev || &starget->dev == dev) {
>			kref_get(&starget->reap_ref);
>			starget->state = STARGET_REMOVE;
>			spin_unlock_irqrestore(shost->host_lock, flags);
>			__scsi_remove_target(starget);
>			scsi_target_reap(starget);
>			goto restart;
>		}
>	}
>	spin_unlock_irqrestore(shost->host_lock, flags);

>In other words, before scsi_remove_target() decides to call __scsi_remove_target(), it changes the target state into STARGET_REMOVE while holding the host lock. 
>This means that scsi_remove_target() won't call __scsi_remove_target() twice and also that it won't invoke list_next_entry(starget, siblings) after starget has been 
>freed.
>Bart.

In the crashes of Suse 12 sp1, the root cause is the deletion of a list node without holding the lock:
        spin_lock_irqsave(shost->host_lock, flags);
        list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
                if (starget->state == STARGET_DEL)
                        continue;
                if (starget->dev.parent == dev || &starget->dev == dev) {
                        /* assuming new targets arrive at the end */
                        kref_get(&starget->reap_ref);
                        spin_unlock_irqrestore(shost->host_lock, flags);

                        __scsi_remove_target(starget);
                        list_move_tail(&starget->siblings, &reap_list);  --this deletion from shost->__targets list is done without the lock.
                        spin_lock_irqsave(shost->host_lock, flags);
                 }
          }
          spin_unlock_irqrestore(shost->host_lock, flags);

A better solution is as follows, without introducing more states:

restart:
        spin_lock_irqsave(shost->host_lock, flags);
        list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
                if (starget->dev.parent == dev || &starget->dev == dev) {
                        /* assuming new targets arrive at the end */
                        kref_get(&starget->reap_ref);
                        list_move_tail(&starget->siblings, &reap_list);
                        spin_unlock_irqrestore(shost->host_lock, flags);
                        __scsi_remove_target(starget);
                        goto restart;
                }
        }
        spin_unlock_irqrestore(shost->host_lock, flags);
        list_for_each_entry_safe(starget, tmp, &reap_list, siblings)
                scsi_target_reap(starget);

Another place that should be modified is the scsi_transport_fc.c:
From:
        if (rport->scsi_target_id != -1)
                fc_starget_delete(&rport->stgt_delete_work);
To:
        if (rport->scsi_target_id != -1) {
                fc_flush_work(shost);
                BUG_ON(ACCESS_ONCE(rport->scsi_target_id) != -1);
        }

Regards,
Dashi Cao

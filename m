From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] mpt3sas - remove unused fw_event_work delayed_work
Date: Fri, 01 Apr 2016 14:51:57 -0400
Message-ID: <1459536717.30035.113.camel@localhost.localdomain>
References: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbcDASwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 14:52:00 -0400
In-Reply-To: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Calvin Owens <calvinowens@fb.com>

On Fri, 2016-04-01 at 13:56 -0400, Joe Lawrence wrote:
> The driver's fw events are queued up using the the fw_event_work's
> struct work, not its delayed_work member.  The latter appears to be
> unused and may provoke CONFIG_DEBUG_OBJECTS_TIMERS "assert_init not
> available" false warnings in _scsih_fw_event_cleanup_queue.  Remove it
> and update _scsih_fw_event_cleanup_queue accordingly.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
> 
> I think this goes all the way back to the introduction of the mpt3sas
> driver.  The previous generation mpt2sas driver uses delayed_work, so
> perhaps it was simply copied and pasted into the mpt3sas but never
> updated.
> 
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index e0e4920d0fa6..67643602efbc 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -189,7 +189,6 @@ struct fw_event_work {
>  	struct list_head	list;
>  	struct work_struct	work;
>  	u8			cancel_pending_work;
> -	struct delayed_work	delayed_work;
>  
>  	struct MPT3SAS_ADAPTER *ioc;
>  	u16			device_handle;
> @@ -2804,12 +2803,12 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
>  		/*
>  		 * Wait on the fw_event to complete. If this returns 1, then
>  		 * the event was never executed, and we need a put for the
> -		 * reference the delayed_work had on the fw_event.
> +		 * reference the work had on the fw_event.
>  		 *
>  		 * If it did execute, we wait for it to finish, and the put will
>  		 * happen from _firmware_event_work()
>  		 */
> -		if (cancel_delayed_work_sync(&fw_event->delayed_work))
> +		if (cancel_work_sync(&fw_event->work))
>  			fw_event_work_put(fw_event);
>  
>  		fw_event_work_put(fw_event);

Hmm... Fixes: 146b16c8 (mpt3sas: Refcount fw_events and fix unsafe list usage)

Since mpt3sas uses ->work instead of _delayed_work this would seem to be
correct, however the deprecated mpt2sas driver had a commit that changed
the firmware event work mechanism to use ->delayed_work instead of ->work:

commit f1c35e6aea579d5bdb6dc02dfa99c67c7c3b3f67
Author: Kashyap, Desai <kashyap.desai@lsi.com>
Date:   Tue Mar 9 16:31:43 2010 +0530

    [SCSI] mpt2sas: RESCAN Barrier work is added in case of HBA reset.
    
    Add the cancel_pending_work flag from the fw_event_work structure, and then to
    set the flag during host reset, check the flag later from work threads
    context and if cancel_pending_work_flag is set ingore those events.
    
    Now Rescan after host reset is changed.
    Added special task MPT2SAS_RESCAN_AFTER_HOST_RESET. This task will be queued
    at the time of HBA reset. this task is treated as barrier. All work after
    MPT2SAS_RESCAN_AFTER_HOST_RESET will be treated as new work and will be
    server by callback handle. If host_recovery is going on while running RESCAN
    task, it will wait for shos_recovery_done completion which will be called
    from HBA reset DONE context.
    
    Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
    Reviewed-by: Eric Moore <eric.moore@lsi.com>
    Signed-off-by: James Bottomley <James.Bottomley@suse.de>

Portions of that patch include:

@@ -125,11 +127,11 @@ struct sense_info {
  */
 struct fw_event_work {
        struct list_head        list;
-       struct work_struct      work;
+       u8                      cancel_pending_work;
+       struct delayed_work     delayed_work;
        struct MPT2SAS_ADAPTER *ioc;
        u8                      VF_ID;
        u8                      VP_ID;
-       u8                      host_reset_handling;
        u8                      ignore;
        u16                     event;
        void                    *event_data;

and

@@ -2325,8 +2327,9 @@ _scsih_fw_event_add(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 
        spin_lock_irqsave(&ioc->fw_event_lock, flags);
        list_add_tail(&fw_event->list, &ioc->fw_event_list);
-       INIT_WORK(&fw_event->work, _firmware_event_work);
-       queue_work(ioc->firmware_event_thread, &fw_event->work);
+       INIT_DELAYED_WORK(&fw_event->delayed_work, _firmware_event_work);
+       queue_delayed_work(ioc->firmware_event_thread,
+           &fw_event->delayed_work, 0);
        spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
The delay argument to queue_delayed_work() is zero though.
So, Broadcom, presumably Joe's fix is the correct fix?

-Ewan




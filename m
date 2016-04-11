From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH] mpt3sas - remove unused fw_event_work delayed_work
Date: Mon, 11 Apr 2016 16:43:33 +0530
Message-ID: <c762138f15c771759b451b16d97f199e@mail.gmail.com>
References: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
	 <1459536717.30035.113.camel@localhost.localdomain>	 <56FEC864.5050008@stratus.com>
 <1459541058.30035.126.camel@localhost.localdomain> <38b26e94d10098596fb11cf9bafcb7c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:32987 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbcDKLNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 07:13:36 -0400
Received: by mail-yw0-f172.google.com with SMTP id t10so203911793ywa.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2016 04:13:35 -0700 (PDT)
In-Reply-To: <38b26e94d10098596fb11cf9bafcb7c0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, emilne@redhat.com, Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Calvin Owens <calvinowens@fb.com>

Hi,
 Please consider this patch as Ack-by: Chaitra P B
<chaitra.basappa@broadcom.com>

Thanks,
 Chaitra

-----Original Message-----
From: Sathya Prakash [mailto:sathya.prakash@broadcom.com]
Sent: Saturday, April 02, 2016 1:45 AM
To: emilne@redhat.com; Joe Lawrence
Cc: linux-scsi@vger.kernel.org; Chaitra Basappa; Suganath Prabu Subramani;
Calvin Owens
Subject: RE: [PATCH] mpt3sas - remove unused fw_event_work delayed_work

We will look into this early next week and provide a detailed response.  On
the first look this is ACK from Broadcom, will reconfirm.

-----Original Message-----
From: Ewan D. Milne [mailto:emilne@redhat.com]
Sent: Friday, April 01, 2016 2:04 PM
To: Joe Lawrence
Cc: linux-scsi@vger.kernel.org; Sathya Prakash; Chaitra P B; Suganath Prabu
Subramani; Calvin Owens
Subject: Re: [PATCH] mpt3sas - remove unused fw_event_work delayed_work

On Fri, 2016-04-01 at 15:13 -0400, Joe Lawrence wrote:
> On 04/01/2016 02:51 PM, Ewan D. Milne wrote:
> > On Fri, 2016-04-01 at 13:56 -0400, Joe Lawrence wrote:
> >> @@ -2804,12 +2803,12 @@ _scsih_fw_event_cleanup_queue(struct
> >> MPT3SAS_ADAPTER *ioc)
> >>  		/*
> >>  		 * Wait on the fw_event to complete. If this returns 1, then
> >>  		 * the event was never executed, and we need a put for the
> >> -		 * reference the delayed_work had on the fw_event.
> >> +		 * reference the work had on the fw_event.
> >>  		 *
> >>  		 * If it did execute, we wait for it to finish, and the put will
> >>  		 * happen from _firmware_event_work()
> >>  		 */
> >> -		if (cancel_delayed_work_sync(&fw_event->delayed_work))
> >> +		if (cancel_work_sync(&fw_event->work))
> >>  			fw_event_work_put(fw_event);
> >>
> >>  		fw_event_work_put(fw_event);
> >
> > Hmm... Fixes: 146b16c8 (mpt3sas: Refcount fw_events and fix unsafe
> > list usage)
>
> This could technically go back to f92363d12359 (mpt3sas: add new
> driver supporting 12GB SAS) ...  but will probably only apply cleanly
> to _scsih_fw_event_cleanup_queue after 146b16c8 (mpt3sas: Refcount
> fw_events and fix unsafe list usage), so you're right.
>
> > Since mpt3sas uses ->work instead of _delayed_work this would seem
> > to be correct, however the deprecated mpt2sas driver had a commit
> > that changed the firmware event work mechanism to use ->delayed_work
> > instead of ->work:
> >
> > commit f1c35e6aea579d5bdb6dc02dfa99c67c7c3b3f67
> > Author: Kashyap, Desai <kashyap.desai@lsi.com>
> > Date:   Tue Mar 9 16:31:43 2010 +0530
>
> Okay, so this is pre-mpt3sas split.
>
> >     [SCSI] mpt2sas: RESCAN Barrier work is added in case of HBA reset.
> >
> >     Add the cancel_pending_work flag from the fw_event_work
> > structure, and then to
> >     set the flag during host reset, check the flag later from work
> > threads
> >     context and if cancel_pending_work_flag is set ingore those events.
>
> More unused mpt2 vestiges in the mpt3 version?
>
> % cd drivers/scsi/mpt3sas/
> % grep 'cancel_pending_work' *.{c,h}
> mpt3sas_scsih.c: * @cancel_pending_work: flag set during reset handling
> mpt3sas_scsih.c:        u8                      cancel_pending_work;
>
> >     Now Rescan after host reset is changed.
> >     Added special task MPT2SAS_RESCAN_AFTER_HOST_RESET. This task
> > will be queued
> >     at the time of HBA reset. this task is treated as barrier. All
> > work after
> >     MPT2SAS_RESCAN_AFTER_HOST_RESET will be treated as new work and
> > will be
> >     server by callback handle. If host_recovery is going on while
> > running RESCAN
> >     task, it will wait for shos_recovery_done completion which will
> > be called
> >     from HBA reset DONE context.
>
> FWIW, I don't see anything like this in today's mpt3sas driver.

Well, that's the question.  Is there some functionality missing?  Were the
changes abandoned/replaced?  mpt2sas used delayed_work for something else,
so maybe that's why the firmware event changes initially used it (albeit
with a 0 delay) but it's hard to know...

cancel_delayed_work() will call del_timer() on delayed_work->timer, but it
looks like kzalloc is used to allocate the fw_event_work objects so perhaps
nothing bad will happen.  I was wondering, though, because I have seen dumps
of hung systems with requests that should have timed out but are not on any
timer list.

-Ewan

>
> Regards,
>
> -- Joe

From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 4/9] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and
 scsi_event to sdev_event
Date: Wed, 23 Jan 2013 15:39:39 -0500
Message-ID: <1358973579.4420.341.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <1358526434-1173-5-git-send-email-emilne@redhat.com>
	 <CAO+b5-rqzcvLX6HhQUS4_feEy4u2PxL0kn0ZmsvP+AX5tG3-mQ@mail.gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3AWUjl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2013 15:39:41 -0500
In-Reply-To: <CAO+b5-rqzcvLX6HhQUS4_feEy4u2PxL0kn0ZmsvP+AX5tG3-mQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2013-01-22 at 10:38 -0700, Bart Van Assche wrote:
> On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> > @@ -2206,7 +2206,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
> >   *     Dispatch queued events to their associated scsi_device kobjects
> >   *     as uevents.
> >   */
> > -void scsi_evt_thread(struct work_struct *work)
> > +void sdev_evt_thread(struct work_struct *work)
> >  {
> >         struct scsi_device *sdev;
> >         LIST_HEAD(event_list);
> > @@ -2214,7 +2214,7 @@ void scsi_evt_thread(struct work_struct *work)
> >         sdev = container_of(work, struct scsi_device, event_work);
> >
> >         while (1) {
> > -               struct scsi_event *evt;
> > +               struct sdev_event *evt;
> >                 struct list_head *this, *tmp;
> >                 unsigned long flags;
> >
> > @@ -2226,9 +2226,9 @@ void scsi_evt_thread(struct work_struct *work)
> >                         break;
> >
> >                 list_for_each_safe(this, tmp, &event_list) {
> > -                       evt = list_entry(this, struct scsi_event, node);
> > +                       evt = list_entry(this, struct sdev_event, node);
> >                         list_del(&evt->node);
> > -                       scsi_evt_emit(sdev, evt);
> > +                       sdev_evt_emit(sdev, evt);
> >                         kfree(evt);
> >                 }
> >         }
> 
> If schedule_work() gets invoked if work is already on a workqueue then
> it will return immediately. Does that mean that the above approach for
> processing the event list is racy and that new events will not get
> processed if schedule_work() is invoked after the while loop finished
> but before the above function returns ?

I thought that the way that the workqueue mechanism did this was that
the work struct was removed from the list and WORK_STRUCT_PENDING_BIT
was cleared in the work_struct before the work function was invoked.

In that case I the code should be OK since the work function will have
to take the lock which is held around the code to add the event to the
list and the call to schedule_work().

But I see your point, and I since I just added more SDEV_EVT_xxx codes
(and an STARGET_EVT_xxx code, which uses the same mechanism), I didn't
inspect this code carefully.  I'll give it some more thought.

It seems to me that the workqueue mechanism would be hard to use if
there weren't some guarantee against the race condition you mention.

> Bart.

Thank you for your comments.



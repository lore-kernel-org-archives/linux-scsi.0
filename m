From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH RFC 4/9] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and
 scsi_event to sdev_event
Date: Tue, 22 Jan 2013 10:38:40 -0700
Message-ID: <CAO+b5-rqzcvLX6HhQUS4_feEy4u2PxL0kn0ZmsvP+AX5tG3-mQ@mail.gmail.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	<1358526434-1173-5-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50131 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3AVRik (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2013 12:38:40 -0500
Received: by mail-oa0-f48.google.com with SMTP id h2so7484791oag.21
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jan 2013 09:38:40 -0800 (PST)
In-Reply-To: <1358526434-1173-5-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> @@ -2206,7 +2206,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>   *     Dispatch queued events to their associated scsi_device kobjects
>   *     as uevents.
>   */
> -void scsi_evt_thread(struct work_struct *work)
> +void sdev_evt_thread(struct work_struct *work)
>  {
>         struct scsi_device *sdev;
>         LIST_HEAD(event_list);
> @@ -2214,7 +2214,7 @@ void scsi_evt_thread(struct work_struct *work)
>         sdev = container_of(work, struct scsi_device, event_work);
>
>         while (1) {
> -               struct scsi_event *evt;
> +               struct sdev_event *evt;
>                 struct list_head *this, *tmp;
>                 unsigned long flags;
>
> @@ -2226,9 +2226,9 @@ void scsi_evt_thread(struct work_struct *work)
>                         break;
>
>                 list_for_each_safe(this, tmp, &event_list) {
> -                       evt = list_entry(this, struct scsi_event, node);
> +                       evt = list_entry(this, struct sdev_event, node);
>                         list_del(&evt->node);
> -                       scsi_evt_emit(sdev, evt);
> +                       sdev_evt_emit(sdev, evt);
>                         kfree(evt);
>                 }
>         }

If schedule_work() gets invoked if work is already on a workqueue then
it will return immediately. Does that mean that the above approach for
processing the event list is racy and that new events will not get
processed if schedule_work() is invoked after the while loop finished
but before the above function returns ?

Bart.

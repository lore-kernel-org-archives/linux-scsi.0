From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v2] mptsas: fix depth param in scsi_track_queue_full
Date: Thu, 4 Jun 2015 14:23:19 +0530
Message-ID: <CAK=zhgqeHZbNyciBgAm8dQAz-CKB73K8USR1W2-iTUWW+fxc3g@mail.gmail.com>
References: <1433345822-14113-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36080 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbFDIxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 04:53:20 -0400
Received: by wgbgq6 with SMTP id gq6so28117959wgb.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2015 01:53:19 -0700 (PDT)
In-Reply-To: <1433345822-14113-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

This patch looks good, please consider this patch as Acked-by:
"Sreekanth Reddy" <Sreekanth.reddy@avagotech.com>.

Regards,
Sreekanth

On Wed, Jun 3, 2015 at 9:07 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> v2: use debug log level to silence the unsurprising information
>
> v1: A user of scsi_track_queue_full should pass to the function
> a constant value untill the queue-depth changes, otherwise the
> internal logic in scsi_track_queue_full rejects the change.
> Other users of this function use a 'sdev->queue_depth - 1'
> as depth parameter, let's do the same.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/message/fusion/mptsas.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 551262e4b9..fe8f277567 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -4096,7 +4096,7 @@ mptsas_handle_queue_full_event(struct fw_event_work *fw_event)
>                                         continue;
>                                 }
>                                 depth = scsi_track_queue_full(sdev,
> -                                   current_depth - 1);
> +                                       sdev->queue_depth - 1);
>                                 if (depth > 0)
>                                         sdev_printk(KERN_INFO, sdev,
>                                         "Queue depth reduced to (%d)\n",
> @@ -4106,7 +4106,7 @@ mptsas_handle_queue_full_event(struct fw_event_work *fw_event)
>                                         "Tagged Command Queueing is being "
>                                         "disabled\n");
>                                 else if (depth == 0)
> -                                       sdev_printk(KERN_INFO, sdev,
> +                                       sdev_printk(KERN_DEBUG, sdev,
>                                         "Queue depth not changed yet\n");
>                         }
>                 }
> --
> 1.9.3
>

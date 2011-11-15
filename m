From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: segfault the use xen and multipath devices
Date: Tue, 15 Nov 2011 17:06:19 +0100
Message-ID: <CAO+b5-pa74Qp_OKyc8g5KwKg6fznHFkRox9dxqw2+XiHnuh5JQ@mail.gmail.com>
References: <CACaajQtfbG=qs5c3RKQUUQ4d5UhQ=mB6o78rQw7hBMpQ0WD8tg@mail.gmail.com>
	<CAO+b5-r2j2DykAQ3vK06FO7=4nEhRsrC-gwGpUv-=8_zFhXKXg@mail.gmail.com>
	<CACaajQvxCnXNTKcgF=wYfQsRyJOJAhT9vjB=GT3DvkSfvNBdQw@mail.gmail.com>
	<4EC24925.9060103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56361 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1KOQGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2011 11:06:20 -0500
Received: by wyh15 with SMTP id 15so7216068wyh.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2011 08:06:19 -0800 (PST)
In-Reply-To: <4EC24925.9060103@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Vasiliy Tolstov <v.tolstov@selfip.ru>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Nov 15, 2011 at 12:12 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 11/15/2011 11:00 AM, Vasiliy Tolstov wrote:
> > [ 1152.782672] Call Trace:
> > [ 1152.782760] =A0[<ffffffffa010dd13>] ? __scsi_queue_insert+0xbe/0=
xe5 [scsi_mod]
> > [ 1152.782862] =A0[<ffffffffa010e125>] ? scsi_io_completion+0x3eb/0=
x3fa [scsi_mod]
> > [ 1152.782964] =A0[<ffffffffa010abb0>] ? scsi_eh_flush_done_q+0xe3/=
0x104
> > [scsi_mod]
> > [ 1152.783093] =A0[<ffffffffa010bdc3>] ? scsi_error_handler+0x3cb/0=
x5b5 [scsi_mod]
> > [ 1152.783195] =A0[<ffffffffa010b9f8>] ? scsi_error_handler+0x0/0x5=
b5 [scsi_mod]
> > [ 1152.783295] =A0[<ffffffff81065c69>] ? kthread+0x79/0x81
> > [ 1152.783389] =A0[<ffffffff81012baa>] ? child_rip+0xa/0x20
> > [ 1152.783482] =A0[<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/=
0x1b
> > [ 1152.783577] =A0[<ffffffff8101251d>] ? retint_restore_args+0x5/0x=
6
> > [ 1152.783673] =A0[<ffffffff8100ef4f>] ? xen_restore_fl_direct_end+=
0x0/0x1
> > [ 1152.783769] =A0[<ffffffff81012ba0>] ? child_rip+0x0/0x20Ouch. Re=
queue while the queue is dead.
>
> I'm pretty sure we need to fix the error handler for this case.

Apparently when a SCSI host is removed the SCSI queue is killed from
inside __scsi_remove_device() before the error handler thread is
stopped from scsi_host_dev_release(). That order doesn't seem correct
to me.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

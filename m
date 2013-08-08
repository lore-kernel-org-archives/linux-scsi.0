From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Thu, 8 Aug 2013 11:27:28 -0700
Message-ID: <CAL1RGDUtfpzrQNhRhj9H4j5CQBOk51k6xf4f969w2GMvoz5wTA@mail.gmail.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com>
 <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com>
 <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com> <52027662.6060103@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:41206 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752527Ab3HHS1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 14:27:49 -0400
Received: by mail-ob0-f181.google.com with SMTP id dn14so5332906obc.26
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2013 11:27:48 -0700 (PDT)
In-Reply-To: <52027662.6060103@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: David Milburn <dmilburn@redhat.com>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Jeffery <djeffery@redhat.com>

On Wed, Aug 7, 2013 at 9:31 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> So what kind of signal was leading to your "stomping on the memory"?
> Was it user generated or something like SIGIO, SIGPIPE or a RT signal?

It was sometimes SIGHUP (for reopening log files) and sometimes
SIGALARM (for various periodic things).

> To get around the SG_IO ioctl restart problem (for non idempotent
> SCSI commands) could we replace a -ERESTARTSYS return value
> with -EINTR ?
>
> As I noted in a previous post, for robust user space code using the
> SG_IO ioctl, masking signals during the IO may help.

Yes, absolutely.  But process A should be able to keep its memory
uncorrupted even if process B is coded wrong :)

> And what about bsg? Is it any better or worse than sg in the case
> of interrupted SG_IO ioctls? Apart from the interface (sg_io_hdr
> v3 versus v4) it should be a drop in replacement for sg.

As far as I can tell bsg looks much better w.r.t. signals -- I don't
see anywhere that it schedules work onto a workqueue or other kernel
thread, and it looks like the SG_IO ioctl there actually has nowhere
that checks for signals.  All sleeps will be uninterruptible, which I
guess may be better or worse depending on your perspective.

 - R.

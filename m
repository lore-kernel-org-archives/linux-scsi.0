From: Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH 2/3] osst upgrade to 0.99.3
Date: Wed, 5 Jan 2005 09:31:55 -0800
Message-ID: <29495f1d0501050931379525d1@mail.gmail.com>
References: <1104627573l.3427l.3l@serve.riede.org>
Reply-To: Nish Aravamudan <nish.aravamudan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.192]:39639 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262486AbVAERyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2005 12:54:32 -0500
Received: by rproxy.gmail.com with SMTP id r35so396665rna
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jan 2005 09:54:31 -0800 (PST)
In-Reply-To: <1104627573l.3427l.3l@serve.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 02 Jan 2005 00:59:33 +0000, Willem Riede <osst@riede.org> wrote:
> Here is patch 2 (see previous mail for context), providing osst error
> handling improvements.

<snip>

> +               while (retval && time_before (jiffies, startwait + 5*60*HZ)) {
> +
> +                       if (STp->buffer->syscall_result && (SRpnt->sr_sense_buffer[2] & 0x0f) != 2) {
> +
> +                               /* some failure - not just not-ready */
> +                               retval = osst_write_error_recovery(STp, aSRpnt, 0);
> +                               break;
> +                       }
> +                       set_current_state(TASK_INTERRUPTIBLE);
> +                       schedule_timeout (HZ / OSST_POLL_PER_SEC);

Are you sure you want to use TASK_INTERRUPTIBLE here? If you are sure,
then you probably should add code which checks if schedule_timeout()
returns early because of signals (signals_pending(current) will be
true). Additionally, you may as well use msleep_interruptible(1000 /
OSST_POLL_PER_SEC), since you are requesting a 10th of a second sleep
(with OSST_POLL_PER_SEC #define'd to 10) (which is long & measurable
in milliseconds), you are not checking the return value (so you don't
seem to care how much time was left in the sleep) and
msleep_interruptible() will return on the same conditions as the
current code does. Seems like it should do what you want (still need
some means of checking for signals, though, I think).

If, in fact, you did not intend to use TASK_INTERRUPTIBLE, but
TASK_UNINTERRUPTIBLE, then you may want to consider using msleep(1000
/ OSST_POLL_PER_SEC) [ignoring signals in addition to waitqueue
events].

If, though, you want to keep the code as is, then please ignore the
noise and I apologize :)

Thanks,
Nish

From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Fri, 1 Feb 2008 16:49:54 -0800 (PST)
Message-ID: <668582.37066.qm@web31809.mail.mud.yahoo.com>
References: <47A38903.9010902@cybernetics.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:32569 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754272AbYBBAtz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 19:49:55 -0500
In-Reply-To: <47A38903.9010902@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

--- On Fri, 2/1/08, Tony Battersby <tonyb@cybernetics.com> wrote:
> 
> I disagree only with this part of the commit:
> 
> -                       good_bytes = (error_sector -
> SCpnt->request->sector) << 9;
> -                       if (good_bytes < 0 || good_bytes
> >= this_count)
> -                               good_bytes = 0;
> 
> So it removed the sanity-check on good_bytes, which broke
> error handling
> for my out-of-spec RAID.

Tony, I explained to you the inequality this
is based on, and gave you a patch which tested
for it (hunk #2, 2 lines) and it also tried to
accommodate your complaint about RECOVERED ERROR
(hunk #1, 3 lines), residual rather, which James addressed and apparently(?) I misunderstood.

You then took hunk #2 (2 lines) of the patch I sent
you and submitted it as your own, and then I acked
"your" patch.

I think it would've been much clearer if you had
singled out the problems you were seeing with your
HW and sent a single problem with a single patch per
single email.

> My patch adds the check back,
> only doing it
> before the multiplication by the sector size rather than
> after.  That is
> also why I wanted to add an upper-bound check, to make sure
> that sd_done
> never returned good_bytes > xfer_size, but no one else
> agreed with that
> level of paranoia.

I think James' email explained why. He also gave an
alternative way to implement one-off behaviour.

> I guess the question is: if a disk drive returns RECOVERED
> ERROR with
> info_valid=1 and the sector number in the sense bytes, does
> that mean
> that the disk completed the command successfully and
> transferred all the
> data (and is reporting the sector number for information
> logging
> purposes only), or does it mean that it stopped reading or
> writing at
> the sector indicated in the sense data?

The former.  It is what 03aba2f7 implements.

>  I can't really
> say for sure, so
> I will leave the debate to others.

The answer is in SBC3 and also in 03aba2f7.

> BTW, your patch will result in sd_done returning good_bytes
> == 0 for the
> case where sense_key == RECOVERED ERROR &&
> info_valid == 0, which I
> think is probably wrong.

Tony, I tried to accommodate your complaints
in the email that started this thread, and thus
the patch that we asked you to try.  RECOVERED
ERROR is handled as per spec in 03aba2f7.

RECOVERED ERROR, info_valid = X, commit
03aba2f7 will return good_bytes = xfer_size,
as per SBC3.

> In this case I would return
> good_bytes == 0
> for hardware/medium error and good_bytes == xfer_size for
> recovered error.

For HARDWARE/MEDIUM ERROR, good_bytes is computed,
depending on sense data.
It is 0 <= good_bytes < xfer_size (latter strict inequality).

For RECOVERED ERROR, good_bytes = xfer_size,
as you can see in 03aba2f7.

> My hardware isn't returning "recovered error"
> or "no sense" sense keys;

Sorry, I assumed you were since you were talking
about it and your original patch touched it.

> I was just trying to improve the handling of these cases
> while I was
> looking at the function.
> Thus, there is no point for me to
> test your
> full patch.  My problem is now solved with the simplified
> patch I
> already posted.  If you want to push for the RECOVERED
> ERROR change,
> then go right ahead with your own patch, but I'm done.

No, I'm not pushing for anything.  I already
acked "your" patch.  I was merely trying to
accommodate the concerns you had, as I explained
above.

03aba2f7 stands with "your" simplified patch.

If you still think there is something wrong
with drivers/scsi/sd.c, a kernel log with a 
spec reference and a patch from you would be
most welcome I assure you.

   Luben


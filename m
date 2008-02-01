From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Fri, 01 Feb 2008 16:02:59 -0500
Message-ID: <47A38903.9010902@cybernetics.com>
References: <145599.60620.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:2671 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbYBAVCx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 16:02:53 -0500
In-Reply-To: <145599.60620.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> --- On Fri, 2/1/08, Tony Battersby <tonyb@cybernetics.com> wrote:
>   
>> Also, I disagree about treating recovered error like
>> hardware/medium
>> error.  Recovered error is supposed to mean "the last
>> command completed
>> successfully, with some recovery action performed by the
>> device
>> server".
>>     
>
> Which then means that you agree with
> commit 03aba2f7.
>
>   

I disagree only with this part of the commit:

-                       good_bytes = (error_sector - SCpnt->request->sector) << 9;
-                       if (good_bytes < 0 || good_bytes >= this_count)
-                               good_bytes = 0;

So it removed the sanity-check on good_bytes, which broke error handling
for my out-of-spec RAID.  My patch adds the check back, only doing it
before the multiplication by the sector size rather than after.  That is
also why I wanted to add an upper-bound check, to make sure that sd_done
never returned good_bytes > xfer_size, but no one else agreed with that
level of paranoia.

> But the definition of RECOVERED ERROR immediately
> after what you quoted, adds:
>    "Details may be determined by examining the
> additional sense bytes and the INFORMATION field."
>
>   

I guess the question is: if a disk drive returns RECOVERED ERROR with
info_valid=1 and the sector number in the sense bytes, does that mean
that the disk completed the command successfully and transferred all the
data (and is reporting the sector number for information logging
purposes only), or does it mean that it stopped reading or writing at
the sector indicated in the sense data?  I can't really say for sure, so
I will leave the debate to others.

BTW, your patch will result in sd_done returning good_bytes == 0 for the
case where sense_key == RECOVERED ERROR && info_valid == 0, which I
think is probably wrong.  In this case I would return good_bytes == 0
for hardware/medium error and good_bytes == xfer_size for recovered error.

> Thus the patch I sent to you for you to try on
> your hardware.
>
>   
My hardware isn't returning "recovered error" or "no sense" sense keys;
I was just trying to improve the handling of these cases while I was
looking at the function.  Thus, there is no point for me to test your
full patch.  My problem is now solved with the simplified patch I
already posted.  If you want to push for the RECOVERED ERROR change,
then go right ahead with your own patch, but I'm done.

Tony


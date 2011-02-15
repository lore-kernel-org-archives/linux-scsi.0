From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/2] convert libsas to the libata new eh
Date: Tue, 15 Feb 2011 02:03:41 -0500
Message-ID: <4D5A254D.8000900@garzik.org>
References: <1295797260.3007.118.camel@mulgrave.site> <1297624717.3001.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55501 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1BOHDq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2011 02:03:46 -0500
In-Reply-To: <1297624717.3001.2.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>

On 02/13/2011 02:18 PM, James Bottomley wrote:
> On Sun, 2011-01-23 at 09:41 -0600, James Bottomley wrote:
>> The bad news is that this is a pretty horrific conversion.  Because of
>> the amount of control the new eh wants (and the slew of monolithic
>> assumptions it makes), the entire error handler routine has to be sliced
>> apart and sewn back together to make it callable as part of an existing
>> error handler (rather than trying to do everything on its own).
>>
>> The even worse news is that unless you have an existing strategy
>> handler, you can't make use of this.  That means that ipr is
>> unconvertable in its current form.  Given the two really nasty options:
>> give ipr its own error handler via its own transport class, or attach
>> ipr to libsas and let it do the work, I'd choose the latter.
>> Unfortunately, my power box with IPR has been non-functional for a year
>> (and all pleas to IBM to fix it have so far gone unanswered), so I can't
>> really do this myself.
>>
>> Once we carve up libata, it's still a rather complex call sequence for
>> libsas because of libata's annoying insistance on calling the error
>> handler at the drop of a hat.  The principle differentiator used is the
>> fact that if a SCSI command no longer has an associated SAS task, (i.e.
>> libsas thinks it's complete) it must be destined for libata.  This works
>> correctly in all the ATAPI sense processing instances I've tested.
>> Finally, we still have to call port recovery.  Currently, it's
>> impossible to tell which port libata thinks is in error (libata knows
>> because it has one host per port, but libsas doesn't), so the final
>> solution is just to call port recovery for every SATA/STP attached port.
>>
>> I've tested all of this with mvsas over expander attached ATA devices
>> using STP (aic94xx seems to have developed some handling fault for STP,
>> which I'll look into next).
>
> Since there's been remarkably little discussion of the ata changes, I
> think it's time to put this in linux-next to see what shakes out.

The fix series was quite straightforward, and the error handler 
separation is almost mechanical.  All looks good and tests well here, so 
I threw it into libata-dev.git#upstream (and thus linux-next).

Let me know if you want to peel off patch 2/2 here into a post-merge tree...

	Jeff




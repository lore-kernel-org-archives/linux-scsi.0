From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Thu, 31 Jan 2008 20:32:35 +0200
Message-ID: <47A21443.50402@panasas.com>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org> <47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com> <47A2033D.2050502@panasas.com> <20080131180051.GA22341@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:60405 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763987AbYAaSdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 13:33:15 -0500
In-Reply-To: <20080131180051.GA22341@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Mark Glines <mark@glines.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jan 31 2008 at 20:00 +0200, Greg KH <greg@kroah.com> wrote:
> On Thu, Jan 31, 2008 at 07:19:57PM +0200, Boaz Harrosh wrote:
>>   scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
>>   volunteer 96 bytes of INQUIRY. This caused an underflow condition in
>>   protocol.c usb_stor_access_xfer_buf(). So first fix is to
>>   usb_stor_access_xfer_buf() to properly handle underflow conditions.
>>   Then usb_stor_set_xfer_buf() should report this condition as a negative
>>   resid. Should we also set cmnd->status in the underflow condition?
>>
>>   Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
>>   the upper layer asked for.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> As this is a regression and hits 2.6.24, can you send the final version
> of this patch to the stable@kernel.org address so we can get it into the
> 2.6.24.y tree?
> 
> thanks,
> 
> greg k-h
> -

On Thu, Jan 31 2008 at 20:00 +0200, Mark Glines <mark@glines.org> wrote:
>> On Thu, 31 Jan 2008 19:20:26 +0200
>> Hi,
>> 
>> This patch fails to apply to 2.6.24.  What should I apply it to, for
>> testing?  USB Git, or SCSI git or something?
>> 
>> patching file drivers/usb/storage/isd200.c
>> Hunk #1 succeeded at 1238 (offset -23 lines).
>> Hunk #2 succeeded at 1248 (offset -23 lines).
>> Hunk #3 succeeded at 1259 (offset -23 lines).
>> patching file drivers/usb/storage/protocol.c
>> Hunk #1 FAILED at 175.
>> Hunk #2 FAILED at 228.
>> 2 out of 2 hunks FAILED -- saving rejects to file drivers/usb/storage/protocol.c.rej
>> 
>> Thanks,
>> 
>> Mark
> 

OK, I was confused with what versions this belongs to. This also answers
my original question of why it happens with my patch, as it did not
it happened before my patch. My patches only went into the 2.6.25 merge window.

So I will need to send 2 Patches. One for stable@kernel.org on top of 2.6.24.
The second is for mainline, which is the one I sent. Should go threw scsi-misc
which it is based on.

patch for 2.6.24 stable@kernel.org on the way

Boaz

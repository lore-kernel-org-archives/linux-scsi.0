From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: HP PSC 1350 cardreader problem + fix, needs new unusal_dev FLAG
Date: Sun, 10 Jun 2007 20:56:59 +0200
Message-ID: <466C497B.4010407@hhs.nl>
References: <466C2A43.8030300@hhs.nl> <1181495929.6112.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:44329 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbXFJSnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jun 2007 14:43:14 -0400
In-Reply-To: <1181495929.6112.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, stern@rowland.harvard.edu

James Bottomley wrote:
> On Sun, 2007-06-10 at 18:43 +0200, Hans de Goede wrote:
>> 1) currently I have decided to add quirk code for this to the usb-storage
>>     driver, as I don't want to polute the generic scsi code with this, but maybe
>>     it would be better to add a quirk for this to the scsi layer?
>> 2) What on earth should I name the flag for this?
> 
> It probably makes the most sense to keep this at the USB layer.  I can't
> see any properly conforming SCSI device having this problem.  Plus the
> command construction is currently a submit hot path for SCSI ... this
> would add an extra check to that path.
> 
>> 3) Currently I just shorten the read / write by one sector. The scsi layer then
>>     notices the 1 sector to short read/write and sends a new command for the
>>     last sector. This works well, but is it ok to depend on the scsi layer
>>     behaving this way?
> 
> Yes, that's behaviour by design.
> 
>> 4) Should I be checking for other READ_X and WRITE_x commands too?
> 
> That depends on USB storage, but I think it currently sets the
> use_10_for_rw flag which forces us only to use READ_10/WRITE_10
> 
> James
> 

Thanks for the quick and thorough answer! I've submitted a pathc for this to 
the usb-storage list.

Regards,

Hans


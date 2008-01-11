From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Linux scsi / usb-mass-storage and HP printer cardreader bug +
 fix
Date: Fri, 11 Jan 2008 13:48:31 +0100
Message-ID: <4787659F.9050607@hhs.nl>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com> <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frosty.hhs.nl ([145.52.2.15]:54997 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYAKMup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 07:50:45 -0500
Received: from exim (helo=frosty)
	by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1JDJLO-0001Zf-Ak
	for linux-scsi@vger.kernel.org; Fri, 11 Jan 2008 13:50:42 +0100
In-Reply-To: <47860106.3090509@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, fedora-kernel-list@redhat.com, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, Guillaume Bedot <littletux@zarb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Boaz Harrosh wrote:
> On Thu, Jan 10 2008 at 12:52 +0200, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
>>> I'm not sure what the proper solution should be?
>>>
>> I guess the proper solution would be to add a special case to the scsi layer 
>> where the read10 / write10 command is issued, and split the request in 2 there 
>> when it involves the last sector.
>>
>> There was another reply in this thread stating that problems reading the last 
>> sector with sd / mmc cards happen quite often, and that this is most likely not 
>> an isolated case.
>>
>> Regards,
>>
>> Hans
> 
> Yes, you're right. in ULDs it is a much proper way to do this.
> 
> So I guess you'll have to do that special host flag or device
> flag, and add a check for it in sd.c. You'll see that sd.c is 
> already doing bufflen truncation at sd_prep_fn(), just add one
> more case.
> 

Yes,

That will work nicely, I'll write an updated patch this evening (when I have 
access to the printer to test again).

Regards,

Hans



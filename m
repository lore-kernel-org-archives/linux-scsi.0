From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency	problem
Date: Tue, 13 Dec 2005 07:22:54 -0600
Message-ID: <439ECB2E.7070103@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>	 <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <439E0112.1030801@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:21460 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932120AbVLMNXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 08:23:14 -0500
In-Reply-To: <439E0112.1030801@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org



Michael Reed wrote:
> 
> James Bottomley wrote:
>> On Mon, 2005-12-12 at 15:00 -0600, Michael Reed wrote:
>>> (The subject of this email isn't quite accurate.  It's not
>>> a pci coherency problem, it's a pio write ordering problem.)
>>>
>>> I've been asked to pass along the suggestion that "mmiowb"
>>> should be implemented for the platform.
>>> Given that I've been unable to unearth the chipset documentation
>>> for the Vis WS, I can only hope that you've got some good ideas
>>> on how this might be accomplished.
>> Well, the idea was that mmiowb and posting flushes were orthogonal.
>> mmiowb would be used in places where a posted write flush was done but
>> was strictly unnnecessary.  This bug report is implying that the posted
>> write flush was necessary, so it was incorrectly replaced with mmiowb
>> (which is a nop on most platforms).
> 
> The mmiowb() is sufficient to assure
> ordering of the write to the board register.
> (Have I incorrectly used the term pio?
> I'm not meaning to imply a particular address space used to
> access a board's registers.)
> 
> It's not a timing issue.  The WRT_REG write doesn't have to reach
> the board before the driver can perform another function.  It
> just has to reach the board in the order issued.

I believe the biggest issue with VISWS is that it appears to need
mmiowb() and we likely don't know how to implement it.  Hence, for
that platform, it would make sense to replace the mmiowb() with a
posting read.

We should let the maintainer chime in.  Perhaps he has the
info that would allow an implementation of mmiowb() for the
platform.  That would be best as there are other drivers
(tg3, for example) that also use mmiowb().  Retaining mmiowb()
also allows those platforms that can take advantage of it
a small (perhaps not so small?) performance gain.

Mike


> 
>>> I agree that replacing the pio read which flushed the preceeding
>>> pio write with mmiowb() is what has likely broken the driver.  If you
>>> restore them,  please make it either mmiowb or pio read, but not both.
>>>
>>> Perhaps something like this?  It's not the most elegant solution....
>> I'm tempted to say I think we need to put the write posting flush back
>> in and dump the mmiowb(), but since the driver is supposedly doing PIO
>> for VISWS, there's something else going on here (PIO writes aren't
>> supposed to post).  I've cc'd the VISWS maintainer in case he can think
>> of anything.
> 
> Again, apologies if I've misused the term PIO.
> 
> Mike
> 
>> James
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

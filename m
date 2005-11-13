From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 14:42:01 -0500
Message-ID: <43779709.5070404@redhat.com>
References: <20051113180358.35896.qmail@web88004.mail.re2.yahoo.com> <1131906086.3291.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39360 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750997AbVKMTmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 14:42:25 -0500
In-Reply-To: <1131906086.3291.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Graham Knap <graham.knap@rogers.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2005-11-13 at 13:03 -0500, Graham Knap wrote:
> 
>>Doug Ledford <dledford@redhat.com> wrote:
>>
>>>You already said it didn't help with the problem, 
>>
>>I meant that I don't think I successfully disabled DV, because the boot
>>messages were *identical*, except for the line where the kernel shows
>>the "Kernel command line".
>>
>>I had added this argument at the end of the line:  aic7xxx=dv:{0}
>>
>>I've re-read "aic7xxx.txt" and I'm not sure what I'm doing wrong. If
>>you can tell me how to disable DV, I'd be happy to give it a try.
> 
> 
> aic7xxx.txt is out of date.  The aic7xxx (and 79xx) drivers use the
> generic domain validation code now rather than the old aic specific ones
> (which is what the dv:{0} option is referring to).  If you try the code
> in the prior email, I think that will disable the piece of DV that's
> causing the problem.
> 
> If the test code succeeds, the problem is pretty nasty:  Apparently the
> device claims DT support but in fact rejects DT in the negotiation.  We
> use DT support to begin the check for an echo buffer, which starts with
> READ_BUFFERS for the descriptor.  Apparently this device returns a valid
> descriptor with a reasonable echo buffer size and then promptly throws a
> wobbly when we try to use it.
> 
> James
> 

The device is on a non-LVD bus.  Certain devices were created back when 
the spec still stated that using PPR negotiation messages on a non-LVD 
bus was a no-no.  As the echo buffer was an addition to support DV, and 
originally DV wasn't intended to be used on non-LVD busses, it might 
stand to reason that this device simply is going tits up because we are 
attempting to use the echo buffer while in SE mode.  Checking that 
PPR/DT is valid (not just between controller and device, but also given 
bus mode) and only using echo buffer DV when all LVD conditions are met 
would likely solve the problem (assuming that the problem is what you 
are referring to).

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


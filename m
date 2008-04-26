From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: AIC94xx SAS question.
Date: Sat, 26 Apr 2008 10:56:24 -0500
Message-ID: <1209225384.3113.19.camel@localhost.localdomain>
References: <20080421231940.GB5656@animx.eu.org>
	 <4812B66A.5000105@hopnet.net>  <20080426145649.GA8848@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51714 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbYDZP42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2008 11:56:28 -0400
In-Reply-To: <20080426145649.GA8848@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org


On Sat, 2008-04-26 at 10:56 -0400, Wakko Warner wrote:
> Keith Hopkins wrote:
> > On 04/22/2008 07:19 AM, Wakko Warner wrote:
> > >Can either of these be done:
> > >1) Embed the firmware into the driver so that it can be used before the
> > >rootfs id mounted.
> > 
> > I think this is generally not done because firmware tends to be 
> > closed-source.
> 
> I can understand this from the point of the distrobution of the linux
> kernel, but it still can be done.  If there were a patch or something that
> would convert the file, that's all I care.  This for me would be preferred.

There is certainly a way to do this: all you really need to do is to
render the firmware into hex as a character array, compile the array
with the driver and return a pointer to the first byte at the
request_firmware call.

The practical reason it's no-longer done (apart from the annoyance it
causes debian) is simply that the file is huge and the firmware seems to
change quite a lot.  For the qla2xxx driver (whose firmware, admittedly
is larger than aic94xx) it used to result in a 4MB patch every time
there was a tiny change to the file.

> > >2) Can the firmware be loaded in an initr{d,amfs}?
> > 
> > Sure.  openSuSE does it in their mkinitrd.
> 
> I'm not sure if you got the point of #2 or not.  I do *NOT* want the driver
> as a module, I want it compiled into the kernel and then load the firmware
> from an initramfs.
> 
> I think I figured out how to do #2, but if/when I do it is another story.  I
> believe that the driver won't bind to the card if the firmware isn't
> available, thus I can have it bind to the card at a later time (during
> initramfs).  I tried this on my system last night (since it crashed anyway). 
> I loaded the module and /sys wasn't mounted.  I mounted /sys and told the
> driver to bind my card and it worked.

James



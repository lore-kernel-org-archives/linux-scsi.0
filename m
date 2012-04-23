From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Is it possible for Realtek card reader driver to reside in
 SCSIsubsystem?
Date: Mon, 23 Apr 2012 09:11:19 +0100
Message-ID: <1335168679.3051.9.camel@dabdike.lan>
References: <4F94D132.7070109@realsil.com.cn>
	 <1335166767.3051.4.camel@dabdike.lan> <4F950C0B.10804@realsil.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51578 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab2DWIL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2012 04:11:26 -0400
In-Reply-To: <4F950C0B.10804@realsil.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: edwin_rong <edwin_rong@realsil.com.cn>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, =?UTF-8?Q?=E7=8E=8B=E7=82=9C?= <wei_wang@realsil.com.cn>, Greg KH <greg@kroah.com>

[updated Greg to non-SUSE address]
On Mon, 2012-04-23 at 16:00 +0800, edwin_rong wrote:
> On 04/23/2012 03:39 PM, James Bottomley wrote:
> > On Mon, 2012-04-23 at 11:49 +0800, edwin_rong wrote:
> >> Dear James and all :
> >>
> >> Sorry to disturb you again!
> >>
> >> I'm an software engineer of Realtek corporation, responsible for writing
> >> driver for Realtek Card Reader chips.
> >>
> >> Our device supports SD/MMC/MS/MSpro/xD series of cards, etc., which is
> >> implemented as an SCSI device in our driver,
> >> and now our driver rts_pstor is under staging folder of linux kernel, so
> >> I want to know whether it is possible to move it out of staging folder,
> >> and reside in SCSI subsystem?
> >>
> >> I also know that both "mmc" and "memstick" subsystem exist in kernel
> >> now, but our device is a composition of these types of cards,
> >> so it seems not suitable for keeping our driver there.
> >>
> >> All replies are appreciated.
> > The general rule is that if the device itself speaks SCSI ... as in
> > either the firmware or the underlying disk does, then you should be
> > using SCSI (This doesn't mean you have to have an actual SCSI device
> > anywhere ... lots of USB devices are some wierd flash or IDE device
> > fronted by a chip that does SCSI<->whatever translation [usually
> > badly]).  Conversely if you would be writing your SCSI command emulation
> > in the driver, don't ... you should be using another subsystem.
> >
> > James
> >
> Dear James,
> 
> Got it, thanks for your response, sincerely.
> 
> As to my case, which subsystem do you think is fit for our driver to 
> stay, could you give me some suggestions?

Well, you said it's a combination of mmc and memstick.  If it can be
bound as two separate drivers, I'd say one in each.  If there's magic
that has to be done in the binding (as in you need a single bind driver
that activates each component), I'd say be guided by the maintainers of
those components.  My instinct would be to put it in one and use the
other via Kconfig, but whatever they find most appropriate.

James



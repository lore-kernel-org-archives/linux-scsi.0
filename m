From: Peter Missel <peter.missel@onlinehome.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sun, 2 Jan 2005 01:28:31 +0100
Message-ID: <200501020128.32217.peter.missel@onlinehome.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <200412311620.44488.peter.missel@onlinehome.de> <m3pt0okd6c.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.190]:8907 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S261202AbVABAaj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jan 2005 19:30:39 -0500
In-Reply-To: <m3pt0okd6c.fsf@merlin.emma.line.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Hi again!

On Saturday 01 January 2005 23:16, Matthias Andree wrote:
> Peter Missel <peter.missel@onlinehome.de> writes:
> > I'm fine with the additional safety from the Domain Validation.
> > Nonetheless, the driver shouldn't validate speeds and/or transfer widths
> > that have been forbidden by the user.
> > Another example (which I can't verify right now) is negotiation width.
> > External HDD enclosures might be connected through a Narrow cable but
> > actually contain a Wide drive. That'll be one thing where the user would
> > use the SCSI BIOS to limit the particular unit to Narrow. This however
> > would possibly be caught by the DM failing.
>
> No external enclosure necessary. There are also wide chips with only
> narrow connectors, for instance, on the Tekram DC-310U, DC-390U boards -
> they use a SYM53C860 or SYM53C875, a wide capable chip, but provide only
> narrow (50-pin) connectors. I last tried some 2.4.X kernel on such a
> setup, and haven't used the DC-390U in a long time (I replaced it by a
> DC-390F) - so I cannot test at this time.

Yes of course ... LSI (NCR back then) had one of those themselves, IIRC it was 
the "8250" and "8750" controller card. These used the 52C825 Fast-Wide and 
53C875 UW controller chips respectively, but had only Narrow connectors.

This possibly is because with the exception of the 815 chip, LSI's Narrow 
chips don't have a BIOS ROM interface, while the Wide chips do. So if you 
were to build a controller card w/ boot ROM support, you had to use a Wide 
chip even if the card was to be Narrow-only.

Tekram's 310U, IIRC, was a ROM-less card that used the 860 Narrow chip, wasn't 
it?

LSI also had a rather quirky special interpretation of certain bits in the 
subsystem ID field (I'm serious!), flagging "halved" interface speed and a 
couple of other aspects. I have the ancient application note at work if 
you're interested - LSI confirmed to me somewhat recently that this is still 
valid. I don't know whether and how this might be relevant to OS driver 
behavior, but it's certainly worth a look while we're working on the topic.

regards,
Peter

From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: RE: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505
Date: Thu, 10 Apr 2003 10:55:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <530360000.1049993706@aslan.btc.adaptec.com>
References: <A5974D8E5F98D511BB910002A50A66470580D766@hdsmsx103.hd.intel.com>	<1049919802.16880.84.camel@astrognat> 	<239330000.1049920048@aslan.btc.adaptec.com> <1049925671.16881.104.camel@astrognat>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:18619 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264101AbTDJQo0 (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 12:44:26 -0400
In-Reply-To: <1049925671.16881.104.camel@astrognat>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, Rohit Gupta <rohit@davsys.com>, linux-scsi@vger.kernel.org

> On Wed, 2003-04-09 at 21:27, Justin T. Gibbs wrote:
> 
> JG> The latest driver is 1.3.6:
> 
> I superimposed your 2.4-20030328 driver over my kernel tree and
> rebuilt.  It still locked up :-(

Do you have the nmi_watchdog enabled?  What bus speed are you running
for the aic7902 and the gig-E card?  Are the on the same physical PCI/PCI-X
bus?

> I tried lowering global tag depth to 4 (which I presume is a low number,
> but I don't really know what I'm doing).  And it still locks up.
> Moreover, according to /proc/scsi/aic79xx/[01], the driver has
> negotiated "Max Tagged Openings 0" with all the devices on this bus.

That seems really wierd - like you disabled disconnection.

> I noticed /proc/scsi/aic79xx/1 correctly refers to the controller as
> Channel B, but all the device info says Channel A.  Hope this doesn't
> mean it's getting scsi0 and scsi1 mixed up at a lower level.

Yes, that is a bit confusing.  The two channels are actually two independent,
single channel, controllers.  The user doesn't know that, and expects the
names to match those silk-screened on the card.  I'll review the code to
see if I can make it less confusing (perhaps just omit the channel identifier).

> My other theory is that all the devices on this bus are removable in one
> form or another, and hence are being polled for media changes.  The
> actions which cause the bus/driver to lock up are things which need a
> long period (several seconds) of data transfer - scanning in colour,
> writing a CD.  Could the disconnect logic be getting screwed up
> somewhere?  How could I test that?

A good start would be to send me privately (no need to spam the list) the
output of "cat /proc/scsi/aic79xx/*" and "cat /proc/scsi/scsi" as well
as a dmesg from the system.  From the last trace you sent, it did look
like we timed out while a command without the disconnection privledge was
out on the bus, but its not clear why yet.  If you compile the driver
with debugging enabled and a debug mask of 8, I can also see the content
of the serial eeprom to see if the settings are strange.

--
Justin


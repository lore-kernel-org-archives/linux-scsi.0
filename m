From: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Subject: RE: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505
Date: 10 Apr 2003 22:00:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050008453.23304.52.camel@astrognat>
References: <A5974D8E5F98D511BB910002A50A66470580D766@hdsmsx103.hd.intel.com>	<10499198
	02.16880.84.camel@astrognat> 	<239330000.1049920048@aslan.btc.adaptec.com>
	<1049925671.16881.104.camel@astrognat>
	<530360000.1049993706@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.169.3.187] ([217.169.3.187]:61066 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S264166AbTDJUtk (for <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2003 16:49:40 -0400
In-Reply-To: <530360000.1049993706@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, Rohit Gupta <rohit@davsys.com>, linux-scsi@vger.kernel.org

On Thu, 2003-04-10 at 17:55, Justin T. Gibbs wrote:

JG> Do you have the nmi_watchdog enabled?

Not normally.  I tried booting with "nmi_watchdog=1" and it made no
difference.  Note that in my case (unlike Rohit Gupta's), it's not a
complete kernel lockup - the system is fine apart from one dead SCSI
channel.  Processes which try to touch devices on ChB hang apparently
indefinitely.

JG> What bus speed are you running for the aic7902 and the gig-E card?

The BIOS says "AUTO"; /proc/pci says 66MHz.

JG> Are the on the same physical PCI/PCI-X bus?

No.  SuperMicro built the board such that PCI-X slots 1 and 2 and the
SCSI controller are on one bus, and PCI-X slot 3 and the Ethernet
interface are on another.  All the slots are empty.


DG> the driver has negotiated "Max Tagged Openings 0" with
DG> all the devices on this bus.

JG> That seems really wierd - like you disabled disconnection.

I don't know how I would do that with this hardware.  SCSIselect doesn't
have that as an option (and has everything defaulted except ChB
termination), and none of my hardware can be jumpered that way AFAIK.


DG> /proc/scsi/aic79xx/1 {..} controller as Channel B,
DG> but all the device info says Channel A.

JG> The two channels are actually two independent, single channel,
JG> controllers.  The user doesn't know that

The user has been misled by the marketing info and the motherboard
manual ;-)

JG> I'll review the code to see if I can make it less confusing
JG> (perhaps just omit the channel identifier).

Presumably channel identifiers are useful in some cases, so IMHO the
most logical option would be to make them match what's reported by
/proc/scsi/scsi.  There the channels are all called "00".


JG> send me privately {..} the output of "cat /proc/scsi/aic79xx/*"
JG> and "cat /proc/scsi/scsi" as well as a dmesg from the system.
JG> {..} If you compile the driver with debugging enabled and a
JG> debug mask of 8, I can also see the content of the serial
JG> eeprom to see if the settings are strange.

OK.  I noticed you released new source today, so I will download that
and play 'make' again.


Duncan



From: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Subject: RE: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505
Date: 09 Apr 2003 23:01:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1049925671.16881.104.camel@astrognat>
References: <A5974D8E5F98D511BB910002A50A66470580D766@hdsmsx103.hd.intel.com>
	<1049919802.16880.84.camel@astrognat>
	<239330000.1049920048@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.169.3.187] ([217.169.3.187]:10632 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S263864AbTDIVtw (for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 17:49:52 -0400
In-Reply-To: <239330000.1049920048@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, Rohit Gupta <rohit@davsys.com>, linux-scsi@vger.kernel.org

On Wed, 2003-04-09 at 21:27, Justin T. Gibbs wrote:

JG> The latest driver is 1.3.6:

I superimposed your 2.4-20030328 driver over my kernel tree and
rebuilt.  It still locked up :-(

JG> Depending on the drives you are using, you may also need to run
JG> with a fairly low tag depth {..} to get the drivers stable.

I tried lowering global tag depth to 4 (which I presume is a low number,
but I don't really know what I'm doing).  And it still locks up.
Moreover, according to /proc/scsi/aic79xx/[01], the driver has
negotiated "Max Tagged Openings 0" with all the devices on this bus.

I noticed /proc/scsi/aic79xx/1 correctly refers to the controller as
Channel B, but all the device info says Channel A.  Hope this doesn't
mean it's getting scsi0 and scsi1 mixed up at a lower level.

My other theory is that all the devices on this bus are removable in one
form or another, and hence are being polled for media changes.  The
actions which cause the bus/driver to lock up are things which need a
long period (several seconds) of data transfer - scanning in colour,
writing a CD.  Could the disconnect logic be getting screwed up
somewhere?  How could I test that?


Duncan



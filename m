From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Mon, 24 Nov 2003 09:37:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598D30@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:46484 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S263806AbTKXRhC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 12:37:02 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@wildopensource.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

Jeremy,

> > Andrew> Manufacturing writes a pre-canned NVRAM image along with a
> > Andrew> rolling serial number (unique to each HBA) to each card that
> > Andrew> leaves QLogic.  One obvious example of a potential problem in
> > Andrew> the case of using the (driver) doctored NVRAM data is how to
> > Andrew> assign a unique serial number to the ISP that is being
> > Andrew> initialized.  BTW: The serial number is actually encoded in
> > Andrew> bytes 5, 6, and 7 of the WWPN (portname); coupled with the
> > Andrew> hardcoded port number (33) and the QLogic copany code of (224
> > Andrew> and 139), code from qla2x00_nvram_config():
> > 
> > Ok this one is more tricky. There's a couple of options though, we
> > could generate a unique serial number based on the random driver
> > output, or maybe it's worth coming up with an infrastructure for this,
> > other FC card drivers will run into the same problem.
> 
> We should be able to read the WWPN out of the NVRAM, since there is
> no reason for that to be reset.  There are various utilities/firmware
> out there that actually look at an adapter's WWPN and decide whether
> or not to talk to that adapter.
> 
> I think the WWPN is the only thing that we read from firmware in our
> Irix driver.  We also verify the checksum, so that we can tell if the
> portname is valid.
> 
> My recommendation is that the driver get the WWPN from nvram and go
> with sane defaults for everything else.
>

Ok, then what groups of parameters would you suggest have sane
defaults.  With the patch that was provided, the following
(additional)-firmware options are set for the ISP23xx by invalidating
the checksum (SN2 behaviour):

	o Full duplex
	o Fairness
	o Full login after LIP
	o use extended firmware control block
	o Loop prefered, else point-to-point
	o Tape enabled
	o FC Confirm

Along with a large number of numeric defaults for retries, delays, a
timer counts.

> Perhaps make it a config option to read other settings from the
> NVRAM, but also provide command line or config options for other
> settings that might need adjustment, for those systems that cannot
> change nvram values.  
>

The (additional-)firmware options, perhaps a subset, seem like a
(possibily) reasonable thing to force at the driver level.  But, on
the otherhand, the retry, delay and timer counts tend to be very
customer specific based on topology and storage.  Additionally, the
driver already exports via module parameters several of the more
important driver retry and timer counts, i.e. port_down_try_count,
link_down_timeout, retry_count (try modinfo for a full list).  A user
can use these facilities to perform any fine-tuning.

> Our experience is that we really don't need to mess with them,
> however.  The only two things that we allow adjustment to are frame
> size and data rate.
> 

The driver still depend on the NVRAM to provide these values.  In many
cases, the standard NVRAM values programmed at manufacturing time
satisfy the majority of users.  Do you have boards that have 'bogus'
NVRAM settings, or are you just being cautious and not depending on
the end-user to not mess things up?

Regards,
Andrew Vasquez

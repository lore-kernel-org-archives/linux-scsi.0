From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Fri, 21 Nov 2003 00:43:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121084325.GA119216@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060ED75@AVEXCH02.qlogic.org> <yq0islf5rdm.fsf@wildopensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:23935 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S264338AbTKUIoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 03:44:13 -0500
Content-Disposition: inline
In-Reply-To: <yq0islf5rdm.fsf@wildopensource.com>
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Thu, Nov 20, 2003 at 04:19:33AM -0500, Jes Sorensen wrote:
> 
> Andrew> Manufacturing writes a pre-canned NVRAM image along with a
> Andrew> rolling serial number (unique to each HBA) to each card that
> Andrew> leaves QLogic.  One obvious example of a potential problem in
> Andrew> the case of using the (driver) doctored NVRAM data is how to
> Andrew> assign a unique serial number to the ISP that is being
> Andrew> initialized.  BTW: The serial number is actually encoded in
> Andrew> bytes 5, 6, and 7 of the WWPN (portname); coupled with the
> Andrew> hardcoded port number (33) and the QLogic copany code of (224
> Andrew> and 139), code from qla2x00_nvram_config():
> 
> Ok this one is more tricky. There's a couple of options though, we
> could generate a unique serial number based on the random driver
> output, or maybe it's worth coming up with an infrastructure for this,
> other FC card drivers will run into the same problem.


We should be able to read the WWPN out of the NVRAM, since there is
no reason for that to be reset.  There are various utilities/firmware
out there that actually look at an adapter's WWPN and decide whether
or not to talk to that adapter.

I think the WWPN is the only thing that we read from firmware in our
Irix driver.  We also verify the checksum, so that we can tell if the
portname is valid.

My recommendation is that the driver get the WWPN from nvram and go
with sane defaults for everything else.  Perhaps make it a config
option to read other settings from the NVRAM, but also provide command
line or config options for other settings that might need adjustment,
for those systems that cannot change nvram values.  Our experience is
that we really don't need to mess with them, however.  The only two
things that we allow adjustment to are frame size and data rate.

jeremy

From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Mon, 24 Nov 2003 17:22:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125012247.GB140407@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0598D30@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:19403 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S261890AbTKYBXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 20:23:02 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598D30@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Mon, Nov 24, 2003 at 09:37:08AM -0800, Andrew Vasquez wrote:
> Jeremy,
> 
> > We should be able to read the WWPN out of the NVRAM, since there is
> > no reason for that to be reset.  There are various utilities/firmware
> > out there that actually look at an adapter's WWPN and decide whether
> > or not to talk to that adapter.
> > 
> > I think the WWPN is the only thing that we read from firmware in our
> > Irix driver.  We also verify the checksum, so that we can tell if the
> > portname is valid.
> > 
> > My recommendation is that the driver get the WWPN from nvram and go
> > with sane defaults for everything else.
> >
> 
> Ok, then what groups of parameters would you suggest have sane
> defaults.  With the patch that was provided, the following
> (additional)-firmware options are set for the ISP23xx by invalidating
> the checksum (SN2 behaviour):
> 
> 	o Full duplex
> 	o Fairness
> 	o Full login after LIP
> 	o use extended firmware control block
> 	o Loop prefered, else point-to-point
> 	o Tape enabled
> 	o FC Confirm

Right.
I want to confirm that "Loop prefered, else point-to-point" means
connection mode 2, which actually means that if you have a device
that can do both, you get point-to-point mode, right?

> Along with a large number of numeric defaults for retries, delays, a
> timer counts.
> 
> > Perhaps make it a config option to read other settings from the
> > NVRAM, but also provide command line or config options for other
> > settings that might need adjustment, for those systems that cannot
> > change nvram values.  
> >
> 
> The (additional-)firmware options, perhaps a subset, seem like a
> (possibily) reasonable thing to force at the driver level.  But, on
> the otherhand, the retry, delay and timer counts tend to be very
> customer specific based on topology and storage.  Additionally, the
> driver already exports via module parameters several of the more
> important driver retry and timer counts, i.e. port_down_try_count,
> link_down_timeout, retry_count (try modinfo for a full list).  A user
> can use these facilities to perform any fine-tuning.

This sounds fine, though a little unwieldy.  You can't do much about
the unwieldiness, though.

> > Our experience is that we really don't need to mess with them,
> > however.  The only two things that we allow adjustment to are frame
> > size and data rate.
> > 
> 
> The driver still depend on the NVRAM to provide these values.  In many
> cases, the standard NVRAM values programmed at manufacturing time
> satisfy the majority of users.  Do you have boards that have 'bogus'
> NVRAM settings, or are you just being cautious and not depending on
> the end-user to not mess things up?

We don't use NVRAM settings on Irix.
We do have a number of 2300-type boards which, for example, don't work
in 2GB mode unless you bypass the NVRAM setting.  There are also problems
with using 1KB frames instead of 2KB frames.

How about a config option that bypasses the NVRAM.  That way, if one
of your customers wants to use it to set different values, they can
use NVRAM.  If others don't want to use NVRAM, then they won't.


jeremy

From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 25 Nov 2003 11:29:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598D39@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:47741 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S263002AbTKYT3e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 14:29:34 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Monday, November 24, 2003 5:23 PM, Jeremy Higdon wrote:

> On Mon, Nov 24, 2003 at 09:37:08AM -0800, Andrew Vasquez wrote:
> > Ok, then what groups of parameters would you suggest have sane
> > defaults.  With the patch that was provided, the following
> > (additional)-firmware options are set for the ISP23xx by
> > invalidating the checksum (SN2 behaviour): 
> > 
> > 	o Full duplex
> > 	o Fairness
> > 	o Full login after LIP
> > 	o use extended firmware control block
> > 	o Loop prefered, else point-to-point
> > 	o Tape enabled
> > 	o FC Confirm
> 
> Right.
> I want to confirm that "Loop prefered, else point-to-point" means
> connection mode 2, which actually means that if you have a device
> that can do both, you get point-to-point mode, right?
> 

Yes, connection mode 2 is loop-preferred, else point-to-point.  But,
in your example of a device supporting both and the HBA coming up in 
point-to-point mode is probably due to the connected device's desire to
come up in point-to-point mode.  This is a typical scenario of how a
switch behaves when an HBA first negotiates a link -- can do loop,
tries point-to-point, if fails, fallback to loop.

> > The (additional-)firmware options, perhaps a subset, seem like a
> > (possibily) reasonable thing to force at the driver level.  But, on
> > the otherhand, the retry, delay and timer counts tend to be very
> > customer specific based on topology and storage.  Additionally, the
> > driver already exports via module parameters several of the more
> > important driver retry and timer counts, i.e. port_down_try_count,
> > link_down_timeout, retry_count (try modinfo for a full list).  A
> > user can use these facilities to perform any fine-tuning.
> 
> This sounds fine, though a little unwieldy.  You can't do much about
> the unwieldiness, though. 
> 

Yes, it's certainly looking so...

> > The driver still depend on the NVRAM to provide these values.  In
> > many cases, the standard NVRAM values programmed at manufacturing
> > time satisfy the majority of users.  Do you have boards that have
> > 'bogus' NVRAM settings, or are you just being cautious and not
> > depending on the end-user to not mess things up?
> 
> We don't use NVRAM settings on Irix.
> We do have a number of 2300-type boards which, for example, don't work
> in 2GB mode unless you bypass the NVRAM setting.
>

Hmm, is the NVRAM data-rate set to 1gb?

> There are also problems with using 1KB frames instead of 2KB frames.
> 
> How about a config option that bypasses the NVRAM.  That way, if one
> of your customers wants to use it to set different values, they can
> use NVRAM.  If others don't want to use NVRAM, then they won't.
> 

Perhaps our best route would be to provide a opensource tool to do
NVRAM updates (as Christoph suggested in an ealier email).  I'll see
what I can do to get that to happen.

Regards,
Andrew Vasquez

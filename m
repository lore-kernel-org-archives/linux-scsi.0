From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH 5/5: scsi-scan-inq-timeout
Date: Wed, 21 Apr 2004 16:49:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421164932.A21741@beaverton.ibm.com>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141456.GW28633@tpkurt.garloff.de> <20040421132454.A19685@beaverton.ibm.com> <20040421224843.GD643@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:17149 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263308AbUDUXtz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 19:49:55 -0400
Content-Disposition: inline
In-Reply-To: <20040421224843.GD643@tpkurt.garloff.de>; from garloff@suse.de on Thu, Apr 22, 2004 at 12:48:43AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Thu, Apr 22, 2004 at 12:48:43AM +0200, Kurt Garloff wrote:
> Hi Patrick,
> 
> On Wed, Apr 21, 2004 at 01:24:54PM -0700, Patrick Mansfield wrote:
> > SCSI_TIMEOUT is 2 * HZ.
> > 
> > So we defaulted to 6 seconds, and now we default to 5.5 seconds. Why?
> 
> True.
> 
> I have added half a second to be safe against 0.
> Thus, I had the choice of rounding 6 to 6.5 or 5.5.
> I chose 5.5, because the old value was chosen very conservative, as it
> had to be enough for even sick devices. Now we have a boot parameter
> to accomodate these, thus we can be less conservative. Thus 5.5.

I have no idea why 6 seconds was picked, but it has been there for so
long, it should remain as the default. If a user picks 0, then too bad.
(It would be nice if there was some module_param with a range, so it could
never be set to 0, it looks like there is stuff in place for adding your
own types and your own "check" macro.)

> > Why not get rid of the HZ/2, and set scsi_inq_timeout = SCSI_TIMEOUT/HZ +
> > 4 so we default to 6 again?
> > 
> > So if a device needs at least N + .5 seconds then just set the
> > scsi_inq_timeout to N + 1.
> 
> Why do you dislike HZ/2. The number is computed by the compiler at
> compile time ...

It's not the HZ/2 I dislike, just the adjustment of the timeout value.

> > >  	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
> > >  			" code 0x%x\n", sreq->sr_result ?
> > > @@ -393,7 +400,7 @@ static void scsi_probe_lun(struct scsi_r
> > >  		memset(inq_result, 0, possible_inq_resp_len);
> > >  		scsi_wait_req(sreq, (void *) scsi_cmd,
> > >  			      (void *) inq_result,
> > > -			      possible_inq_resp_len, SCSI_TIMEOUT + 4 * HZ, 3);
> > > +			      possible_inq_resp_len, (1+scsi_inq_timeout)*(HZ/2), 3);
> > 
> > IMO just make the two timeouts the same and avoid any potential problems
> > (like some funky device always takes 4 seconds to reponsd to an INQUIRY).
> 
> It's really only the reset recivery time which makes us choose such long
> times. Otherwise SCSI_TIMEOUT would be _plenty_ of time to answer an 
> INQUIRY. An INQUIRY is easier: No medium access is needed, see SPC3.
> When this second INQUIRY is done, a first one has succeeded already, so 
> the recovery from the reset has happened already.

> Anyway, if you dislike it, I don't care much. If the first INQUIRY
> succeeded, it's very unlikely that the second one fails, so the timeout
> is even less important in real life.

It should be plenty of time, but you can't guarantee it, so it's better to
be cautious and just use the same timeout.

-- Patrick Mansfield

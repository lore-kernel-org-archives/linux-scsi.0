From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: 22 Jan 2004 12:50:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074793813.2149.32.camel@mulgrave>
References: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com>
		<4010034A.3040903@us.ibm.com> <1074792163.2149.12.camel@mulgrave>
	<4010096D.4030205@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52165 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266311AbUAVRvf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 12:51:35 -0500
In-Reply-To: <4010096D.4030205@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-22 at 12:33, Brian King wrote:
> I agree that this is a solution as well (requires more code), but
> then sysfs will show the device as a different device type, which
> I would think might be confusing.

Isn't there a volume manager type ... don't have access to the standards
at the moment, but I vaguely remember this.  That is essentially what
you're doing isn't it? discs that are part of an array?

> > The true solution to this issue looks to be more flexibility in the
> > binding process.  We did discuss this previously, certainly in a SAN
> > environment there are reasons for only actually binding (and allocating
> > resources to) devices you're interested in.
> 
> Who generally has this knowledge in your example? The LLDD? Would a
> LLDD host template function that gets called for each disk be more
> palatable?

This is definitely a TBD in the future item.  The idea is that some user
process does the binding, and would have a list of devices to identify
and ignore (or to identify and bind ignoring everything else).

It would benefit us if we begin to trigger hotplug events on FC storage
discovery.  Without zoning, we'd get may FC events that we simply
weren't interested in.  We could simply log the ID in a database, and if
the user says "I want that storage" then bring it in and bind it.  You
would be able to use the same mechanism in ipr to say "don't bind
here"..

James



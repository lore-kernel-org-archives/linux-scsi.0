From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Mon, 27 Oct 2003 12:06:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027120631.E4263@vienna.EGENERA.COM>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM> <20031027072733.A20720@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:17084 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S263306AbTJ0RIn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 12:08:43 -0500
Content-Disposition: inline
In-Reply-To: <20031027072733.A20720@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Oct 27, 2003 at 07:27:33AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org

Rumor has it that on Mon, Oct 27, 2003 at 07:27:33AM -0800 Patrick Mansfield said:
> Philip -
> 
> On Mon, Oct 27, 2003 at 09:16:55AM -0500, Philip R. Auld wrote:
> 
> > In my experience code page 0x83 by itself is not always enough. There 
> > are high-end devices that don't return the results correctly. This leads 
> > to false negatives (which are safer than false positives, of course, but 
> > make multipath useless). I think in all of these auto-mp detection schemes 
> > there needs to be some mechanism for dealing with the quirks of different 
> > machine types. In userspace it should not be hard to have a table of some 
> > kind to tell such programs how to compare the results. This can also depend 
> > on how the system is configured as well so that adds another level of 
> > complexity.
> 
> The above generally applies even without multi-path (i.e. for use with
> udev).

I haven't gotten to play with 2.6 yet, so I'm not sure exactly what udev does. 
However, as long as scsi_id generated the same value for udev it shouldn't 
be an issue for that. It's just got to match what it found last time 
it booted to make sure it names the device node the same way, right?

Which leads to a question about how this works with udev. If it gets the same 
value for multiple paths to a devive won't udev them make a single device node?

> 
> The scsi_id program is setup to have a callout program, I did not complete
> coding it, mainly because I do not have any devices that require a
> callout.
> 
> And, It is not clear if the specific code called should be a separate
> program or a new function. A separate program can be released independent
> of scsi_id, but that means we will need common or duplicated code: mainly
> for the sg_io usage, and decoding of the result, especially the sense
> data.
> 

A separate program that is called based on the config file makes sense to me. 
It could then be independent as you say. A small general purpose dynamic sg_io 
library could remove the code duplication. 


> There is a /etc/scsi_id.config file, where devices can be optionally black
> or white listed, and callout programs can be specified. This is all done
> based on the vendor and optionally model (product) of the scsi device.
> 

That sounds good.

Cheers,

Phil


-- 
Philip R. Auld, Ph.D.                  Technical Staff 
Egenera Corp.                        pauld@egenera.com
165 Forest St., Marlboro, MA 01752       (508)858-2600

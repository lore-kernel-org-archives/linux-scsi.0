From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Mon, 27 Oct 2003 07:27:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027072733.A20720@beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:49655 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263302AbTJ0P2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 10:28:39 -0500
Content-Disposition: inline
In-Reply-To: <20031027091655.B4263@vienna.EGENERA.COM>; from pauld@egenera.com on Mon, Oct 27, 2003 at 09:16:55AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org

Philip -

On Mon, Oct 27, 2003 at 09:16:55AM -0500, Philip R. Auld wrote:

> In my experience code page 0x83 by itself is not always enough. There 
> are high-end devices that don't return the results correctly. This leads 
> to false negatives (which are safer than false positives, of course, but 
> make multipath useless). I think in all of these auto-mp detection schemes 
> there needs to be some mechanism for dealing with the quirks of different 
> machine types. In userspace it should not be hard to have a table of some 
> kind to tell such programs how to compare the results. This can also depend 
> on how the system is configured as well so that adds another level of 
> complexity.

The above generally applies even without multi-path (i.e. for use with
udev).

The scsi_id program is setup to have a callout program, I did not complete
coding it, mainly because I do not have any devices that require a
callout.

And, It is not clear if the specific code called should be a separate
program or a new function. A separate program can be released independent
of scsi_id, but that means we will need common or duplicated code: mainly
for the sg_io usage, and decoding of the result, especially the sense
data.

There is a /etc/scsi_id.config file, where devices can be optionally black
or white listed, and callout programs can be specified. This is all done
based on the vendor and optionally model (product) of the scsi device.

The config file can also be used to set global options.

-- Patrick Mansfield

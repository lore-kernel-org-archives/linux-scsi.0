From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace
	ioctl	for	sysfs	take 2
Date: 08 Sep 2004 10:53:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094655232.7222.69.camel@mulgrave>
References: <20040907210520.0251476C56@isis.visi.com>		<413E2440.8080509@cs.wisc.edu>	<1
	094592818.1716.159.camel@mulgrave>
		<413E2A17.80107@us.ibm.com>	<1094594715.1716.169.camel@mulgrave>
	<413E38DB.6040408@us.ibm.com> <1094600074.2401.234.camel@mulgrave>
	<413ECEAD.3050409@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26499 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268227AbUIHO4b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Sep 2004 10:56:31 -0400
In-Reply-To: <413ECEAD.3050409@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-09-08 at 05:19, Mike Christie wrote:
> I just meant that I am trying to get the iscsi transport class to have 
> common code across virtual and non virtual drivers. I was not striving 
> for virtual and non-virtual to alloc hosts alike. I was the one that 
> converted the iscsi driver to host per session and caused this mess :(

I'm not sure that's a good idea; virtual and physical drivers are very
different things and the transport classes may end up being different to
support their different needs.  I'd do the transport class for what you
have currently, which is a virtual driver, and when the physical one
comes along we'll see if it's possible to reuse pieces.  As long as the
code itself is nicely clean and modular this shouldn't be too hard; so
anywhere you're doing something that could easily be more generally
abstracted, do it.  Anywhere where an abstraction would be a contortion
of what you want to do, don't bother.

> The reason I kept asking below is becuase I misunderstood the resource 
> comment, and was unsure if I did the right thing and was supposed to 
> convert the driver back to a single host.

A host to the mid-layer is the place in which driver instance resources
are managed.  We expect to have things like an overall command limit per
host, and manage host and device blocking caused by resource issues.

For a physical iscsi driver, one host per card is easy and obvious; each
instance of the driver controlling a single card.  For a virtual iscsi
driver, the driver instances could be many things, but it seems logical
to me that your driver instances are per connection, thus you have one
host per iSCSI connection.  Its certainly possible to write a virtual
iSCSI driver where there's a single set of resources for everything, and
thus a single host, but I really don't think that would end up being a
very efficient driver.

James



From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Round II on sysfs attributes
Date: 23 May 2003 15:37:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053718657.1810.22.camel@mulgrave>
References: <1053707904.1810.4.camel@mulgrave>
	<20030523113003.A15369@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:60676 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264150AbTEWTYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 15:24:32 -0400
In-Reply-To: <20030523113003.A15369@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

On Fri, 2003-05-23 at 14:30, Patrick Mansfield wrote:
> On Fri, May 23, 2003 at 12:38:24PM -0400, James Bottomley wrote:
> > 
> > The attached patch makes the sysfs attributes a property of the host
> > template (I can't really see a reason why the actual attributes need to
> > change per host, so I think the template is the better place for them).
> > 
> > I've also provided helper functions to modify the attributes in the LLD
> > init routines.
> > 
> > An illustration of how this works for the 53c700 will follow.
> > 
> > James
> 
> Any examples of potential LLDD specific host attributes?

Certainly things like the firmware SEEPROM loading that aic7xxx does. 
Possibly global (or per host) resource counts for HBA's that have single
issue queue (again, aic7xxx; and even the 53c700 has this).

> Looks good for modifying attributes.
> 
> For additional attributes, why not an LLDD specific function to add and
> remove them?

That would require knowledge of what the "official" host attributes are,
so it seemed to me that leaving it up to the routine to determine
whether it's an addition or an override was more appropriate.  If we
have a separate routine for adds it would have to have an error case for
adding an existing resource...

James



From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 04 Nov 2008 21:10:56 -0500
Message-ID: <1225851056.14849.6.camel@localhost.localdomain>
References: <20081105013205.816CA108057@picon.linux-foundation.org>
	 <4910FD2C.5010907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50099 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbYKECLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 21:11:07 -0500
In-Reply-To: <4910FD2C.5010907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2008-11-04 at 19:55 -0600, Mike Christie wrote:
> bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11898
> > 
> > 
> > 
> > 
> > 
> > ------- Comment #9 from alex.shi@intel.com  2008-11-04 17:32 -------
> > I did bisect for this bug and find the following commit cause this problem.
> > 
> > commit f0c0a376d0fcd4c5579ecf5e95f88387cba85211
> > Author: Mike Christie <michaelc@cs.wisc.edu>
> 
> Ok, I am looking into this.

I have a theoretical case that might trigger an endless loop:

Supposing we actually get a two deep starved list.  On first pass, we
process the first entry, but set starved_head to be it.  On second pass,
we get a host_busy.  Now we will loop forever (because we have a single
entry sdev and it's not starved_head) under the host lock, which means
we can never unbusy the host.

A fix would be to set starved_head to NULL after we delete sdev from the
list.

James



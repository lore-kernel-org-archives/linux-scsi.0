From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: 05 Jun 2003 08:59:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054817958.1760.17.camel@mulgrave>
References: <1054742495.1674.18.camel@mulgrave>
	<20030604165146.GA1426@beaverton.ibm.com>
	<1054754103.2360.8.camel@mulgrave>  <20030604173413.A9632@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:53766 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264660AbTFEMqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 08:46:01 -0400
In-Reply-To: <20030604173413.A9632@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Wed, 2003-06-04 at 20:34, Patrick Mansfield wrote:
> I thought that USB sending a command after online cleared was likely the
> last prepped request being sent. This can't be fixed within scsi_prep_fn,
> since it will not be called for the last request after online is cleared.
> 
> So we might as well move all the checking of online into the
> scsi_request_fn.

Not unless there's agreement that prepared commands need killing.  To do
this in the simple fashion I outlined in the email (with the two
conditions), the prep function is the correct place for the check.

If the check is moved into the request function you have to worry about
freeing the allocated structures and terminating it yourself, which adds
unnecessary complexity.

Since the LLD knows it must handle commands until the slave_destroy, I
don't see a compelling reason to go to extraordinary lengths to prevent
it from seeing them.

James



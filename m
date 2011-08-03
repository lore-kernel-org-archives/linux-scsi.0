From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH] SCSI: Correct UA being ignored when notifying of
 media-changed
Date: Wed, 03 Aug 2011 17:36:39 -0500
Message-ID: <1312410999.2855.97.camel@mulgrave>
References: <1312378758-17308-1-git-send-email-revers@redhat.com>
	 <1312410128.2855.94.camel@mulgrave>  <4E39CC32.70305@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41645 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab1HCWgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2011 18:36:41 -0400
In-Reply-To: <4E39CC32.70305@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

On Wed, 2011-08-03 at 17:31 -0500, Mike Christie wrote:
> On 08/03/2011 05:22 PM, James Bottomley wrote:
> > On Wed, 2011-08-03 at 09:39 -0400, Rob Evers wrote:
> >> Unit attention commands are getting ignored when a dvd is
> >> replaced, resulting in errors when accessing the new dvd.
> >>
> >> This problem occurred when a system is booted in rescue
> >> mode via dvd and the dvd is then replaced with another dvd.
> >> Subsequent commands to a filesystem on the dvd, such as
> >> 'fsck' and 'restore' report errors.
> >>
> >> Solution suggested by Mike Christie.
> >>
> >> Signed-off-by: Rob Evers <revers@redhat.com>
> >> ---
> >>  drivers/scsi/scsi_error.c |    4 ++++
> >>  1 files changed, 4 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >> index a4b9cdb..725cc11 100644
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -294,6 +294,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
> >>  		 */
> >>  		if (scmd->device->expecting_cc_ua) {
> >>  			scmd->device->expecting_cc_ua = 0;
> >> +				if (sdev->removable) {
> >> +					sdev->changed = 1;
> >> +					return SUCCESS;
> >> +				}
> > 
> > Are you sure about this?  We only set expecting_cc_ua if the device was
> > reset in error handling ... and there we definitely *don't* want to
> > trigger a medium change.
> > 
> 
> What is happening is that we have a quirky device, and when you switch
> CD/DVDs the first command times out, so the scsi error handler runs.
> That is why the above code was modified. Before the patch the scsi layer
> would just retry the IO, and sr would not see the sense and so it would
> not detect the media changed. So the above code was meant to work like
> UA code in scsi_io_completion.

The SCSI standard requires all SCSI devices to return UA after a reset
(that's the reason for the code).  So, if I put this patch in, every
removable device would be flagged as having changed media if we go into
an error handling situation and reset it.  I don't think that's a good
idea to fix a single non-standard CD.

James



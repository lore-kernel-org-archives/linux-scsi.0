From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention
 conditions
Date: Tue, 17 Jul 2012 08:45:00 +0100
Message-ID: <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
	 <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
	 <50044D56.6000400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38675 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab2GQIBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 04:01:34 -0400
In-Reply-To: <50044D56.6000400@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 19:20 +0200, Paolo Bonzini wrote:
> Il 16/07/2012 18:18, James Bottomley ha scritto:
> >> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >> > index b583277..6d8ca08 100644
> >> > --- a/drivers/scsi/scsi_lib.c
> >> > +++ b/drivers/scsi/scsi_lib.c
> >> > @@ -843,8 +843,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> >> >  	} else if (sense_valid && !sense_deferred) {
> >> >  		switch (sshdr.sense_key) {
> >> >  		case UNIT_ATTENTION:
> >> > -			if (cmd->device->removable) {
> >> > -				/* Detected disc change.  Set a bit
> >> > +			if (cmd->device->removable &&
> >> > +			    (sshdr.asc == 0x3a ||
> >> > +			     (sshdr.asc == 0x28 && sshdr.ascq == 0x00))) {
> >> > +				/* "No medium" or "Medium may have changed."
> >> > +				 * This means a disc change.  Set a bit
> > This type of change would likely cause a huge cascade of errors in real
> > removable media devices.  Under the MMC standards, which a lot of the
> > older removable discs seem to follow, UNIT ATTENTION indicates either
> > medium change or device reset (which we check for and eat lower down);
> > we can't rely on them giving proper SBC-2 sense codes.  If you want to
> > pretend to be removable media, you have to conform to its standards.
> 
> Would you accept a patch doing the opposite, i.e. passing some sense
> codes such as PARAMETERS CHANGED and TARGET OPERATING CONDITIONS HAVE
> CHANGED?

Could you explain what the problem actually is?  It looks like you had a
reason to mark virtio-scsi as removable, even though it isn't, and now
you want to add further hacks because being removable doesn't quite
work.

Lets go back and see if there's a more correct way to do whatever it is
you want to do.

James



From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
Date: Mon, 16 Jul 2012 19:20:22 +0200
Message-ID: <50044D56.6000400@redhat.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com> <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47717 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2GPRU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2012 13:20:27 -0400
In-Reply-To: <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 16/07/2012 18:18, James Bottomley ha scritto:
>> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> > index b583277..6d8ca08 100644
>> > --- a/drivers/scsi/scsi_lib.c
>> > +++ b/drivers/scsi/scsi_lib.c
>> > @@ -843,8 +843,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>> >  	} else if (sense_valid && !sense_deferred) {
>> >  		switch (sshdr.sense_key) {
>> >  		case UNIT_ATTENTION:
>> > -			if (cmd->device->removable) {
>> > -				/* Detected disc change.  Set a bit
>> > +			if (cmd->device->removable &&
>> > +			    (sshdr.asc == 0x3a ||
>> > +			     (sshdr.asc == 0x28 && sshdr.ascq == 0x00))) {
>> > +				/* "No medium" or "Medium may have changed."
>> > +				 * This means a disc change.  Set a bit
> This type of change would likely cause a huge cascade of errors in real
> removable media devices.  Under the MMC standards, which a lot of the
> older removable discs seem to follow, UNIT ATTENTION indicates either
> medium change or device reset (which we check for and eat lower down);
> we can't rely on them giving proper SBC-2 sense codes.  If you want to
> pretend to be removable media, you have to conform to its standards.

Would you accept a patch doing the opposite, i.e. passing some sense
codes such as PARAMETERS CHANGED and TARGET OPERATING CONDITIONS HAVE
CHANGED?

Paolo

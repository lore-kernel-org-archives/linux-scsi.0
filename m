From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Overlapped command error handling
Date: Thu, 02 Feb 2006 09:12:27 -0600
Message-ID: <1138893147.3363.3.camel@mulgrave>
References: <43E20272.5000506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19606 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751124AbWBBPMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Feb 2006 10:12:31 -0500
In-Reply-To: <43E20272.5000506@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-02-02 at 14:00 +0100, Hannes Reinecke wrote:
> It looks to me as if the device has aborted _both_ commands when
> returning the 'overlapped commands attempted' sense.
> Is that conformant behaviour?
> 
> SCSI-2 states in section 7.5.2:
> A target that detects an incorrect initiator connection shall abort all
> I/O processes for the initiator on the logical unit or target routine
> and shall return CHECK CONDITION status. The sense key shall be set to
> ABORTED COMMAND and the additional sense code shall be set to OVERLAPPED
> COMMANDS ATTEMPTED.

Actually, I think it's probably complaining about tag reuse in the sense
of SAM-3 section 5.9.3.  You return this sense if an initiator attempts
to use a duplicate tag.  Since the aic79xx manges its own tags, then
it's probably a driver error.  You could verify this by having the
aic79xx print out the tag as it sends the command out on the wire.  (The
device does support TCQ, doesn't it?)

James



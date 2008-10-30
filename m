From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch]liberal acceptance of 0x28 asc in sd.c
Date: Thu, 30 Oct 2008 09:01:13 -0500
Message-ID: <1225375273.3250.9.camel@localhost.localdomain>
References: <200810301309.41705.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47025 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755206AbYJ3OBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 10:01:15 -0400
In-Reply-To: <200810301309.41705.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-10-30 at 13:09 +0100, Oliver Neukum wrote:
> >From reading the SCSI spec it seems that having the valid bit 0 (0x70
> checked in scsi_sense_valid) should does not invalidate the ASC or ASQ.
> [See page 37 of spc4r02.pdf].

That's a correct reading of the spec as regards the valid bit for non
descriptor sense data, but not applicable to this situation. sense_valid
is generated from (byte[0] & 0x70 == 0x70) (see scsi_sense_valid() in
include/scsi/scsi_eh.h) not from the valid bit.  This test is *required*
by the standard otherwise what we have isn't sense data.

>   It should only invalidate the INFORMATION
> field. Therefore remove the sense_valid check from the USB quirk.
> 
> This is needed for a strange USB storage device.

Could you elaborate a bit more?  What's its problem (and what is it
replying as byte 0 to a REQUEST_SENSE)?

Also:

> Signed-off-by: Brandon Philips <bphilips@suse.de>
> Signed-off-by: Oliver Neukum <oneukum@suse.de>

These signoffs don't make sense for what you sent ... this implies that
its Brandon's patch which you altered, in which case it needs a From: at
the beginning to make him the author.

James



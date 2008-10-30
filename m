From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [patch]liberal acceptance of 0x28 asc in sd.c
Date: Thu, 30 Oct 2008 15:23:13 +0100
Message-ID: <200810301523.13569.oliver@neukum.org>
References: <200810301309.41705.oliver@neukum.org> <1225375273.3250.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:43945 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYJ3OXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 10:23:12 -0400
In-Reply-To: <1225375273.3250.9.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Am Donnerstag, 30. Oktober 2008 15:01:13 schrieb James Bottomley:
> On Thu, 2008-10-30 at 13:09 +0100, Oliver Neukum wrote:
> > >From reading the SCSI spec it seems that having the valid bit 0 (0x70
> > checked in scsi_sense_valid) should does not invalidate the ASC or ASQ.
> > [See page 37 of spc4r02.pdf].
> 
> That's a correct reading of the spec as regards the valid bit for non
> descriptor sense data, but not applicable to this situation. sense_valid
> is generated from (byte[0] & 0x70 == 0x70) (see scsi_sense_valid() in
> include/scsi/scsi_eh.h) not from the valid bit.  This test is *required*
> by the standard otherwise what we have isn't sense data.
> 
> >   It should only invalidate the INFORMATION
> > field. Therefore remove the sense_valid check from the USB quirk.
> > 
> > This is needed for a strange USB storage device.
> 
> Could you elaborate a bit more?  What's its problem (and what is it
> replying as byte 0 to a REQUEST_SENSE)?

I got a report about a storage device that reports 0x28 and scsi_sense_valid()
returns false.

> > Signed-off-by: Brandon Philips <bphilips@suse.de>
> > Signed-off-by: Oliver Neukum <oneukum@suse.de>
> 
> These signoffs don't make sense for what you sent ... this implies that
> its Brandon's patch which you altered, in which case it needs a From: at
> the beginning to make him the author.

I wrote it.

	Regards
		Oliver

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Forcing use of sd driver on Suse 10.3 (2.6.22)
Date: Thu, 17 Jan 2008 09:40:21 -0600
Message-ID: <1200584422.3255.7.camel@localhost.localdomain>
References: <1200308514.4729.25.camel@desk.ty-rhos-barn>
	 <478BAA8E.7020703@s5r6.in-berlin.de>
	 <1200567191.5778.6.camel@desk.ty-rhos-barn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37590 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbYAQPkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 10:40:35 -0500
In-Reply-To: <1200567191.5778.6.camel@desk.ty-rhos-barn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Adair <adair@gotadsl.co.uk>
Cc: linux-scsi@vger.kernel.org


On Thu, 2008-01-17 at 10:53 +0000, Bill Adair wrote:
> On Mon, 2008-01-14 at 19:31 +0100, Stefan Richter wrote:
> > Bill Adair wrote:
> > > Is there any way under Linux of forcing use of the sd driver for a
> > > device on the bus instead of sg?
> > 
> > The INQUIRY data which the SCSI core gets from the device have to
> > indicate that the device implements SBC or RBC (is of peripheral device
> > type 00h or 0Eh).
> I have altered the sd.c file by patching sd_probe to check for the
> particular unit I have and accepting pdt 03h (Processor) as a valid
> return and the unit works fine. 

That's a bit of a nasty.  We can't blindly attach sd to a processor
otherwise it will pick up all sorts of stuff its not supposed to bind to
(like scanners, enclosure devices and other initiators).

I suppose a firmware upgrade for the device to make it actually comply
vaguely with the spec is out of the question?

If not, there's a trick we do in scsi_scan.c for Toshiba CDROMS that
fail to set their type correctly (it's the code under BLIST_ISROM), we
could do the same for this device.  What are its inquiry strings?  And
does anyone have any clue whether it should be RBC or DISK type?

> I suspect the sd file is considered very important though (and I don't
> know how many of these card readers exist) so I assume a patch is not
> required ;-). Would there be another approach to creating a "driver" for
> my Spyrus RD300 in it's guise as a card reader?

James



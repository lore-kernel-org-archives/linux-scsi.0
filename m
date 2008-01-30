From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Wed, 30 Jan 2008 08:38:35 -0600
Message-ID: <1201703915.3292.1.camel@localhost.localdomain>
References: <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk>
	 <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk>
	 <20080129183910.GI15220@kernel.dk>
	 <20080129191024.GO14375@one-eyed-alien.net>
	 <1201635195.3069.36.camel@localhost.localdomain>
	 <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk>
	 <Pine.LNX.4.64.0801301125350.26562@vixen.sonytel.be>
	 <20080130103803.GN15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34156 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbYA3Oiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 09:38:52 -0500
In-Reply-To: <20080130103803.GN15220@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-01-30 at 11:38 +0100, Jens Axboe wrote:
> On Wed, Jan 30 2008, Geert Uytterhoeven wrote:
> > On Tue, 29 Jan 2008, Jens Axboe wrote:
> > > On Tue, Jan 29 2008, Jens Axboe wrote:
> > > > On Tue, Jan 29 2008, James Bottomley wrote:
> > > > > On Tue, 2008-01-29 at 11:10 -0800, Matthew Dharm wrote:
> > > > > > For some reason, usb_sg_init is boned during auto-sense.
> > > > > 
> > > > > OK, that's implicating the scsi_eh_prep_cmnd() in the auto sense
> > > > > code ... that was also an update in 2.6.24
> > > > 
> > > > yeah, already found the bug - it's assuming ->request_buffer holds the
> > > > sglist, oops. Preparing a fix.
> > > 
> > > ok here goes, this saves and restores the sg table correctly. it also
> > > fixes the usb bug for me.
> > 
> > I can confirm this patch fixes the errors I was seeing with current
> > linux-2.6.git for the USB memory card readers in a Dell TFT connected
> > to a PS3.
> 
> James, we need a fix for this pushed asap. So either we should merge the
> below now, or push the bidi patchset that also fixes this. It all
> depends on when you want to merge the bidi patches...

The SCSI patch set (including the bidirectional pieces) is waiting in
scsi-misc ... just for forms sake, could you confirm that it actually
fixes the problem and I'll push it.

James



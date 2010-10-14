From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
Date: Wed, 13 Oct 2010 20:34:37 -0400
Message-ID: <1287016477.10264.418.camel@mulgrave.site>
References: <1286977551.2969.22.camel@mulgrave.site>
	 <AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
	 <1287015899.10264.394.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0JNAep (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 20:34:45 -0400
In-Reply-To: <1287015899.10264.394.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2010-10-13 at 20:24 -0400, James Bottomley wrote:
> On Wed, 2010-10-13 at 16:49 -0700, Linus Torvalds wrote:
> > On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
> > <James.Bottomley@suse.de> wrote:
> > > This patch set fixes a couple of longstanding bugs in SCSI.  The VPD
> > > patch fix a possible buffer overrun in the VPD code (only tripped if the
> > > device has a huge number of VPD pages).  The other is where the status
> > > return code on our BSG interface is wrongly right shifted one place.
> > 
> > Umm. That other patch seems to be utter crap.
> > 
> > > -       hdr->device_status = status_byte(rq->errors);
> > > +       hdr->device_status = rq->errors && 0xff;
> > 
> > That's pure shit. Please look at it for one second, and don't send me
> > crap like this.
> 
> What's wrong with it? device_status() is an ancient SCSI-1 macro that
> dates from the time the status was left shifted by 1, which makes the
> value wrong according to the sg interface spec.  We should really remove
> it, but there's still a few ancient drivers using it.  the SG interface
> requires the full status byte, which is what the bottom most byte of
> req_errors is ... hence the change.

OK, right ... several people pointed out in private email that it was &&
not & ... I'll fix it when I'm slightly less jet lagged.

James



From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as355) Fix test for valid sense data present
Date: Thu, 26 Aug 2004 12:59:31 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408261244430.1089-100000@ida.rowland.org>
References: <1093536566.2326.61.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:29444 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269232AbUHZRAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 13:00:18 -0400
In-Reply-To: <1093536566.2326.61.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 26 Aug 2004, James Bottomley wrote:

> Well, it doesn't look quite right.
> 
> You haven't modified the SCSI_SENSE_VALID() macro, so DRIVER_SENSE
> doesn't get set for the extra conditions you're checking for.

I admit that all the ramifications aren't clear to me.  However, the
SCSI_SENSE_VALID macro already masks with 0x70.  The places the patch
changed were masking with 0x7f.  How come two different masks are being 
used in various places?

> Even if you do fix it, You'll cause us to treat deferred sense
> conditions as errors, which would be wrong.
> 
> What's the actual problem you're trying to fix?

No problems have come up in actual use.  I wrote the patch in response to 
the message below, from Douglas Gilbert (this was part of an interchange 
commenting on some proposed additions to the 
Documentation/scsi/scsi_mid_low_api.txt document -- see the section 
about Autosense).  Was he incorrect?

Alan Stern


-------------------------------------------------------------------------

> This looks quite good.  Only a few things struck me:
> 
> 	The test given for valid data in the sense_buffer isn't correct.
> 	The actual test used is ((cmd->sense_buffer[0] & 0x7f) == 0x70).
> 	This is mentioned in a couple of places in the document.

If that comparison is in linux code then the comparison
is wrong! The comparison that is correct is bits 4, 5 and 6
all being set. So we don't care about bit 7 and the bottom
two bits can be 0x0, 0x1, 0x2 or 0x3. The fact that linux
can't handle sense buffer "descriptor" format is an issue
that needs to be addressed soon (but is unlikely to be an
issue for usb-storage devices for some time).


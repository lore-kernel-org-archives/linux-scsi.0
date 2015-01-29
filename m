From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Thu, 29 Jan 2015 06:41:29 -0800
Message-ID: <1422542489.2091.2.camel@HansenPartnership.com>
References: <54C2390A.3000700@sandisk.com>
	 <20150123131249.GA8045@infradead.org> <54CA2EDF.7060405@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35715 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbbA2Olb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 09:41:31 -0500
In-Reply-To: <54CA2EDF.7060405@plexistor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2015-01-29 at 15:00 +0200, Boaz Harrosh wrote:
> On 01/23/2015 03:12 PM, Christoph Hellwig wrote:
> > On Fri, Jan 23, 2015 at 01:05:30PM +0100, Bart Van Assche wrote:
> >> There is some confusion in the SCSI core and in SCSI LLDs around the
> >> meaning of sc_data_direction and whether or not this member can have the
> >> value DMA_BIDIRECTIONAL. Clear up this confusion. The patches in this
> >> series are:
> > 
> > I wonder if we should change the code to set DMA_BIDIRECTIONAL for
> > bidi commands.  That seems a lot more logical than the current
> > version.
> > 
> 
> You cannot do this. Because a Bidi Command is actually two commands
> one for the WRITE side (DMA_TO_DEVICE) which is this one, and another
> command for the READ side (DMA_FROM_DEVICE).

You're not thinking about this the correct way.  DMA_BIDIRECTIONAL is a
DMA engine flag.  We use it in SCSI for historical reasons (mainly to
prevent a translation from the SCSI version).  Since it was never used,
most SCSI drivers have code to check and reject commands with it set.
For actual bidirectional commands, you have to check scsi_bidi_command()
and programme the DMA engine separately for both phases, so the flag is
useless in this case.

The proposal is to make it the signal for bidirectional commands (in
which case most HBAs would make it do the right thing; i.e. reject) but
it still wouldn't be how you'd program the DMA enigne; that still would
have to be done in two phases as it is today.

James



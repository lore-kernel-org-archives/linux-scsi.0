From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as355) Fix test for valid sense data present
Date: Thu, 26 Aug 2004 15:32:00 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408261528230.1089-100000@ida.rowland.org>
References: <1093541269.2326.148.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:44548 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269435AbUHZTcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 15:32:01 -0400
In-Reply-To: <1093541269.2326.148.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Regarding the question of whether to test for valid sense data by masking 
sense_buffer[0] against 0x70 or 0x7f (some places do it one way, some 
places do it the other):


On 26 Aug 2004, James Bottomley wrote:

> On Thu, 2004-08-26 at 12:59, Alan Stern wrote:
> > No problems have come up in actual use.  I wrote the patch in response to 
> > the message below, from Douglas Gilbert (this was part of an interchange 
> > commenting on some proposed additions to the 
> > Documentation/scsi/scsi_mid_low_api.txt document -- see the section 
> > about Autosense).  Was he incorrect?
> 
> I suspect that's because you've never seen any of the new types in
> practice.
> 
> 0x70 is really the only sense type we process correctly: Fixed Format. 
> 0x72 is the newer Descriptor Format.  0x71 and 0x73 are the Fixed and
> Descriptor format deferred sense conditions.
> 
> We really only get deferred errors if the device has a cache that is set
> to writeback, so we just hope never to see them...
> 
> I thought Doug had a proposal for unifying our view of Fixed vs
> Descriptor sense formats?

I have no idea.  My only intention was to bring the matter to the
attention of people who understand the issues better than I do.  Maybe
Doug can comment on this.

Alan Stern


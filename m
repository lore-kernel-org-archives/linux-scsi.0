From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH: (as355) Fix test for valid sense data present
Date: 26 Aug 2004 13:27:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093541269.2326.148.camel@mulgrave>
References: <Pine.LNX.4.44L0.0408261244430.1089-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30146 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269288AbUHZRc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 13:32:57 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408261244430.1089-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2004-08-26 at 12:59, Alan Stern wrote:
> No problems have come up in actual use.  I wrote the patch in response to 
> the message below, from Douglas Gilbert (this was part of an interchange 
> commenting on some proposed additions to the 
> Documentation/scsi/scsi_mid_low_api.txt document -- see the section 
> about Autosense).  Was he incorrect?

I suspect that's because you've never seen any of the new types in
practice.

0x70 is really the only sense type we process correctly: Fixed Format. 
0x72 is the newer Descriptor Format.  0x71 and 0x73 are the Fixed and
Descriptor format deferred sense conditions.

We really only get deferred errors if the device has a cache that is set
to writeback, so we just hope never to see them...

I thought Doug had a proposal for unifying our view of Fixed vs
Descriptor sense formats?

James



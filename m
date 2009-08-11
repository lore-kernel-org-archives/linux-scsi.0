From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 11:24:47 -0500
Message-ID: <1250007887.4301.53.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0908111212010.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39758 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbZHKQYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 12:24:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908111212010.2562-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2009-08-11 at 12:14 -0400, Alan Stern wrote:
> On Tue, 11 Aug 2009, James Bottomley wrote:
> 
> > Sort of, but it's not really doing it properly.  Lets do it like this.
> > This should also fix the > 255 length problem older devices might have.
> 
> Do you mind including also the residue check?

But there's no point to it ... it's a Byzantine check.  The standard
says shall return as many bytes as will fit in the allocation length
(what it does with allocation length beyond data to return is
undefined).

For the USB case where a full residue and no error indicates there was
actually an error, we already have a translation.

If devices just return random data lengths and then stop, your proposed
residue check doesn't catch them anyway.  However, I'd much rather
assume a device performs to spec until proven otherwise.

James



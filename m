From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 09:55:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421095500.A17447@beaverton.ibm.com>
References: <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de> <20040421163336.A7382@infradead.org> <20040421160823.GK29699@tpkurt.garloff.de> <1082564314.1932.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:19187 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263457AbUDUQ4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:56:52 -0400
Content-Disposition: inline
In-Reply-To: <1082564314.1932.22.camel@mulgrave>; from James.Bottomley@SteelEye.com on Wed, Apr 21, 2004 at 11:18:30AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kurt Garloff <garloff@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Wed, Apr 21, 2004 at 11:18:30AM -0500, James Bottomley wrote:
> On Wed, 2004-04-21 at 11:08, Kurt Garloff wrote:
> > But unfortunately James prefers yet another approach, where we add
> > a inq_pq field to struct scsi_device ...
> > Patrick did not like it, if I parsed his mail correctly. 
> > So we've conflicting requirements.

Yes.

> > I'll wait for this to be sorted. If it's only used at one place
> > (bus_match), I believe parsing it directly from the inquiry data
> > is perfectly fine. The code dupl in UL drivers was not.

And yeh I agree.

> 
> Well, I'm happy to have the debate.
> 
> My principle is that inquiry data should be abstracted as much as
> possible on the grounds that it's the hottest piece of the standard in
> terms of everyone grabbing fields to indicate extra features.  I'd like
> problems caused by inquiry field changes to be confined to scsi_scan.c
> (so we have a single parsing routine for common inquiry fields.  The
> thing I can definitely see someone wanting to do is to overflow either
> the type or pq field).
> 
> There's logic to parsing data where it's needed, but it makes it
> difficult to locate all the places when it changes...

So add a macro or inline function to parse the data, like a sdev_pq(sdev),
then we have one location for the parsing, and don't have to duplicate the
data. And if sdev->inquiry changes or goes away we need only change
sdev_pq().

-- Patrick Mansfield

From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Thu, 22 Apr 2004 13:39:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422133912.A31488@beaverton.ibm.com>
References: <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de> <20040421163336.A7382@infradead.org> <20040421160823.GK29699@tpkurt.garloff.de> <1082564314.1932.22.camel@mulgrave> <20040421095500.A17447@beaverton.ibm.com> <20040421225137.GE643@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:14268 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264667AbUDVUjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 16:39:52 -0400
Content-Disposition: inline
In-Reply-To: <20040421225137.GE643@tpkurt.garloff.de>; from garloff@suse.de on Thu, Apr 22, 2004 at 12:51:37AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Thu, Apr 22, 2004 at 12:51:37AM +0200, Kurt Garloff wrote:
> On Wed, Apr 21, 2004 at 09:55:01AM -0700, Patrick Mansfield wrote:
> > On Wed, Apr 21, 2004 at 11:18:30AM -0500, James Bottomley wrote:
> > > There's logic to parsing data where it's needed, but it makes it
> > > difficult to locate all the places when it changes...
> > 
> > So add a macro or inline function to parse the data, like a sdev_pq(sdev),
> > then we have one location for the parsing, and don't have to duplicate the
> > data. And if sdev->inquiry changes or goes away we need only change
> > sdev_pq().
> 
> #define sdev_pg(sdev) ((sdev->inquiry[0] >> 5) & 7)
> 
> Just there is no scsi_scan.h where we could stick this.
> So either we have it at some non-obvious place or just once in
> scsi_sysfs.c. Or in scsi_scan.c and add one char to struct scsi_dev.
> I believe it's a very minor issue.

Yes, it's minor; James hasn't replied, and there aren't any other macros
like I'm suggesting, so go with the extra char.

-- Patrick Mansfield

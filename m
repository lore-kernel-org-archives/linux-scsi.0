From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 08:33:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421153316.GE9918@us.ibm.com>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:27364 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263372AbUDUQpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:45:53 -0400
Content-Disposition: inline
In-Reply-To: <20040421152436.GD29699@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

Kurt Garloff [garloff@suse.de] wrote:
> On Wed, Apr 21, 2004 at 04:02:58PM +0100, Christoph Hellwig wrote:
> > On Wed, Apr 21, 2004 at 04:14:17PM +0200, Kurt Garloff wrote:
> > > 
> > > Don't attach high level drivers (except sg) to devices with peripheral
> > > qualifier indicating not connected (1) or not capable (3).
> > > SPC3, 7.4.2.
> > 
> > Please don't duplicate it in every driver but in scsi_bus_match.  sg uses
> > a completely different attachment path so it shouldn't be affected by that.
> 
> Is it safe to assume it will stay like this?
> 

It should stay like this through 2.6. The driver model does not allow
multi-binding. Also all ULD are using the scsi_register_driver interface
which means prior to there probe routine scsi_bus_match is called.


-andmike
--
Michael Anderson
andmike@us.ibm.com


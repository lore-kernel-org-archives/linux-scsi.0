From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: 21 Apr 2004 11:18:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082564314.1932.22.camel@mulgrave>
References: <20040418185751.GC4868@tpkurt.garloff.de>
	<1082330192.1969.37.camel@mulgrave>
	<20040420115419.GG4356@tpkurt.garloff.de>
	<1082471881.1804.34.camel@mulgrave>
	<20040420160334.GO4356@tpkurt.garloff.de>
	<20040421134511.GP28633@tpkurt.garloff.de>
	<20040421141417.GV28633@tpkurt.garloff.de>
	<20040421160257.A6793@infradead.org>
	<20040421152436.GD29699@tpkurt.garloff.de>
	<20040421163336.A7382@infradead.org>
	<20040421160823.GK29699@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:18085 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263379AbUDUQSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:18:43 -0400
In-Reply-To: <20040421160823.GK29699@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>

On Wed, 2004-04-21 at 11:08, Kurt Garloff wrote:
> But unfortunately James prefers yet another approach, where we add
> a inq_pq field to struct scsi_device ...
> Patrick did not like it, if I parsed his mail correctly. 
> So we've conflicting requirements.
> 
> I'll wait for this to be sorted. If it's only used at one place
> (bus_match), I believe parsing it directly from the inquiry data
> is perfectly fine. The code dupl in UL drivers was not.

Well, I'm happy to have the debate.

My principle is that inquiry data should be abstracted as much as
possible on the grounds that it's the hottest piece of the standard in
terms of everyone grabbing fields to indicate extra features.  I'd like
problems caused by inquiry field changes to be confined to scsi_scan.c
(so we have a single parsing routine for common inquiry fields.  The
thing I can definitely see someone wanting to do is to overflow either
the type or pq field).

There's logic to parsing data where it's needed, but it makes it
difficult to locate all the places when it changes...

James



From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Thu, 16 Sep 2010 19:25:06 -0400
Message-ID: <20100916232506.GA19476@infradead.org>
References: <1284666254.7280.54.camel@schen9-DESK>
 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
 <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
 <1284672287.26423.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0IPXZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 19:25:11 -0400
Content-Disposition: inline
In-Reply-To: <1284672287.26423.41.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Thu, Sep 16, 2010 at 05:24:47PM -0400, James Bottomley wrote:
> > into the drivers (similar to how it has been done with the BKL).
> > This would be a fairly mechanic mindless patch. Lots of typing,
> > but not really a lot of real code review needed.
> > 
> > Then next step the drivers who know they don't want it can remove it.
> 
> Yes, that's basically what Christoph did when he moved the lock out of
> the eh path.

And it is what we should do here as well.  I'm just wondering if we rely
on the fact that we hold the lock over the check for the device beeing
deleted and the queuecommand call.


From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
	SHT->queuecommand()
Date: Fri, 17 Sep 2010 09:20:22 +0200
Message-ID: <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org> <1284691571.26423.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:65064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0IQHRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 03:17:53 -0400
Content-Disposition: inline
In-Reply-To: <1284691571.26423.50.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

> So at least from where I stand, my object is to reduce the number of
> times we take and release the lock, which this doesn't do.  As I said
> before: we need to figure out the rest, which likely includes an atomic
> for the serial number (which is almost unused).  I think the check

If it's unused it should be removed, make optional.
Atomics are a scalability problem too and not much cheaper than spinlocks.

-Andi

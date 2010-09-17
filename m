From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
 SHT->queuecommand()
Date: Fri, 17 Sep 2010 08:13:12 -0400
Message-ID: <1284725592.26423.60.camel@mulgrave.site>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
	 <1284691571.26423.50.camel@mulgrave.site>
	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53539 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0IQMNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 08:13:30 -0400
In-Reply-To: <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On Fri, 2010-09-17 at 09:20 +0200, Andi Kleen wrote:
> > So at least from where I stand, my object is to reduce the number of
> > times we take and release the lock, which this doesn't do.  As I said
> > before: we need to figure out the rest, which likely includes an atomic
> > for the serial number (which is almost unused).  I think the check
> 
> If it's unused it should be removed, make optional.
> Atomics are a scalability problem too and not much cheaper than spinlocks.

I don't disagree with the idea of removing it, especially as it has so
few users, but replacing the host lock with an atomic here would still
vastly reduce the contention, which is the initial complaint.  The
contention occurs because the host lock is so widely used for other
things.  The way to reduce that contention is firstly to reduce the
length of code covered by the lock and also reduce the actual number of
places where the lock is taken.  Compared with host lock's current vast
footprint, and atomic here is tiny.

James



From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT] isci: remote_device state_handlers and base_object
	removal
Date: Wed, 4 May 2011 11:55:07 +0200
Message-ID: <20110504095507.GA30387@lst.de>
References: <1304441142.20102.12.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45114 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1EDJzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2011 05:55:08 -0400
Content-Disposition: inline
In-Reply-To: <1304441142.20102.12.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Christoph Hellwig <hch@lst.de>

In general this looks like the way to go.  The only think I'm not overly
happy wih is how the sci_base_object removal is handled.  In general it
shouldn't be replaced by untyped void pointers, by proper container_of
usage.  I guess for most instances it doesn't matter too much as the
different layers of structures for the same object are in the process of
beeing merged anyway, but it's fairly significant for the state machine.

All the enter/exit handler should be passed a struct sci_base_state_machine *,
and then use container_of to get at the containing structure, thus removing
the need for the state_machine_owner field in struct sci_base_state_machine.

And while you're at it _please_ remove all the utterly pointless kerneldoc
comments for the state enter/exit handlers.  


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Mon, 6 Apr 2015 23:17:11 -0700
Message-ID: <20150407061711.GA11081@infradead.org>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
 <20150330120823.GA20193@infradead.org>
 <1427871116.9176.240.camel@haakon3.risingtidesystems.com>
 <20150401070400.GA3431@infradead.org>
 <1427953047.9176.292.camel@haakon3.risingtidesystems.com>
 <20150402085607.GA31017@infradead.org>
 <1428008230.26668.20.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbDGGRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 02:17:15 -0400
Content-Disposition: inline
In-Reply-To: <1428008230.26668.20.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>

On Thu, Apr 02, 2015 at 01:57:10PM -0700, Nicholas A. Bellinger wrote:
> > mempools are for I/O path that make guaranteed progress.  While the
> > callers of core_enable_device_list_for_node are in the control path,
> > and not in a very deep callstack, fairly shallow below the configfs
> > interface.  This is not a use case for mempools, as there is no need
> > to guarantee progress in deep I/O callstacks.
> > 
> 
> I was more concerned about the creation of se_dev_entry for dynamically
> generated se_node_acl in the login path.
> 
> Having to back out everything upon se_dev_entry allocation failure is
> annoying.

But unless you specificly pre-create the number of entries that
core_dev_add_lun may create that's the only way to handle it.  mempool
rely on the fact the objects get freed to the mempool again to make
forward progress, which isn't the case for a lon-lived se_dev_entry
allocation.

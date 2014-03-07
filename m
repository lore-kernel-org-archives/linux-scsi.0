From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] target: Allocate se_luns only when used
Date: Fri, 7 Mar 2014 10:22:32 -0800
Message-ID: <20140307182232.GA5474@infradead.org>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
 <1394144131-31499-6-git-send-email-agrover@redhat.com>
 <20140307104114.GC14195@infradead.org>
 <531A0BF9.9040504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaCGSWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 13:22:33 -0500
Content-Disposition: inline
In-Reply-To: <531A0BF9.9040504@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Mar 07, 2014 at 10:12:09AM -0800, Andy Grover wrote:
> >I can't see how the synchronization can work without refcounting the lun
> >structure.  The lock just protectes the assignment, but you free it
> >right after.  What happens to how jsut dereferenced it under the lock
> >but then uses it outside (e.g. core_dev_add_initiator_node_lun_acl).
> 
> Well you're right, but this is one instance of a larger lio
> locking/refcounting hairball. This will be addressed in a separate
> patch series.

I don't think that's true. Before your series we might be accessing a
lun structure that was marked as not active just before, but now the
race becomes a genuine use after free.


From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 3 Dec 2003 16:57:58 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031203225758.947145DC7E@bambi.visi.com>
References: <yqujiskx3apj.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corb.mc.mpls.visi.com ([208.42.156.1]:10200 "EHLO
	corb.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S262074AbTLCW6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 17:58:05 -0500
In-Reply-To: <yqujiskx3apj.fsf@chaapala-lnx2.cisco.com> from Clay Haapala at
 "Dec 3, 2003 02:38:48 pm"
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Clay Haapala wrote:
> 
> In discussions around here it was pointed out that the driver should
> *not* retry on COMMAND ABORT situations, rather let the upper layers
> handle it.  A retry at the driver level might be outright incorrect in
> the case of tape devices, for instance.

Note that if you let the upper layers handle it, you'll get data loss
from the page cache if you ever reach the point where a buffer write
from the cache runs out of retries.  On a write failure, the block I/O
layer just marks the unwritten buffer !uptodate, making it look like
the disk has the most recent data for that buffer, when it fact that
memory page contains the most recent data which was never written out
to disk.

Somebody really needs to come up with a cache design that doesn't
silently discard unwritten data when block writes start failing.  All
of that gross retry logic in the iSCSI driver came about because it
was so easy to get hundreds of megabytes of data lost forever, and at
the time Cisco wanted a driver work-around instead of a kernel fix.

Linus argued there was nothing else the cache could do, and that the
layers below the cache should do more retries.  I'm still not
convinced that the cache design is good enough, since it can block
badly when the lower layers are changed to do lots of retries, but in
any case, the layers below the cache still aren't doing very many
retries.  This is especially problematic on network SCSI transports
like Fibre Channel and iSCSI, where network problems can cause all
sorts of failures not commonly seen with parallel SCSI, USB, or any
other direct-attached storage.  NFS gets around these issues by being
a filesystem instead of a block device, and having it's own caching
logic.

-- 
Scott M. Ferris,
sferris@acm.org 

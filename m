From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] target: Add target_submit_cmd_map_mem for SGL
 fabric memory passthrough
Date: Tue, 02 Oct 2012 13:49:46 -0700
Message-ID: <1349210986.28145.73.camel@haakon2.linux-iscsi.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
	 <1349162147-29098-2-git-send-email-nab@linux-iscsi.org>
	 <20121002151752.GA21786@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41881 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2JBUty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 16:49:54 -0400
In-Reply-To: <20121002151752.GA21786@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On Tue, 2012-10-02 at 11:17 -0400, Christoph Hellwig wrote:
> On Tue, Oct 02, 2012 at 07:15:44AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a new TARGET_SCF_MAP_MEM flag within __target_submit_cmd()
> > + a target_submit_cmd_map_mem() wrapper to pass pre-allocated SGL memory
> > using existing transport_generic_map_mem_to_cmd() logic into the generic
> > target submit I/O codepath.
> 
> Instead of requiring a flag we could simply check for the sglist_count
> to be non-zero instead of requiring multiple pieces of information to
> be in sync.
> 

Mmmm, fair point here.  In that case I'd rather rename
__target_submit_cmd() to target_submit_cmd_mapsgl(), and update the
target_submit_cmd() wrapper accordingly.

> I'd also be tempted to remove the wrappers and just expose what is
> __target_submit_cmd now to the drivers, but that can be done
> independently as a cleanup.
> 

<nod>, dropping the extra target_submit_cmd_map_mem bit + flag now.

Thanks hch!

--nab



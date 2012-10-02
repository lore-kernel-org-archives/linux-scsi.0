From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] target: Add target_submit_cmd_map_mem for SGL fabric
 memory passthrough
Date: Tue, 2 Oct 2012 11:17:52 -0400
Message-ID: <20121002151752.GA21786@infradead.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
 <1349162147-29098-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59882
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab2JBPRy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 11:17:54 -0400
Content-Disposition: inline
In-Reply-To: <1349162147-29098-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On Tue, Oct 02, 2012 at 07:15:44AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new TARGET_SCF_MAP_MEM flag within __target_submit_cmd()
> + a target_submit_cmd_map_mem() wrapper to pass pre-allocated SGL memory
> using existing transport_generic_map_mem_to_cmd() logic into the generic
> target submit I/O codepath.

Instead of requiring a flag we could simply check for the sglist_count
to be non-zero instead of requiring multiple pieces of information to
be in sync.

I'd also be tempted to remove the wrappers and just expose what is
__target_submit_cmd now to the drivers, but that can be done
independently as a cleanup.


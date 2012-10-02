From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] target: Add TARGET_SCF_MAP_CLEAR_MEM work-around for
 tcm_loop
Date: Tue, 2 Oct 2012 11:21:07 -0400
Message-ID: <20121002152107.GC21786@infradead.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
 <1349162147-29098-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59905
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab2JBPVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 11:21:08 -0400
Content-Disposition: inline
In-Reply-To: <1349162147-29098-4-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On Tue, Oct 02, 2012 at 07:15:46AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch carries forward a work-around from tcm_loop to target
> core code to explicitly clear control CDB READ paylods in order to
> avoid bugs in scsi-generic user-space code for INQUIRY that do not
> explicitly zero CDB payload memory.

I never understood why we'd limit this to loop.  As far as I can see
we can get the same issue using sg-passthrough ontop of vhost, and for
the other drivers we'd simply rely on the drivers zeroing the pages.

I'd be much happier if we'd just unconditionally do this for the control
plane commands, as the performance over head for those should be
negligible.

A good place would be to do it as part of transport_kmap_data_sg, after
adding a data direction flag to it so that we'll only do it for the from
device direction.


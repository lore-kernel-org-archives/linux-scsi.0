From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Add transport_handle_cdb_direct
	optimization
Date: Thu, 16 Jun 2011 21:22:56 +0200
Message-ID: <20110616192256.GA14124@lst.de>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org> <1307167290-24832-2-git-send-email-nab@linux-iscsi.org> <20110604140308.GB13359@lst.de> <4DFA55D6.8090101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59129 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1FPTW6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 15:22:58 -0400
Content-Disposition: inline
In-Reply-To: <4DFA55D6.8090101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jun 16, 2011 at 12:13:26PM -0700, Andy Grover wrote:
> I agree. Also, I don't think there should be a handle_cdb_direct because
> I think handle_cdb should call transport_generic_new_cmd, we don't need
> a "direct" version. transport_generic_new_cmd should be safe (or made
> safe) for calling from interrupt context. There's nothing in it that
> demands it be executed in the backstore thread's context, and doing so
> just incurs a two context switch latency penalty.

I think the whole target context/threading model needs a makeover. As
we need to switch to a usermode context for just about any operation
we should just declare that any fabrict module must call all entry points
from user context.  The fabric modules can trivially do that using the
concurrency managed workqueues if nessecary.  At that point the target core
can just go ahead by itself without bothering with context switches, and
just using another workqueue where it might need additional concurreny
(e.g. executing multiple task is parallel for the file backend)


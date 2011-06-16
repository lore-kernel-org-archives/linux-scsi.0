From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 1/2] target: Add transport_handle_cdb_direct	optimization
Date: Thu, 16 Jun 2011 15:29:30 -0700
Message-ID: <4DFA83CA.60600@redhat.com>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org> <1307167290-24832-2-git-send-email-nab@linux-iscsi.org> <20110604140308.GB13359@lst.de> <4DFA55D6.8090101@redhat.com> <20110616192256.GA14124@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab1FPW3h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 18:29:37 -0400
In-Reply-To: <20110616192256.GA14124@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/16/2011 12:22 PM, Christoph Hellwig wrote:
> On Thu, Jun 16, 2011 at 12:13:26PM -0700, Andy Grover wrote:
>> I agree. Also, I don't think there should be a handle_cdb_direct because
>> I think handle_cdb should call transport_generic_new_cmd, we don't need
>> a "direct" version. transport_generic_new_cmd should be safe (or made
>> safe) for calling from interrupt context. There's nothing in it that
>> demands it be executed in the backstore thread's context, and doing so
>> just incurs a two context switch latency penalty.
> 
> I think the whole target context/threading model needs a makeover. As
> we need to switch to a usermode context for just about any operation
> we should just declare that any fabrict module must call all entry points
> from user context.  The fabric modules can trivially do that using the
> concurrency managed workqueues if nessecary.  At that point the target core
> can just go ahead by itself without bothering with context switches, and
> just using another workqueue where it might need additional concurreny
> (e.g. executing multiple task is parallel for the file backend)

I don't think we should be making it easy on the core, I think we should
be making it easy on the *fabrics*, if for no other reason that there
are >1 of them, but only one core. Less code duplicated.

Furthermore, many commands can be handled and generate a response
without submitting a read/write request to the backstores, which is the
only part that may need to sleep. If we decide all fabric calls to the
core must be from a thread, then all fabrics that could've gotten a
response to a command without context switching would then be the ones
taking unneeded context switches.

It's not clear to me yet what the barriers to fabrics calling core APIs
from interrupt are at this point. Do we just need to avoid GFP_KERNEL
allocs? The architecture as-is may be pretty close to doing this, and
then we'd be close to a reasonable framework.

Regards -- Andy
